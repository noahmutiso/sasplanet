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

unit u_MapMarksBitmapLayerProviderByMarksSubset;

interface

uses
  
  GR32,
  Graphics,
  WinTypes,
  t_GeoTypes,
  i_CoordConverter,
  i_LocalCoordConverter,
  i_OperationNotifier,
  i_MarksDrawConfig,
  i_MarkPicture,
  i_MarksSimple,
  i_DoublePointsAggregator,
  i_BitmapLayerProvider;

type
  TMapMarksBitmapLayerProviderByMarksSubset = class(TInterfacedObject, IBitmapLayerProvider)
  private
    FConfig: IMarksDrawConfigStatic;
    FMarksSubset: IMarksSubset;
    FBaseConverter: ILocalCoordConverter;


    FTempBmp: TCustomBitmap32;
    FBitmapWithText: TBitmap32;
    FPreparedPointsAggreagtor: IDoublePointsAggregator;
    FPathFixedPoints: TArrayOfFixedPoint;
    function DrawSubset(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier;
      AMarksSubset: IMarksSubset;
      ATargetBmp: TCustomBitmap32;
      ALocalConverter: ILocalCoordConverter
    ): Boolean;
    procedure DrawPath(
      ATargetBmp: TCustomBitmap32;
      ALocalConverter: ILocalCoordConverter;
      AMarkLine: IMarkLine
    );
    procedure DrawPoly(
      ATargetBmp: TCustomBitmap32;
      ALocalConverter: ILocalCoordConverter;
      AMarkPoly: IMarkPoly
    );
    procedure DrawPoint(
      ATargetBmp: TCustomBitmap32;
      ALocalConverter: ILocalCoordConverter;
      AMarkPoint: IMarkPoint
    );
  protected
    function GetBitmapRect(
      AOperationID: Integer;
      ACancelNotifier: IOperationNotifier;
      ATargetBmp: TCustomBitmap32;
      ALocalConverter: ILocalCoordConverter
    ): Boolean;
  public
    constructor Create(
      AConfig: IMarksDrawConfigStatic;
      ABaseConverter: ILocalCoordConverter;
      AMarksSubset: IMarksSubset
    );
    destructor Destroy; override;
  end;

implementation

uses
  Classes,
  ActiveX,
  SysUtils,
  GR32_Resamplers,
  GR32_Polygons,
  i_BitmapMarker,
  i_EnumDoublePoint,
  u_DoublePointsAggregator,
  u_EnumDoublePointsByArray,
  u_EnumDoublePointLonLatToMapPixel,
  u_EnumDoublePointMapPixelToLocalPixel,
  u_EnumDoublePointWithClip,
  u_EnumDoublePointFilterFirstPoly,
  u_EnumDoublePointFilterEqual,
  u_GeoFun;

const
  CMaxFontSize = 20;

{ TMapMarksBitmapLayerProviderByMarksSubset }

constructor TMapMarksBitmapLayerProviderByMarksSubset.Create(
  AConfig: IMarksDrawConfigStatic;
  ABaseConverter: ILocalCoordConverter;
  AMarksSubset: IMarksSubset
);
begin
  FConfig := AConfig;
  FBaseConverter := ABaseConverter;
  FMarksSubset := AMarksSubset;

  FTempBmp := TCustomBitmap32.Create;
  FTempBmp.DrawMode := dmBlend;
  FTempBmp.CombineMode := cmMerge;
  FTempBmp.Resampler := TLinearResampler.Create;

  FBitmapWithText := TBitmap32.Create;
  FBitmapWithText.Font.Name := 'Tahoma';
  FBitmapWithText.Font.Style := [];
  FBitmapWithText.DrawMode := dmBlend;
  FBitmapWithText.CombineMode := cmMerge;
  FBitmapWithText.Font.Size := CMaxFontSize;
  FBitmapWithText.Resampler := TLinearResampler.Create;

  FPreparedPointsAggreagtor := TDoublePointsAggregator.Create;
end;

destructor TMapMarksBitmapLayerProviderByMarksSubset.Destroy;
begin
  FPreparedPointsAggreagtor := nil;
  FreeAndNil(FTempBmp);
  FreeAndNil(FBitmapWithText);
  inherited;
end;

procedure TMapMarksBitmapLayerProviderByMarksSubset.DrawPath(
  ATargetBmp: TCustomBitmap32;
  ALocalConverter: ILocalCoordConverter;
  AMarkLine: IMarkLine
);
var
  VPolygon: TPolygon32;
  i: Integer;
  VPointsCount: Integer;
  VPointsProcessedCount: Integer;
  VIndex: Integer;
  VScale1: Integer;
  VTestArrLenLonLatRect: TDoubleRect;
  VTestArrLenPixelRect: TDoubleRect;
  VEnum: IEnumDoublePoint;
  VRectWithDelta: TDoubleRect;
  VLocalRect: TDoubleRect;
  VPoint: TDoublePoint;
