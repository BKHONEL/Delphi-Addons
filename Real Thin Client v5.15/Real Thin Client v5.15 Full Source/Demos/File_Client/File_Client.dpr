program File_Client;

{$include rtcDefs.inc}

{$MAXSTACKSIZE 128000}

uses
{$ifdef rtcDeploy}
  FastMM4,
  FastMove,
{$endif}
  Forms,
  Client_Form in 'Client_Form.pas' {RtcFileClient};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TRtcFileClient, RtcFileClient);
  Application.Run;
end.
