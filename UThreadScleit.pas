unit UThreadScleit;

interface

uses
  Windows,
  Forms,
  SysUtils,
  Classes,
  Dialogs,
  Graphics,
  GR32,
  Jpeg,
  ijl,
  UECWWrite,
  UMapType,
  UImgFun,
  UGeoFun,
  bmpUtil,
  t_GeoTypes,
  UResStrings,
  unit4;

type
  PRow = ^TRow;
  TRow = array[0..0] of byte;

  P256rgb = ^T256rgb;
  T256rgb = array[0..255] of PRow;

  PArrayBGR = ^TArrayBGR;
  TArrayBGR = array [0..0] of TBGR;

  P256ArrayBGR = ^T256ArrayBGR;
  T256ArrayBGR = array[0..255] of PArrayBGR;

  TThreadScleit = class(TThread)
  private
    FZoom: byte;
    FPoly: TPointArray;
    FMapCalibrationList: IInterfaceList;
    FSplitCount: TPoint;
    FFileName: string;
    FFilePath: string;
    FFileExt: string;
    FCurrentFileName: string;
    FTypeMap: TMapType;
    FHTypeMap: TMapType;



    FProcessTiles: integer;
    PolyMin:TPoint;
    PolyMax:TPoint;
    Fprogress: TFprogress2;
    Array256BGR:P256ArrayBGR;
    sx,ex,sy,ey:integer;
    Rarr:P256rgb;
    Garr:P256rgb;
    Barr:P256rgb;
    Poly0:TPoint;
    Poly1:TPoint;
    colors:byte;
    ecw:TECWWrite;
    btmm:TBitmap32;
    btmh:TBitmap32;
    usedReColor:boolean;
    prStr1,prStr2,prCaption:string;
    prBar:integer;
    Message_:string;
    LastXY: TPoint;
    function ReadLineECW(Line:cardinal;var LineR,LineG,LineB:PLineRGB):boolean;
    function ReadLineBMP(Line:cardinal;LineRGB:PLineRGBb):boolean;
    function IsCancel: Boolean;
    procedure UpdateProgressFormCapt;
    procedure UpdateProgressFormBar;
    procedure UpdateProgressFormStr1;
    procedure UpdateProgressFormStr2;
    procedure UpdateProgressFormClose;
    procedure SynShowMessage;
    procedure saveRECT;
    procedure Save_ECW;
    procedure Save_BMP;
    procedure Save_JPG;
  protected
    procedure Execute; override;
  public
    constructor Create(
      AMapCalibrationList: IInterfaceList;
      AFName: string;
      APolygon_: TPointArray;
      numTilesG: integer;
      numTilesV: integer;
      Azoom: byte;
      Atypemap: TMapType;
      AHtypemap: TMapType;
      Acolors: byte;
      AusedReColor: boolean
    );
  end;

implementation

uses
  StrUtils,
  ECWWriter,
  i_IMapCalibration,
  u_GlobalState,
  usaveas, Types;

procedure TThreadScleit.SynShowMessage;
begin
 ShowMessage(Message_);
end;

procedure TThreadScleit.UpdateProgressFormClose;
begin
 fprogress.Close;
end;

procedure TThreadScleit.UpdateProgressFormCapt;
begin
 fprogress.Caption:=prCaption;
end;

procedure TThreadScleit.UpdateProgressFormStr1;
begin
 fprogress.MemoInfo.Lines[0]:=prStr1;
end;

procedure TThreadScleit.UpdateProgressFormStr2;
begin
 fprogress.MemoInfo.Lines[1]:=prStr2;
end;

procedure TThreadScleit.UpdateProgressFormBar;
begin
 fprogress.ProgressBar1.Progress1:=prBar;
end;

procedure TThreadScleit.saveRECT;
var
  i, j, pti: integer;
  Fnamebuf: string;