begin
  VScale1 := AMarkLine.LineWidth;
  VTestArrLenLonLatRect := AMarkLine.LLRect;
  ALocalConverter.GetGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
  VTestArrLenPixelRect := ALocalConverter.LonLatRect2LocalRectFloat(VTestArrLenLonLatRect);
  if (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > VScale1 + 2) or (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > VScale1 + 2) then begin
    VPointsCount := Length(AMarkLine.Points);
    if VPointsCount > 0 then begin
      VLocalRect := DoubleRect(ALocalConverter.GetLocalRect);
      VRectWithDelta.Left := VLocalRect.Left - 10;
      VRectWithDelta.Top := VLocalRect.Top - 10;
      VRectWithDelta.Right := VLocalRect.Right + 10;
      VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
      VEnum :=
        TEnumDoublePointFilterEqual.Create(
          TEnumDoublePointClipByRect.Create(
            False,
            VRectWithDelta,
            TEnumDoublePointMapPixelToLocalPixel.Create(
              ALocalConverter,
              TEnumDoublePointFilterEqual.Create(
                TEnumDoublePointLonLatToMapPixel.Create(
                  ALocalConverter.GetZoom,
                  ALocalConverter.GetGeoConverter,
                  TEnumDoublePointsByArray.Create(
                    @(AMarkLine.Points[0]),
                    VPointsCount
                  )
                )
              )
            )
          )
        );
      FPreparedPointsAggreagtor.Clear;
      while VEnum.Next(VPoint) do begin
        FPreparedPointsAggreagtor.Add(VPoint);
      end;
      try
        VPointsProcessedCount := FPreparedPointsAggreagtor.Count;
        if VPointsProcessedCount > 0 then begin
          VPolygon := TPolygon32.Create;
          try
            VPolygon.Antialiased := true;
            VPolygon.AntialiasMode := am4times;
            VPolygon.Closed := False;
            if Length(FPathFixedPoints) < VPointsProcessedCount then begin
              SetLength(FPathFixedPoints, VPointsProcessedCount);
            end;
            VIndex := 0;
            for i := 0 to VPointsProcessedCount - 1 do begin
              VPoint := FPreparedPointsAggreagtor.Points[i];
              if PointIsEmpty(VPoint) then begin
                VPolygon.AddPoints(FPathFixedPoints[0], VIndex);
                VPolygon.NewLine;
                VIndex := 0;
              end else begin
                FPathFixedPoints[VIndex] := FixedPoint(VPoint.X, VPoint.Y);
                Inc(VIndex);
              end;
            end;
            VPolygon.AddPoints(FPathFixedPoints[0], VIndex);
            with VPolygon.Outline do try
              with Grow(GR32.Fixed(AMarkLine.LineWidth / 2), 0.5) do try
                FillMode := pfWinding;
                DrawFill(ATargetBmp, AMarkLine.LineColor);
              finally
                free;
              end;
            finally
              free;
            end;
          finally
            VPolygon.Free;
          end;
        end;
      except
      end;
    end;
  end;
end;

procedure TMapMarksBitmapLayerProviderByMarksSubset.DrawPoly(
  ATargetBmp: TCustomBitmap32;
  ALocalConverter: ILocalCoordConverter;
  AMarkPoly: IMarkPoly
);
var
  VPolygon: TPolygon32;
  i: Integer;
  VPointsCount: Integer;
  VPointsProcessedCount: Integer;
  VScale1: Integer;
  VTestArrLenLonLatRect: TDoubleRect;
  VTestArrLenPixelRect: TDoubleRect;
  VEnum: IEnumDoublePoint;
  VRectWithDelta: TDoubleRect;
  VLocalRect: TDoubleRect;
  VPoint: TDoublePoint;
