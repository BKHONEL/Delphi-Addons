{
  "HTTP Socket Server Provider"
   - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br>)

  Using a TCP/IP Socket Server Provider to implement a HTTP Server provider.

  @exclude
}
unit rtcSocketHttpSrvProv;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils,

  rtcLog,
  rtcInfo,
  rtcConn,
  rtcConnProv,

  rtcPlugins,
  rtcFastStrings,

  rtcSocketSrvProv;

type
  TRtcSocketHttpServerProvider = class(TRtcSocketServerProvider)
  private
    FOnInvalidRequest:TRtcBasicEvent;

    FMaxHeaderSize:integer;
    FMaxRequestSize:integer;

    FRequest:TRtcServerRequest;
    FResponse:TRtcServerResponse;

    FRequestBuffer:TRtcHugeString;

    FRequestWaiting:boolean; // will be set when request is waiting to be read.

    FChunked:boolean;
    FChunkState:byte;

    FWantManualRead:boolean; // expecting manual read

    FRequestLine:boolean; // request line received
    InBuffer:AnsiString; // data received, including HTTP header (header will be stripped when read)
    FHaveRequest:boolean; // request header accepted, receiving request data.
    LenToRead:int64; // number of bytes left to read from last Request

    LenToWrite:int64; // number of bytes to write out using inherited Write()
    LenToSend:int64; // number of bytes left to send out (DataOut event)
    FHeaderOut:boolean;
    FFixupRequest: TRtcServerRequestFixup;

    procedure ClearRequest;

  protected

    procedure InternalRead(FromDataReceived:boolean); virtual;

    function GetCryptProtocol:TRtcCryptPluginProtocol; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure TriggerConnect; override;
    procedure TriggerDisconnect; override;
    procedure TriggerDataReceived; override;
    procedure TriggerDataSent; override;
    procedure TriggerDataOut; override;

    procedure TriggerInvalidRequest; virtual;
    procedure SetTriggerInvalidRequest(Event:TRtcBasicEvent);

    procedure WriteHeader(SendNow:boolean=True); overload;
    procedure WriteHeader(const Header_Text:AnsiString; SendNow:boolean=True); overload;

    procedure Write(const ResultData:AnsiString; SendNow:boolean=True); override;

    // 1. On DataReceived, read client request info using this:
    function Read:AnsiString; override;

    property Request:TRtcServerRequest read FRequest write FRequest;
    property Response:TRtcServerResponse read FResponse write FResponse;

    property MaxRequestSize:integer read FMaxRequestSize write FMaxRequestSize;
    property MaxHeaderSize:integer read FMaxHeaderSize write FMaxHeaderSize;

    property FixupRequest:TRtcServerRequestFixup read FFixupRequest write FFixupRequest;
    end;

implementation

