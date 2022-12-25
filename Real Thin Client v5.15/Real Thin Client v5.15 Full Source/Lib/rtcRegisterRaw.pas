{
  @html(<b>)
  Raw TCP and UDP components Registration
  @html(</b>)
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  RealThinClient SDK's "raw" TCP/IP and UDP components 
  are being registered to Delphi component palette.
  
  @exclude
}
unit rtcRegisterRaw;

{$INCLUDE rtcDefs.inc}

interface

// This procedure is being called by Delphi to register the components.
procedure Register;

implementation

uses
  rtcTCPCli, rtcTCPSrv,
  rtcUDPCli, rtcUDPSrv,

  Classes;

procedure Register;
  begin
  RegisterComponents('RTC Raw',[TRtcTCPClient,
                                TRtcTCPServer,
                                TRtcUDPClient,
                                TRtcUDPServer]);
  end;

end.