begin
  prCaption:='�������: '+inttostr((PolyMax.x-PolyMin.x-1) div 256+1)+'x'
    +inttostr((PolyMax.y-PolyMin.y-1) div 256+1) +'('+inttostr(FProcessTiles)+') '+SAS_STR_files;
  Synchronize(UpdateProgressFormCapt);
  prStr1:=SAS_STR_Resolution+': '+inttostr((PolyMax.x-PolyMin.x))+'x'+inttostr((PolyMax.y-PolyMin.y))+' '+SAS_STR_DivideInto+' '+inttostr(FSplitCount.X*FSplitCount.Y)+' '+SAS_STR_files;
  Synchronize(UpdateProgressFormStr1);

  FProgress.ProgressBar1.Max:=0;
  for i:=1 to FSplitCount.X do begin
    for j:=1 to FSplitCount.Y do begin
      FProgress.ProgressBar1.Max:=FProgress.ProgressBar1.Max+(((PolyMax.x-PolyMin.x)div 256)+2)*(((PolyMax.y-PolyMin.y)div 256)+2);
    end;
  end;
  prBar:=0;
  Synchronize(UpdateProgressFormBar);
  prStr2:=SAS_STR_Processed+' '+inttostr(FProgress.ProgressBar1.Progress1);
  Synchronize(UpdateProgressFormStr2);

  for i:=1 to FSplitCount.X do begin
    for j:=1 to FSplitCount.Y do begin
      Poly0.X:=PolyMin.x+((PolyMax.x-PolyMin.x)div FSplitCount.X)*(i-1);
      Poly1.X:=PolyMin.x+((PolyMax.x-PolyMin.x)div FSplitCount.X)*i;
      Poly0.Y:=PolyMin.y+((PolyMax.y-PolyMin.y)div FSplitCount.Y)*(j-1);
      Poly1.Y:=PolyMin.y+((PolyMax.y-PolyMin.y)div FSplitCount.Y)*j;

      if (FSplitCount.X > 1) or (FSplitCount.Y > 1) then begin
        FCurrentFileName := FFilePath + FFileName + '_'+inttostr(i)+'-'+inttostr(j) + FFileExt;
      end else begin
        FCurrentFileName := FFilePath + FFileName + FFileExt;
      end;

      for pti := 0 to FMapCalibrationList.Count - 1 do begin
        try
          (FMapCalibrationList.get(pti) as IMapCalibration).SaveCalibrationInfo(FCurrentFileName, Poly0, Poly1, FZoom - 1, FTypeMap.GeoConvert);
        except
          //TODO: �������� ���� ���������� ��������� ������.
        end;
      end;
      try
        if (UpperCase(FFileExt)='.ECW')or(UpperCase(FFileExt)='.JP2') then begin
          Save_ECW;
          continue;
        end else if (UpperCase(FFileExt)='.BMP') then begin
          Save_BMP;
          continue;
        end else begin
          Save_JPG;
        end;
      except
        On E:Exception do begin
          Message_:=E.Message;
          Synchronize(SynShowMessage);
          exit;
        end;
      end;
    end;
  end;
end;

constructor TThreadScleit.Create(AMapCalibrationList: IInterfaceList; AFName:string;APolygon_:TPointArray;numTilesG,numTilesV:integer;Azoom:byte;Atypemap,AHtypemap:TMapType;Acolors:byte;AusedReColor:boolean);
begin
  inherited Create(false);
  Priority := tpLower;
  FreeOnTerminate := true;
  FPoly := APolygon_;
  FZoom := Azoom;
  FSplitCount.X := numTilesG;
  FSplitCount.Y := numTilesV;
  FFilePath := ExtractFilePath(AFName);
  FFileExt := ExtractFileExt(AFName);
  FFileName := ChangeFileExt(ExtractFileName(AFName), '');
  FTypeMap := Atypemap;
  FHTypeMap := AHtypemap;


  Application.CreateForm(TFProgress2, FProgress);
  FMapCalibrationList := AMapCalibrationList;
  FProgress.Visible:=true;
  usedReColor:=AusedReColor;
  colors:=Acolors;
  FProcessTiles:=GetDwnlNum(PolyMin, polyMax, FPoly, true);
  GetMinMax(PolyMin, polyMax, FPoly,false);
end;

procedure TThreadScleit.Execute;
begin
 saveRECT;
 Synchronize(UpdateProgressFormClose);
end;

