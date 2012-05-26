unit fr_TilesCopy;

interface

uses
  Types,
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  CheckLst,
  ExtCtrls,
  i_LanguageManager,
  i_MapTypes,
  i_ActiveMapsConfig,
  i_MapTypeGUIConfigList,
  i_VectorItemLonLat,
  i_RegionProcessParamsFrame,
  u_CommonFormAndFrameParents;

type
  IRegionProcessParamsFrameTilesCopy = interface(IRegionProcessParamsFrameBase)
    ['{71851148-93F1-42A9-ADAC-757928C5C85A}']
    function GetReplaseTarget: Boolean;
    property ReplaseTarget: Boolean read GetReplaseTarget;

    function GetDeleteSource: Boolean;
    property DeleteSource: Boolean read GetDeleteSource;

    function GetTargetCacheType: Byte;
    property TargetCacheType: Byte read GetTargetCacheType;

    function GetMapTypeList: IMapTypeListStatic;
    property MapTypeList: IMapTypeListStatic read GetMapTypeList;
  end;

type
  TfrTilesCopy = class(
      TFrame,
      IRegionProcessParamsFrameBase,
      IRegionProcessParamsFrameZoomArray,
      IRegionProcessParamsFrameTargetPath,
      IRegionProcessParamsFrameTilesCopy
    )
    pnlCenter: TPanel;
    pnlRight: TPanel;
    lblZooms: TLabel;
    chkAllZooms: TCheckBox;
    chklstZooms: TCheckListBox;
    pnlMain: TPanel;
    lblNamesType: TLabel;
    cbbNamesType: TComboBox;
    pnlTop: TPanel;
    lblTargetPath: TLabel;
    edtTargetPath: TEdit;
    btnSelectTargetPath: TButton;
    chkDeleteSource: TCheckBox;
    chkReplaseTarget: TCheckBox;
    chkAllMaps: TCheckBox;
    chklstMaps: TCheckListBox;
    Panel1: TPanel;
    procedure btnSelectTargetPathClick(Sender: TObject);
    procedure chkAllZoomsClick(Sender: TObject);
    procedure chkAllMapsClick(Sender: TObject);
    procedure chklstZoomsDblClick(Sender: TObject);
  private
    FMainMapsConfig: IMainMapsConfig;
    FFullMapsSet: IMapTypeSet;
    FGUIConfigList: IMapTypeGUIConfigList;
  private
    procedure Init(
      const AZoom: byte;
      const APolygon: ILonLatPolygon
    );
  private
    function GetZoomArray: TByteDynArray;
    function GetPath: string;
  private
    function GetReplaseTarget: Boolean;
    function GetDeleteSource: Boolean;
    function GetTargetCacheType: Byte;
    function GetMapTypeList: IMapTypeListStatic;
  public
    constructor Create(
      const ALanguageManager: ILanguageManager;
      const AMainMapsConfig: IMainMapsConfig;
      const AFullMapsSet: IMapTypeSet;
      const AGUIConfigList: IMapTypeGUIConfigList
    ); reintroduce;
    procedure RefreshTranslation; override;
  end;

implementation

uses
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  i_GUIDListStatic,
  u_MapTypeListStatic,
  u_MapType;

{$R *.dfm}

procedure TfrTilesCopy.btnSelectTargetPathClick(Sender: TObject);
var
  TempPath: string;
begin
  if SelectDirectory('', '', TempPath) then begin
    edtTargetPath.Text := IncludeTrailingPathDelimiter(TempPath);
  end;
end;

procedure TfrTilesCopy.chkAllMapsClick(Sender: TObject);
var
  i: byte;
begin
  for i:=0 to chklstMaps.Count-1 do begin
    chklstMaps.Checked[i] := TCheckBox(sender).Checked;
  end;
end;

procedure TfrTilesCopy.chkAllZoomsClick(Sender: TObject);
var
  i: byte;
begin
  if chkAllZooms.state<>cbGrayed then
  for i:=0 to chklstZooms.Count-1 do begin
    chklstZooms.Checked[i] := TCheckBox(sender).Checked;
  end;
end;

procedure TfrTilesCopy.chklstZoomsDblClick(Sender: TObject);
var
  i: Integer;
