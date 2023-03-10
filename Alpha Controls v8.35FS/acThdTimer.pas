// Copyright 1996, 1997, 1998 Carlos Barbosa //
unit acThdTimer;
{$I sDefs.inc}

{$DEFINE USE_TIMER} // Patched by M. Zhuravsky (standard timer used if key is enabled)

interface

uses
  ExtCtrls,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SyncObjs;

type
  TacThreadedTimer = class;

  TacTimerThread = class(TThread)
    OwnerTimer: TacThreadedTimer;
    Interval: DWord;
    TimeEvent: TSimpleEvent;
    procedure Execute; override;
    procedure DoTimer;
  end;

  TacThreadedTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: DWord;
    FOnTimer: TNotifyEvent;
    {$IFDEF USE_TIMER}
    FTimerThread: TTimer;
    {$ELSE}
    FTimerThread: TacTimerThread;
    {$ENDIF}
    FThreadPriority: TThreadPriority;
    procedure KillTimer;
    procedure StartTimer;
    {$IFDEF USE_TIMER}
    Procedure OnTimer2(Sender: TObject);
    {$ENDIF}
  protected
    Executing : boolean;
    FOwner : TObject;
    InHandler : boolean;
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: DWord);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure SetThreadPriority(Value: TThreadPriority);
    procedure Timer; dynamic;
    procedure TimeHandler; virtual;
    procedure TimeEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateOwned(AOwner: TComponent; ChangeEvent : boolean); virtual;
    destructor Destroy; override;
    procedure Reset;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: DWord read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
    property ThreadPriority: TThreadPriority read FThreadPriority write SetThreadPriority;
  end;

implementation

procedure TacTimerThread.Execute;
var
  term_cause: TWaitResult;
begin   
  repeat
    term_cause := TimeEvent.WaitFor(Interval);
    if term_cause = wrTimeout then Synchronize(DoTimer);
  until Terminated or (term_cause <> wrTimeout) or Application.Terminated;
end;

procedure TacTimerThread.DoTimer;
begin
  if not Application.Terminated then OwnerTimer.Timer;
end;

constructor TacThreadedTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThreadPriority := tpNormal;
  Executing := False;
  InHandler := False;
  if not Application.Terminated then begin
    FEnabled := True;
    FInterval := 1000;
    StartTimer;
  end;
end;

destructor TacThreadedTimer.Destroy;
begin
  KillTimer;
  inherited Destroy;
end;

procedure TacThreadedTimer.StartTimer;
begin
{$IFDEF USE_TIMER}
  FTimerThread := TTimer.Create(Self);
  FTimerThread.Interval := FInterval;
  FTimerThread.OnTimer := OnTimer2;
{$ELSE}
  FTimerThread := TacTimerThread.Create(True);
  FTimerThread.OwnerTimer := Self;
  FTimerThread.Interval := FInterval;
  FTimerThread.Priority := FThreadPriority;
  FTimerThread.FreeOnTerminate := False;
  FTimerThread.TimeEvent := TSimpleEvent.Create;
  FTimerThread.TimeEvent.ResetEvent;
  FTimerThread.Resume;
{$ENDIF}
end;

procedure TacThreadedTimer.KillTimer;
begin
  if FTimerThread <> nil then begin
  {$IFDEF USE_TIMER}
    FTimerThread.Enabled := False;
    FTimerThread.Free;
  {$ELSE}
    FTimerThread.TimeEvent.SetEvent;         // Note: if the thread is suspended
                                             //       it will never terminate!
    if FTimerThread.Suspended then FTimerThread.Resume;
    FTimerThread.WaitFor;
    FTimerThread.TimeEvent.Free;
    FTimerThread.Free;
  {$ENDIF}
  end;
end;

procedure TacThreadedTimer.UpdateTimer;
begin
  if FTimerThread <> nil then begin
{$IFDEF USE_TIMER}
    FTimerThread.Enabled := False;
    if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then FTimerThread.Enabled := True;
{$ELSE}
    if not FTimerThread.Suspended then FTimerThread.Suspend;
    if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then FTimerThread.Resume;
{$ENDIF}
  end;
end;

procedure TacThreadedTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TacThreadedTimer.SetInterval(Value: DWord);
begin
  if Value <> FInterval then begin
    FInterval := Value;
    if FTimerThread <> nil then begin
      FTimerThread.Interval := FInterval;
      UpdateTimer;
    end;
  end;
end;

procedure TacThreadedTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TacThreadedTimer.SetThreadPriority(Value: TThreadPriority);
begin
  if Value <> FThreadPriority then begin
    FThreadPriority := Value;
    {$IFNDEF USE_TIMER}
    FTimerThread.Priority := Value;
    {$ENDIF}
    UpdateTimer;
  end;
end;

procedure TacThreadedTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

procedure TacThreadedTimer.Reset;
begin
  KillTimer;
  StartTimer;
  UpdateTimer;
end;

constructor TacThreadedTimer.CreateOwned(AOwner: TComponent; ChangeEvent: boolean);
begin
  Create(AOwner);
  Enabled := False;
  FOwner := AOwner;
  if ChangeEvent then OnTimer := TimeEvent;
end;

procedure TacThreadedTimer.TimeHandler;
begin
//
end;

procedure TacThreadedTimer.TimeEvent(Sender: TObject);
begin
  TimeHandler;
end;

{$IFDEF USE_TIMER}
procedure TacThreadedTimer.OnTimer2(Sender: TObject);
begin
  if TTimer(Sender).Enabled and not Executing then begin
    Executing := True;
    TacThreadedTimer(TTimer(Sender).Owner).Timer;
    Executing := False;
  end;
end;
{$ENDIF}

end.
