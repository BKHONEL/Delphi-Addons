unit SrvUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, rtcInfo, rtcConn, rtcDataSrv, rtcHttpSrv, rtcFunction,
  rtcSrvModule, StdCtrls;

{$include rtcDefs.inc}

type
  TForm1 = class(TForm)
    RtcHttpServer1: TRtcHttpServer;
    RtcFunctionGroup1: TRtcFunctionGroup;
    RtcServerModule1: TRtcServerModule;
    RtcFunction1: TRtcFunction;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RtcFunction1Execute(Sender: TRtcConnection;
      Param: TRtcFunctionInfo; Result: TRtcValue);
    procedure Button1Click(Sender: TObject);
    procedure RtcHttpServer1ListenStart(Sender: TRtcConnection);
    procedure RtcHttpServer1ListenStop(Sender: TRtcConnection);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
  begin
  RtcHttpServer1.Listen;
  end;

procedure TForm1.RtcFunction1Execute(Sender: TRtcConnection; Param: TRtcFunctionInfo; Result: TRtcValue);
  begin
  // Here is a simple example for manual session handling ...
  with TRtcDataServer(Sender) do
    if not assigned(Session) then
      begin
      if Param.asString['name']='hi' then // user sends "hi" to start a new session
        begin
        OpenSession;
        Session.KeepAlive:=30; // allow max 30 seconds idle time between requests, or session dies
        Result.asString:='Hi! Your NEW ID = '+Session.ID;
        end
      else // no session, tell the user that
        Result.asString:=Param.asString['name']+' does NOT have a Session';
      end
    else if Param.asString['name']='bye' then // user sends "bye" to close a session
      begin
      Result.asString:='Bye, bye! Your ID was '+Session.ID;
      Session.Close;
      end
    else // tell the user his session ID
      Result.asString:=Param.asString['name']+', your OLD ID = '+Session.ID;
  end;

procedure TForm1.Button1Click(Sender: TObject);
  begin
  if RtcHttpServer1.isListening then
    RtcHttpServer1.StopListen
  else
    RtcHttpServer1.Listen;
  end;

procedure TForm1.RtcHttpServer1ListenStart(Sender: TRtcConnection);
  begin
  if not Sender.inMainThread then
    Sender.Sync(RtcHttpServer1ListenStart)
  else
    Button1.Caption:='Stop';
  end;

procedure TForm1.RtcHttpServer1ListenStop(Sender: TRtcConnection);
  begin
  if not Sender.inMainThread then
    Sender.Sync(RtcHttpServer1ListenStop)
  else
    Button1.Caption:='Listen';
  end;

end.
