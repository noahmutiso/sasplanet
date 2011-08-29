unit u_MarkFactory;

interface

uses
  Windows,
  GR32,
  t_GeoTypes,
  i_MarkPicture,
  i_MarksFactoryConfig,
  i_MarkCategory,
  i_MarkCategoryDBSmlInternal,
  i_MarksSimple,
  i_MarkTemplate,
  i_HtmlToHintTextConverter,
  i_MarkFactory,
  i_MarkFactorySmlInternal;

type

  TMarkFactory =  class(TInterfacedObject, IMarkFactory, IMarkFactorySmlInternal)
  private
    FConfig: IMarksFactoryConfig;
    FDbCode: Integer;
    FCategoryDB: IMarkCategoryDBSmlInternal;
    FHintConverter: IHtmlToHintTextConverter;

    FMarkPictureList: IMarkPictureList;
    function GetLLRectFromPoints(APoints: TArrayOfDoublePoint): TDoubleRect;
    function GetLLRectFromPoint(APoint: TDoublePoint): TDoubleRect;
    procedure PreparePolyPoints(var APoints: TArrayOfDoublePoint);
    procedure PreparePathPoints(var APoints: TArrayOfDoublePoint);

    function CreateLine(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      ACategoryId: Integer;
      ACategory: IMarkCategory;
      ADesc: string;
      ARect: TDoubleRect;
      APoints: TArrayOfDoublePoint;
      AColor1: TColor32;
      AScale1: Integer
    ): IMarkFull;
    function CreatePoint(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      APicName: string;
      APic: IMarkPicture;
      ACategoryId: Integer;
      ACategory: IMarkCategory;
      ADesc: string;
      APoint: TDoublePoint;
      AColor1, AColor2: TColor32;
      AScale1, AScale2: Integer
    ): IMarkFull;
    function CreatePoly(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      ACategoryId: Integer;
      ACategory: IMarkCategory;
      ADesc: string;
      ARect: TDoubleRect;
      APoints: TArrayOfDoublePoint;
      AColor1, AColor2: TColor32;
      AScale1: Integer
    ): IMarkFull;
  protected
    function CreateNewPoint(
      APoint: TDoublePoint;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplatePoint = nil
    ): IMarkFull;
    function CreateNewLine(
      APoints: TArrayOfDoublePoint;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplateLine = nil
    ): IMarkFull;
    function CreateNewPoly(
      APoints: TArrayOfDoublePoint;
      AName: string;
      ADesc: string;
      ATemplate: IMarkTemplatePoly = nil
    ): IMarkFull;

    function ModifyPoint(
      ASource: IMarkFull;
      AName: string;
      AVisible: Boolean;
      APic: IMarkPicture;
      ACategory: IMarkCategory;
      ADesc: string;
      APoint: TDoublePoint;
      AColor1: TColor32;
      AColor2: TColor32;
      AScale1: Integer;
      AScale2: Integer
    ): IMarkFull;
    function ModifyLine(
      ASource: IMarkFull;
      AName: string;
      AVisible: Boolean;
      ACategory: IMarkCategory;
      ADesc: string;
      APoints: TArrayOfDoublePoint;
      AColor1: TColor32;
      AScale1: Integer
    ): IMarkFull;
    function ModifyPoly(
      ASource: IMarkFull;
      AName: string;
      AVisible: Boolean;
      ACategory: IMarkCategory;
      ADesc: string;
      APoints: TArrayOfDoublePoint;
      AColor1: TColor32;
      AColor2: TColor32;
      AScale1: Integer
    ): IMarkFull;

    function SimpleModifyLine(
      ASource: IMarkFull;
      APoints: TArrayOfDoublePoint;
      ADesc: string
    ): IMarkFull;
    function SimpleModifyPoly(
      ASource: IMarkFull;
      APoints: TArrayOfDoublePoint
    ): IMarkFull;

    function GetConfig: IMarksFactoryConfig;
  protected
    function CreateMark(
      AID: Integer;
      AName: string;
      AVisible: Boolean;
      APicName: string;
      ACategoryId: Integer;
      ADesc: string;
      ARect: TDoubleRect;
      APoints: TArrayOfDoublePoint;
      AColor1: TColor32;
      AColor2: TColor32;
      AScale1: Integer;
      AScale2: Integer
    ): IMarkFull;
    function CreateMarkId(
      AName: string;
      AId: Integer;
      ACategoryId: Integer;
      AVisible: Boolean
    ): IMarkID;
  public
    constructor Create(
      ADbCode: Integer;
      AConfig: IMarksFactoryConfig;
      AHintConverter: IHtmlToHintTextConverter;
      ACategoryDB: IMarkCategoryDBSmlInternal
    );
  end;

