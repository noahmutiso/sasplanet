unit i_ITileStorageType;

interface

uses
  i_IConfigDataElement,
  i_ITileStorageTypeInfo,
  i_ITileStorage;

type
  ITileStorageType = interface(IConfigDataElement)
    ['{EBB122FB-5382-49CA-A265-3BEA89694B0E}']
    function GetInfo: ITileStorageTypeInfo;
    function BuildStorage(AName: string): ITileStorage;
    function GetCaption: string;
  end;

implementation

end.
