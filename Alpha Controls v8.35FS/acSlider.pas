unit acSlider;
{$I sDefs.inc}

interface

uses
  Windows {$IFNDEF DELPHI5}, Types{$ENDIF}, SysUtils, Classes, Controls, ExtCtrls, sPanel, sButton, Graphics, Messages,
  ImgList, sCommonData;

type
  TacSliderChangeEvent = procedure(Sender: TObject) of object;
  TacOnChangingEvent = procedure(Sender: TObject; var CanChange : boolean) of object;
  TControlOrientation = (coHorizontal, coVertical);

  TsSlider = class;

  TsSlider = class(TsPanel)
  private
    FImageChangeLink: TChangeLink;
    FButton: TsPanel;
    MouseDownSpot: TPoint;
    Capturing: Boolean;
    Dragged : boolean;
    FSliderOn: Boolean;
    FOnSliderChange: TacSliderChangeEvent;
    FSliderCaptionOn: TCaption;
    FSliderCaptionOff: TCaption;
    FOrientation: TControlOrientation;
    FImageIndexOff: TImageIndex;
    FImageIndexOn: TImageIndex;
    FImages: TCustomImageList;
    FFontOn: TFont;
    FBoundLabel: TsBoundLabel;
    FShowCaption: boolean;
    FOnChanging: TacOnChangingEvent;
    procedure SetSliderOn(const Value: Boolean);
    procedure ImageListChange(Sender: TObject);
    procedure FontOnChange(Sender: TObject);
    procedure UpdateButton;
    procedure SetSliderCaptionOff(const Value: TCaption);
    procedure SetSliderCaptionOn(const Value: TCaption);
    procedure SetSliderCursor(const Value: TCursor);
    function GetSliderCursor: TCursor;
    procedure SetOrientation(const Value: TControlOrientation);
    procedure SetImageIndexOff(const Value: TImageIndex);
    procedure SetImageIndexOn(const Value: TImageIndex);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetFontOn(const Value: TFont);
    procedure SetShowCaption(const Value: boolean);
  protected
    function CanChange : boolean;
    procedure Click; override;
    procedure UpdateSize;
    procedure UpdateBtnFont;
    function ImagesDefined : boolean;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure ChangeValueAnim;
    procedure ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonPaint(Sender: TObject; Canvas: TCanvas);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Loaded; override;
    procedure WndProc (var Message: TMessage); override;
  published
    property BevelOuter default bvLowered;
    property BoundLabel : TsBoundLabel read FBoundLabel write FBoundLabel;
    property Orientation : TControlOrientation read FOrientation write SetOrientation default coHorizontal;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageIndexOff : TImageIndex read FImageIndexOff write SetImageIndexOff default -1;
    property ImageIndexOn : TImageIndex read FImageIndexOn write SetImageIndexOn default -1;
    property FontOn : TFont read FFontOn write SetFontOn;
    property Height default 21;
    property Width default 57;
    property ShowCaption : boolean read FShowCaption write SetShowCaption default True;
    property SliderCursor: TCursor read GetSliderCursor write SetSliderCursor default crDefault;
    property SliderOn: Boolean read FSliderOn write SetSliderOn default True;
    property SliderCaptionOn: TCaption read FSliderCaptionOn write SetSliderCaptionOn;
    property SliderCaptionOff: TCaption read FSliderCaptionOff write SetSliderCaptionOff;
    property OnChanging: TacOnChangingEvent read FOnChanging write FOnChanging;
    ////// Event allows to forbid a changing of value //////
    property OnSliderChange: TacSliderChangeEvent read FOnSliderChange write FOnSliderChange;
  end;

implementation

uses
  Forms, sSkinProps, sConst, acntUtils, math, sGraphUtils;

{ TsSlider }

const
  ContentMargin = 8;

procedure TsSlider.AfterConstruction;
begin
  inherited;
  UpdateButton;
  if FFontOn.Height = 100 then FFontOn.Assign(Font);
  FButton.OnClick := OnClick;
end;

