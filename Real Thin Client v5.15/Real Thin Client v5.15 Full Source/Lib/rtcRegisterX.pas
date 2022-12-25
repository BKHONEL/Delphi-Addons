{
  @html(<b>)
  Cross-platform Components Registration
  @html(</b>)
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  RealThinClient SDK components for cross-platform development are being registered here.
  Components which are NOT designed for cross-platform use will NOT be registered with this unit.

  @exclude
}
unit rtcRegisterX;

{$INCLUDE rtcDefs.inc}

interface

// This procedure is being called by Delphi to register the components.
procedure Register;

implementation

uses
{$IFDEF FPC}
  LResources,
{$ENDIF}

  rtcDataCli, rtcDataSrv,
  rtcHttpSrv, rtcHttpCli,
  rtcMsgSrv, rtcMsgCli,

  rtcDataRoute, rtcLoadBalance,

  rtcCliModule, rtcSrvModule, rtcFunction,

  rtcScript, rtcLink, rtcDB, rtcThrPool,

  Classes;

procedure Register;
  begin
  RegisterComponents('RTC Server',[TRtcHttpServer,
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

{$IFDEF FPC}
initialization
{$I rtcsdk_fpc.lrs}
{$ENDIF}
end.