const
  INVALID_SOCKET = TSocket(NOT(0));

  SOCKET_ERROR=-1;

  EPROTONOSUPPORT=-1;
  ECONNRESET=-2;

  NI_MAXHOST	   = 1025;
  NI_MAXSERV	   = 32;

  cLocalHostStr : AnsiString = 'localhost';
  cLocalhost : AnsiString = '127.0.0.1';
  cAnyHost : AnsiString = '0.0.0.0';
  cBroadcast : AnsiString = '255.255.255.255';
  c6Localhost : AnsiString = '::1';
  c6AnyHost : AnsiString = '::0';
  c6Broadcast : AnsiString = 'ffff::1';
  cAnyPort : AnsiString = '0';

(*
function __error: PInteger; cdecl
{$IFDEF MACOSX}
external libc name _PU + '__error';
{$ENDIF}
function errno: Integer;
begin
  Result := __error()^;
end;
*)

function WSA_SetVarSin(var Sin: TSockAddr; IP, Port: AnsiString; Family, SockProtocol, SockType: integer; PreferIP4: Boolean): integer;
  var
    r: integer;
    Hints1, Hints2: AddrInfo;
    Sin1, Sin2: TSockAddr;
    TwoPass: boolean;

  function GetAddr(const IP, port: AnsiString; Hints: AddrInfo; var Sin: TSockAddr): integer;
    var
      Addr: PAddrInfo;
    begin
    //-System.Writeln('GetAddr');
    Addr := nil;
    try
      FillChar(Sin, Sizeof(Sin), 0);
      if Hints.ai_socktype = SOCK_RAW then
        begin
        //-System.Writeln('SOCK_RAW');
        Hints.ai_socktype := 0;
        Hints.ai_protocol := 0;
        Result := GetAddrInfo(PAnsiChar(IP), nil, Hints, Addr);
        end
      else
        begin
        //-System.Writeln('SOCK family ',Hints.ai_family);
        if (IP=cAnyHost) or (IP=c6AnyHost) then
          begin
          Hints.ai_flags := AI_PASSIVE;
          Result := GetAddrInfo(nil, PAnsiChar(Port), Hints, Addr);
          end
        else
          begin
          if (IP=cLocalhost) or (IP=c6Localhost) then
            Result := GetAddrInfo(nil, PAnsiChar(Port), Hints, Addr)
          else
            Result := GetAddrInfo(PAnsiChar(IP), PAnsiChar(Port), Hints, Addr);
          end;
        end;
      //-if assigned(Addr) then
      //-  System.Writeln('SOCK Addr assigned.')
      //-else
      //-  System.Writeln('SOCK Addr NOT assigned!');
      if Result = 0 then
        if (Addr <> nil) then
          begin
          Move(Addr^.ai_addr^, Sin, Addr^.ai_addrlen);
          //-System.Writeln('SOCK Copy (',Sin.sa_family,',',Addr^.ai_addrlen,')');
          end;
    finally
      if Assigned(Addr) then
        FreeAddrInfo(Addr^);
      //-System.Writeln('GetAddr Result = ',Result);
      end;
    end;

  begin
  //-System.Writeln('SetVarSin (',IP,',',Port,')');
  //-try
    // Result := 0;
    FillChar(Sin, Sizeof(Sin), 0);
    FillChar(Hints1, Sizeof(Hints1), 0);
    FillChar(Hints2, Sizeof(Hints2), 0);
    TwoPass := False;
    if Family = AF_UNSPEC then
      begin
      if PreferIP4 then
        begin
        Hints1.ai_family := AF_INET;
        Hints2.ai_family := AF_INET6;
        TwoPass := True;
        end
      else
        begin
        Hints2.ai_family := AF_INET;
        Hints1.ai_family := AF_INET6;
        TwoPass := True;
        end;
      end
    else
      Hints1.ai_family := Family;

    Hints1.ai_socktype := SockType;
    Hints1.ai_protocol := SockProtocol;
    Hints2.ai_socktype := Hints1.ai_socktype;
    Hints2.ai_protocol := Hints1.ai_protocol;

    r := GetAddr(IP, Port, Hints1, Sin1);
    Result := r;
    if r = 0 then
      sin := sin1
    else if TwoPass then
      begin
      r := GetAddr(IP, Port, Hints2, Sin2);
      Result := r;
      if r = 0 then
        sin := sin2
      else
        begin
        r := GetAddr(IP, Port, Hints1, Sin1);
        Result := r;
        if r = 0 then
          sin := sin1;
        end;
      end;
  //-finally
  //-  System.Writeln('SetVarSin (',IP,',',Port,') Result = ',Result);
  //-  end;
  end;

