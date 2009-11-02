unit Unit1;
interface
uses
  Windows,
  Registry,
  Messages,
  SysUtils,
  Forms,
  Math,
  ShellApi,
  IniFiles,
  Classes,
  Menus,
  MSHTML,
  Variants,
  ActiveX,
  ComCtrls,
  ShlObj,
  ComObj,
  Graphics,
  StdCtrls,
  OleCtrls,
  Controls,
  Buttons,
  DB,
  DBClient,
  WinInet,
  Dialogs,
  ImgList,
  GR32,
  GR32_Resamplers,
  GR32_Layers,
  GR32_Polygons,
  GR32_Filters,
  GR32_Image,
  TB2Item,
  TB2Dock,
  TB2Toolbar,
  RXSlider,
  EmbeddedWB,
  TB2ExtItems,
  SHDocVw_EWB,
  TB2ToolWindow,
  TBXToolPals,
  EwbCore,
  TBX,
  ZylGPSReceiver,
  ZylCustomGPSReceiver,
  PNGimage,
  MidasLib,
  ImgMaker,
  t_LoadEvent,
  u_GeoToStr,
  UThreadScleit,
  Ugeofun,
  UWikiLayer,
  ULogo,
  UMapType,
  UThreadExport,
  UResStrings,
  UFillingMap,
  u_MemFileCache,
  u_TileDownloaderUI,
  t_GeoTypes;

