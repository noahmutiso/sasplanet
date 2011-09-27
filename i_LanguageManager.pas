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

unit i_LanguageManager;

interface

uses
  i_ConfigDataElement,
  i_LanguageListStatic;

type
  ILanguageManager = interface(IConfigDataElement)
  ['{F8D76CED-2681-4DD4-AB24-4C6ECE89CE4D}']
    function GetCurrentLanguageCode: string;
    procedure SetCurrentLanguageCode(ACode: string);
    property CurrentLanguageCode: string read GetCurrentLanguageCode write SetCurrentLanguageCode;

    function GetCurrentLanguageIndex: Integer;
    procedure SetCurrentLanguageIndex(AValue: Integer);
    property CurrentLanguageIndex: Integer read GetCurrentLanguageIndex write SetCurrentLanguageIndex;

    function GetLanguageList: ILanguageListStatic;
    property LanguageList: ILanguageListStatic read GetLanguageList;

    function GetLangNameByIndex(AIndex: Integer): string;
  end;

implementation

end.
