{
  @html(<b>)
  C++Builder Components Registration
  @html(</b>)
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  RealThinClient SDK components for C++Builder development are being registered here.
  Components which are NOT designed for C++Builder will NOT be registered with this unit.

  @exclude
}
unit rtcRegisterC;

{$INCLUDE rtcDefs.inc}

interface

// This procedure is being called by Delphi to register the components.
procedure Register;

implementation

uses
  rtcDataCli, rtcDataSrv,
  rtcHttpSrv, rtcHttpCli,
  rtcMsgSrv, rtcMsgCli,

  rtcDataRoute, rtcLoadBalance,

  rtcCliModule, rtcSrvModule, rtcFunction,

  rtcScript, rtcLink, rtcDB, rtcThrPool,

{$IFNDEF RTC_NOISAPI} rtcISAPISrv, {$ENDIF}

  Classes;

procedure Register;
  begin
  RegisterComponents('RTC Server',[TRtcHttpServer,
                                   {$IFNDEF RTC_NOISAPI}TRtcISAPIServer,{$ENDIF}
                                   TRtcMessageServer,
                                   TRtcDataServerLink, TRtcDualDataServerLink,
                                   TRtcDataProvider,
                                   TRtcServerModule,
                                   TRtcFunctionGroup, TRtcFunction,
                                   TRtcLinkedModule,
                                   TRtcDataRouter,
                                   TRtcLoadBalancer,
                                   TRtcScriptEngine,
                                   TRtcQuickJob]);

  RegisterComponents('RTC Client',[TRtcHttpClient,
                                   TRtcMessageClient,
                                   TRtcDataClientLink, TRtcDualDataClientLink,
                                   TRtcDataRequest,
                                   TRtcClientModule,
                                   TRtcResult,
                                   TRtcMemDataSet,
                                   TRtcDataSetMonitor]);
  end;

end.