const
  CRLF=AnsiString(#13#10);
  END_MARK=AnsiString(#13#10#13#10);

{ TRtcSocketHttpServerProvider }

constructor TRtcSocketHttpServerProvider.Create;
  begin
  inherited;
  FRequestBuffer:=TRtcHugeString.Create;

  InBuffer:='';
  LenToWrite:=0;
  LenToSend:=0;
  FHeaderOut:=False;
  FHaveRequest:=False;
  FRequestLine:=False;
  FRequest:=nil;
  FResponse:=nil;
  FChunked:=False;
  FChunkState:=0;
  FFixupRequest:=nil;
  end;

destructor TRtcSocketHttpServerProvider.Destroy;
  begin
  try
    FreeAndNil(FRequestBuffer);

    InBuffer:='';
    LenToWrite:=0;
    LenToSend:=0;
    FRequestLine:=False;
    FHaveRequest:=False;
    FHeaderOut:=False;

    inherited;
  except
    on E:Exception do
      begin
      if LOG_AV_ERRORS then
        Log('TRtcSocketHttpServerProvider.Destroy',E,'ERROR');
      raise;
      end;
    end;
  end;

procedure TRtcSocketHttpServerProvider.SetTriggerInvalidRequest(Event: TRtcBasicEvent);
  begin
  FOnInvalidRequest:=Event;
  end;

procedure TRtcSocketHttpServerProvider.TriggerInvalidRequest;
  begin
  if assigned(FOnInvalidRequest) then
    FOnInvalidRequest;
  end;

procedure TRtcSocketHttpServerProvider.ClearRequest;
  begin
  FRequestBuffer.Clear;

  FHaveRequest:=False;
  FRequestLine:=False;
  FRequest.Clear;
  FResponse.Clear;
  LenToRead:=0;
  end;

procedure TRtcSocketHttpServerProvider.TriggerConnect;
  begin
  inherited;
  NeedMoreData;
  end;

procedure TRtcSocketHttpServerProvider.TriggerDisconnect;
  begin
  inherited;
  FRequestBuffer.Clear;

  InBuffer:='';
  LenToWrite:=0;
  LenToSend:=0;
  FHeaderOut:=False;
  FRequestLine:=False;
  FHaveRequest:=False;

  ClearRequest;
  end;

procedure TRtcSocketHttpServerProvider.TriggerDataReceived;
  var
    s,
    StatusLine,
    HeadStr:AnsiString;
    HeadLen,
    MyPos:integer;

  procedure RequestError;
    begin
    FRequestLine:=False;
    FHaveRequest:=False;

    TriggerInvalidRequest;
    end;

  begin
  if Request.Complete and not Response.Done then
    begin
    if assigned(CryptPlugin) and (InBuffer='') then
      InBuffer:=InBuffer + inherited Read;
    FRequestWaiting:=True;
    end
  else if FHaveRequest and Request.ManualRead then
    begin
    FRequestWaiting:=False;
    FWantManualRead:=True;
    // We have request headers, using manual read ...
    inherited TriggerDataReceived;
    end
  else
    begin
    FRequestWaiting:=False;
    FWantManualRead:=False;
    // Read String from buffer
    InBuffer:=InBuffer + inherited Read;

    while InBuffer<>'' do
      begin

      // Prepare Request headers
      if not FHaveRequest then // Don't have the header yet ...
        begin
        if not FRequestLine then
          begin
          MyPos:=PosEx2(CRLF,InBuffer);
          if (MaxRequestSize>0) and
             ( (MyPos>MaxRequestSize+1) or
               ((MyPos<=0) and (length(InBuffer)>MaxRequestSize+length(CRLF))) ) then
            begin
            ClearRequest;
            Request.FileName:=InBuffer;
            RequestError;
            Exit;
            end
          else if (MyPos>0) then
            begin
            ClearRequest;
            StatusLine:=Copy(InBuffer,1,MyPos-1);
            Delete(InBuffer,1,MyPos+length(CRLF)-1);

            MyPos:=PosEx2(' HTTP/', Upper_Case(StatusLine));
            if MyPos<=0 then
              MyPos:=PosEx2(' HTTPS/', Upper_Case(StatusLine));

            if MyPos<=0 then
              begin
              Request.FileName:=StatusLine;
              RequestError;
              Exit;
              end
            else
              begin
              Request.Started:=True;
              Request.Active:=True;

              // Request Method
              MyPos:=PosEx(' ',StatusLine);
              if MyPos<=0 then
                begin
                Request.FileName:=StatusLine;
                RequestError;
                Exit;
                end;

              Request.Method:=Trim(Copy(StatusLine,1,MyPos-1));
              Delete(StatusLine,1,MyPos);

              // Request FileName
              MyPos:=PosEx(' ',StatusLine);
              if MyPos<=0 then
                begin
                Request.FileName:=StatusLine;
                RequestError;
                Exit;
                end;

              Request.FileName:=Copy(StatusLine,1,MyPos-1);
              Delete(StatusLine,1,MyPos);

              // Request HTTP type
              MyPos:=PosEx('/',StatusLine);
              if MyPos<=0 then
                begin
                RequestError;
                Exit;
                end;

              if Copy(StatusLine,MyPos+1,3)='1.0' then
                Request.Close:=True;

              MyPos:=PosEx('?',Request.FileName);
              if MyPos>0 then
                begin
                Request.Query.Text:=Copy(Request.FileName,MyPos+1,length(Request.FileName)-MyPos);
                Request.FileName:=Copy(Request.FileName,1,MyPos-1);
                end
              else
                Request.Query.Clear;

              FRequestLine:=True;
              end;
            end;
          end;

        if FRequestLine then
          begin
          // See if we can get the whole header ...
          HeadLen:=PosEx2(CRLF, InBuffer);
          if HeadLen<>1 then
            HeadLen:=PosEx2(END_MARK, InBuffer);

          if HeadLen=1 then
            begin
            Delete(InBuffer,1,2);
            FHaveRequest:=True;

            FixupRequest.Fixup(Request);
            end
          else if (MaxHeaderSize>0) and
             ( (HeadLen>MaxHeaderSize) or
               ((HeadLen<=0) and (length(InBuffer)>MaxHeaderSize+length(END_MARK))) ) then
            begin
            RequestError;
            Exit;
            end
          else if HeadLen>0 then
            begin
            // Separate header from the body
            HeadStr:=Copy(InBuffer, 1, HeadLen+length(END_MARK)-1);
            Delete(InBuffer,1,HeadLen+length(END_MARK)-1);

            FHaveRequest:=True;

            // Scan for all header attributes ...
            MyPos:=Pos(CRLF, HeadStr);
            while (MyPos>1) do // at least 1 character inside line
              begin
              StatusLine:=Copy(HeadStr,1,MyPos-1);
              Delete(HeadStr,1,MyPos+Length(CRLF)-1);

              MyPos:=PosEx(':',StatusLine);
              if MyPos>0 then
                begin
                s:=Trim(Copy(StatusLine,1,MyPos-1));
                Delete(StatusLine,1,MyPos);
                StatusLine:=Trim(StatusLine);
                Request.Value[s]:=StatusLine;
                end;

              MyPos:=Pos(CRLF, HeadStr);
              end;

            if Request.ValueCS['CONTENT-LENGTH']<>'' then
              LenToRead:=Request.ContentLength;

            s:=Request.ValueCS['CONNECTION'];
            if s<>'' then
              begin
              s:=Upper_Case(s);
              if s='CLOSE' then
                Request.Close:=True
              else if s='KEEP-ALIVE' then
                Request.Close:=False;
              end;

            FChunked:=False;
            s:=Request.ValueCS['TRANSFER-ENCODING'];
            if s<>'' then
              begin
              s:=Upper_Case(s);
              if s='CHUNKED' then
                begin
                FChunked:=True;
                FChunkState:=0;
                end;
              end;

            s:=Request.ContentType;
            if s<>'' then
              begin
              if Upper_Case(Copy(s,1,19))='MULTIPART/FORM-DATA' then
                begin
                MyPos:=PosEx2('BOUNDARY=',Upper_Case(s));
                if MyPos>0 then
                  // Get MULTIPART Boundary (Params.Delimiter)
                  begin
                  Request.Params.Delimiter:= Copy(s, MyPos+9, length(s)-MyPos-8);

                  if (Copy(Request.Params.Delimiter,1,1)='"') and
                     (Copy(Request.Params.Delimiter,length(Request.Params.Delimiter),1)='"') then
                    begin
                    Request.Params.Delimiter:=
                       Copy(Request.Params.Delimiter, 2, length(Request.Params.Delimiter)-2);
                    end;
                  end;
                end;
              end;

            FixupRequest.Fixup(Request);

            StatusLine:='';
            HeadStr:='';
            end;
          end;
        end;

      if FHaveRequest then // Processing a request ...
        begin
        InternalRead(True);
        if Request.Complete and not Response.Done then
          begin
          FRequestWaiting:=InBuffer<>'';
          Exit; // need to wait for the request to be processed, before we can go to the next one.
          end;
        end
      else
        begin
        NeedMoreData;
        Exit; // Failing to fetch a header will break the loop.
        end;
      end;
    if not Request.Complete then NeedMoreData;
    end;
  end;

procedure TRtcSocketHttpServerProvider.InternalRead(FromDataReceived:boolean);
  var
    StatusLine:AnsiString;
    MyPos:integer;

  function HexToInt(const s:AnsiString):integer;
    var
      i,len:integer;
      c:AnsiChar;
    begin
    Result:=0;
    len:=length(s);
    i:=1;
    while len>0 do
      begin
      c:=s[len];
      if c in ['1'..'9'] then
        Result:=Result+i*(Ord(c)-Ord('0'))
      else if s[len] in ['A'..'F'] then
        Result:=Result+i*(Ord(c)-Ord('A')+10)
      else if s[len] in ['a'..'f'] then
        Result:=Result+i*(Ord(c)-Ord('a')+10);
      i:=i*16;Dec(len);
      end;
    end;

  begin
  if FChunked then // Read data as chunks
    begin
    if (FChunkState=0) and (InBuffer<>'') then // 1.step = read chunk size
      begin
      MyPos:=Pos(CRLF,InBuffer);
      if MyPos>0 then
        begin
        StatusLine:=Trim(Copy(InBuffer,1,MyPos-1));
        Delete(InBuffer,1,MyPos+1);

        LenToRead:=HexToInt(StatusLine);

        FChunkState:=1; // ready to read data
        end;
      end;

    if (FChunkState=1) and (InBuffer<>'') then // 2.step = read chunk data
      begin
      if (LenToRead>length(InBuffer)) then // need more than we have
        begin
        Request.ContentIn:=Request.ContentIn+length(InBuffer);

        if LenToRead>0 then
          Dec(LenToRead, length(InBuffer));

        FRequestBuffer.Add(InBuffer);
        InBuffer:='';

        if FromDataReceived then
          begin
          inherited TriggerDataReceived;
          Request.Started:=False;
          end;
        end
      else
        begin
        if LenToRead>0 then
          begin
          Request.ContentIn:=Request.ContentIn+LenToRead;

          FRequestBuffer.Add(Copy(InBuffer,1,LenToRead));

          Delete(InBuffer,1,LenToRead);
          LenToRead:=0;
          FChunkState:=2; // this is not the last chunk, ready to read CRLF
          end
        else
          FChunkState:=3; // this was last chunk, ready to read CRLF
        end;
      end;

    if (FChunkState>=2) and (length(InBuffer)>=2) then // 3.step = close chunk
      begin
      LenToRead:=-1;
      Delete(InBuffer,1,2); // Delete CRLF

      if FChunkState=2 then // not the last chunk
        FChunkState:=0 // will continue with next chunk
      else
        begin
        Request.Complete:=True;
        FHaveRequest:=False; // get ready for next request
        FRequestLine:=False;
        end;

      if FromDataReceived then
        begin
        inherited TriggerDataReceived;
        Request.Started:=False;
        end;
      end;
    end
  else
    begin
    if LenToRead>0 then
      begin
      if LenToRead>length(InBuffer) then // need more than we have
        begin
        Request.ContentIn:=Request.ContentIn + length(InBuffer);

        FRequestBuffer.Add(InBuffer);

        Dec(LenToRead, length(InBuffer));

        InBuffer:='';
        end
      else
        begin
        Request.ContentIn:=Request.ContentIn + LenToRead;

        FRequestBuffer.Add(Copy(InBuffer,1,LenToRead));

        Delete(InBuffer,1,LenToRead);

        LenToRead:=0;
        Request.Complete:=True;
        FHaveRequest:=False; // get ready for next request
        FRequestLine:=False;
        end;
      end
    else
      begin
      Request.Complete:=True;
      FHaveRequest:=False; // get ready for next request
      FRequestLine:=False;
      end;

    if FromDataReceived then
      begin
      inherited TriggerDataReceived;
      Request.Started:=False;
      end;
    end;
  end;

procedure TRtcSocketHttpServerProvider.WriteHeader(SendNow:boolean=True);
  var
    s:AnsiString;
  begin
  if FHeaderOut then
    raise Exception.Create('Last header intercepted with new header, before data sent out.');

  if Request.Close then
    begin
    Response.ValueCS['CONNECTION']:='close';
    s:='HTTP/1.0 '+Int2Str(Response.StatusCode)+' '+Response.StatusText+CRLF+
       Response.HeaderText+CRLF;
    end
  else
    s:='HTTP/1.1 '+Int2Str(Response.StatusCode)+' '+Response.StatusText+CRLF+
       Response.HeaderText+CRLF;

  Response.Sending:=True;
  Response.Started:=True;

  if Response.SendContent and
    (Response.ValueCS['CONTENT-LENGTH']='')  then // streaming data
    begin
    LenToWrite:=-1;
    LenToSend:=-1;
    end
  else
    begin
    if not Response.SendContent then
      Response.ValueCS['CONTENT-LENGTH']:='';

    LenToWrite:=Response.ContentLength;
    LenToSend:=length(s) + Response.ContentLength;
    end;

  Response.Sent:=LenToWrite=0;

  if Response.Sent then
    TriggerLastWrite;

  FHeaderOut:=True;
  inherited Write(s, SendNow or (LenToWrite<=0));
  end;

procedure TRtcSocketHttpServerProvider.WriteHeader(const Header_Text:AnsiString; SendNow:boolean=True);
  var
    s:AnsiString;
  begin
  if FHeaderOut then
    raise Exception.Create('Last header intercepted with new header, before data sent out.');

  if Header_Text<>'' then
    begin
    Response.HeaderText:=Header_Text;
    if Request.Close then
      begin
      Response.ValueCS['CONNECTION']:='close';
      s:='HTTP/1.0 '+Int2Str(Response.StatusCode)+' '+Response.StatusText+CRLF+
         Response.HeaderText+CRLF;
      end
    else
      s:='HTTP/1.1 '+Int2Str(Response.StatusCode)+' '+Response.StatusText+CRLF+
         Response.HeaderText+CRLF;
    end
  else
    begin
    s:='';
    Request.Close:=True;
    end;

  Response.Sending:=True;
  Response.Started:=True;

  if Response.SendContent and
    (Response.ValueCS['CONTENT-LENGTH']='')  then // streaming data
    begin
    LenToWrite:=-1;
    LenToSend:=-1;
    end
  else
    begin
    if not Response.SendContent then
      Response.ValueCS['CONTENT-LENGTH']:='';

    LenToWrite:=Response.ContentLength;
    LenToSend:=length(s) + Response.ContentLength;
    end;

  Response.Sent:=LenToWrite=0;

  if Response.Sent then
    TriggerLastWrite;

  FHeaderOut:=True;
  inherited Write(s, SendNow or (LenToWrite<=0));
  end;

procedure TRtcSocketHttpServerProvider.Write(const ResultData: AnsiString; SendNow:boolean=True);
  begin
  if length(ResultData)=0 then Exit;

  if not FHeaderOut then
    raise Exception.Create('Trying to send Data without Header. Call WriteHeader before Write.');

  if LenToWrite>=0 then
    begin
    if length(ResultData)>LenToWrite then
      raise Exception.Create('Trying to send more Data out than specified in Header.');

    Dec(LenToWrite, length(ResultData));
    end;

  Response.Sent:=LenToWrite=0;
  Response.ContentOut:=Response.ContentOut + length(ResultData);

  if Response.Sent then
    TriggerLastWrite;

  inherited Write(ResultData,SendNow);
  end;

function TRtcSocketHttpServerProvider.Read: AnsiString;
  begin
  if FWantManualRead then
    begin
    FWantManualRead:=False;
    InBuffer:=InBuffer + inherited Read;
    InternalRead(False);
    if Request.Complete and not Response.Done then
      FRequestWaiting:=InBuffer<>'';
    if FRequestBuffer.Size>0 then
      begin
      Result:=FRequestBuffer.Get;
      FRequestBuffer.Clear;
      end
    else
      Result:='';
    if not Request.Complete then
      NeedMoreData;
    end
  else
    begin
    if FRequestBuffer.Size>0 then
      begin
      Result:=FRequestBuffer.Get;
      FRequestBuffer.Clear;
      end
    else
      Result:='';
    end;
  end;

procedure TRtcSocketHttpServerProvider.TriggerDataSent;
  begin
  if Response.Sending then
    begin
    if not Response.Done then
      Response.Done := LenToSend=0;

    inherited TriggerDataSent;

    if Response.Done then
      begin
      Request.Started:=False;
      Request.Active:=False;
      Response.Started:=False;
      Response.Sending:=False;
      FHeaderOut:=False;
      ClearRequest;
      if FRequestWaiting then
        TriggerDataReceived;
      end;
    end;
  end;

procedure TRtcSocketHttpServerProvider.TriggerDataOut;
  var
    nmd:boolean;
  begin
  nmd:=False;

  Response.Started:=False;
  if LenToSend>=0 then
    Dec(LenToSend, DataOut);
  if LenToSend=0 then
    nmd:=(InBuffer='') and not Request.Close;

  inherited TriggerDataOut;

  if nmd then
    NeedMoreData;
  end;

function TRtcSocketHttpServerProvider.GetCryptProtocol: TRtcCryptPluginProtocol;
  begin
  Result:=cppHttp;
  end;

end.
