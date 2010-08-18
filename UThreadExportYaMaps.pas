unit UThreadExportYaMaps;

interface

uses
  Windows,
  Types,
  Forms,
  SysUtils,
  Classes,
  Graphics,
  GR32,
  UMapType,
  UGeoFun,
  unit4,
  UResStrings,
  UYaMobile,
  t_GeoTypes;

type
  TThreadExportYaMaps = class(TThread)
  private
    FPolygLL:TExtendedPointArray;
    FZoomArr:array [0..23] of boolean;
    FMapTypeArr:array of TMapType;
    FIsReplace:boolean;
    FExportPath: string;

    FProgressForm: TFprogress2;
    FShowFormCaption: string;
    FShowOnFormLine0: string;
    FShowOnFormLine1: string;
    FProgressOnForm: integer;
    FMessageForShow: string;

    csat,cmap,chib:byte;

    procedure UpdateProgressFormBar;
    procedure UpdateProgressFormCaption;
    procedure UpdateProgressFormStr0;
    procedure UpdateProgressFormStr1;
    procedure UpdateProgressFormClose;
    procedure SynShowMessage;

    procedure export2YaMaps;
  protected
    procedure Execute; override;
  public
    constructor Create(
      APath: string;
      APolygon: TExtendedPointArray;
      Azoomarr: array of boolean;
      Atypemaparr: array of TMapType;
      Areplace: boolean;
      Acsat: byte;
      Acmap: byte;
      Achib: byte
    );
  end;

implementation

uses
  Dialogs,
  u_GeoToStr,
  i_ICoordConverter,
  u_GlobalState,
  u_CoordConverterMercatorOnEllipsoid,
  i_BitmapTileSaveLoad,
  u_BitmapTileJpegSaverIJL,
  u_BitmapTileVampyreSaver;

constructor TThreadExportYaMaps.Create(
  APath: string;
  APolygon: TExtendedPointArray;
  Azoomarr: array of boolean;
  Atypemaparr: array of TMapType;
  Areplace: boolean;
  Acsat, Acmap, Achib: byte
);
var i:integer;
begin
  inherited Create(false);
  Priority := tpLowest;
  FreeOnTerminate:=true;
  Application.CreateForm(TFProgress2, FProgressForm);
  cSat:=Acsat;
  cMap:=Acmap;
  cHib:=Achib;
  FProgressForm.ProgressBar1.Progress1 := 0;
  FProgressForm.ProgressBar1.Max := 100;
  FProgressForm.Visible:=true;
  FExportPath:=APath;
  FIsReplace:=AReplace;
  setlength(FPolygLL,length(APolygon));
  for i:=1 to length(APolygon) do
    FPolygLL[i-1]:=APolygon[i-1];
  for i:=0 to 23 do
    FZoomArr[i]:=Azoomarr[i];
  setlength(FMapTypeArr,length(Atypemaparr));
  for i:=1 to length(Atypemaparr) do
    FMapTypeArr[i-1]:=Atypemaparr[i-1];
end;


procedure TThreadExportYaMaps.Execute;
begin
  export2YaMaps;
  Synchronize(UpdateProgressFormClose);
end;

function UniLoadTile(var bmp:TBitmap32; ATypeMap: TmapType; ATargetProjection: byte; p_h:TPoint;p_x,p_y:integer; zoom:byte):boolean;
var
  bmp2,bmp1:TBitmap32;
  res1,res2:boolean;
  VTile: TPoint;
