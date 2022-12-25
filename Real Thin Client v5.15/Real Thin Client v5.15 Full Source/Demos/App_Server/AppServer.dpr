program AppServer;

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
  Server_Form in 'Server_Form.pas' {Form1},
  AppServer_Module in 'AppServer_Module.pas' {AppSrv_Module: TDataModule};

{$R *.res}

begin
  {$IFDEF IDE_2006up}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TAppSrv_Module, AppSrv_Module);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