function WSA_GetSinIP(Sin: TSockAddr): AnsiString;
  var
    host, serv: AnsiString;
    hostlen, servlen: integer;
    r: integer;
  begin
  Result := '';
  hostlen := NI_MAXHOST;
  servlen := NI_MAXSERV;
  setlength(host, hostlen);
  setlength(serv, servlen);
  r := GetNameInfo(sin, sin.sa_len,
                   PAnsiChar(host), hostlen,
                   PAnsiChar(serv), servlen,
                   NI_NUMERICHOST + NI_NUMERICSERV);
  if r = 0 then
    Result := PAnsiChar(host);
  end;

function WSA_GetSinPort(Sin: TSockAddr): Integer;
  begin
  if (Sin.sa_family = AF_INET6) then
    Result := ntohs(PSockAddr_In6(@Sin)^.sin6_port)
  else
    Result := ntohs(PSockAddr_In(@Sin)^.sin_port);
  end;

function TRtcSocket.Sock_CheckError: boolean;
  begin
  //-System.Writeln('CkechError ',FErrCode);
  Result := (FErrCode <> 0); // and (FErrCode <> EINPROGRESS) and (FErrCode <> EWOULDBLOCK);
  //-System.Writeln('CheckError Result = ', Result);
  end;

procedure TRtcSocket.Sock_CheckLastErrorDesc;
  begin
  //-System.Writeln('CheckLastErrorDesc ',FErrCode);
  if FErrCode=0 then
    FErr:=''
  else
    FErr := String(gai_strerror(FErrCode));
  //-System.Writeln('CheckLastErrorDesc Result = ',FErr);
  end;

procedure TRtcSocket.Sock_CheckLastError;
  begin
  //-System.Writeln('CheckLastError');
  FErrCode:=GetLastError;
  if FErrCode=0 then
    FErr:=''
  else
    Sock_CheckLastErrorDesc;
  //-System.Writeln('CheckLastError Result = ',FErrCode);
  end;

function TRtcSocket.Sock_Err(res: Integer):boolean;
  begin
  if (res=SOCKET_ERROR) or (res<0) then
    begin
    Result:=True;
    Sock_CheckLastError;
    end
  else
    Result:=False;
  end;

procedure TRtcSocket.Sock_SetSin(var Sin: TSockAddr; const vAddr,vPort:AnsiString);
  begin
  //-System.Writeln('SetSin ('+vAddr+','+vPort+')');
  FErrCode := WSA_SetVarSin(sin, vAddr, vPort, AF_UNSPEC, IPPROTO_TCP, SOCK_STREAM, true);
  Sock_CheckLastErrorDesc;
  //-System.Writeln('SetSin Result = ',FErrCode);
  end;

procedure TRtcSocket.Sock_CreateSocket(Sin: TSockAddr);
  begin
  //-System.Writeln('CreateSocket (',Sin.sa_family,',',Sin.sa_len,')');
  FSocket := socket(Sin.sa_family, SOCK_STREAM, IPPROTO_TCP);
  if FSocket = INVALID_SOCKET then
    Sock_CheckLastError
  else
    begin
    __FD_ZERO(FFDSet);
    __FD_SET(FSocket, FFDSet);
    end;
  //-System.Writeln('CreateSocket Result = ',FErrCode);
  end;

procedure TRtcSocket.Sock_SetLinger(vEnable: Boolean; vLinger: Integer);
  var
    li: Linger;
    buf: pointer;
  begin
  //-System.Writeln('SetLinger (',vEnable,',',vLinger,')');
  if vEnable then
    li.l_onoff := 1
  else
    li.l_onoff := 0;
  li.l_linger := vLinger;
  buf := @li;
  Sock_Err(SetSockOpt(FSocket, integer(SOL_SOCKET), integer(SO_LINGER), buf, SizeOf(li)));
  //-System.Writeln('SetLinger Result = ',FErrCode);
  end;

