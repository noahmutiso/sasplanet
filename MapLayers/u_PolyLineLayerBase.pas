unit u_PolyLineLayerBase;

interface

uses
  Types,
  GR32,
  GR32_Polygons,
  GR32_Image,
  t_GeoTypes,
  i_ViewPortState,
  i_LocalCoordConverter,
  i_InternalPerformanceCounter,
  i_LineOnMapEdit,
  i_PolyLineLayerConfig,
  u_ClipPolygonByRect,
  u_MapLayerBasic;

type
  TPolyLineLayerBase = class(TMapLayerBasicNoBitmap)
  private
    FConfig: IPolyLineLayerConfig;
    FLineOnMapEdit: ILineOnMapEdit;

    FLineColor: TColor32;
    FLineWidth: Integer;
    FPointFillColor: TColor32;
    FPointRectColor: TColor32;
    FPointFirstColor: TColor32;
    FPointActiveColor: TColor32;
    FPointSize: integer;

    FSourcePolygon: TArrayOfDoublePoint;
    FPolyActivePointIndex: integer;

    FBitmapSize: TPoint;
    FPointsOnBitmap: TArrayOfDoublePoint;
    FPolygon: TPolygon32;
    FLinePolygon: TPolygon32;

    FClosed: boolean;

    procedure DrawPolyPoint(
      ABuffer: TBitmap32;
      const ABitmapSize: TPoint;
      const APosOnBitmap: TDoublePoint;
      const ASize: Integer;
      const AFillColor: TColor32;
      const ARectColor: TColor32
    );
  protected
    procedure SetSourcePolygon(const Value: TArrayOfDoublePoint); virtual;
    procedure OnLineOnMapEditChange; virtual;
    procedure OnConfigChange; virtual;
    procedure DoConfigChange; virtual;
    function LonLatArrayToVisualFloatArray(
      const APolygon: TArrayOfDoublePoint;
      ALocalConverter: ILocalCoordConverter
    ): TArrayOfDoublePoint;
    procedure PreparePolygon(ALocalConverter: ILocalCoordConverter); virtual;
    property BitmapSize: TPoint read FBitmapSize;
    property PointsOnBitmap: TArrayOfDoublePoint read FPointsOnBitmap;
    property SourcePolygon: TArrayOfDoublePoint read FSourcePolygon write SetSourcePolygon;
  protected
    procedure PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter); override;
  public
    procedure StartThreads; override;
  public
    constructor Create(
      APerfList: IInternalPerformanceCounterList;
      AParentMap: TImage32;
      AViewPortState: IViewPortState;
      ALineOnMapEdit: ILineOnMapEdit;
      AConfig: IPolyLineLayerConfig;
      APolygon: TPolygon32;
      AClosed: boolean
    );
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  i_CoordConverter,
  u_GeoFun,
  u_NotifyEventListener;

{ TPolyLineLayerBase }

constructor TPolyLineLayerBase.Create(
  APerfList: IInternalPerformanceCounterList;
  AParentMap: TImage32;
  AViewPortState: IViewPortState;
  ALineOnMapEdit: ILineOnMapEdit;
  AConfig: IPolyLineLayerConfig;
  APolygon: TPolygon32;
  AClosed: boolean
);
begin
  inherited Create(APerfList, AParentMap, AViewPortState);
  FConfig := AConfig;
  FLineOnMapEdit := ALineOnMapEdit;
  FPolygon := APolygon;

  FLinePolygon := TPolygon32.Create;

  FClosed := AClosed;

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnConfigChange),
    FConfig.GetChangeNotifier
  );

  LinksList.Add(
    TNotifyNoMmgEventListener.Create(Self.OnLineOnMapEditChange),
    FLineOnMapEdit.GetChangeNotifier
  );
end;

