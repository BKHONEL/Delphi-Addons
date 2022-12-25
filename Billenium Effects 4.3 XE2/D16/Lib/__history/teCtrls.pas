unit teCtrls;

interface


uses
  SysUtils, Classes, teBkgrnd, Windows, Messages, Graphics, Controls, 
  StdCtrls, ExtCtrls;

type
  TEffectsPanel = class(TPanel)
  private
    FBackgroundOptions: TFCBackgroundOptions;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;

    procedure SetBackgroundOptions(Value: TFCBackgroundOptions);
    function  GetVersion: String;
    procedure SetVersion(const Value: String);
  protected
    function  GetPalette: HPalette; override;
    procedure Paint; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property BackgroundOptions: TFCBackgroundOptions read FBackgroundOptions write SetBackgroundOptions;
    property Version: String read GetVersion write SetVersion stored False;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

  TEffectsGroupBox = class(TGroupBox)
  private
    FBackgroundOptions: TFCBackgroundOptions;

    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;

    procedure SetBackgroundOptions(Value: TFCBackgroundOptions);
    function  GetVersion: String;
    procedure SetVersion(const Value: String);
  protected
    function  GetPalette: HPalette; override;
    procedure Paint; override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property BackgroundOptions: TFCBackgroundOptions read FBackgroundOptions write SetBackgroundOptions;
    property Version: String read GetVersion write SetVersion stored False;
  end;

implementation

uses
  
  teRender;

{ TEffectsPanel }

constructor TEffectsPanel.Create(AOwner: TComponent);
begin
  inherited;

  FBackgroundOptions := TFCBackgroundOptions.Create;
end;

destructor TEffectsPanel.Destroy;
begin
  FBackgroundOptions.Free;
  FBackgroundOptions := nil;

  inherited;
end;

function TEffectsPanel.GetPalette: HPalette;
begin
  Result := BackgroundOptions.GetPalette;
end;

procedure TEffectsPanel.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(BackgroundOptions) and (not(csDestroying in ComponentState)) then
    BackgroundOptions.Control := Self;
end;

function TEffectsPanel.GetVersion: String;
begin
  Result := BilleniumEffectsVersion;
end;

procedure TEffectsPanel.SetVersion(const Value: String);
begin
end;

procedure TEffectsPanel.Paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  R: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  Flags: Longint;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  R := Canvas.ClipRect;
  BackgroundOptions.DrawBackGround(Canvas.Handle, nil, R);

  Brush.Style := bsClear;
  R := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, R, TopColor, BottomColor, BevelWidth);
  end;

  InflateRect(R, -BorderWidth, -BorderWidth);

  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, R, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with R do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[Alignment];

    Flags := DrawTextBiDiModeFlags(Flags);
    DrawText(Handle, PChar(Caption), -1, R, Flags);
    Brush.Style := bsSolid;
  end;
end;

procedure TEffectsPanel.SetBackgroundOptions(Value: TFCBackgroundOptions);
begin
  BackgroundOptions.Assign(Value);
end;

procedure TEffectsPanel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TEffectsPanel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TEffectsPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
 
  Message.Result := 1;
end;

procedure TEffectsPanel.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;

  if(not(csDestroying in ComponentState)) and
    BackgroundOptions.IsActive then
    BackgroundOptions.ControlChanged(Self);
end;

{ TEffectsGroupBox }

constructor TEffectsGroupBox.Create(AOwner: TComponent);
begin
  inherited;

  FBackgroundOptions := TFCBackgroundOptions.Create;
end;

destructor TEffectsGroupBox.Destroy;
begin
  FBackgroundOptions.Free;
  FBackgroundOptions := nil;

  inherited;
end;

function TEffectsGroupBox.GetPalette: HPalette;
begin
  Result := BackgroundOptions.GetPalette;
end;

procedure TEffectsGroupBox.SetParent(AParent: TWinControl);
begin
  inherited;
  if Assigned(BackgroundOptions) and (not(csDestroying in ComponentState)) then
    BackgroundOptions.Control := Self;
end;

procedure TEffectsGroupBox.Paint;
var
  H: Integer;
  R,
  TextR: TRect;
  Flags: Longint;
  SaveIndex: Integer;
  
begin
  R := Canvas.ClipRect;
  BackgroundOptions.DrawBackGround(Canvas.Handle, nil, R);

  Brush.Style := bsClear;
  R := GetClientRect;
  with Canvas do
  begin
    Font := Self.Font;
  
    begin
      H := TextHeight('0');
      R := Rect(0, H div 2 - 1, Width, Height);

      SaveIndex := SaveDC(Canvas.Handle);
      try
        Flags := 0;
        if Text <> '' then
        begin
          if not UseRightToLeftAlignment
          then TextR := Rect(8, 0, 0, H)
          else TextR := Rect(R.Right - Canvas.TextWidth(Text) - 8, 0, 0, H);
          Flags := DrawTextBiDiModeFlags(DT_SINGLELINE);
          DrawText(Handle, PChar(Text), Length(Text), TextR, Flags or DT_CALCRECT);
          ExcludeClipRect(Canvas.Handle, TextR.Left, TextR.Top, TextR.Right,
            TextR.Bottom);
        end;

        if Ctl3D then
        begin
          Inc(R.Left);
          Inc(R.Top);
          Brush.Color := clBtnHighlight;
          FrameRect(R);
          OffsetRect(R, -1, -1);
          Brush.Color := clBtnShadow;
        end else
          Brush.Color := clWindowFrame;
        FrameRect(R);
      finally
        RestoreDC(Canvas.Handle, SaveIndex);
      end;

      if Text <> '' then
      begin
        Brush.Style := bsClear;
        DrawText(Handle, PChar(Text), Length(Text), TextR, Flags);
      end;
    end;
  end;
  Brush.Style := bsSolid;
end;

procedure TEffectsGroupBox.SetBackgroundOptions(Value: TFCBackgroundOptions);
begin
  BackgroundOptions.Assign(Value);
end;

procedure TEffectsGroupBox.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
 
  Message.Result := 1;
end;

procedure TEffectsGroupBox.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;

  if(not(csDestroying in ComponentState)) and
    BackgroundOptions.IsActive then
    BackgroundOptions.ControlChanged(Self);
end;

function TEffectsGroupBox.GetVersion: String;
begin
  Result := BilleniumEffectsVersion;
end;

procedure TEffectsGroupBox.SetVersion(const Value: String);
begin
end;

end.
