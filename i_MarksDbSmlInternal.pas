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

unit i_MarksDbSmlInternal;

interface

type
  IMarkSMLInternal = interface
  ['{2611AAA5-10DA-472B-B3EE-31EA27EDD6CD}']
    function GetDbCode: Integer;
    property DbCode: Integer read GetDbCode;

    function GetId: Integer;
    property Id: Integer read GetId;

    function GetCategoryId: Integer;
    property CategoryId: Integer read GetCategoryId;

    function GetVisible: Boolean;
    procedure SetVisible(AValue: Boolean);
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  IMarkPointSMLInternal = interface(IMarkSMLInternal)
  ['{8032428E-F038-46C0-A060-47EDDF3A4852}']
    function GetPicName: string;
    property PicName: string read GetPicName;
  end;

  IMarkCategorySMLInternal = interface
    ['{08E68E71-FD75-4E7F-953F-485F034525AA}']
    function GetDbCode: Integer;
    property DbCode: Integer read GetDbCode;

    function GetId: integer; stdcall;
    property Id: integer read GetId;
  end;

  IMarkTemplateSMLInternal = interface
    ['{17BBDDCD-3CBC-4872-91C4-E58AEBCF595E}']
    function GetCategoryId: Integer;
    property CategoryId: Integer read GetCategoryId;
  end;

  IMarksDbSmlInternal = interface
    ['{54D17191-A56C-4951-8838-7E492906213A}']
    function SaveMarks2File: boolean;
    procedure LoadMarksFromFile;
  end;

implementation

end.