type
  TTileSource = (tsInternet,tsCache,tsCacheInternet);

  TArrLL = array [0..0] of TExtendedPoint;
  PArrLL = ^TArrLL;

  TAOperation = (
    ao_movemap,
    ao_add_line ,
    ao_add_poly,
    ao_add_point,
    ao_line,
    ao_rect,
    ao_reg
  );

  TFmain = class(TForm)
    map: TImage32;
    PopupMenu1: TPopupMenu;
    NaddPoint: TMenuItem;
    N15: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N11: TMenuItem;
    N24: TMenuItem;
    Nopendir: TMenuItem;
    N25: TMenuItem;
    NDel: TMenuItem;
    TBImageList1: TTBImageList;
    N28: TMenuItem;
    N012: TMenuItem;
    N022: TMenuItem;
    N032: TMenuItem;
    N042: TMenuItem;
    N052: TMenuItem;
    N062: TMenuItem;
    N072: TMenuItem;
    N082: TMenuItem;
    N091: TMenuItem;
    N101: TMenuItem;
    N111: TMenuItem;
    N121: TMenuItem;
    N131: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    N171: TMenuItem;
    N181: TMenuItem;
    N191: TMenuItem;
    N201: TMenuItem;
    N211: TMenuItem;
    N221: TMenuItem;
    N231: TMenuItem;
    N241: TMenuItem;
    N30: TMenuItem;
    Google1: TMenuItem;
    N43: TMenuItem;
    TBImageList2: TTBImageList;
    OpenDialog1: TOpenDialog;
    YaLink: TMenuItem;
    kosmosnimkiru1: TMenuItem;
    N51: TMenuItem;
    DataSource1: TDataSource;
    NMarkDel: TMenuItem;
    NMarkEdit: TMenuItem;
    NMarkSep: TMenuItem;
    NMarkOper: TMenuItem;
    livecom1: TMenuItem;
    N13: TMenuItem;
    ImageAtlas1: TMenuItem;
    SaveDialog1: TSaveDialog;
    N26: TMenuItem;
    N27: TMenuItem;
    DigitalGlobe1: TMenuItem;
    ldm: TMenuItem;
    dlm: TMenuItem;
    GPSReceiver: TZylGPSReceiver;
    SaveLink: TSaveDialog;
    DSKategory: TDataSource;
    CDSKategory: TClientDataSet;
    CDSmarks: TClientDataSet;
    CDSKategoryid: TAutoIncField;
    CDSKategoryname: TStringField;
    CDSKategoryvisible: TBooleanField;
    CDSKategoryAfterScale: TSmallintField;
    CDSKategoryBeforeScale: TSmallintField;
    CDSmarksid: TAutoIncField;
    CDSmarksname: TStringField;
    CDSmarksdescr: TMemoField;
    CDSmarksscale1: TIntegerField;
    CDSmarksscale2: TIntegerField;
    CDSmarkslonlatarr: TBlobField;
    CDSmarkslonL: TFloatField;
    CDSmarkslatT: TFloatField;
    CDSmarksLonR: TFloatField;
    CDSmarksLatB: TFloatField;
    CDSmarkscolor1: TIntegerField;
    CDSmarkscolor2: TIntegerField;
    CDSmarksvisible: TBooleanField;
    CDSmarkspicname: TStringField;
    CDSmarkscategoryid: TIntegerField;
    NSRTM3: TMenuItem;
    N47: TMenuItem;
    N49: TMenuItem;
    NGTOPO30: TMenuItem;
    NMarkNav: TMenuItem;
    TBDock: TTBXDock;
    TBMainToolBar: TTBXToolbar;
    TBDockBottom: TTBXDock;
    TBDockLeft: TTBXDock;
    SrcToolbar: TTBXToolbar;
    TBMarksToolbar: TTBXToolbar;
    GPSToolbar: TTBXToolbar;
    TBControlItem3: TTBControlItem;
    Label1: TLabel;
    TBExit: TTBXToolbar;
    ZoomToolBar: TTBXToolbar;
    TBControlItem1: TTBControlItem;
    RxSlider1: TRxSlider;
    TBControlItem2: TTBControlItem;
    labZoom: TLabel;
    TBEditPath: TTBXToolbar;
    TBDockRight: TTBXDock;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXMainMenu: TTBXToolbar;
    NSMB: TTBXSubmenuItem;
    NLayerSel: TTBXSubmenuItem;
    NOperations: TTBXSubmenuItem;
    NView: TTBXSubmenuItem;
    NSources: TTBXSubmenuItem;
    NMarks: TTBXSubmenuItem;
    NGPS: TTBXSubmenuItem;
    NParams: TTBXSubmenuItem;
    NLayerParams: TTBXSubmenuItem;
    NHelp: TTBXSubmenuItem;
    PopupMSmM: TTBXPopupMenu;
    NSubMenuSmItem: TTBXSubmenuItem;
    NMMtype_0: TTBXItem;
    NMarksCalcs: TMenuItem;
    NMarksCalcsLen: TMenuItem;
    NMarksCalcsSq: TMenuItem;
    NMarksCalcsPer: TMenuItem;
    TBXToolWindow1: TTBXToolWindow;
    TreeView1: TTreeView;
    SpeedButton1: TSpeedButton;
    MemoObjectInfo: TMemo;
    WebBrowser1: TEmbeddedWB;
    ImageList1: TImageList;
    N1: TMenuItem;
    NMapInfo: TMenuItem;
    TBImageList1_24: TTBImageList;
    PMNRObject: TPopupMenu;
    NGoHim: TMenuItem;
    NSRCic: TTBXItem;
    NSRCinet: TTBXItem;
    NSRCesh: TTBXItem;
    TBAdd_Point: TTBXItem;
    TBAdd_Line: TTBXItem;
    TBAdd_Poly: TTBXItem;
    TBItem6: TTBXItem;
    TBGPSconn: TTBXItem;
    TBGPSPath: TTBXSubmenuItem;
    TBGPSToPoint: TTBXItem;
    TBSrc: TTBXSubmenuItem;
    TBSMB: TTBXSubmenuItem;
    TBLayerSel: TTBXSubmenuItem;
    ImagesSrc24: TTBImageList;
    MapIcons24: TTBImageList;
    MapIcons18: TTBImageList;
    TBFullSize: TTBXItem;
    TBmove: TTBXItem;
    TBCalcRas: TTBXItem;
    TBRectSave: TTBXSubmenuItem;
    TBMapZap: TTBXSubmenuItem;
    TBGoTo: TTBXSubmenuItem;
    TBEditItem2: TTBEditItem;
    TBEditItem1: TTBEditItem;
    EditGoogleSrch: TTBEditItem;
    TBZoomIn: TTBXItem;
    TBZoom_out: TTBXItem;
    N35: TTBXItem;
    NZoomIn: TTBXItem;
    NZoomOut: TTBXItem;
    N14: TTBXItem;
    NCalcRast: TTBXItem;
    N6: TTBXItem;
    TBEditPathDel: TTBXItem;
    TBEditPathLabel: TTBXItem;
    TBEditPathSave: TTBXItem;
    TBEditPathOk: TTBXItem;
    TBEditPathMarsh: TTBXSubmenuItem;
    TBItem8: TTBXItem;
    TBItem9: TTBXItem;
    TBItem7: TTBXItem;
    TBItem3: TTBXItem;
    TBItem5: TTBXItem;
    TBItemDelTrack: TTBXItem;
    NFoolSize: TTBXItem;
    NGoToCur: TTBXItem;
    Nbackload: TTBXItem;
    NbackloadLayer: TTBXItem;
    Nanimate: TTBXItem;
    NCiclMap: TTBXItem;
    N32: TTBXItem;
    Ninvertcolor: TTBXItem;
    N4: TTBXSubmenuItem;
    N31: TTBXSubmenuItem;
    NFillMap: TTBXSubmenuItem;
    TBFillingTypeMap: TTBXSubmenuItem;
    TBfillMapAsMain: TTBXItem;
    TBXToolPalette1: TTBXToolPalette;
    NShowGran: TTBXSubmenuItem;
    N40: TTBXSubmenuItem;
    NGShScale0: TTBXItem;
    NGShScale1000000: TTBXItem;
    NGShScale500000: TTBXItem;
    NGShScale200000: TTBXItem;
    NGShScale100000: TTBXItem;
    NGShScale50000: TTBXItem;
    NGShScale25000: TTBXItem;
    NGShScale10000: TTBXItem;
    N29: TTBXItem;
    N16: TTBXItem;
    NGoToSite: TTBXItem;
    NGoToForum: TTBXItem;
    NMapParams: TTBXItem;
    N8: TTBXItem;
    TBLang: TTBXSubmenuItem;
    TBXLangRus: TTBXItem;
    TBXLangEng: TTBXItem;
    NGPSconn: TTBXItem;
    NGPSPath: TTBXItem;
    NGPSToPoint: TTBXItem;
    NSaveTreck: TTBXItem;
    N36: TTBXItem;
    N39: TTBXItem;
    NMainToolBarShow: TTBXItem;
    NZoomToolBarShow: TTBXItem;
    NsrcToolBarShow: TTBXItem;
    NGPSToolBarShow: TTBXItem;
    NMarksBarShow: TTBXItem;
    Showstatus: TTBXItem;
    ShowMiniMap: TTBXItem;
    ShowLine: TTBXItem;
    N000: TTBXItem;
    N001: TTBXItem;
    N002: TTBXItem;
    N003: TTBXItem;
    N004: TTBXItem;
    N005: TTBXItem;
    N006: TTBXItem;
    N007: TTBXItem;
    TBRECT: TTBXItem;
    TBREGION: TTBXItem;
    TBCOORD: TTBXItem;
    TBPrevious: TTBXItem;
    TBLoadSelFromFile: TTBXItem;
    TBXExit: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    N38: TTBXSubmenuItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    TBXSeparatorItem10: TTBXSeparatorItem;
    TBXSeparatorItem11: TTBXSeparatorItem;
    TBXSeparatorItem12: TTBXSeparatorItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    TBXSeparatorItem14: TTBXSeparatorItem;
    TBXSeparatorItem15: TTBXSeparatorItem;
    procedure FormActivate(Sender: TObject);
    procedure NzoomInClick(Sender: TObject);
    procedure NZoomOutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TBZoom_outClick(Sender: TObject);
    procedure TBZoomInClick(Sender: TObject);
    procedure TBmoveClick(Sender: TObject);
    procedure TBFullSizeClick(Sender: TObject);
    procedure RxSlider1Change(Sender: TObject);
    procedure NCalcRastClick(Sender: TObject);
    procedure NFoolSizeClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure ZoomToolBarDockChanging(Sender: TObject; Floating: Boolean; DockingTo: TTBDock);
    procedure N8Click(Sender: TObject);
    procedure TBmap1Click(Sender: TObject);
    procedure NbackloadClick(Sender: TObject);
    procedure NaddPointClick(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure NopendirClick(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure NDelClick(Sender: TObject);
    procedure TBREGIONClick(Sender: TObject);
    procedure NShowGranClick(Sender: TObject);
    procedure NFillMapClick(Sender: TObject);
    procedure ThreadDone(Sender: TObject);
    procedure NSRCinetClick(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure TBRECTClick(Sender: TObject);
    procedure TBRectSaveClick(Sender: TObject);
    procedure TBPreviousClick(Sender: TObject);
    procedure TBCalcRasClick(Sender: TObject);
    procedure NCiclMapClick(Sender: TObject);
    procedure N012Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure NMainToolBarShowClick(Sender: TObject);
    procedure NZoomToolBarShowClick(Sender: TObject);
    procedure NsrcToolBarShowClick(Sender: TObject);
    procedure EditGoogleSrchAcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
    procedure TBSubmenuItem1Click(Sender: TObject);
    procedure TBMainToolBarClose(Sender: TObject);
    procedure N000Click(Sender: TObject);
    procedure TBItem2Click(Sender: TObject);
    procedure TBGPSconnClick(Sender: TObject);
    procedure NGPSToolBarShowClick(Sender: TObject);
    procedure TBGPSPathClick(Sender: TObject);
    procedure TBGPSToPointClick(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure TBCOORDClick(Sender: TObject);
    procedure ShowstatusClick(Sender: TObject);
    procedure ShowMiniMapClick(Sender: TObject);
    procedure ShowLineClick(Sender: TObject);
    procedure NMMtype_0Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure TBItem3Click(Sender: TObject);
    procedure Google1Click(Sender: TObject);
    procedure mapResize(Sender: TObject);
    procedure TBLoadSelFromFileClick(Sender: TObject);
    procedure TBEditItem1AcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
    procedure YaLinkClick(Sender: TObject);
    procedure kosmosnimkiru1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure NinvertcolorClick(Sender: TObject);
    procedure mapDblClick(Sender: TObject);
    procedure TBAdd_PointClick(Sender: TObject);
    procedure TBAdd_LineClick(Sender: TObject);
    procedure TBAdd_PolyClick(Sender: TObject);
    procedure TBItem5Click(Sender: TObject);
    procedure NMarkEditClick(Sender: TObject);
    procedure NMarkDelClick(Sender: TObject);
    procedure NMarksBarShowClick(Sender: TObject);
    procedure NMarkOperClick(Sender: TObject);
    procedure livecom1Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure ImageAtlas1Click(Sender: TObject);
    procedure DigitalGlobe1Click(Sender: TObject);
    procedure RxSlider1Changed(Sender: TObject);
    procedure mapMouseLeave(Sender: TObject);
    procedure GPSReceiver1SatellitesReceive(Sender: TObject);
    procedure GPSReceiverReceive(Sender: TObject);
    procedure GPSReceiverDisconnect(Sender: TObject; const Port: TCommPort);
    procedure GPSReceiverConnect(Sender: TObject; const Port: TCommPort);
    procedure GPSReceiverTimeout(Sender: TObject);
    procedure NMapParamsClick(Sender: TObject);
    procedure mapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure mapMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure mapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure N35Click(Sender: TObject);
    procedure TBItemDelTrackClick(Sender: TObject);
    procedure NGShScale01Click(Sender: TObject);
    procedure TBEditPathDelClick(Sender: TObject);
    procedure TBEditPathLabelClick(Sender: TObject);
    procedure TBEditPathSaveClick(Sender: TObject);
    procedure TBEditPathClose(Sender: TObject);
    procedure NGoToForumClick(Sender: TObject);
    procedure NGoToSiteClick(Sender: TObject);
    procedure TBItem6Click(Sender: TObject);
    procedure NSRTM3Click(Sender: TObject);
    procedure NGTOPO30Click(Sender: TObject);
    procedure NMarkNavClick(Sender: TObject);
    procedure TBEditPathMarshClick(Sender: TObject);
    procedure AdjustFont(Item: TTBCustomItem; Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
    procedure NParamsClick(Sender: TObject);
    procedure TBfillMapAsMainClick(Sender: TObject);
    procedure NMarksCalcsLenClick(Sender: TObject);
    procedure NMarksCalcsSqClick(Sender: TObject);
    procedure NMarksCalcsPerClick(Sender: TObject);
    procedure TBEditPathOkClick(Sender: TObject);
    procedure TBItem1Click(Sender: TObject);
    procedure NMapInfoClick(Sender: TObject);
    procedure TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette;var ACol, ARow: Integer; var AllowChange: Boolean);
    procedure WebBrowser1Authenticate(Sender: TCustomEmbeddedWB; var hwnd: HWND; var szUserName, szPassWord: WideString; var Rezult: HRESULT);
    procedure NanimateClick(Sender: TObject);
    procedure NbackloadLayerClick(Sender: TObject);
  private
   ShowActivHint:boolean;
   HintWindow: THintWindow;
   procedure DoMessageEvent(var Msg: TMsg; var Handled: Boolean);
   procedure WMGetMinMaxInfo(var msg: TWMGetMinMaxInfo);message WM_GETMINMAXINFO;
   procedure Set_lock_toolbars(const Value: boolean);
   procedure Set_TileSource(const Value:TTileSource);
   procedure Set_Pos(const Value:TPoint);
    function GetLoadedPixelRect: TRect;
    function GetVisiblePixelRect: TRect;
    function GetLoadedSizeInPixel: TPoint;
    function GetLoadedSizeInTile: TPoint;
    function GetVisibleTopLeft: TPoint;
    function GetVisibleSizeInPixel: TPoint;
    function GetMapLayerLocationRect: TRect;
    function GetLoadedTopLeft: TPoint;
  protected
   Flock_toolbars:boolean;
   notpaint: boolean;
   rect_dwn: Boolean;
   rect_p2:boolean;
   FTileSource:TTileSource;
   FScreenCenterPos: TPoint;
   LayerStatBar: TBitmapLayer;
   dWhenMovingButton:integer;
   LenShow: boolean;
   RectWindow:TRect;
   FUIDownLoader: TTileDownloaderUI;
  public
   LayerMap,LayerMapWiki,LayerMapMarks,LayerMapScale,layerLineM,LayerMapNal,LayerMapGPS: TBitmapLayer;
   MapMoving: Boolean;
   MapZoomAnimtion: Integer;
   change_scene:boolean;
   ProgramStart: Boolean;
   ProgramClose: Boolean;
   aoper:TAOperation;
   FillingMap:TFillingMap;
   property lock_toolbars:boolean read Flock_toolbars write Set_lock_toolbars;
   property TileSource:TTileSource read FTileSource write Set_TileSource;
   property ScreenCenterPos: TPoint read FScreenCenterPos write Set_Pos;
   procedure generate_im(lastload:TLastLoad;err:string);
   function  toSh:string;
class   function  X2AbsX(Ax:integer;Azoom:byte):integer;
   procedure topos(LL:TExtendedPoint;zoom_:byte;draw:boolean);
   procedure zooming(x:byte;move:boolean);
class   function  timezone(lon,lat:real):TDateTime;
   procedure drawLineCalc;
   procedure drawPath(pathll:TExtendedPointArray; new:boolean;color1,color2:TColor32;linew:integer;poly:boolean);
   procedure drawReg;
   procedure generate_mapzap;
   procedure draw_point;
class   function  str2r(inp:string):real;
   procedure paint_Line;
   procedure selectMap(num:TMapType);
   procedure generate_granica;
   procedure drawLineGPS;
   procedure ShowCaptcha(URL:string);
   procedure drawRect(Shift:TShiftState);
   procedure ShowErrScript(DATA:string);
   procedure setalloperationfalse(newop:TAOperation);
class   procedure insertinpath(pos:integer);
class   procedure delfrompath(pos:integer);
   procedure DrawGenShBorders;
   procedure LayerMinMapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure LayerMinMapMouseUP(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure LayerMinMapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
   procedure SetStatusBarVisible();
   procedure SetLineScaleVisible(visible:boolean);
   procedure SetMiniMapVisible(visible:boolean);

   function VisiblePixel2MapPixel(Pnt: TPoint): TPoint; overload;
   function VisiblePixel2MapPixel(Pnt: TExtendedPoint): TExtendedPoint; overload;
   function MapPixel2VisiblePixel(Pnt: TPoint): TPoint; overload;
   function MapPixel2VisiblePixel(Pnt: TExtendedPoint): TExtendedPoint; overload;

   function LoadedPixel2MapPixel(Pnt: TPoint): TPoint; overload;
   function LoadedPixel2MapPixel(Pnt: TExtendedPoint): TExtendedPoint; overload;
   function MapPixel2LoadedPixel(Pnt: TPoint): TPoint; overload;
   function MapPixel2LoadedPixel(Pnt: TExtendedPoint): TExtendedPoint; overload;

   property VisibleTopLeft: TPoint read GetVisibleTopLeft;
   property VisibleSizeInPixel: TPoint read GetVisibleSizeInPixel;
   property VisiblePixelRect: TRect read GetVisiblePixelRect;

   property LoadedTopLeft: TPoint read GetLoadedTopLeft;
   property LoadedPixelRect: TRect read GetLoadedPixelRect;
   property LoadedSizeInTile: TPoint read GetLoadedSizeInTile;
   property LoadedSizeInPixel: TPoint read GetLoadedSizeInPixel;
   property MapLayerLocationRect: TRect read GetMapLayerLocationRect;
  end;

  TGPSpar = record
   speed:real;
   len:extended;
   sspeed:real;
   maxspeed:real;
   nap:integer;
  end;

  TNavOnMark = class
   id:integer;
   ll:TExtendedPoint;
   width:integer;
   public
   procedure draw;
  end;

const
  SASVersion='91026';
  CProgram_Lang_Default = LANG_RUSSIAN;
//  ENU=LANG_ENGLISH;
//  RUS=LANG_RUSSIAN;// $00000419;
  D2R: Double = 0.017453292519943295769236907684886;// ��������� ��� �������������� �������� � �������
  R2D: Double = 57.295779513082320876798154814105; // ��������� ��� �������������� ������ � �������
  zoom:array [1..24] of longint = (256,512,1024,2048,4096,8192,16384,32768,65536,
                                   131072,262144,524288,1048576,2097152,4194304,
                                   8388608,16777216,33554432,67108864,134217728,
                                   268435456,536870912,1073741824,2147483647);
  GSHprec=100000000;

var
  Fmain:TFmain;
  PWL:TResObj;

  zoom_line,
  poly_zoom_save:byte;
  marshrutcomment:string;
  mWd2,
  mHd2,
  yhgpx,
  xhgpx,
  hg_x,
  hg_y,
  pr_x,
  pr_y:integer;
  move,m_up,m_m,moveTrue:Tpoint;
  Gspr:TBitmap32;
  movepoint,lastpoint:integer;
  rect_arr:array [0..1] of TextendedPoint;
  length_arr,add_line_arr,reg_arr,poly_save:TExtendedPointArray;
  curBuf:TCursor;
  nilLastLoad:TLastLoad;
  GPSpar:TGPSpar;
  GOToSelIcon:TBitmap32;
  NavOnMark:TNavOnMark;

  function c_GetTempPath: string;
  procedure CopyStringToClipboard(s: Widestring);
  procedure CopyBtmToClipboard(btm:TBitmap);
  function GetStreamFromURL(var ms:TMemoryStream;url:string;conttype:string):integer;
  function EncodeDG(S: string): string;
  function Encode64(S: string): string;
  function URLDecode(const S: string): string;
  function URLEncode(const S: string): string;

implementation
uses
  StrUtils,
  DateUtils,
  Types,
  t_CommonTypes,
  u_GlobalState,
  u_MiniMap,
  Unit2,
  UAbout,
  Usettings,
  USaveas,
  UProgress,
  UaddPoint,
  Unit4,
  USelLonLat,
  UImgFun,
  UtimeZones,
  UaddLine,
  UaddPoly,
  UEditMap,
  Ubrowser,
  UMarksExplorer,
  UFDGAvailablePic,
  USearchResult,
  UImport,
  UAddCategory,
  u_TileDownloaderUIOneTile;

{$R *.dfm}
procedure TFMain.Set_Pos(const Value:TPoint);
begin
 FScreenCenterPos:=Value;
end;

function GetClipboardText(Wnd: HWND; var Str: string): Boolean;
var
  hData: HGlobal;
begin
  Result := True;
  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_TEXT);
      if hData <> 0 then
      begin
        try
          SetString(Str, PChar(GlobalLock(hData)), GlobalSize(hData));
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
      Str := PChar(@Str[1]);
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

procedure TFMain.Set_TileSource(const Value:TTileSource);
begin
 FTileSource:=Value;
 TBSrc.ImageIndex:=integer(Value);
 case Value of
  tsInternet: NSRCinet.Checked:=true;
  tsCache: NSRCesh.Checked:=true;
  tsCacheInternet: NSRCic.Checked:=true;
 end;
 change_scene:=true
end;

procedure TFMain.Set_lock_toolbars(const Value: boolean);
begin
 TBDock.AllowDrag:=not value;
 TBDockLeft.AllowDrag:=not value;
 TBDockRight.AllowDrag:=not value;
 TBDockBottom.AllowDrag:=not value;
 Flock_toolbars:=value;
end;

procedure TNavOnMark.draw;
var Polygon:TPolygon32;
    ke,ks:TExtendedPoint;
    pe:TPoint;
    dl:integer;
    r,TanOfAngle,D,Angle:Extended;
begin
 Polygon := TPolygon32.Create;
 Polygon.Antialiased := true;
 polygon.AntialiasMode:=am4times;

  ke:=sat_map_both.FCoordConverter.LonLat2PixelPosf(ll,GState.zoom_size-1);
  ke := Fmain.MapPixel2LoadedPixel(ke);
  pe:=Point(round(ke.x),round(ke.y));
  ks:=ExtPoint(pr_x,pr_y);
  dl:=GState.GPS_ArrowSize;
  if ks.x=ke.x then TanOfAngle:=MaxExtended/100 * Sign(ks.Y-ke.Y)
               else TanOfAngle:=(ks.Y-ke.Y)/(ks.X-ke.X);
  D:=Sqrt(Sqr(ks.X-ke.X)+Sqr(ks.Y-ke.Y));
  r:=D/2-(dl div 2);
  if mWd2>mHd2 then if R>mHd2 then r:=mHd2-(dl div 2) else
               else if R>mWd2 then r:=mWd2-(dl div 2);
  ke.x:=Round((R*kE.x+(D-R)*kS.X)/D);
  ke.y:=Round((R*kE.y+(D-R)*kS.Y)/D);
  Polygon.Add(FixedPoint(round(ke.X),round(ke.Y)));
  Angle:=ArcTan(TanOfAngle)+0.28;
  if ((TanOfAngle<0)and(ks.X<=ke.X))or((TanOfAngle>=0)and(ks.X<ke.X)) then Angle:=Angle+Pi;
  Polygon.Add(FixedPoint(round(ke.x) + Round(dl*Cos(Angle)),round(ke.Y) + Round(dl*Sin(Angle))));
  Angle:=ArcTan(TanOfAngle)-0.28;
  if ((TanOfAngle<0)and(ks.X<=ke.X))or((TanOfAngle>=0)and(ks.X<ke.X)) then Angle:=Angle+Pi;
  Polygon.Add(FixedPoint(round(ke.X) + Round(dl*Cos(Angle)),round(ke.Y) + Round(dl*Sin(Angle))));
  if D>dl
   then Polygon.DrawFill(FMain.LayerMap.Bitmap, SetAlpha(Color32(GState.GPS_ArrowColor), 150))
   else begin
         FMain.LayerMap.Bitmap.VertLine(pe.X,pe.Y-dl div 2,pe.Y+dl div 2,SetAlpha(Color32(GState.GPS_ArrowColor), 150));
         FMain.LayerMap.Bitmap.HorzLine(pe.X-dl div 2,pe.Y,pe.X+dl div 2,SetAlpha(Color32(GState.GPS_ArrowColor), 150));
        end;
 Polygon.Free;
end;

function DigitToHex(Digit: Integer): Char;
begin
  case Digit of
    0..9: Result := Chr(Digit + Ord('0'));
    10..15: Result := Chr(Digit - 10 + Ord('A'));
    else Result := '0';
  end;
end; // DigitToHex

function EncodeDG(S: string): string;
var i:integer;
begin
 result:=S;
 for i:=1 to length(s) do
  if ord(s[i]) mod 2 = 0 then result[i]:=chr(ord(s[i])+1)
                         else result[i]:=chr(ord(s[i])-1);
end;

function Encode64(S: string): string;
const Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var i,a,x,b: Integer;
begin
 Result:='';
 a:=0;
 b:=0;
 for i := 1 to Length(s) do
  begin
   x:=Ord(s[i]);
   b:=b*256+x;
   a:=a+8;
   while a >= 6 do
    begin
     a := a-6;
     x := b div (1 shl a);
     b := b mod (1 shl a);
     Result := Result + Codes64[x + 1];
    end;
  end;
 if a>0 then Result:=Result+Codes64[(b shl (6-a))+1];
end;

function Decode64(S: string): string;
const Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var i,a,x,b: Integer;
begin
 Result := '';
 a := 0;
 b := 0;
 for i := 1 to Length(s) do
  begin
   x := System.Pos(s[i], codes64) - 1;
   if x>=0 then begin
                 b := b * 64 + x;
                 a := a + 6;
                 if a >= 8 then
                  begin
                   a := a - 8;
                   x := b shr a;
                   b := b mod (1 shl a);
                   x := x mod 256;
                   Result := Result + chr(x);
                  end;
               end
           else Exit;
   end;
end;

function URLEncode(const S: string): string;
var i, idx, len: Integer;
begin
  len := 0;
  for i := 1 to Length(S) do
   if ((S[i] >= '0') and (S[i] <= '9')) or
      ((S[i] >= 'A') and (S[i] <= 'Z')) or
      ((S[i] >= 'a') and (S[i] <= 'z')) or (S[i] = ' ') or
      (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.')
      then len := len + 1
      else len := len + 3;
  SetLength(Result, len);
  idx := 1;
  for i := 1 to Length(S) do
    if S[i] = ' ' then
    begin
      Result[idx] := '+';
      idx := idx + 1;
    end
    else if ((S[i] >= '0') and (S[i] <= '9')) or
    ((S[i] >= 'A') and (S[i] <= 'Z')) or
    ((S[i] >= 'a') and (S[i] <= 'z')) or
    (S[i] = '_') or (S[i] = '*') or (S[i] = '-') or (S[i] = '.') then
    begin
      Result[idx] := S[i];
      idx := idx + 1;
    end
    else
    begin
      Result[idx] := '%';
      Result[idx + 1] := DigitToHex(Ord(S[i]) div 16);
      Result[idx + 2] := DigitToHex(Ord(S[i]) mod 16);
      idx := idx + 3;
    end;
end; // URLEncode

function URLDecode(const S: string): string;
var i, idx, len, n_coded: Integer;
  function WebHexToInt(HexChar: Char): Integer;
  begin
    if HexChar < '0' then
      Result := Ord(HexChar) + 256 - Ord('0')
    else if HexChar <= Chr(Ord('A') - 1) then
      Result := Ord(HexChar) - Ord('0')
    else if HexChar <= Chr(Ord('a') - 1) then
      Result := Ord(HexChar) - Ord('A') + 10
    else Result := Ord(HexChar) - Ord('a') + 10;
  end;
begin
  len := 0;
  n_coded := 0;
  for i := 1 to Length(S) do
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
      if n_coded >= 3 then n_coded := 0;
    end
    else
    begin
      len := len + 1;
      if S[i] = '%' then n_coded := 1;
    end;
  SetLength(Result, len);
  idx := 0;
  n_coded := 0;
  for i := 1 to Length(S) do
    if n_coded >= 1 then
    begin
      n_coded := n_coded + 1;
      if n_coded >= 3 then
      begin
        Result[idx] := Chr((WebHexToInt(S[i - 1]) * 16 + WebHexToInt(S[i])) mod 256);
        n_coded := 0;
      end;
    end
    else
    begin
      idx := idx + 1;
      if S[i] = '%' then n_coded := 1;
      if S[i] = '+' then Result[idx] := ' '
                    else Result[idx] := S[i];
    end;
end;

procedure CopyBtmToClipboard(btm:TBitmap);
var hSourcDC, hDestDC, hBM, hbmOld: THandle;
begin
  hSourcDC := btm.Canvas.Handle;
  hDestDC := CreateCompatibleDC(hSourcDC);
  hBM := CreateCompatibleBitmap(hSourcDC, btm.width, btm.height);
  hbmold:= SelectObject(hDestDC, hBM);
  BitBlt(hDestDC, 0, 0, btm.width, btm.height, hSourcDC, 0, 0, SRCCopy);
  OpenClipBoard(fmain.handle);
  EmptyClipBoard;
  SetClipBoardData(CF_Bitmap, hBM);
  CloseClipBoard;
  SelectObject(hDestDC,hbmold);
  DeleteObject(hbm);
  DeleteDC(hDestDC);
  DeleteDC(hSourcDC);
end;

procedure CopyStringToClipboard(s: Widestring);
var hg: THandle;
    P: PChar;
begin
  if OpenClipboard(FMain.Handle) then
  begin
    try
      EmptyClipBoard;
      hg:=GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, Length(S)+1);
      try
        P:=GlobalLock(hg);
        try
          StrPCopy(P, s);
          SetClipboardData(CF_TEXT, hg);
        finally
          GlobalUnlock(hg);
        end;
      except
        GlobalFree(hg);
        raise
      end;
    finally
      CloseClipboard;
    end;
  end
end;

class procedure TFmain.insertinpath(pos:integer);
begin
 SetLength(add_line_arr,length(add_line_arr)+1);
 CopyMemory(Pointer(integer(@add_line_arr[pos])+sizeOf(TExtendedPoint)),@add_line_arr[pos],(length(add_line_arr)-pos-1)*sizeOf(TExtendedPoint));
end;

function c_GetTempPath: string;
var Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetTempPath(Sizeof(Buffer) - 1,Buffer));
end;

class procedure TFmain.delfrompath(pos:integer);
begin
 CopyMemory(@add_line_arr[pos],Pointer(integer(@add_line_arr[pos])+sizeOf(TExtendedPoint)),(length(add_line_arr)-pos-1)*sizeOf(TExtendedPoint));
 SetLength(add_line_arr,length(add_line_arr)-1);
 Dec(lastpoint);
end;

procedure TFmain.setalloperationfalse(newop:TAOperation);
begin
 if aoper=newop then newop:=ao_movemap;
 LayerMapNal.Bitmap.Clear(clBlack);
 marshrutcomment:='';
 LayerMapNal.Visible:=newop<>ao_movemap;
 TBmove.Checked:=newop=ao_movemap;
 TBCalcRas.Checked:=newop=ao_line;
 TBRectSave.Checked:=(newop=ao_reg)or(newop=ao_rect);
 TBAdd_Point.Checked:=newop=ao_Add_Point;
 TBAdd_Line.Checked:=newop=ao_Add_line;
 TBAdd_Poly.Checked:=newop=ao_Add_Poly;
 TBEditPath.Visible:=false;
 TBEditPathSave.Visible:=(newop=ao_Add_line)or(newop=ao_Add_Poly);
 TBEditPathOk.Visible:=(newop=ao_reg);
 TBEditPathLabel.Visible:=(newop=ao_line);
 TBEditPathMarsh.Visible:=(newop=ao_Add_line);
 rect_dwn:=false;
 setlength(length_arr,0);
 setlength(add_line_arr,0);
 setlength(reg_arr,0);
 rect_p2:=false;
 lastpoint:=-1;
 case newop of
  ao_movemap:  map.Cursor:=crDefault;
  ao_line:     map.Cursor:=2;
  ao_reg,ao_rect: map.Cursor:=crDrag;
  ao_Add_Point,ao_Add_Poly,ao_Add_Line: map.Cursor:=4;
 end;
 aoper:=newop;
end;

procedure TFmain.ShowCaptcha(URL:string);
begin
 ShellExecute(Handle, nil, PChar(URL), nil, nil, SW_RESTORE);
end;

//��������� ������� ������� � ��������
procedure TFmain.DoMessageEvent(var Msg: TMsg; var Handled: Boolean);
var z:integer;
    POSb:TPoint;
    dWMB:integer;
begin

 if Active then
  case Msg.message of
   WM_MOUSEWHEEL:if MapZoomAnimtion=0 then
                 begin
                  m_m:=moveTrue;
                  if GState.MouseWheelInv then z:=-1 else z:=1;
                  if Msg.wParam<0 then zooming(GState.Zoom_size-(1*z),NGoToCur.Checked)
                                  else zooming(GState.Zoom_size+(1*z),NGoToCur.Checked);
                 end;
   WM_KEYFIRST: begin
                 POSb:=ScreenCenterPos;
                 if (dWhenMovingButton<35) then begin
                  inc(dWhenMovingButton);
                 end;
                 dWMB:=trunc(Power(dWhenMovingButton,1.5));
                 if Msg.wParam=VK_RIGHT then ScreenCenterPos := Point(ScreenCenterPos.x+dWMB, ScreenCenterPos.y);
                 if Msg.wParam=VK_Left then ScreenCenterPos := Point(ScreenCenterPos.x-dWMB, ScreenCenterPos.y);
                 if Msg.wParam=VK_Down then ScreenCenterPos := Point(ScreenCenterPos.x, ScreenCenterPos.y+dWMB);
                 if Msg.wParam=VK_Up then ScreenCenterPos := Point(ScreenCenterPos.x, ScreenCenterPos.y-dWMB);
                 if (Msg.wParam=VK_RIGHT)or(Msg.wParam=VK_Left)or
                    (Msg.wParam=VK_Down)or(Msg.wParam=VK_Up)then
                    generate_im(nilLastLoad,'');
                end;
   WM_KEYUP:begin
             dWhenMovingButton:=5;
             if (Msg.wParam=VK_Delete)and(aoper=ao_line) then
               begin
                if length(length_arr)>0 then setlength(length_arr,length(length_arr)-1);
                drawLineCalc;
               end;
             if (Msg.wParam=VK_Delete)and(aoper=ao_reg) then
               begin
                if length(reg_arr)>0 then setlength(reg_arr,length(reg_arr)-1);
                drawReg;
               end;
             if (Msg.wParam=VK_Delete)and(aoper in [ao_add_line,ao_add_poly]) then
              if length(add_line_arr)>0 then
               begin
                delfrompath(lastpoint);
                drawPath(add_line_arr,true,SetAlpha(ClRed32, 150),SetAlpha(ClWhite32, 50),3,aoper=ao_add_poly);
               end;
             if (Msg.wParam=VK_ESCAPE)and(aoper=ao_Reg) then
              if length(reg_arr)=0 then TBmoveClick(self)
                                   else begin
                                         setlength(reg_arr,0);
                                         drawreg;
                                        end;
             if (Msg.wParam=VK_ESCAPE)and(aoper=ao_line) then
              if length(length_arr)=0 then TBmoveClick(self)
                                      else begin
                                            setlength(length_arr,0);
                                            drawLineCalc;
                                           end;
             if (Msg.wParam=VK_ESCAPE)and(aoper=ao_rect) then
              begin
               if rect_dwn then begin
                                 setalloperationfalse(ao_movemap);
                                 setalloperationfalse(ao_rect);
                                end
                           else setalloperationfalse(ao_movemap);
              end;
             if (Msg.wParam=VK_ESCAPE)and(aoper=ao_Add_Point) then setalloperationfalse(ao_movemap);
             if (Msg.wParam=VK_ESCAPE)and(aoper in [ao_add_line,ao_add_poly]) then
               if length(add_line_arr)=0 then setalloperationfalse(ao_movemap)
                                         else begin
                                               setlength(add_line_arr,0);
                                               lastpoint:=-1;
                                               //LayerMapNal.Bitmap.Clear(clBlack);
                                               drawPath(add_line_arr,true,setalpha(clRed32,150),setalpha(clWhite32,50),3,aoper=ao_add_poly);
                                              end;
             if (Msg.wParam=13)and(aoper=ao_add_Poly)and(length(add_line_arr)>1) then
              begin
               if FaddPoly.show_(add_line_arr,true) then
                begin
                 setalloperationfalse(ao_movemap);
                 generate_im(nilLastLoad,'');
                end; 
              end;
             if (Msg.wParam=13)and(aoper=ao_add_line)and(length(add_line_arr)>1) then
              begin
               if FaddLine.show_(add_line_arr,true) then
                begin
                 setalloperationfalse(ao_movemap);
                 generate_im(nilLastLoad,'');
                end;
              end;
            end;
  end;
end;


class function TFmain.X2AbsX(Ax:integer;Azoom:byte):integer;
begin
 if Ax>=0 then result:=Ax mod zoom[Azoom]
          else result:=zoom[Azoom]+(Ax mod zoom[Azoom])
end;

class function TFmain.str2r(inp:string):real;
var p:integer;
begin
 p:=System.pos(DecimalSeparator,inp);
 if p=0 then begin
              if DecimalSeparator='.' then p:=System.pos(',',inp)
                                      else p:=System.pos('.',inp);
              inp[p]:=DecimalSeparator;
             end;
 result:=strtofloat(inp);
end;

procedure TFmain.ThreadDone(Sender: TObject);
begin
  if not((MapMoving)or(MapZoomAnimtion=1)) then begin
    GState.MainFileCache.Clear;
    generate_im(nilLastLoad,'');
  end;
end;

procedure TFmain.drawRect(Shift:TShiftState);
var i,d256,kz,jj,j,bxy:integer;
    xy1,xy2:TPoint;
    zLonR,zLatR:extended;
    LonLatLT,LonLatRD:TExtendedPoint;
    Poly:  TExtendedPointArray;
begin
  xy1:=sat_map_both.GeoConvert.LonLat2PixelPos(rect_arr[0],GState.zoom_size-1);
  xy2:=sat_map_both.GeoConvert.LonLat2PixelPos(rect_arr[1],GState.zoom_size-1);
  LayerMapNal.Location:=floatrect(MapLayerLocationRect);
  LayerMapNal.Bitmap.Clear(clBlack);
  if (zoom_line in [99,0])or(zoom_line<GState.zoom_size)
   then d256:=256
   else d256:=256 div round(power(2,zoom_line-GState.zoom_size));
  if xy1.x>xy2.x then begin
    bxy:=xy2.x;
    xy2.x:=xy1.x;
    xy1.x:=bxy;
  end;
  if xy1.y>xy2.y then begin
    bxy:=xy2.y;
    xy2.y:=xy1.y;
    xy1.y:=bxy;
  end;
  if (ssCtrl in Shift) then begin
    xy1.x:=(xy1.x-(xy1.x mod d256));
    xy1.y:=(xy1.y-(xy1.y mod d256));
    xy2.x:=((xy2.x+d256)-((xy2.x+d256) mod d256));
    xy2.y:=((xy2.y+d256)-((xy2.y+d256) mod d256));
  end;
  if (ssShift in Shift)and(GState.GShScale>0) then begin
    case GState.GShScale of
      1000000: begin zLonR:=6; zLatR:=4; end;
       500000: begin zLonR:=3; zLatR:=2; end;
       200000: begin zLonR:=1; zLatR:=0.66666666666666666666666666666667; end;
       100000: begin zLonR:=0.5; zLatR:=0.33333333333333333333333333333333; end;
        50000: begin zLonR:=0.25; zLatR:=0.1666666666666666666666666666665; end;
        25000: begin zLonR:=0.125; zLatR:=0.08333333333333333333333333333325; end;
        10000: begin zLonR:=0.0625; zLatR:=0.041666666666666666666666666666625; end;
    end;
    LonLatLT:=sat_map_both.GeoConvert.PixelPos2LonLat(xy1,GState.zoom_size-1);
    LonLatLT.X:=LonLatLT.X-(round(LonLatLT.X*GSHprec) mod round(zLonR*GSHprec))/GSHprec;
    LonLatLT.Y:=LonLatLT.Y-(round(LonLatLT.Y*GSHprec) mod round(zLatR*GSHprec))/GSHprec;
    if LonLatLT.X<0 then LonLatLT.X:=LonLatLT.X-zLonR;
    if LonLatLT.Y>0 then LonLatLT.Y:=LonLatLT.Y+zLatR;
    xy1:=sat_map_both.GeoConvert.LonLat2PixelPos(LonLatLT,GState.zoom_size-1);

    LonLatRD:=sat_map_both.GeoConvert.PixelPos2LonLat(xy2,GState.zoom_size-1);
    LonLatRD.X:=LonLatRD.X-(round(LonLatRD.X*GSHprec) mod round(zLonR*GSHprec))/GSHprec;
    LonLatRD.Y:=LonLatRD.Y-(round(LonLatRD.Y*GSHprec) mod round(zLatR*GSHprec))/GSHprec;
    if LonLatRD.X>=0 then LonLatRD.X:=LonLatRD.X+zLonR;
    if LonLatRD.Y<=0 then LonLatRD.Y:=LonLatRD.Y-zLatR;
    xy2:=sat_map_both.GeoConvert.LonLat2PixelPos(LonLatRD,GState.zoom_size-1);
    if (rect_p2) then
     begin
      SetLength(Poly, 5);
      Poly[0]:=LonLatLT;
      Poly[1]:=extPoint(LonLatRD.X,LonLatLT.Y);
      Poly[2]:=LonLatRD;
      Poly[3]:=extPoint(LonLatLT.X,LonLatRD.Y);
      Poly[4]:=LonLatLT;
      fsaveas.Show_(GState.zoom_size,Poly);
      Poly := nil;
      rect_p2:=false;
      exit;
     end;
  end;
  if (rect_p2) then begin
    SetLength(Poly, 5);
    Poly[0]:=sat_map_both.GeoConvert.PixelPos2LonLat(xy1,GState.zoom_size-1);
    Poly[1]:=sat_map_both.GeoConvert.PixelPos2LonLat(Point(xy2.X,xy1.Y),GState.zoom_size-1);
    Poly[2]:=sat_map_both.GeoConvert.PixelPos2LonLat(xy2,GState.zoom_size-1);
    Poly[3]:=sat_map_both.GeoConvert.PixelPos2LonLat(Point(xy1.X,xy2.Y),GState.zoom_size-1);
    Poly[4]:=sat_map_both.GeoConvert.PixelPos2LonLat(xy1,GState.zoom_size-1);
    fsaveas.Show_(GState.zoom_size, Poly);
    Poly := nil;
    rect_p2:=false;
    exit;
  end;
  if not(rect_dwn) then exit;
  xy1 := MapPixel2LoadedPixel(xy1);
  xy1.x:=xy1.x+1;
  xy1.y:=xy1.y+1;
  xy2 := MapPixel2LoadedPixel(xy2);
  xy2.x:=xy2.x-1;
  xy2.y:=xy2.y-1;

  LayerMapNal.Bitmap.FillRectS(xy1.x,xy1.y,xy2.x,xy2.y,SetAlpha(clWhite32,20));
  LayerMapNal.Bitmap.FrameRectS(xy1.x,xy1.y,xy2.x,xy2.y,SetAlpha(clBlue32,150));
  LayerMapNal.Bitmap.FrameRectS(xy1.x-1,xy1.y-1,xy2.x+1,xy2.y+1,SetAlpha(clBlue32,150));
  kz:=256;
  while kz>=32 do begin
    i:=xy1.x-kz; while ((ScreenCenterPos.X-(pr_x-i))mod kz)<>0 do inc(i);
    j:=xy1.y-kz; while ((ScreenCenterPos.Y-(pr_y-j))mod kz)<>0 do inc(j);
    jj:= round(Log2(kz))-5;
    LayerMapNal.Bitmap.FrameRectS(i-jj,j-jj,i+((xy2.x+kz-i)div kz)*kz+jj,j+((xy2.y+kz-j)div kz)*kz+jj,SetAlpha(RGB(kz-1,kz-1,kz-1),255));
    LayerMapNal.Bitmap.Font.Size:=11;
    LayerMapNal.Bitmap.RenderText(xy2.x-((xy2.x-xy1.x)div 2)-42+jj*26,xy2.y-((xy2.y-xy1.y)div 2)-6,'x'+inttostr(GState.zoom_size+3-jj),3,SetAlpha(RGB(kz-1,kz-1,kz-1),255));
    kz:=kz div 2;
  end;
end;

procedure TFmain.drawReg;
var i:integer;
    k1:TPoint;
    Polygon: TPolygon32;
begin
 LayerMapNal.Location:=floatrect(MapLayerLocationRect);
 TBEditPath.Visible:=(length(reg_arr)>1);
 Polygon := TPolygon32.Create;
 Polygon.Antialiased := true;
 Polygon.AntialiasMode := am32times;
 Polygon.FillMode := pfAlternate;
 with LayerMapNal.Bitmap do begin
   Clear(clBlack);
   Canvas.Pen.Style:=psSolid;
   Canvas.Brush.Color:=ClWhite;
   Canvas.Pen.Width:=1;
   for i:=0 to length(reg_arr)-1 do begin
     k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(reg_arr[i],GState.zoom_size-1);
     k1:=MapPixel2LoadedPixel(k1);
     Polygon.add(FixedPoint(k1.x, k1.Y));
   end;
 end;
 with Polygon.Outline do
  begin
   FillMode := pfWinding;
   with Grow(Fixed(2 / 2), 0.5) do begin
     DrawFill(LayerMapNal.Bitmap, SetAlpha(clBlue32, 180));
     free;
   end;
   free;
  end;
 Polygon.DrawFill(LayerMapNal.Bitmap, SetAlpha(clWhite32, 40));
 if length(reg_arr)>0 then
  begin
   k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(reg_arr[0],GState.zoom_size-1);
   k1:=MapPixel2LoadedPixel(k1);
   k1:=Point(k1.x-3,k1.y-3);
   LayerMapNal.Bitmap.FillRectS(bounds(k1.X,k1.Y,6,6),SetAlpha(ClGreen32,255));
   if length(reg_arr)>1 then begin
     k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(reg_arr[length(reg_arr)-1],GState.zoom_size-1);
     k1:=MapPixel2LoadedPixel(k1);
     k1:=Point(k1.x-3,k1.y-3);
     LayerMapNal.Bitmap.FillRectS(bounds(k1.X,k1.Y,6,6),SetAlpha(ClRed32,255));
   end;
  end;
 Polygon.Free;
end;

procedure TFmain.drawLineGPS;
var i,speed,SizeTrackd2:integer;
    k1,k2:TPoint;
    ke,ks:TExtendedPoint;
    TanOfAngle,Angle,D,R: Currency;
    dl: integer;
    Polygon: TPolygon32;
    s_speed,s_len,n_len:string;
    polygon_line: TPolygon32;
begin
 Polygon := TPolygon32.Create;
 Polygon.Antialiased := true;
 polygon.AntialiasMode:=am4times;
 Polygon_line := TPolygon32.Create;
 Polygon_line.Antialiased := true;
 Polygon_line.AntialiasMode := am4times;
 polygon_line.Closed:=false;
 LayerMapGPS.Bitmap.Canvas.Pen.Style:=psSolid;
 LayerMapGPS.Bitmap.Canvas.Pen.Color:=clBlue;
 LayerMapGPS.Bitmap.Clear(clBlack);
 if length(GState.GPS_ArrayOfSpeed)>3 then
  begin
   GPSpar.speed:=GState.GPS_ArrayOfSpeed[length(GState.GPS_ArrayOfSpeed)-1];
   GPSpar.sspeed:=0;
   GPSpar.maxspeed:=GState.GPS_ArrayOfSpeed[1];
   for i:=3 to length(GState.GPS_ArrayOfSpeed)-1 do
    begin
     GPSpar.sspeed:=GPSpar.sspeed+GState.GPS_ArrayOfSpeed[i];
     if GState.GPS_ArrayOfSpeed[i]>GPSpar.maxspeed then GPSpar.maxspeed:=GState.GPS_ArrayOfSpeed[i];
    end;
   GPSpar.sspeed:=GPSpar.sspeed/(length(GState.GPS_ArrayOfSpeed)-3);
  end;

 with LayerMapGPS.Bitmap do
 if GState.GPS_ShowPath then
 begin
  for i:=0 to length(GState.GPS_TrackPoints)-2 do
   begin
    k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(GState.GPS_TrackPoints[i],GState.zoom_size-1);
    k1:=MapPixel2LoadedPixel(k1);
    k2:=sat_map_both.FCoordConverter.LonLat2PixelPos(GState.GPS_TrackPoints[i+1],GState.zoom_size-1);
    k2:=MapPixel2LoadedPixel(k2);
    if (GState.GPS_ArrayOfSpeed[i]>0)and(GPSpar.maxspeed>0)
      then speed:=round(255/(GPSpar.maxspeed/GState.GPS_ArrayOfSpeed[i]))
      else speed:=0;
    if (k1.x<32767)and(k1.x>-32767)and(k1.y<32767)and(k1.y>-32767) then begin
      polygon_line.Add(FixedPoint(k1));
      polygon_line.Add(FixedPoint(k2));
    end;
    with Polygon_line.Outline do begin
      with Grow(Fixed(GState.GPS_TrackWidth / 2), 0.5) do begin
        DrawFill(LayerMapGPS.Bitmap, SetAlpha(Color32(speed,0,256-speed,0),150));
        free;
      end;
      free;
    end;
    Polygon_line.Clear;
   end;
 end;

 if length(GState.GPS_TrackPoints)>1 then
 try
  ke:=sat_map_both.FCoordConverter.LonLat2PixelPosf(GState.GPS_TrackPoints[length(GState.GPS_TrackPoints)-1],GState.zoom_size-1);
  ke:=MapPixel2LoadedPixel(ke);
  ks:=sat_map_both.FCoordConverter.LonLat2PixelPosf(GState.GPS_TrackPoints[length(GState.GPS_TrackPoints)-2],GState.zoom_size-1);
  ks:=MapPixel2LoadedPixel(ks);

  dl:=GState.GPS_ArrowSize;
  R:=sqrt(sqr(ks.X-ke.X)+sqr(ks.Y-ke.Y))/2-(dl div 2);
  if ks.x=ke.x then TanOfAngle:=MaxExtended/100 * Sign(ks.Y-ke.Y)
               else TanOfAngle:=(ks.Y-ke.Y)/(ks.X-ke.X);
  D:=Sqrt(Sqr(ks.X-ke.X)+Sqr(ks.Y-ke.Y));
  ke.x:=ke.X+(ke.X-ks.X);
  ke.y:=ke.y+(ke.y-ks.y);
  ke.x:=Round((R*ks.x+(D-R)*kE.X)/D);
  ke.y:=Round((R*ks.y+(D-R)*kE.Y)/D);
  Polygon.Add(FixedPoint(round(ke.X),round(ke.Y)));
  Angle:=ArcTan(TanOfAngle)+0.28;
  if ((TanOfAngle<0)and(ks.X<=ke.X))or((TanOfAngle>=0)and(ks.X<ke.X)) then Angle:=Angle+Pi;

  Polygon.Add(FixedPoint(round(ke.x) + Round(dl*Cos(Angle)),round(ke.Y) + Round(dl*Sin(Angle))));
  Angle:=ArcTan(TanOfAngle)-0.28;
  if ((TanOfAngle<0)and(ks.X<=ke.X))or((TanOfAngle>=0)and(ks.X<ke.X)) then Angle:=Angle+Pi;

  Polygon.Add(FixedPoint(round(ke.X) + Round(dl*Cos(Angle)),round(ke.Y) + Round(dl*Sin(Angle))));
  Polygon.DrawFill(LayerMapGPS.Bitmap, SetAlpha(Color32(GState.GPS_ArrowColor), 150));
 except
 end;

 if length(GState.GPS_TrackPoints)>0 then
  begin
   k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(GState.GPS_TrackPoints[length(GState.GPS_TrackPoints)-1],GState.zoom_size-1);
   k1:=MapPixel2LoadedPixel(k1);
   SizeTrackd2:=GState.GPS_ArrowSize div 6;
   LayerMapGPS.Bitmap.FillRectS(k1.x-SizeTrackd2,k1.y-SizeTrackd2,k1.x+SizeTrackd2,k1.y+SizeTrackd2,SetAlpha(clRed32, 200));
  end;

 s_speed:=RoundEx(GPSpar.speed,2)+' ('+RoundEx(GPSpar.sspeed,1)+') '+SAS_UNITS_kmperh;
 LayerStatBar.Bitmap.FillRectS(10,-40,10,-20,SetAlpha(clWhite32, 140));
 LayerMapGPS.Bitmap.FillRectS((pr_x-mWd2)+5,(pr_y-mHd2)+5,(pr_x-mWd2)+round(LayerMapGPS.Bitmap.TextWidthW(s_speed)*1.3),(pr_y-mHd2)+52,SetAlpha(clWhite32, 140));
 LayerMapGPS.Bitmap.Font.Size:=8;
 LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+10,SAS_STR_Speed+':', 0, clBlack32);
 LayerMapGPS.Bitmap.Font.Size:=16;
 LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+24,s_speed, 4, clBlack32);
 s_len := DistToStrWithUnits(GPSpar.len, GState.num_format);
 LayerMapGPS.Bitmap.FillRectS((pr_x-mWd2)+5,(pr_y-mHd2)+59,(pr_x-mWd2)+round(LayerMapGPS.Bitmap.TextWidthW(s_len)*1.3)+5,(pr_y-mHd2)+106,SetAlpha(clWhite32, 140));
 LayerMapGPS.Bitmap.Font.Size:=8;
 LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+64,SAS_STR_LenPath+':', 0, clBlack32);
 LayerMapGPS.Bitmap.Font.Size:=16;
 LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+78,s_len, 4, clBlack32);
 if (NavOnMark<>nil) then
  begin
   n_len:=DistToStrWithUnits(sat_map_both.GeoConvert.CalcDist(GState.GPS_TrackPoints[length(GState.GPS_TrackPoints)-1],NavOnMark.ll), GState.num_format);
   LayerMapGPS.Bitmap.FillRectS((pr_x-mWd2)+5,(pr_y-mHd2)+113,(pr_x-mWd2)+round(LayerMapGPS.Bitmap.TextWidthW(n_len)*1.3)+5,(pr_y-mHd2)+160,SetAlpha(clWhite32, 140));
   LayerMapGPS.Bitmap.Font.Size:=8;
   LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+118,SAS_STR_LenToMark+':', 0, clBlack32);
   LayerMapGPS.Bitmap.Font.Size:=16;
   LayerMapGPS.Bitmap.RenderText((pr_x-mWd2)+10,(pr_y-mHd2)+132,n_len, 4, clBlack32);
  end;
 LayerMapGPS.BringToFront;
 FreeAndNil(Polygon);
 FreeAndNil(Polygon_line);
 toSh;
