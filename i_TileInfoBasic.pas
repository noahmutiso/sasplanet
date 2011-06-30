unit i_TileInfoBasic;

interface

uses
  i_MapVersionInfo,
  i_ContentTypeInfo;

type
  ITileInfoBasic = interface
    ['{7916FA97-49F1-451E-B2C1-0669B9336291}']
    function GetIsExists: Boolean;
    function GetIsExistsTNE: Boolean;
    function GetLoadDate: TDateTime;
    function GetSize: Cardinal;
    function GetVersionInfo: IMapVersionInfo;
    function GetContentType: IContentTypeInfoBasic;
  end;


implementation

end.