function TThreadScleit.ReadLineECW(Line: cardinal; var LineR, LineG,
  LineB: PLineRGB): boolean;
var
  i,j,rarri,lrarri,p_x,p_y,Asx,Asy,Aex,Aey,starttile:integer;
  p_h:TPoint;
  p:PColor32array;
begin
  Result := True;
  if line<(256-sy) then begin
    starttile:=sy+line;
  end else begin
    starttile:=(line-(256-sy)) mod 256;
  end;
  if (starttile=0)or(line=0) then begin
    prBar:=line;
    Synchronize(UpdateProgressFormBar);
    prStr2:=SAS_STR_Processed+': '+inttostr(Round((line/(Poly1.Y-Poly0.Y))*100))+'%';
    Synchronize(UpdateProgressFormStr2);
    p_y:=(Poly0.Y+line)-((Poly0.Y+line) mod 256);
    p_x:=poly0.x-(poly0.x mod 256);
    p_h := FTypeMap.GeoConvert.Pos2OtherMap(Point(p_x,p_y), (FZoom - 1) + 8, FHTypeMap.GeoConvert);
    lrarri:=0;
    if line>(255-sy) then Asy:=0 else Asy:=sy;
    if (p_y div 256)=(poly1.y div 256) then Aey:=ey else Aey:=255;
    Asx:=sx;
    Aex:=255;
    while p_x<=poly1.x do begin
      // ��������� ���������� ��������������� ����� ��� ������ ���� ���������� ������
      LastXY.X := p_x;
      LastXY.Y := p_y;
      if not(RgnAndRgn(FPoly, p_x+128, p_y+128, false)) then begin
        btmm.Clear(Color32(GState.BGround))
      end else begin
        btmm.Clear(Color32(GState.BGround));
        if (FTypeMap.Tileexists(p_x,p_y, FZoom)) then begin
          if not(FTypeMap.LoadTile(btmm,p_x,p_y, FZoom,false)) then begin
            FTypeMap.LoadTileFromPreZ(btmm,p_x,p_y,FZoom,false);
          end;
        end else begin
          FTypeMap.LoadTileFromPreZ(btmm,p_x,p_y, FZoom, false);
        end;
        if usedReColor then Gamma(btmm);
        if FHTypeMap<>nil then begin
          btmh.Clear($FF000000);
          if (FHTypeMap.Tileexists(p_h.x,p_h.y, FZoom)) then begin
            if not(FHTypeMap.LoadTile(btmh,p_h.x,p_h.y, FZoom,false)) then begin
              FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y, FZoom, false);
            end;
          end else begin
            FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y, FZoom, false);
          end;
          btmh.DrawMode:=dmBlend;
          btmm.Draw(0,0-((p_h.y mod 256)),btmh);
          if p_h.y<>p_y then begin
            btmh.Clear($FF000000);
            if (FHTypeMap.Tileexists(p_h.x,p_h.y+256, FZoom)) then begin
              if not(FHTypeMap.LoadTile(btmh,p_h.x,p_h.y+256, FZoom, false)) then begin
                FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y+256, FZoom, false);
              end;
            end else begin
              FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y+256, FZoom, false);
            end;
            btmh.DrawMode:=dmBlend;
            btmm.Draw(0,256-(p_h.y mod 256),bounds(0,0,256,(p_h.y mod 256)),btmh);
          end;
        end;
      end;
      if (p_x+256)>poly1.x then Aex:=ex;
      for j:=Asy to Aey do begin
        p:=btmm.ScanLine[j];
        rarri:=lrarri;
        for i:=Asx to Aex do begin
          Rarr^[j]^[rarri]:=(cardinal(p^[i]) shr 16);
          Garr^[j]^[rarri]:=(cardinal(p^[i]) shr 8);
          Barr^[j]^[rarri]:=(cardinal(p^[i]));
          inc(rarri);
        end;
      end;
      lrarri:=rarri;
      Asx:=0;
      inc(p_x,256);
      inc(p_h.x,256);
    end;
  end;
  for i:=0 to (poly1.x-poly0.x)-1 do begin
    LineR^[i]:=Rarr^[starttile]^[i];
    LineG^[i]:=Garr^[starttile]^[i];
    LineB^[i]:=Barr^[starttile]^[i];
  end;