end;

procedure TFmain.drawPath(pathll:TExtendedPointArray;new:boolean;color1,color2:TColor32;linew:integer;poly:boolean);
var i,adp,j:integer;
    k1,k2,k4:TPoint;
    k3:TextendedPoint;
    polygon: TPolygon32;
begin
 try
 if new then begin
   LayerMapNal.Bitmap.Clear(clBlack);
   TBEditPath.Visible:=(new)and(length(pathll)>1);
 end;
 polygon:=TPolygon32.Create;
 polygon.Antialiased:=true;
 polygon.AntialiasMode:=am4times;
 polygon.Closed:=poly;
 LayerMapNal.Location:=floatrect(GetMapLayerLocationRect);
 map.Bitmap.BeginUpdate;
 if length(pathll)>0 then
  with LayerMap.Bitmap do begin
   for i:=0 to length(pathll)-1 do begin
     k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(pathll[i],GState.zoom_size-1);
     k1:=MapPixel2LoadedPixel(k1);
     if (k1.x<32767)and(k1.x>-32767)and(k1.y<32767)and(k1.y>-32767) then
       polygon.Add(FixedPoint(k1));
     if i<length(pathll)-1 then begin
       k2:=sat_map_both.FCoordConverter.LonLat2PixelPos(pathll[i+1],GState.zoom_size-1);
       k2:=MapPixel2LoadedPixel(k2);
       if (k2.x-k1.x)>(k2.y-k1.y) then adp:=(k2.x-k1.x)div 32767+2
                                  else adp:=(k2.y-k1.y)div 32767+2;
       k3:=extPoint(((k2.X-k1.x)/adp),((k2.y-k1.y)/adp));
       if adp>2 then
         for j:=1 to adp-1 do begin
           k4:=Point(round(k1.x+k3.x*j),round(k1.Y+k3.y*j));
           if(k4.x<32767)and(k4.x>-32767)and(k4.y<32767)and(k4.y>-32767)then polygon.Add(FixedPoint(k4.x,k4.y));
         end;
     end;
   end;
   if poly then if new then Polygon.DrawFill(LayerMapNal.Bitmap, color2)
                       else Polygon.DrawFill(LayerMapMarks.Bitmap, color2);
   with Polygon.Outline do begin
     with Grow(Fixed(linew / 2), 0.5) do begin
       FillMode := pfWinding;
       if new then DrawFill(LayerMapNal.Bitmap, color1)
              else DrawFill(LayerMapMarks.Bitmap, color1);
       free;
     end;
     free;
   end;
   if new then begin
     for i:=1 to length(pathll)-2 do begin
       k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(pathll[i],GState.zoom_size-1);
       k1:=MapPixel2LoadedPixel(k1);
       k1:=Point(k1.x-4,k1.y-4);
       LayerMapNal.Bitmap.FillRectS(bounds(k1.X,k1.y,8,8),SetAlpha(clYellow32,150));
     end;
   end;
  end;

 polygon.Free;
 if (new)and(length(pathll)>0) then begin
   k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(pathll[0],GState.zoom_size-1);
   k1:=MapPixel2LoadedPixel(k1);
   k1:=Point(k1.x-4,k1.y-4);
   LayerMapNal.Bitmap.FillRectS(bounds(k1.X,k1.y,8,8),SetAlpha(ClGreen32,255));
   k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(pathll[length(pathll)-1],GState.zoom_size-1);
   k1:=MapPixel2LoadedPixel(k1);
   k1:=Point(k1.x-4,k1.y-4);
   LayerMapNal.Bitmap.FillRectS(bounds(k1.X,k1.y,8,8),SetAlpha(ClRed32,255));
 end;
 map.Bitmap.endUpdate;
 map.Bitmap.Changed;
 except
 end;
end;


procedure TFmain.drawLineCalc;
var i,j,textW,l,adp:integer;
    k1,k2,k4:TPoint;
    k3:TExtendedPoint;
    len:real;
    text:string;
    polygon: TPolygon32;
begin
 try
 polygon:=TPolygon32.Create;
 polygon.Antialiased:=true;
 polygon.AntialiasMode:=am4times;
 polygon.Closed:=false;
 LayerMapNal.Location:=floatrect(GetMapLayerLocationRect);
 map.Bitmap.BeginUpdate;
 TBEditPath.Visible:=(length(length_arr)>1);
 LayerMapNal.Bitmap.Font.Name:='Tahoma';
 LayerMapNal.Bitmap.Clear(clBlack);
 if length(length_arr)>0 then
 with LayerMapNal.Bitmap do
 begin
  for i:=0 to length(length_arr)-1 do
   begin
    k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[i],GState.zoom_size-1);
    k1:=MapPixel2LoadedPixel(k1);
    if (k1.x<32767)and(k1.x>-32767)and(k1.y<32767)and(k1.y>-32767) then
      polygon.Add(FixedPoint(k1));
    if i<length(length_arr)-1 then
     begin
      k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[i+1],GState.zoom_size-1);
      k1:=MapPixel2LoadedPixel(k1);
      if (k2.x-k1.x)>(k2.y-k1.y) then adp:=(k2.x-k1.x)div 32767+2
                                 else adp:=(k2.y-k1.y)div 32767+2;
      k3:=extPoint(((k2.X-k1.x)/adp),((k2.y-k1.y)/adp));
      if adp>2 then
       for j:=1 to adp-1 do
        begin
         k4:=Point(round(k1.x+k3.x*j),round(k1.Y+k3.y*j));
         if(k4.x<32767)and(k4.x>-32767)and(k4.y<32767)and(k4.y>-32767)then polygon.Add(FixedPoint(k4.x,k4.y));
        end;
     end;
   end;
  with Polygon.Outline do
   begin
    with Grow(Fixed(2.5 / 2), 0.5) do
     begin
      FillMode := pfWinding;
      DrawFill(LayerMapNal.Bitmap, SetAlpha(ClRed32, 150));
      free;
     end;
    free;
   end;
  polygon.Free;
  for i:=0 to length(length_arr)-2 do
   begin
    k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[i],GState.zoom_size-1);
    k1:=MapPixel2LoadedPixel(k1);
    k2:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[i+1],GState.zoom_size-1);
    k2:=MapPixel2LoadedPixel(k2);
    if not((k2.x>0)and(k2.y>0))and((k2.x<xhgpx)and(k2.y<yhgpx))then continue;
    FrameRectS(k2.x-3,k2.y-3,k2.X+3,k2.Y+3,SetAlpha(ClRed32,150));
    FillRectS(k1.x-2,k1.y-2,k1.X+2,k1.y+2,SetAlpha(ClWhite32,150));
    if i=length(length_arr)-2 then
     begin
      len:=0;
      for j:=0 to i do len:=len+sat_map_both.GeoConvert.CalcDist(length_arr[j], length_arr[j+1]);
      text:=SAS_STR_Whole+': '+DistToStrWithUnits(len, GState.num_format);
      Font.Size:=9;
      textW:=TextWidth(text)+11;
      FillRectS(k2.x+12,k2.y,k2.X+textW,k2.y+15,SetAlpha(ClWhite32,110));
      RenderText(k2.X+15,k2.y,text,3,clBlack32);
     end
    else
     if LenShow then
      begin
       text:=DistToStrWithUnits(sat_map_both.GeoConvert.CalcDist(length_arr[i], length_arr[i+1]), GState.num_format);
       LayerMapNal.Bitmap.Font.Size:=7;
       textW:=TextWidth(text)+11;
       FillRectS(k2.x+5,k2.y+5,k2.X+textW,k2.y+16,SetAlpha(ClWhite32,110));
       RenderText(k2.X+8,k2.y+5,text,0,clBlack32);
      end;
   end;
  k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[0],GState.zoom_size-1);
  k1:=MapPixel2LoadedPixel(k1);
  k1:=Point(k1.x-3,k1.y-3);
  FillRectS(bounds(k1.x,k1.y,6,6),SetAlpha(ClGreen32,255));
  k1:=sat_map_both.FCoordConverter.LonLat2PixelPos(length_arr[length(length_arr)-1],GState.zoom_size-1);
  k1:=MapPixel2LoadedPixel(k1);
  k1:=Point(k1.x-3,k1.y-3);
  FillRectS(bounds(k1.x,k1.y,6,6),SetAlpha(ClRed32,255));
 end;
 map.Bitmap.endUpdate;
 map.Bitmap.Changed;
 except
 end;
end;

procedure TFmain.draw_point;
var LLRect:TExtendedRect;
    i:integer;
    xy:Tpoint;
    btm:TBitmap32;
    TestArrLenP1,TestArrLenP2:TPoint;
    arrLL:PArrLL;
    buf_line_arr:TExtendedPointArray;
    ms:TMemoryStream;
    indexmi:integer;
    imw,texth:integer;
    marksFilter:string;
begin                     
 if (GState.show_point = mshNone) then
  begin
   LayerMapMarks.Visible:=false;
   exit;
  end;
  LLRect := sat_map_both.FCoordConverter.PixelRect2LonLatRect(VisiblePixelRect, GState.zoom_size-1);
  marksFilter:='';
 if GState.show_point = mshChecked then
  begin
   CDSKategory.Filter:='visible = 1 and ( AfterScale <= '+inttostr(GState.zoom_size)+' and BeforeScale >= '+inttostr(GState.zoom_size)+' )';
   CDSKategory.Filtered:=true;
   marksFilter:=marksFilter+'visible=1';
   CDSKategory.First;
   if CDSKategory.Eof then begin
                            LayerMapMarks.Visible:=false;
                            CDSKategory.Filtered:=false;
                            exit;
                           end;
   if not(CDSKategory.Eof) then
    begin
     marksFilter:=marksFilter+' and (';
     while not(CDSKategory.Eof) do
      begin
       marksFilter:=marksFilter+'categoryid='+CDSKategory.fieldbyname('id').AsString;
       CDSKategory.Next;
       if not(CDSKategory.Eof) then marksFilter:=marksFilter+' or ';
      end;
     marksFilter:=marksFilter+')';
    end;
   CDSKategory.Filtered:=false;
   marksFilter:=marksFilter+' and ';
  end;
 marksFilter:=marksFilter+'( LonR>'+floattostr(LLRect.Left)+' and LonL<'+floattostr(LLRect.Right)+
              ' and LatB<'+floattostr(LLRect.Top)+' and LatT>'+floattostr(LLRect.Bottom)+')';
 CDSmarks.Filter:=marksFilter;
 CDSmarks.Filtered:=true;
 CDSmarks.First;
 if CDSmarks.Eof then begin
                       LayerMapMarks.Visible:=false;
                       CDSmarks.Filtered:=false;
                       exit;
                      end
                 else begin
                       LayerMapMarks.Bitmap.Clear(clBlack);
                       LayerMapMarks.Location:=floatrect(GetMapLayerLocationRect);
                       LayerMapMarks.Visible:=true;
                      end;
 btm:=TBitmap32.Create;
 btm.DrawMode:=dmBlend;
 btm.Resampler:=TLinearResampler.Create;
 While not(CDSmarks.Eof) do
  begin
     ms:=TMemoryStream.Create;
     TBlobField(CDSmarksLonLatArr).SaveToStream(ms);
     ms.Position:=0;
     GetMem(arrLL,ms.size);
     ms.ReadBuffer(arrLL^,ms.size);
     if (ms.size)>24 then
      begin
       TestArrLenP1:=sat_map_both.GeoConvert.LonLat2Pos(ExtPoint(CDSmarksLonL.AsFloat,CDSmarksLatT.AsFloat),(GState.zoom_size - 1) + 8);
       TestArrLenP2:=sat_map_both.GeoConvert.LonLat2Pos(ExtPoint(CDSmarksLonR.AsFloat,CDSmarksLatB.AsFloat),(GState.zoom_size - 1) + 8);
       if (abs(TestArrLenP1.X-TestArrLenP2.X)>CDSmarksScale1.AsInteger+2)or(abs(TestArrLenP1.Y-TestArrLenP2.Y)>CDSmarksScale1.AsInteger+2) then
        begin
         SetLength(buf_line_arr,(ms.size div 24));
         for i:=0 to (ms.size div 24)-1 do buf_line_arr[i]:=arrLL^[i];
         drawPath(buf_line_arr,false,TColor32(CDSmarksColor1.AsInteger),TColor32(CDSmarksColor2.AsInteger),CDSmarksScale1.asInteger,
                 (buf_line_arr[0].x=buf_line_arr[length(buf_line_arr)-1].x)and(buf_line_arr[0].y=buf_line_arr[length(buf_line_arr)-1].y));
         SetLength(buf_line_arr,0);
        end;
      end;
     if (ms.size)=24 then
      begin
       xy:=sat_map_both.FCoordConverter.LonLat2PixelPos(arrLL^[0],GState.zoom_size-1);
       xy := MapPixel2LoadedPixel(xy);
       xy:=Point(xy.x-3,xy.y-3);
       imw:=CDSmarks.FieldByName('Scale2').AsInteger;
       indexmi:=GState.MarkIcons.IndexOf(CDSmarks.FieldByName('picname').AsString);
       if(indexmi=-1)and(GState.MarkIcons.Count>0) then indexmi:=0;
       if(indexmi>-1)then begin
                           PNGintoBitmap32(btm,TPNGObject(GState.MarkIcons.Objects[indexmi]));
                           LayerMapMarks.Bitmap.Draw(bounds(xy.x-(imw div 2),xy.y-imw,imw,imw),bounds(0,0,btm.Width,btm.Height),btm);
                          end;
       if CDSmarks.FieldByName('Scale1').AsInteger>0 then
        begin
         LayerMapMarks.Bitmap.Font.Size:=CDSmarksScale1.AsInteger;
         texth:=LayerMap.Bitmap.TextHeight(CDSmarksname.asString) div 2;
         LayerMapMarks.Bitmap.RenderText(xy.x+(imw div 2)+2,xy.y-(imw div 2)-texth+1,CDSmarksname.AsString,1,TColor32(CDSmarksColor2.AsInteger));
         LayerMapMarks.Bitmap.RenderText(xy.x+(imw div 2)+1,xy.y-(imw div 2)-texth,CDSmarksname.AsString,1,TColor32(CDSmarksColor1.AsInteger));
        end;
      end;
     ms.free;
     FreeMem(arrLL);
     CDSmarks.Next;
  end;
 CDSmarks.Filtered:=false;
 btm.Free;
end;

class function TFmain.timezone(lon,lat:real):TDateTime;
var prH,prM:integer;
    tz:real;
    st:TSystemTime;
begin
 tz:=GetTZ_(ExtPoint(Lon,Lat));
 GetSystemTime(st);
 prH:=trunc(tz);
 prM:=round(60*frac(TZ));
 result:=EncodeTime(abs(st.wHour+prH+24)mod 24,abs(st.wMinute+prM+60)mod 60,0,0);
end;

procedure TFmain.topos(LL:TExtendedPoint;zoom_:byte;draw:boolean);
begin
 ScreenCenterPos := sat_map_both.GeoConvert.LonLat2Pos(LL,(zoom_ - 1) + 8);
 GState.zoom_size:=zoom_;
 zooming(zoom_,false);
 if draw then LayerMap.Bitmap.Draw(pr_x-7,pr_y-6,GOToSelIcon);
end;

procedure TFmain.paint_Line;
var rnum,len_p,textstrt,textwidth:integer;
    s,se:string;
    LL:TExtendedPoint;
    temp,num:real;
begin
 if not(LayerLineM.visible) then exit;
 LL:=sat_map_both.FCoordConverter.PixelPos2LonLat(ScreenCenterPos, GState.zoom_size-1);
 num:=106/((zoom[GState.zoom_size]/(2*PI))/(sat_map_both.radiusa*cos(LL.y*D2R)));
 if num>10000 then begin
                    num:=num/1000;
                    se:=' '+SAS_UNITS_km+'.';
                   end
              else
 if num<10    then begin
                    num:=num*100;
                    se:=' '+SAS_UNITS_sm+'.';
                   end
              else se:=' '+SAS_UNITS_m+'.';
 rnum:=round(num);
 temp:=power(5,(length(inttostr(rnum))-1));
 if ((rnum/temp)<1.25) then rnum:=round(temp)
                      else if ((rnum/temp)>=3.75)then rnum:=5*round(temp)
                                                 else rnum:=round(2.5*temp);
 len_p:=round(106/(num/rnum));
 s:=inttostr(rnum)+se;
 textwidth:=LayerLineM.bitmap.TextWidth(s);
 while (len_p<textwidth+15)and(not(len_p=0)) do
  begin
   rnum:=rnum*2;
   len_p:=round(106/(num/rnum));
  end;
 s:=inttostr(rnum)+se;
 len_p:=round(106/(num/rnum));
 textwidth:=LayerLineM.bitmap.TextWidth(s);
 LayerLineM.Bitmap.Width:=len_p;
 if GState.ShowStatusBar then With LayerLineM do Location:=floatrect(bounds(round(Location.left),map.Height-23-17,len_p,15))
                         else With LayerLineM do Location:=floatrect(bounds(round(Location.left),map.Height-23,len_p,15));
 LayerLineM.Bitmap.Clear(SetAlpha(clWhite32,135));
 LayerLineM.bitmap.LineS(0,0,0,15,SetAlpha(clBlack32,256));
 LayerLineM.bitmap.LineS(LayerLineM.bitmap.Width-1,0,LayerLineM.bitmap.Width-1,15,SetAlpha(clBlack32,256));
 textstrt:=(len_p div 2)-(textwidth div 2);
 LayerLineM.bitmap.RenderText(textstrt,0,s, 2, clBlack32);
end;

function TFmain.toSh:string;
var ll:TextendedPoint;
    subs2:string;
    posnext:integer;
    TameTZ:TDateTime;
    VPoint: TPoint;
begin
 If not(GState.ShowStatusBar) then exit;
 labZoom.caption:=' '+inttostr(GState.zoom_size)+'x ';
 VPoint := VisiblePixel2MapPixel(m_m);
 ll:=sat_map_both.GeoConvert.Pos2LonLat(VPoint,(GState.zoom_size - 1) + 8);
 if GState.FirstLat then result:=lat2str(ll.y, GState.llStrType)+' '+lon2str(ll.x, GState.llStrType)
                    else result:=lon2str(ll.x, GState.llStrType)+' '+lat2str(ll.y, GState.llStrType);
 LayerStatBar.Bitmap.Width:=map.Width;
 LayerStatBar.Bitmap.Clear(SetAlpha(clWhite32,160));
 LayerStatBar.Bitmap.Line(0,0,map.Width,0,SetAlpha(clBlack32,256));
 LayerStatBar.bitmap.RenderText(4,1,inttostr(GState.zoom_size)+'x', 0, clBlack32);
 LayerStatBar.bitmap.RenderText(29,1,'| '+SAS_STR_coordinates+' '+result, 0, clBlack32);

 TameTZ:=timezone(ll.x,ll.y);
 subs2 := DistToStrWithUnits(1/((zoom[GState.zoom_size]/(2*PI))/(sat_map_both.radiusa*cos(ll.y*D2R))), GState.num_format)+SAS_UNITS_mperp;
 LayerStatBar.bitmap.RenderText(278,1,' | '+SAS_STR_Scale+' '+subs2, 0, clBlack32);
 posnext:=273+LayerStatBar.Bitmap.TextWidth(subs2)+70;
 LayerStatBar.bitmap.RenderText(posnext,1,' | '+SAS_STR_time+' '+ TimeToStr(TameTZ), 0, clBlack32);
 posnext:=posnext+LayerStatBar.Bitmap.TextWidth(SAS_STR_time+' '+TimeToStr(TameTZ))+10;
 // ����� � ����� ����� � ��������� ������. �������� �� ���������� ��� �����.
 subs2:=sat_map_both.GetTileFileName(X2absX(VPoint.X,GState.zoom_size),VPoint.Y,GState.zoom_size);
 LayerStatBar.bitmap.RenderText(posnext,1,' | '+SAS_STR_load+' '+inttostr(GState.All_Dwn_Tiles)+' ('+kb2KbMbGb(GState.All_Dwn_Kb)+') | '+SAS_STR_file+' '+subs2, 0, clBlack32);

 if GState.ShowStatusBar then LayerStatBar.BringToFront;
 if GMiniMap.LayerMinMap.Visible then GMiniMap.LayerMinMap.BringToFront;
