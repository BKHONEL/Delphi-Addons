{
  RealThinClient SDK: Platform-independent Synchronous Socket API class
  Copyright (c) 2009-2012 by Danijel Tkalcec (http://www.realthinclient.com)

  @exclude
}
unit rtcSynAPI;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils,
  rtcConn,
  rtcInfo,
  rtcFastStrings,
  rtcSockBase,

{$IF Defined(WINDOWS)} //Win32 and Win64
  rtcWinSock;

{$ELSEIF Defined(POSIX)} // Mac OSX
  Classes,
  Posix.Base, Posix.SysSocket, Posix.SysSelect,
  Posix.ArpaInet, Posix.NetinetIn, Posix.NetDB,
  Posix.Unistd, Posix.SysTime; // , PosixStrOpts;

type
  TSocket = integer;
  TSockAddr = sockaddr;
  TFDSet = fd_set;

{$ELSEIF Defined(DARWIN)} // iOS (iPhone + iPad)
  {$DEFINE RTC_NIX_SOCK}
  rtcNixSock;

{$ELSE} // Anything else
  {$DEFINE FPSOCK}
  Classes,
  BaseUnix, Unix, termio, sockets, netdb;

{$IFEND}

const
  LISTEN_BACKLOG:integer=128;

type
  TRtcSocket=class
  private
    FSocket: TSocket;
    NewSockID: TSocket;
    FFDSet: TFDSet;
    FErr: String;
    FErrCode: Integer;
    FLocalSin, FRemoteSin: TSockAddr;

  {$IF Defined(WINDOWS)}
    FLocalSinLen, FRemoteSinLen: integer;
  {$ELSEIF Defined(POSIX)}
    FLocalSinLen, FRemoteSinLen: socklen_t;
    FTempBuffer: AnsiString;
  {$ELSEIF Defined(RTC_NIX_SOCK)}
    FTempBuffer: AnsiString;
  {$IFEND}

    procedure Sock_SetSin(var Sin: TSockAddr; const vAddr,vPort:AnsiString);
    procedure Sock_CreateSocket(Sin: TSockAddr);
    procedure Sock_SetLinger(vEnable: Boolean; vLinger: Integer);
    procedure Sock_SetDelay;
    procedure Sock_SetTimeouts(const TOA:TRtcTimeoutsOfAPI);

    procedure Sock_Bind(const vAddr,vPort: AnsiString);
    procedure Sock_Listen(const TOA:TRtcTimeoutsOfAPI);
    procedure Sock_Connect(const vAddr,vPort: AnsiString; const TOA:TRtcTimeoutsOfAPI);

    function Sock_Accept:TSocket;
    procedure Sock_SetSocket(sid:TSocket);

    procedure Sock_Close;

    function Sock_Invalid:boolean;
    function Sock_CheckError:boolean;
    function Sock_Err(res:Integer):boolean;

    procedure Sock_ResetError;
    procedure Sock_CheckLastError;
    procedure Sock_CheckLastErrorDesc;

    function Sock_GetLocalSinIP:AnsiString;
    function Sock_GetLocalSinPort:AnsiString;
    function Sock_GetRemoteSinIP:AnsiString;
    function Sock_GetRemoteSinPort:AnsiString;

    function Sock_WaitingData:integer;
    function Sock_RecvBuffer(var Buffer; Len: Integer): Integer;
    function Sock_SendBuffer(var Buffer; Len: Integer): Integer;

    function Sock_CanRead(vTimeout:integer):boolean;
    function Sock_CanWrite(vTimeout:integer):boolean;

  public
    { Constructor }
    constructor Create;

    { Destructor }
    destructor Destroy; override;

    { Start using this socket as Server listener,
      listening on port "FPort", bound to local network addapter "FAddr".
      Leave "FAddr" empty to listen on all network addapters.
      TOA can be passed as parameter to set Timeouts on API.
      Send NIL as TOA parameter to use default timeout values.
      Returns TRUE if success, FALSE if error. }
    function Listen(const FAddr,FPort:AnsiString; const TOA:TRtcTimeoutsOfAPI):boolean;

    { Connect to address "FAddr" on port "FPort".
      TOA can be passed as parameter to set Timeouts on API.
      Send NIL as TOA parameter to use default timeout values.
      Returns TRUE if success, FALSE if error. }
    function Connect(const FAddr,FPort:AnsiString; const TOA:TRtcTimeoutsOfAPI): boolean;

    { Close socket connection.
      If it was a Listening socket, listener is closed but NOT connected clients.
      If it was a Client socket, it will be disconnected from Server.
      Returns TRUE if success, FALSE if error. }
    function Close: boolean;

    { Check if there are new client sockets waiting to be accepted.
      Returns the number of waiting sockets if there are sockets waiting,
      0 if no sockets were waiting after "vTimeout" (ms), or -1 if error. }
    function WaitingSockets(vTimeout:integer): integer;

    { After WaitingSockets has returned a positive result,
      use GetNewSocket to accept one socket and receive
      a new TRtcSocket component for the new socket.
      Returns a new TRtcSocket object if OK, or NIL if error. }
    function GetNewSocket: TRtcSocket;

    { Has to be called on a socket received from GetNewSocket
      before the new TRtcSocket component can be used.
      Returns TRUE is the socket can be used, FALSE if error. }
    function StartNewSocket: boolean;

    { Try to receive data from the other side.
      If data is available, will read as much as can be read without blocking.
      If no data is available, will wait up to "vTimeout" ms for new data.
      If no data after "vTimeout", returns TRUE and an empty string in "Str".
      If data was read, "Str" will contain the data received, result will be TRUE.
      If there was an error, "Str" will be empty and FALSE will be returned as Result. }
    function ReceiveStr(var Str: AnsiString; vTimeout:integer): boolean;

    { Try to send as much data from "Str" starting at character location "at"
      as possible without blocking. If can not read (buffer full), will wait
      up to "vTimeout" ms to be able to send at least something. If something
      was sent, will return the number of characters (bytes) sent (to buffer).
      If can not send yet but connection seems OK, will return 0.
      If connection is not working anymore, will return -1. }
    function SendStr(var Str: AnsiString; at: integer; vTimeout:integer): Integer;

    { If any of the methods of this class returns FALSE or -1,
      signaling that there was an error, GetLastErrorText will
      return a more-or-less descriptive error message (text). }
    function GetLastErrorText: String;

    { Local Address to which this socket is connected. }
    function GetLocalAddr: AnsiString;

    { Local Port to which this socket is connected. }
    function GetLocalPort: AnsiString;

    { Peer (remote) Address to which this socket is connected.
      Does NOT apply to Listening sockets (server).  }
    function GetPeerAddr: AnsiString;

    { Peer (remote) Port to which this socket is connected.
      Does NOT apply to Listening sockets (server).  }
    function GetPeerPort: AnsiString;
    end;

implementation

{$IF Defined(WINDOWS)}          {$I synsock\winapi.inc}
{$ELSEIF Defined(FPSOCK)}       {$I synsock\fpcapi.inc}
{$ELSEIF Defined(POSIX)}        {$I synsock\posapi.inc}
{$ELSEIF Defined(RTC_NIX_SOCK)} {$I synsock\nixapi.inc}
{$IFEND}

constructor TRtcSocket.Create;
  begin
  inherited;
{$IF Defined(WINDOWS)}
  LoadWinSock;
{$ELSEIF Defined(POSIX)}
  SetLength(FTempBuffer,65000);
{$ELSEIF Defined(RTC_NIX_SOCK)}
  LoadNixSock;
  SetLength(FTempBuffer,65000);
{$IFEND}
  FSocket:=INVALID_SOCKET;
  NewSockID:=FSocket;
  end;

destructor TRtcSocket.Destroy;
  begin
{$IF Defined(POSIX) or Defined(RTC_NIX_SOCK)}
  SetLength(FTempBuffer,0);
{$IFEND}
  if not Sock_Invalid then Sock_Close;
  inherited;
  end;

function TRtcSocket.Listen(const FAddr,FPort:AnsiString; const TOA:TRtcTimeoutsOfAPI): boolean;
  begin
  Result:=False;
  Sock_ResetError;

  if FAddr = '' then
    Sock_Bind('0.0.0.0',FPort)
  else
    Sock_Bind(FAddr,FPort);
  if Sock_CheckError then Exit;

  Sock_Listen(TOA);
  Result:= not Sock_CheckError;
  if not Result then
    Sock_Close;
  end;

function TRtcSocket.WaitingSockets(vTimeout:integer): integer;
  begin
  Result:=-1;
  Sock_ResetError;

  if Sock_CanRead(vTimeout) then
    Result:=1
  else if not Sock_CheckError then
    Result:=0;
  end;

function TRtcSocket.GetNewSocket: TRtcSocket;
  var
    Sck:TSocket;
  begin
  Result:=nil;
  Sock_ResetError;

  Sck:=Sock_Accept;
  if Sock_CheckError then Exit;

  Result:=TRtcSocket.Create;
  Result.NewSockID:=Sck;
  end;

function TRtcSocket.StartNewSocket: boolean;
  begin
  Sock_ResetError;

  Sock_SetSocket(NewSockID);
  Result:= not Sock_CheckError;
  end;

function TRtcSocket.Close: boolean;
  begin
  Result:=False;
  Sock_ResetError;

  if not Sock_Invalid then
    begin
    Sock_Close;
    Result:=True;
    end;
  end;

function TRtcSocket.Connect(const FAddr,FPort:AnsiString; const TOA:TRtcTimeoutsOfAPI): boolean;
  begin
  Sock_ResetError;

  Sock_Connect(FAddr,FPort,TOA);
  Result:= not Sock_CheckError;

  if not Result then Sock_Close;
  end;

function TRtcSocket.ReceiveStr(var Str: AnsiString; vTimeout:integer): boolean;
  var
    r,l: integer;
  begin
  Sock_ResetError;

  l:=Sock_WaitingData;
  if l<0 then
    begin
    Str:='';
    Result:=False;
    end
  else
    begin
    if l=0 then // nothing to read yet?
      if not Sock_CanRead(vTimeout) then // wait for new data
        begin
        Str:='';
        Result:=not Sock_CheckError;
        Exit;
        end
      else
        l:=Sock_WaitingData;

    if l>0 then
      begin
      if l>SOCK_MAX_READ_SIZE then
        l:=SOCK_MAX_READ_SIZE;
      SetLength(Str,l);
      r:=Sock_RecvBuffer(Str[1],l);
      if r<>l then // received size has to be equal to "WaitingData"
        begin
        if r>=0 then
          begin
          FErrCode:=-1;
          FErr:='Reading error';
          end;
        Str:='';
        Result:=False;
        end
      else
        Result:=not Sock_CheckError;
      end
    else // can read but nothing to read? error!
      begin
      Str:='';
      FErrCode:=-1;
      FErr:='Connection error';
      Result:=False;
      end;
    end;
  end;

function TRtcSocket.SendStr(var Str: AnsiString; at: integer; vTimeout:integer): Integer;
  begin
  Sock_ResetError;

  Result:=Sock_SendBuffer(Str[at],length(Str)-at+1);
  if Result=0 then
    if Sock_CanWrite(vTimeout) then
      begin
      Result:=Sock_SendBuffer(Str[at],length(Str)-at+1);
      if Result=0 then
        Result:=-1; // error!
      end;

  if Result>=0 then
    if Sock_CheckError then
      Result:=-1;
  end;

function TRtcSocket.GetLastErrorText: String;
  begin
  if FErrCode=0 then
    Result:=''
  else
    Result:='#'+IntToStr(FErrCode)+': '+FErr;
  end;

function TRtcSocket.GetLocalAddr: AnsiString;
  begin
  if not Sock_Invalid then
    Result:=Sock_GetLocalSinIP
  else
    Result:='';
  end;

function TRtcSocket.GetLocalPort: AnsiString;
  begin
  if not Sock_Invalid then
    Result:=Sock_GetLocalSinPort
  else
    Result:='';
  end;

function TRtcSocket.GetPeerAddr: AnsiString;
  begin
  if not Sock_Invalid then
    Result:=Sock_GetRemoteSinIP
  else
    Result:='';
  end;

function TRtcSocket.GetPeerPort: AnsiString;
  begin
  if not Sock_Invalid then
    Result:=Sock_GetRemoteSinPort
  else
    Result:='';
  end;

end.
