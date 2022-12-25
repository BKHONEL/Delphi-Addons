{
  @exclude

  @html(<b>)
  StreamSec SSL Plug-in Registration
  @html(</b>)
  - Copyright (c) Henrick Hellstrom & Danijel Tkalcec
  @html(<br><br>)
}
unit rtcSSecRegister;

interface

uses
  Classes, SysUtils,

  // RTC SDK
  rtcPlugins,
  rtcSSecPlugin;

procedure Register;

implementation

procedure Register;
  begin
  RegisterComponents('RTC Server',[TRtcSSecServerPlugin]);
  RegisterComponents('RTC Client',[TRtcSSecClientPlugin]);
  end;

end.