procedure TsSlider.ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    Capturing := True;
    MouseDownSpot.X := X;
    MouseDownSpot.Y := Y;
  end;
end;

procedure TsSlider.ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  b : boolean;
begin
  if Capturing then begin
    FButton.SkinData.BeginUpdate;
    Dragged := True;
    if Orientation = coHorizontal then begin
      if (FButton.Left - (MouseDownSpot.X - X) > 0) and (FButton.Left - (MouseDownSpot.X - X) + FButton.Width < Width) then begin
        FButton.Left := FButton.Left - (MouseDownSpot.X - X);
        b := FButton.Left < Width - (FButton.Left + FButton.Width);
        if b <> FSliderOn then SliderOn := b;
      end
      else if (FButton.Left - (MouseDownSpot.X - X) < 0)
        then FButton.Left := 1
        else if (FButton.Left - (MouseDownSpot.X - X) + FButton.Width > Width)
          then FButton.Left := Width - FButton.Width - 1;
    end
    else begin
      if (FButton.Top - (MouseDownSpot.Y - Y) > 0) and (FButton.Top - (MouseDownSpot.Y - Y) + FButton.Height < Height) then begin
        FButton.Top := FButton.Top - (MouseDownSpot.Y - Y);
        b := FButton.Top < Height - (FButton.Top + FButton.Height);
        if b <> FSliderOn then SliderOn := b;
      end
      else if (FButton.Top - (MouseDownSpot.Y - Y) < 0)
        then FButton.Top := 1
        else if (FButton.Top - (MouseDownSpot.Y - Y) + FButton.Height > Height)
          then FButton.Top := Height - FButton.Height - 1;
    end;
    FButton.SkinData.EndUpdate;
  end;
end;

procedure TsSlider.ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Capturing then begin
    Capturing := False;
    if Dragged then begin
      if Orientation = coHorizontal then SliderOn := (FButton.Left < FButton.Width div 2) else SliderOn := (FButton.Top < FButton.Height div 2);
    end
    else ChangeValueAnim;
    UpdateButton;
  end;
  Dragged := False;
end;

procedure TsSlider.ButtonPaint(Sender: TObject; Canvas: TCanvas);
const
  cMargin = 2;
var
  x, y, Ndx : integer;
  R : TRect;
  s : string;
begin
  x := cMargin;
  y := cMargin;
  if FShowCaption then begin
    if FSliderOn then begin
      s := FSliderCaptionOn;
      if s <> '' then Canvas.Font.Assign(FontOn);
    end
    else begin
      s := FSliderCaptionOff;
      if s <> '' then Canvas.Font.Assign(Font);
    end;
  end
  else s := '';
  if Images <> nil then begin
    if Orientation = coHorizontal then begin
      if s = '' then x := (FButton.Width - Images.Width) div 2;
      Images.Draw(Canvas, x, (FButton.Height - Images.Height) div 2, iffi(FSliderOn, ImageIndexOn, ImageIndexOff));
      inc(x, Images.Width + 2);
    end
    else begin
      Images.Draw(Canvas, (FButton.Width - Images.Width) div 2, y, iffi(FSliderOn, ImageIndexOn, ImageIndexOff));
      inc(y, Images.Height + 2);
    end;
  end;
  if s <> '' then begin
    R.Left := x;
    R.Top := y;
    R.Right := FButton.Width - cMargin;
    R.Bottom := FButton.Height - cMargin;
    if not SkinData.CustomFont and SkinData.Skinned then begin
      Ndx := FButton.SkinData.SkinIndex;
    end
    else Ndx := -1;
    acWriteTextEx(Canvas, PacChar(s), Enabled, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE, Ndx, False, SkinData.SkinManager);
  end;
end;

function TsSlider.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
var
  cy, cx, h : integer;
