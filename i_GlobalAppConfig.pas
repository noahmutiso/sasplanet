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

unit i_GlobalAppConfig;

interface

uses
  i_ConfigDataElement;

type
  IGlobalAppConfig = interface(IConfigDataElement)
    ['{3DBA929F-BD4C-46A3-A64B-F61786D41FED}']
    // ���������� ������ � ����
    function GetIsShowIconInTray: Boolean;
    procedure SetIsShowIconInTray(AValue: Boolean);
    property IsShowIconInTray: Boolean read GetIsShowIconInTray write SetIsShowIconInTray;

    // �������� �� ���� ������ ��� ������ ���������
    function GetIsSendStatistic: Boolean;
    procedure SetIsSendStatistic(AValue: Boolean);
    property IsSendStatistic: Boolean read GetIsSendStatistic write SetIsSendStatistic;

    // �������� ���������� ���������� � ������������������
    function GetIsShowDebugInfo: Boolean;
    procedure SetIsShowDebugInfo(AValue: Boolean);
    property IsShowDebugInfo: Boolean read GetIsShowDebugInfo write SetIsShowDebugInfo;
  end;

implementation

end.
