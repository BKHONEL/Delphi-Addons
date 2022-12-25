unit sSpeedButton;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Imglist, {$IFNDEF DELPHI5}Types, {$ENDIF}
  Buttons, sCommonData, sConst, sDefaults, sFade, comctrls, menus
  {$IFDEF TNTUNICODE}, TntButtons{$ENDIF};

type

{$IFDEF TNTUNICODE}
  TsSpeedButton = class(TTntSpeedButton)
{$ELSE}
  TsSpeedButton = class(TSpeedButton)
{$ENDIF}
  private
{$IFNDEF NOTFORHELP}
    FOldNumGlyphs : integer;
    FOldSpacing : integer;
    FImageChangeLink: TChangeLink;

    FStoredDown : boolean;
    FCommonData: TsCtrlSkinData;
    FDisabledKind: TsDisabledKind;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FadeTimer : TsAnimTimer;
    FDisabledGlyphKind: TsDisabledGlyphKind;
    FGrayed: boolean;
    FBlend: integer;
    FOffset: Integer;
    FImageIndex: integer;
    FImages: TCustomImageList;
    FShowCaption: boolean;
    FAlignment: TAlignment;
    FTextLayout : integer;
    FButtonStyle: TToolButtonStyle;
    FDropdownMenu: TPopupMenu;
    FDrawOverBorder: boolean;
    FOnPaint: TBmpPaintEvent;
    FTextAlignment: TAlignment;
    FAnimatEvents: TacAnimatEvents;

    procedure ImageListChange(Sender: TObject);
    procedure SetDisabledKind(const Value: TsDisabledKind);
    procedure SetDisabledGlyphKind(const Value: TsDisabledGlyphKind);
    procedure SetBlend(const Value: integer);
    procedure SetGrayed(const Value: boolean);
    procedure SetOffset(const Value: Integer);
    procedure SetImageIndex(const Value: integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetShowCaption(const Value: boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetButtonStyle(const Value: TToolButtonStyle);
    procedure SetDropdownMenu(const Value: TPopupMenu);
    procedure SetDrawOverBorder(const Value: boolean);
    procedure SetTextAlignment(const Value: TAlignment);
  private
    FReflected: boolean;
    FWordWrap: boolean;
    procedure SetReflected(const Value: boolean);
    procedure SetWordWrap(const Value: boolean);
  protected
    DroppedDown : boolean;
    FMenuOwnerMode : boolean;
    FHotState : boolean;
    OldOnChange: TNotifyEvent;
    OldLayout : TButtonLayout;
    OldCaption : acString;

    function ArrowWidth : integer;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); virtual;
    procedure DrawCaption; virtual;
    function TextRectSize : TSize; virtual;
    procedure DrawGlyph; virtual;
    function GlyphWidth : integer; virtual;
    function GlyphHeight : integer; virtual;
    function GenMargin : integer;

    function PrepareCache : boolean; virtual;

    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure Ac_CMMouseEnter;
    procedure Ac_CMMouseLeave;
    procedure StdPaint(PaintButton : boolean = True); virtual;
    procedure Paint; override;
    procedure GlyphChanged(Sender: TObject);
    procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function CurrentState : integer; virtual;
    function CaptionRect : TRect; virtual;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure GraphRepaint;
    procedure AfterConstruction; override;
    function ImgRect : TRect; virtual;
    procedure Invalidate; override;
    procedure Loaded; override;
    procedure WndProc (var Message: TMessage); override;
    property Canvas;
{$ENDIF} // NOTFORHELP
  published
{$IFNDEF NOTFORHELP}
    property Align;
    property OnPaint : TBmpPaintEvent read FOnPaint write FOnPaint;
{$ENDIF} // NOTFORHELP
    property OnMouseEnter : TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnDragDrop;
    property OnDragOver;
    property AnimatEvents : TacAnimatEvents read FAnimatEvents write FAnimatEvents default [aeGlobalDef];
    property Alignment : TAlignment read FAlignment write SetAlignment default taCenter;
    property Blend : integer read FBlend write SetBlend default 0;
    property ButtonStyle : TToolButtonStyle read FButtonStyle write SetButtonStyle default tbsButton;
    property SkinData : TsCtrlSkinData read FCommonData write FCommonData;
    property DisabledGlyphKind : TsDisabledGlyphKind read FDisabledGlyphKind write SetDisabledGlyphKind default DefDisabledGlyphKind;
    property DisabledKind : TsDisabledKind read FDisabledKind write SetDisabledKind default DefDisabledKind;
    property DragKind;
    property DragCursor;
    property DragMode;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property Grayed : boolean read FGrayed write SetGrayed default False;
    property ImageIndex : integer read FImageIndex write SetImageIndex default -1;
    property Images : TCustomImageList read FImages write SetImages;
    property Reflected : boolean read FReflected write SetReflected default False;
    property ShowCaption: boolean read FShowCaption write SetShowCaption default True;
    property DrawOverBorder : boolean read FDrawOverBorder write SetDrawOverBorder default True;
    property TextOffset : Integer read FOffset write SetOffset default 0;
    property TextAlignment : TAlignment read FTextAlignment write SetTextAlignment default taCenter;
    property WordWrap : boolean read FWordWrap write SetWordWrap default True;
  end;

{$IFNDEF NOTFORHELP}
  TsTimerSpeedButton = class(TsSpeedButton)
  private
    FAllowTimer: boolean;
  public
    constructor Create (AOwner: TComponent); override;
  published
    property AllowTimer: boolean read FAllowTimer write FAllowTimer default True;
  end;

function GlowingAllowed(Btn : TsSpeedButton) : boolean;
{$ENDIF} // NOTFORHELP

implementation

uses sGraphUtils, sVCLUtils, sMessages, acntUtils, sMAskData, sAlphaGraph, sStyleSimply, sSkinProps, acGlow, math, sPanel,
  sBitBtn, sThirdParty{$IFDEF LOGGED}, sDebugMsgs{$ENDIF}, ActnList, sSkinManager, sBorders{$IFDEF DELPHI7UP}, Themes{$ENDIF};

const AddedWidth = 16;

var
  MenuVisible : boolean = False;

type
  TPopupActionBar_ = class(TPopupMenu)
{$IFDEF D2009}
    FActionManager: TObject;
{$ENDIF}
    FPopupMenu: TObject;
  end;

function GlowingAllowed(Btn : TsSpeedButton) : boolean;
begin
  if Btn.DropDownMenu = nil then Result := True else begin
    if Btn.DropDownMenu.ClassName = 'TPopupActionBar' 
      then Result := TPopupActionBar_(Btn.DropDownMenu).FPopupMenu = nil
      else Result := True
  end;
end;

function IsImgListDefined(Btn : TsSpeedButton) : boolean;
begin
  Result := Assigned(Btn.Images) and (GetImageCount(Btn.Images) > 0) and (Btn.ImageIndex >= 0) and (Btn.ImageIndex < GetImageCount(Btn.Images))
end;

procedure PaintParentControls(Button : TsSpeedButton; aCanvas : TCanvas);
var
  i : integer;
  R, cR : TRect;
  SavedDC : hdc;
begin
  with Button do begin
    R := BoundsRect;
    for i := 0 to Parent.ControlCount - 1 do if (Parent.Controls[i] <> Button) and Parent.Controls[i].Visible and (csOpaque in Parent.Controls[i].ControlStyle) then begin
      cR := Parent.Controls[i].BoundsRect;
      if PtInRect(R, cR.TopLeft) or PtInRect(R, cR.BottomRight) then begin
        SavedDC := SaveDC(aCanvas.Handle);
        try
          aCanvas.Lock;
          Parent.Controls[i].ControlState := Parent.Controls[i].ControlState + [csPaintCopy];
          MoveWindowOrg(aCanvas.Handle, cR.Left - R.Left, cr.Top - R.Top);
          IntersectClipRect(aCanvas.Handle, 0, 0, Parent.Controls[i].Width, Parent.Controls[i].Height);
          Parent.Controls[i].Perform(WM_PAINT, WPARAM(aCanvas.Handle), 0);
          Parent.Controls[i].ControlState := Parent.Controls[i].ControlState - [csPaintCopy];
          aCanvas.UnLock;
        finally
          RestoreDC(aCanvas.Handle, SavedDC);
        end;
      end;
    end;
  end;
end;

procedure StartFade(Button : TsSpeedButton; Clicked : boolean = False);
var
  i : integer;
begin
  with Button do if not (csDesigning in ComponentState) then begin
    if FadeTimer <> nil then begin
      i := FadeTimer.Iterations - FadeTimer.FadeLevel;
      FreeAndNil(FadeTimer);
    end
    else i := 1;
    if FCommonData.SkinManager.gd[FCommonData.SkinIndex].FadingEnabled and not FadingForbidden then begin
      if FadeTimer = nil then begin
        FadeTimer := TsAnimTimer.Create(nil);
        FadeTimer.Enabled := False;
        FadeTimer.OwnerData := FCommonData;
        if Clicked then FadeTimer.Iterations := FadeTimer.Iterations shr 1; // div 2; // Animation is faster when clicked
        FadeTimer.FadeLevel := i;
        PaintParentControls(Button, FCommonData.FCacheBmp.Canvas);
        FadeTimer.BmpFrom.Assign(FCommonData.FCacheBmp); // Save current image
      end;
      PrepareCache;
      PaintParentControls(Button, Button.SkinData.FCacheBmp.Canvas);
      UpdateCorners(FCommonData, Button.CurrentState);
      FadeTimer.Enabled := True;
      FadeTimer.DoFade;
    end;
  end;
end;

procedure StopFading(Button : TsSpeedButton);
begin
  with Button do if not (csDestroying in ComponentState) and not (csDesigning in ComponentState) then begin
    if (FadeTimer <> nil) and not (csDestroying in FadeTimer.ComponentState) then begin
      FadeTimer.Enabled := False;
      if FadeTimer.FadeLevel <> 0 then begin
        FCommonData.BGChanged := True;
        Repaint;
      end;
    end;
  end;
  if Assigned(Button.FadeTimer)
    then FreeAndNil(Button.FadeTimer);
end;

procedure DoChangePaint(Button : TsSpeedButton; Clicked : boolean; AllowAnimation : boolean; Direction : TFadeDirection = fdUp);
begin
  if not GlowingAllowed(Button) or (Button.FCommonData = nil) then Exit;

  if AllowAnimation and not aSkinchanging and Button.FCommonData.Skinned and Button.FCommonData.SkinManager.gd[Button.FCommonData.SkinIndex].FadingEnabled and
       not FadingForbidden and not Button.FCommonData.BGChanged then begin
    Button.FCommonData.BGChanged := True;
    StartFade(Button, Clicked)
  end
  else begin
    Button.FCommonData.BGChanged := True;
    if (Button.FadeTimer <> nil) and (Button.FadeTimer.Enabled) then StopFading(Button);
    Button.GraphRepaint;
  end;
  ShowGlowingIfNeeded(Button.FCommonData, Clicked);
end;

{ TsSpeedButton }

function MaxCaptionWidth(Button : TsSpeedButton) : integer;
begin
  with Button do begin
    if ShowCaption and (Caption <> '') then begin
      Result := Width - 2 * Margin - ArrowWidth;
      if Layout in [blGlyphLeft, blGlyphRight] then Result := Result - (Spacing + GlyphWidth) * integer(GlyphWidth <> 0)
    end
    else Result := 0
  end;
end;

function TsSpeedButton.ArrowWidth: integer;
begin
  Result := AddedWidth * integer(ButtonStyle = tbsDropDown);
end;

procedure TsSpeedButton.AfterConstruction;
begin
  inherited;
  FCommonData.Loaded;
  if FCommonData.Skinned then ControlStyle := ControlStyle + [csOpaque]; 
end;

function TsSpeedButton.CaptionRect: TRect;
var
  l, t, r, b : integer;
  dh, dw : integer;
  Size : TSize;
begin
  l := 0; t := 0; r := 0; b := 0;
  Size := TextRectSize;
  case Layout of
    blGlyphLeft : begin
      dw := (Width - ArrowWidth - GlyphWidth - Spacing * integer((GlyphWidth > 0) and (Caption <> '')) - Size.cx) div 2 - GenMargin;
      t := (Height - Size.cy) div 2;
      b := Height - t;
      case Alignment of
        taLeftJustify : begin
          l := Margin + GlyphWidth + Spacing * integer(GlyphWidth > 0);
          r := Width - ArrowWidth - GenMargin - dw * 2;
        end;
        taCenter : begin
          l := GenMargin + dw + GlyphWidth + Spacing * integer(GlyphWidth > 0);
          r := Width - ArrowWidth - GenMargin - dw;
        end;
        taRightJustify : begin
          l := GenMargin + 2 * dw + GlyphWidth + Spacing * integer(GlyphWidth > 0);
          r := Width - ArrowWidth - GenMargin;
        end;
      end;
      FTextLayout := DT_LEFT;
    end;
    blGlyphRight : begin
      dw := (Width - ArrowWidth - GlyphWidth - Spacing * integer((GlyphWidth > 0) and (Caption <> '')) - Size.cx) div 2 - GenMargin;
      t := (Height - Size.cy) div 2;
      b := Height - t;
      case Alignment of
        taLeftJustify : begin
          l := GenMargin;
          r := GenMargin + Size.cx
        end;
        taCenter : begin
          l := GenMargin + dw;
          r := GenMargin + dw + Size.cx
        end;
        taRightJustify : begin
          l := GenMargin + 2 * dw;
          r := GenMargin + 2 * dw + Size.cx
        end;
      end;
      FTextLayout := DT_RIGHT;
    end;
    blGlyphTop : begin
      dh := (Height - GlyphHeight - Spacing * integer((GlyphHeight > 0) and (Caption <> '')) - Size.cy) div 2 - GenMargin;
      l := (Width - Size.cx - ArrowWidth) div 2;
      t := (GenMargin + dh + GlyphHeight + Spacing * integer((GlyphHeight > 0) and (Caption <> '')));
      r := Width - l - ArrowWidth;
      b := Height - dh - GenMargin;
      FTextLayout := DT_CENTER;
    end;
    blGlyphBottom : begin
      dh := (Height - GlyphHeight - Spacing * integer((GlyphHeight > 0) and (Caption <> '')) - Size.cy) div 2 - GenMargin;
      l := (Width - Size.cx - ArrowWidth) div 2;
      t := GenMargin + dh;
      r := Width - (Width - Size.cx - ArrowWidth) div 2 - ArrowWidth;
      b := Height - dh - GenMargin - GlyphHeight - Spacing * integer((GlyphHeight > 0) and (Caption <> ''));
      FTextLayout := DT_CENTER;
    end;
  end;
  Result := Rect(l - 1 + FOffset, t, r + 2 + FOffset, b);
  if CurrentState = 2 then OffsetRect(Result, 1, 1);
end;

constructor TsSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommonData := TsCtrlSkinData.Create(Self, True);
  FCommonData.COC := COC_TsSpeedButton;
  FadeTimer := nil;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  FButtonStyle := tbsButton;
  FWordWrap := True;
  FImageIndex := -1;
  FGrayed := False;
  FBlend := 0;
  FMenuOwnerMode := False;
  FHotState := False;
  FDisabledGlyphKind := DefDisabledGlyphKind;
  FDisabledKind := DefDisabledKind;
  FOffset := 0;
  FAlignment := taCenter;
  FShowCaption := True;
  FDrawOverBorder := True;
  FTextAlignment := taCenter;
  OldOnChange := Glyph.OnChange;
  Glyph.OnChange := GlyphChanged;
  FAnimatEvents := [aeGlobalDef];
end;

function TsSpeedButton.CurrentState: integer;
begin
  if (FState in [bsDown, bsExclusive]) and not FMenuOwnerMode then Result := 2 else if ControlIsActive(FCommonData) or FHotState or FMenuOwnerMode then Result := 1 else Result := 0
end;

destructor TsSpeedButton.Destroy;
begin
  StopFading(Self);
  if (FCommonData.SkinManager <> nil) and (FCommonData.SkinManager.ActiveGraphControl = Self) then FCommonData.SkinManager.ActiveGraphControl := nil;

  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  FreeAndNil(FImageChangeLink);
  inherited Destroy;
end;

procedure TsSpeedButton.DoDrawText(var Rect: TRect; Flags: Integer);
begin
  Flags := DrawTextBiDiModeFlags(Flags) and not DT_SINGLELINE;
  if SkinData.Skinned then begin
    FCommonData.FCacheBMP.Canvas.Font.Assign(Font);
    acWriteTextEx(FCommonData.FCacheBMP.Canvas, PacChar(Caption), True, Rect, Flags, FCommonData, CurrentState <> 0);
  end
  else begin
    Canvas.Font.Assign(Font);
    Canvas.Brush.Style := bsClear;
    SelectObject(Canvas.Handle, Canvas.Font.Handle);
    if not Enabled then begin
      OffsetRect(Rect, 1, 1);
      Canvas.Font.Color := clBtnHighlight;
      acDrawText(Canvas.Handle, PacChar(Caption), Rect, Flags);
      OffsetRect(Rect, -1, -1);
      Canvas.Font.Color := clBtnShadow;
      acDrawText(Canvas.Handle, PacChar(Caption), Rect, Flags);
    end
    else acDrawText(Canvas.Handle, PacChar(Caption), Rect, Flags);
  end;
end;

procedure TsSpeedButton.DrawCaption;
var
  R, CalcRect : TRect;
begin
  if ShowCaption then begin
    FCommonData.FCacheBmp.Canvas.Font.Assign(Font);
    FCommonData.FCacheBMP.Canvas.Brush.Style := bsClear;
    R := CaptionRect;
    { Calculate vertical layout }
    CalcRect := R;
    DoDrawText(R, DT_EXPANDTABS or DT_WORDBREAK or GetStringFlags(Self, FTextAlignment));
  end;
end;

procedure TsSpeedButton.DrawGlyph;
begin
  if SkinData.Skinned
    then DrawBtnGlyph(Self, SkinData.FCacheBmp.Canvas)
    else DrawBtnGlyph(Self, Canvas);
end;

function TsSpeedButton.GenMargin: integer;
begin
  if Margin < 0 then Result := 0 else Result := Margin + 3;
end;

function TsSpeedButton.GlyphHeight: integer;
begin
  if (Glyph <> nil) and (Glyph.Height > 0) then Result := Glyph.Height else if IsImgListDefined(Self) then Result := Images.Height else Result := 0;
end;

function TsSpeedButton.GlyphWidth: integer;
begin
  if (Glyph <> nil) and (Glyph.Width > 0) then Result := Glyph.Width div NumGlyphs else if IsImgListDefined(Self) then Result := Images.Width div NumGlyphs else Result := 0;
end;

procedure TsSpeedButton.GraphRepaint;
begin
  if (csCreating in ControlState) or (csDestroying in ComponentState) or (csLoading in ComponentState) or
    not Assigned(Parent) or InAnimationProcess then Exit;
  if Parent.HandleAllocated and Visible then begin
    if not IsWindowVisible(Parent.Handle) then Exit;
    if Skindata.Skinned and not (csDesigning in ComponentState) then begin
      if Skindata.FUpdating then Exit;
      if FCommonData.BGChanged then begin
        if not PrepareCache then Exit;
        if not (csPaintCopy in ControlState) then PaintParentControls(Self, FCommonData.FCacheBmp.Canvas)
      end;
      if (FadeTimer <> nil) and FadeTimer.Enabled
        then BitBlt(Canvas.Handle, 0, 0, Width, Height, FadeTimer.TmpBmp.Canvas.Handle, 0, 0, SRCCOPY)
        else BitBlt(Canvas.Handle, 0, 0, Width, Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
    end
    else Repaint
  end;
end;

function TsSpeedButton.ImgRect: TRect;
var
  x, y : integer;
  dh, dw, gh, gw : integer;
begin
  x := 0;
  y := 0;
  Result := Rect(0, 0, 0, 0);

  gh := GlyphHeight;
  gw := GlyphWidth;

  dw := (Width - ArrowWidth - gw - Spacing * integer(ShowCaption and (gw > 0) and (Caption <> '')) - TextRectSize.cx) div 2 - GenMargin;
  dh := (Height - gh - Spacing * integer(ShowCaption and (gw > 0) and (Caption <> '')) - TextRectSize.cy) div 2 - GenMargin;
  case Layout of
    blGlyphLeft : case Alignment of
      taLeftJustify : begin
        x := GenMargin;
        y := (Height - gh) div 2;
      end;
      taCenter : begin
        x := GenMargin + dw;
        y := (Height - gh) div 2;
      end;
      taRightJustify : begin
        x := GenMargin + 2 * dw;
        y := (Height - gh) div 2;
      end;
    end;
    blGlyphRight : case Alignment of
      taLeftJustify : begin
        x := CaptionRect.Right + Spacing;
        y := (Height - gh) div 2;
      end;
      taCenter : begin
        x := (Width - ArrowWidth - gw + Spacing * integer(ShowCaption and (gw > 0) and (Caption <> '')) + TextRectSize.cx) div 2;
        y := (Height - gh) div 2;
      end;
      taRightJustify : begin
        x := Width - ArrowWidth - gw - GenMargin;
        y := (Height - gh) div 2;
      end;
    end;
    blGlyphTop : begin
      x := (Width - ArrowWidth - gw) div 2 + 1;
      y := GenMargin + dh;
    end;
    blGlyphBottom : begin
      x := (Width - ArrowWidth - gw) div 2 + 1;
      y := Height - GenMargin - dh - gh;
    end;
  end;
  if CurrentState = 2 then begin
    inc(x);
    inc(y);
  end;
  Result := Rect(x, y, x + gw, y + gh);
  if Reflected then OffsetRect(Result, 0, - HeightOf(Result) div 6);
end;

procedure TsSpeedButton.Loaded;
begin
  inherited;
  FCommonData.Loaded;
  if FCommonData.Skinned then ControlStyle := ControlStyle + [csOpaque];
  if IsImgListDefined(Self) then Glyph.Assign(nil);
end;

type
  TAccessControl = class(TCustomControl);

procedure TsSpeedButton.Paint;
var
  R : TRect;
  ParentDC : hdc;
begin
  if Assigned(FCommonData.SkinManager) and FCommonData.SkinManager.Active and (FCommonData.SkinIndex < 1) then FCommonData.UpdateIndexes;
  if not FCommonData.Skinned then StdPaint else begin
    if (width < 1) or (height < 1) then Exit;
    if Assigned(FadeTimer) and FadeTimer.Enabled and Assigned(FadeTimer.TmpBmp) and (FadeTimer.TmpBmp.Width = Width) then begin
      BitBlt(Canvas.Handle, 0, 0, Width, Height, FadeTimer.TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    end
    else begin
{$IFDEF D2005}
      if CurrentState > 0 then FCommonData.BGChanged := True else
{$ENDIF}
      FCommonData.BGChanged := (FStoredDown <> Down) or FCommonData.BGChanged or FCommonData.HalfVisible;
      FStoredDown := Down;

      if Parent <> nil then begin
        ParentDC := GetWindowDC(Parent.Handle);
        if (GetClipBox(ParentDC, R) = 0) or IsRectEmpty(R) or (WidthOF(R) < (Left + Width)) or (HeightOF(R) < (Top + Height)) or (Top < 0) or (Left < 0)
          then FCommonData.HalfVisible := True
          else FCommonData.HalfVisible := False;
        ReleaseDC(Parent.Handle, ParentDC)
      end
      else FCommonData.HalfVisible := False;

      if not FCommonData.BGChanged then begin
        if (FOldNumGlyphs <> NumGlyphs) then begin
          FCommonData.BGChanged := True;
          FOldNumGlyphs := NumGlyphs;
        end
        else if (FOldSpacing <> Spacing) then begin
          FCommonData.BGChanged := True;
          FOldSpacing := Spacing;
        end;
      end
      else begin
        FOldNumGlyphs := NumGlyphs;
        FOldSpacing := Spacing;
      end;
      if FCommonData.BGChanged and not FCommonData.UrgentPainting
        then if not PrepareCache then Exit;
      BitBlt(Canvas.Handle, 0, 0, Width, Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
    end;
  end;
end;

function TsSpeedButton.PrepareCache : boolean;
var
  CI : TCacheInfo;
  si, mi, w : integer;
  Mode, x, y : integer;
  R : TRect;
  BGInfo : TacBGInfo;
begin
  if Self = nil then Exit;
  Result := True;
  GetBGInfo(@BGInfo, Parent);
  if BGInfo.BgType = btNotReady then begin
    FCommonData.FUpdating := True;
    Result := False;
    Exit;
  end;
  CI := BGInfoToCI(@BGInfo);

  InitCacheBmp(SkinData);
  FCommonData.FCacheBmp.Canvas.Font.Assign(Font);

  if CI.Ready and (CI.Bmp.Width = 0) then Exit;

  case FButtonStyle of
    tbsDivider: begin
      if CI.Ready
        then BitBlt(FCommonData.FCacheBMP.Canvas.Handle, 0, 0, Width, Height, CI.Bmp.Canvas.Handle, Left + CI.X, Top + CI.Y, SRCCOPY)
        else FillDC(FCommonData.FCacheBMP.Canvas.Handle, ClientRect, CI.FillColor);
      si := FCommonData.SkinManager.GetSkinIndex(s_Divider);
      if FCommonData.SkinManager.IsValidSkinIndex(si) then begin
        mi := FCommonData.SkinManager.GetMaskIndex(si, s_Divider, s_BordersMask);
        if Assigned(FCommonData.SkinManager) and FCommonData.SkinManager.IsValidImgIndex(mi) then begin
          w := Width div 2 - 1;
          DrawSkinRect(FCommonData.FCacheBmp, Rect(w, 0, w + 2, Height), True, CI, FCommonData.SkinManager.ma[mi], 0, False);
        end;
      end
      else begin
      end;
    end;
    tbsSeparator: begin
      if CI.Ready
        then BitBlt(FCommonData.FCacheBMP.Canvas.Handle, 0, 0, Width, Height, CI.Bmp.Canvas.Handle, Left, Top, SRCCOPY)
        else FillDC(FCommonData.FCacheBMP.Canvas.Handle, ClientRect, CI.FillColor);
    end
    else begin
      if FButtonStyle = tbsDropDown then begin
        x := FCommonData.HUEOffset;
        y := FCommonData.Saturation;
        FCommonData.FHUEOffset := 0;
        FCommonData.FSaturation := 0;
        if ((Assigned(DropDownMenu) and DroppedDown) or Down or (FState in [bsDown, bsExclusive])) then Mode := 2 else if ControlIsActive(FCommonData) then Mode := 1 else Mode := 0;

        // Paint BG
        PaintItemBG(FCommonData, ci, Mode, Rect(Width - ArrowWidth, 0, Width, Height), Point(Left + Width - ArrowWidth, Top), FCommonData.FCacheBMP, integer(Down), integer(Down));
        inc(ci.X, Left);
        inc(ci.Y, Top);
        if FCommonData.SkinManager.IsValidImgIndex(FCommonData.BorderIndex) then DrawSkinRect(FCommonData.FCacheBMP, Rect(Width - ArrowWidth, 0, Width, Height), True, ci, FCommonData.SkinManager.ma[FCommonData.BorderIndex], Mode, True);
        dec(ci.X, Left);
        dec(ci.Y, Top);

        FCommonData.FHUEOffset := x;
        FCommonData.FSaturation := y;

        R.Left := Width - ArrowWidth;
        R.Right := Width;
        R.Top := 0;
        R.Bottom := Height;

        si := GetFontIndex(Self, FCommonData.SkinIndex, FCommonData.SkinManager, Mode); // Receive parent font if needed
        case Mode of
          2 : OffsetRect(R, 1, 1);
        end;

        if si >= 0
          then DrawColorArrow(FCommonData.FCacheBmp.Canvas, FCommonData.SkinManager.gd[si].Props[min(integer(Mode > 0), FCommonData.SkinManager.gd[si].States - 1)].FontColor.Color, R, BF_BOTTOM)
          else DrawColorArrow(FCommonData.FCacheBmp.Canvas, Font.Color, R, BF_BOTTOM);
      end
      else Mode := CurrentState;
      if not FDrawOverBorder then begin
        PaintItemBG(FCommonData, ci, Mode, Rect(0, 0, Width - ArrowWidth, Height), Point(Left, Top), FCommonData.FCacheBMP, integer(Down), integer(Down));
        DrawCaption;
        DrawGlyph;
        inc(ci.X, Left);
        inc(ci.Y, Top);
        if FCommonData.SkinManager.IsValidImgIndex(FCommonData.BorderIndex) then DrawSkinRect(FCommonData.FCacheBMP, Rect(0, 0, Width - ArrowWidth, Height), True, ci, FCommonData.SkinManager.ma[FCommonData.BorderIndex], Mode, False);
      end
      else begin
        PaintItem(FCommonData, CI, True, Mode, Rect(0, 0, Width - ArrowWidth, Height), Point(Left, Top), FCommonData.FCacheBMP, True, integer(Down), integer(Down));
        DrawCaption;
        DrawGlyph;
      end;
      if not Enabled then begin
        CI := GetParentCache(FCommonData);
        BmpDisabledKind(FCommonData.FCacheBmp, FDisabledKind, Parent, CI, Point(Left, Top));
      end;
      if Assigned(FOnPaint) then FOnPaint(Self, FCommonData.FCacheBmp);
    end;
  end;
  FCommonData.BGChanged := False;
end;

procedure TsSpeedButton.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetBlend(const Value: integer);
begin
  if FBlend <> Value then begin
    if Value < 0 then FBlend := 0 else if Value > 100 then FBlend := 100 else FBlend := Value;
    if (Visible or (csDesigning in ComponentState)) and (SkinData.CtrlSkinState and ACS_LOCKED <> ACS_LOCKED) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetButtonStyle(const Value: TToolButtonStyle);
begin
  if FButtonStyle <> Value then begin
    if not (csLoading in ComponentState) then begin
      if Value = tbsDropDown then Width := Width + AddedWidth else if FButtonStyle = tbsDropdown then Width := Width - AddedWidth;
    end;
    FButtonStyle := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetDisabledGlyphKind(const Value: TsDisabledGlyphKind);
begin
  if FDisabledGlyphKind <> Value then begin
    FDisabledGlyphKind := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetDisabledKind(const Value: TsDisabledKind);
begin
  if FDisabledKind <> Value then begin
    FDisabledKind := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetGrayed(const Value: boolean);
begin
  if FGrayed <> Value then begin
    FGrayed := Value;
    if (Visible or (csDesigning in ComponentState)) and (SkinData.CtrlSkinState and ACS_LOCKED <> ACS_LOCKED) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetImageIndex(const Value: integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    if (Visible or (csDesigning in ComponentState)) and (SkinData.CtrlSkinState and ACS_LOCKED <> ACS_LOCKED) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then begin
    if Images <> nil then Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if Images <> nil then begin
      Images.RegisterChanges(FImageChangeLink);
      Images.FreeNotification(Self);
    end;
    if (Visible or (csDesigning in ComponentState)) and (SkinData.CtrlSkinState and ACS_LOCKED <> ACS_LOCKED) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetOffset(const Value: Integer);
begin
  if (FOffset <> Value) then begin
    FOffset := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.SetShowCaption(const Value: boolean);
begin
  if FShowCaption <> Value then begin
    FShowCaption := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

function TsSpeedButton.TextRectSize: TSize;
var
  R : TRect;
  Flag : Cardinal;
begin
  R := Rect(0, 0, MaxCaptionWidth(Self), 0);
  if FWordWrap then
    Flag := DT_WORDBREAK
  else
    Flag := DT_SINGLELINE;
  acDrawText(FCommonData.FCacheBMP.Canvas.Handle, Caption, R, Flag or DT_EXPANDTABS or DT_CALCRECT);
  Result.cy := HeightOf(R);
  Result.cx := WidthOf(R);
end;

procedure TsSpeedButton.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_CTRLHANDLED : begin Message.Result := 1; Exit end;
    AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
    AC_SETNEWSKIN : if (ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager)) then begin
      CommonWndProc(Message, FCommonData);
      if FCommonData.Skinned then ControlStyle := ControlStyle + [csOpaque];
      Exit;
    end;
    AC_REMOVESKIN : if (ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager)) and not (csDestroying in ComponentState) then begin
      CommonWndProc(Message, FCommonData);
      ControlStyle := ControlStyle - [csOpaque];
      if Visible then Repaint;
    end;
    AC_ENDPARENTUPDATE : begin
      if not InUpdating(FCommonData, True) then begin
//        FCommonData.BGChanged := True;
        GraphRepaint;
      end;
      Exit;
    end;
    AC_REFRESH : if (ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager)) then begin
      CommonWndProc(Message, FCommonData);
      if Visible then RePaint;
      exit
    end;
    AC_INVALIDATE : begin
      FCommonData.FUpdating := False;
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
    AC_MOUSELEAVE : begin
      Ac_CMMouseLeave;
      Exit;
    end;
  end;
  if not ControlIsReady(Self) or (FCommonData = nil) or not FCommonData.Skinned then begin
    case Message.Msg of
      CM_MOUSEENTER : if Enabled and not (csDesigning in ComponentState) then begin
        if Assigned(FCommonData) then FCommonData.FMouseAbove := True;
        if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
      end;
      CM_MOUSELEAVE : if Enabled and not (csDesigning in ComponentState) then begin
        if Assigned(FCommonData) then FCommonData.FMouseAbove := False;
        if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
        if bsDown = FState then FState := bsUp;
      end;
    end;
    inherited
  end
  else begin
    if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
      AC_UPDATESECTION : begin GraphRepaint; Exit end;
      AC_STOPFADING : begin StopFading(Self); Exit end;
      AC_PREPARING : begin
        Message.Result := integer(FCommonData.FUpdating);
        Exit;
      end;
    end
    else case Message.Msg of
      CM_MOUSEENTER : if Enabled and not MouseInControl and not (csDesigning in ComponentState) then begin
        Ac_CMMouseEnter;
        inherited;
        Exit;
      end;
      WM_MOUSELEAVE, CM_MOUSELEAVE : if Enabled then begin
        Ac_CMMouseLeave;
        inherited;
        Exit;
      end;
      WM_ERASEBKGND : Exit;
{$IFNDEF DYNAMICCACHE}
      CM_TEXTCHANGED : if ShowCaption then begin
        FCommonData.BGChanged := True;
        GraphRepaint;
        Exit;
      end;
{$ENDIF}
      WM_WINDOWPOSCHANGED, WM_SIZE : begin
        if Visible then FCommonData.BGChanged := True;
      end;
      WM_LBUTTONDBLCLK, WM_LBUTTONDOWN : if not (csDesigning in ComponentState) then begin
        if FMenuOwnerMode then Exit;
      end;
      WM_LBUTTONUP : if not (csDesigning in ComponentState) then begin
        if FMenuOwnerMode then Exit;
        if Assigned(FadeTimer) and FadeTimer.Enabled and Assigned(FadeTimer.TmpBmp) and (FadeTimer.TmpBmp.Width = Width) then begin
          StopFading(Self);
          PrepareCache;
          GraphRepaint; // Fast repainting if clicked quickly
        end;
      end;
      CM_VISIBLECHANGED : begin
        FCommonData.BGChanged := True;
        SkinData.FMouseAbove := False
      end;
    end;
    CommonWndProc(Message, FCommonData);
    inherited;
    case Message.Msg of
      WM_MOUSEMOVE : begin
        if SkinData.FMouseAbove then begin
          if (FCommonData.SkinManager.ActiveGraphControl <> Self) then begin
            SkinData.FMouseAbove := False;
            Ac_CMMouseEnter;
            Perform(CM_MOUSEENTER, 0, 0);
          end;
        end;
      end;
      CM_BUTTONPRESSED : begin // If changed when GroupIndex <> 0
        FCommonData.BGChanged := True;
        GraphRepaint;
      end;
      CM_FONTCHANGED : if FCommonData.CustomFont then begin // If changed when GroupIndex <> 0
        FCommonData.BGChanged := True;
        GraphRepaint;
      end;
      WM_LBUTTONDBLCLK, WM_LBUTTONDOWN : if not (csDesigning in ComponentState) then begin
        DoChangePaint(Self, True, EventEnabled(aeMouseDown, FAnimatEvents));
      end;
      WM_LBUTTONUP : if Visible and not (csDesigning in ComponentState) and not (csDestroying in ComponentState) then begin
        DoChangePaint(Self, True, EventEnabled(aeMouseUp, FAnimatEvents));
      end
      else begin
        Message.Result := -1;
      end;
      CM_ENABLEDCHANGED : if (Visible or (csDesigning in ComponentState)) then begin
        if not Enabled then StopFading(Self);
        FCommonData.BGChanged := True;
        if not (csLoading in ComponentState) then GraphRepaint;
        Exit;
      end;
      WM_MOVE : begin
        if (csDesigning in ComponentState) and not SkinData.Updating then Repaint
      end;
      WM_SIZE, WM_WINDOWPOSCHANGED : if (csDesigning in ComponentState) and not SkinData.Updating then begin
        GraphRepaint;
      end;
    end;
  end;
end;

procedure TsSpeedButton.SetDropdownMenu(const Value: TPopupMenu);
begin
  if Value <> FDropdownMenu then begin
    FDropdownMenu := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

procedure TsSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  c : TMouse;
begin
  if not ShowHintStored then begin
    AppShowHint := Application.ShowHint;
    Application.ShowHint := False;
    ShowHintStored := True;
  end;

  if (Button = mbLeft) and Enabled then begin
    if (ButtonStyle = tbsDropDown) and Assigned(DropDownMenu) and ((X > Width - AddedWidth) or not Assigned(OnCLick)) then begin
      TempControl := pointer(Self);

      c := nil;

      StopFading(Self);

      if not MenuVisible then begin
        if SkinData.SkinManager <> nil then SkinData.SkinManager.SkinableMenus.HookPopupMenu(DropDownMenu, SkinData.SkinManager.Active);
        MenuVisible := True;
        DroppedDown := True;
        FCommonData.BGChanged := True;
        if not Assigned(OnCLick) then FState := bsDown;
        GraphRepaint;
        p := ClientToScreen(Point(0, Height + 1));
        DropDownMenu.PopupComponent := Self;
        DropDownMenu.Popup(p.X, p.Y);
        DroppedDown := False;
        MenuVisible := False;
        TempControl := nil;

        if not PtInRect(Rect(p.x, p.y - Height - 1, p.x + Width, p.y - 1), c.CursorPos) then begin
          Perform(CM_MOUSELEAVE, 0, 0);
        end;

        if not Assigned(OnCLick) then FState := bsUp;
        if not SkinData.Skinned then Repaint;                     
      end;
    end
    else inherited;
  end else inherited;
end;

procedure TsSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (csDestroying in ComponentState) then begin
    Application.ShowHint := AppShowHint;
    ShowHintStored := False;
    if (Button = mbLeft)  and Enabled and (ButtonStyle = tbsDropDown) then begin
      DroppedDown := False;
      TempControl := nil;
      inherited;
    end
    else inherited;
  end;
end;

procedure TsSpeedButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then begin
    if (AComponent = Images)
      then Images := nil
      else if (AComponent = DropDownMenu) then DropDownMenu := nil;
  end;
end;

procedure TsSpeedButton.SetDrawOverBorder(const Value: boolean);
begin
  if FDrawOverBorder <> Value then begin
    FDrawOverBorder := Value;
    if Visible or (csDesigning in ComponentState) then begin
      FCommonData.BGChanged := True;
      GraphRepaint;
    end;
  end;
end;

procedure TsSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
var
  b : boolean;
begin
  inherited ActionChange(Sender, CheckDefaults);
  if not (csLoading in ComponentState) then begin
    if (TCustomAction(Sender).ActionList <> nil) and (Images = nil) then begin
      Images := TCustomAction(Sender).ActionList.Images;
      b := True;
    end
    else b := False;
    if ImageIndex = -1 then begin
      ImageIndex := TCustomAction(Sender).ImageIndex;
      b := True;
    end;
    if b and (Images <> nil) and (ImageIndex >= 0) and (ImageIndex < GetImageCount(Images)) then Glyph.Assign(nil); // Remove this line in Beta
    if not (csDestroying in ComponentState) then FCommonData.Invalidate;
  end;
end;

procedure TsSpeedButton.GlyphChanged(Sender: TObject);
begin
  if Assigned(OldOnChange) then OldOnChange(Glyph);
  if not (csLoading in ComponentState) and not (csDestroying in ComponentState) and not (csCreating in ControlState) then FCommonData.Invalidate;
end;

procedure TsSpeedButton.SetTextAlignment(const Value: TAlignment);
begin
  if FTextAlignment <> Value then begin
    FTextAlignment := Value;
    Repaint
  end;
end;

procedure TsSpeedButton.SetWordWrap(const Value: boolean);
begin
  if FWordWrap <> Value then begin
    FWordWrap := Value;
    FCommonData.BGChanged := True;
    GraphRepaint;
  end;
end;

procedure TsSpeedButton.Ac_CMMouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
  if not FCommonData.FMouseAbove and not (ButtonStyle in [tbsDivider, tbsSeparator]) then begin
    FCommonData.FMouseAbove := True;
    FCommonData.SkinManager.ActiveGraphControl := Self;
    if not FMenuOwnerMode
      then DoChangePaint(Self, False, EventEnabled(aeMouseEnter, FAnimatEvents))
      else FCommonData.BGChanged := True;
  end;
end;

type
  TAccessManager = class (TsSkinManager);

procedure TsSpeedButton.Ac_CMMouseLeave;
begin
  if FCommonData.FMouseAbove then begin
    if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
    FCommonData.FMouseAbove := False;
    if TAccessManager(FCommonData.SkinManager).FActiveGraphControl = Self then TAccessManager(FCommonData.SkinManager).FActiveGraphControl := nil;
    if bsDown = FState then FState := bsUp;
    if Visible and not FMenuOwnerMode
      then DoChangePaint(Self, False, EventEnabled(aeMouseLeave, FAnimatEvents))
      else FCommonData.BGChanged := True;
  end;
end;

procedure TsSpeedButton.Invalidate;
begin
  if (OldLayout <> Layout) then begin
    OldLayout := Layout;
    FCommonData.BGChanged := True;
  end;
  inherited;
end;

procedure TsSpeedButton.StdPaint(PaintButton : boolean = True);
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
  ArrowPoints: array of TPoint;
{$IFDEF DELPHI7UP}
  Button: TThemedButton;
  ToolButton: TThemedToolBar;
  Details: TThemedElementDetails;
{$ENDIF}
begin
  Canvas.Lock;
  if not Enabled then FState := bsDisabled else if FState = bsDisabled then if Down and (GroupIndex <> 0) then FState := bsExclusive else FState := bsUp;
  Canvas.Font.Assign(Font);
  case ButtonStyle of
    tbsDivider : begin
{$IFDEF DELPHI7UP}
      PaintRect := ClientRect;
      PaintRect.Left := WidthOf(PaintRect) div 2 - 1;
      if ThemeServices.ThemesEnabled then begin
        PaintRect.Right := PaintRect.Left + 4;
        PerformEraseBackground(Self, Canvas.Handle);
        ToolButton := ttbSeparatorNormal;
        Details := ThemeServices.GetElementDetails(ToolButton);
        ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
      end
      else
{$ENDIF}
      begin
        PaintRect.Right := PaintRect.Left + 2;
        DrawEdge(Canvas.Handle, PaintRect, BDR_SUNKENOUTER, BF_RECT);
      end;
    end;
    tbsSeparator : begin
    end
    else begin
      if PaintButton then begin
        if ButtonStyle = tbsDropDown then begin
          PaintRect := ClientRect;
          PaintRect.Right := PaintRect.Right - ArrowWidth;
        end
        else PaintRect := ClientRect;
{$IFDEF DELPHI7UP}
        if ThemeServices.ThemesEnabled then begin
          PerformEraseBackground(Self, Canvas.Handle);
                                             
          if not Enabled
            then Button := tbPushButtonDisabled
            else if FState in [bsDown, bsExclusive]
              then Button := tbPushButtonPressed
              else if MouseInControl
                then Button := tbPushButtonHot
                else Button := tbPushButtonNormal;
                
          ToolButton := ttbToolbarDontCare;
          if Flat then case Button of
            tbPushButtonDisabled: Toolbutton := ttbButtonDisabled;
            tbPushButtonPressed:  Toolbutton := ttbButtonPressed;
            tbPushButtonHot:      Toolbutton := ttbButtonHot;
            tbPushButtonNormal:   Toolbutton := ttbButtonNormal;
          end;
          if ToolButton = ttbToolbarDontCare then begin
            Details := ThemeServices.GetElementDetails(Button);
            ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
            PaintRect := ThemeServices.ContentRect(Canvas.Handle, Details, PaintRect);
          end
          else begin
            Details := ThemeServices.GetElementDetails(ToolButton);
            ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
            PaintRect := ThemeServices.ContentRect(Canvas.Handle, Details, PaintRect);
          end;
          if ButtonStyle = tbsDropDown then begin
            PaintRect := ClientRect;
            PaintRect.Left := PaintRect.Right - ArrowWidth;

            if ((Assigned(DropDownMenu) and DroppedDown) or Down or (FState in [bsDown, bsExclusive])) then begin
              if ToolButton = ttbToolbarDontCare then begin
                Button := tbPushButtonPressed;
                Details := ThemeServices.GetElementDetails(Button);
              end
              else begin
                ToolButton := ttbButtonPressed;
                Details := ThemeServices.GetElementDetails(ToolButton);
              end;
            end;

            ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
            SetLength(ArrowPoints, 3);
            ArrowPoints[0] := Point((WidthOf(PaintRect) - 5) div 2 + PaintRect.Left + integer(Toolbutton = ttbButtonPressed), (HeightOf(PaintRect) - 5) div 2 + PaintRect.Top + integer(Toolbutton = ttbButtonPressed));
            ArrowPoints[1] := Point(ArrowPoints[0].X + 5, ArrowPoints[0].Y);
            ArrowPoints[2] := Point(ArrowPoints[0].X + 2, ArrowPoints[0].Y + 5);
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := clBtnText;
            Canvas.Pen.Color := clBtnText;
            Canvas.Polygon(ArrowPoints);
          end;

          if Button = tbPushButtonPressed then begin
            // A pressed speed button has a white text. This applies however only to flat buttons.
//            if ToolButton <> ttbToolbarDontCare then Canvas.Font.Color := clHighlightText;
            Offset := Point(1, 0);
          end
          else Offset := Point(0, 0);
        end
        else
{$ENDIF}
        begin
          if not Flat then begin
            DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
            if FState in [bsDown, bsExclusive] then DrawFlags := DrawFlags or DFCS_PUSHED;
            DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
          end
          else begin
            if (FState in [bsDown, bsExclusive]) or (MouseInControl and (FState <> bsDisabled)) or (csDesigning in ComponentState)
              then DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]], FillStyles[Transparent] or BF_RECT)
              else if not Transparent then begin
                Canvas.Brush.Color := Color;
                Canvas.FillRect(PaintRect);
              end;
            InflateRect(PaintRect, -1, -1);
          end;
          if FState in [bsDown, bsExclusive] then begin
            if (FState = bsExclusive) and (not Flat or not MouseInControl) then begin
              Canvas.Brush.Bitmap := AllocPatternBitmap(clBtnFace, clBtnHighlight);
              Canvas.FillRect(PaintRect);
            end;
            Offset := Point(1, 1);
          end
          else Offset := Point(0, 0);

          if ButtonStyle = tbsDropDown then begin
            PaintRect := ClientRect;
            PaintRect.Left := PaintRect.Right - ArrowWidth;

            if ((Assigned(DropDownMenu) and DroppedDown) or Down or (FState in [bsDown, bsExclusive])) then begin
              if not Flat then begin
                DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT or DFCS_PUSHED;
                DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
              end
              else begin
                DrawEdge(Canvas.Handle, PaintRect, DownStyles[True], FillStyles[Transparent] or BF_RECT)
              end;
            end
            else begin
              if not Flat then begin
                DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
                DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
              end
              else begin
                if MouseInControl then DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]], FillStyles[Transparent] or BF_RECT)
              end;
            end;

            SetLength(ArrowPoints, 3);
            ArrowPoints[0] := Point((WidthOf(PaintRect) - 5) div 2 + PaintRect.Left + integer(FState in [bsDown, bsExclusive]), (HeightOf(PaintRect) - 5) div 2 + PaintRect.Top + integer(FState in [bsDown, bsExclusive]));
            ArrowPoints[1] := Point(ArrowPoints[0].X + 5, ArrowPoints[0].Y);
            ArrowPoints[2] := Point(ArrowPoints[0].X + 2, ArrowPoints[0].Y + 5);
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := clBtnText;
            Canvas.Pen.Color := clBtnText;
            Canvas.Polygon(ArrowPoints);
          end;
        end;
      end;

      DrawCaption;
      DrawGlyph;
    end;
  end;
  Canvas.UnLock;
end;

procedure TsSpeedButton.SetReflected(const Value: boolean);
begin
  if FReflected <> Value then begin
    FReflected := Value;
    FCommonData.BGChanged := True;
    GraphRepaint;
  end;
end;

procedure TsSpeedButton.ImageListChange(Sender: TObject);
begin
  if SkinData.Skinned then begin
    SkinData.BGChanged := True;
    GraphRepaint
  end
  else Repaint;
end;

{ TsTimerSpeedButton }

constructor TsTimerSpeedButton.Create(AOwner: TComponent);
begin
  inherited;
  Width := Height - 4;
end;

end.