end;


procedure TFmain.DrawGenShBorders;
var LonLatLT,LonLatRD:TExtendedPoint;
    bufLonLT:Extended;
    PosLT:TPoint;
    zLonR,zLatR:extended;
    x2,x1,y1,y2,X1b,twidth,theight:integer;
    ListName:WideString;
begin
 if GState.GShScale=0 then exit;
 case GState.GShScale of
  1000000: begin zLonR:=6; zLatR:=4; end;
   500000: begin zLonR:=3; zLatR:=2; end;
   200000: begin zLonR:=1; zLatR:=0.66666666666666666666666666666667; end;
   100000: begin zLonR:=0.5; zLatR:=0.33333333333333333333333333333333; end;
    50000: begin zLonR:=0.25; zLatR:=0.1666666666666666666666666666665; end;
    25000: begin zLonR:=0.125; zLatR:=0.08333333333333333333333333333325; end;
    10000: begin zLonR:=0.0625; zLatR:=0.041666666666666666666666666666625; end;
 end;

 LonLatRD:=sat_map_both.GeoConvert.Pos2LonLat(Point(ScreenCenterPos.x+pr_x,ScreenCenterPos.y+pr_y), (GState.zoom_size - 1) + 8);
 LonLatRD:=ExtPoint(LonLatRD.x+zLonR,LonLatRD.y-zLatR);
 if LonLatRD.y<-90 then LonLatRD.y:=-90;
 if LonLatRD.x>180 then LonLatRd.x:=180;
 LonLatLT:=sat_map_both.GeoConvert.Pos2LonLat(Point(ScreenCenterPos.x-pr_x,ScreenCenterPos.y-pr_y), (GState.zoom_size - 1) + 8);
 LonLatLT:=ExtPoint(LonLatLT.X-zLonR,LonLatLT.Y+zLatR);
 if LonLatLT.y>90 then LonLatLT.y:=90;
 if LonLatLT.x<-180 then LonLatLT.x:=-180;
 LonLatLT.X:=LonLatLT.X-(round(LonLatLT.X*GSHprec) mod round(zLonR*GSHprec))/GSHprec;
 LonLatLT.Y:=LonLatLT.Y-(round(LonLatLT.Y*GSHprec) mod round(zLatR*GSHprec))/GSHprec;

 PosLT:=sat_map_both.GeoConvert.LonLat2Pos(LonLatLT,(GState.zoom_size - 1) + 8);
 if sat_map_both.GeoConvert.LonLat2Pos(ExtPoint(LonLatLT.x+zLonR,LonLatLT.y+zLatR),(GState.zoom_size - 1) + 8).x-PosLT.x<4 then exit;
 bufLonLT:=LonLatLT.X;

 Y1:=pr_Y-(ScreenCenterPos.Y-PosLT.Y);
 while (LonLatLT.Y>LonLatRD.y) do
  begin
   LonLatLT.Y:=LonLatLT.Y-zLatR;
   LonLatLT.X:=bufLonLT;
   PosLT:=sat_map_both.GeoConvert.LonLat2Pos(LonLatLT,(GState.zoom_size - 1) + 8);
   Y2:=pr_Y-(ScreenCenterPos.Y-PosLT.Y);
   X1:=pr_x-(ScreenCenterPos.X-PosLT.X);
   X1b:=X1;
   while (LonLatLT.X+zLonR/2<LonLatRD.x) do
    begin
     LonLatLT.X:=LonLatLT.X+zLonR;
     PosLT:=sat_map_both.GeoConvert.LonLat2Pos(LonLatLT,(GState.zoom_size - 1) + 8);
     X2:=pr_x-(ScreenCenterPos.X-PosLT.X);
     LayerMap.bitmap.LineAS(x1,y1,x1,y2,SetAlpha(Color32(GState.BorderColor),GState.BorderAlpha));
     if ((x2-x1>30)and(y2-y1>7))and(GState.ShowBorderText) then
      begin
       ListName:=LonLat2GShListName(ExtPoint(LonLatLT.X-zLonR/2,LonLatLT.Y+zLatR/2),GState.GShScale,GSHprec);
        twidth:=LayerMap.bitmap.TextWidth(ListName);
       theight:=LayerMap.bitmap.TextHeight(ListName);
       if (twidth+4<x2-x1)and(theight+4<y2-y1) then
        LayerMap.bitmap.RenderTextW(x1+(x2-x1)div 2-(twidth div 2),y1+(y2-y1)div 2-(theight div 2),ListName,0,SetAlpha(Color32(GState.BorderColor),GState.BorderAlpha));
      end;
     X1:=X2;
    end;
   LayerMap.bitmap.LineAS(x1b,y1,x2,y1,SetAlpha(Color32(GState.BorderColor),GState.BorderAlpha));
   LonLatLT.X:=LonLatLT.X+zLonR;
   PosLT:=sat_map_both.GeoConvert.LonLat2Pos(LonLatLT,(GState.zoom_size - 1) + 8);
   LayerMap.bitmap.LineAS(x1,y1,x1,y2,SetAlpha(Color32(GState.BorderColor),GState.BorderAlpha));
   y1:=y2;
  end;
end;

procedure TFmain.generate_granica;
var y_draw,x_draw,xx,yy,xx1,yy1:longint;
    i,j:integer;
    src:TRect;
    drawcolor:TColor32;
    textoutx,textouty:string;
    Sz1,Sz2: TSize;
    d2562,x2,x1,y1,zl,twidthx,twidthy,theight:integer;
begin
 if zoom_line=99 then zl:=GState.zoom_size
                 else zl:=zoom_line;
 if (zl<GState.zoom_size)or(zl-GState.zoom_size>5) then exit;
 x2:=trunc(power(2,zl-GState.zoom_size));
 d2562:=256 div x2;
 src:=bounds(0,0,d2562,d2562);
 y_draw:=(256+((ScreenCenterPos.y-pr_y)mod 256))mod 256;
 x_draw:=(256+((ScreenCenterPos.x-pr_x)mod 256))mod 256;
 if (ScreenCenterPos.x-pr_x)>0 then xx1:=((ScreenCenterPos.x-pr_x)-((ScreenCenterPos.x-pr_x)mod 256))*x2
                   else xx1:=((ScreenCenterPos.x-pr_x)-256-((ScreenCenterPos.x-pr_x)mod 256))*x2;
 if (ScreenCenterPos.y-pr_y)>0 then yy1:=((ScreenCenterPos.y-pr_y)-((ScreenCenterPos.y-pr_y)mod 256))*x2
                   else yy1:=((ScreenCenterPos.y-pr_y)-256-((ScreenCenterPos.y-pr_y)mod 256))*x2;
 drawcolor:=SetAlpha(Color32(GState.BorderColor),GState.BorderAlpha);
 LayerMap.bitmap.Font.Size:=8;
 LayerMap.bitmap.Font.Name:='Arial';
 for i:=0 to hg_x*(x2)+(x_draw div d2562) do
  for j:=0 to hg_y*(x2)+(y_draw div d2562) do
    begin
     xx:=xx1+(i shl 8);
     yy:=yy1+(j shl 8);
     if (xx<0)or(yy<0)or(yy>=zoom[zl])or(xx>=zoom[zl]) then Continue;
     x1:=(i*d2562)-x_draw;
     y1:=(j*d2562)-y_draw;
     LayerMap.bitmap.LineAS(x1,y1,x1+d2562,y1,drawcolor);
     LayerMap.bitmap.LineAS(x1+d2562,y1,x1+d2562,y1+d2562,drawcolor);
     x1:=(x1+d2562 shr 1);
     y1:=(y1+d2562 shr 1);
     if (GState.ShowBorderText)and(x1>0)and(y1>0)and(x1<xhgpx)and(y1<yhgpx) then
       begin
        textoutx:='x='+inttostr(((ScreenCenterPos.x-pr_x+x1)*x2) shr 8);
        textouty:='y='+inttostr(((ScreenCenterPos.y-pr_y+y1)*x2) shr 8);
        Sz1:=LayerMap.bitmap.TextExtent(textoutx);
        Sz2:=LayerMap.bitmap.TextExtent(textouty);
        if ((Sz1.cx)<d2562)and(Sz2.cx<d2562) then
         begin
          LayerMap.bitmap.RenderText(x1-(Sz1.cx shr 1)+1,y1-Sz2.cy,textoutx,0, drawcolor);
          LayerMap.bitmap.RenderText(x1-(Sz2.cx shr 1)+1,y1,textouty,0,drawcolor);
         end;
       end;
    end;
end;

procedure TFmain.generate_mapzap;
begin
  if (GState.zoom_mapzap<=GState.zoom_size) then begin
    FillingMap.StopDrow;
  end else begin
    FillingMap.StartDrow;
  end;
end;

procedure BadDraw(var spr:TBitmap32; transparent:boolean);
begin
 spr.SetSize(256,256);
 if transparent then spr.Clear(SetAlpha(Color32(clSilver),0))
                else spr.Clear(Color32(clSilver) xor $00000000);
 spr.RenderText(87,120,SAS_ERR_BadFile,0,clBlack32);
end;

procedure TFmain.generate_im(LastLoad:TLastLoad;err:string);
var
    y_draw,x_draw,y_drawN,x_drawN,xx,yy:longint;
    i,j:byte;
    Leyi:integer;
    posN:TPoint;
    ts2,ts3,fr:int64;
begin
 if notpaint then exit;
 QueryPerformanceCounter(ts2);
 if not(lastload.use) then generate_mapzap;
 if not(lastload.use) then change_scene:=true;

 y_draw:=(256+((ScreenCenterPos.y-pr_y)mod 256))mod 256;
 x_draw:=(256+((ScreenCenterPos.x-pr_x)mod 256))mod 256;
 LayerMap.Location:=floatrect(GetMapLayerLocationRect);
 LayerMap.Bitmap.Clear(clSilver);
 if aoper<>ao_movemap then LayerMapNal.Location:=floatrect(GetMapLayerLocationRect);
 if GState.GPS_enab then LayerMapGPS.Location:=floatrect(GetMapLayerLocationRect);
 destroyWL;

 for i:=0 to hg_x do
  for j:=0 to hg_y do
   begin
    xx:=ScreenCenterPos.x-pr_x+(i shl 8);
    if GState.CiclMap then xx:=X2AbsX(xx,GState.zoom_size);
    yy:=ScreenCenterPos.y-pr_y+(j shl 8);
    if (xx<0)or(yy<0)or(yy>=zoom[GState.zoom_size])or(xx>=zoom[GState.zoom_size]) then continue;
    if (sat_map_both.TileExists(xx,yy,GState.zoom_size))
     then begin
           if sat_map_both.LoadTile(Gspr,xx,yy,GState.zoom_size,true)
             then begin
                    if (sat_map_both.DelAfterShow)and(not lastload.use) then sat_map_both.DeleteTile(xx,yy,GState.zoom_size);
                  end
             else BadDraw(Gspr,false);
          end
     else sat_map_both.LoadTileFromPreZ(Gspr,xx,yy,GState.zoom_size,true);
    Gamma(Gspr);
    LayerMap.bitmap.Draw((i shl 8)-x_draw,(j shl 8)-y_draw,bounds(0,0,256,256),Gspr);
   end;
  Gspr.SetSize(256,256);
  for Leyi:=0 to length(MapType)-1 do
   if (MapType[Leyi].asLayer)and(MapType[Leyi].active) then begin
     if MapType[Leyi].ext='.kml' then begin
       if not(LayerMapWiki.Visible) then begin
         LayerMapWiki.Location:=floatrect(GetMapLayerLocationRect);
         LayerMapWiki.Bitmap.Clear(clBlack);
       end;
       loadWL(MapType[Leyi]);
       continue;
     end;
     posN:=sat_map_both.GeoConvert.Pos2OtherMap(ScreenCenterPos, (GState.zoom_size - 1) + 8,MapType[Leyi].GeoConvert);
     y_drawN:=(((256+((posN.y-pr_y)mod 256)) mod 256));
     x_drawN:=(((256+((posN.x-pr_x)mod 256)) mod 256));
     for i:=0 to hg_x do
      for j:=0 to hg_y do
       begin
         xx:=ScreenCenterPos.x-pr_x+(i shl 8);
         if GState.CiclMap then xx:=X2AbsX(xx,GState.zoom_size);
         yy:=posN.y-pr_y+(j shl 8);
         if  (xx<0)or(yy<0)or(yy>=zoom[GState.zoom_size])or(xx>=zoom[GState.zoom_size]) then continue;
         //Gspr.Clear($FF000000);
         if (MapType[Leyi].TileExists(xx,yy,GState.zoom_size)) then begin
           if MapType[Leyi].LoadTile(Gspr,xx,yy,GState.zoom_size,true) then begin
             if (MapType[Leyi].DelAfterShow)and(not lastload.use) then MapType[Leyi].DeleteTile(xx,yy,GState.zoom_size);
           end
           else BadDraw(Gspr,true);
           Gamma(Gspr);
         end
         else if MapType[Leyi].LoadTileFromPreZ(Gspr,xx,yy,GState.zoom_size,true) then begin
           Gamma(Gspr);
         end;
         Gspr.DrawMode:=dmBlend;
         LayerMap.bitmap.Draw((i shl 8)-x_drawN,(j shl 8)-y_drawN, Gspr);
       end;
   end;
 if (lastload.use)and(err<>'') then
   LayerMap.Bitmap.RenderText(pr_x+(lastload.x-ScreenCenterPos.x)+15,pr_y+(lastload.y-ScreenCenterPos.y)+124,err,0,clBlack32);
 generate_granica;
 DrawGenShBorders;
 if NavOnMark<>nil then NavOnMark.draw;
 if not(lastload.use) then
   begin
    paint_Line;
    if aoper=ao_line then drawLineCalc;
    if aoper=ao_reg then drawReg;
    if aoper=ao_rect then drawRect([]);
    if GState.GPS_enab then drawLineGPS;
    if aoper in [ao_add_line,ao_add_poly] then drawPath(add_line_arr,true,setalpha(clRed32,150),setalpha(clWhite32,50),3,aoper=ao_add_poly);
    try
     draw_point;
    except
    end;
    GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos);
   end;
{ m_up.x:=move.X;
 m_up.y:=move.y;   }
 toSh;
 QueryPerformanceCounter(ts3);
 QueryPerformanceFrequency(fr);
 Label1.caption :=FloatToStr((ts3-ts2)/(fr/1000));
 //map.Cursor:=AcrBuf;
end;

procedure TFmain.FormActivate(Sender: TObject);
var
     i,r:integer;
     xy,xy1:Tpoint;
     param:string;
     MainWindowMaximized: Boolean;