implementation

uses
  SysUtils,
  i_MarksDbSmlInternal,
  u_GeoFun,
  u_MarkId,
  u_MarkPoint,
  u_MarkLine,
  u_MarkPoly;

{ TMarkFactory }

constructor TMarkFactory.Create(
  ADbCode: Integer;
  AConfig: IMarksFactoryConfig;
  AHintConverter: IHtmlToHintTextConverter;
  ACategoryDB: IMarkCategoryDBSmlInternal
);
begin
  FDbCode := ADbCode;
  FConfig := AConfig;
  FHintConverter := AHintConverter;
  FCategoryDB := ACategoryDB;
  FMarkPictureList := FConfig.PointTemplateConfig.MarkPictureList;
end;

function TMarkFactory.CreateNewLine(APoints: TArrayOfDoublePoint; AName,
  ADesc: string; ATemplate: IMarkTemplateLine): IMarkFull;
var
  VTemplate: IMarkTemplateLine;
  VTemplateSML: IMarkTemplateSMLInternal;
  VCategory: IMarkCategory;
  VCategoryID: Integer;
  VName: string;
  VPoints: TArrayOfDoublePoint;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.LineTemplateConfig.DefaultTemplate;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  VPoints := Copy(APoints);
  PreparePathPoints(VPoints);

  Result := CreateLine(
    -1,
    VName,
    True,
    VCategoryId,
    VCategory,
    ADesc,
    GetLLRectFromPoints(VPoints),
    VPoints,
    VTemplate.Color1,
    VTemplate.Scale1
  );
end;

function TMarkFactory.CreateNewPoint(APoint: TDoublePoint; AName, ADesc: string;
  ATemplate: IMarkTemplatePoint): IMarkFull;
var
  VTemplate: IMarkTemplatePoint;
  VTemplateSML: IMarkTemplateSMLInternal;
  VName: string;
  VCategory: IMarkCategory;
  VCategoryID: Integer;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.PointTemplateConfig.DefaultTemplate;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  Result := CreatePoint(
    -1,
    VName,
    True,
    '',
    VTemplate.Pic,
    VCategoryId,
    VCategory,
    ADesc,
    APoint,
    VTemplate.Color1,
    VTemplate.Color2,
    VTemplate.FontSize,
    VTemplate.Scale2
  );
end;

function TMarkFactory.CreateNewPoly(APoints: TArrayOfDoublePoint; AName,
  ADesc: string; ATemplate: IMarkTemplatePoly): IMarkFull;
var
  VTemplate: IMarkTemplatePoly;
  VTemplateSML: IMarkTemplateSMLInternal;
  VName: string;
  VPoints: TArrayOfDoublePoint;
  VCategory: IMarkCategory;
  VCategoryID: Integer;