destructor TPolyLineLayerBase.Destroy;
begin
  FreeAndNil(FLinePolygon);
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TPolyLineLayerBase.DoConfigChange;
begin
  FLineColor := FConfig.LineColor;
  FLineWidth := FConfig.LineWidth;
  FPointFillColor := FConfig.PointFillColor;
  FPointRectColor := FConfig.PointRectColor;
  FPointFirstColor := FConfig.PointFirstColor;
  FPointActiveColor := FConfig.PointActiveColor;
  FPointSize := FConfig.PointSize;
end;

procedure TPolyLineLayerBase.DrawPolyPoint(
  ABuffer: TBitmap32;
  const ABitmapSize: TPoint;
  const APosOnBitmap: TDoublePoint;
  const ASize: Integer;
  const AFillColor, ARectColor: TColor32
);
var
  VHalfSize: Double;
  VRect: TRect;
begin
  if
    (APosOnBitmap.x > 0) and
    (APosOnBitmap.y > 0) and
    (APosOnBitmap.x < ABitmapSize.X) and
    (APosOnBitmap.y < ABitmapSize.Y)
  then begin
    VHalfSize := ASize / 2;
    VRect.Left := Trunc(APosOnBitmap.X - VHalfSize);
    VRect.Top := Trunc(APosOnBitmap.Y - VHalfSize);
    VRect.Right := VRect.Left + ASize;
    VRect.Bottom := VRect.Top + ASize;
    ABuffer.FillRectTS(VRect, ARectColor);
    if AFillColor <> ARectColor then begin
      Inc(VRect.Left);
      Inc(VRect.Top);
      Dec(VRect.Right);
      Dec(VRect.Bottom);
      ABuffer.FillRectS(VRect, AFillColor);
    end;
  end;
end;

procedure TPolyLineLayerBase.OnConfigChange;
begin
  ViewUpdateLock;
  try
    FConfig.LockRead;
    try
      DoConfigChange;
    finally
      FConfig.UnlockRead;
    end;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TPolyLineLayerBase.OnLineOnMapEditChange;
var
  VPoints: TArrayOfDoublePoint;
  VActiveIndex: Integer;
  VPointsCount: Integer;
begin
  FLineOnMapEdit.LockRead;
  try
    VPoints := Copy(FLineOnMapEdit.GetPoints);
    VActiveIndex := FLineOnMapEdit.GetActiveIndex;
  finally
    FLineOnMapEdit.UnlockRead;
  end;

  ViewUpdateLock;
  try
    FSourcePolygon := VPoints;
    FPolyActivePointIndex := VActiveIndex;

    VPointsCount := Length(FSourcePolygon);
    if VPointsCount > 0 then begin
      SetNeedRedraw;
      Show;
    end else begin
      Hide;
    end;
  finally
    ViewUpdateUnlock;
  end;
  ViewUpdate;
end;

procedure TPolyLineLayerBase.PaintLayer(ABuffer: TBitmap32; ALocalConverter: ILocalCoordConverter);
var
  VIndex: integer;
  VPosOnBitmap: TDoublePoint;
  VPointsCount: Integer;
begin
  PreparePolygon(ALocalConverter);
  VPointsCount := Length(FPointsOnBitmap);
  if VPointsCount > 0 then begin
    if FLinePolygon <> nil then begin
      FLinePolygon.DrawFill(ABuffer, FLineColor);
    end;

    for VIndex := 1 to VPointsCount - 2 do begin
      VPosOnBitmap := FPointsOnBitmap[VIndex];
      DrawPolyPoint(ABuffer, FBitmapSize, VPosOnBitmap, FPointSize, FPointFillColor, FPointRectColor);
    end;
    DrawPolyPoint(ABuffer, FBitmapSize, FPointsOnBitmap[VPointsCount - 1], FPointSize, FPointFillColor, FPointRectColor);
    DrawPolyPoint(ABuffer, FBitmapSize, FPointsOnBitmap[0], FPointSize, FPointFirstColor, FPointFirstColor);
    DrawPolyPoint(ABuffer, FBitmapSize, FPointsOnBitmap[FPolyActivePointIndex], FPointSize, FPointActiveColor, FPointActiveColor);
  end;
