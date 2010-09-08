unit u_ProviderTilesGenPrev;

interface

uses
  Windows,
  Forms,
  t_GeoTypes,
  u_ExportProviderAbstract,
  fr_TilesGenPrev;

type
  TProviderTilesGenPrev = class(TExportProviderAbstract)
  private
    FFrame: TfrTilesGenPrev;
  public
    destructor Destroy; override;
    function GetCaption: string; override;
    procedure InitFrame(Azoom: byte); override;
    procedure Show; override;
    procedure Hide; override;
    procedure StartProcess(APolygon: TExtendedPointArray); override;
  end;


implementation

uses
  SysUtils,
  GR32,
  u_ThreadGenPrevZoom,
  UResStrings,
  Uimgfun,
  UMapType;

{ TProviderTilesGenPrev }

destructor TProviderTilesGenPrev.Destroy;
begin
  FreeAndNil(FFrame);
  inherited;
end;

function TProviderTilesGenPrev.GetCaption: string;
begin
  Result := '��������';
end;

procedure TProviderTilesGenPrev.InitFrame(Azoom: byte);
begin
  if FFrame = nil then begin
    FFrame := TfrTilesGenPrev.Create(nil);
    FFrame.Visible := False;
    FFrame.Parent := FParent;
  end;
  FFrame.Init(Azoom);
end;

procedure TProviderTilesGenPrev.Hide;
begin
  inherited;
  if FFrame <> nil then begin
    if FFrame.Visible then begin
      FFrame.Hide;
    end;
  end;
end;

procedure TProviderTilesGenPrev.Show;
begin
  inherited;
  if FFrame <> nil then begin
    if not FFrame.Visible then begin
      FFrame.Show;
    end;
  end;
end;

procedure TProviderTilesGenPrev.StartProcess(APolygon: TExtendedPointArray);
var
  i:integer;
  VInZooms: TArrayOfByte;
  VMapType: TMapType;
  VZoomsCount: Integer;
  VFromZoom: Byte;

begin
  inherited;
  VMapType:=TMapType(FFrame.cbbMap.Items.Objects[FFrame.cbbMap.ItemIndex]);
  VFromZoom := FFrame.cbbFromZoom.ItemIndex + 1;
  VZoomsCount := 0;
  for i:=0 to FFrame.cbbFromZoom.ItemIndex do begin
    if FFrame.chklstZooms.Checked[i] then begin
      SetLength(VInZooms, VZoomsCount + 1);
      VInZooms[VZoomsCount] := FFrame.cbbFromZoom.ItemIndex - i;
      Inc(VZoomsCount);
    end;
  end;

  TThreadGenPrevZoom.Create(
    VFromZoom,
    VInZooms,
    APolygon,
    VMapType,
    FFrame.chkReplace.Checked,
    FFrame.chkSaveFullOnly.Checked,
    FFrame.chkFromPrevZoom.Checked,
    TTileResamplingType(FFrame.cbbResampler.ItemIndex)
  );
end;

end.