begin
  VTemplate := ATemplate;
  if VTemplate = nil then begin
    VTemplate := FConfig.PolyTemplateConfig.TemplateDefault;
  end;

  VName := AName;
  if VName = '' then begin
    VName := VTemplate.GetNewName;
  end;

  VPoints := Copy(APoints);
  PreparePolyPoints(VPoints);

  VCategoryID := -1;
  if Supports(VTemplate, IMarkTemplateSMLInternal, VTemplateSML) then begin
    VCategoryID := VTemplateSML.CategoryId;
  end;

  Result := CreatePoly(
    -1,
    VName,
    True,
    VCategoryId,
    VCategory,
    ADesc,
    GetLLRectFromPoints(APoints),
    VPoints,
    VTemplate.Color1,
    VTemplate.Color2,
    VTemplate.Scale1
  );
end;

function TMarkFactory.CreatePoint(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  APicName: string;
  APic: IMarkPicture;
  ACategoryId: Integer;
  ACategory: IMarkCategory;
  ADesc: string;
  APoint: TDoublePoint;
  AColor1, AColor2: TColor32;
  AScale1, AScale2: Integer
): IMarkFull;
var
  VPicIndex: Integer;
  VPic: IMarkPicture;
  VPicName: string;
  VCategory: IMarkCategory;
begin
  VPic := APic;
  if VPic = nil then begin
    VPicName := APicName;
    VPicIndex := FMarkPictureList.GetIndexByName(APicName);
    if VPicIndex < 0 then begin
      VPic := nil;
    end else begin
      VPic := FMarkPictureList.Get(VPicIndex);
    end;
  end else begin
    VPicName := VPic.GetName;
  end;

  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkPoint.Create(
    FHintConverter,
    FDbCode,
    AName,
    AID,
    AVisible,
    VPicName,
    VPic,
    VCategory,
    ADesc,
    GetLLRectFromPoint(APoint),
    APoint,
    AColor1,
    AColor2,
    AScale1,
    AScale2
  );
end;

function TMarkFactory.CreateLine(
  AID: Integer; AName: string; AVisible: Boolean;
  ACategoryId: Integer;
  ACategory: IMarkCategory;
  ADesc: string;
  ARect: TDoubleRect;
  APoints: TArrayOfDoublePoint;
  AColor1: TColor32; AScale1: Integer): IMarkFull;
var
  VCategory: IMarkCategory;
begin
  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkLine.Create(
    FHintConverter,
    FDbCode,
    AName,
    AId,
    AVisible,
    VCategory,
    ADesc,
    ARect,
    APoints,
    AColor1,
    AScale1
  );
end;

function TMarkFactory.CreatePoly(
  AID: Integer; AName: string; AVisible: Boolean;
  ACategoryId: Integer;
  ACategory: IMarkCategory;
  ADesc: string;
  ARect: TDoubleRect;
  APoints: TArrayOfDoublePoint; AColor1,
  AColor2: TColor32; AScale1: Integer): IMarkFull;
var
  VCategory: IMarkCategory;
begin
  VCategory := ACategory;
  if VCategory = nil then begin
    VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  end;

  Result := TMarkPoly.Create(
    FHintConverter,
    FDbCode,
    AName,
    AID,
    AVisible,
    VCategory,
    ADesc,
    ARect,
    APoints,
    AColor1,
    AColor2,
    AScale1
  );
end;

function TMarkFactory.CreateMark(
  AID: Integer;
  AName: string;
  AVisible: Boolean;
  APicName: string;
  ACategoryId: Integer;
  ADesc: string;
  ARect: TDoubleRect;
  APoints: TArrayOfDoublePoint;
  AColor1, AColor2: TColor32;
  AScale1, AScale2: Integer
): IMarkFull;
var
  VPointCount: Integer;
begin
  VPointCount := Length(APoints);
  if VPointCount > 0 then begin
    if VPointCount = 1 then begin
      Result := CreatePoint(AId, AName, AVisible, APicName, nil, ACategoryId, nil, ADesc, APoints[0], AColor1, AColor2, AScale1, AScale2)
    end else begin
      if DoublePointsEqual(APoints[0], APoints[VPointCount - 1]) then begin
        Result := CreatePoly(AId, AName, AVisible, ACategoryId, nil, ADesc, ARect, APoints, AColor1, AColor2, AScale1);
      end else begin
        Result := CreateLine(AId, AName, AVisible, ACategoryId, nil, ADesc, ARect, APoints, AColor1, AScale1);
      end;
    end;
  end;
