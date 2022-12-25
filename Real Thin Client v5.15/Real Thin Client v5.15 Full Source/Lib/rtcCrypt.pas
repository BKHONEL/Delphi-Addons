{
  @html(<b>)
  Encryption Class
  @html(</b>)
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  This unit implements the encryption class @Link(TRtcCrypt),
  which is used by @Link(TRtcClientModule) and @Link(TRtcServerModule)
  to crypt and decrypt all RTC Data when AutoEnctyption is activated.
}

unit rtcCrypt;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils,

  rtcLog,
  rtcInfo;

type
  TRtcCrypt = class(TRtcObject)
    private
      FCryptKey:AnsiString;
      FCryptCode:AnsiString;

      CErr:integer;
      CPos:integer;
      CLen:integer;
      CCode:byte;
      CValue:longint;
      CInit:boolean;

      procedure SetCryptCode(const Value: AnsiString);

    public
      constructor Create;
      destructor Destroy; override;

      procedure Kill; override;

      procedure Init;

      procedure Crypt(var s:AnsiString);
      procedure DeCrypt(var s:AnsiString);

      property Key:AnsiString read FCryptKey write SetCryptCode;
    end;

procedure Crypt(var s:AnsiString; const key:AnsiString);
procedure DeCrypt(var s:AnsiString; const key:AnsiString);

implementation

procedure Crypt(var s:AnsiString; const key:AnsiString);
  var
    crypt:TRtcCrypt;
  begin
  crypt:=TRtcCrypt.Create;
  try
    crypt.Key:=key;
    crypt.Crypt(s);
  finally
    FreeAndNil(crypt);
    end;
  end;

procedure DeCrypt(var s:AnsiString; const key:AnsiString);
  var
    crypt:TRtcCrypt;
  begin
  crypt:=TRtcCrypt.Create;
  try
    crypt.Key:=key;
    crypt.DeCrypt(s);
  finally
    FreeAndNil(crypt);
    end;
  end;

{ TRtcCrypt }

constructor TRtcCrypt.Create;
  begin
  inherited;
  FCryptKey:='';
  FCryptCode:='';
  CInit:=False;
  Init;
  end;

destructor TRtcCrypt.Destroy;
  begin
  try
    FCryptKey:='';
    FCryptCode:='';
    inherited;
  except
    on E:Exception do
      begin
      if LOG_AV_ERRORS then
        Log('TRtcCrypt.Destroy',E,'ERROR');
      raise;
      end;
    end;
  end;

procedure TRtcCrypt.Init;
  var
    a:integer;
  begin
  if CInit then Exit;

  FCryptCode := FCryptKey; // Initial encryption key
  CValue:=0;
  CLen:=length(FCryptCode);

  if CLen>0 then
    begin
    // First code = sum of all crypt bytes
    for a:=1 to CLen do
      Inc(CValue,Byte(FCryptCode[a]));
      
    if CValue>$FFFF then
      CValue:=(CValue and $FFFF)+(CValue shr 16);
    CErr:=CValue+CLen;

    CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
    if CCode=0 then
      begin
      Inc(CValue,CErr);
      CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
      end;
    CPos:=0;

    CInit:=True;
    end;
  end;

procedure TRtcCrypt.Crypt(var s: AnsiString);
  var
    a:integer;
    c,c2:byte;
  begin
  CInit:=False;
  if CLen>0 then
    begin
    for a:=1 to length(s) do
      begin
      c2:=Byte(s[a]);
      c:=c2 xor CCode; // Crypt this character

      CValue:=CValue * (1+(c2 and $F)) + (c2 and $F0); // include original character into the code

      if CPos>=CLen then
        CPos:=1
      else
        Inc(CPos);

      Inc(CValue, Byte(FCryptCode[CPos]));
      if CValue>$FFFF then
        CValue:=(CValue and $FFFF)+(CValue shr 16);

      CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
      if CCode=0 then
        begin
        Inc(CValue,CErr);
        CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
        end;
      s[a]:=AnsiChar(c);
      end;
    end;
  end;

procedure TRtcCrypt.DeCrypt(var s: AnsiString);
  var
    a:integer;
    c:byte;
  begin
  CInit:=False;
  if CLen>0 then
    begin
    for a:=1 to length(s) do
      begin
      c:=Byte(s[a]) xor CCode; // Crypt this character

      CValue:=CValue * (1+(c and $F)) + (c and $F0); // include original character into the code

      if CPos>=CLen then
        CPos:=1
      else
        Inc(CPos);

      Inc(CValue, Byte(FCryptCode[CPos]));
      if CValue>$FFFF then
        CValue:=(CValue and $FFFF)+(CValue shr 16);

      CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
      if CCode=0 then
        begin
        Inc(CValue,CErr);
        CCode:=((CValue shr 8) and $FF) xor (CValue and $FF);
        end;
      s[a]:=AnsiChar(c);
      end;
    end;
  end;

procedure TRtcCrypt.SetCryptCode(const Value: AnsiString);
  begin
  FCryptKey := Value;
  CInit:=False;
  Init;
  end;

procedure TRtcCrypt.Kill;
  begin
  Free;
  end;

end.