begin
  res2:=false;
  bmp.width:=256;
  bmp.Height:=256;
  bmp.Clear(Color32(GState.BGround));
  bmp1:=TBitmap32.Create;
  try
    bmp1.DrawMode:=dmBlend;
    bmp2:=TBitmap32.Create;
    try
      bmp2.DrawMode:=dmBlend;
      res1:=true;
      VTile := ATypeMap.GeoConvert.PixelPos2TilePos(p_h, zoom);
      if (not(ATypeMap.LoadTile(bmp1,VTile, zoom, false))) then begin
        res1:=false;
        bmp1.width:=256;
        bmp1.Height:=256;
        bmp1.Clear(Color32(GState.BGround));
      end;
      if p_h.Y<0 then begin
        bmp.Draw(0,((((p_Y-(p_y mod 256)) mod 256)+256)-(p_h.Y mod 256)),bmp1);
      end else begin
        bmp.Draw(0,(((p_Y-(p_y mod 256)) mod 256)-(p_h.Y mod 256)),bmp1);
      end;

      if ATargetProjection<>ATypeMap.projection then begin
        res2:=true;
        if (not(ATypeMap.LoadTile(bmp2,Point(VTile.X, VTile.Y + 1), zoom,false))) then begin
          res2:=false;
          bmp2.width:=256;
          bmp2.Height:=256;
          bmp2.Clear(Color32(GState.BGround));
        end;
        if p_h.Y<0 then begin
          bmp.Draw(0,(((p_Y-(p_y mod 256)) mod 256)-(p_h.Y mod 256)),bmp2);
        end else begin
          bmp.Draw(0,((((p_Y-(p_y mod 256)) mod 256)+256)-(p_h.Y mod 256)),bmp2);
        end;
      end;
      result:=(res1 or res2);
    finally
      bmp2.Free;
    end;
  finally
    bmp1.Free;
  end;
end;

procedure TThreadExportYaMaps.export2YaMaps;
var
  p_x,p_y,i,j,xi,yi,hxyi,sizeim:integer;
  VTilesToProcess,VTilesProcessed:integer;
  polyg:TPointArray;
  max,min,p_h:TPoint;
  bmp32,bmp322,bmp32crop:TBitmap32;
  TileStream : TMemoryStream;
  tc:cardinal;
  VGeoConvert: ICoordConverter;
  JPGSaver,PNGSaver:IBitmapTileSaver;