end;

function TMarkFactory.CreateMarkId(
  AName: string;
  AId: Integer;
  ACategoryId: Integer;
  AVisible: Boolean
): IMarkID;
var
  VCategory: IMarkCategory;
begin
  VCategory := FCategoryDB.GetCategoryByID(ACategoryId);
  Result := TMarkId.Create(FDbCode, AName, AId, VCategory, AVisible);
end;

function TMarkFactory.SimpleModifyLine(
  ASource: IMarkFull;
  APoints: TArrayOfDoublePoint;
  ADesc: string
): IMarkFull;
var
  VId: Integer;
  VCategoryId: Integer;
  VDesc: string;
  VVisible: Boolean;
  VMarkInternal: IMarkSMLInternal;
  VPoints: TArrayOfDoublePoint;
begin
  VVisible := True;
  VId := -1;
  VCategoryId := -1;
  if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
    VVisible := VMarkInternal.Visible;
    VId := VMarkInternal.Id;
    VCategoryId := VMarkInternal.CategoryId;
  end;
  VDesc := ADesc;
  if ADesc = '' then begin
    VDesc := ASource.Desc;
  end;

  VPoints := Copy(APoints);
  PreparePathPoints(VPoints);

  Result := CreateLine(
    VId,
    ASource.Name,
    VVisible,
    VCategoryId,
    ASource.Category,
    VDesc,
    GetLLRectFromPoints(VPoints),
    VPoints,
    ASource.Color1,
    ASource.Scale1
  );
end;

function TMarkFactory.SimpleModifyPoly(
  ASource: IMarkFull;
  APoints: TArrayOfDoublePoint
): IMarkFull;
var
  VVisible: Boolean;
  VId: Integer;
  VCategoryId: Integer;
  VMarkInternal: IMarkSMLInternal;
  VPoints: TArrayOfDoublePoint;
begin
  VVisible := True;
  VId := -1;
  VCategoryId := -1;
  if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
    VVisible := VMarkInternal.Visible;
    VId := VMarkInternal.Id;
    VCategoryId := VMarkInternal.CategoryId;
  end;

  VPoints := Copy(APoints);
  PreparePathPoints(VPoints);

  Result := CreatePoly(
    VId,
    ASource.Name,
    VVisible,
    VCategoryId,
    ASource.Category,
    ASource.Desc,
    GetLLRectFromPoints(VPoints),
    VPoints,
    ASource.Color1,
    ASource.Color2,
    ASource.Scale1
  );
end;

function TMarkFactory.ModifyPoint(
  ASource: IMarkFull;
  AName: string;
  AVisible: Boolean;
  APic: IMarkPicture;
  ACategory: IMarkCategory;
  ADesc: string;
  APoint: TDoublePoint;
  AColor1: TColor32;
  AColor2: TColor32;
  AScale1: Integer;
  AScale2: Integer
): IMarkFull;
var
  VID: Integer;
  VCategoryId: Integer;
  VPicName: string;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
  VMarkPointInternal: IMarkPointSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
    if Supports(ASource, IMarkPointSMLInternal, VMarkPointInternal) then begin
      VPicName := VMarkPointInternal.PicName;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  Result := CreatePoint(
    VID,
    AName,
    AVisible,
    VPicName,
    APic,
    VCategoryId,
    ACategory,
    ADesc,
    APoint,
    AColor1,
    AColor2,
    AScale1,
    AScale2
  );
end;

