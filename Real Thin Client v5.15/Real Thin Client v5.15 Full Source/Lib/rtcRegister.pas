{
  @html(<b>)
  Component Registration
  @html(</b>)
  - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  RealThinClient SDK  components are being
  registered to Delphi component palette.
  
  @exclude
}
unit rtcRegister;

{$INCLUDE rtcDefs.inc}

interface

// This procedure is being called by Delphi to register the components.
procedure Register;

implementation

uses
{$IFNDEF RTC_NOINTF}
  {$IFNDEF FPC}
    {$IFDEF IDE_6up}
      DesignIntf,
    {$ELSE}
      TypInfo, Consts,
      DsgnIntf,
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF FPC}
  LResources,
{$ENDIF}

  rtcDataCli, rtcDataSrv,
  rtcHttpSrv, rtcHttpCli,
  rtcMsgSrv, rtcMsgCli,
{$IFNDEF RTC_NOISAPI}
  rtcISAPISrv,
  {$IFNDEF RTC_NOINTF}
    rtcEditors,
    rtcTransports,
  {$ENDIF}
{$ENDIF}

  rtcDataRoute, rtcLoadBalance,

  rtcCliModule, rtcSrvModule, rtcFunction,

  rtcScript, rtcLink, rtcDB, rtcThrPool,

  Classes;

{$IFNDEF RTC_NOINTF}
  {$IFNDEF FPC}
  type
    TRtcMessageReceiverInterfacedComponentProperty = class(TRtcInterfacedComponentProperty)
      public
        function GetIID: TGUID; override;
      end;

  function TRtcMessageReceiverInterfacedComponentProperty.GetIID: TGUID;
    begin
    Result := IRTCMessageReceiverGUID;
    end;
  {$ENDIF}
{$ENDIF}

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

{$IFNDEF RTC_NOINTF}
  {$IFNDEF FPC}
  RegisterPropertyEditor(TComponent.ClassInfo,
                         TRtcMessageClient, 'Server',
                         TRtcMessageReceiverInterfacedComponentProperty);
  {$ENDIF}
{$ENDIF}
  end;

{$IFDEF FPC}
initialization
{$I rtcsdk_fpc.lrs}
{$ENDIF}
end.