begin
  for I := 0 to chklstZooms.ItemIndex do chklstZooms.Checked[i]:=true;
  if chklstZooms.ItemIndex<chklstZooms.count-1 then for I := chklstZooms.ItemIndex+1 to chklstZooms.count-1 do chklstZooms.Checked[i]:=false;
  if chklstZooms.ItemIndex=chklstZooms.count-1 then chkAllZooms.state:=cbChecked else chkAllZooms.state:=cbGrayed;
end;

constructor TfrTilesCopy.Create(
  const ALanguageManager: ILanguageManager;
  const AMainMapsConfig: IMainMapsConfig;
  const AFullMapsSet: IMapTypeSet;
  const AGUIConfigList: IMapTypeGUIConfigList
);
begin
  inherited Create(ALanguageManager);
  FMainMapsConfig := AMainMapsConfig;
  FFullMapsSet := AFullMapsSet;
  FGUIConfigList := AGUIConfigList;
  cbbNamesType.ItemIndex := 1;
end;

function TfrTilesCopy.GetDeleteSource: Boolean;
begin
  Result := chkDeleteSource.Checked;
end;

function TfrTilesCopy.GetMapTypeList: IMapTypeListStatic;
var
  VMap: IMapType;
  VMaps: array of IMapType;
  VMapType: TMapType;
  i: Integer;
begin
  for i := 0 to chklstMaps.Items.Count - 1 do begin
    if chklstMaps.Checked[i] then begin
      VMap := nil;
      VMapType := TMapType(chklstMaps.Items.Objects[i]);
      if VMapType <> nil then begin
        VMap := FFullMapsSet.GetMapTypeByGUID(VMapType.Zmp.GUID);
      end;
      if VMap <> nil then begin
        SetLength(VMaps, Length(VMaps) + 1);
        VMaps[Length(VMaps) - 1] := VMap;
      end;
    end;
  end;
  Result := TMapTypeListStatic.Create(VMaps);
end;

function TfrTilesCopy.GetPath: string;
begin
  Result := IncludeTrailingPathDelimiter(edtTargetPath.Text);
end;

function TfrTilesCopy.GetReplaseTarget: Boolean;
begin
  Result := chkReplaseTarget.Checked;
end;

function TfrTilesCopy.GetTargetCacheType: Byte;
begin
  if cbbNamesType.ItemIndex >= 0 then begin
    Result := cbbNamesType.ItemIndex + 1
  end else begin
    Result := 1;
  end;
end;

function TfrTilesCopy.GetZoomArray: TByteDynArray;
var
  i: Integer;
  VCount: Integer;
begin
  Result := nil;
  VCount := 0;
  for i := 0 to 23 do begin
    if chklstZooms.Checked[i] then begin
      SetLength(Result, VCount + 1);
      Result[VCount] := i;
      Inc(VCount);
    end;
  end;
end;

procedure TfrTilesCopy.Init;
var
  i: integer;
  VMapType: TMapType;
  VActiveMapGUID: TGUID;
  VAddedIndex: Integer;
  VGUIDList: IGUIDListStatic;
  VGUID: TGUID;
begin
  chklstZooms.Items.Clear;
  for i:=1 to 24 do begin
    chklstZooms.Items.Add(inttostr(i));
  end;

  VActiveMapGUID := FMainMapsConfig.GetActiveMap.GetSelectedGUID;
  chklstMaps.Items.Clear;
  VGUIDList := FGUIConfigList.OrderedMapGUIDList;
  For i := 0 to VGUIDList.Count-1 do begin
    VGUID := VGUIDList.Items[i];
    VMapType := FFullMapsSet.GetMapTypeByGUID(VGUID).MapType;
    if (VMapType.GUIConfig.Enabled) then begin
      VAddedIndex := chklstMaps.Items.AddObject(VMapType.GUIConfig.Name.Value, VMapType);
      if IsEqualGUID(VMapType.Zmp.GUID, VActiveMapGUID) then begin
        chklstMaps.ItemIndex := VAddedIndex;
        chklstMaps.Checked[VAddedIndex] := True;
      end;
    end;
  end;
end;

procedure TfrTilesCopy.RefreshTranslation;
var
  i: Integer;
begin
  i := cbbNamesType.ItemIndex;
  inherited;
  cbbNamesType.ItemIndex := i;
end;

end.
