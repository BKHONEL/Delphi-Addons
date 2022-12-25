program AppClient;

//{$APPTYPE CONSOLE}

{$include rtcDefs.inc}
{$include rtcDeploy.inc}

{$MINSTACKSIZE 4000}
{$MAXSTACKSIZE 70000}

uses
{$IFDEF RtcDeploy}
  FastMM4,
{$ENDIF}
  Forms,
  AppClient_Unit in 'AppClient_Unit.pas' {Form1};

{$R *.res}

begin
  {$IFDEF IDE_2006up}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
