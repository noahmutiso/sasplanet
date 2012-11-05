unit u_TextByVectorItemMarkInfo;

interface

uses
  i_VectorDataItemSimple,
  i_MarksSimple,
  i_ValueToStringConverter,
  i_Datum,
  i_TextByVectorItem;

type
  TTextByVectorItemMarkInfo = class(TInterfacedObject, ITextByVectorItem)
  private
    FValueToStringConverterConfig: IValueToStringConverterConfig;
    FDatum: IDatum;
    function GetTextForPoint(AMark: IMarkPoint): string;
    function GetTextForPath(AMark: IMarkLine): string;
    function GetTextForPoly(AMark: IMarkPoly): string;
  private
    function GetText(const AItem: IVectorDataItemSimple): string;
  public
    constructor Create(
      const AValueToStringConverterConfig: IValueToStringConverterConfig;
      const ADatum: IDatum
    );
  end;


implementation

uses
  SysUtils,
  gnugettext;

{ TTextByVectorItemMarkInfo }

constructor TTextByVectorItemMarkInfo.Create(
  const AValueToStringConverterConfig: IValueToStringConverterConfig;
  const ADatum: IDatum);
begin
  Assert(AValueToStringConverterConfig <> nil);
  Assert(ADatum <> nil);
  inherited Create;
  FValueToStringConverterConfig := AValueToStringConverterConfig;
  FDatum := ADatum;
end;

function TTextByVectorItemMarkInfo.GetText(
  const AItem: IVectorDataItemSimple): string;
var
  VMarkPoint: IMarkPoint;
  VMarkLine: IMarkLine;
  VMarkPoly: IMarkPoly;
begin
  if Supports(AItem, IMarkPoint, VMarkPoint) then begin
    Result := GetTextForPoint(VMarkPoint);
  end else if Supports(AItem, IMarkLine, VMarkLine) then begin
    Result := GetTextForPath(VMarkLine);
  end else if Supports(AItem, IMarkPoly, VMarkPoly) then begin
    Result := GetTextForPoly(VMarkPoly);
  end else begin
    Result := 'Unknown mark type';
  end;
  if Result <> '' then begin
    Result := '<HTML><BODY>' + Result + '</BODY></HTML>';
  end;
end;

function TTextByVectorItemMarkInfo.GetTextForPath(AMark: IMarkLine): string;
var
  VLength: Double;
  VPartsCount: Integer;
  VPointsCount: Integer;
  i: Integer;
  VConverter: IValueToStringConverter;
  VCategoryName: string;
begin
  VPartsCount := AMark.Line.Count;
  VPointsCount := 0;
  for i := 0 to VPartsCount - 1 do begin
    Inc(VPointsCount, AMark.Line.Item[i].Count);
  end;
  VLength := AMark.Line.CalcLength(FDatum);
  VConverter := FValueToStringConverterConfig.GetStatic;
  Result := '';
  VCategoryName := '';
  if AMark.Category <> nil then begin
    VCategoryName := AMark.Category.Name;
  end;
  Result := Result + Format(_('Category: %s'), [VCategoryName]) + #13#10;
  Result := Result + Format(_('Name: %s'), [AMark.Name]) + #13#10;
  Result := Result + Format(_('Parts count: %d'), [VPartsCount]) + #13#10;
  Result := Result + Format(_('Points count: %d'), [VPointsCount]) + #13#10;
  Result := Result + Format(_('Length: %s'), [VConverter.DistConvert(VLength)]) + #13#10;
  Result := Result + Format(_('Description:'#13#10'%s'), [AMark.Desc]) + #13#10;
end;

function TTextByVectorItemMarkInfo.GetTextForPoint(AMark: IMarkPoint): string;
var
  VConverter: IValueToStringConverter;
  VCategoryName: string;
begin
  VConverter := FValueToStringConverterConfig.GetStatic;
  Result := '';
  VCategoryName := '';
  if AMark.Category <> nil then begin
    VCategoryName := AMark.Category.Name;
  end;
  Result := Result + Format(_('Category: %s'), [VCategoryName]) + #13#10;
  Result := Result + Format(_('Name: %s'), [AMark.Name]) + #13#10;
  Result := Result + Format(_('Coordinates: %s'), [VConverter.LonLatConvert(AMark.Point)]) + #13#10;
  Result := Result + Format(_('Description:'#13#10'%s'), [AMark.Desc]) + #13#10;
end;

function TTextByVectorItemMarkInfo.GetTextForPoly(AMark: IMarkPoly): string;
var
  VLength: Double;
  VArea: Double;
  VPartsCount: Integer;
  VPointsCount: Integer;
  i: Integer;
  VConverter: IValueToStringConverter;
  VCategoryName: string;
begin
  VPartsCount := AMark.Line.Count;
  VPointsCount := 0;
  for i := 0 to VPartsCount - 1 do begin
    Inc(VPointsCount, AMark.Line.Item[i].Count);
  end;
  VLength := AMark.Line.CalcPerimeter(FDatum);
  VArea := AMark.Line.CalcArea(FDatum);
  VConverter := FValueToStringConverterConfig.GetStatic;
  Result := '';
  VCategoryName := '';
  if AMark.Category <> nil then begin
    VCategoryName := AMark.Category.Name;
  end;
  Result := Result + Format(_('Category: %s'), [VCategoryName]) + #13#10;
  Result := Result + Format(_('Name: %s'), [AMark.Name]) + #13#10;
  Result := Result + Format(_('Parts count: %d'), [VPartsCount]) + #13#10;
  Result := Result + Format(_('Points count: %d'), [VPointsCount]) + #13#10;
  Result := Result + Format(_('Perimeter: %s'), [VConverter.DistConvert(VLength)]) + #13#10;
  Result := Result + Format(_('Area: %s'), [VConverter.AreaConvert(VArea)]) + #13#10;
  Result := Result + Format(_('Description:'#13#10'%s'), [AMark.Desc]) + #13#10;
end;

end.
