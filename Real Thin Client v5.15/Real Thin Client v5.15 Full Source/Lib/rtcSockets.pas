{
  Load the appropriate low-level Socket API implementation.
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)

  @exclude
}
unit rtcSockets;

{$INCLUDE rtcDefs.inc}

interface

uses
  rtcSockBase;

var
  DefaultRtcSocketClass:TRtcSocketBaseClass=nil;

implementation

{$IF Defined(WINDOWS)}
  {$IF not Defined(RTC_noAsynSock)}
    uses
      rtcWinSocket;
    initialization
    DefaultRtcSocketClass:=TRtcWinSocket;
  {$ELSEIF not Defined(RTC_noSynSock)}
    uses
      rtcSynSocket;
    initialization
    DefaultRtcSocketClass:=TRtcSynSocket;
  {$ELSE}
    {$MESSAGE WARN 'AsynSock and SynSock API support excluded (RTC_noAsynSock, RTC_noSynSock).'}
  {$IFEND}
{$ELSE}
  {$IF not Defined(RTC_noSynSock)}
  uses
    rtcSynSocket;
  initialization
  DefaultRtcSocketClass:=TRtcSynSocket;
  {$ELSE}
    {$MESSAGE WARN 'SynSock API support excluded (RTC_noSynSock).'}
  {$IFEND}
{$IFEND}
end.
