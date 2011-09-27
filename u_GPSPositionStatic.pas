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

unit u_GPSPositionStatic;

interface

uses
  SysUtils,
  t_GeoTypes,
  i_GPS;

type
  TGPSPositionStatic = class(TInterfacedObject, IGPSPosition)
  private
    FPosition: TDoublePoint;
    FAltitude: Double;
    FSpeed_KMH: Double;
    FHeading: Double;
    FUTCDateTime: TDateTime;
    FLocalDateTime: TDateTime;
    FIsFix: Word;
    FHDOP: Double;
    FVDOP: Double;
    FPDOP: Double;
    FSatellites: IGPSSatellitesInView;
  protected
    function GetPosition: TDoublePoint; stdcall;
    function GetAltitude: Double; stdcall;
    function GetSpeed_KMH: Double; stdcall;
    function GetHeading: Double; stdcall;
    function GetUTCDateTime: TDateTime; stdcall;
    function GetLocalDateTime: TDateTime; stdcall;
    function GetIsFix: Word; stdcall;
    function GetHDOP: Double; stdcall;
    function GetVDOP: Double; stdcall;
    function GetPDOP: Double; stdcall;
    function GetSatellites: IGPSSatellitesInView; stdcall;
  public
    constructor Create(
      APosition: TDoublePoint;
      AAltitude: Double;
      ASpeed_KMH: Double;
      AHeading: Double;
      AUTCDateTime: TDateTime;
      ALocalDateTime: TDateTime;
      AIsFix: Word;
      AHDOP: Double;
      AVDOP: Double;
      APDOP: Double;
      ASatellites: IGPSSatellitesInView
    );
    destructor Destroy; override;
  end;

implementation

{ TGPSPosition }

constructor TGPSPositionStatic.Create(
  APosition: TDoublePoint; AAltitude, ASpeed_KMH, AHeading: Double;
  AUTCDateTime, ALocalDateTime: TDateTime; AIsFix: Word; AHDOP, AVDOP,
  APDOP: Double; ASatellites: IGPSSatellitesInView);
begin
  FPosition := APosition;
  FAltitude := AAltitude;
  FSpeed_KMH := ASpeed_KMH;
  FHeading := AHeading;
  FUTCDateTime := AUTCDateTime;
  FLocalDateTime := ALocalDateTime;
  FIsFix := AIsFix;
  FHDOP := AHDOP;
  FVDOP := AVDOP;
  FPDOP := APDOP;
  FSatellites := ASatellites;
end;

destructor TGPSPositionStatic.Destroy;
begin
  FSatellites := nil;
  inherited;
end;

function TGPSPositionStatic.GetAltitude: Double;
begin
  Result := FAltitude;
end;

function TGPSPositionStatic.GetHDOP: Double;
begin
  Result := FHDOP;
end;

function TGPSPositionStatic.GetHeading: Double;
begin
  Result := FHeading;
end;

function TGPSPositionStatic.GetIsFix: Word;
begin
  Result := FIsFix;
end;

function TGPSPositionStatic.GetLocalDateTime: TDateTime;
begin
  Result := FLocalDateTime;
end;

function TGPSPositionStatic.GetPDOP: Double;
begin
  Result := FPDOP;
end;

function TGPSPositionStatic.GetPosition: TDoublePoint;
begin
  Result := FPosition;
end;

function TGPSPositionStatic.GetSatellites: IGPSSatellitesInView;
begin
  Result := FSatellites;
end;

function TGPSPositionStatic.GetSpeed_KMH: Double;
begin
  Result := FSpeed_KMH;
end;

function TGPSPositionStatic.GetUTCDateTime: TDateTime;
begin
  Result := FUTCDateTime;
end;

function TGPSPositionStatic.GetVDOP: Double;
begin
  Result := FVDOP;
end;

end.