end;

function TThreadScleit.IsCancel: Boolean;
begin
  result:=not(Fprogress.Visible);
end;

function TThreadScleit.ReadLineBMP(Line: cardinal;
  LineRGB: PLineRGBb): boolean;
var
  i,j,rarri,lrarri,p_x,p_y,Asx,Asy,Aex,Aey,starttile:integer;
  p_h:TPoint;
  p:PColor32array;
begin
  if line<(256-sy) then begin
    starttile:=sy+line
  end else begin
    starttile:=(line-(256-sy)) mod 256;
  end;
  if (starttile=0)or(line=0) then begin
    prBar:=line;
    Synchronize(UpdateProgressFormBar);
    if line=0 then begin
      prStr2:=SAS_STR_CreateFile
    end else begin
      prStr2:=SAS_STR_Processed+': '+inttostr(Round((line/(Poly1.Y-Poly0.Y))*100))+'%';
    end;
    Synchronize(UpdateProgressFormStr2);
    p_y:=(Poly0.Y+line)-((Poly0.Y+line) mod 256);
    p_x:=poly0.x-(poly0.x mod 256);
    p_h := FTypeMap.GeoConvert.Pos2OtherMap(Point(p_x,p_y), (Fzoom - 1) + 8, FHTypeMap.GeoConvert);
    lrarri:=0;
    if line>(255-sy) then Asy:=0 else Asy:=sy;
    if (p_y div 256)=(poly1.y div 256) then Aey:=ey else Aey:=255;
    Asx:=sx;
    Aex:=255;
    while p_x<=poly1.x do begin
      if not(RgnAndRgn(FPoly, p_x+128, p_y+128, false)) then begin
        btmm.Clear(Color32(GState.BGround))
      end else begin
        btmm.Clear(Color32(GState.BGround));
        if (FTypeMap.Tileexists(p_x,p_y, FZoom)) then begin
          if not(FTypeMap.LoadTile(btmm,p_x,p_y, FZoom, false)) then begin
            FTypeMap.LoadTileFromPreZ(btmm,p_x,p_y, FZoom, false);
          end;
        end else begin
          FTypeMap.LoadTileFromPreZ(btmm,p_x,p_y, FZoom, false);
        end;
        if usedReColor then Gamma(btmm);
        if FHTypeMap<>nil then begin
          btmh.Clear($FF000000);
          if (FHTypeMap.Tileexists(p_h.x,p_h.y, FZoom)) then begin
            if not(FHTypeMap.LoadTile(btmh,p_h.x,p_h.y, FZoom, false)) then begin
              FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y, FZoom, false);
            end;
          end else begin
            FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y, FZoom, false);
          end;
          btmh.DrawMode:=dmBlend;
          btmm.Draw(0,0-((p_h.y mod 256)),btmh);
          if p_h.y<>p_y then begin
            btmh.Clear($FF000000);
            if (FHTypeMap.Tileexists(p_h.x,p_h.y+256, FZoom)) then begin
              if not(FHTypeMap.LoadTile(btmh,p_h.x,p_h.y+256, FZoom, false)) then begin
                FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y+256, FZoom, false);
              end;
            end else begin
              FHTypeMap.LoadTileFromPreZ(btmh,p_h.x,p_h.y+256, FZoom, false);
            end;
            btmh.DrawMode:=dmBlend;
            btmm.Draw(0,256-(p_h.y mod 256),bounds(0,0,256,(p_h.y mod 256)),btmh);
          end;
        end;
      end;
      if (p_x+256)>poly1.x then Aex:=ex;
      for j:=Asy to Aey do begin
        p:=btmm.ScanLine[j];
        rarri:=lrarri;
        for i:=Asx to Aex do begin
          CopyMemory(@Array256BGR[j]^[rarri],Pointer(integer(p)+(i*4)),3);
          inc(rarri);
        end;
      end;
      lrarri:=rarri;
      Asx:=0;
      inc(p_x,256);
      inc(p_h.x,256);
    end;
  end;
  CopyMemory(LineRGB,Array256BGR^[starttile],(poly1.x-poly0.x)*3);
