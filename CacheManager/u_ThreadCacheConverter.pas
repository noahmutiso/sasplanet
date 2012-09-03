{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2012, SAS.Planet development team.                      *}
{* This program is free software: you can redistribute it and/or modify       *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* This program is distributed in the hope that it will be useful,            *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with this program.  If not, see <http://www.gnu.org/licenses/>.      *}
{*                                                                            *}
{* http://sasgis.ru                                                           *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_ThreadCacheConverter;

interface

uses
  Classes,
  i_NotifierOperation,
  i_NotifierTTLCheck,
  i_ContentTypeManager,
  i_TileFileNameParsersList,
  i_TileFileNameGeneratorsList,
  i_InternalPerformanceCounter,
  i_TileInfoBasic,
  i_TileStorage,
  i_CacheConverterProgressInfo,
  u_ThreadCacheManagerAbstract;

type
  TThreadCacheConverter = class(TThreadCacheManagerAbstract)
  private
    FOperationID: Integer;
    FCancelNotifier: INotifierOperation;
    FSourceTileStorage: ITileStorage;
    FDestTileStorage: ITileStorage;
    FSourceIgnoreTne: Boolean;
    FSourceRemoveTiles: Boolean;
    FDestOverwriteTiles: Boolean;
    FSourcePath: string;
    FGCList: INotifierTTLCheck;
    FContentTypeManager: IContentTypeManager;
    FPerfCounterList: IInternalPerformanceCounterList;
    FProgressInfo: ICacheConverterProgressInfo;
    function CreateSimpleTileStorage(
      const ACacheIdent: string;
      const ARootPath: string;
      const ADefExtention: string;
      const AFormatID: Byte;
      const AIsReadOnly: Boolean;
      const AAllowDelete: Boolean;
      const AAllowAdd: Boolean;
      const AAllowReplace: Boolean
    ): ITileStorage;

    function OnSourceTileStorageScan(
      const ATileInfo: TTileInfo
    ): Boolean;

  protected
    procedure Process; override;
  public
    constructor Create(
      const ACancelNotifier: INotifierOperation;
      const AOperationID: Integer;
      const ASourcePath: string;
      const ADestPath: string;
      const ADefExtention: string;
      const ASourceCacheFormatID: Byte;
      const ADestCacheFormatID: Byte;
      const ASourceIgnoreTne: Boolean;
      const ASourceRemoveTiles: Boolean;
      const ADestOverwriteTiles: Boolean;
      const AGCList: INotifierTTLCheck;
      const AContentTypeManager: IContentTypeManager;
      const APerfCounterList: IInternalPerformanceCounterList;
      const AProgressInfo: ICacheConverterProgressInfo
    );
  end;

implementation

uses
  SysUtils,
  c_CacheTypeCodes,
  i_PathConfig,
  i_CoordConverter,
  i_SimpleTileStorageConfig,
  u_SimpleTileStorageConfig,
  u_SimpleTileStorageConfigStatic,
  u_TileFileNameParsersSimpleList,
  u_TileFileNameGeneratorsSimpleList,
  u_CoordConverterMercatorOnSphere,
  u_PathConfig,
  u_TileStorageFileSystem,
  u_TileStorageBerkeleyDB,
  u_TileStorageGE;

{ TThreadCacheConverter }

constructor TThreadCacheConverter.Create(
  const ACancelNotifier: INotifierOperation;
  const AOperationID: Integer;
  const ASourcePath: string;
  const ADestPath: string;
  const ADefExtention: string;
  const ASourceCacheFormatID: Byte;
  const ADestCacheFormatID: Byte;
  const ASourceIgnoreTne: Boolean;
  const ASourceRemoveTiles: Boolean;
  const ADestOverwriteTiles: Boolean;
  const AGCList: INotifierTTLCheck;
  const AContentTypeManager: IContentTypeManager;
  const APerfCounterList: IInternalPerformanceCounterList;
  const AProgressInfo: ICacheConverterProgressInfo
);
var
  VDefExtention: string;
  VDotPos: Integer;
begin
  FCancelNotifier := ACancelNotifier;
  FOperationID := AOperationID;
  FSourceIgnoreTne := ASourceIgnoreTne;
  FSourceRemoveTiles := ASourceRemoveTiles;
  FDestOverwriteTiles := ADestOverwriteTiles;
  FSourcePath := ASourcePath;
  FGCList := AGCList;
  FContentTypeManager := AContentTypeManager;
  FPerfCounterList := APerfCounterList;
  FProgressInfo := AProgressInfo;

  VDotPos := Pos('.', ADefExtention);
  if VDotPos > 0 then begin
    VDefExtention := Copy(ADefExtention, VDotPos, Length(ADefExtention) - VDotPos + 1);
  end else begin
    VDefExtention := '.' + ADefExtention;
  end;

  FSourceTileStorage :=
    CreateSimpleTileStorage(
      'SourcePath',
      FSourcePath,
      VDefExtention,
      ASourceCacheFormatID,
      (not FSourceRemoveTiles),
      FSourceRemoveTiles,
      False,
      False
    );

  ForceDirectories(ADestPath);

  FDestTileStorage :=
    CreateSimpleTileStorage(
      'DestPath',
      ADestPath,
      VDefExtention,
      ADestCacheFormatID,
      False,
      True,
      True,
      True
    );

  inherited Create(FCancelNotifier, FOperationID, AnsiString(Self.ClassName));
end;

procedure TThreadCacheConverter.Process;
var
  VEnum: IEnumTileInfo;
  VTileInfo: TTileInfo;
begin
  VEnum := FSourceTileStorage.ScanTiles(FSourceIgnoreTne);
  while VEnum.Next(VTileInfo) do begin
    if FCancelNotifier.IsOperationCanceled(FOperationID) then begin
      Break;
    end;
    if not OnSourceTileStorageScan(VTileInfo) then begin
      Break;
    end;
    if FSourceRemoveTiles then begin
      if VTileInfo.FInfoType = titExists then begin
        FSourceTileStorage.DeleteTile(VTileInfo.FTile, VTileInfo.FZoom, VTileInfo.FVersionInfo);
      end else if VTileInfo.FInfoType = titTneExists then begin
        FSourceTileStorage.DeleteTNE(VTileInfo.FTile, VTileInfo.FZoom, VTileInfo.FVersionInfo);
      end;
    end;
  end;
  FProgressInfo.Finished := True;
end;

function TThreadCacheConverter.OnSourceTileStorageScan(
  const ATileInfo: TTileInfo
): Boolean;
var
  VTileInfo: ITileInfoBasic;
  VTileFullPath: string;
begin
  Result := False;
  if not FCancelNotifier.IsOperationCanceled(FOperationID) then begin

    if not FDestOverwriteTiles then begin
      VTileInfo :=
        FDestTileStorage.GetTileInfo(
          ATileInfo.FTile,
          ATileInfo.FZoom,
          ATileInfo.FVersionInfo,
          gtimAsIs
        );
      if (VTileInfo.IsExists or (VTileInfo.IsExistsTNE and (ATileInfo.FInfoType = titTneExists))) then begin
        Result := True;
        FProgressInfo.TilesSkipped := FProgressInfo.TilesSkipped + 1;
      end;
    end;

    if not Result then begin

      if ATileInfo.FInfoType = titExists then begin
        FDestTileStorage.SaveTile(
          ATileInfo.FTile,
          ATileInfo.FZoom,
          ATileInfo.FVersionInfo,
          ATileInfo.FData
        );
        Result := True;
      end else if ATileInfo.FInfoType = titTneExists then begin
        FDestTileStorage.SaveTNE(
          ATileInfo.FTile,
          ATileInfo.FZoom,
          ATileInfo.FVersionInfo
        );
        Result := True;
      end;

      if Result then begin
        FProgressInfo.TilesProcessed := FProgressInfo.TilesProcessed + 1;
        if Assigned(ATileInfo.FData) then begin
          FProgressInfo.TilesSize := FProgressInfo.TilesSize + ATileInfo.FData.Size;
        end;
      end;
    end;

    VTileFullPath :=
      FSourceTileStorage.GetTileFileName(
        ATileInfo.FTile,
        ATileInfo.FZoom,
        ATileInfo.FVersionInfo
      );

    FProgressInfo.LastTileName :=
      StringReplace(VTileFullPath, FSourcePath, '', [rfIgnoreCase]);
  end;
end;

function TThreadCacheConverter.CreateSimpleTileStorage(
  const ACacheIdent: string;
  const ARootPath: string;
  const ADefExtention: string;
  const AFormatID: Byte;
  const AIsReadOnly: Boolean;
  const AAllowDelete: Boolean;
  const AAllowAdd: Boolean;
  const AAllowReplace: Boolean
): ITileStorage;
var
  VIsStoreFileCache: Boolean;
  VStorageConfig: ISimpleTileStorageConfig;
  VStorageConfigStatic: ISimpleTileStorageConfigStatic;
  VBaseCachePath: IPathConfig;
  VTileNameGeneratorList: ITileFileNameGeneratorsList;
  VTileNameParserList: ITileFileNameParsersList;
  VCoordConverterFake: ICoordConverter;
begin
  VIsStoreFileCache :=
    (AFormatID <> c_File_Cache_Id_BDB) and
    (AFormatID <> c_File_Cache_Id_GE) and
    (AFormatID <> c_File_Cache_Id_GC);

  VCoordConverterFake := TCoordConverterMercatorOnSphere.Create(6378137);

  VStorageConfigStatic :=
    TSimpleTileStorageConfigStatic.Create(
      VCoordConverterFake,
      AFormatID,
      '',
      ADefExtention,
      VIsStoreFileCache,
      AIsReadOnly,
      AAllowDelete,
      AAllowAdd,
      AAllowReplace
    );

  VStorageConfig := TSimpleTileStorageConfig.Create(VStorageConfigStatic);

  VBaseCachePath := TPathConfig.Create(ACacheIdent, ARootPath, nil);

  VTileNameGeneratorList :=
    TTileFileNameGeneratorsSimpleList.Create;

  VTileNameParserList :=
    TTileFileNameParsersSimpleList.Create;

  if VStorageConfig.CacheTypeCode = c_File_Cache_Id_BDB then begin
//    Result :=
//      TTileStorageBerkeleyDB.Create(
//        FGCList,
//        VStorageConfig,
//        VGlobalCacheConfig,
//        False,
//        FContentTypeManager,
//        FPerfCounterList
//      );
  end else if VStorageConfig.CacheTypeCode = c_File_Cache_Id_GE then begin
//    Result :=
//      TTileStorageGE.Create(
//        VStorageConfig,
//        VGlobalCacheConfig,
//        FContentTypeManager
//      );
  end else if VStorageConfig.CacheTypeCode = c_File_Cache_Id_GC then begin
//    Result :=
//      TTileStorageGC.Create(
//        VStorageConfig,
//        VGlobalCacheConfig,
//        FContentTypeManager
//      );
  end else begin
//    Result :=
//      TTileStorageFileSystem.Create(
//        VStorageConfig,
//        VGlobalCacheConfig,
//        VTileNameGeneratorList,
//        VTileNameParserList,
//        FContentTypeManager,
//        FPerfCounterList
//      );
  end;
end;

end.
