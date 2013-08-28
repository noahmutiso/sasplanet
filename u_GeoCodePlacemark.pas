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

unit u_GeoCodePlacemark;

interface

uses
  t_Hash,
  t_GeoTypes,
  i_Appearance,
  i_LonLatRect,
  i_HashFunction,
  i_VectorDataItemSimple,
  i_GeoCoder,
  u_BaseInterfacedObject;

type
  TGeoCodePlacemark = class(TBaseInterfacedObject, IGeoCodePlacemark, IVectorDataItemPoint, IVectorDataItemSimple)
  private
    FHash: THashValue;
    FLLRect: ILonLatRect;
    FAddress: string;
    FDesc: string;
    FFullDesc: string;
    FAccuracy: Integer;
  private
    function GetHash: THashValue;
    function GetAppearance: IAppearance;
    function GetPoint: TDoublePoint;
    function GetName: string;
    function GetDesc: string;
    function GetLLRect: ILonLatRect;
    function IsEqual(const AItem: IVectorDataItemSimple): Boolean;
    function GetGoToLonLat: TDoublePoint;
    function GetHintText: string;
    function GetInfoHTML: string;
    function GetInfoUrl: string;
    function GetInfoCaption: string;
  private
    function GetAccuracy: Integer;
  public
    constructor Create(
      const AHash: THashValue;
      const APoint: TDoublePoint;
      const AAddress: string;
      const ADesc: string;
      const AFullDesc: string;
      const AAccuracy: Integer
    );
  end;

  TGeoCodePlacemarkFactory = class(TBaseInterfacedObject, IGeoCodePlacemarkFactory)
  private
    FHashFunction: IHashFunction;
  private
    function Build(
      const APoint: TDoublePoint;
      const AAddress: string;
      const ADesc: string;
      const AFullDesc: string;
      const AAccuracy: Integer
    ): IGeoCodePlacemark;
  public
    constructor Create(
      const AHashFunction: IHashFunction
    );
  end;

implementation

uses
  SysUtils,
  u_LonLatRectByPoint;

{ TGeoCodePlacemark }

constructor TGeoCodePlacemark.Create(
  const AHash: THashValue;
  const APoint: TDoublePoint;
  const AAddress: string;
  const ADesc: string;
  const AFullDesc: string;
  const AAccuracy: Integer
);
begin
  inherited Create;
  FHash := AHash;
  FAddress := AAddress;
  FDesc := ADesc;
  FFullDesc := AFullDesc;
  FLLRect := TLonLatRectByPoint.Create(APoint);
  FAccuracy := AAccuracy;
end;

function TGeoCodePlacemark.GetAccuracy: Integer;
begin
  Result := FAccuracy;
end;

function TGeoCodePlacemark.GetAppearance: IAppearance;
begin
  Result := nil;
end;

function TGeoCodePlacemark.GetName: string;
begin
  Result := FAddress;
end;

function TGeoCodePlacemark.GetDesc: string;
begin
  Result := FDesc;
end;

function TGeoCodePlacemark.GetGoToLonLat: TDoublePoint;
begin
  Result := FLLRect.TopLeft;
end;

function TGeoCodePlacemark.GetHash: THashValue;
begin
  Result := FHash;
end;

function TGeoCodePlacemark.GetHintText: string;
begin
  Result := FDesc;
end;

function TGeoCodePlacemark.GetInfoCaption: string;
begin
  Result := FAddress;
end;

function TGeoCodePlacemark.GetInfoHTML: string;
begin
  Result := FFullDesc;
end;

function TGeoCodePlacemark.GetInfoUrl: string;
begin
  Result := '';
end;

function TGeoCodePlacemark.GetLLRect: ILonLatRect;
begin
  Result := FLLRect;
end;

function TGeoCodePlacemark.GetPoint: TDoublePoint;
begin
  Result := FLLRect.TopLeft;
end;

function TGeoCodePlacemark.IsEqual(const AItem: IVectorDataItemSimple): Boolean;
var
  VGeoCodePlacemark: IGeoCodePlacemark;
begin
  if not Assigned(AItem) then begin
    Result := False;
    Exit;
  end;
  if AItem = IVectorDataItemSimple(Self) then begin
    Result := True;
    Exit;
  end;
  if (FHash <> 0) and (AItem.Hash <> 0) and (FHash <> AItem.Hash) then begin
    Result := False;
    Exit;
  end;
  if FLLRect.IsEqual(AItem.LLRect) then begin
    Result := False;
    Exit;
  end;
  if Assigned(AItem.Appearance) then begin
    Result := False;
    Exit;
  end;
  if FAddress <> AItem.Name then begin
    Result := False;
    Exit;
  end;
  if FDesc <> AItem.Desc then begin
    Result := False;
    Exit;
  end;
  if not Supports(AItem, IGeoCodePlacemark, VGeoCodePlacemark) then begin
    Result := False;
    Exit;
  end;
  if FAccuracy <> VGeoCodePlacemark.GetAccuracy then begin
    Result := False;
    Exit;
  end;

  if FFullDesc <> VGeoCodePlacemark.GetInfoHTML then begin
    Result := False;
    Exit;
  end;

  Result := True;
end;

{ TGeoCodePlacemarkFactory }

constructor TGeoCodePlacemarkFactory.Create(const AHashFunction: IHashFunction);
begin
  inherited Create;
  FHashFunction := AHashFunction;
end;

function TGeoCodePlacemarkFactory.Build(
  const APoint: TDoublePoint;
  const AAddress, ADesc, AFullDesc: string;
  const AAccuracy: Integer
): IGeoCodePlacemark;
var
  VHash: THashValue;
begin
  VHash := FHashFunction.CalcHashByDoublePoint(APoint);
  FHashFunction.UpdateHashByString(VHash, AAddress);
  FHashFunction.UpdateHashByString(VHash, ADesc);
  FHashFunction.UpdateHashByString(VHash, AFullDesc);
  Result :=
    TGeoCodePlacemark.Create(
      VHash,
      APoint,
      AAddress,
      ADesc,
      AFullDesc,
      AAccuracy
    );
end;

end.