procedure TRtcSocket.Sock_SetDelay;
  var
    optval: integer;
    buf: pointer;
  begin
  //-System.Writeln('SetDelay');
  buf := @optval;
  // NO SEND DELAY
  optval := 1;
  SetSockOpt(FSocket, SOL_SOCKET, SO_SNDLOWAT, buf, SizeOf(optval));
  // KEEP-ALIVE
  optval  := -1;
  SetSockOpt(FSocket, SOL_SOCKET, SO_KEEPALIVE, buf, SizeOf(optval));
  // REUSE ADDR.
  optval  := -1;
  SetSockOpt(FSocket, SOL_SOCKET, SO_REUSEADDR, buf, SizeOf(optval));
  // Set READ Buffer
  optval := SOCK_READ_BUFFER_SIZE;
  SetSockOpt(FSocket, SOL_SOCKET, SO_RCVBUF, buf, SizeOf(optval));
  // Set SEND Buffer
  optval := SOCK_SEND_BUFFER_SIZE;
  SetSockOpt(FSocket, SOL_SOCKET, SO_SNDBUF, buf, SizeOf(optval));
  // Do NOT generate SIGPIPE
  optval := -1;
  SetSockOpt(FSocket, SOL_SOCKET, SO_NOSIGPIPE, buf, SizeOf(optval));
  //-System.Writeln('SetDelay Result = ',FErrCode);
  end;

procedure TRtcSocket.Sock_SetTimeouts(const TOA:TRtcTimeoutsOfAPI);
  var
    optval: integer;
    buf: pointer;
  begin
  //-System.Writeln('SetTimeouts');
{$IFDEF RTC_USESETTIMEOUTS}
  if assigned(TOA) then
    begin
    buf:=@optval;
    // Set RECV_TIMEO
    if TOA.ReceiveTimeout>0 then
      begin
      optval := TOA.ReceiveTimeout*1000;
      SetSockOpt(FSocket, SOL_SOCKET, SO_RCVTIMEO, buf, SizeOf(optval));
      end;
    // Set SND_TIMEO
    if TOA.SendTimeout>0 then
      begin
      optval := TOA.SendTimeout*1000;
      SetSockOpt(FSocket, SOL_SOCKET, SO_SNDTIMEO, buf, SizeOf(optval));
      end;
    end;
{$ELSE}
  // Set RECV_TIMEO
  optval := SOCK_RECV_TIMEOUT;
  WSA_SetSockOpt(FSocket, SOL_SOCKET, SO_RCVTIMEO, buf, SizeOf(optval));
  // Set SND_TIMEO
  optval := SOCK_SEND_TIMEOUT;
  WSA_SetSockOpt(FSocket, SOL_SOCKET, SO_SNDTIMEO, buf, SizeOf(optval));
{$ENDIF}
  //-System.Writeln('SetTimeouts Result = ',FErrCode);
  end;

function TRtcSocket.Sock_Invalid: boolean;
  begin
  Result := FSocket=INVALID_SOCKET;
  //-System.Writeln('Sock_Invalid (',FSocket,')? Result = ',Result);
  end;

function TRtcSocket.Sock_GetLocalSinIP: AnsiString;
  begin
  //-System.Writeln('GetLocalSinIP');
  Result := WSA_GetSinIP(FLocalSin);
  //-System.Writeln('GetLocalSinIP Result = ',Result);
  end;

function TRtcSocket.Sock_GetLocalSinPort: AnsiString;
  begin
  //-System.Writeln('GetLocalSinPort');
  Result := Int2Str(WSA_GetSinPort(FLocalSin));
  //-System.Writeln('GetLocalSinPort Result = ',Result);
  end;

function TRtcSocket.Sock_GetRemoteSinIP: AnsiString;
  begin
  //-System.Writeln('GetRemoteSinIP');
  Result := WSA_GetSinIP(FRemoteSin);
  //-System.Writeln('GetRemoteSinIP Result = ',Result);
  end;

function TRtcSocket.Sock_GetRemoteSinPort: AnsiString;
  begin
  //-System.Writeln('GetRemoteSinPort');
  Result := Int2Str(WSA_GetSinPort(FRemoteSin));
  //-System.Writeln('GetRemoteSinPort Result = ',Result);
  end;

