{
  "Socket Handle Pool"
   - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @exclude
}
unit rtcSocketPool;

{$INCLUDE rtcDefs.inc}

interface

uses
  SysUtils,

  rtcTypes,
  memBinTree,

  rtcSyncObjs;

function rtcEnterSocket:boolean;
procedure rtcLeaveSocket;

// Get socket (need to call rtcEnterSocket before & rtcLeaveSocket after)
function rtcGetSocket(sock:RtcIntPtr):TObject;

// Check socket (no need to call rtcEnterSocket and rtcLeaveSocket)
function rtcCheckSocket(sock:RtcIntPtr):TObject;

// Store socket (thread-safe)
procedure rtcStoreSocket(obj:TObject; sock:RtcIntPtr);
// Remove socket (thread-safe)
function rtcRemoveSocket(obj:TObject):boolean;

implementation

{$IFDEF RTC_DEBUG}
uses
  rtcLog;
{$ENDIF}

var
  SockList:tBinTree;
  CSHWND:TRtcCritSec;

procedure rtcStoreSocket(obj:TObject; sock:RtcIntPtr);
  begin
  CSHWND.Acquire;
  try
    // add socket-to-object reference
    SockList.insert(RtcIntPtr(Obj), Sock);
  finally
    CSHWND.Release;
    end;
  end;

function rtcRemoveSocket(obj:TObject):boolean;
  var
    i:RtcIntPtr;
  begin
  Result:=False;
  CSHWND.Acquire;
  try
    i:=SockList.search(RtcIntPtr(Obj));
    if i<>0 then // object in the list
      begin
      SockList.remove(RtcIntPtr(Obj));
      Result:=True;
      end;
  finally
    CSHWND.Release;
    end;
  end;

function rtcEnterSocket:boolean;
  begin
  if assigned(CSHWND) then
    begin
    CSHWND.Acquire;
    Result:=True;
    end
  else
    Result:=False;
  end;

procedure rtcLeaveSocket;
  begin
  CSHWND.Release;
  end;

function rtcGetSocket(Sock:RtcIntPtr):TObject;
  var
    i:RtcIntPtr;
  begin
  i:=SockList.isearch(Sock);
  if i<>0 then
    Result:=TObject(i)
  else
    Result:=nil;
  end;

function rtcCheckSocket(Sock:RtcIntPtr):TObject;
  var
    i:RtcIntPtr;
  begin
  if not assigned(CSHWND) then
    Result:=nil
  else
    begin
    CSHWND.Acquire;
    try
      i:=SockList.isearch(Sock);
      if i<>0 then
        Result:=TObject(i)
      else
        Result:=nil;
    finally
      CSHWND.Release;
      end;
    end;
  end;

initialization
{$IFDEF RTC_DEBUG} Log('rtcSocketPool Initializing ...','DEBUG');{$ENDIF}

CSHWND:=TRtcCritSec.Create;
SockList:=tBinTree.Create(256);

{$IFDEF RTC_DEBUG} Log('rtcSocketPool Initialized.','DEBUG');{$ENDIF}
finalization
{$IFDEF RTC_DEBUG} Log('rtcSocketPool Finalizing ...','DEBUG');{$ENDIF}

FreeAndNil(SockList);
FreeAndNil(CSHWND);

{$IFDEF RTC_DEBUG} Log('rtcSocketPool Finalized.','DEBUG');{$ENDIF}
end.