begin
 if ProgramStart=false then exit;
 RectWindow := Types.Rect(0, 0, 0, 0);
 Enabled:=false;
 dWhenMovingButton := 5;
 GMiniMapPopupMenu := PopupMSmM;
 MainWindowMaximized:=GState.MainIni.Readbool('VIEW','Maximized',true);
 GState.FullScrean:=GState.MainIni.Readbool('VIEW','FullScreen',false);
 TBFullSize.Checked:=GState.FullScrean;
  if GState.FullScrean then TBFullSizeClick(TBFullSize)
                  else if MainWindowMaximized
                        then WindowState:=wsMaximized
                        else begin
                              Self.SetBounds(
                              GState.MainIni.ReadInteger('VIEW','FLeft',Left),
                              GState.MainIni.ReadInteger('VIEW','FTop',Top),
                              GState.MainIni.ReadInteger('VIEW','FWidth',Width),
                              GState.MainIni.ReadInteger('VIEW','FHeight',Height)
                              )
                             end;

 movepoint:=-1;
 GMiniMap := TMiniMap.Create(Map);
 GMiniMap.LayerMinMap.OnMouseDown:=LayerMinMapMouseDown;
 GMiniMap.LayerMinMap.OnMouseUp:=LayerMinMapMouseUp;
 GMiniMap.LayerMinMap.OnMouseMove:=LayerMinMapMouseMove;

 if length(MapType)=0 then
  begin
   ShowMessage(SAS_ERR_NoMaps);
   Close;
   exit;
  end;
 CreateMapUI;
 if FileExists(GState.MarksFileName)
  then begin
        CDSMarks.LoadFromFile(GState.MarksFileName);
        if CDSMarks.RecordCount>0 then
         CopyFile(PChar(GState.MarksFileName),PChar(GState.MarksBackUpFileName),false);
       end;
 if FileExists(GState.MarksCategoryFileName)
  then begin
        CDSKategory.LoadFromFile(GState.MarksCategoryFileName);
        if CDSKategory.RecordCount>0 then
         CopyFile(PChar(GState.MarksCategoryFileName),PChar(GState.MarksCategoryBackUpFileName),false);
       end;
 Enabled:=true;
 nilLastLoad.use:=false;
 notpaint:=true;
 SetDefoultMap;
 Application.OnMessage := DoMessageEvent;
 Application.HelpFile := ExtractFilePath(Application.ExeName)+'help.hlp';
 LenShow:=true;
 mWd2:=map.Width shr 1;
 mHd2:=map.Height shr 1;
 Screen.Cursors[1]:=LoadCursor(HInstance, 'SEL');
 Screen.Cursors[2]:=LoadCursor(HInstance, 'LEN');
 Screen.Cursors[3]:=LoadCursor(HInstance, 'HAND');
 Screen.Cursors[4]:=LoadCursor(HInstance, 'SELPOINT');
 move:=point(0,0);
 m_up:=point(0,0);
 MapZoomAnimtion:=0;

 GState.TilesOut:=GState.MainIni.readInteger('VIEW','TilesOut',0);

 hg_x:=round(Screen.Width / 256)+(integer((Screen.Width mod 256)>0))+GState.TilesOut;
 hg_y:=round(Screen.Height / 256)+(integer((Screen.Height mod 256)>0))+GState.TilesOut;
 if GState.TilesOut=0 then begin
   yhgpx:=Screen.Height;
   xhgpx:=Screen.Width;
 end else begin
   yhgpx:=256*hg_y;
   xhgpx:=256*hg_x;
 end;
 pr_y:=(yhgpx)div 2;
 pr_x:=(xhgpx)div 2;

 Gspr:=TBitmap32.Create;
 Gspr.Width:=256;
 Gspr.Height:=256;
 setlength(poly_save,0);

 Map.Cursor:=crDefault;
 map.Color:=clSilver;
 LayerMap:=TBitmapLayer.Create(map.Layers);
 LayerMap.Location:=floatrect(MapLayerLocationRect);
 LayerMap.Bitmap.Width:=xhgpx;
 LayerMap.Bitmap.Height:=yhgpx;
 LayerMap.bitmap.Font.Charset:=RUSSIAN_CHARSET;

 LayerMapScale:=TBitmapLayer.Create(map.Layers);
 LayerMapScale.location:=floatrect(bounds(mWd2-145,mHd2-145,290,290));
 LayerMapScale.Bitmap.Width:=290;
 LayerMapScale.Bitmap.Height:=290;
 LayerMapScale.Bitmap.DrawMode:=dmBlend;
 LayerMapScale.Bitmap.CombineMode:=cmMerge;
 LayerMapScale.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 i:=0;
 LayerMapScale.Bitmap.Clear(clBlack);
 LayerMapScale.Bitmap.Canvas.Pen.Color:=clRed;
 LayerMapScale.Bitmap.Font.Size:=6;
 While i<360 do
  begin
   LayerMapScale.Bitmap.Font.Size:=6;
   if (i mod 90) = 0 then begin
                           r:=0;
                           LayerMapScale.Bitmap.Font.Size:=10;
                          end
    else if (i mod 45) = 0 then begin
                                 r:=80;
                                 LayerMapScale.Bitmap.Font.Size:=8;
                                end
     else r:=110;
   xy.x := round(145 + 120 * cos(i*(Pi/180)));
   xy.y := round(145 + 120 * sin(i*(Pi/180)));
   xy1.x := round(145 + r * cos(i*(Pi/180)));
   xy1.y := round(145 + r * sin(i*(Pi/180)));
   LayerMapScale.Bitmap.LineFS(xy.x,xy.y,xy1.x,xy1.y,SetAlpha(clRed32,180));
   if (i mod 15) = 0 then
    begin
     xy1.x := round(145 + 132* cos(i*(Pi/180)))-LayerMapScale.Bitmap.TextWidth(inttostr((i+90)mod 360)+'�')div 2;
     xy1.y := round(145 + 132* sin(i*(Pi/180)))-2-LayerMapScale.Bitmap.Font.size div 2;
     LayerMapScale.Bitmap.RenderText(xy1.x+1,xy1.y+1,inttostr((i+90)mod 360)+'�',3,SetAlpha(clWhite32,250) );
     LayerMapScale.Bitmap.RenderText(xy1.x,xy1.y,inttostr((i+90)mod 360)+'�',3,SetAlpha(clBlue32,250) );
    end;
   inc(i,5);
  end;

 FillingMap:=TFillingMap.create(true);
 FillingMap.FreeOnTerminate:=true;
 FillingMap.Priority:=tpLowest;

 LayerMapNal:=TBitmapLayer.Create(map.Layers);
 LayerMapNal.Bitmap.Width:=xhgpx;
 LayerMapNal.Bitmap.Height:=yhgpx;
 LayerMapNal.Bitmap.DrawMode:=dmBlend;
 LayerMapNal.Bitmap.CombineMode:=cmMerge;
 LayerMapNal.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 LayerMapNal.Visible:=false;

 LayerMapMarks:=TBitmapLayer.Create(map.Layers);
 LayerMapMarks.Bitmap.Width:=xhgpx;
 LayerMapMarks.Bitmap.Height:=yhgpx;
 LayerMapMarks.Bitmap.DrawMode:=dmBlend;
 LayerMapMarks.Bitmap.CombineMode:=cmMerge;
 LayerMapMarks.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 LayerMapMarks.Bitmap.Font.Name:='Tahoma';
 LayerMapMarks.Bitmap.Font.Style:=[];
 LayerMapMarks.Visible:=false;

 LayerMapWiki:=TBitmapLayer.Create(map.Layers);
 LayerMapWiki.Bitmap.Width:=xhgpx;
 LayerMapWiki.Bitmap.Height:=yhgpx;
 LayerMapWiki.Bitmap.DrawMode:=dmTransparent;
 LayerMapWiki.bitmap.Font.Charset:=RUSSIAN_CHARSET;

 LayerMapGPS:=TBitmapLayer.Create(map.Layers);
 LayerMapGPS.Bitmap.Width:=xhgpx;
 LayerMapGPS.Bitmap.Height:=yhgpx;
 LayerMapGPS.Bitmap.DrawMode:=dmBlend;
 LayerMapGPS.Bitmap.CombineMode:=cmMerge;
 LayerMapGPS.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 LayerMapGPS.Visible:=false;

 layerLineM:=TBitmapLayer.Create(map.Layers);
 layerLineM.location:=floatrect(bounds(6,map.Height-23,128,15));
 layerLineM.Bitmap.Width:=128;
 layerLineM.Bitmap.Height:=15;
 layerLineM.bitmap.DrawMode := dmBlend;
 LayerLineM.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 LayerLineM.bitmap.Font.Name := 'Arial';
 LayerLineM.bitmap.Font.Size := 10;


 LayerStatBar:=TBitmapLayer.Create(map.Layers);
 LayerStatBar.Location:=floatrect(0,map.Height-17,map.Width,map.Height);
 LayerStatBar.Bitmap.Width:=map.Width;
 LayerStatBar.Bitmap.Height:=17;
 LayerStatBar.Bitmap.DrawMode:=dmBlend;
 LayerStatBar.bitmap.Font.Charset:=RUSSIAN_CHARSET;
 LayerStatBar.bitmap.Font.Name := 'arial';
 LayerStatBar.bitmap.Font.Size := 10;

 GState.InetConnect.userwinset:=GState.MainIni.Readbool('INTERNET','userwinset',true);
 GState.InetConnect.uselogin:=GState.MainIni.Readbool('INTERNET','uselogin',false);
 GState.InetConnect.Proxyused:=GState.MainIni.Readbool('INTERNET','used_proxy',false);
 GState.InetConnect.proxystr:=GState.MainIni.Readstring('INTERNET','proxy','');
 GState.InetConnect.loginstr:=GState.MainIni.Readstring('INTERNET','login','');
 GState.InetConnect.passstr:=GState.MainIni.Readstring('INTERNET','password','');
 GState.SaveTileNotExists:=GState.MainIni.ReadBool('INTERNET','SaveTileNotExists',false);
 GState.TwoDownloadAttempt:=GState.MainIni.ReadBool('INTERNET','DblDwnl',true);
 GState.GoNextTileIfDownloadError:=GState.MainIni.ReadBool('INTERNET','GoNextTile',false);

 GState.ShowMapName:=GState.MainIni.readBool('VIEW','ShowMapNameOnPanel',true);
 GState.show_point := TMarksShowType(GState.MainIni.readinteger('VIEW','ShowPointType',2));
 GState.Zoom_Size:=GState.MainIni.ReadInteger('POSITION','zoom_size',1);
 GState.DefCache:=GState.MainIni.readinteger('VIEW','DefCache',2);
 GState.zoom_mapzap:=GState.MainIni.readinteger('VIEW','MapZap',0);
 zoom_line:=GState.MainIni.readinteger('VIEW','grid',0);
 GState.MouseWheelInv:=GState.MainIni.readbool('VIEW','invert_mouse',false);
 TileSource:=TTileSource(GState.MainIni.Readinteger('VIEW','TileSource',1));
 GState.num_format:= TDistStrFormat(GState.MainIni.Readinteger('VIEW','NumberFormat',0));
 GState.CiclMap:=GState.MainIni.Readbool('VIEW','CiclMap',false);
 GState.Resampling := TTileResamplingType(GState.MainIni.Readinteger('VIEW','ResamlingType',1));
 GState.llStrType:=TDegrShowFormat(GState.MainIni.Readinteger('VIEW','llStrType',0));
 GState.FirstLat:=GState.MainIni.ReadBool('VIEW','FirstLat',false);
 GState.BorderAlpha:=GState.MainIni.Readinteger('VIEW','BorderAlpha',150);
 GState.BorderColor:=GState.MainIni.Readinteger('VIEW','BorderColor',$FFFFFF);
 GState.ShowBorderText:=GState.MainIni.ReadBool('VIEW','BorderText',true);
 GState.GShScale:=GState.MainIni.Readinteger('VIEW','GShScale',0);
 if GState.GShScale >= 1000000 then begin
  GState.GShScale := 1000000;
 end else if GState.GShScale >= 500000 then begin
  GState.GShScale := 500000;
 end else if GState.GShScale >= 200000 then begin
  GState.GShScale := 200000;
 end else if GState.GShScale >= 100000 then begin
  GState.GShScale := 100000;
 end else if GState.GShScale >= 50000 then begin
  GState.GShScale := 50000;
 end else if GState.GShScale >= 25000 then begin
  GState.GShScale := 25000;
 end else if GState.GShScale >= 10000 then begin
  GState.GShScale := 10000;
 end else begin
  GState.GShScale := 0;
 end;

 GState.MapZapColor:=GState.MainIni.Readinteger('VIEW','MapZapColor',clBlack);
 GState.MapZapAlpha:=GState.MainIni.Readinteger('VIEW','MapZapAlpha',110);
 lock_toolbars:=GState.MainIni.ReadBool('VIEW','lock_toolbars',false);
 GState.MainFileCache.CacheElemensMaxCnt:=GState.MainIni.ReadInteger('VIEW','TilesOCache',150);
 Label1.Visible:=GState.MainIni.ReadBool('VIEW','time_rendering',false);
 GState.ShowHintOnMarks:=GState.MainIni.ReadBool('VIEW','ShowHintOnMarks',true);
 GState.WikiMapMainColor:=GState.MainIni.Readinteger('Wikimapia','MainColor',$FFFFFF);
 GState.WikiMapFonColor:=GState.MainIni.Readinteger('Wikimapia','FonColor',$000001);

 GState.GammaN:=GState.MainIni.Readinteger('COLOR_LEVELS','gamma',50);
 GState.ContrastN:=GState.MainIni.Readinteger('COLOR_LEVELS','contrast',0);
 GState.InvertColor:=GState.MainIni.ReadBool('COLOR_LEVELS','InvertColor',false);
 GState.GPS_COM:=GState.MainIni.ReadString('GPS','com','COM0');
 GState.GPS_BaudRate:=GState.MainIni.ReadInteger('GPS','BaudRate',4800);
 GState.GPS_TimeOut:=GState.MainIni.ReadInteger('GPS','timeout',15);
 GState.GPS_Delay:=GState.MainIni.ReadInteger('GPS','update',1000);
 GState.GPS_enab:=GState.MainIni.ReadBool('GPS','enbl',false);
 GState.GPS_WriteLog:=GState.MainIni.Readbool('GPS','log',true);
 GState.GPS_ArrowSize:=GState.MainIni.ReadInteger('GPS','SizeStr',25);
 GState.GPS_TrackWidth:=GState.MainIni.ReadInteger('GPS','SizeTrack',5);
 GState.GPS_ArrowColor:=GState.MainIni.ReadInteger('GPS','ColorStr',clRed{-16776961});
 GState.GPS_Correction:=extpoint(GState.MainIni.ReadFloat('GPS','popr_lon',0),GState.MainIni.ReadFloat('GPS','popr_lat',0));
 GState.GPS_ShowPath:=GState.MainIni.ReadBool('GPS','path',true);
 GState.GPS_MapMove:=GState.MainIni.ReadBool('GPS','go',true);
 GState.OldCpath_:=GState.MainIni.Readstring('PATHtoCACHE','GMVC','cache_old\');
 GState.NewCpath_:=GState.MainIni.Readstring('PATHtoCACHE','SASC','cache\');
 GState.ESCpath_:=GState.MainIni.Readstring('PATHtoCACHE','ESC','cache_ES\');
 GState.GMTilesPath_:=GState.MainIni.Readstring('PATHtoCACHE','GMTiles','cache_gmt\');
 GState.GECachePath_:=GState.MainIni.Readstring('PATHtoCACHE','GECache','cache_GE\');
 ScreenCenterPos := Point(GState.MainIni.ReadInteger('POSITION','x',zoom[GState.zoom_size]div 2 +1),
                          GState.MainIni.ReadInteger('POSITION','y',zoom[GState.zoom_size]div 2 +1));
 GState.UsePrevZoom := GState.MainIni.Readbool('VIEW','back_load',true);
 GState.UsePrevZoomLayer := GState.MainIni.Readbool('VIEW','back_load_layer',true);
 GState.AnimateZoom:=GState.MainIni.Readbool('VIEW','animate',true);
 Fillingmaptype:=GetMapFromID(GState.MainIni.ReadString('VIEW','FillingMap','0'));
 if Fillingmaptype<>nil then fillingmaptype.TBFillingItem.Checked:=true
                        else TBfillMapAsMain.Checked:=true;
 i:=1;
 while str2r(GState.MainIni.ReadString('HIGHLIGHTING','pointx_'+inttostr(i),'2147483647'))<>2147483647 do
  begin
   setlength(poly_save,i);
   poly_save[i-1].x:=str2r(GState.MainIni.ReadString('HIGHLIGHTING','pointx_'+inttostr(i),'2147483647'));
   poly_save[i-1].y:=str2r(GState.MainIni.ReadString('HIGHLIGHTING','pointy_'+inttostr(i),'2147483647'));
   inc(i);
  end;
 if length(poly_save)>0 then poly_zoom_save:=GState.MainIni.Readinteger('HIGHLIGHTING','zoom',1);

 LayerMapScale.Visible:=GState.MainIni.readbool('VIEW','showscale',false);
 SetMiniMapVisible(GState.MainIni.readbool('VIEW','minimap',true));
 SetLineScaleVisible(GState.MainIni.readbool('VIEW','line',true));
 GState.ShowStatusBar := GState.MainIni.readbool('VIEW','statusbar',true);
 SetStatusBarVisible();
 NzoomIn.ShortCut:=GState.MainIni.Readinteger('HOTKEY','ZoomIn',33);
 NzoomOut.ShortCut:=GState.MainIni.Readinteger('HOTKEY','ZoomOut',34);
 N14.ShortCut:=GState.MainIni.Readinteger('HOTKEY','GoTo',16455);
 NCalcRast.ShortCut:=GState.MainIni.Readinteger('HOTKEY','CalcRast',16460);
 TBRECT.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Rect',32850);
 TBRegion.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Polyg',32848);
 TBCOORD.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Coord',16451);
 TBPREVIOUS.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Previous',16450);
 NSRCinet.ShortCut:=GState.MainIni.Readinteger('HOTKEY','inet',32841);
 NSRCesh.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Cache',32835);
 NSRCic.ShortCut:=GState.MainIni.Readinteger('HOTKEY','CachInet',32834);
 Showstatus.ShortCut:=GState.MainIni.Readinteger('HOTKEY','Showstatus',32851);
 ShowLine.ShortCut:=GState.MainIni.Readinteger('HOTKEY','ShowLine',32844);
 ShowMiniMap.ShortCut:=GState.MainIni.Readinteger('HOTKEY','ShowMiniMap',32845);
 NFoolSize.ShortCut:=GState.MainIni.Readinteger('HOTKEY','FoolSize',122);
 NGoToCur.ShortCut:=GState.MainIni.Readinteger('HOTKEY','GoToCur',49219);
 Nbackload.ShortCut:=GState.MainIni.Readinteger('HOTKEY','backload',49218);
 Nanimate.ShortCut:=GState.MainIni.Readinteger('HOTKEY','animate',49217);
 NCiclMap.ShortCut:=GState.MainIni.Readinteger('HOTKEY','CiclMap',49242);
 N32.ShortCut:=GState.MainIni.Readinteger('HOTKEY','ShowScale',49235);
 NGPSconn.ShortCut:=GState.MainIni.Readinteger('HOTKEY','GPSconn',49223);
 NGPSPath.ShortCut:=GState.MainIni.Readinteger('HOTKEY','GPSPath',49236);
 NGPSToPoint.ShortCut:=GState.MainIni.Readinteger('HOTKEY','GPSToPoint',0);
 NSaveTreck.ShortCut:=GState.MainIni.Readinteger('HOTKEY','SaveTreck',16467);
 Ninvertcolor.ShortCut:=GState.MainIni.Readinteger('HOTKEY','InvertColor',32846);
 TBLoadSelFromFile.ShortCut:=GState.MainIni.Readinteger('HOTKEY','LoadSelFromFile',0);
 NMapParams.ShortCut:=GState.MainIni.Readinteger('HOTKEY','MapParams',16464);

 TTBXItem(FindComponent('NGShScale'+IntToStr(GState.GShScale))).Checked:=true;
 N32.Checked:=LayerMapScale.Visible;
 Ninvertcolor.Checked:=GState.InvertColor;
 TBGPSconn.Checked := GState.GPS_enab;
 if GState.GPS_enab then TBGPSconnClick(TBGPSconn);
 TBGPSPath.Checked:=GState.GPS_ShowPath;
 NGPSPath.Checked:=GState.GPS_ShowPath;
 TBGPSToPoint.Checked:=GState.GPS_MapMove;
 NGPSToPoint.Checked:=GState.GPS_MapMove;
 Nbackload.Checked:=GState.UsePrevZoom;
 NbackloadLayer.Checked:=GState.UsePrevZoomLayer;
 Nanimate.Checked:=GState.AnimateZoom;

 if not(FileExists(GState.MainConfigFileName)) then
  begin
   TBEditPath.Floating:=true;
   TBEditPath.MoveOnScreen(true);
   TBEditPath.FloatingPosition:=Point(Left+map.Left+30,Top+map.Top+70);
  end;

 NMainToolBarShow.Checked:=TBMainToolBar.Visible;
 NZoomToolBarShow.Checked:=ZoomToolBar.Visible;
 NsrcToolBarShow.Checked:=SrcToolbar.Visible;
 NGPSToolBarShow.Checked:=GPSToolBar.Visible;
 NMarksBarShow.Checked:=TBMarksToolBar.Visible;

 TBFullSize.Checked:=GState.FullScrean;
 NCiclMap.Checked:=GState.CiclMap;

 toSh;
 ProgramStart:=false;

 if GState.zoom_mapzap<>0 then TBMapZap.Caption:='x'+inttostr(GState.zoom_mapzap)
                   else TBMapZap.Caption:='';
 selectMap(sat_map_both);
 RxSlider1.Value:=GState.Zoom_size-1;
 notpaint:=false;

 if ParamCount > 1 then
 begin
  param:=paramstr(1);
  if param<>'' then For i:=0 to length(MapType)-1 do if MapType[i].guids=param then sat_map_both:=MapType[i];
  if paramstr(2)<>'' then GState.zoom_size:=strtoint(paramstr(2));
  if (paramstr(3)<>'')and(paramstr(4)<>'') then ScreenCenterPos := sat_map_both.GeoConvert.LonLat2Pos(ExtPoint(str2r(paramstr(3)),str2r(paramstr(4))),(GState.zoom_size - 1) + 8);
 end;

 zooming(GState.Zoom_size,false);
 MapMoving:=false;
 Fsaveas.PageControl1.ActivePageIndex:=0;

 SetProxy;

 if GState.WebReportToAuthor then WebBrowser1.Navigate('http://sasgis.ru/stat/index.html');
 Enabled:=true;
 SetFocus;
 if (FLogo<>nil)and(FLogo.Visible) then FLogo.Timer1.Enabled:=true;
 FUIDownLoader := TTileDownloaderUI.Create;
end;


procedure TFmain.zooming(x:byte;move:boolean);
  procedure usleep(mils:integer);
  var startTS,endTS,freqTS:int64;
  begin
   if mils>0 then begin
     QueryPerformanceCounter(startTS);
     repeat
       QueryPerformanceCounter(endTS);
       QueryPerformanceFrequency(freqTS);
     until ((endTS-startTS)/(freqTS/1000))>mils;
   end;
  end;
var w,i,steps,d_moveH,d_moveW:integer;
    w1:extended;
    ts1,ts2,fr:int64;
begin
 if x<=1  then TBZoom_Out.Enabled:=false
          else TBZoom_Out.Enabled:=true;
 if x>=24 then TBZoomIn.Enabled:=false
          else TBZoomIn.Enabled:=true;
 NZoomIn.Enabled:=TBZoomIn.Enabled;
 NZoomOut.Enabled:=TBZoom_Out.Enabled;
 if (MapZoomAnimtion=1)or(MapMoving)or(x<1)or(x>24) then exit;
 MapZoomAnimtion:=1;
 labZoom.caption:=' '+inttostr(GState.zoom_size)+'x ';
 labZoom.caption:=' '+inttostr(x)+'x ';
 RxSlider1.Value:=x-1;
 steps:=10;
 d_moveH:=0;
 d_moveW:=0;
 if GState.zoom_size>x
  then begin
         w:=-steps*2;
         w1:=-steps;
         ScreenCenterPos := Point(trunc(ScreenCenterPos.x/power(2,GState.zoom_size-x)),trunc(ScreenCenterPos.y/power(2,GState.zoom_size-x)));
         if (move)and(abs(x-GState.zoom_size)=1) then begin
           ScreenCenterPos:=Point(ScreenCenterPos.x+(mWd2-m_m.X)div 2,ScreenCenterPos.y+(mHd2-m_m.y)div 2);
           d_moveW:=((mWd2-m_m.X) div 2);
           d_moveH:=((mHd2-m_m.Y) div 2);
         end;
       end
  else begin
         w:=steps;
         w1:=steps / 2;
         ScreenCenterPos:=Point(trunc(ScreenCenterPos.x*power(2,x-GState.zoom_size)),trunc(ScreenCenterPos.y*power(2,x-GState.zoom_size)));
         if (move)and(abs(x-GState.zoom_size)=1) then begin
           ScreenCenterPos:=Point(ScreenCenterPos.x-(mWd2-m_m.X),ScreenCenterPos.y-(mHd2-m_m.y));
           d_moveW:=(mWd2-m_m.X);
           d_moveH:=(mHd2-m_m.Y);
         end;
       end;
 LayerMapNal.Bitmap.Clear(clBlack);
 LayerMapgps.Bitmap.Clear(clBlack);
 LayerMapWiki.Visible:=false;
 if (abs(x-GState.zoom_size)=1)and(GState.AnimateZoom) then begin
   for i:=0 to steps-1 do begin
     QueryPerformanceCounter(ts1);
     if (move)
      then LayerMap.Location:=
              floatrect(bounds(round(mWd2-pr_x-(pr_x/w*i)+((mWd2-m_m.X)/w1/2*i)),
                               round(mHd2-pr_y-(pr_y/w*i)+((mHd2-m_m.y)/w1/2*i)),
                               xhgpx+round(pr_x/w*i*2),yhgpx+round(pr_y/w*i*2)))
      else LayerMap.Location:=
              floatrect(bounds(mWd2-pr_x-round((pr_x/w)*i),mHd2-pr_y-round((pr_y/w)*i),
                               xhgpx+round((pr_x/w)*i*2),yhgpx+round((pr_y/w)*i*2)));
              FillingMap.Location:=LayerMap.Location;
     if (LayerMapMarks.Visible) then LayerMapMarks.Location:=LayerMap.Location;
     application.ProcessMessages;
     QueryPerformanceCounter(ts2);
     QueryPerformanceFrequency(fr);
     ts1:=round((ts2-ts1)/(fr/1000));
     if (22-ts1>0) then begin
       usleep(22-ts1);
     end;
   end;
   if GState.zoom_size<x
    then LayerMap.Location:=floatrect(bounds(mWd2-pr_x*2+d_moveW,mHd2-pr_y*2+d_moveH,xhgpx*2,yhgpx*2))
    else LayerMap.Location:=floatrect(bounds(mWd2-pr_x div 2-d_moveW,mHd2-pr_y div 2-d_moveH,xhgpx div 2,yhgpx div 2));
   application.ProcessMessages;
 end;

 GState.zoom_size:=x;
 generate_im(nilLastLoad,'');
 MapZoomAnimtion:=0;
 toSh;
end;

procedure TFmain.NzoomInClick(Sender: TObject);
begin
 zooming(GState.zoom_size+1,false);
end;

procedure TFmain.NZoomOutClick(Sender: TObject);
begin
 zooming(GState.zoom_size-1,false);
end;

procedure TFmain.FormCreate(Sender: TObject);
begin
 Application.Title:=Caption;
 TBiniLoadPositions(Self,GState.MainIni,'PANEL_');
 TBEditPath.Visible:=false;
 Caption:=Caption+' '+SASVersion;
 ProgramStart:=true;
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ProgramClose:=true;
 FUIDownLoader.Terminate;
 WaitForSingleObject(FUIDownLoader.Handle, 0);
 FreeAndNil(FUIDownLoader);
 if length(MapType)<>0 then FSettings.Save;
 FreeAndNil(GMiniMap);
end;

procedure TFmain.TBmoveClick(Sender: TObject);
begin
 setalloperationfalse(ao_movemap);
end;

procedure TFmain.TBZoom_outClick(Sender: TObject);
begin
 zooming(GState.Zoom_size-1,false);
end;

procedure TFmain.TBZoomInClick(Sender: TObject);
begin
 zooming(GState.Zoom_size+1,false);
end;

procedure TFmain.WMGetMinMaxInfo(var msg:TWMGetMinMaxInfo);
begin
 inherited;
 with msg.MinMaxInfo^.ptMaxTrackSize do begin
  X:=GetDeviceCaps(Canvas.handle,HORZRES)+(Width-ClientWidth);
  Y:=GetDeviceCaps(Canvas.handle,VERTRES)+(Height-ClientHeight);
 end;
end;

procedure TFmain.TBFullSizeClick(Sender:TObject);
begin
 NFoolSize.Checked:=TBFullSize.Checked;
 TBexit.Visible:=TBFullSize.Checked;
 GState.FullScrean:=TBFullSize.Checked;
 TBDock.Parent:=Self;
 TBDockLeft.Parent:=Self;
 TBDockBottom.Parent:=Self;
 TBDockRight.Parent:=Self;
 TBDock.Visible:=not(TBFullSize.Checked);
 TBDockLeft.Visible:=not(TBFullSize.Checked);
 TBDockBottom.Visible:=not(TBFullSize.Checked);
 TBDockRight.Visible:=not(TBFullSize.Checked);
 if TBFullSize.Checked then
  begin
   RectWindow:=Self.BoundsRect;
   SetBounds(Left-ClientOrigin.X,Top-ClientOrigin.Y,GetDeviceCaps(Canvas.handle,
   HORZRES)+(Width-ClientWidth),GetDeviceCaps(Canvas.handle,VERTRES)+(Height-ClientHeight));
  end
  else Self.BoundsRect:=RectWindow;
end;

procedure TextToHTMLDoc(Text: string; var Document: IHTMLDocument2);
var
  V: OleVariant;
begin
  try
   V:=VarArrayCreate([0, 0], varVariant);
   V[0]:=Text;
   Document.Write(PSafeArray(TVarData(v).VArray));
  finally
   Document.Close;
  end;
end;

procedure TextToWebBrowser(Text: string; var WB: TEmbeddedWB);
var
  Document: IHTMLDocument2;
  V: OleVariant;
begin
  if WB.Document = nil then WB.Navigate('about:blank');
  while WB.Document = nil do
    Application.ProcessMessages;
  Document := WB.Document as IHtmlDocument2;
  try
   V:=VarArrayCreate([0, 0], varVariant);
   V[0]:=Text;
   Document.Write(PSafeArray(TVarData(v).VArray));
  finally
   Document.Close;
  end;
end;

procedure TFmain.ZoomToolBarDockChanging(Sender: TObject; Floating: Boolean; DockingTo: TTBDock);
begin
 if (DockingTo=TBDockLeft)or(DockingTo=TBDockRight)
   then begin
         RxSlider1.Orientation:=RxSlider.soVertical;
         TTBToolBar(sender).Items.Move(TTBToolBar(sender).Items.IndexOf(TBZoom_out),4);
         TTBToolBar(sender).Items.Move(TTBToolBar(sender).Items.IndexOf(TBZoomin),0);
        end
   else begin
         RxSlider1.Orientation:=RxSlider.soHorizontal;
         TTBToolBar(sender).Items.Move(TTBToolBar(sender).Items.IndexOf(TBZoom_out),0);
         TTBToolBar(sender).Items.Move(TTBToolBar(sender).Items.IndexOf(TBZoomin),4);
        end
end;


procedure TFmain.RxSlider1Change(Sender: TObject);
begin
 labZoom.Caption:=' '+inttostr(RxSlider1.Value+1)+'x ';
end;

procedure TFmain.RxSlider1Changed(Sender: TObject);
begin
 zooming(RxSlider1.Value+1,false);
 SetFocusedControl(map);
end;

procedure TFmain.NMainToolBarShowClick(Sender: TObject);
begin
 TBMainToolBar.Visible:=NMainToolBarShow.Checked;
end;

procedure TFmain.NGPSToolBarShowClick(Sender: TObject);
begin
 GPSToolBar.Visible:=NGPSToolBarShow.Checked;
end;

procedure TFmain.NZoomToolBarShowClick(Sender: TObject);
begin
 ZoomToolBar.Visible:=NZoomToolBarShow.Checked;
end;

procedure TFmain.NsrcToolBarShowClick(Sender: TObject);
begin
 SrcToolbar.Visible:=NsrcToolBarShow.Checked;
end;

procedure TFmain.NCalcRastClick(Sender: TObject);
begin
 TBCalcRas.Checked:=true;
 TBCalcRasClick(self);
end;

procedure TFmain.NFoolSizeClick(Sender: TObject);
begin
 TBFullSize.Checked:=NFoolSize.Checked;
 TBFullSizeClick(Sender);
end;

procedure TFmain.N6Click(Sender: TObject);
begin
 close;
end;

procedure TFmain.TBmap1Click(Sender: TObject);
begin
 selectMap(TMapType(TTBXItem(sender).tag));
end;

procedure TFmain.N8Click(Sender: TObject);
begin
 fsettings.ShowModal;
end;

procedure TFmain.NbackloadClick(Sender: TObject);
begin
 GState.UsePrevZoom := Nbackload.Checked;
 generate_im(nilLastLoad,'');
end;

procedure TFmain.NbackloadLayerClick(Sender: TObject);
begin
 GState.UsePrevZoomLayer := NbackloadLayer.Checked;
 generate_im(nilLastLoad,'');
end;

procedure TFmain.NaddPointClick(Sender: TObject);
begin
  if FAddPoint.show_(sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(m_up), GState.zoom_size-1), true) then
    generate_im(nilLastLoad,'');
end;

procedure TFmain.N20Click(Sender: TObject);
var btm:TBitmap32;
    btm1:TBitmap;
    VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(move);
 btm:=TBitmap32.Create;
 if sat_map_both.LoadTile(btm,X2absX(VPoint.X,GState.zoom_size), VPoint.Y, GState.zoom_size,false)
  then begin
        btm1:=TBitmap.Create;
        btm1.Width:=256; btm1.Height:=256;
        btm.DrawTo(btm1.Canvas.Handle,0,0);
        CopyBtmToClipboard(btm1);
        btm1.Free;
       end;
 btm.Free;
end;

procedure TFmain.N30Click(Sender: TObject);
var ll:TExtendedPoint;
begin
 ll:=sat_map_both.GeoConvert.Pos2LonLat(VisiblePixel2MapPixel(move),(GState.zoom_size - 1) + 8);
 if GState.FirstLat then CopyStringToClipboard(lat2str(ll.y, GState.llStrType)+' '+lon2str(ll.x, GState.llStrType))
             else CopyStringToClipboard(lon2str(ll.x, GState.llStrType)+' '+lat2str(ll.y, GState.llStrType));
end;

procedure TFmain.N15Click(Sender: TObject);
var
  VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(move);
 // ����������� � ����� ����� � ������ ������. �������� �� ���������� ��� �����.
 CopyStringToClipboard(sat_map_both.GetTileFileName(X2AbsX(VPoint.X,GState.zoom_size), VPoint.Y, GState.zoom_size));
end;

procedure TFmain.N21Click(Sender: TObject);
var path:string;
    APos:TPoint;
    AMapType:TMapType;
    VLoadPoint: TPoint;
begin
 if TMenuItem(sender).Tag=0 then AMapType:=sat_map_both
                            else AMapType:=TMapType(TMenuItem(sender).Tag);
 APos := sat_map_both.GeoConvert.Pos2OtherMap(ScreenCenterPos, (GState.zoom_size - 1) + 8, AMapType.GeoConvert);
 //��� ����� ��� ������ � ���������. �������� �� ������������ ��� �����
 VLoadPoint.x := Apos.x-(mWd2-m_up.x);
 VLoadPoint.y := Apos.y-(mHd2-m_up.y);

 path:=AMapType.GetTileFileName(VLoadPoint.x, VLoadPoint.Y,GState.zoom_size);

 if ((not(AMapType.tileExists(VLoadPoint.x,VLoadPoint.y,GState.zoom_size)))or
  (MessageBox(handle,pchar(SAS_STR_file+' '+path+' '+SAS_MSG_FileExists),pchar(SAS_MSG_coution),36)=IDYES))
 then begin
  TTileDownloaderUIOneTile.Create(VLoadPoint, GState.zoom_size, AMapType);
 end;
end;

procedure TFmain.N11Click(Sender: TObject);
var
  WindirP: PChar;
  btm_ex:TBitmap;
  path: string;
begin
  WinDirP:=StrAlloc(MAX_PATH);
  GetWindowsDirectory(WinDirP, MAX_PATH);
  path := StrPas(WinDirP)+'\SASwallpaper.bmp';
  btm_ex:=TBitmap.Create;
  try
    btm_ex.Assign(LayerMap.bitmap);
    btm_ex.SaveToFile(path);
  finally
    btm_ex.Free;
  end;
  with TRegIniFile.Create('Control Panel') do
   begin
    WriteString('desktop', 'Wallpaper', StrPas(WinDirP)+'\SASwallpaper.bmp');
    WriteString('desktop', 'TileWallpaper', '0');
    free;
   end;
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDWININICHANGE);
end;

procedure TFmain.NopendirClick(Sender: TObject);
var
  VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(m_m);
  // ������� ���� � ������������. �������� �� �������� ����������� ������� ��� ��� �������� ������� �� ��������� ����.
 ShellExecute(0,'open',PChar(sat_map_both.GetTileFileName(VPoint.X, VPoint.Y, GState.zoom_size)),nil,nil,SW_SHOWNORMAL);
end;

procedure TFmain.N25Click(Sender: TObject);
var s:string;
    i:integer;
  VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(m_m);
  s:=sat_map_both.GetTileFileName(VPoint.X, VPoint.Y, GState.zoom_size);
 for i:=length(s) downto 0 do if s[i]='\'then break;
 // ������� ����� � ����� � ����������. �������� �� �������� ����������� ������� ��� ��� �������� ������� �� ��������� ����.
 ShellExecute(0,'open',PChar(copy(s,1,i)),nil,nil,SW_SHOWNORMAL);
end;

procedure TFmain.NDelClick(Sender: TObject);
var s:string;
    AMapType:TMapType;
    APos:TPoint;
    VLoadPoint: TPoint;
begin
 if TMenuItem(sender).Tag=0 then AMapType:=sat_map_both
                            else AMapType:=TMapType(TMenuItem(sender).Tag);
 APos := sat_map_both.GeoConvert.Pos2OtherMap(ScreenCenterPos, (GState.zoom_size - 1) + 8, AMapType.GeoConvert);
 VLoadPoint.X := APos.x-(mWd2-m_up.x);
 VLoadPoint.Y := APos.y-(mHd2-m_up.y);
 //��� ����� ��� ������ � ���������. �������� �� ������������ ��� �����
 s:=AMapType.GetTileFileName(VLoadPoint.X, VLoadPoint.Y, GState.zoom_size);
 if (MessageBox(handle,pchar(SAS_MSG_youasure+' '+s+'?'),pchar(SAS_MSG_coution),36)=IDYES)
  then begin
        if AMapType.TileExists(VLoadPoint.X, VLoadPoint.Y, GState.zoom_size) then
          AMapType.DeleteTile(VLoadPoint.X, VLoadPoint.Y, GState.zoom_size);
        generate_im(nilLastLoad,'');
       end;
       
end;

procedure TFmain.NSRCinetClick(Sender: TObject);
begin
 Tilesource:=TTileSource(TTBXItem(Sender).Tag);
end;

procedure TFmain.N16Click(Sender: TObject);
begin
 fabout.ShowModal;
end;

procedure TFmain.TBREGIONClick(Sender: TObject);
begin
 TBRectSave.ImageIndex:=9;
 TBRectSave.Checked:=true;
 setalloperationfalse(ao_reg);
end;

procedure TFmain.TBRECTClick(Sender: TObject);
begin
 TBRectSave.ImageIndex:=6;
 TBRectSave.Checked:=true;
 setalloperationfalse(ao_rect);
end;

procedure TFmain.TBRectSaveClick(Sender: TObject);
begin
 if TBRectSave.ImageIndex=6 then setalloperationfalse(ao_rect)
                            else setalloperationfalse(ao_reg)
end;

procedure TFmain.TBPreviousClick(Sender: TObject);
begin
 if length(poly_save)>0 then fsaveas.Show_(poly_zoom_save,poly_save)
                        else showmessage(SAS_MSG_NeedHL);
end;

//����� ���������� � �������� ����
procedure TFmain.NFillMapClick(Sender: TObject);
begin
 TBXToolPalette1.SelectedCell:=Point(GState.zoom_mapzap mod 5,GState.zoom_mapzap div 5);
end;

procedure TFmain.TBXToolPalette1CellClick(Sender: TTBXCustomToolPalette; var ACol, ARow: Integer; var AllowChange: Boolean);
begin
 GState.zoom_mapzap:=(5*ARow)+ACol;
 if GState.zoom_mapzap>0 then TBMapZap.Caption:='x'+inttostr(GState.zoom_mapzap)
                  else TBMapZap.Caption:='';
 generate_im(nilLastLoad,'');
end;
//X-����� ���������� � �������� ����

procedure TFmain.TBCalcRasClick(Sender: TObject);
begin
 setalloperationfalse(ao_line);
end;

procedure TFmain.NCiclMapClick(Sender: TObject);
begin
 GState.ciclmap:=NCiclMap.Checked;
 generate_im(nilLastLoad,'');
end;

procedure TFmain.N012Click(Sender: TObject);
var
  VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(m_up);

 topos(sat_map_both.FCoordConverter.PixelPos2LonLat(VPoint, GState.zoom_size-1),TMenuItem(sender).tag,true);
end;

procedure TFmain.N29Click(Sender: TObject);
begin
 ShellExecute(0,'open',PChar(GState.HelpFileName),nil,nil,SW_SHOWNORMAL);
end;

procedure TFmain.selectMap(num:TMapType);
var ll:TExtendedPoint;
    i:integer;
begin
 if MapZoomAnimtion=1 then exit;
 LL:=sat_map_both.FCoordConverter.PixelPos2LonLat(ScreenCenterPos, GState.zoom_size-1);
 if not(num.asLayer) then
  begin
   if (num.showinfo)and(num.info<>'') then
    begin
     ShowMessage(num.info);
     num.showinfo:=false;
    end;
   sat_map_both.TBItem.Checked:=false;
   sat_map_both.active:=false;
   sat_map_both:=num;
   TBSMB.ImageIndex:=sat_map_both.TBItem.ImageIndex;
   sat_map_both.TBItem.Checked:=true;
   sat_map_both.active:=true;
   if GState.Showmapname then TBSMB.Caption:=sat_map_both.name
                  else TBSMB.Caption:='';
  end else
  begin
   num.active:=not(num.active);
   For i:=0 to length(MapType)-1 do
    if maptype[i].asLayer then
    begin
     MapType[i].TBItem.Checked:=MapType[i].active;
    end;
  end;
 topos(ll,GState.zoom_size,false);
end;

procedure TFmain.EditGoogleSrchAcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
var s,slat,slon,par:string;
    i,j:integer;
    err:boolean;
    lat,lon:real;
    Buffer:array [1..64535] of char;
    BufferLen:LongWord;
    hSession,hFile:Pointer;
    dwindex, dwcodelen,dwReserv: dword;
    dwtype: array [1..20] of char;
    strr:string;
begin
 s:='';
 hSession:=InternetOpen(pChar('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)'),INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
 
 if Assigned(hSession)
  then begin
        for i:=1 to length(NewText) do
         if NewText[i]=' ' then NewText[i]:='+';

        strr:='http://maps.google.com/maps/geo?q='+URLEncode(AnsiToUtf8(NewText))+'&output=xml&hl=ru&key=ABQIAAAA5M1y8mUyWUMmpR1jcFhV0xSHfE-V63071eGbpDusLfXwkeh_OhT9fZIDm0qOTP0Zey_W5qEchxtoeA';
        hFile:=InternetOpenUrl(hSession,PChar(strr),PChar(par),length(par),INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_RELOAD,0);
        if Assigned(hFile)then
         begin
          dwcodelen:=150; dwReserv:=0; dwindex:=0;
          if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
           then dwindex:=strtoint(pchar(@dwtype));
          if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then
           begin
            if (not GState.InetConnect.userwinset)and(GState.InetConnect.uselogin) then
             begin
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_USERNAME,PChar(GState.InetConnect.loginstr), length(GState.InetConnect.loginstr));
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_PASSWORD,PChar(GState.InetConnect.passstr), length(GState.InetConnect.Passstr));
              HttpSendRequest(hFile, nil, 0,Nil, 0);
             end;
            dwcodelen:=150; dwReserv:=0; dwindex:=0;
            if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
             then dwindex:=strtoint(pchar(@dwtype));
            if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then //�������� ������ �����
             begin
             	ShowMessage(SAS_ERR_Authorization);
              InternetCloseHandle(hFile);
              InternetCloseHandle(hSession);
              exit;
             end;
           end;

          repeat
           err:=not(internetReadFile(hFile,@Buffer,SizeOf(Buffer),BufferLen));
           s:=s+Buffer;
          until (BufferLen=0)and(BufferLen<SizeOf(Buffer))and(err=false);

          if PosEx(AnsiToUtf8('Placemark'),s)<1 then
           begin
            ShowMessage(SAS_STR_notfound);
            exit;
           end;
          i:=PosEx('<address>',s);
          j:=PosEx('</address>',s);
          strr:=Utf8ToAnsi(Copy(s,i+9,j-(i+9)));
          i:=PosEx('<coordinates>',s);
          j:=PosEx(',',s,i+13);
          slon:=Copy(s,i+13,j-(i+13));
          i:=PosEx(',0</coordinates>',s,j);
          slat:=Copy(s,j+1,i-(j+1));
          if slat[1]='\' then delete(slat,1,1);
          if slon[1]='\' then delete(slon,1,1);
          try
           lat:=str2r(slat);
           lon:=str2r(slon);
          except
           ShowMessage('������ ��� ����������� ���������!'+#13#10+'�������� ����������� ����������� � ���������,'+#13#10+'��� ������ ������� ������.');
           exit;
          end;
          toPos(ExtPoint(lon,lat),GState.zoom_size,true);
          ShowMessage(SAS_STR_foundplace+' "'+strr+'"');
         end
        else ShowMessage(SAS_ERR_Noconnectionstointernet);
       end
  else ShowMessage(SAS_ERR_Noconnectionstointernet);
end;

procedure TFmain.TBSubmenuItem1Click(Sender: TObject);
begin
 FGoTo.ShowModal;
 end;

procedure TFmain.TBMainToolBarClose(Sender: TObject);
begin
 if sender=TBMainToolBar then NMainToolBarShow.Checked:=false;
 if sender=SrcToolbar then NsrcToolBarShow.Checked:=false;
 if sender=ZoomToolBar then NZoomToolBarShow.Checked:=false;
 if sender=GPSToolBar then NGPSToolBarShow.Checked:=false;
 if sender=TBMarksToolBar then NMarksBarShow.Checked:=false;
end;

procedure TFmain.N000Click(Sender: TObject);
begin
 zoom_line:=TMenuItem(Sender).Tag;
 generate_im(nilLastLoad,'');
end;

procedure TFmain.NShowGranClick(Sender: TObject);
var i:integer;
begin
 if zoom_line=0 then NShowGran.Items[0].Checked:=true;
 if zoom_line=99 then NShowGran.Items[1].Checked:=true;
 NShowGran.Items[1].Caption:=SAS_STR_activescale+' (�'+inttostr(GState.zoom_size)+')';
 for i:=2 to 7 do
  if GState.zoom_size+i-2<24 then begin
                            NShowGran.Items[i].Caption:=SAS_STR_for+' �'+inttostr(GState.zoom_size+i-2);
                            NShowGran.Items[i].Visible:=true;
                            NShowGran.Items[i].Tag:=GState.zoom_size+i-2;
                            if NShowGran.Items[i].Tag=zoom_line then NShowGran.Items[i].Checked:=true
                                                                else NShowGran.Items[i].Checked:=false;
                           end
                      else NShowGran.Items[i].Visible:=false;
end;

procedure TFmain.TBItem2Click(Sender: TObject);
begin
 close;
end;

procedure TFmain.TBGPSconnClick(Sender: TObject);
begin
 try
 NGPSconn.Checked:=TTBXitem(sender).Checked;
 TBGPSconn.Checked:=TTBXitem(sender).Checked;
 LayerMapGPS.Visible:=NGPSconn.Checked;
 GState.GPS_enab := TBGPSconn.Checked;
 if GState.GPS_enab then
  begin
   GPSReceiver.Delay:=GState.GPS_Delay;
   GPSReceiver.ConnectionTimeout:=GState.GPS_TimeOut;
   GPSReceiver.Port :=  GPSReceiver.StringToCommPort(GState.GPS_COM);
   if GPSReceiver.BaudRate<>GPSReceiver.IntToBaudRate(GState.GPS_BaudRate) then
     GPSReceiver.BaudRate:=GPSReceiver.IntToBaudRate(GState.GPS_BaudRate);
   GPSReceiver.NeedSynchronization:=true;
   try
    GPSReceiver.Open;
   except
    ShowMessage(SAS_ERR_PortOpen);
    GPSReceiver.Close;
   end;
  end
  else GPSReceiver.Close;
 except
 end;
end;

procedure TFmain.TBGPSPathClick(Sender: TObject);
begin
 NGPSPath.Checked:=TTBXitem(sender).Checked;
 TBGPSPath.Checked:=TTBXitem(sender).Checked;
 GState.GPS_ShowPath:=TBGPSPath.Checked;
end;

procedure TFmain.TBGPSToPointClick(Sender: TObject);
begin
 NGPSToPoint.Checked:=TTBXitem(sender).Checked;
 TBGPSToPoint.Checked:=TTBXitem(sender).Checked;
 GState.GPS_MapMove:=TBGPSToPoint.Checked;
end;

procedure TFmain.TBCOORDClick(Sender: TObject);
var
  Poly: TExtendedPointArray;
begin
 FSelLonLat:= TFSelLonLat.Create(Self);
        Try
          if FSelLonLat.Execute Then
             Begin
              SetLength(Poly, 5);
              Poly[0] := ExtPoint(FSelLonLat._lon_k,FSelLonLat._lat_k);
              Poly[1] := ExtPoint(FSelLonLat.lon_k,FSelLonLat._lat_k);
              Poly[2] := ExtPoint(FSelLonLat.lon_k,FSelLonLat.lat_k);
              Poly[3] := ExtPoint(FSelLonLat._lon_k,FSelLonLat.lat_k);
              Poly[4] := ExtPoint(FSelLonLat._lon_k,FSelLonLat._lat_k);
              fsaveas.Show_(GState.zoom_size, Poly);
              Poly := nil;
             End;
        Finally
          FSelLonLat.Free;
        End;
 TBmoveClick(Sender);
end;

procedure TFmain.SetStatusBarVisible();
begin
 LayerStatBar.Visible:=GState.ShowStatusBar;
 mapResize(nil);
 Showstatus.Checked:=GState.ShowStatusBar;
end;

procedure TFmain.SetLineScaleVisible(visible:boolean);
begin
 LayerLineM.visible:=visible;
 paint_Line;
 ShowLine.Checked:=visible;
end;

procedure TFmain.SetMiniMapVisible(visible:boolean);
begin
  GMiniMap.SetMiniMapVisible(visible, ScreenCenterPos);
  ShowMiniMap.Checked:=visible;
end;

procedure TFmain.ShowstatusClick(Sender: TObject);
begin
  GState.ShowStatusBar := Showstatus.Checked;
  SetStatusBarVisible();
end;

procedure TFmain.ShowMiniMapClick(Sender: TObject);
begin
 SetMiniMapVisible(ShowMiniMap.Checked);
end;

procedure TFmain.ShowLineClick(Sender: TObject);
begin
 SetLineScaleVisible(ShowLine.Checked)
end;

procedure TFmain.NMMtype_0Click(Sender: TObject);
begin
 if TTBXItem(sender).Tag=0 then begin
                                  if GMiniMap.MapType<>nil then begin
                                    GMiniMap.MapType.ShowOnSmMap:=false;
                                    GMiniMap.MapType.NSmItem.Checked:=false;
                                    GMiniMap.maptype:=nil;
                                  end;  
                                  NMMtype_0.Checked:=true;
                                 end
 else
 if TMapType(TTBXItem(sender).Tag).asLayer then
   begin
    TMapType(TTBXItem(sender).Tag).ShowOnSmMap:=not(TMapType(TTBXItem(sender).Tag).ShowOnSmMap);
    TTBXItem(sender).Checked:=TMapType(TTBXItem(sender).Tag).ShowOnSmMap;
   end else
   begin
    NMMtype_0.Checked:=false;
    if GMiniMap.maptype<>nil then begin
                                        GMiniMap.MapType.ShowOnSmMap:=false;
                                        GMiniMap.MapType.NSmItem.Checked:=false;
                                       end;
    GMiniMap.maptype:=TMapType(TTBXItem(sender).Tag);
    GMiniMap.maptype.NSmItem.Checked:=true;
    GMiniMap.maptype.ShowOnSmMap:=true;
   end;
  GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos);
end;

procedure TFmain.N32Click(Sender: TObject);
begin
 LayerMapScale.Visible:=TTBXItem(sender).Checked;
 if LayerMapScale.Visible then LayerMapScale.BringToFront
                          else LayerMapScale.SendToBack;
end;

procedure TFmain.TBItem3Click(Sender: TObject);
var F:TextFile;
    i:integer;
    SaveDlg: TSaveDialog;
begin
Fprogress2.Visible:=true;
fprogress2.MemoInfo.Lines[0]:=SAS_STR_savetreck;
Fprogress2.ProgressBar1.Max:=100;
SaveDlg := TSaveDialog.Create(Fprogress2);
SaveDlg.DefaultExt:='*.kml';
SaveDlg.Filter:='KML|*.kml';
Fprogress2.ProgressBar1.Progress1:=0;
if (SaveDlg.Execute)and(SaveDlg.FileName<>'') then
 begin
  AssignFile(f,SaveDlg.FileName);
  rewrite(f);
  Fprogress2.ProgressBar1.Progress1:=10;
  Writeln(f,'<?xml version="1.0" encoding="UTF-8"?>');
  Writeln(f,'<kml xmlns="http://earth.google.com/kml/2.1">');
 	Writeln(f,'<Folder>');
  Fprogress2.ProgressBar1.Progress1:=20;
  Writeln(f,'	<name>'+ ExtractFileName(SaveDlg.FileName)+'</name>');
	Writeln(f,'	<open>0</open>');
	Writeln(f,'<Style>');
	Writeln(f,'	<ListStyle>');
  Fprogress2.ProgressBar1.Progress1:=30;
	Writeln(f,'		<listItemType>checkHideChildren</listItemType>');
	Writeln(f,'		<bgColor>00ffffff</bgColor>');
	Writeln(f,'	</ListStyle>');
  Fprogress2.ProgressBar1.Progress1:=40;
	Writeln(f,'</Style>');
  Writeln(f,'<Placemark>');
	Writeln(f,'<name>'+ExtractFileName(SaveDlg.FileName)+'</name>');
  Fprogress2.ProgressBar1.Progress1:=50;
	Writeln(f,'<Style>');
	Writeln(f,'	<LineStyle>');
	Writeln(f,'		<color>ff000000</color>');
  Fprogress2.ProgressBar1.Progress1:=60;
	Writeln(f,'	</LineStyle>');
	Writeln(f,'</Style>');
	Writeln(f,'<LineString>');
  Fprogress2.ProgressBar1.Progress1:=70;
	Writeln(f,'	<tessellate>1</tessellate>');
	Writeln(f,'	<altitudeMode>absolute</altitudeMode>');
	Writeln(f,' <coordinates>');
  Fprogress2.ProgressBar1.Progress1:=80;
  for i:=0 to length(GState.GPS_TrackPoints)-1 do
   Writeln(f,R2strPoint(GState.GPS_TrackPoints[i].x),',',R2strPoint(GState.GPS_TrackPoints[i].y),',0');
  Writeln(f,' </coordinates>');
  Fprogress2.ProgressBar1.Progress1:=90;
	Writeln(f,'</LineString>');
  Writeln(f,'</Placemark>');
	Writeln(f,'</Folder>'+#13#10+'</kml>');
  CloseFile(f);
 end;
 Fprogress2.ProgressBar1.Progress1:=100;
 Fprogress2.Visible:=false;
 SaveDlg.Free;
end;

procedure TFmain.TBItem5Click(Sender: TObject);
begin
 if length(GState.GPS_TrackPoints)>1 then begin
                            if FaddLine.show_(GState.GPS_TrackPoints,true) then
                             begin
                              setalloperationfalse(ao_movemap);
                              generate_im(nilLastLoad,'');
                             end; 
                           end
                      else ShowMessage(SAS_ERR_Nopoints);
end;

procedure TFmain.Google1Click(Sender: TObject);
var Apos:tExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos,(GState.zoom_size - 1) + 8);
 CopyStringToClipboard('http://maps.google.com/?ie=UTF8&ll='+R2StrPoint(Apos.y)+','+R2StrPoint(Apos.x)+'&spn=57.249013,100.371094&t=h&z='+inttostr(GState.zoom_size-1));
end;

procedure TFmain.YaLinkClick(Sender: TObject);
var Apos:tExtendedPoint;
  VRect: TExtendedRect;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos, (GState.zoom_size - 1) + 8);
 VRect := sat_map_both.GeoConvert.PixelRect2LonLatRect(VisiblePixelRect, (GState.zoom_size - 1));
 CopyStringToClipboard('http://beta-maps.yandex.ru/?ll='+R2StrPoint(round(Apos.x*100000)/100000)+'%2C'+R2StrPoint(round(Apos.y*100000)/100000)+'&spn='+R2StrPoint(abs(VRect.Left-VRect.Right))+'%2C'+R2StrPoint(abs(VRect.Top-VRect.Bottom))+'&l=sat');
end;

procedure TFmain.kosmosnimkiru1Click(Sender: TObject);
var Apos:tExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos,(GState.zoom_size - 1) + 8);
 CopyStringToClipboard('http://kosmosnimki.ru/?x='+R2StrPoint(Apos.x)+'&y='+R2StrPoint(Apos.y)+'&z='+inttostr(GState.zoom_size-1)+'&fullscreen=false&mode=satellite');
