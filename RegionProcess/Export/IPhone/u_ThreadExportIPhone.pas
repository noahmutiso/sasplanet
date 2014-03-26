{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2014, SAS.Planet development team.                      *}
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
{* http://sasgis.org                                                          *}
{* info@sasgis.org                                                            *}
{******************************************************************************}

unit u_ThreadExportIPhone;

interface

uses
  Windows,
  Types,
  SysUtils,
  Classes,
  SQLite3Handler,
  t_Bitmap32,
  t_GeoTypes,
  i_NotifierOperation,
  i_RegionProcessProgressInfo,
  i_BinaryData,
  i_Bitmap32StaticFactory,
  i_BitmapTileSaveLoad,
  i_BitmapLayerProvider,
  i_CoordConverterFactory,
  i_LocalCoordConverterFactorySimpe,
  i_GeometryProjectedFactory,
  i_CoordConverter,
  i_GeometryLonLat,
  u_ThreadExportAbstract;

type
  TExportTaskIPhone = record
    FFlag: Integer;
    FSaver: IBitmapTileSaver;
    FImageProvider: IBitmapLayerProvider;
  end;
  TExportTaskIPhoneArray = array of TExportTaskIPhone;

  TThreadExportIPhone = class(TThreadExportAbstract)
  private
    FBitmapFactory: IBitmap32StaticFactory;
    FTasks: TExportTaskIPhoneArray;
    FActiveMapIndex: integer;
    FNewFormat: Boolean;

    FIsReplace: boolean;
    FExportPath: string;
    //FSQLite3Lib: TALSqlite3Library;
    //FSqlite3: PSQLite3;
    FCoordConverterFactory: ICoordConverterFactory;
    FLocalConverterFactory: ILocalCoordConverterFactorySimpe;
    FProjectionFactory: IProjectionInfoFactory;
    FVectorGeometryProjectedFactory: IGeometryProjectedFactory;
    procedure WritePListFile(const AGeoConvert: ICoordConverter);
    procedure WriteTileToSQLite3(
      const ASQLite3DbHandler: PSQLite3DbHandler;
      const AXY: TPoint;
      AZoom: Integer;
      const AData: IBinaryData;
      AFlags: Integer
    );
  protected
    procedure ProcessRegion; override;
  public
    constructor Create(
      const AProgressInfo: IRegionProcessProgressInfoInternal;
      const ACoordConverterFactory: ICoordConverterFactory;
      const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
      const AProjectionFactory: IProjectionInfoFactory;
      const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
      const ABitmapFactory: IBitmap32StaticFactory;
      const APath: string;
      const APolygon: IGeometryLonLatMultiPolygon;
      const ATasks: TExportTaskIPhoneArray;
      const Azoomarr: TByteDynArray;
      AActiveMapIndex: Integer;
      AReplace: boolean;
      ANewFormat: Boolean
    );
    destructor Destroy; override;
  end;

implementation

uses
  GR32,
  ALString,
  c_CoordConverter,
  i_LocalCoordConverter,
  i_Bitmap32Static,
  u_GeoToStrFunc,
  u_ResStrings,
  i_GeometryProjected,
  i_TileIterator,
  u_GeoFunc,
  u_BitmapFunc,
  u_TileIteratorByPolygon;

constructor TThreadExportIPhone.Create(
  const AProgressInfo: IRegionProcessProgressInfoInternal;
  const ACoordConverterFactory: ICoordConverterFactory;
  const ALocalConverterFactory: ILocalCoordConverterFactorySimpe;
  const AProjectionFactory: IProjectionInfoFactory;
  const AVectorGeometryProjectedFactory: IGeometryProjectedFactory;
  const ABitmapFactory: IBitmap32StaticFactory;
  const APath: string;
  const APolygon: IGeometryLonLatMultiPolygon;
  const ATasks: TExportTaskIPhoneArray;
  const Azoomarr: TByteDynArray;
  AActiveMapIndex: Integer;
  AReplace: boolean;
  ANewFormat: Boolean
);
begin
  inherited Create(
    AProgressInfo,
    APolygon,
    Azoomarr,
    Self.ClassName
  );
  FCoordConverterFactory := ACoordConverterFactory;
  FLocalConverterFactory := ALocalConverterFactory;
  FProjectionFactory := AProjectionFactory;
  FBitmapFactory := ABitmapFactory;
  FVectorGeometryProjectedFactory := AVectorGeometryProjectedFactory;
  FExportPath := IncludeTrailingPathDelimiter(APath);
  ForceDirectories(FExportPath);
  FTasks := ATasks;
  FNewFormat := ANewFormat;
  FIsReplace := AReplace;
  FActiveMapIndex := AActiveMapIndex;
end;

destructor TThreadExportIPhone.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FTasks) - 1 do begin
    FTasks[i].FSaver := nil;
    FTasks[i].FImageProvider := nil;
  end;
  inherited;