procedure TRtcSocket.Sock_Bind(const vAddr, vPort: AnsiString);
  var
    Sin: TSockAddr;
  begin
  //-System.Writeln('Bind');
  //-try
    Sock_SetSin(Sin,vAddr,vPort);
    if FErrCode<>0 then Exit;

    if FSocket = INVALID_SOCKET then
      begin
      Sock_CreateSocket(Sin);
      if FErrCode<>0 then Exit;
      end;

    if Sock_Err(Bind(FSocket, Sin, Sin.sa_len)) then Exit;

    FLocalSinLen:=SizeOf(FLocalSin);
    Sock_Err(GetSockName(FSocket, FLocalSin, FLocalSinLen));
  //-finally
  //-  System.Writeln('Bind (',FSocket,') Result = ',FErrCode);
  //-  end;
  end;

procedure TRtcSocket.Sock_Connect(const vAddr, vPort: AnsiString; const TOA:TRtcTimeoutsOfAPI);
  var
    Sin: TSockAddr;
  begin
  //-System.Writeln('Connect');
  //-try
    Sock_SetSin(Sin, vAddr, vPort);
    if FErrCode<>0 then Exit;

    if FSocket = INVALID_SOCKET then
      begin
      Sock_CreateSocket(Sin);
      if FErrCode<>0 then Exit;
      end;

    if Sock_Err(Posix.SysSocket.Connect(FSocket, Sin, Sin.sa_len)) then Exit;

    FLocalSinLen:=SizeOf(FLocalSin);
    if Sock_Err(GetSockName(FSocket, FLocalSin, FLocalSinLen)) then Exit;

    FRemoteSinLen:=SizeOf(FRemoteSin);
    if Sock_Err(GetPeerName(FSocket, FRemoteSin, FRemoteSinLen)) then Exit;

    Sock_SetDelay;
    Sock_SetTimeouts(TOA);
    Sock_SetLinger(False,0);
  //-finally
  //-  System.Writeln('Connect (',FSocket,') Result = ',FErrCode);
  //-  end;
  //Log('Socket '+IntToStr(FSocket)+' OPEN!');
  end;

procedure TRtcSocket.Sock_Listen(const TOA:TRtcTimeoutsOfAPI);
  var
    blog:integer;
  begin
  //-System.Writeln('Listen');
  //-try
    blog:=LISTEN_BACKLOG;
    if blog>SOMAXCONN then blog:=SOMAXCONN;

    if Sock_Err(Posix.SysSocket.Listen(FSocket, blog)) then Exit;

    FLocalSinLen:=SizeOf(FLocalSin);
    if Sock_Err(GetSockName(FSocket, FLocalSin, FLocalSinLen)) then Exit;

    Sock_SetDelay;
    Sock_SetTimeouts(TOA);
    Sock_SetLinger(False,0);
  //-finally
  //-  System.Writeln('Listen (',FSocket,') Result = ',FErrCode);
  //-  end;
  //Log('Socket '+IntToStr(FSocket)+' LISTEN!');
  end;

function TRtcSocket.Sock_Accept: TSocket;
  begin
  //-System.Writeln('Accept');
  //-try
    FRemoteSinLen:=SizeOf(FRemoteSin);
    Result := Accept(FSocket, FRemoteSin, FRemoteSinLen);
    if Result=INVALID_SOCKET then
      begin
      Sock_CheckLastError;
      if FErrCode=0 then
        begin
        FErrCode:=-1;
        FErr:='No socket waiting';
        end;
      end;
  //-finally
  //-  System.Writeln('Accept Result = ',FErrCode);
  //-  end;
  end;

procedure TRtcSocket.Sock_SetSocket(sid: TSocket);
  begin
  //-System.Writeln('SetSocket');
  //-try
    FSocket := sid;
    __FD_ZERO(FFDSet);
    __FD_SET(FSocket, FFDSet);

    FLocalSinLen:=SizeOf(FLocalSin);
    if Sock_Err(GetSockName(FSocket, FLocalSin, FLocalSinLen)) then Exit;

    FRemoteSinLen:=SizeOf(FRemoteSin);
    if Sock_Err(GetPeerName(FSocket, FRemoteSin, FRemoteSinLen)) then Exit;

    Sock_SetLinger(False,0);
  //-finally
  //-  System.Writeln('SetSocket (',FSocket,') Result = ',FErrCode);
  //-  end;
  //Log('Socket '+IntToStr(FSocket)+' ACCEPT!');
  end;

