unit u_MarkLineTemplateConfig;

interface

uses
  Classes,
  GR32,
  i_ConfigDataProvider,
  i_ConfigDataWriteProvider,
  i_MarkTemplate,
  i_MarkCategory,
  i_MarksFactoryConfig,
  i_MarkCategoryDBSmlInternal,
  u_MarkTemplateConfigBase;

type
  TMarkLineTemplateConfig = class(TMarkTemplateConfigBase, IMarkLineTemplateConfig)
  private
    FDefaultTemplate: IMarkTemplateLine;
  protected
    procedure DoReadConfig(AConfigData: IConfigDataProvider); override;
    procedure DoWriteConfig(AConfigData: IConfigDataWriteProvider); override;
  protected
    function CreateTemplate(
      ACategory: IMarkCategory;
      AColor1: TColor32;
      AScale1: Integer
    ): IMarkTemplateLine;

    function GetDefaultTemplate: IMarkTemplateLine;
    procedure SetDefaultTemplate(AValue: IMarkTemplateLine);
  public
    constructor Create(
      ACategoryDb: IMarkCategoryDBSmlInternal
    );
  end;

implementation

uses
  SysUtils,
  i_MarksDbSmlInternal,
  u_ConfigProviderHelpers,
  u_ResStrings,
  u_MarkTemplates;

{ TMarkLineTemplateConfig }

constructor TMarkLineTemplateConfig.Create(
  ACategoryDb: IMarkCategoryDBSmlInternal
);
begin
  inherited Create(ACategoryDb, SAS_STR_NewPath);

  FDefaultTemplate := CreateTemplate(
    nil,
    SetAlpha(clRed32, 166),
    2
  );
end;

function TMarkLineTemplateConfig.CreateTemplate(
  ACategory: IMarkCategory;
  AColor1: TColor32;
  AScale1: Integer
): IMarkTemplateLine;
var
  VCategoryId: Integer;
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  VCategoryId := -1;
  if ACategory <> nil then begin
    if Supports(ACategory, IMarkCategorySMLInternal, VCategoryInternal) then begin
      VCategoryId := VCategoryInternal.Id;
    end;
  end;
  Result := TMarkTemplateLine.Create(
    CategoryDb,
    NameGenerator,
    VCategoryId,
    AColor1,
    AScale1
  );
end;

procedure TMarkLineTemplateConfig.DoReadConfig(
  AConfigData: IConfigDataProvider);
var
  VCategoryId: Integer;
  VColor: TColor32;
  VLineWeight: Integer;
  VTemplateInternal: IMarkTemplateSMLInternal;
begin
  inherited;
  VCategoryID := -1;
  if Supports(FDefaultTemplate, IMarkTemplateSMLInternal, VTemplateInternal) then begin
    VCategoryId := VTemplateInternal.CategoryId;
  end;
  VColor := FDefaultTemplate.Color;
  VLineWeight := FDefaultTemplate.LineWeight;
  if AConfigData <> nil then begin
    VCategoryId := AConfigData.ReadInteger('CategoryId', VCategoryId);
    VColor := ReadColor32(AConfigData, 'LineColor', VColor);
    VLineWeight := AConfigData.ReadInteger('LineWidth', VLineWeight);
  end;
  SetDefaultTemplate(
    TMarkTemplateLine.Create(
      CategoryDb,
      NameGenerator,
      VCategoryId,
      VColor,
      VLineWeight
    )
  );
end;

procedure TMarkLineTemplateConfig.DoWriteConfig(
  AConfigData: IConfigDataWriteProvider);
var
  VCategoryId: Integer;
  VTemplateInternal: IMarkTemplateSMLInternal;
begin
  inherited;
  VCategoryID := -1;
  if Supports(FDefaultTemplate, IMarkTemplateSMLInternal, VTemplateInternal) then begin
    VCategoryId := VTemplateInternal.CategoryId;
  end;
  AConfigData.WriteInteger('CategoryId', VCategoryId);
  WriteColor32(AConfigData, 'LineColor', FDefaultTemplate.Color);
  AConfigData.WriteInteger('LineWidth', FDefaultTemplate.LineWeight);
end;

function TMarkLineTemplateConfig.GetDefaultTemplate: IMarkTemplateLine;
begin
  LockRead;
  try
    Result := FDefaultTemplate;
  finally
    UnlockRead;
  end;
end;

procedure TMarkLineTemplateConfig.SetDefaultTemplate(
  AValue: IMarkTemplateLine);
begin
  if AValue <> nil then begin
    LockWrite;
    try
      if (FDefaultTemplate = nil) or (not FDefaultTemplate.IsSame(AValue)) then begin
        FDefaultTemplate := AValue;
        SetChanged;
      end;
    finally
      UnlockWrite;
    end;
  end;
end;

end.