end;

procedure TFmain.mapResize(Sender: TObject);
begin
 if (ProgramClose<>true)and(not(ProgramStart))then
  begin
   mWd2:=map.Width shr 1;
   mHd2:=map.Height shr 1;
   LayerStatBar.Location:=floatrect(0,map.Height-17,map.Width,map.Height);
   if GState.ShowStatusBar
    then begin
          with LayerLineM do location:=floatrect(location.left,map.Height-23-17,location.right,map.Height-8-17);
         end
    else begin
          with LayerLineM do location:=floatrect(location.left,map.Height-23,location.right,map.Height-8);
         end;
   LayerMap.Location:=floatrect(MapLayerLocationRect);
   FillingMap.Location:=LayerMap.Location;
   LayerMapNal.Location:=floatrect(MapLayerLocationRect);
   LayerMapMarks.Location:=floatrect(MapLayerLocationRect);
   LayerMapGPS.Location:=floatrect(MapLayerLocationRect);
   LayerMapWiki.Location:=floatrect(MapLayerLocationRect);
   LayerMapScale.location:=floatrect(bounds(mWd2-145,mHd2-145,290,290));
   toSh;
   GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos)
  end;
end;

procedure TFmain.TBLoadSelFromFileClick(Sender: TObject);
var ini:TMemIniFile;
    i:integer;
begin
 if (OpenDialog1.Execute)and(OpenDialog1.FileName<>'') then
  begin
   ini:=TMemIniFile.Create(OpenDialog1.FileName);
   i:=1;
   while str2r(Ini.ReadString('HIGHLIGHTING','PointLon_'+inttostr(i),'2147483647'))<>2147483647 do
    begin
     setlength(poly_save,i);
     poly_save[i-1].x:=str2r(Ini.ReadString('HIGHLIGHTING','PointLon_'+inttostr(i),'2147483647'));
     poly_save[i-1].y:=str2r(Ini.ReadString('HIGHLIGHTING','PointLat_'+inttostr(i),'2147483647'));
     inc(i);
    end;
   if length(poly_save)>0 then
    begin
     poly_zoom_save:=Ini.Readinteger('HIGHLIGHTING','zoom',1);
     fsaveas.Show_(poly_zoom_save,poly_save);
    end;
  end
end;

function GetStreamFromURL(var ms:TMemoryStream;url:string;conttype:string):integer;
var par,ty:string;
    err:boolean;
    Buffer:array [1..64535] of char;
    BufferLen:LongWord;
    hSession,hFile:Pointer;
    dwtype: array [1..20] of char;
    dwindex, dwcodelen,dwReserv: dword;
begin
 hSession:=InternetOpen(pChar('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)'),INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
 if Assigned(hSession)
  then begin
        hFile:=InternetOpenURL(hSession,PChar(URL),PChar(par),length(par), INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_RELOAD,0);
        if Assigned(hFile)then
         begin
          dwcodelen:=150; dwReserv:=0; dwindex:=0;
          if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
           then dwindex:=strtoint(pchar(@dwtype));
          if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then
           begin
            if (not GState.InetConnect.userwinset)and(GState.InetConnect.uselogin) then
             begin
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_USERNAME,PChar(GState.InetConnect.loginstr), length(GState.InetConnect.loginstr));
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_PASSWORD,PChar(GState.InetConnect.passstr), length(GState.InetConnect.Passstr));
              HttpSendRequest(hFile, nil, 0,Nil, 0);
             end;
            dwcodelen:=150; dwReserv:=0; dwindex:=0;
            if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
             then dwindex:=strtoint(pchar(@dwtype));
            if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then //�������� ������ �����
             begin
            	result:=-3;
              InternetCloseHandle(hFile);
              InternetCloseHandle(hSession);
              exit
             end;
           end;
          result:=0;
          dwindex:=0; dwcodelen:=150; ty:='';
          fillchar(dwtype,sizeof(dwtype),0);
          if HttpQueryInfo(hfile,HTTP_QUERY_CONTENT_TYPE, @dwtype,dwcodelen,dwindex)
           then ty:=PChar(@dwtype);
          if (PosEx(conttype,ty,0)>0) then
          repeat
           err:=not(internetReadFile(hFile,@Buffer,SizeOf(Buffer),BufferLen));
           ms.Write(Buffer,BufferLen);
           inc(result,BufferLen)
          until (BufferLen=0)and(BufferLen<SizeOf(Buffer))and(err=false)
          else result:=-1;
         end
        else result:=0;
       end
  else result:=0;
  ms.Position:=0;
end;

procedure TFmain.TBEditItem1AcceptText(Sender: TObject; var NewText: String; var Accept: Boolean);
var s,slat,slon,par:string;
    i,j:integer;
    err:boolean;
    lat,lon:real;
    Buffer:array [1..64535] of char;
    BufferLen:LongWord;
    hSession,hFile:Pointer;
    dwtype: array [1..20] of char;
    dwindex, dwcodelen,dwReserv: dword;