end;

procedure TThreadExportIPhone.WriteTileToSQLite3(
  const ASQLite3DbHandler: PSQLite3DbHandler;
  const AXY: TPoint;
  AZoom: Integer;
  const AData: IBinaryData;
  AFlags: Integer
);
var
  s: AnsiString;
begin
  s := 'INSERT INTO Images (data,zoom,x,y,flags,length) VALUES ' +
    '(' +
    '?,' +
    '"' + ALIntToStr(AZoom) + '",' +
    '"' + ALIntToStr(AXY.X) + '",' +
    '"' + ALIntToStr(AXY.Y) + '",' +
    '"' + ALIntToStr(AFlags) + '",' +
    '"' + ALIntToStr(AData.Size) + '"' +
    ')';

  ASQLite3DbHandler^.ExecSQLWithBLOB(s, AData.Buffer, AData.Size);
end;

procedure TThreadExportIPhone.WritePListFile(const AGeoConvert: ICoordConverter);
var
  PList: Text;
  VLLCenter: TDoublePoint;
  VZoom: Integer;
begin
  VZoom := FZooms[0];
  VLLCenter := AGeoConvert.PixelPosFloat2LonLat(RectCenter(AGeoConvert.LonLatRect2PixelRectFloat(PolygLL.Bounds.Rect, VZoom)), VZoom);
  AssignFile(Plist, FExportPath + 'com.apple.Maps.plist');
  Rewrite(PList);
  Writeln(PList, '<plist>');
  Writeln(PList, '<dict>');
  Writeln(PList, '<key>LastViewMode</key>');
  if FActiveMapIndex >= 0 then begin
    Writeln(PList, '<integer>' + IntToStr(FActiveMapIndex) + '</integer>');
  end;
  Writeln(PList, '<key>LastViewedLatitude</key>');
  Writeln(PList, '<real>' + R2StrPoint(VLLCenter.y) + '</real>');
  Writeln(PList, '<key>LastViewedLongitude</key>');
  Writeln(PList, '<real>' + R2StrPoint(VLLCenter.x) + '</real>');
  Writeln(PList, '<key>LastViewedZoomScale</key>');
  Writeln(PList, '<real>' + inttostr(VZoom + 1) + '</real>');
  Writeln(PList, '</dict>');
  Writeln(PList, '</plist>');
  CloseFile(PList);
end;

procedure TThreadExportIPhone.ProcessRegion;
var
  VZoom: byte;
  i, j, xi, yi, hxyi, sizeim: integer;
  VGeoConvert: ICoordConverter;
  VTile: TPoint;
  VBitmapTile: IBitmap32Static;
  Vbmp32crop: TCustomBitmap32;
  VStaticBitmapCrop: IBitmap32Static;
  VDataToSave: IBinaryData;
  VTileIterators: array of ITileIterator;
  VTileIterator: ITileIterator;
  VDatabaseName: string;
  VProjectedPolygon: IGeometryProjectedMultiPolygon;
  VTilesToProcess: Int64;
  VTilesProcessed: Int64;
  VTileConverter: ILocalCoordConverter;
  VSQLite3DbHandler: TSQLite3DbHandler;