begin
  VScale1 := AMarkPoly.LineWidth;
  VTestArrLenLonLatRect := AMarkPoly.LLRect;
  ALocalConverter.GetGeoConverter.CheckLonLatRect(VTestArrLenLonLatRect);
  VTestArrLenPixelRect := ALocalConverter.LonLatRect2LocalRectFloat(VTestArrLenLonLatRect);
  if (abs(VTestArrLenPixelRect.Left - VTestArrLenPixelRect.Right) > VScale1 + 2) or (abs(VTestArrLenPixelRect.Top - VTestArrLenPixelRect.Bottom) > VScale1 + 2) then begin
    VPointsCount := Length(AMarkPoly.Points);
    if VPointsCount > 0 then begin
      VLocalRect := DoubleRect(ALocalConverter.GetLocalRect);
      VRectWithDelta.Left := VLocalRect.Left - 10;
      VRectWithDelta.Top := VLocalRect.Top - 10;
      VRectWithDelta.Right := VLocalRect.Right + 10;
      VRectWithDelta.Bottom := VLocalRect.Bottom + 10;
      VEnum :=
        TEnumDoublePointFilterEqual.Create(
          TEnumDoublePointClipByRect.Create(
            True,
            VRectWithDelta,
            TEnumDoublePointMapPixelToLocalPixel.Create(
              ALocalConverter,
              TEnumDoublePointFilterEqual.Create(
                TEnumDoublePointLonLatToMapPixel.Create(
                  ALocalConverter.GetZoom,
                  ALocalConverter.GetGeoConverter,
                  TEnumDoublePointFilterFirstPoly.Create(
                    TEnumDoublePointsByArray.Create(
                      @(AMarkPoly.Points[0]),
                      VPointsCount
                    )
                  )
                )
              )
            )
          )
        );
      FPreparedPointsAggreagtor.Clear;
      while VEnum.Next(VPoint) do begin
        FPreparedPointsAggreagtor.Add(VPoint);
      end;
      try
        VPointsProcessedCount := FPreparedPointsAggreagtor.Count;
        if VPointsProcessedCount > 0 then begin
          VPolygon := TPolygon32.Create;
          try
            VPolygon.Antialiased := true;
            VPolygon.AntialiasMode := am4times;
            VPolygon.Closed := True;
              if Length(FPathFixedPoints) < VPointsProcessedCount then begin
                SetLength(FPathFixedPoints, VPointsProcessedCount);
              end;
              for i := 0 to VPointsProcessedCount - 1 do begin
                VPoint := FPreparedPointsAggreagtor.Points[i];
                FPathFixedPoints[i] := FixedPoint(VPoint.X, VPoint.Y);
              end;
              VPolygon.AddPoints(FPathFixedPoints[0], VPointsProcessedCount);
              VPolygon.DrawFill(ATargetBmp, AMarkPoly.FillColor);
              with VPolygon.Outline do try
                with Grow(GR32.Fixed(AMarkPoly.LineWidth / 2), 0.5) do try
                  FillMode := pfWinding;
                  DrawFill(ATargetBmp, AMarkPoly.BorderColor);
                finally
                  free;
                end;
              finally
                free;
              end;
          finally
            VPolygon.Free;
          end;
        end;
      except
      end;
    end;
  end;
end;

procedure TMapMarksBitmapLayerProviderByMarksSubset.DrawPoint(
  ATargetBmp: TCustomBitmap32;
  ALocalConverter: ILocalCoordConverter;
  AMarkPoint: IMarkPoint
);
var
  xy: Tpoint;
  VDstRect: TRect;
  VSrcRect: TRect;
  VTextSize: TSize;
  VMarkSize: Integer;
  VFontSize: Integer;
  VMarker: IBitmapMarker;
  VTargetPoint: TDoublePoint;
begin
  VMarkSize := AMarkPoint.MarkerSize;
  VFontSize := AMarkPoint.FontSize;
  xy := ALocalConverter.LonLat2LocalPixel(AMarkPoint.Point);
  if (AMarkPoint.Pic <> nil) then begin
    VMarker := AMarkPoint.Pic.GetMarkerBySize(VMarkSize);
    VTargetPoint.X := xy.X - VMarker.AnchorPoint.X;
    VTargetPoint.Y := xy.Y - VMarker.AnchorPoint.Y;
    ATargetBmp.Draw(Trunc(VTargetPoint.X), Trunc(VTargetPoint.Y), VMarker.Bitmap);
  end;
  if FConfig.ShowPointCaption then begin
    if VFontSize > 0 then begin
      FBitmapWithText.MasterAlpha:=AlphaComponent(AMarkPoint.TextColor);
      FBitmapWithText.Font.Size := VFontSize;
      VTextSize := FBitmapWithText.TextExtent(AMarkPoint.Name);
      VTextSize.cx:=VTextSize.cx+2;
      VTextSize.cy:=VTextSize.cy+2;
      FBitmapWithText.SetSize(VTextSize.cx + 2,VTextSize.cy + 2);
      VDstRect.Left := xy.x + (VMarkSize div 2);
      VDstRect.Top := xy.y - (VMarkSize div 2) - VTextSize.cy div 2;
      VDstRect.Right := VDstRect.Left + VTextSize.cx;
      VDstRect.Bottom := VDstRect.Top + VTextSize.cy;
      VSrcRect := bounds(1, 1, VTextSize.cx, VTextSize.cy);
      FBitmapWithText.Clear(0);
      FBitmapWithText.RenderText(2, 2, AMarkPoint.Name, 1, SetAlpha(AMarkPoint.TextBgColor,255));
      FBitmapWithText.RenderText(1, 1, AMarkPoint.Name, 1, SetAlpha(AMarkPoint.TextColor,255));
      ATargetBmp.Draw(VDstRect, VSrcRect, FBitmapWithText);
    end;
  end;