end;

function TPolyLineLayerBase.LonLatArrayToVisualFloatArray(
  const APolygon: TArrayOfDoublePoint;
  ALocalConverter: ILocalCoordConverter
): TArrayOfDoublePoint;
var
  i: Integer;
  VPointsCount: Integer;
  VLonLat: TDoublePoint;
  VGeoConvert: ICoordConverter;
begin
  VPointsCount := Length(APolygon);
  SetLength(Result, VPointsCount);

  VGeoConvert := ALocalConverter.GetGeoConverter;
  for i := 0 to VPointsCount - 1 do begin
    VLonLat := APolygon[i];
    if PointIsEmpty(VLonLat) then begin
      Result[i] := VLonLat;
    end else begin
      VGeoConvert.CheckLonLatPos(VLonLat);
      Result[i] := ALocalConverter.LonLat2LocalPixelFloat(VLonLat);
    end;
  end;
end;

procedure TPolyLineLayerBase.PreparePolygon(ALocalConverter: ILocalCoordConverter);
var
  VPointsCount: Integer;
  VPolygonOutline: TPolygon32;
  VPolygonGrow: TPolygon32;
  i: Integer;
  VPathFixedPoints: TArrayOfFixedPoint;
  VBitmapClip: IPolygonClip;
  VPointsProcessedCount: Integer;
  VPointsOnBitmapPrepared: TArrayOfDoublePoint;
  VIndex: Integer;
  VLocalRect: TRect;
begin
  VPointsCount := Length(FSourcePolygon);
  if VPointsCount > 0 then begin
    VLocalRect := ALocalConverter.GetLocalRect;
    FBitmapSize.X := VLocalRect.Right - VLocalRect.Left;
    FBitmapSize.Y := VLocalRect.Bottom - VLocalRect.Top;
    Dec(VLocalRect.Left, 10);
    Dec(VLocalRect.Top, 10);
    Inc(VLocalRect.Right, 10);
    Inc(VLocalRect.Bottom, 10);
    VBitmapClip := TPolygonClipByRect.Create(VLocalRect);
    FPointsOnBitmap := LonLatArrayToVisualFloatArray(FSourcePolygon, ALocalConverter);
    if FClosed then begin
      SetLength(FPointsOnBitmap,VPointsCount+1);
      FPointsOnBitmap[VPointsCount]:=FPointsOnBitmap[0];
      inc(VPointsCount);
    end;

    VPointsProcessedCount := VBitmapClip.Clip(FPointsOnBitmap[0], VPointsCount, VPointsOnBitmapPrepared);
    if VPointsProcessedCount > 0 then begin
      SetLength(VPathFixedPoints, VPointsProcessedCount);
      VIndex := 0;
      FPolygon.Clear;
      for i := 0 to VPointsProcessedCount - 1 do begin
        if PointIsEmpty(VPointsOnBitmapPrepared[i]) then begin
          FPolygon.AddPoints(VPathFixedPoints[0], VIndex);
          FPolygon.NewLine;
          VIndex := 0;
        end else begin
          VPathFixedPoints[VIndex] := FixedPoint(VPointsOnBitmapPrepared[i].X, VPointsOnBitmapPrepared[i].Y);
          Inc(VIndex);
        end;
      end;
      FPolygon.AddPoints(VPathFixedPoints[0], VIndex);

      VPolygonOutline := FPolygon.Outline;
      try
        VPolygonGrow := VPolygonOutline.Grow(Fixed(FLineWidth / 2), 0.5);
        try
          FLinePolygon.Assign(VPolygonGrow);
        finally
          VPolygonGrow.Free;
        end;
      finally
        VPolygonOutline.Free;
      end;
    end;
  end;
end;

procedure TPolyLineLayerBase.SetSourcePolygon(const Value: TArrayOfDoublePoint);
begin
  FSourcePolygon := Value;
end;

procedure TPolyLineLayerBase.StartThreads;
begin
  inherited;
  OnConfigChange;
end;

end.

