unit u_MapLayerShowError;

interface

uses
  Windows,
  GR32,
  GR32_Image,
  u_MapViewPortState,
  UMapType,
  u_MapLayerBasic;

type
  TTileErrorInfoLayer = class(TMapLayerFixedWithBitmap)
  protected
    FHideAfterTime: Cardinal;
    FBitmapSize: TPoint;
    FZoom: Byte;
    function GetBitmapSizeInPixel: TPoint; override;
    procedure RenderText(AMapType: TMapType; AText: string);
    procedure DoUpdateLayerLocation; override;
  public
    constructor Create(AParentMap: TImage32; AViewPortState: TMapViewPortState);
    procedure ShowError(ATile: TPoint; AZoom: Byte; AMapType: TMapType; AText: string);
  end;

implementation

uses
  Graphics,
  Types,
  Ugeofun,
  u_WindowLayerBasic;


{ TTileErrorInfoLayer }

constructor TTileErrorInfoLayer.Create(AParentMap: TImage32;
  AViewPortState: TMapViewPortState);
begin
  inherited;
  FBitmapSize.X := 256;
  FBitmapSize.Y := 100;
  FFixedOnBitmap.X := FBitmapSize.X / 2;
  FFixedOnBitmap.Y := FBitmapSize.Y / 2;
end;

//procedure TTileErrorInfoLayer.DoRedraw;
//var
//  VCurrTime: Cardinal;
//  VTilePixel: TPoint;
//begin
//  if FHideAfterTime <> 0 then begin
//    VCurrTime := GetTickCount;
//    if (VCurrTime < FHideAfterTime) then begin
//      if FZoom = FTileZoom then begin
//        VTilePixel := FMapType.GeoConvert.TilePos2PixelPos(FTilePos, FZoom);
//        VTilePixel := FMapType.GeoConvert.PixelPos2OtherMap(VTilePixel, FZoom, FGeoConvert);
//        if (abs(VTilePixel.X - FScreenCenterPos.X) < (1 shl 15)) and
//          (abs(VTilePixel.Y - FScreenCenterPos.Y) < (1 shl 15)) then
//        begin
//          inherited;
//          RenderText;
//        end else begin
//          Visible := False;
//        end;
//      end else begin
//        Visible := False;
//      end;
//    end else begin
//      Visible := False;
//    end;
//  end else begin
//    Visible := False;
//  end;
//end;
//
procedure TTileErrorInfoLayer.DoUpdateLayerLocation;
var
  VCurrTime: Cardinal;
begin
  if FHideAfterTime <> 0 then begin
    VCurrTime := GetTickCount;
    if (VCurrTime < FHideAfterTime) then begin
      if (VCurrTime < FHideAfterTime) then begin
        if FZoom = FVisualCoordConverter.GetZoom then begin
          inherited;
        end else begin
          Visible := False;
        end;
      end else begin
        Visible := False;
      end;
    end else begin
      Visible := False;
    end;
  end else begin
    Visible := False;
  end;
end;

function TTileErrorInfoLayer.GetBitmapSizeInPixel: TPoint;
begin
  Result := FBitmapSize;
end;

//function TTileErrorInfoLayer.GetScreenCenterInBitmapPixels: TPoint;
//var
//  VTileRect: TRect;
//  VTileCenter: TPoint;
//begin
//  if FTileZoom = FZoom then begin
//    VTileRect := FMapType.GeoConvert.TilePos2PixelRect(FTilePos, FZoom);
//    VTileCenter.X := VTileRect.Left + (VTileRect.Right - VTileRect.Left) div 2;
//    VTileCenter.Y := VTileRect.Top + (VTileRect.Bottom - VTileRect.Top) div 2;
//    VTileCenter := FMapType.GeoConvert.PixelPos2OtherMap(VTileCenter, FZoom, FGeoConvert);
//    Result := GetBitmapSizeInPixel;
//    Result.X := Result.X div 2 + (FScreenCenterPos.X - VTileCenter.X);
//    Result.Y := Result.Y div 2 + (FScreenCenterPos.Y - VTileCenter.Y);
//  end else begin
//    Result := Point(10000, 10000);
//  end;
//end;
//
procedure TTileErrorInfoLayer.RenderText(AMapType: TMapType; AText: string);
var
  VTextWidth: integer;
  VSize: TPoint;
begin
  VSize := GetBitmapSizeInPixel;
  FLayer.Bitmap.Clear(clBlack);
  if AMapType <> nil then begin
    VTextWidth := FLayer.Bitmap.TextWidth(AMapType.name);
    FLayer.Bitmap.RenderText((VSize.X - VTextWidth) div 2, VSize.Y div 4, AMapType.name, 0, clBlack32);

    VTextWidth := FLayer.Bitmap.TextWidth(AText);
    FLayer.Bitmap.RenderText((VSize.X - VTextWidth) div 2, (VSize.Y div 4) * 3, AText, 0, clBlack32);
  end else begin
    VTextWidth := FLayer.Bitmap.TextWidth(AText);
    FLayer.Bitmap.RenderText((VSize.X - VTextWidth) div 2, (VSize.Y div 2), AText, 0, clBlack32);
  end;
end;

procedure TTileErrorInfoLayer.ShowError(ATile: TPoint; AZoom: Byte; AMapType: TMapType; AText: string);
begin
  FHideAfterTime := GetTickCount + 10000;
  FZoom := AZoom;
  FFixedLonLat := RectCenter(FVisualCoordConverter.GetGeoConverter.TilePos2PixelRect(ATile, AZoom));
  RenderText(AMapType, AText);
  Visible := true;
  UpdateLayerLocation;
end;

end.