begin
 s:='';
 hSession:=InternetOpen(pChar('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)'),INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
 if Assigned(hSession)
  then begin
        hFile:=InternetOpenURL(hSession,PChar('http://maps.yandex.ru/?text='+URLEncode(AnsiToUtf8(NewText))),PChar(par),length(par),INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_RELOAD,0);
        dwcodelen:=SizeOf(dwindex);
        if Assigned(hFile)then
         begin
          dwcodelen:=150; dwReserv:=0; dwindex:=0;
          if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
           then dwindex:=strtoint(pchar(@dwtype));
          if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then
           begin
            if (not GState.InetConnect.userwinset)and(GState.InetConnect.uselogin) then
             begin
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_USERNAME,PChar(GState.InetConnect.loginstr), length(GState.InetConnect.loginstr));
              InternetSetOption (hFile, INTERNET_OPTION_PROXY_PASSWORD,PChar(GState.InetConnect.passstr), length(GState.InetConnect.Passstr));
              HttpSendRequest(hFile, nil, 0,Nil, 0);
             end;
            dwcodelen:=150; dwReserv:=0; dwindex:=0;
            if HttpQueryInfo(hFile,HTTP_QUERY_STATUS_CODE,@dwtype, dwcodelen, dwReserv)
             then dwindex:=strtoint(pchar(@dwtype));
            if (dwindex=HTTP_STATUS_PROXY_AUTH_REQ) then //�������� ������ �����
             begin
             	ShowMessage(SAS_ERR_Authorization);
              InternetCloseHandle(hFile);
              InternetCloseHandle(hSession);
              exit;
             end;
           end;

          repeat
           err:=not(internetReadFile(hFile,@Buffer,SizeOf(Buffer),BufferLen));
           s:=s+Buffer;
          until (BufferLen=0)and(BufferLen<SizeOf(Buffer))and(err=false);

          if PosEx(AnsiToUtf8('������� ����������'),s)>0 then
           begin
            ShowMessage(SAS_STR_notfound);
            exit;
           end;
          i:=PosEx('"ll":[',s);
          j:=PosEx(',',s,i+6);
          slon:=Copy(s,i+6,j-(i+6));
          i:=PosEx(']',s,j);
          slat:=Copy(s,j+1,i-(j+1));
          if slat[1]='\' then delete(slat,1,1);
          if slon[1]='\' then delete(slon,1,1);
          try
           lat:=str2r(slat);
           lon:=str2r(slon);
          except
           ShowMessage('������ ��� ����������� ���������!'+#13#10+'�������� ����������� ����������� � ���������,'+#13#10+'��� ������ ������� ������.');
           exit;
          end;
          toPos(ExtPoint(lon,lat),GState.zoom_size,true);
          ShowMessage(SAS_STR_foundplace+' "'+NewText+'"');
         end
        else ShowMessage(SAS_ERR_Noconnectionstointernet);
       end
  else ShowMessage(SAS_ERR_Noconnectionstointernet);
end;

procedure TFmain.PopupMenu1Popup(Sender: TObject);
var i:Integer;
begin
 ldm.Visible:=false;
 dlm.Visible:=false;
 For i:=0 to length(MapType)-1 do
  if (MapType[i].asLayer) then
   begin
    MapType[i].NDwnItem.Visible:=MapType[i].active;
    MapType[i].NDelItem.Visible:=MapType[i].active;
    if MapType[i].active then begin
                                ldm.Visible:=true;
                                dlm.Visible:=true;
                              end
   end;
end;

procedure TFmain.ShowErrScript(DATA:string);
begin
 ShowMessage(data);
end;

procedure TFmain.NinvertcolorClick(Sender: TObject);
begin
 GState.InvertColor:=Ninvertcolor.Checked;
 generate_im(nilLastLoad,''); 
end;

procedure TFmain.mapDblClick(Sender: TObject);
var r:TPoint;
begin
 MapMoving:=false;
 if (aoper=ao_movemap) then
  begin
   r:=map.ScreenToClient(Mouse.CursorPos);
   ScreenCenterPos := VisiblePixel2MapPixel(r);
   generate_im(nilLastLoad,'');
  end;
end;

procedure TFmain.TBAdd_PointClick(Sender: TObject);
begin
 setalloperationfalse(ao_add_point);
end;

procedure TFmain.TBAdd_LineClick(Sender: TObject);
begin
 setalloperationfalse(ao_add_Line);
end;

procedure TFmain.TBAdd_PolyClick(Sender: TObject);
begin
 setalloperationfalse(ao_add_poly);
end;

procedure TFmain.NMarkEditClick(Sender: TObject);
begin
 MouseOnReg(PWL,Point(moveTrue.x+(pr_x-mWd2),moveTrue.y+(pr_y-mHd2)));
 if EditMark(strtoint(PWL.numid)) then generate_im(nilLastLoad,'');
end;

procedure TFmain.NMarkDelClick(Sender: TObject);
begin
 MouseOnReg(PWL,Point(moveTrue.x+(pr_x-mWd2),moveTrue.y+(pr_y-mHd2)));
 if DeleteMark(StrToInt(PWL.numid),Handle) then
  generate_im(nilLastLoad,'');
end;

procedure TFmain.NMarksBarShowClick(Sender: TObject);
begin
 TBMarksToolBar.Visible:=NMarksBarShow.Checked;
end;

procedure TFmain.NMarkOperClick(Sender: TObject);
begin
 MouseOnReg(PWL,Point(moveTrue.x+(pr_x-mWd2),moveTrue.y+(pr_y-mHd2)));
 OperationMark(strtoint(PWL.numid));
end;

procedure TFmain.livecom1Click(Sender: TObject);
var Apos:tExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos,(GState.zoom_size - 1) + 8);
 CopyStringToClipboard('http://maps.live.com/default.aspx?v=2&cp='+R2StrPoint(Apos.y)+'~'+R2StrPoint(Apos.x)+'&style=h&lvl='+inttostr(GState.zoom_size-1));
end;

procedure TFmain.N13Click(Sender: TObject);
var
  VPoint: TPoint;
begin
  VPoint := VisiblePixel2MapPixel(move);
 CopyStringToClipboard(sat_map_both.GetLink(X2absX(VPoint.X,GState.zoom_size),VPoint.Y,GState.zoom_size));
end;

procedure TFmain.ImageAtlas1Click(Sender: TObject);
var Apos:tExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos,(GState.zoom_size - 1) + 8);
 CopyStringToClipboard('http://imageatlas.digitalglobe.com/ia-webapp/?lat='+R2StrPoint(Apos.y)+'&lon='+R2StrPoint(Apos.x)+'&zoom='+inttostr(GState.zoom_size-1));
end;

procedure TFmain.DigitalGlobe1Click(Sender: TObject);
begin
 if FDGAvailablePic.Visible then FDGAvailablePic.setup
                            else FDGAvailablePic.Show;
end;

procedure TFmain.mapMouseLeave(Sender: TObject);
begin
 if (HintWindow<>nil) then
  begin
   HintWindow.ReleaseHandle;
   FreeAndNil(HintWindow);
  end;
end;

procedure TFmain.GPSReceiver1SatellitesReceive(Sender: TObject);
begin
 if FSettings.Visible then FSettings.PaintBox1.Repaint;
end;

procedure TFmain.GPSReceiverReceive(Sender: TObject);
var s2f,sb:string;
    len:integer;
    bPos:TPoint;
    xYear, xMonth, xDay, xHr, xMin, xSec, xMSec: word;
begin
 if (GPSReceiver.IsFix=0) then exit;
 setlength(GState.GPS_TrackPoints,length(GState.GPS_TrackPoints)+1);
 len:=length(GState.GPS_TrackPoints);
 GState.GPS_TrackPoints[len-1]:=ExtPoint(GPSReceiver.GetLongitudeAsDecimalDegrees+GState.GPS_Correction.x,GPSReceiver.GetLatitudeAsDecimalDegrees+GState.GPS_Correction.y);
 if (GState.GPS_TrackPoints[len-1].x<>0)or(GState.GPS_TrackPoints[len-1].y<>0) then
  begin
  setlength(GState.GPS_ArrayOfSpeed,len);
  GState.GPS_ArrayOfSpeed[len-1]:=GPSReceiver.GetSpeed_KMH;
  if len>1 then
    GPSpar.len:=GPSpar.len+ sat_map_both.GeoConvert.CalcDist(GState.GPS_TrackPoints[len-2], GState.GPS_TrackPoints[len-1]);
  if not((MapMoving)or(MapZoomAnimtion=1))and(Self.Active) then
   begin
    bPOS:=sat_map_both.GeoConvert.LonLat2Pos(ExtPoint(GState.GPS_TrackPoints[len-1].X,GState.GPS_TrackPoints[len-1].Y),(GState.zoom_size - 1) + 8);
    if (GState.GPS_MapMove)and((bpos.X<>ScreenCenterPos.x)or(bpos.y<>ScreenCenterPos.y))
     then begin
           ScreenCenterPos:=bpos;
           generate_im(nilLastLoad,'');
          end
     else begin
           drawLineGPS;
           toSh;
          end;
   end;
  if GState.GPS_WriteLog then
   begin
    if length(GState.GPS_TrackPoints)=1 then sb:='1' else sb:='0';
    DecodeDate(Date, xYear, xMonth, xDay);
    DecodeTime(GetTime, xHr, xMin, xSec, xMSec);
    s2f:=R2StrPoint(round(GState.GPS_TrackPoints[len-1].y*10000000)/10000000)+','+R2StrPoint(round(GState.GPS_TrackPoints[len-1].x*10000000)/10000000)+','+sb+','+'-777'+','+
                    floattostr(Double(Date))+'.'+inttostr(round(Double(GetTime)*1000000))+','+inttostr(xDay)+'.'+inttostr(xMonth)+'.'+inttostr(xYear)+','+
                    inttostr(xHr)+':'+inttostr(xMin)+':'+inttostr(xSec);
    Writeln(GState.GPS_LogFile,s2f);
   end;
  end
  else setlength(GState.GPS_TrackPoints,length(GState.GPS_TrackPoints)-1);
end;

procedure TFmain.GPSReceiverDisconnect(Sender: TObject;
  const Port: TCommPort);
begin
 try
 if GState.GPS_WriteLog then CloseFile(GState.GPS_LogFile);
 except
 end;
 LayerMapGPS.Bitmap.Clear(clBlack);
 GState.GPS_enab:=false;
 LayerMapGPS.Visible:=false;
 NGPSconn.Checked:=false;
 TBGPSconn.Checked:=false;
end;

procedure TFmain.GPSReceiverConnect(Sender: TObject; const Port: TCommPort);
var S:string;
begin
 if GState.GPS_WriteLog then
 try
  TimeSeparator:='-';
  DateSeparator:='-';
  CreateDir(GState.TrackLogPath);
  s:=GState.TrackLogPath+DateToStr(Date)+'-'+TimeToStr(GetTime)+'.plt';
  AssignFile(GState.GPS_LogFile,s);
  rewrite(GState.GPS_LogFile);
 except
  GState.GPS_WriteLog:=false;
 end;
end;

procedure TFmain.GPSReceiverTimeout(Sender: TObject);
begin
 ShowMessage(SAS_ERR_Communication);
end;

procedure TFmain.NMapParamsClick(Sender: TObject);
begin
 if TTBXItem(sender).Tag=0 then FEditMap.AmapType:=sat_map_both
                           else FEditMap.AmapType:=TMapType(TTBXItem(sender).Tag);
 FEditMap.ShowModal;
end;

procedure TFmain.LayerMinMapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ll,lt:integer;
begin
  map.PopupMenu:=nil;
  case button of
    mbRight: map.PopupMenu:=GMiniMapPopupMenu;
    mbLeft: begin
      ll:=round(GMiniMap.LayerMinMap.Location.Left);
      lt:=round(GMiniMap.LayerMinMap.Location.top);
      if (x<ll+5) then begin
        GMiniMap.size_dw:=true
      end else if (x>ll+6)and(x<ll+17)and(y>lt+5)and(y<lt+15) then begin
        GMiniMap.zooming:=true;
        if GMiniMap.z1mz2>1 then dec(GMiniMap.z1mz2);
        GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos);
      end else if (x>ll+19)and(x<ll+33)and(y>lt+5)and(y<lt+15) then begin
        GMiniMap.zooming:=true;
        if GState.zoom_size-GMiniMap.z1mz2>1 then inc(GMiniMap.z1mz2);
        GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos);
      end else if (x>ll+5)and(y>lt) then begin
        GMiniMap.m_dwn:=true;
        GMiniMap.sm_im_reset(round(x-(GMiniMap.LayerMinMap.Location.Left+5)),round(y-(GMiniMap.LayerMinMap.Location.top)), ScreenCenterPos);
      end;
    end;
  end;
end;

procedure TFmain.LayerMinMapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if (x<GMiniMap.LayerMinMap.Location.Left+5)and(map.Cursor<>crSizeNWSE) then GMiniMap.LayerMinMap.Cursor:=crSizeNWSE
                                                               else GMiniMap.LayerMinMap.Cursor:=crHandPoint;
 if (GMiniMap.size_dw)and((map.Width-x-5)>40)
  then begin
        GMiniMap.width:=(map.Width-x-5);
        GMiniMap.height:=(map.Width-x-5);
        GMiniMap.sm_im_reset(GMiniMap.width div 2,GMiniMap.height div 2, ScreenCenterPos)
       end;
 if (GMiniMap.m_dwn)and(x>GMiniMap.LayerMinMap.Location.Left+5)and(y>GMiniMap.LayerMinMap.Location.top+5)
  then GMiniMap.sm_im_reset(round(x-(GMiniMap.LayerMinMap.Location.Left+5)),round(y-(GMiniMap.LayerMinMap.Location.top)), ScreenCenterPos);
end;

procedure TFmain.LayerMinMapMouseUp(Sender:TObject; Button:TMouseButton; Shift:TShiftState; X,Y:Integer);
begin
 if (MapZoomAnimtion=1) then exit;
 GMiniMap.m_dwn:=false;
 GMiniMap.size_dw:=false;
 if (not(GMiniMap.size_dw))and(not(GMiniMap.zooming))and((x>GMiniMap.LayerMinMap.Location.Left+5)and(y>GMiniMap.LayerMinMap.Location.Top))
  then begin
        if GMiniMap.zoom>1 then
         ScreenCenterPos:=Point(ScreenCenterPos.x+round((-(128-(GMiniMap.pos.x*(256/GMiniMap.width))))*power(2,GState.zoom_size-GMiniMap.zoom)),
              ScreenCenterPos.y+round((-(128-(GMiniMap.pos.y*(256/GMiniMap.height))))*power(2,GState.zoom_size-GMiniMap.zoom)))
         else ScreenCenterPos:=Point(round(GMiniMap.pos.X*(256/GMiniMap.height)*power(2,GState.zoom_size-GMiniMap.zoom)),round((GMiniMap.pos.Y*(256/GMiniMap.height))*power(2,GState.zoom_size-GMiniMap.zoom)));
        generate_im(nilLastLoad,'');
       end
  else GMiniMap.zooming:=false;
 toSh;
end;

procedure TFmain.mapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var i:integer;
    xy:TPoint;
begin
   if (HintWindow<>nil) then
    begin
     HintWindow.ReleaseHandle;
     FreeAndNil(HintWindow);
    end;
 if (layer=GMiniMap.LayerMinMap) then exit;
 if (ssDouble in Shift)or(MapZoomAnimtion=1)or(button=mbMiddle)or(HiWord(GetKeyState(VK_DELETE))<>0)
    or(HiWord(GetKeyState(VK_INSERT))<>0)or(HiWord(GetKeyState(VK_F5))<>0) then exit;
 Screen.ActiveForm.SetFocusedControl(map);
 Layer.Cursor:=curBuf;
 if (Button=mbLeft)and(aoper<>ao_movemap) then
  begin
   if (aoper=ao_line)then begin
                  setlength(length_arr,length(length_arr)+1);
                  length_arr[length(length_arr)-1]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1);
                  drawLineCalc;
                 end;
   if (aoper=ao_Reg) then begin
                  setlength(reg_arr,length(reg_arr)+1);
                  reg_arr[length(reg_arr)-1]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1);
                  drawReg;
                 end;
   if (aoper=ao_rect)then begin
                  if rect_dwn then begin
                                    rect_arr[1]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1);
                                    rect_p2:=true;
                                   end
                              else begin
                                    rect_arr[0]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1);
                                    rect_arr[1]:=rect_arr[0];
                                   end;
                  rect_dwn:=not(rect_dwn);
                  drawRect(Shift);
                 end;
   if (aoper=ao_add_point)and(FAddPoint.show_(sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1),true)) then generate_im(nilLastLoad,'');
   if (aoper in [ao_add_line,ao_add_poly]) then
      begin
        for i:=0 to length(add_line_arr)-1 do begin
         xy:=sat_map_both.FCoordConverter.LonLat2PixelPos(add_line_arr[i],GState.zoom_size-1);
         xy := MapPixel2VisiblePixel(xy);
         if (X<xy.x+5)and(X>xy.x-5)and(Y<xy.y+5)and(Y>xy.y-5) then begin
           movepoint:=i;
           lastpoint:=i;
           drawPath(add_line_arr,true,SetAlpha(ClRed32,150),SetAlpha(ClWhite32,50),3,aoper=ao_add_poly);
           exit;
         end;
        end;
        inc(lastpoint);
        movepoint:=lastpoint;
        insertinpath(lastpoint);
        add_line_arr[lastpoint]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x, y)),GState.zoom_size-1);
        drawPath(add_line_arr,true,SetAlpha(ClRed32, 150),SetAlpha(ClWhite32, 50),3,aoper=ao_add_poly);
      end;
   exit;
  end;
 if MapMoving then exit;
 if (Button=mbright)and(aoper=ao_movemap)
  then begin
        m_up:=point(x,y);
        PWL.find:=false;
        PWL.S:=0;
        MouseOnMyReg(PWL,Point(x,y));
        NMarkEdit.Visible:=PWL.find;
        NMarkDel.Visible:=PWL.find;
        NMarkSep.Visible:=PWL.find;
        NMarkOper.Visible:=PWL.find;
        NMarkNav.Visible:=PWL.find;
        if (PWL.find)and(PWL.type_<>ROTpoint) then begin
                                                    NMarksCalcsSq.Visible:=(PWL.type_=ROTPoly);
                                                    NMarksCalcsPer.Visible:=(PWL.type_=ROTPoly);
                                                    NMarksCalcsLen.Visible:=(PWL.type_=ROTline);
                                                    NMarksCalcs.Visible:=true;
                                                   end
                                              else NMarksCalcs.Visible:=false;
        if (NavOnMark<>nil)and(NavOnMark.id=strtoint(PWL.numid))
         then NMarkNav.Checked:=true
         else NMarkNav.Checked:=false;
        map.PopupMenu:=PopupMenu1;
       end
  else begin
        MapMoving:=true;
        map.PopupMenu:=nil;
       end;
 move:=Point(x,y);
end;

procedure TFmain.mapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var PWL:TResObj;
    posB:TPoint;
    stw:String;
    VPoint: TPoint;
begin
 if (layer=GMiniMap.LayerMinMap) then exit;
 if (ssDouble in Shift) then exit;
 MapMoving:=false;
 VPoint := VisiblePixel2MapPixel(Point(x, y));
 if HiWord(GetKeyState(VK_DELETE))<>0 then
  if (VPoint.X > 0)and(VPoint.X < Zoom[GState.zoom_size])and
     (VPoint.Y > 0)and(VPoint.Y < Zoom[GState.zoom_size]) then
  begin
   sat_map_both.DeleteTile(VPoint.X, VPoint.Y, GState.zoom_size);
   generate_im(nilLastLoad,'');
   exit;
  end;
 if HiWord(GetKeyState(VK_INSERT))<>0 then
  if (VPoint.X > 0)and(VPoint.X < Zoom[GState.zoom_size])and
     (VPoint.Y > 0)and(VPoint.Y < Zoom[GState.zoom_size]) then
  begin
    TTileDownloaderUIOneTile.Create(VPoint, GState.zoom_size, sat_map_both);
    exit;
  end;
 if HiWord(GetKeyState(VK_F6))<>0 then
  begin
   if FDGAvailablePic.Visible then FDGAvailablePic.setup
                              else FDGAvailablePic.Show;
   exit;
  end;

 if movepoint>-1 then begin movepoint:=-1; end;
 if (((aoper<>ao_movemap)and(Button=mbLeft))or
     ((aoper=ao_movemap)and(Button=mbRight))) then exit;
// m_up:=move;
 if (MapZoomAnimtion=1) then exit;
 map.Enabled:=false;
 map.Enabled:=true;
 if button=mbMiddle then
   begin
    TBFullSize.Checked:=not(TBFullSize.Checked);
    TBFullSizeClick(Sender);
    layer.Cursor:=curBuf;
    exit;
   end;

 POSb:=ScreenCenterPos;
 ScreenCenterPos:=Point(ScreenCenterPos.x+(move.x-x),ScreenCenterPos.y+(move.y-y));
 m_up:=Point(x,y);
 layer.Cursor:=curBuf;
 if ((move.x<>m_up.x)or(move.y<>m_up.y))
  then generate_im(nilLastLoad,'');
 if (y=move.y)and(x=move.x) then
  begin
   toSh;
   paint_Line;
   if aoper=ao_line then drawLineCalc;
   if aoper=ao_reg then drawReg;
   if aoper=ao_rect then drawRect([]);
   if GState.GPS_enab then drawLineGPS;
   if aoper in [ao_add_line,ao_add_poly] then drawPath(add_line_arr,true,setalpha(clRed32,150),setalpha(clWhite32,50),3,aoper=ao_add_poly);
  end;
 if (y=move.y)and(x=move.x)and(aoper=ao_movemap)and(button=mbLeft) then
  begin
    layer.Cursor:=curBuf;
    PWL.S:=0;
    PWL.find:=false;
    if (LayerMapWiki.Visible) then
     MouseOnReg(PWL,Point(x+(pr_x-mWd2),y+(pr_y-mHd2)));
    MouseOnMyReg(PWL,Point(x,y));
    if pwl.find then
     begin
      stw:='<HTML><BODY>';
      stw:=pwl.descr;
      stw:=stw+'</BODY></HTML>';
      TextToWebBrowser(stw,Fbrowser.EmbeddedWB1);
      Fbrowser.Visible:=true;
     end;
    exit;
  end;
end;

function HTML2Txt(OrigHTML: String): String;
var
  NoHTML: String;
function MidStr(const pString, pAbre, pFecha: String; pInclui: boolean): string;
var
  lIni, lFim : integer;
begin
  if (pInclui = False) then begin
    lIni := System.Pos(UpperCase(pAbre), UpperCase(pString)) + Length(pAbre);
    lFim := PosEx(UpperCase(pFecha),UpperCase(pString),lIni)+1;
  end else begin
    lIni := System.Pos(UpperCase(pAbre), UpperCase(pString));
    lFim := PosEx(UpperCase(pFecha),UpperCase(pString),lIni + Length(pAbre))+1;
  end;
  result := Copy(pString, lIni, lFim - lIni);
end;
function mid(str:string; pos:integer):string;
begin
 result:=copy(str,pos, length(str)-pos+1);