end;

function TMapMarksBitmapLayerProviderByMarksSubset.DrawSubset(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier;
  AMarksSubset: IMarksSubset;
  ATargetBmp: TCustomBitmap32;
  ALocalConverter: ILocalCoordConverter
): Boolean;
var
  VEnumMarks: IEnumUnknown;
  VMark: IMark;
  i: Cardinal;
  VOldClipRect: TRect;
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  VOldClipRect := ATargetBmp.ClipRect;
  ATargetBmp.ClipRect := ALocalConverter.GetLocalRect;
  try
    VEnumMarks := AMarksSubset.GetEnum;
    if FConfig.UseSimpleDrawOrder then begin
      while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end;
        if Supports(VMark, IMarkPoint, VMarkPoint) then begin
          DrawPoint(
            ATargetBmp,
            ALocalConverter,
            VMarkPoint
          );
        end else if Supports(VMark, IMarkLine, VMarkLine) then begin
          drawPath(
            ATargetBmp,
            ALocalConverter,
            VMarkLine
          );
        end else if Supports(VMark, IMarkPoly, VMarkPoly) then begin
          DrawPoly(
            ATargetBmp,
            ALocalConverter,
            VMarkPoly
          );
        end;
      end;
    end else begin
      while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end;
        if Supports(VMark, IMarkPoly, VMarkPoly) then begin
          DrawPoly(
            ATargetBmp,
            ALocalConverter,
            VMarkPoly
          );
        end;
      end;
      VEnumMarks.Reset;
      while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end;
        if Supports(VMark, IMarkLine, VMarkLine) then begin
          drawPath(
            ATargetBmp,
            ALocalConverter,
            VMarkLine
          );
        end;
      end;
      VEnumMarks.Reset;
      while (VEnumMarks.Next(1, VMark, @i) = S_OK) do begin
        if ACancelNotifier.IsOperationCanceled(AOperationID) then begin
          Break;
        end;
        if Supports(VMark, IMarkPoint, VMarkPoint) then begin
          DrawPoint(
            ATargetBmp,
            ALocalConverter,
            VMarkPoint
          );
        end;
      end;
    end;
  finally
    ATargetBmp.ClipRect := VOldClipRect;
  end;
  Result := True;
end;

function TMapMarksBitmapLayerProviderByMarksSubset.GetBitmapRect(
  AOperationID: Integer;
  ACancelNotifier: IOperationNotifier;
  ATargetBmp: TCustomBitmap32;
  ALocalConverter: ILocalCoordConverter
): Boolean;
var
  VRectWithDelta: TRect;
  VLocalRect: TRect;
  VTargetRect: TDoubleRect;
  VLonLatRect: TDoubleRect;
  VConverter: ICoordConverter;
  VZoom: Byte;
  VMarksSubset: IMarksSubset;
  VDeltaSizeInPixel: TRect;
begin
  VLocalRect := ALocalConverter.GetLocalRect;
  VDeltaSizeInPixel := FConfig.OverSizeRect;
  VRectWithDelta.Left := VLocalRect.Left - VDeltaSizeInPixel.Left;
  VRectWithDelta.Top := VLocalRect.Top - VDeltaSizeInPixel.Top;
  VRectWithDelta.Right := VLocalRect.Right + VDeltaSizeInPixel.Right;
  VRectWithDelta.Bottom := VLocalRect.Bottom + VDeltaSizeInPixel.Bottom;
  VTargetRect := ALocalConverter.LocalRect2MapRectFloat(VRectWithDelta);
  VZoom := ALocalConverter.GetZoom;
  VConverter := ALocalConverter.GetGeoConverter;
  VConverter.CheckPixelRectFloat(VTargetRect, VZoom);
  VLonLatRect := VConverter.PixelRectFloat2LonLatRect(VTargetRect, VZoom);
  VMarksSubset := FMarksSubset.GetSubsetByLonLatRect(VLonLatRect);

  Result := DrawSubset(AOperationID, ACancelNotifier, VMarksSubset, ATargetBmp, ALocalConverter);
end;

end.

