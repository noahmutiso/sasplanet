{******************************************************************************}
{* SAS.������� (SAS.Planet)                                                   *}
{* Copyright (C) 2007-2011, ������ ��������� SAS.������� (SAS.Planet).        *}
{* ��� ��������� �������� ��������� ����������� ������������. �� ������       *}
{* �������������� �/��� �������������� � �������� �������� �����������       *}
{* ������������ �������� GNU, �������������� ������ ���������� ������������   *}
{* �����������, ������ 3. ��� ��������� ���������������� � �������, ��� ���   *}
{* ����� ��������, �� ��� ������ ��������, � ��� ����� ���������������        *}
{* �������� ��������� ��������� ��� ������� � �������� ��� ������˨�����      *}
{* ����������. �������� ����������� ������������ �������� GNU ������ 3, ���   *}
{* ��������� �������������� ����������. �� ������ ���� �������� �����         *}
{* ����������� ������������ �������� GNU ������ � ����������. � ������ �     *}
{* ����������, ���������� http://www.gnu.org/licenses/.                       *}
{*                                                                            *}
{* http://sasgis.ru/sasplanet                                                 *}
{* az@sasgis.ru                                                               *}
{******************************************************************************}

unit u_MarkCategoryFactory;

interface

uses
  i_MarkCategory,
  i_MarkCategoryFactoryConfig,
  i_MarkCategoryFactory,
  i_MarkCategoryFactoryDbInternal;

type
  TMarkCategoryFactory = class(TInterfacedObject, IMarkCategoryFactory, IMarkCategoryFactoryDbInternal)
  private
    FConfig: IMarkCategoryFactoryConfig;
    FDbCode: Integer;
  protected
    function CreateNew(AName: string): IMarkCategory;
    function Modify(
      ASource: IMarkCategory;
      AName: string;
      AVisible: Boolean;
      AAfterScale: integer;
      ABeforeScale: integer
    ): IMarkCategory;
    function ModifyVisible(ASource: IMarkCategory; AVisible: Boolean): IMarkCategory;
  protected
    function CreateCategory(
      AId: Integer;
      AName: string;
      AVisible: Boolean;
      AAfterScale: integer;
      ABeforeScale: integer
    ): IMarkCategory;
  public
    constructor Create(
      ADbCode: Integer;
      AConfig: IMarkCategoryFactoryConfig
    );
  end;

implementation

uses
  SysUtils,
  i_MarksDbSmlInternal,
  u_MarkCategory;

{ TMarkCategoryFactory }

constructor TMarkCategoryFactory.Create(
  ADbCode: Integer;
  AConfig: IMarkCategoryFactoryConfig
);
begin
  FDbCode := ADbCode;
  FConfig := AConfig;
end;

function TMarkCategoryFactory.CreateCategory(
  AId: Integer;
  AName: string;
  AVisible: Boolean;
  AAfterScale, ABeforeScale: integer
): IMarkCategory;
begin
  Result := TMarkCategory.Create(
    FDbCode,
    AId,
    AName,
    AVisible,
    AAfterScale,
    ABeforeScale
  );
end;

function TMarkCategoryFactory.CreateNew(AName: string): IMarkCategory;
var
  VName: string;
  VAfterScale, VBeforeScale: Integer;
begin
  VName := AName;
  FConfig.LockRead;
  try
    if VName = '' then begin
      VName := FConfig.DefaultName.Value;
    end;
    VAfterScale := FConfig.AfterScale;
    VBeforeScale := FConfig.BeforeScale;
  finally
    FConfig.UnlockRead;
  end;

  Result :=
    CreateCategory(
      -1,
      VName,
      True,
      VAfterScale,
      VBeforeScale
    );
end;

function TMarkCategoryFactory.Modify(
  ASource: IMarkCategory;
  AName: string;
  AVisible: Boolean;
  AAfterScale, ABeforeScale: integer
): IMarkCategory;
var
  VName: string;
  VId: Integer;
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  VName := AName;
  FConfig.LockRead;
  try
    if VName = '' then begin
      VName := FConfig.DefaultName.Value;
    end;
  finally
    FConfig.UnlockRead;
  end;

  VId := -1;
  if Supports(ASource, IMarkCategorySMLInternal, VCategoryInternal) then begin
    VId := VCategoryInternal.Id;
  end;

  Result :=
    CreateCategory(
      VId,
      VName,
      AVisible,
      AAfterScale,
      ABeforeScale
    );
end;

function TMarkCategoryFactory.ModifyVisible(
  ASource: IMarkCategory;
  AVisible: Boolean
): IMarkCategory;
var
  VId: Integer;
  VCategoryInternal: IMarkCategorySMLInternal;
begin
  VId := -1;
  if Supports(ASource, IMarkCategorySMLInternal, VCategoryInternal) then begin
    VId := VCategoryInternal.Id;
  end;

  Result :=
    CreateCategory(
      VId,
      ASource.Name,
      AVisible,
      ASource.AfterScale,
      ASource.BeforeScale
    );
end;

end.