end;

procedure TThreadScleit.Save_ECW;
var
  k: integer;
  Datum, Proj: string;
  Units: TCellSizeUnits;
  CellIncrementX, CellIncrementY, OriginX, OriginY: extended;
  errecw: integer;
  Path: string;
begin
  sx:=(Poly0.X mod 256);
  sy:=(Poly0.Y mod 256);
  ex:=(Poly1.X mod 256);
  ey:=(Poly1.Y mod 256);
  try
    ecw:=TECWWrite.Create;
    btmm:=TBitmap32.Create;
    btmh:=TBitmap32.Create;
    btmm.Width:=256;
    btmm.Height:=256;
    btmh.Width:=256;
    btmh.Height:=256;
    getmem(Rarr,256*sizeof(PRow));
    for k:=0 to 255 do getmem(Rarr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
    getmem(Garr,256*sizeof(PRow));
    for k:=0 to 255 do getmem(Garr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
    getmem(Barr,256*sizeof(PRow));
    for k:=0 to 255 do getmem(Barr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
    FProgress.ProgressBar1.Max:=Poly1.y-Poly0.y;
    prStr1:=SAS_STR_Resolution+': '+inttostr((poly1.x-poly0.x))+'x'+inttostr((poly1.y-poly0.y));
    Synchronize(UpdateProgressFormStr1);
    Datum := 'EPSG:' + IntToStr(FTypeMap.GeoConvert.GetDatumEPSG);
    Proj := 'EPSG:' + IntToStr(FTypeMap.GeoConvert.GetProjectionEPSG);
    Units := FTypeMap.GeoConvert.GetCellSizeUnits;
    CalculateWFileParams(FTypeMap.GeoConvert.PixelPos2LonLat(Poly0, FZoom - 1),FTypeMap.GeoConvert.PixelPos2LonLat(Poly1, FZoom - 1),
    Poly1.X-Poly0.X,Poly1.y-Poly0.y,FTypeMap.GeoConvert,CellIncrementX,CellIncrementY,OriginX,OriginY);
    errecw:=ecw.Encode(FCurrentFileName,Poly1.X-Poly0.X,Poly1.y-Poly0.y,101-Fsaveas.QualitiEdit.Value, COMPRESS_HINT_BEST, ReadLineECW, IsCancel, nil,
    Datum,Proj,Units,CellIncrementX,CellIncrementY,OriginX,OriginY);
    if (errecw>0)and(errecw<>52) then begin
      path:=FTypeMap.GetTileShowName(LastXY.x, LastXY.Y, FZoom);
      Message_:=SAS_ERR_Save+' '+SAS_ERR_Code+inttostr(errecw)+#13#10+path;
      Synchronize(SynShowMessage);
    end;
  finally
    {$IFDEF VER80}
      for k:=0 to 255 do freemem(Rarr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
      freemem(Rarr,256*((Poly1.X-Poly0.X+1)*sizeof(byte)));
      for k:=0 to 255 do freemem(Garr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
      freemem(Garr,256*((Poly1.X-Poly0.X+1)*sizeof(byte)));
      for k:=0 to 255 do freemem(Barr[k],(Poly1.X-Poly0.X+1)*sizeof(byte));
      freemem(Barr,256*((Poly1.X-Poly0.X+1)*sizeof(byte)));
    {$ELSE}
      for k:=0 to 255 do freemem(Rarr[k]);
      FreeMem(Rarr);
      for k:=0 to 255 do freemem(Garr[k]);
      FreeMem(Garr);
      for k:=0 to 255 do freemem(Barr[k]);
      FreeMem(Barr);
    {$ENDIF}
    btmm.Free;
    btmh.Free;
    ecw.Free;
  end;
end;

procedure TThreadScleit.Save_BMP;
var
  k: integer;
begin
  sx:=(Poly0.X mod 256);
  sy:=(Poly0.Y mod 256);
  ex:=(Poly1.X mod 256);
  ey:=(Poly1.Y mod 256);
  try
    btmm:=TBitmap32.Create;
    btmh:=TBitmap32.Create;
    btmm.Width:=256;
    btmm.Height:=256;
    btmh.Width:=256;
    btmh.Height:=256;
    getmem(Array256BGR,256*sizeof(P256ArrayBGR));
    for k:=0 to 255 do getmem(Array256BGR[k],(Poly1.X-Poly0.X+1)*3);
    FProgress.ProgressBar1.Max:=Poly1.y-Poly0.y;
    prStr1:=SAS_STR_Resolution+': '+inttostr((poly1.x-poly0.x))+'x'+inttostr((poly1.y-poly0.y));
    Synchronize(UpdateProgressFormStr1);
    SaveBMP(Poly1.X-Poly0.X,Poly1.y-Poly0.y, FCurrentFileName, ReadLineBMP, IsCancel);
  finally
    {$IFDEF VER80}
      for k:=0 to 255 do freemem(Array256BGR[k],(Poly1.X-Poly0.X+1)*3);
      freemem(Array256BGR,256*((Poly1.X-Poly0.X+1)*3));
    {$ELSE}
      for k:=0 to 255 do freemem(Array256BGR[k]);
      FreeMem(Array256BGR);
    {$ENDIF}
    btmm.Free;
    btmh.Free;
    ecw.Free;
  end;
end;

procedure TThreadScleit.Save_JPG;
var
  iNChannels, iWidth, iHeight: integer;
  k: integer;
  jcprops: TJPEG_CORE_PROPERTIES;
begin
  sx:=(Poly0.X mod 256);
  sy:=(Poly0.Y mod 256);
  ex:=(Poly1.X mod 256);
  ey:=(Poly1.Y mod 256);
  iWidth  := poly1.x-poly0.x;
  iHeight := poly1.y-poly0.y;
  try
    getmem(Array256BGR,256*sizeof(P256ArrayBGR));
    for k:=0 to 255 do getmem(Array256BGR[k],(iWidth+1)*3);
    FProgress.ProgressBar1.Max:=Poly1.y-Poly0.y;
    prStr1:=SAS_STR_Resolution+': '+inttostr(iWidth)+'x'+inttostr(iHeight);
    Synchronize(UpdateProgressFormStr1);
    btmm:=TBitmap32.Create;
    btmh:=TBitmap32.Create;
    btmm.Width:=256;
    btmm.Height:=256;
    btmh.Width:=256;
    btmh.Height:=256;
    ijlInit(@jcprops);
    iNChannels := 3;
    jcprops.DIBWidth := iWidth;
    jcprops.DIBHeight := -iHeight;
    jcprops.DIBChannels := iNChannels;
    jcprops.DIBColor := IJL_BGR;
    jcprops.DIBPadBytes := ((((iWidth*iNChannels)+3) div 4)*4)-(iWidth*3);
    new(jcprops.DIBBytes);
    GetMem(jcprops.DIBBytes,(iWidth*3+ (iWidth mod 4))*iHeight);
    if jcprops.DIBBytes<>nil then begin
      for k:=0 to iHeight-1 do begin
        ReadLineBMP(k,Pointer(integer(jcprops.DIBBytes)+(((iWidth*3+ (iWidth mod 4))*iHeight)-(iWidth*3+ (iWidth mod 4))*(k+1))));
        if not(Fprogress.Visible) then break;
      end;
    end else begin
      Message_:=SAS_ERR_Memory;
      Synchronize(SynShowMessage);
      exit;
    end;
    jcprops.JPGFile := PChar(FCurrentFileName);
    jcprops.JPGWidth := iWidth;
    jcprops.JPGHeight := iHeight;
    jcprops.JPGChannels := 3;
    jcprops.JPGColor := IJL_YCBCR;
    jcprops.jquality := FSaveAs.QualitiEdit.Value;
    ijlWrite(@jcprops,IJL_JFILE_WRITEWHOLEIMAGE);
  Finally
    freemem(jcprops.DIBBytes,iWidth*iHeight*3);
    for k:=0 to 255 do freemem(Array256BGR[k],(iWidth+1)*3);
    freemem(Array256BGR,256*((iWidth+1)*3));
    ijlFree(@jcprops);
    btmm.Free;
    btmh.Free;
  end;
end;

end.
