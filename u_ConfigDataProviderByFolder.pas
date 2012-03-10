{******************************************************************************}
{* SAS.Planet (SAS.�������)                                                   *}
{* Copyright (C) 2007-2011, SAS.Planet development team.                      *}
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

unit u_ConfigDataProviderByFolder;

interface

uses
  Classes,
  i_StringListStatic,
  i_BinaryData,
  i_ConfigDataProvider;

type
  TConfigDataProviderByFolder = class(TInterfacedObject, IConfigDataProvider)
  private
    FSourceFolderName: string;
  protected
    function GetSubItem(const AIdent: string): IConfigDataProvider; virtual;
    function ReadBinary(const AIdent: string): IBinaryData; virtual;
    function ReadString(const AIdent: string; const ADefault: string): string; virtual;
    function ReadInteger(const AIdent: string; const ADefault: Longint): Longint; virtual;
    function ReadBool(const AIdent: string; const ADefault: Boolean): Boolean; virtual;
    function ReadDate(const AIdent: string; const ADefault: TDateTime): TDateTime; virtual;
    function ReadDateTime(const AIdent: string; const ADefault: TDateTime): TDateTime; virtual;
    function ReadFloat(const AIdent: string; const ADefault: Double): Double; virtual;
    function ReadTime(const AIdent: string; const ADefault: TDateTime): TDateTime; virtual;

    function ReadSubItemsList: IStringListStatic;
    function ReadValuesList: IStringListStatic;
  public
    constructor Create(AFolderName: string);
  end;

implementation

uses
  SysUtils,
  IniFiles,
  u_StringListStatic,
  u_BinaryDataByMemStream,
  u_ConfigDataProviderByIniFile;

{ TConfigDataProviderByFolder }

constructor TConfigDataProviderByFolder.Create(AFolderName: string);
begin
  FSourceFolderName := AFolderName;
end;

function TConfigDataProviderByFolder.GetSubItem(
  const AIdent: string): IConfigDataProvider;
var
  VExt: string;
  VIniFile: TMemIniFile;
  VIniStrings: TStringList;
  VIniStream: TMemoryStream;
begin
  Result := nil;
  VExt := UpperCase(ExtractFileExt(AIdent));
  if (VExt = '.INI') or (VExt = '.TXT') then begin
    VIniFile := TMemIniFile.Create('');
    try
      VIniStream := TMemoryStream.Create;
      try
        VIniStream.LoadFromFile(IncludeTrailingPathDelimiter(FSourceFolderName) + AIdent);
        VIniStream.Position := 0;
        VIniStrings := TStringList.Create;
        try
          VIniStrings.LoadFromStream(VIniStream);
          VIniFile.SetStrings(VIniStrings);
        finally
          VIniStrings.Free;
        end;
      finally
        VIniStream.Free;
      end;
    except
      VIniFile.Free;
      raise;
    end;
    Result := TConfigDataProviderByIniFile.Create(VIniFile);
  end;
end;

function TConfigDataProviderByFolder.ReadBinary(const AIdent: string): IBinaryData;
var
  VStream: TMemoryStream;
  VFileName: string;
begin
  Result := nil;
  VFileName := IncludeTrailingPathDelimiter(FSourceFolderName) + AIdent;
  if FileExists(VFileName) then begin
    VStream := TMemoryStream.Create;
    try
      VStream.LoadFromFile(VFileName);
    except
      VStream.Free;
      raise;
    end;
    Result := TBinaryDataByMemStream.CreateWithOwn(VStream);
  end;
end;

function TConfigDataProviderByFolder.ReadBool(const AIdent: string;
  const ADefault: Boolean): Boolean;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadDate(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadDateTime(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadFloat(const AIdent: string;
  const ADefault: Double): Double;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadInteger(const AIdent: string;
  const ADefault: Integer): Longint;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadString(const AIdent,
  ADefault: string): string;
var
  VExt: string;
  VStream: TMemoryStream;
  VFileName: string;
begin
  Result := '';
  if AIdent = '::FileName' then begin
    Result := FSourceFolderName;
  end else begin
    VExt := UpperCase(ExtractFileExt(AIdent));
    if (VExt = '.INI') or (VExt = '.HTML') or (VExt = '.TXT') then begin
      VFileName := IncludeTrailingPathDelimiter(FSourceFolderName) + AIdent;
      if FileExists(VFileName) then begin
        VStream := TMemoryStream.Create;
        try
          VStream.LoadFromFile(VFileName);
          SetLength(Result, VStream.Size);
          VStream.Position := 0;
          VStream.ReadBuffer(Result[1], VStream.Size);
        finally
          VStream.Free;
        end;
      end else begin
        Result := ADefault;
      end;
    end else begin
      Result := ADefault;
    end;
  end;
end;

function TConfigDataProviderByFolder.ReadSubItemsList: IStringListStatic;
var
  VList: TStringList;
  VExt: string;
  VFolder: string;
  SearchRec: TSearchRec;
begin
  VList := TStringList.Create;
  try
    VFolder := IncludeTrailingPathDelimiter(FSourceFolderName);
    if FindFirst(VFolder + '*', faAnyFile, SearchRec) = 0 then begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then begin
          continue;
        end;
        VExt := UpperCase(ExtractFileExt(SearchRec.Name));
        if (VExt = '.INI') or (VExt = '.TXT') then begin
          VList.Add(SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    end;
  except
    VList.Free;
    raise;
  end;
  Result := TStringListStatic.CreateWithOwn(VList);
end;

function TConfigDataProviderByFolder.ReadTime(const AIdent: string;
  const ADefault: TDateTime): TDateTime;
begin
  Result := ADefault;
end;

function TConfigDataProviderByFolder.ReadValuesList: IStringListStatic;
var
  VList: TStringList;
  VExt: string;
  VFolder: string;
  SearchRec: TSearchRec;
begin
  VList := TStringList.Create;
  try
    VFolder := IncludeTrailingPathDelimiter(FSourceFolderName);
    if FindFirst(VFolder + '*', faAnyFile, SearchRec) = 0 then begin
      repeat
        if (SearchRec.Attr and faDirectory) = faDirectory then begin
          continue;
        end;
        VExt := UpperCase(ExtractFileExt(SearchRec.Name));
        if (VExt <> '.INI') or (VExt = '.HTML') or (VExt = '.TXT') then begin
          VList.Add(SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    end;
  except
    VList.Free;
    raise;
  end;
  Result := TStringListStatic.CreateWithOwn(VList);
end;

end.
