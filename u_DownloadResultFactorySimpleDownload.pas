unit u_DownloadResultFactorySimpleDownload;

interface

uses
  Types,
  i_DownloadResult,
  i_DownloadResultFactory;

type
  TDownloadResultFactorySimpleDownload = class(TInterfacedObject, IDownloadResultFactory)
  private
    FUrl: string;
    FRequestHead: string;
  protected
    function BuildCanceled: IDownloadResultCanceled;
    function BuildOk(
      AStatusCode: Cardinal;
      ARawResponseHeader: string;
      AContentType: string;
      ASize: Integer;
      ABuffer: Pointer
    ): IDownloadResultOk;
    function BuildUnexpectedProxyAuth: IDownloadResultProxyError;
    function BuildBadProxyAuth: IDownloadResultProxyError;
    function BuildNoConnetctToServerByErrorCode(AErrorCode: DWORD): IDownloadResultNoConnetctToServer;
    function BuildLoadErrorByStatusCode(AStatusCode: DWORD): IDownloadResultError;
    function BuildLoadErrorByUnknownStatusCode(AStatusCode: DWORD): IDownloadResultError;
    function BuildLoadErrorByErrorCode(AErrorCode: DWORD): IDownloadResultError;
    function BuildBadContentType(AContentType, ARawResponseHeader: string): IDownloadResultBadContentType;
    function BuildBanned(ARawResponseHeader: string): IDownloadResultBanned;
    function BuildDataNotExists(AReasonText, ARawResponseHeader: string): IDownloadResultDataNotExists;
    function BuildDataNotExistsByStatusCode(ARawResponseHeader: string; AStatusCode: DWORD): IDownloadResultDataNotExists;
    function BuildDataNotExistsZeroSize(ARawResponseHeader: string): IDownloadResultDataNotExists;
    function BuildNotNecessary(AReasonText, ARawResponseHeader: string): IDownloadResultNotNecessary;
  public
    constructor Create(
      AUrl: string;
      ARequestHead: string
    );
  end;

implementation

uses
  u_DownloadResult;

{ TDownloadResultFactorySimpleDownload }

constructor TDownloadResultFactorySimpleDownload.Create(AUrl,
  ARequestHead: string);
begin
  FUrl := AUrl;
  FRequestHead := ARequestHead;
end;

function TDownloadResultFactorySimpleDownload.BuildBadContentType(
  AContentType, ARawResponseHeader: string): IDownloadResultBadContentType;
begin
  Result := TDownloadResultBadContentType.Create(FUrl, FRequestHead, AContentType, ARawResponseHeader);
end;

function TDownloadResultFactorySimpleDownload.BuildBadProxyAuth: IDownloadResultProxyError;
begin
  Result := TDownloadResultBadProxyAuth.Create(FUrl, FRequestHead);
end;

function TDownloadResultFactorySimpleDownload.BuildBanned(ARawResponseHeader: string): IDownloadResultBanned;
begin
  Result := TDownloadResultBanned.Create(FUrl, FRequestHead, ARawResponseHeader);
end;

function TDownloadResultFactorySimpleDownload.BuildCanceled: IDownloadResultCanceled;
begin
  Result := TDownloadResultCanceled.Create(FUrl, FRequestHead);
end;

function TDownloadResultFactorySimpleDownload.BuildDataNotExists(
  AReasonText, ARawResponseHeader: string): IDownloadResultDataNotExists;
begin
  Result := TDownloadResultDataNotExists.Create(FUrl, FRequestHead, AReasonText, ARawResponseHeader);
end;

function TDownloadResultFactorySimpleDownload.BuildDataNotExistsByStatusCode(
  ARawResponseHeader: string;
  AStatusCode: DWORD): IDownloadResultDataNotExists;
begin
  Result := TDownloadResultDataNotExistsByStatusCode.Create(FUrl, FRequestHead, ARawResponseHeader, AStatusCode);
end;

function TDownloadResultFactorySimpleDownload.BuildDataNotExistsZeroSize(ARawResponseHeader: string): IDownloadResultDataNotExists;
begin
  Result := TDownloadResultDataNotExistsZeroSize.Create(FUrl, FRequestHead, ARawResponseHeader);
end;

function TDownloadResultFactorySimpleDownload.BuildLoadErrorByErrorCode(
  AErrorCode: DWORD): IDownloadResultError;
begin
  Result := TDownloadResultLoadErrorByErrorCode.Create(FUrl, FRequestHead, AErrorCode);
end;

function TDownloadResultFactorySimpleDownload.BuildLoadErrorByStatusCode(
  AStatusCode: DWORD): IDownloadResultError;
begin
  Result := TDownloadResultLoadErrorByStatusCode.Create(FUrl, FRequestHead, AStatusCode);
end;

function TDownloadResultFactorySimpleDownload.BuildLoadErrorByUnknownStatusCode(
  AStatusCode: DWORD): IDownloadResultError;
begin
  Result := TDownloadResultLoadErrorByUnknownStatusCode.Create(FUrl, FRequestHead, AStatusCode);
end;

function TDownloadResultFactorySimpleDownload.BuildNoConnetctToServerByErrorCode(
  AErrorCode: DWORD): IDownloadResultNoConnetctToServer;
begin
  Result := TDownloadResultNoConnetctToServerByErrorCode.Create(FUrl, FRequestHead, AErrorCode);
end;

function TDownloadResultFactorySimpleDownload.BuildNotNecessary(
  AReasonText, ARawResponseHeader: string): IDownloadResultNotNecessary;
begin
  Result := TDownloadResultNotNecessary.Create(FUrl, FRequestHead, AReasonText, ARawResponseHeader);
end;

function TDownloadResultFactorySimpleDownload.BuildOk(
  AStatusCode: Cardinal;
  ARawResponseHeader, AContentType: string;
  ASize: Integer;
  ABuffer: Pointer
): IDownloadResultOk;
begin
  Result := TDownloadResultOk.Create(FUrl, FRequestHead, AStatusCode, ARawResponseHeader, AContentType, ASize, ABuffer);
end;

function TDownloadResultFactorySimpleDownload.BuildUnexpectedProxyAuth: IDownloadResultProxyError;
begin
  Result := TDownloadResultUnexpectedProxyAuth.Create(FUrl, FRequestHead);
end;

end.