begin
  try
    if (FMapTypeArr[0]=nil)and(FMapTypeArr[1]=nil)and(FMapTypeArr[2]=nil) then exit;
    try
      hxyi:=1;
      sizeim:=128;
      JPGSaver:=TJpegBitmapTileSaverIJL.create(cSat);
      PNGSaver:=TVampyreBasicBitmapTileSaverPNGPalette.create(cMap);
      TileStream:=TMemoryStream.Create;
      bmp32:=TBitmap32.Create;
      bmp32.DrawMode:=dmBlend;
      bmp322:=TBitmap32.Create;
      bmp322.DrawMode:=dmBlend;
      bmp32crop:=TBitmap32.Create;
      bmp32crop.Width:=sizeim;
      bmp32crop.Height:=sizeim;
      VGeoConvert := TCoordConverterMercatorOnEllipsoid.Create(6378137, 6356752);
      VTilesToProcess:=0;
      SetLength(polyg,length(FPolygLL));
      for i:=0 to length(FMapTypeArr)-1 do begin
        if FMapTypeArr[i]<>nil then begin
          for j:=0 to 23 do begin
            if FZoomArr[j] then begin
              polyg := FMapTypeArr[i].GeoConvert.PoligonProject(j + 8, FPolygLL);
              VTilesToProcess:=VTilesToProcess+GetDwnlNum(min,max,Polyg,true);
            end;
          end;
        end;
      end;
      FShowOnFormLine0:=SAS_STR_ExportTiles;
      Synchronize(UpdateProgressFormStr0);

      FShowFormCaption:=SAS_STR_AllSaves+' '+inttostr(VTilesToProcess)+' '+SAS_STR_files;
      Synchronize(UpdateProgressFormCaption);

      FProgressOnForm := 0;
      FShowOnFormLine1:=SAS_STR_Processed+' '+inttostr(FProgressOnForm)+'%';
      Synchronize(UpdateProgressFormStr1);
      
      VTilesProcessed:=0;
      tc:=GetTickCount;
      for i:=0 to 23 do begin
        if FZoomArr[i] then begin
          for j:=0 to 2 do begin
            if (FMapTypeArr[j]<>nil)and(not((j=0)and(FMapTypeArr[2]<>nil))) then begin
              polyg := VGeoConvert.PoligonProject(i + 8, FPolygLL);
              GetDwnlNum(min,max,Polyg,false);
              p_x:=min.x;
              while p_x<max.x do begin
                p_y:=min.Y;
                while p_y<max.Y do begin
                  if (FProgressForm.Visible=false)or(not(RgnAndRgn(Polyg,p_x,p_y,false))) then begin
                    inc(p_y,256);
                    CONTINUE;
                  end;
                  bmp322.Clear;
                  if (j=2)and(FMapTypeArr[0]<>nil) then begin
                    p_h := VGeoConvert.Pos2OtherMap(Point(p_x,p_y-(p_y mod 256)), i + 8, FMapTypeArr[0].GeoConvert);
                    UniLoadTile(bmp322,FMapTypeArr[0],2,p_h,p_x,p_y,i);
                  end;
                  bmp32.Clear;
                  p_h := VGeoConvert.Pos2OtherMap(Point(p_x,p_y-(p_y mod 256)), i + 8, FMapTypeArr[j].GeoConvert);
                  if UniLoadTile(bmp32,FMapTypeArr[j],2,p_h,p_x,p_y,i) then begin
                    if (j=2)and(FMapTypeArr[0]<>nil) then begin
                      bmp322.Draw(0,0,bmp32);
                      bmp32.Draw(0,0,bmp322);
                    end;
                    if (j=2)or(j=0) then begin
                      for xi:=0 to hxyi do begin
                        for yi:=0 to hxyi do begin
                          bmp32crop.Clear;
                          bmp32crop.Draw(0,0,bounds(sizeim*xi,sizeim*yi,sizeim,sizeim),bmp32);
                          TileStream.Clear;
                          JPGSaver.SaveToStream(bmp32crop,TileStream);
                          WriteTileInCache(p_x div 256,p_y div 256,i,2,(yi*2)+xi,FExportPath, TileStream,FIsReplace)
                        end;
                      end;
                    end;
                    if j=1 then begin
                      for xi:=0 to hxyi do begin
                        for yi:=0 to hxyi do begin
                          bmp32crop.Clear;
                          bmp32crop.Draw(0,0,bounds(sizeim*xi,sizeim*yi,sizeim,sizeim),bmp32);
                          TileStream.Clear;
                          PNGSaver.SaveToStream(bmp32crop,TileStream);
                          WriteTileInCache(p_x div 256,p_y div 256,i,1,(yi*2)+xi,FExportPath, TileStream,FIsReplace)
                        end;
                      end;
                    end;
                  end;
                  inc(VTilesProcessed);
                  if (GetTickCount-tc>1000) then begin
                    tc:=GetTickCount;
                    FProgressOnForm:=round((VTilesProcessed/VTilesToProcess)*100);
                    Synchronize(UpdateProgressFormBar);
                    FShowOnFormLine1:=SAS_STR_Processed+' '+inttostr(FProgressOnForm)+'%';
                    Synchronize(UpdateProgressFormStr1);
                  end;
                  inc(p_y,256);
                end;
                inc(p_x,256);
              end;
            end;
          end;
        end;
      end;
      FProgressOnForm:=round((VTilesProcessed/VTilesToProcess)*100);
      Synchronize(UpdateProgressFormBar);
      FShowOnFormLine1:=SAS_STR_Processed+' '+inttostr(FProgressOnForm)+'%';
      Synchronize(UpdateProgressFormStr1);
    finally
      bmp32.Free;
      bmp322.Free;
    end;
  except
    on e: Exception do begin
      FMessageForShow := e.Message;
      Synchronize(SynShowMessage);
    end;
  end;
end;

procedure TThreadExportYaMaps.SynShowMessage;
begin
  ShowMessage(FMessageForShow);
end;

procedure TThreadExportYaMaps.UpdateProgressFormCaption;
begin
  FProgressForm.Caption := FShowFormCaption;
end;

procedure TThreadExportYaMaps.UpdateProgressFormClose;
begin
  FProgressForm.Close;
end;

procedure TThreadExportYaMaps.UpdateProgressFormStr0;
begin
  FProgressForm.MemoInfo.Lines[0] := FShowOnFormLine0;
end;

procedure TThreadExportYaMaps.UpdateProgressFormStr1;
begin
  FProgressForm.MemoInfo.Lines[1] := FShowOnFormLine1;
end;

procedure TThreadExportYaMaps.UpdateProgressFormBar;
begin
  FProgressForm.ProgressBar1.Progress1 := FProgressOnForm;
end;

end.