end;
begin
  if System.Pos('<body', LowerCase(OrigHTML)) > 0 Then begin
    OrigHTML := Mid(OrigHTML, System.Pos('<body', LowerCase(OrigHTML)));
    OrigHTML := Mid(OrigHTML, System.Pos('>', OrigHTML) + 1);
    if System.Pos('</body>', LowerCase(OrigHTML)) > 0 Then
      OrigHTML := Copy(OrigHTML,1 , System.Pos('</body>', LowerCase(OrigHTML)) - 1);
  end;
  OrigHTML := StringReplace(OrigHTML, Chr(13), '', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, Chr(10), '', [rfReplaceAll]);
  while System.Pos('  ', OrigHTML) > 0 do
    OrigHTML := StringReplace(OrigHTML, '  ', ' ', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '<br>', #13#10, [rfReplaceAll, rfIgnoreCase]);
  OrigHTML := StringReplace(OrigHTML, '</div>', #13#10#13#10, [rfReplaceAll, rfIgnoreCase]);
  while System.Pos('<p', OrigHTML) > 0 do begin
    NoHTML   := MidStr(OrigHTML, '<p', '>', True);
    OrigHTML := StringReplace(OrigHTML, NoHTML, (#13#10#13#10), [rfReplaceAll, rfIgnoreCase]);
  end;
  while System.Pos('<', OrigHTML) > 0 do begin
    NoHTML   := MidStr(OrigHTML, '<', '>', True);
    OrigHTML := StringReplace(OrigHTML, NoHTML, '', [rfReplaceAll, rfIgnoreCase]);
  end;
  OrigHTML := StringReplace(OrigHTML, '&#36;',     '$', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '#37;',      '%', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&#187;',    '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&aacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&atilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ccedil;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&eacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ecirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&iacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&oacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&ocirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&otilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Aacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Atilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ccedil;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Eacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ecirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Iacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Oacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Ocirc;',   '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Otilde;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&amp;',     '&', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&quot;',    '"', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&lt;',      '<', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&gt;',      '>', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&nbsp;',    ' ', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&copy;',    '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&reg;',     '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&raquo;',   '�', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&laquo;',   '�', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&Uacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&uacute;',  '?', [rfReplaceAll]);
  OrigHTML := StringReplace(OrigHTML, '&uuml;',    '?', [rfReplaceAll]);
  result := OrigHTML;
end;


procedure TFmain.mapMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var i,j:integer;
    nms:string;
    hintrect:TRect;
    CState: Integer;
begin
 if (Layer=GMiniMap.LayerMinMap)or(MapZoomAnimtion>0)or(
    (ssDouble in Shift)or(HiWord(GetKeyState(VK_DELETE))<>0)or(HiWord(GetKeyState(VK_INSERT))<>0))
   then begin
         moveTrue:=point(x,y);
         exit;
        end;
 CState:=ShowCursor(True);
 while CState < 0 do CState:= ShowCursor(true);
 sleep(1);
 if movepoint>-1 then
  begin
   add_line_arr[movepoint]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x,y)), GState.zoom_size-1);
   drawPath(add_line_arr,true,SetAlpha(ClRed32, 150),SetAlpha(ClWhite32, 50),3,aoper=ao_add_poly);
   exit;
  end;
 if (aoper=ao_rect)and(rect_dwn)and(not(ssRight in Shift))and(layer<>GMiniMap.LayerMinMap)
         then begin
               rect_arr[1]:=sat_map_both.FCoordConverter.PixelPos2LonLat(VisiblePixel2MapPixel(Point(x,y)), GState.zoom_size-1);
               drawRect(Shift);
              end;
 if MapMoving then layer.Cursor:=3;

 if GState.FullScrean then begin
                       if y<10 then begin
                                     TBDock.Parent:=map;
                                     TBDock.Visible:=true;
                                    end
                               else begin
                                     TBDock.Visible:=false;
                                     TBDock.Parent:=Self;
                                    end;
                       if x<10 then begin
                                     TBDockLeft.Parent:=map;
                                     TBDockLeft.Visible:=true;
                                    end
                               else begin
                                     TBDockLeft.Visible:=false;
                                     TBDockLeft.Parent:=Self;
                                    end;
                       if y>Map.Height-10 then begin
                                     TBDockBottom.Parent:=map;
                                     TBDockBottom.Visible:=true;
                                    end
                               else begin
                                     TBDockBottom.Visible:=false;
                                     TBDockBottom.Parent:=Self;
                                    end;
                       if x>Map.Width-10 then begin
                                     TBDockRight.Parent:=map;
                                     TBDockRight.Visible:=true;
                                    end
                               else begin
                                     TBDockRight.Visible:=false;
                                     TBDockRight.Parent:=Self;
                                    end;
                      end;
 if MapZoomAnimtion=1 then exit;
 if MapMoving then begin
              LayerMap.Location:=floatrect(bounds(mWd2-pr_x-(move.X-x),mHd2-pr_y-(move.Y-y),xhgpx,yhgpx));
              FillingMap.Location := LayerMap.Location;
              if (LayerMapNal.Visible)and(aoper<>ao_movemap) then LayerMapNal.Location:=floatrect(bounds(mWd2-pr_x-(move.X-x),mHd2-pr_y-(move.Y-y),xhgpx,yhgpx));
              if (LayerMapMarks.Visible) then LayerMapMarks.Location:=floatrect(bounds(mWd2-pr_x-(move.X-x),mHd2-pr_y-(move.Y-y),xhgpx,yhgpx));
              if (LayerMapGPS.Visible)and(GState.GPS_enab) then LayerMapGPS.Location:=floatrect(bounds(mWd2-pr_x-(move.X-x),mHd2-pr_y-(move.Y-y),xhgpx,yhgpx));
              if LayerMapWiki.Visible then LayerMapWiki.Location:=floatrect(bounds(mWd2-pr_x-(move.X-x),mHd2-pr_y-(move.Y-y),xhgpx,yhgpx));
             end
        else m_m:=point(x,y);
 if not(MapMoving) then toSh;

 if (not ShowActivHint) then
  begin
   if (HintWindow<>nil) then
    begin
     HintWindow.ReleaseHandle;
     FreeAndNil(HintWindow);
    end;
   Layer.Cursor:=curBuf;
  end;
 ShowActivHint:=false;
 if not(MapMoving)and((moveTrue.x<>X)or(moveTrue.y<>y))and(GState.ShowHintOnMarks) then
  begin
   PWL.S:=0;
   PWL.find:=false;
   if (LayerMapWiki.Visible) then
     MouseOnReg(PWL,Point(x+(pr_x-mWd2),y+(pr_y-mHd2)));
   MouseOnMyReg(PWL,Point(x,y));
   if (PWL.find) then
    begin
     if HintWindow<>nil then HintWindow.ReleaseHandle;
     if (length(PWL.name)>0) then
      begin
       if System.Pos('<',PWL.name)>0 then nms:=HTML2Txt(PWL.name)
                                     else nms:=PWL.name;
      end;
     if (length(PWL.descr)>0) then
      begin
       if length(nms)>0 then nms:=nms+#13#10;
       if System.Pos('<',PWL.descr)>0 then nms:=nms+HTML2Txt(PWL.descr)
                                      else nms:=nms+PWL.descr;
      end;
     i:=1;
     j:=0;
     while (i<length(nms))and(i<>0) do
      begin
       inc(j);
       if (nms[i]=#13)or(nms[i]=#10) then j:=0;
       if (j>40)and(nms[i]=' ')and(length(nms)-i>5)then
        begin
         if i>500 then
          begin
           Insert('...',nms,i);
           Delete(nms,i+3,length(nms)-i+3);
           i:=0;
           continue;
          end;
         Delete(nms,i,1);
         Insert(#13#10,nms,i);
         j:=0;
        end;
       inc(i);
      end;
     layer.Cursor:=crHandPoint;
     if nms<>'' then
     begin
      if HintWindow=nil then
       begin
        HintWindow:=THintWindow.Create(Self);
        HintWindow.Brush.Color:=clInfoBk;
        HintWindow.Font.Charset:=RUSSIAN_CHARSET;
       end;
      hintrect:=HintWindow.CalcHintRect(Screen.Width, nms, nil);
      HintWindow.ActivateHint(Bounds(Mouse.CursorPos.x+13,Mouse.CursorPos.y-13,abs(hintrect.Right-hintrect.Left),abs(hintrect.Top-hintrect.Bottom)),nms);
      HintWindow.Repaint;
     end;
     ShowActivHint:=true;
    end;
  end;
 moveTrue:=point(x,y);
end;

procedure CreateLink(const PathObj,PathLink, Desc, Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), FALSE);
end;

procedure TFmain.N35Click(Sender: TObject);
var Apos:TExtendedPoint;
    param:string;
begin
if SaveLink.Execute then
 begin
   Apos:=sat_map_both.GeoConvert.Pos2LonLat(ScreenCenterPos,(GState.zoom_size - 1) + 8);
   param:=' '+sat_map_both.guids+' '+inttostr(GState.zoom_size)+' '+floattostr(Apos.x)+' '+floattostr(Apos.y);
   CreateLink(ParamStr(0),SaveLink.filename, '', param)
 end;
end;

procedure TFmain.TBItemDelTrackClick(Sender: TObject);
begin
 setlength(GState.GPS_ArrayOfSpeed,0);
 setlength(GState.GPS_TrackPoints,0);
 GPSpar.len:=0;
 GPSpar.speed:=0;
 GPSpar.sspeed:=0;
end;

procedure TFmain.NGShScale01Click(Sender: TObject);
begin
 GState.GShScale:=TTBXItem(sender).Tag;

 if GState.GShScale >= 1000000 then begin
  GState.GShScale := 1000000;
 end else if GState.GShScale >= 500000 then begin
  GState.GShScale := 500000;
 end else if GState.GShScale >= 200000 then begin
  GState.GShScale := 200000;
 end else if GState.GShScale >= 100000 then begin
  GState.GShScale := 100000;
 end else if GState.GShScale >= 50000 then begin
  GState.GShScale := 50000;
 end else if GState.GShScale >= 25000 then begin
  GState.GShScale := 25000;
 end else if GState.GShScale >= 10000 then begin
  GState.GShScale := 10000;
 end else begin
  GState.GShScale := 0;
 end;

 generate_im(nilLastLoad,'');
end;

procedure TFmain.TBEditPathDelClick(Sender: TObject);
begin
 case aoper of
  ao_line: begin
         if length(length_arr)>0 then setlength(length_arr,length(length_arr)-1);
         drawLineCalc;
        end;
  ao_Reg : begin
         if length(reg_arr)>0 then setlength(reg_arr,length(reg_arr)-1);
         drawReg;
        end;
  ao_add_poly,ao_add_line:
        begin
         if length(add_line_arr)>0 then delfrompath(lastpoint);
         drawPath(add_line_arr,true,SetAlpha(ClRed32, 150),SetAlpha(ClWhite32, 50),3,aoper=ao_add_poly);
        end;
 end;
end;

procedure TFmain.TBEditPathLabelClick(Sender: TObject);
begin
 LenShow:=not(LenShow);
 drawLineCalc;
end;

procedure TFmain.TBEditPathSaveClick(Sender: TObject);
var result:boolean;
begin
  result := false;
 case aoper of
  ao_add_Poly: result:=FaddPoly.show_(add_line_arr,true);
  ao_add_Line: result:=FaddLine.show_(add_line_arr,true);
 end;
 if result then
  begin
   setalloperationfalse(ao_movemap);
   generate_im(nilLastLoad,'');
  end;
end;

procedure TFmain.TBEditPathClose(Sender: TObject);
begin
 setalloperationfalse(ao_movemap);
end;

procedure TFmain.NGoToForumClick(Sender: TObject);
begin
  ShowCaptcha('http://sasgis.ru/forum');
end;

procedure TFmain.NGoToSiteClick(Sender: TObject);
begin
  ShowCaptcha('http://sasgis.ru/');
end;

procedure TFmain.TBItem6Click(Sender: TObject);
begin
 Self.Enabled:=false;
 FMarksExplorer.ShowModal;
 Self.Enabled:=true;
 generate_im(nilLastLoad,'');
end;

procedure TFmain.NSRTM3Click(Sender: TObject);
var Apos:TExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(VisiblePixel2MapPixel(move), (GState.zoom_size - 1) + 8);
 TextToWebBrowser(SAS_STR_WiteLoad,Fbrowser.EmbeddedWB1);
 Fbrowser.Visible:=true;
 Fbrowser.EmbeddedWB1.Navigate('http://ws.geonames.org/srtm3?lat='+R2StrPoint(Apos.y)+'&lng='+R2StrPoint(Apos.x));
end;

procedure TFmain.NGTOPO30Click(Sender: TObject);
var Apos:TExtendedPoint;
begin
 Apos:=sat_map_both.GeoConvert.Pos2LonLat(VisiblePixel2MapPixel(move), (GState.zoom_size - 1) + 8);
 TextToWebBrowser(SAS_STR_WiteLoad,Fbrowser.EmbeddedWB1);
 Fbrowser.Visible:=true;
 Fbrowser.EmbeddedWB1.Navigate('http://ws.geonames.org/gtopo30?lat='+R2StrPoint(Apos.y)+'&lng='+R2StrPoint(Apos.x));
end;

procedure TFmain.NMarkNavClick(Sender: TObject);
var ms:TMemoryStream;
    LL:TExtendedPoint;
    arrLL:PArrLL;
    id:integer;
begin
 MouseOnReg(PWL,Point(moveTrue.x+(pr_x-mWd2),moveTrue.y+(pr_y-mHd2)));
 if (not NMarkNav.Checked) then
  begin
   id:=strtoint(PWL.numid);
   if NavOnMark<>nil then FreeAndNil(NavOnMark);
   if not(CDSmarks.Locate('id',id,[])) then exit;
   ms:=TMemoryStream.Create;
   TBlobField(CDSmarks.FieldByName('LonLatArr')).SaveToStream(ms);
   ms.Position:=0;
   GetMem(arrLL,ms.size);
   ms.ReadBuffer(arrLL^,ms.size);
   if (arrLL^[0].Y=arrLL^[ms.size div 24-1].Y)and
      (arrLL^[0].X=arrLL^[ms.size div 24-1].X)
      then begin
            LL.X:=CDSmarks.FieldByName('LonL').AsFloat+(CDSmarks.FieldByName('LonR').AsFloat-CDSmarks.FieldByName('LonL').AsFloat)/2;
            LL.Y:=CDSmarks.FieldByName('LatB').AsFloat+(CDSmarks.FieldByName('LatT').AsFloat-CDSmarks.FieldByName('LatB').AsFloat)/2;
           end
      else begin
            LL:=arrLL^[0];
           end;
   ms.Free;
   FreeMem(arrLL);
   NavOnMark:=TNavOnMark.create;
   NavOnMark.id:=id;
   NavOnMark.LL:=LL;
   NavOnMark.width:=25;
  end
 else FreeAndNil(NavOnMark);
 generate_im(nilLastLoad,'');
end;

function SecondToTime(const Seconds: Cardinal): Double;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
  ms, ss, mm, hh, dd: Cardinal; 
begin 
  dd := Seconds div SecPerDay;
  hh := (Seconds mod SecPerDay) div SecPerHour; 
  mm := ((Seconds mod SecPerDay) mod SecPerHour) div SecPerMinute; 
  ss := ((Seconds mod SecPerDay) mod SecPerHour) mod SecPerMinute; 
  ms := 0; 
  Result := dd + EncodeTime(hh, mm, ss, ms); 
end; 

procedure TFmain.TBEditPathMarshClick(Sender: TObject);
var ms:TMemoryStream;
    pathstr,timeT1:string;
    url:string;
    i,posit,posit2,endpos,dd,seconds,meters:integer;
    Buffer:array [1..64535] of char;
    BufferLen:LongWord;
    dateT1:TDateTime;
begin
 ms:=TMemoryStream.Create;
 case TTBXItem(Sender).tag of
  1:url:='http://maps.mail.ru/stamperx/getPath.aspx?mode=distance';
  2:url:='http://maps.mail.ru/stamperx/getPath.aspx?mode=time';
  3:url:='http://maps.mail.ru/stamperx/getPath.aspx?mode=deftime';
 end;
 for i:=0 to length(add_line_arr)-1 do
  url:=url+'&x'+inttostr(i)+'='+R2StrPoint(add_line_arr[i].x)+'&y'+inttostr(i)+'='+R2StrPoint(add_line_arr[i].y);
 if GetStreamFromURL(ms,url,'text/javascript; charset=utf-8')>0 then
  begin
   ms.Position:=0;
   pathstr:='';
   repeat
    BufferLen:=ms.Read(Buffer,SizeOf(Buffer));
    pathstr:=pathstr+Buffer;
   until (BufferLen=0)or(BufferLen<SizeOf(Buffer));

   SetLength(add_line_arr,0);
   meters:=0;
   seconds:=0;

   try
   posit:=PosEx('"totalLength"',pathstr,0);
   While (posit>0) do
    begin
     try
      posit2:=PosEx('"',pathstr,posit+17);
      meters:=meters+strtoint(copy(pathstr,posit+17,posit2-(posit+17)));
      posit:=PosEx('"totalTime"',pathstr,posit);
      posit2:=PosEx('"',pathstr,posit+15);
      seconds:=seconds+strtoint(copy(pathstr,posit+15,posit2-(posit+15)));
     except
     end;
     posit:=PosEx('"points"',pathstr,posit);
     endpos:=PosEx(']',pathstr,posit);
      while (posit>0)and(posit<endpos) do
       try
        SetLength(add_line_arr,length(add_line_arr)+1);
        posit:=PosEx('"x" : "',pathstr,posit);
        posit2:=PosEx('", "y" : "',pathstr,posit);
        add_line_arr[length(add_line_arr)-1].X:=str2r(copy(pathstr,posit+7,posit2-(posit+7)));
        posit:=PosEx('"',pathstr,posit2+10);
        add_line_arr[length(add_line_arr)-1].y:=str2r(copy(pathstr,posit2+10,posit-(posit2+10)));
        posit:=PosEx('{',pathstr,posit);
       except
        SetLength(add_line_arr,length(add_line_arr)-1);
        dec(lastpoint);
       end;
     posit:=PosEx('"totalLength"',pathstr,posit);
    end;
   except
   end;

   lastpoint:=length(add_line_arr)-1;
   if meters>1000 then marshrutcomment:=SAS_STR_MarshLen+RoundEx(meters/1000,2)+' '+SAS_UNITS_km
                  else marshrutcomment:=SAS_STR_MarshLen+inttostr(meters)+' '+SAS_UNITS_m;
   DateT1:=SecondToTime(seconds);
   dd:=DaysBetween(0,DateT1);
   timeT1:='';
   if dd>0 then timeT1:=inttostr(dd)+' ����, ';
   timeT1:=timeT1+TimeToStr(DateT1);
   marshrutcomment:=marshrutcomment+#13#10+SAS_STR_Marshtime+timeT1;
  end
 else ShowMessage('Connect error!');
 drawPath(add_line_arr,true,setalpha(clRed32,150),setalpha(clWhite32,50),3,aoper=ao_add_poly);
end;

procedure TFmain.AdjustFont(Item: TTBCustomItem;
  Viewer: TTBItemViewer; Font: TFont; StateFlags: Integer);
begin
 if TTBXItem(Item).Checked then TTBXItem(Item).FontSettings.Bold:=tsTrue
                           else TTBXItem(Item).FontSettings.Bold:=tsDefault;
end;

procedure TFmain.NParamsClick(Sender: TObject);
var i:Integer;
begin
 NLayerParams.Visible:=false;
 For i:=0 to length(MapType)-1 do
  if (MapType[i].asLayer) then
   begin
    MapType[i].NLayerParamsItem.Visible:=MapType[i].active;
    if MapType[i].active then begin
                                NLayerParams.Visible:=true;
                              end
   end;

end;

procedure TFmain.TBfillMapAsMainClick(Sender: TObject);
begin
  if TTBXItem(sender).Tag=0 then begin
                                 if fillingmaptype<>nil then
                                  begin
                                   fillingmaptype.TBFillingItem.Checked:=false;
                                   fillingmaptype:=nil;
                                  end;
                                 TBfillMapAsMain.Checked:=true;
                                end
  else
  begin
    TBfillMapAsMain.Checked:=false;
    if fillingmaptype<>nil then fillingmaptype.TBFillingItem.Checked:=false;
    fillingmaptype:=TMapType(TTBXItem(sender).Tag);
    fillingmaptype.TBFillingItem.Checked:=true;
 end;
 generate_mapzap;
end;

procedure TFmain.NMarksCalcsLenClick(Sender: TObject);
begin
 MessageBox(Self.Handle,pchar(SAS_STR_L+' - '+DistToStrWithUnits(GetMarkLength(strtoint(PWL.numid)), GState.num_format)),pchar(PWL.name),0);
end;

procedure TFmain.NMarksCalcsSqClick(Sender: TObject);
begin
 MessageBox(Handle,pchar(SAS_STR_S+' - '+RoundEx(GetMarkSq(strtoint(PWL.numid)),2)+' '+SAS_UNITS_km+'2'),pchar(PWL.name),0);
end;

procedure TFmain.NMarksCalcsPerClick(Sender: TObject);
begin
 MessageBox(Handle,pchar(SAS_STR_P+' - '+DistToStrWithUnits(GetMarkLength(strtoint(PWL.numid)), GState.num_format)),pchar(PWL.name),0);
end;

procedure TFmain.TBEditPathOkClick(Sender: TObject);
begin
  case aoper of
   ao_reg: begin
         SetLength(reg_arr,length(reg_arr)+1);
         reg_arr[length(reg_arr)-1]:=reg_arr[0];
         LayerMapNal.Bitmap.Clear(clBlack);
         Fsaveas.Show_(GState.zoom_size,reg_arr);
         setalloperationfalse(ao_movemap);
        end;
  end;
end;

procedure TFmain.TBItem1Click(Sender: TObject);
begin
 if ((GState.Localization<>LANG_RUSSIAN)and(TTBXItem(Sender).tag=0))or
    ((GState.Localization<>LANG_ENGLISH)and(TTBXItem(Sender).tag=1)) then ShowMessage(SAS_MSG_need_reload_application);
 case TTBXItem(Sender).tag of
  0:GState.Localization:=LANG_RUSSIAN;
  1:GState.Localization:=LANG_ENGLISH;
 end;
end;

procedure TFmain.NMapInfoClick(Sender: TObject);
begin
 ShowMessage('����: '+sat_map_both.zmpfilename+#13#10+sat_map_both.info);
end;

procedure TFmain.WebBrowser1Authenticate(Sender: TCustomEmbeddedWB; var hwnd: HWND; var szUserName, szPassWord: WideString; var Rezult: HRESULT);
begin
 if GState.InetConnect.uselogin then
  begin
   szUserName:=GState.InetConnect.loginstr;
   szPassWord:=GState.InetConnect.passstr;
  end;
end;

{
procedure MergeBitmaps(BM1, BM2, BM3 : TBitmap; Alpha : byte);
var
  bf:TBlendFunction;
begin
//if not Assigned(BM3) then BM3:= TBitmap32.Create;
BM3.Assign(BM1);
bf.BlendOp:=AC_SRC_OVER;
bf.BlendFlags:=0;
bf.SourceConstantAlpha:=Alpha;//0-255
bf.AlphaFormat:=0;// not use alpha-channel of bmp2
 
//if sizes of your source bmps are different, try uncomment
// and see result
//BM2.Width:=BM3.Width;
//BM2.Height:=BM3.Height;

AlphaBlend(BM3.Canvas.Handle,0,0,BM3.Width,BM3.Height,
   BM2.canvas.handle,0,0,BM2.Width,BM2.Height,bf);
end;


}
procedure TFmain.NanimateClick(Sender: TObject);
begin
  GState.AnimateZoom := Nanimate.Checked;
end;

function TFmain.GetVisiblePixelRect: TRect;
begin
  Result.Left := ScreenCenterPos.X - map.Width div 2;
  Result.Top := ScreenCenterPos.Y - map.Height div 2;
  Result.Right := ScreenCenterPos.X + map.Width div 2;
  Result.Bottom := ScreenCenterPos.Y + map.Height div 2;
end;

function TFmain.GetVisibleSizeInPixel: TPoint;
begin
  Result.X := map.Width;
  Result.Y := map.Height;
end;

function TFmain.GetVisibleTopLeft: TPoint;
begin
  Result.X := ScreenCenterPos.X - map.Width div 2;
  Result.Y := ScreenCenterPos.Y - map.Height div 2;
end;

function TFmain.GetLoadedPixelRect: TRect;
var
  VSizeInPixel: TPoint;
begin
  VSizeInPixel := GetLoadedSizeInPixel;
  Result.Left := ScreenCenterPos.X - VSizeInPixel.X div 2;
  Result.Top := ScreenCenterPos.Y - VSizeInPixel.Y div 2;
  Result.Right := ScreenCenterPos.X + VSizeInPixel.X div 2;
  Result.Bottom := ScreenCenterPos.Y + VSizeInPixel.Y div 2;
end;

function TFmain.GetLoadedSizeInPixel: TPoint;
var
  VSizeInTile: TPoint;
begin
  if GState.TilesOut=0 then begin
    Result.X := Screen.Width;
    Result.Y := Screen.Height;
  end else begin
    VSizeInTile := GetLoadedSizeInTile;
    Result.X := VSizeInTile.X * 256;
    Result.Y := VSizeInTile.Y * 256;
  end;
end;

function TFmain.GetLoadedSizeInTile: TPoint;
begin
// Result.X := Ceil(Screen.Width / 256) + GState.TilesOut;
  Result.X := round(Screen.Width / 256)+(integer((Screen.Width mod 256)>0))+GState.TilesOut;
// Result.Y := Ceil(Screen.Height / 256) + GState.TilesOut;
  Result.Y := round(Screen.Height / 256)+(integer((Screen.height mod 256)>0))+GState.TilesOut;
end;


function TFmain.GetMapLayerLocationRect: TRect;
var
  VLoadedSize: TPoint;
  VVisibleSize: TPoint;
begin
  VLoadedSize := GetLoadedSizeInPixel;
  VVisibleSize := GetVisibleSizeInPixel;
  Result := bounds(
    (VVisibleSize.X - VLoadedSize.X) div 2,
    (VVisibleSize.Y - VLoadedSize.Y) div 2,
    VLoadedSize.X,
    VLoadedSize.Y
  );
end;

function TFmain.GetLoadedTopLeft: TPoint;
var
  VSizeInPixel: TPoint;
begin
  VSizeInPixel := GetLoadedSizeInPixel;
  Result.X := ScreenCenterPos.X - VSizeInPixel.X div 2;
  Result.Y := ScreenCenterPos.Y - VSizeInPixel.Y div 2;
end;


function TFmain.VisiblePixel2MapPixel(Pnt:TPoint):TPoint;
begin
  Result := GetVisibleTopLeft;
  Result.X := Result.X + Pnt.X;
  Result.Y := Result.Y + Pnt.y;
end;


function TFmain.MapPixel2VisiblePixel(Pnt: TPoint): TPoint;
var
  VVisibleSize: TPoint;
begin
  VVisibleSize := GetVisibleSizeInPixel;
  Result.X := Pnt.X - ScreenCenterPos.X + (VVisibleSize.X div 2);
  Result.Y := Pnt.Y - ScreenCenterPos.Y + (VVisibleSize.Y div 2);
end;

function TFmain.LoadedPixel2MapPixel(Pnt: TPoint): TPoint;
begin
  Result := GetLoadedTopLeft;
  Result.X := Result.X + Pnt.X;
  Result.Y := Result.Y + Pnt.y;
end;

function TFmain.MapPixel2LoadedPixel(Pnt: TPoint): TPoint;
var
  VSize: TPoint;
begin
  VSize := GetLoadedSizeInPixel;
  Result.X := Pnt.X - ScreenCenterPos.X + (VSize.X div 2);
  Result.Y := Pnt.Y - ScreenCenterPos.Y + (VSize.Y div 2);
end;

function TFmain.LoadedPixel2MapPixel(Pnt: TExtendedPoint): TExtendedPoint;
var
  VTopLeft: TPoint;
begin
  VTopLeft := GetLoadedTopLeft;
  Result.X := VTopLeft.X + Pnt.X;
  Result.Y := VTopLeft.Y + Pnt.y;
end;

function TFmain.MapPixel2LoadedPixel(Pnt: TExtendedPoint): TExtendedPoint;
var
  VSize: TPoint;
begin
  VSize := GetLoadedSizeInPixel;
  Result.X := Pnt.X - ScreenCenterPos.X + (VSize.X / 2);
  Result.Y := Pnt.Y - ScreenCenterPos.Y + (VSize.Y / 2);
end;

function TFmain.MapPixel2VisiblePixel(Pnt: TExtendedPoint): TExtendedPoint;
var
  VSize: TPoint;
begin
  VSize := GetVisibleSizeInPixel;
  Result.X := Pnt.X - ScreenCenterPos.X + (VSize.X / 2);
  Result.Y := Pnt.Y - ScreenCenterPos.Y + (VSize.Y / 2);
end;

function TFmain.VisiblePixel2MapPixel(Pnt: TExtendedPoint): TExtendedPoint;
var
  VTopLeft: TPoint;
begin
  VTopLeft := GetVisibleTopLeft;
  Result.X := VTopLeft.X + Pnt.X;
  Result.Y := VTopLeft.Y + Pnt.y;
end;

end.