function TMarkFactory.ModifyLine(
  ASource: IMarkFull;
  AName: string;
  AVisible: Boolean;
  ACategory: IMarkCategory;
  ADesc: string;
  APoints: TArrayOfDoublePoint;
  AColor1: TColor32;
  AScale1: Integer
): IMarkFull;
var
  VID: Integer;
  VCategoryId: Integer;
  VPoints: TArrayOfDoublePoint;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  VPoints := Copy(APoints);
  PreparePathPoints(VPoints);
  Result := CreateLine(
    VId,
    AName,
    AVisible,
    VCategoryId,
    ACategory,
    ADesc,
    GetLLRectFromPoints(VPoints),
    VPoints,
    AColor1,
    AScale1
  );
end;

function TMarkFactory.ModifyPoly(
  ASource: IMarkFull;
  AName: string;
  AVisible: Boolean;
  ACategory: IMarkCategory;
  ADesc: string;
  APoints: TArrayOfDoublePoint;
  AColor1: TColor32;
  AColor2: TColor32;
  AScale1: Integer
): IMarkFull;
var
  VID: Integer;
  VCategoryId: Integer;
  VPoints: TArrayOfDoublePoint;
  VCategoryInternal: IMarkCategorySMLInternal;
  VMarkInternal: IMarkSMLInternal;
begin
  VID := -1;
  if ASource <> nil then begin
    if Supports(ASource, IMarkSMLInternal, VMarkInternal) then begin
      VID := VMarkInternal.Id;
    end;
  end;
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;

  VPoints := Copy(APoints);
  PreparePolyPoints(VPoints);
  Result := CreatePoly(
    VID,
    AName,
    AVisible,
    VCategoryId,
    ACategory,
    ADesc,
    GetLLRectFromPoints(VPoints),
    VPoints,
    AColor1,
    AColor2,
    AScale1
  );
end;

function TMarkFactory.GetConfig: IMarksFactoryConfig;
begin
  Result := FConfig;
end;

function TMarkFactory.GetLLRectFromPoint(APoint: TDoublePoint): TDoubleRect;
begin
  Result.TopLeft := APoint;
  Result.BottomRight := APoint;
end;

function TMarkFactory.GetLLRectFromPoints(
  APoints: TArrayOfDoublePoint): TDoubleRect;
var
  VCount: Integer;
  i: Integer;
begin
  VCount := Length(APoints);
  if VCount > 0 then begin
    Result.TopLeft := APoints[0];
    Result.BottomRight := APoints[0];
    for i := 1 to VCount - 1 do begin
      if not PointIsEmpty(APoints[i]) then begin
        if Result.Left > APoints[i].X then begin
          Result.Left := APoints[i].X;
        end;
        if Result.Top < APoints[i].Y then begin
          Result.Top := APoints[i].Y;
        end;
        if Result.Right < APoints[i].X then begin
          Result.Right := APoints[i].X;
        end;
        if Result.Bottom > APoints[i].Y then begin
          Result.Bottom := APoints[i].Y;
        end;
      end;
    end;
  end else begin
    Result.Left := 0;
    Result.Top := 0;
    Result.Right := 0;
    Result.Bottom := 0;
  end;
end;

procedure TMarkFactory.PreparePathPoints(var APoints: TArrayOfDoublePoint);
var
  VCount: Integer;
begin
  VCount := Length(APoints);
  while (VCount > 0) and PointIsEmpty(APoints[VCount - 1]) do begin
    Dec(VCount);
  end;
  SetLength(APoints, VCount);
  Assert(VCount > 1, '� ���� ������ ���� ���� �� 2 �����');
end;

procedure TMarkFactory.PreparePolyPoints(var APoints: TArrayOfDoublePoint);
var
  VCount: Integer;
begin
  VCount := Length(APoints);
  Assert(VCount > 1, '� �������� ������ ���� ���� �� 2 �����');
  if VCount > 0 then begin
    if not DoublePointsEqual(APoints[0], APoints[VCount - 1]) then begin
      SetLength(APoints, VCount + 1);
      APoints[VCount] := APoints[0];
    end;
  end;
end;

end.