procedure TRtcSocket.Sock_Close;
  begin
  //-System.Writeln('Close ',FSocket);
  //-try
    if FSocket <> INVALID_SOCKET then
      begin
      //Log('Socket '+IntToStr(FSocket)+' CLOSE.');
      Shutdown(FSocket,SHUT_WR);
      __close(FSocket);
      end;
    FSocket := INVALID_SOCKET;
  //-finally
  //-  System.Writeln('SetSocket Result = ',FErrCode);
  //-  end;
  end;

function TRtcSocket.Sock_CanRead(vTimeout: integer): boolean;
  var
    PVal: PTimeVal;
    TVal: TimeVal;
    x: Integer;
    FDSet: TFDSet;
  begin
  //-System.Writeln('CanRead ',FSocket);
  //-try
    TVal.tv_usec := (vTimeout mod 1000) * 1000;
    TVal.tv_sec := vTimeout div 1000;
    PVal := @TVal;
    if vTimeout = -1 then PVal := nil;

    FDSet := FFdSet;
    x := Select(FSocket + 1, @FDSet, nil, nil, PVal);
    if Sock_Err(x) then
      Result:=False
    else
      Result:= x > 0;
  //-finally
  //-  System.Writeln('CanRead (',x,') Result = ',Result);
  //-  end;
  end;

function TRtcSocket.Sock_CanWrite(vTimeout: integer): boolean;
  var
    PVal: PTimeVal;
    TVal: TimeVal;
    x: Integer;
    FDSet: TFDSet;
  begin
  //-System.Writeln('CanWrite ',FSocket);
  //-try
    TVal.tv_usec := (vTimeout mod 1000) * 1000;
    TVal.tv_sec := vTimeout div 1000;
    PVal := @TVal;
    if vTimeout = -1 then PVal := nil;

    FDSet := FFdSet;
    x := Select(FSocket + 1, nil, @FDSet, nil, PVal);
    if Sock_Err(x) then
      Result:=False
    else
      Result:= x > 0;
  //-finally
  //-  System.Writeln('CanWrite (',x,') Result = ',Result);
  //-  end;
  end;

function TRtcSocket.Sock_WaitingData: integer;
  // var x: Integer;
  begin
  //-System.Writeln('WaitingData ',FSocket);
  //-try
(* This function is a temporary work-around until "ioctl" is added ... *)
    if not Sock_CanRead(1) then
      Result:=0
    else
      begin
      Result := Recv(FSocket, FTempBuffer[1], length(FTempBuffer), MSG_PEEK);
      if Result = 0 then
        begin
        FErrCode := ECONNRESET;
        Sock_CheckLastErrorDesc;
        end
      else if Result = SOCKET_ERROR then
        Sock_CheckLastError;
      end;
//- {$MESSAGE WARN 'Ioctl missing! Using recv() with MSG_PEEK intead.'}
(* Result := 0;
   if not Sock_Err(Ioctl(FSocket, FIONREAD, x)) then
     Result := x; *)
  //-finally
  //-  System.Writeln('WaitingData Result = ',Result);
  //-  end;
  end;

function TRtcSocket.Sock_RecvBuffer(var Buffer; Len: Integer): Integer;
  begin
  //-System.Writeln('RecvBuffer ',FSocket);
  //-try
    Result := Recv(FSocket, Buffer, Len, 0); // MSG_WAITALL);
    if Result = 0 then
      begin
      FErrCode := ECONNRESET;
      Sock_CheckLastErrorDesc;
      end
    else if Result = SOCKET_ERROR then
      Sock_CheckLastError;
  //-finally
  //-  System.Writeln('RecvBuffer Result = ',Result);
  //-  end;
  end;

function TRtcSocket.Sock_SendBuffer(var Buffer; Len: Integer): Integer;
  begin
  //-System.Writeln('SendBuffer ',FSocket);
  //-try
    if Len>SOCK_MAX_SEND_SIZE then
      Len:=SOCK_MAX_SEND_SIZE;
    Result := Send(FSocket, Buffer, Len, 0);
    if Sock_Err(Result) then
      Result:=-1;
  //-finally
  //-  System.Writeln('SendBuffer Result = ',Result);
  //-  end;
  end;

procedure TRtcSocket.Sock_ResetError;
  begin
  FErrCode:=0; FErr:='';
  end;
