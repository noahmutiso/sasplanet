unit UGSM;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,  SwinHttp,
  Dialogs, StdCtrls, CPDrv, StrUtils, t_GeoTypes, u_GlobalState, unit1, UResStrings;

type
  TToPos = procedure (LL:TExtendedPoint;zoom_:byte;draw:boolean) of object;
  TPosFromGPS = class
    FToPos:TToPos;
    CommPortDriver:TCommPortDriver;
    LAC:string;
    CellID:string;
    CC:string;
    NC:string;
    BaundRate:integer;
    Port:string;
    function GetPos:boolean;
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
    function GetCoordFromGoogle(var LL:TExtendedPoint): boolean;
    property OnToPos:TToPos read FToPos write FToPos;
  end;

implementation

function TPosFromGPS.GetCoordFromGoogle(var LL:TExtendedPoint): boolean;
var
  strA, strB, strC, strAll: string;
  sResult: string;
  ms: TMemoryStream;
  dLat, dLon: Double;
  iLat, iLon: Integer;
  i: Integer;
  b: byte;
  sTmp, sTmp2: string;
  iCntr: Integer;
  SwinHttp: TSwinHttp;
  post:string;
begin
  Result := true;
  strA := '000E00000000000000000000000000001B0000000000000000000000030000';
  strB := '0000' + CellID + '0000' + LAC;
  strC := '000000' + IntToHex(strtoint(NC), 2) + '000000' + IntToHex(strtoint(CC), 2);
  strAll := strA + strB + strC + 'FFFFFFFF00000000';
  SwinHttp:=TSwinHttp.Create(nil);
  SwinHttp.InThread:=false;
  SwinHttp.Request.Headers.Clear;
  SwinHttp.Request.Headers.Add('Content-Type: application/x-www-form-urlencoded');
  SwinHttp.Request.Headers.Add('Content-Length: '+inttostr(Length(strAll) div 2));
  SwinHttp.Request.Headers.Add('Accept: text/html, */*');

  ms := TMemoryStream.Create;
  try
    iCntr := 1; 
    for i := 1 to (Length(strAll) div 2) do begin
      b := StrToInt('0x' + Copy(strAll, iCntr, 2));
      iCntr := iCntr + 2;
      ms.Write(b, 1);
    end;
    ms.Seek(0, soFromBeginning);
    try
      ms.Position:=0;
      setLength(post,ms.Size);
      ms.Read(post[1],ms.Size);
      SwinHttp.Post('http://www.google.com/glm/mmap',post);
      SetLength(sResult,SwinHttp.Response.Content.Size);
      SwinHttp.Response.Content.ReadBuffer(sResult[1],SwinHttp.Response.Content.Size);
      if (SwinHttp.Error=0)and(Length(sResult) > 14) then begin
        sTmp := '0x';
        for i := 1 to 5 do begin
          sTmp2 := Copy(sResult, i + 6, 1);
          sTmp := sTmp + IntToHex(Ord(sTmp2[1]), 2);
        end;
        iLat := StrToInt(sTmp);
        sTmp := '0x';
        for i := 1 to 4 do begin
          sTmp2 := Copy(sResult, i + 11, 1);
          sTmp := sTmp + IntToHex(Ord(sTmp2[1]), 2); 
        end;
        iLon := StrToInt(sTmp);
        LL.y := iLat/1000000;
        LL.x := iLon/1000000;
      end
      else result:=false;
    except
      result:=false;
    end;
  finally
    SwinHttp.Free;
    ms.Free;
  end;
end;

procedure TPosFromGPS.CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer; DataSize: Cardinal);
var s:string;
    pos:integer;
    LL:TExtendedPoint;
begin
 setlength(s,DataSize);
 CopyMemory(@s[1],DataPtr,DataSize);
 pos:=posEx('+CREG:',s);
 if pos>0 then begin
   pos:=posEx(',"',s,pos+1);
   if pos>0 then begin
     LAC:=copy(s,pos+2,4);
   end;
   pos:=posEx(',"',s,pos+1);
   if pos>0 then begin
     CellID:=copy(s,pos+2,4);
   end;
 end;
 pos:=posEx('+COPS:',s);
 if pos>0 then begin
   pos:=posEx(',"',s,pos);
   if pos>0 then begin
     NC:=copy(s,pos+2,3);
     CC:=copy(s,pos+5,2);
   end;
 end;
 CommPortDriver.SendString('AT+CREG=1'+#13);
 CommPortDriver.Disconnect;
 if GetCoordFromGoogle(LL) then begin
    OnToPos(LL,GState.zoom_size,true);
 end else begin
    ShowMessage(SAS_ERR_Communication);
 end;
end;

function TPosFromGPS.GetPos:boolean;
var
    LL:TExtendedPoint;
begin
 CommPortDriver:=TCommPortDriver.Create(nil);
 CommPortDriver.PortName:=Port;
 CommPortDriver.BaudRateValue:=BaundRate;
 CommPortDriver.OnReceiveData:=CommPortDriver1ReceiveData;
 CommPortDriver.Connect;
 if CommPortDriver.Connected then begin
   if CommPortDriver.SendString('AT+CREG=2'+#13) then begin
     CommPortDriver.SendString('AT+CREG?'+#13);
     CommPortDriver.SendString('AT+COPS?'+#13);
   end;
 end else begin
   Result:=false;
 end;        
end;

end.