begin
  if Images <> nil then begin
    h := Images.Height;
    if Orientation = coHorizontal then begin
      cx := Images.Width + 2;
      cy := 0;
    end
    else begin
      cx := 0;
      cy := h + 2;
    end;
  end
  else begin
    cx := 0;
    cy := 0;
    h := 8;
  end;
  if FShowCaption then begin
    NewWidth := (cx + max(Canvas.TextWidth(SliderCaptionOff), Canvas.TextWidth(SliderCaptionOn)) + ContentMargin) * 2;
    NewHeight := (max(cy + Canvas.TextHeight(SliderCaptionOn), h) + ContentMargin);
  end
  else begin
    NewWidth := (cx + ContentMargin) * 2;
    NewHeight := h + ContentMargin;
  end;
  Result := True;
end;

function TsSlider.CanChange: boolean;
begin
  Result := True;
  if Assigned(FOnChanging) then FOnChanging(Self, Result);
end;

procedure TsSlider.ChangeValueAnim;
const
  StepCount = 20;
var
  i : integer;
  Step : real;
begin
  if not CanChange then Exit;
  if Orientation = coHorizontal then begin
    Step := FButton.Width / StepCount;
    if not FSliderOn then Step := -Step;
    for i := 0 to StepCount - 2 do begin
      FButton.Left := Round(FButton.Left + Step);
      if not SkinData.Skinned then FButton.Repaint;
      Repaint;
      Sleep(4);
    end;
  end
  else begin
    Step := FButton.Height / StepCount;
    if not FSliderOn then Step := -Step;
    for i := 0 to StepCount - 2 do begin
      FButton.Top := Round(FButton.Top + Step);
      if not SkinData.Skinned then FButton.Repaint;
      Repaint;
      Sleep(4);
    end;
  end;
  SliderOn := not FSliderOn;
end;

procedure TsSlider.Click;
begin
  inherited;
  ChangeValueAnim;
end;

constructor TsSlider.Create(AOwner: TComponent);
begin
  inherited;
  FBoundLabel := TsBoundLabel.Create(Self, SkinData);
  SkinData.SkinSection := s_PANELLOW;
  FSliderOn := True;
  FShowCaption := True;
  FOrientation := coHorizontal;
  TabStop := False;
  BevelOuter := bvLowered;
  Width := 57;
  Height := 21;
  FSliderCaptionOn := 'On';
  FSliderCaptionOff := 'Off';
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  FFontOn := TFont.Create;
  FFontOn.OnChange := FontOnChange;
  FFontOn.Height := 100;

  FButton := TsPanel.Create(Self);
  FButton.Parent := Self;
  FButton.Top := 1;
  FButton.TabStop := False;
  FButton.OnMouseDown := ButtonMouseDown;
  FButton.OnMouseMove := ButtonMouseMove;
  FButton.OnMouseUp := ButtonMouseUp;
  FButton.OnPaint := ButtonPaint;
  UpdateButton;
end;

destructor TsSlider.Destroy;
begin
  FreeAndNil(FBoundLabel);
  FButton.Free;
  FFontOn.Free;
  FreeAndNil(FImageChangeLink);
  inherited;
end;

procedure TsSlider.FontOnChange(Sender: TObject);
begin
  if SkinData.Skinned then begin
    SkinData.Invalidate;
  end
  else Repaint;
  UpdateSize;
end;

function TsSlider.GetSliderCursor: TCursor;
begin
  Result := FButton.Cursor;
end;

procedure TsSlider.ImageListChange(Sender: TObject);
begin
  if SkinData.Skinned then begin
    SkinData.Invalidate;
  end
  else Repaint;
end;

function TsSlider.ImagesDefined: boolean;
begin
  Result := (Images <> nil) and (ImageIndexOff >= 0) and
     (ImageIndexOn >= 0) and (ImageIndexOff < Images.Count) and
     (ImageIndexOn < Images.Count);
end;

procedure TsSlider.Loaded;
begin
  inherited;
  UpdateButton;
  if FFontOn.Height = 100 then FFontOn.Assign(Font);
  UpdateBtnFont;
  FButton.OnClick := OnClick;
end;

procedure TsSlider.SetFontOn(const Value: TFont);
begin
  FontOn.Assign(Value);
end;