begin
  inherited;
  VGeoConvert := FCoordConverterFactory.GetCoordConverterByCode(CGoogleProjectionEPSG, CTileSplitQuadrate256x256);

  WritePListFile(VGeoConvert);

  if FNewFormat then begin
    hxyi := 2;
    sizeim := 128;
  end else begin
    hxyi := 4;
    sizeim := 64;
  end;

  Vbmp32crop := TCustomBitmap32.Create;
  try
    Vbmp32crop.Width := sizeim;
    Vbmp32crop.Height := sizeim;
    VTilesToProcess := 0;
    SetLength(VTileIterators, Length(FZooms));
    for i := 0 to Length(FZooms) - 1 do begin
      VZoom := FZooms[i];
      VProjectedPolygon :=
        FVectorGeometryProjectedFactory.CreateProjectedPolygonByLonLatPolygon(
          FProjectionFactory.GetByConverterAndZoom(VGeoConvert, VZoom),
          PolygLL
        );
      VTileIterators[i] := TTileIteratorByPolygon.Create(VProjectedPolygon);
      VTilesToProcess := VTilesToProcess + VTileIterators[i].TilesTotal * Length(FTasks);
    end;
    try
      ProgressInfo.SetCaption(SAS_STR_ExportTiles);
      ProgressInfo.SetFirstLine(
        SAS_STR_AllSaves + ' ' + inttostr(VTilesToProcess) + ' ' + SAS_STR_Files
      );
      VTilesProcessed := 0;
      ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);

      if VSQLite3DbHandler.Init then
      try
        VDatabaseName := FExportPath + 'MapTiles' + c_SQLite_Ext;
        if not FileExists(VDatabaseName) then begin
          FIsReplace := True;
        end;

        If FIsReplace then begin
          // ��������
          If FileExists(VDatabaseName) then begin
            DeleteFile(VDatabaseName);
          end;

          VSQLite3DbHandler.Open(VDatabaseName, SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE);
          //VSQLite3DbHandler.OpenW(VDatabaseName);

          VSQLite3DbHandler.ExecSQL('CREATE TABLE version(version int)');
          VSQLite3DbHandler.ExecSQL('CREATE TABLE images(zoom int, x int, y int, flags int, length int, data blob);');
          VSQLite3DbHandler.ExecSQL('CREATE INDEX index1 on images (zoom,x,y,flags)');
        end else begin
          // �� �������� - ������ ��������� � ����������
          VSQLite3DbHandler.Open(VDatabaseName, SQLITE_OPEN_READWRITE);
          //VSQLite3DbHandler.OpenW(VDatabaseName);
        end;

        // ��������� ��������� �����������
        VSQLite3DbHandler.ExecSQL('PRAGMA locking_mode=EXCLUSIVE');
        VSQLite3DbHandler.ExecSQL('PRAGMA cache_size=100000');
        VSQLite3DbHandler.ExecSQL('PRAGMA synchronous=OFF');

        If FIsReplace then begin
          if FNewFormat then begin
            VSQLite3DbHandler.ExecSQL('INSERT INTO version (version) VALUES ("5")');
          end else begin
            VSQLite3DbHandler.ExecSQL('INSERT INTO version (version) VALUES ("4")');
          end;
          VSQLite3DbHandler.ExecSQL('INSERT INTO version (version) VALUES ("0")');
        end;

        // ���������
        VSQLite3DbHandler.BeginTran;
        try
          for i := 0 to Length(FZooms) - 1 do begin
            VZoom := FZooms[i];
            VTileIterator := VTileIterators[i];
            while VTileIterator.Next(VTile) do begin
              if CancelNotifier.IsOperationCanceled(OperationID) then begin
                exit;
              end;
              VTileConverter := FLocalConverterFactory.CreateForTile(VTile, VZoom, VGeoConvert);
              for j := 0 to Length(FTasks) - 1 do begin
                VBitmapTile := FTasks[j].FImageProvider.GetBitmapRect(
                  OperationID,
                  CancelNotifier,
                  FLocalConverterFactory.CreateForTile(VTile, VZoom, VGeoConvert)
                );

                // ���� �� ������ � ��������
                if VBitmapTile <> nil then
                for xi := 0 to hxyi - 1 do
                for yi := 0 to hxyi - 1 do begin
                  Vbmp32crop.Clear;
                  BlockTransfer(
                    Vbmp32crop,
                    0,
                    0,
                    VBitmapTile,
                    bounds(sizeim * xi, sizeim * yi, sizeim, sizeim),
                    dmOpaque
                  );
                  VStaticBitmapCrop := FBitmapFactory.Build(
                    Point(sizeim, sizeim),
                    Vbmp32crop.Bits
                  );
                  VDataToSave := FTasks[j].FSaver.Save(VStaticBitmapCrop);
                  // ����� ���� � �� (��� ���������� �� 1)
                  WriteTileToSQLite3(
                    @VSQLite3DbHandler,
                    Point(VTile.X * hxyi + xi, VTile.Y * hxyi + yi),
                    VZoom + 1,
                    VDataToSave,
                    FTasks[j].FFlag
                  );
                end;
                // ������������ ���� ��������
                inc(VTilesProcessed);
                if ((VTilesToProcess < 100) and (VTilesProcessed mod 5 = 0)) or
                   ((VTilesToProcess >= 100) and (VTilesProcessed mod 50 = 0)) then begin
                  // � ����������
                  ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
                end;
                // �������� �������� �������
                if (VTilesProcessed mod 500 = 0) then begin
                  VSQLite3DbHandler.Commit;
                  VSQLite3DbHandler.BeginTran;
                end;
              end; { for }
            end; { while }
          end; { for }
        finally
          VSQLite3DbHandler.Commit;
        end;
        ProgressFormUpdateOnProgress(VTilesProcessed, VTilesToProcess);
      finally
        VSQLite3DbHandler.Close;
      end;
    finally
      for i := 0 to Length(VTileIterators) - 1 do begin
        VTileIterators[i] := nil;
      end;
      VTileIterators := nil;
    end;
  finally
    Vbmp32crop.Free;
  end;
end;

end.