procedure TsSlider.SetImageIndexOff(const Value: TImageIndex);
begin
  if FImageIndexOff <> Value then begin
    FImageIndexOff := Value;
    UpdateButton;
  end;
end;

procedure TsSlider.SetImageIndexOn(const Value: TImageIndex);
begin
  if FImageIndexOn <> Value then begin
    FImageIndexOn := Value;
    UpdateButton;
  end;
end;

procedure TsSlider.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then begin
    if Images <> nil then Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if Images <> nil then begin
      Images.RegisterChanges(FImageChangeLink);
      Images.FreeNotification(Self);
      UpdateButton;
    end;
    if (Visible or (csDesigning in ComponentState)) and (SkinData.CtrlSkinState and ACS_LOCKED <> ACS_LOCKED) then begin
      UpdateSize;
      SkinData.Invalidate;
    end;
  end;
end;

procedure TsSlider.SetOrientation(const Value: TControlOrientation);
begin
  if FOrientation <> Value then begin
    FOrientation := Value;
    UpdateButton;
  end;
end;

procedure TsSlider.SetShowCaption(const Value: boolean);
begin
  if FShowCaption <> Value then begin
    FShowCaption := Value;
    UpdateSize;
  end;
end;

procedure TsSlider.SetSliderCaptionOff(const Value: TCaption);
begin
  if FSliderCaptionOff <> Value then begin
    FSliderCaptionOff := Value;
    UpdateSize;
  end;
end;

procedure TsSlider.SetSliderCaptionOn(const Value: TCaption);
begin
  if FSliderCaptionOn <> Value then begin
    FSliderCaptionOn := Value;
    UpdateSize;
  end;
end;

procedure TsSlider.SetSliderCursor(const Value: TCursor);
begin
  FButton.Cursor := Value;
end;

procedure TsSlider.SetSliderOn(const Value: Boolean);
begin
  if FSliderOn <> Value then begin
    if not CanChange then Exit;
    FSliderOn := Value;
    UpdateButton;
    UpdateBtnFont;
    Repaint;
    if Assigned(FOnSliderChange) then FOnSliderChange(Self);
  end;
end;

procedure TsSlider.UpdateBtnFont;
begin
  if FSliderOn then begin
    FButton.SkinData.CustomFont := True;
    FButton.Font.Assign(FontOn);
  end
  else begin
    FButton.SkinData.CustomFont := SkinData.CustomFont;
    FButton.Font.Assign(Font);
  end;
end;

procedure TsSlider.UpdateButton;
begin
  if Orientation = coHorizontal then begin
    FButton.Width := Width div 2;
    FButton.Height := Height - 2;
    if FSliderOn then FButton.Left := 1 else FButton.Left := Width - FButton.Width - 1;
    FButton.Top := 1;
  end
  else begin
    FButton.Width := Width - 2;
    FButton.Height := Height div 2;
    FButton.Left := 1;
    if FSliderOn then FButton.Top := 1 else FButton.Top := Height - FButton.Height - 1;
  end;
  FButton.SkinData.BGChanged := True;
end;

procedure TsSlider.UpdateSize;
begin
  if AutoSize then begin
    AdjustSize;
    UpdateButton;
  end;
end;

procedure TsSlider.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_GETTEXTLENGTH : begin
      Message.Result := 0;
      Exit;
    end;
  end;
  inherited;
  case Message.Msg of
    WM_SIZE : UpdateButton;
  end;
  // Aligning of the bound label
  if Assigned(BoundLabel) and Assigned(BoundLabel.FtheLabel) then case Message.Msg of
    WM_SIZE, WM_WINDOWPOSCHANGED : begin BoundLabel.AlignLabel end;
    CM_VISIBLECHANGED : begin BoundLabel.FtheLabel.Visible := Visible; BoundLabel.AlignLabel end;
    CM_ENABLEDCHANGED : begin BoundLabel.FtheLabel.Enabled := Enabled; BoundLabel.AlignLabel end;
    CM_BIDIMODECHANGED : begin BoundLabel.FtheLabel.BiDiMode := BiDiMode; BoundLabel.AlignLabel end;
  end;
end;

end.
