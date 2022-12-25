unit sGroupBox;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {$IFNDEF DELPHI5}Types, {$ENDIF}
  {$IFDEF TNTUNICODE}TntGraphics, TntControls, TntActnList, TntClasses,
  TntSysUtils, TntForms, TntStdCtrls,{$ENDIF} {$IFDEF DELPHI7UP}Themes, {$ENDIF}
  StdCtrls, sCommonData, sRadioButton, sConst;

type
  TsCaptionLayout = (clTopLeft, clTopCenter, clTopRight);

  TacIntProperty = 0..MaxInt;

  TsMargin = class(TPersistent)
  private
    FControl: TControl;
    FLeft, FTop, FRight, FBottom: TacIntProperty;
    procedure SetMargin(Index: Integer; Value: TacIntProperty);
  public
    constructor Create(Control: TControl);
    procedure Invalidate;
  published
    property Left: TacIntProperty index 0 read FLeft write SetMargin default 2;
    property Top: TacIntProperty index 1 read FTop write SetMargin default 0;
    property Right: TacIntProperty index 2 read FRight write SetMargin default 2;
    property Bottom: TacIntProperty index 3 read FBottom write SetMargin default 0;
  end;

{$IFDEF TNTUNICODE}
  TsGroupBox = class(TTntGroupBox)
{$ELSE}
  TsGroupBox = class(TGroupBox)
{$ENDIF}
{$IFNDEF NOTFORHELP}
  private
    FCaptionLayout: TsCaptionLayout;
    FCaptionYOffset: integer;
    FCommonData: TsCommonData;
    FCaptionSkin: TsSkinSection;
    FCaptionMargin: TsMargin;
    FCaptionWidth : TacIntProperty;
    procedure SetCaptionLayout(const Value: TsCaptionLayout);
    procedure SetCaptionYOffset(const Value: integer);
    procedure WMFontChanged(var Message : TMessage); message CM_FONTCHANGED;
    procedure SetCaptionSkin(const Value: TsSkinSection);
    procedure SetCaptionWidth(const Value: TacIntProperty);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    function TextHeight : integer;
    procedure WndProc (var Message: TMessage); override;
  public
    procedure AfterConstruction; override;
    procedure Loaded; override;
    function CaptionRect: TRect;
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure PaintToDC(DC : hdc);
    procedure PrepareCache;
    procedure WriteText(R : TRect; CI : TCacheInfo);
  published
{$ENDIF} // NOTFORHELP
    property CaptionLayout : TsCaptionLayout read FCaptionLayout write SetCaptionLayout default clTopLeft;
    property CaptionMargin : TsMargin read FCaptionMargin write FCaptionMargin;
    property CaptionYOffset : integer read FCaptionYOffset write SetCaptionYOffset default 0;
    property SkinData : TsCommonData read FCommonData write FCommonData;
    property CaptionSkin : TsSkinSection read FCaptionSkin write SetCaptionSkin;
    property CaptionWidth : TacIntProperty read FCaptionWidth write SetCaptionWidth default 0;
{$IFDEF D2010}
    property Touch;
{$ENDIF}
  end;

{$IFNDEF NOTFORHELP}
  TacIndexChangingEvent = procedure(Sender: TObject; NewIndex: Integer; var AllowChange: Boolean) of object;
{$ENDIF}

  TsRadioGroup = class(TsGroupBox)
{$IFNDEF NOTFORHELP}
  private
    FOnChanging : TacIndexChangingEvent;
    FItems: {$IFDEF TNTUNICODE}TTntStrings;{$ELSE}TStrings;{$ENDIF}
    FAnimatEvents : TacAnimatEvents;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    FShowFocus : boolean;
    procedure ArrangeButtons;
    procedure ButtonClick(Sender: TObject);
    procedure ItemsChange(Sender: TObject);
    procedure SetButtonCount(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure UpdateButtons;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetButtons(Index: Integer): TsRadioButton;
    procedure SetItems(Value: {$IFDEF TNTUNICODE}TTntStrings{$ELSE}TStrings{$ENDIF});
  protected
    procedure ReadState(Reader: TReader); override;
    procedure WndProc (var Message: TMessage); override;
  public
    FButtons: TList;
    procedure Loaded; override;
    function CanModify(NewIndex : integer): Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FlipChildren(AllLevels: Boolean); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    property Buttons[Index: Integer]: TsRadioButton read GetButtons;
  published
    property AnimatEvents : TacAnimatEvents read FAnimatEvents write FAnimatEvents default [aeGlobalDef];
{$ENDIF} // NOTFORHELP
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
{$IFDEF TNTUNICODE}
    property Items: TTntStrings read FItems write SetItems;
{$ELSE}
    property Items: TStrings read FItems write SetItems;
{$ENDIF}
    property ShowFocus : boolean read FShowFocus write FShowFocus default True;
    property OnChanging: TacIndexChangingEvent read FOnChanging write FOnChanging;
  end;

implementation

uses acntUtils, sMessages, sVCLUtils, sMaskData, sGraphUtils, salphaGraph, {$IFDEF TNTUNICODE}TntWindows, {$ENDIF}
  ComCtrls, sSkinProps, sStyleSimply, sSKinManager
  {$IFDEF LOGGED}, sDebugMsgs{$ENDIF};

{ TsGroupBox }

procedure TsGroupBox.AdjustClientRect(var Rect: TRect);
begin
  if not (csDestroying in ComponentState) then begin
    inherited AdjustClientRect(Rect);
    Inc(Rect.Top, CaptionYOffset);
  end;
end;

procedure TsGroupBox.AfterConstruction;
begin
  inherited;
  FCommonData.Loaded;
end;

function TsGroupBox.CaptionRect: TRect;
const
  xOffset = 6;
var
  aRect : TRect;
  aTextWidth: Integer;
  Margin : integer;
begin
  aRect.Top := 0;
  if FCommonData.Skinned then begin
    aRect.Bottom := aRect.Top + TextHeight + FCaptionYOffset + FCaptionmargin.Top + FCaptionmargin.Bottom;
    if FCaptionYOffset < 0 then inc(aRect.Top, FCaptionYOffset);
  end
  else aRect.Bottom := aRect.Top + TextHeight + FCaptionmargin.Top + FCaptionmargin.Bottom;

  Margin := FCaptionmargin.Left + FCaptionmargin.Right;

  if Captionwidth = 0 then begin
    aTextWidth := acTextWidth(FCommonData.FCacheBmp.Canvas, Caption);
    if FCaptionLayout = clTopCenter then aRect.Left := (Width - aTextWidth - Margin - xOffset) div 2 else begin
      if ((FCaptionLayout = clTopLeft) and not UseRightToLeftAlignment) or ((FCaptionLayout = clTopRight) and UseRightToLeftAlignment)
        then aRect.Left := xOffset
        else aRect.Left := Width - aTextWidth - 2 * Margin - xOffset;
    end;
    if aRect.Left < 0 then aRect.Left := 0;
    aRect.Right := aRect.Left + aTextWidth + 2 * Margin;
    if aRect.Right > Width then aRect.Right := Width;
    if WidthOf(aRect) < 2 * BevelWidth then begin
      aRect.Left := aRect.Left - BevelWidth;
      aRect.Right := aRect.Right + BevelWidth;
    end;
  end
  else begin
    aTextWidth := CaptionWidth;
    if FCaptionLayout = clTopCenter then aRect.Left := (Width - aTextWidth - xOffset) div 2 else begin
      if ((FCaptionLayout = clTopLeft) and not UseRightToLeftAlignment) or ((FCaptionLayout = clTopRight) and UseRightToLeftAlignment)
        then aRect.Left := xOffset + FCaptionmargin.Left
        else aRect.Left := Width - aTextWidth - xOffset - FCaptionmargin.Right;
    end;
    if aRect.Left < 0 then aRect.Left := 0;
    aRect.Right := aRect.Left + aTextWidth + FCaptionmargin.Left;
    if aRect.Right > Width then aRect.Right := Width;
    if WidthOf(aRect) < 2 * BevelWidth then begin
      aRect.Left := aRect.Left - BevelWidth;
      aRect.Right := aRect.Right + BevelWidth;
    end;
  end;

  Result := aRect;
end;

constructor TsGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque];
  FCommonData := TsCommonData.Create(Self, True);
  FCommonData.COC := COC_TsGroupBox;
  FCaptionLayout := clTopLeft;
  FCaptionYOffset := 0;
  FCaptionMargin := TsMargin.Create(Self);
  FCaptionWidth := 0;
end;

destructor TsGroupBox.Destroy;
begin
  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  FCaptionMargin.Free;
  inherited Destroy;
end;

procedure TsGroupBox.Loaded;
begin
  inherited;
  FCommonData.Loaded;
end;

procedure TsGroupBox.Paint;
begin
  if FCommonData.Skinned(True) then PaintToDC(Canvas.Handle) else inherited;
end;

procedure TsGroupBox.PaintToDC(DC : hdc);
var
  b : boolean;
{$IFDEF TNTUNICODE}
{$IFDEF DELPHI7UP}
  procedure PaintThemedGroupBox;
  var
    CaptionRect: TRect;
    OuterRect: TRect;
    Size: TSize;
    Box: TThemedButton;
    Details: TThemedElementDetails;
  begin
    with Canvas do begin
      if Caption <> '' then begin
        GetTextExtentPoint32W(Handle, PWideChar(Caption), Length(Caption), Size);
        CaptionRect := Rect(0, 0, Size.cx, Size.cy);
        if not UseRightToLeftAlignment then
          OffsetRect(CaptionRect, 8, 0)
        else
          OffsetRect(CaptionRect, Width - 8 - CaptionRect.Right, 0);
      end
      else CaptionRect := Rect(0, 0, 0, 0);

      OuterRect := ClientRect;
      OuterRect.Top := (CaptionRect.Bottom - CaptionRect.Top) div 2;
      with CaptionRect do ExcludeClipRect(Handle, Left, Top, Right, Bottom);
      if Enabled then Box := tbGroupBoxNormal else Box := tbGroupBoxDisabled;
      Details := ThemeServices.GetElementDetails(Box);
      ThemeServices.DrawElement(Handle, Details, OuterRect);

      SelectClipRgn(Handle, 0);
      if Text <> '' then ThemeServices.DrawText{TNT-ALLOW DrawText}(Handle, Details, Caption, CaptionRect, DT_LEFT, 0);
    end;
  end;
{$ENDIF}
  procedure PaintGroupBox;
  var
    H: Integer;
    R: TRect;
    Flags: Longint;
  begin
    with Canvas do begin
      H := WideCanvasTextHeight(Canvas, '0');
      R := Rect(0, H div 2 - 1, Width, Height);
      if Ctl3D then begin
        Inc(R.Left);
        Inc(R.Top);
        Brush.Color := clBtnHighlight;
        FrameRect(R);
        OffsetRect(R, -1, -1);
        Brush.Color := clBtnShadow;
      end
      else Brush.Color := clWindowFrame;
      FrameRect(R);
      if Caption <> '' then begin
        if not UseRightToLeftAlignment then R := Rect(8, 0, 0, H) else R := Rect(R.Right - WideCanvasTextWidth(Canvas, Caption) - 8, 0, 0, H);
        Flags := DrawTextBiDiModeFlags(DT_SINGLELINE);
        Tnt_DrawTextW(Handle, PWideChar(Caption), Length(Caption), R, Flags or DT_CALCRECT);
        Brush.Color := Color;
        Tnt_DrawTextW(Handle, PWideChar(Caption), Length(Caption), R, Flags);
      end;
    end;
  end;
{$ENDIF}
begin
  if FCommonData.Skinned(True) then begin
    if (csDestroying in ComponentState) or not (Visible or (csDesigning in componentState)) then Exit;
    if InAnimationProcess and (DC <> SkinData.PrintDC) then Exit;

    FCommonData.FUpdating := FCommonData.Updating;
    if not FCommonData.FUpdating then begin
      // If transparent and form resizing processed
      b := True;
      if SkinData.RepaintIfMoved then begin
        FCommonData.HalfVisible := not (PtInRect(Parent.ClientRect, Point(Left + 1, Top + 1)));
        FCommonData.HalfVisible := FCommonData.HalfVisible or not PtInRect(Parent.ClientRect, Point(Left + Width - 1, Top + Height - 1));
      end
      else FCommonData.HalfVisible := False;

      if b and not FCommonData.UrgentPainting then PrepareCache;
      CopyWinControlCache(Self, FCommonData, Rect(0, 0, 0, 0), Rect(0, 0, Width, Height), DC, False);
      sVCLUtils.PaintControls(DC, Self, b, Point(0, 0));
      SetParentUpdated(Self);
    end;
  end
  else begin
{$IFDEF TNTUNICODE}
    if (not Win32PlatformIsUnicode) then inherited else begin
      Canvas.Font := Self.Font;
{$IFDEF DELPHI7UP}
      if ThemeServices.ThemesEnabled then PaintThemedGroupBox else
{$ENDIF}
      PaintGroupBox;
    end;
{$ELSE}
    inherited;
{$ENDIF}
  end
end;

procedure TsGroupBox.PrepareCache;
var
  cRect, aRect: TRect;
  CI : TCacheInfo;
begin
  InitCacheBmp(SkinData);

  aRect := Rect(0, 0, Width, Height);
  CI := GetParentCache(FCommonData);
  cRect := CaptionRect;

  if CI.Ready
    then BitBlt(FCommonData.FCacheBmp.Canvas.Handle, aRect.Left, aRect.Top, Width, HeightOf(cRect), CI.Bmp.Canvas.Handle, Left + CI.X, Top + CI.Y, SRCCOPY)
    else if Parent <> nil then FillDC(FCommonData.FCacheBmp.Canvas.Handle, Rect(0, 0, Width, cRect.Bottom), CI.FillColor);

  if FCaptionYOffset < 0 then aRect.Top := 0 else aRect.Top := HeightOf(cRect) div 2;
  PaintItem(FCommonData, CI, False, 0, Rect(0, aRect.Top, Width, Height), Point(Left, Top + aRect.Top), FCommonData.FCacheBMP, True);

  if Caption <> '' then WriteText(cRect, CI);
  FCommonData.BGChanged := False;
end;

procedure TsGroupBox.SetCaptionLayout(const Value: TsCaptionLayout);
begin
  if FCaptionLayout <> Value then begin
    FCaptionLayout := Value;
    if Caption <> '' then SkinData.Invalidate;
  end;
end;

procedure TsGroupBox.SetCaptionSkin(const Value: TsSkinSection);
begin
  if FCaptionSkin <> Value then begin
    FCaptionSkin := Value;
    FCommonData.Invalidate
  end;
end;

procedure TsGroupBox.SetCaptionWidth(const Value: TacIntProperty);
begin
  if FCaptionWidth <> Value then begin
    FCaptionWidth := Value;
    FCommonData.Invalidate
  end;
end;

procedure TsGroupBox.SetCaptionYOffset(const Value: integer);
begin
  if FCaptionYOffset <> Value then begin
    FCaptionYOffset := Value;
    SkinData.Invalidate;
  end;
end;

function TsGroupBox.TextHeight: integer;
begin
  Result := Maxi(4, FCommonData.FCacheBmp.Canvas.TextHeight('W')) + 2;
end;

procedure TsGroupBox.WMFontChanged(var Message: TMessage);
begin
  inherited;
  FCommonData.FCacheBmp.Canvas.Font.Assign(Font);
  if Caption <> '' then FCommonData.Invalidate;
end;

procedure TsGroupBox.WndProc(var Message: TMessage);
var
  PS : TPaintStruct;
  DC : hdc;
begin
{$IFDEF LOGGED}
  AddToLog(Message, Name);
{$ENDIF}
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_CTRLHANDLED : begin Message.Result := 1; Exit end;
    AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
    AC_SETNEWSKIN : begin
      AlphaBroadCast(Self, Message);
      if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then CommonWndProc(Message, FCommonData);
      exit
    end;
    AC_GETBG : begin
      if CaptionSkin <> '' then begin // If BG of groupbox used
        PacBGInfo(Message.LParam)^.Bmp := SkinData.FCacheBmp;
        PacBGInfo(Message.LParam)^.Offset := Point(0, 0);
        PacBGInfo(Message.LParam)^.BgType := btCache;
        Exit;
      end;
    end;
    AC_REFRESH, AC_REMOVESKIN : begin
      if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
        CommonWndProc(Message, FCommonData);
        AlphaBroadCast(Self, Message);
        Repaint;
      end
      else AlphaBroadCast(Self, Message);
      exit
    end
  end;
  if not ControlIsReady(Self) or not FCommonData.Skinned then inherited else begin
    if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
      AC_PREPARING : begin
        Message.Result := integer(FCommonData.BGChanged or FCommonData.Updating);
        Exit
      end;
      AC_URGENTPAINT : begin
        CommonWndProc(Message, FCommonData);
        if FCommonData.UrgentPainting then PrepareCache;
        Exit
      end;
      AC_ENDPARENTUPDATE : if FCommonData.FUpdating then begin
        FCommonData.FUpdating := False;
        FCommonData.FUpdating := FCommonData.Updating;
        if Showing and not FCommonData.FUpdating
          then RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_UPDATENOW);
        Exit;
      end;
      else begin
        CommonMessage(Message, FCommonData);
        Exit;
      end;
    end
    else case Message.Msg of
      WM_PAINT : begin
        BeginPaint(Handle, PS);
        if Message.WParam = 0 then DC := GetDC(Handle) else DC := hdc(Message.WParam);
        try
          PaintToDC(DC);
        finally
          if Message.WParam = 0 then ReleaseDC(Handle, DC);
        end;
        EndPaint(Handle, PS);
        Exit;
      end;
      WM_PRINT : begin
        SkinData.Updating := False;
        PaintToDC(TWMPaint(Message).DC);
        Exit;
      end;
      CM_TEXTCHANGED : begin
        SkinData.Invalidate;
        Exit;
      end;
      WM_ERASEBKGND : begin
        Message.Result := 1;
        if (csDesigning in ComponentState) then inherited; // Drawing in the BDS IDE
        Exit;
      end;
      CM_VISIBLECHANGED, WM_WINDOWPOSCHANGED : begin
        FCommonData.BGChanged := True;
      end;
      WM_KILLFOCUS, WM_SETFOCUS: begin inherited; exit end;
      WM_MOVE : begin
        FCommonData.BGChanged := FCommonData.BGChanged or FCommonData.RepaintIfMoved;
      end;
    end;
//    if Message.Result <> 1 then
    CommonWndProc(Message, FCommonData);
    inherited;
    case Message.Msg of
      WM_SIZE : if (csDesigning in ComponentState) then SendMessage(Handle, WM_PAINT, 0, 0);
    end
  end;
end;

procedure TsGroupBox.WriteText(R: TRect; CI : TCacheInfo);
var
  sSection : string;
  sIndex : integer;
  Flags : Cardinal;
  Bmp : TBitmap;
  rText : TRect;
begin
  Flags := DT_SINGLELINE or DT_VCENTER;
  if CaptionWidth = 0 then Flags := Flags or DT_CENTER else Flags := Flags or DT_END_ELLIPSIS;
  if UseRightToLeftReading then Flags := Flags or DT_RTLREADING;
  if FCaptionSkin = '' then begin
    CI := GetParentCache(FCommonData);
    sSection := s_CHECKBOX;
    sIndex := FCommonData.SkinManager.GetSkinIndex(sSection);
    if not CI.Ready
      then FillDC(FCommonData.FCacheBmp.Canvas.Handle, R, CI.FillColor)
      else PaintItem(sIndex, sSection, CI, True, integer(Focused), R, Point(Left + R.Left, Top + R.Top), FCommonData.FCacheBmp, FCommonData.SkinManager);

    inc(R.Left, FCaptionMargin.Left);
    inc(R.Top, FCaptionMargin.Top);
    inc(R.Right, -FCaptionMargin.Right);
    inc(R.Bottom, -FCaptionMargin.Bottom);
    acWriteTextEx(FCommonData.FCacheBMP.Canvas, PacChar(Caption), True, R, Flags, SkinData, False, FCommonData.SkinManager);
  end
  else begin
    CI := MakeCacheInfo(FCommonData.FCacheBmp);
    sSection := FCaptionSkin;
    sIndex := FCommonData.SkinManager.GetSkinIndex(sSection);

    Bmp := CreateBmp32(WidthOf(R), HeightOf(R));
    PaintItem(sIndex, sSection, CI, True, integer(Focused), Rect(0, 0, Bmp.Width, Bmp.Height), Point(R.Left, R.Top), Bmp, FCommonData.SkinManager);

    rText := Rect(FCaptionMargin.Left, FCaptionMargin.Top, Bmp.Width - FCaptionMargin.Right, Bmp.Height - FCaptionMargin.Bottom);
    if not SkinData.CustomFont then acWriteTextEx(BMP.Canvas, PacChar(Caption), True, rText, Flags, sIndex, False, FCommonData.SkinManager) else begin
      BMP.Canvas.Font.Assign(Font);
      acWriteText(BMP.Canvas, PacChar(Caption), True, rText, Flags);
    end;

    BitBlt(FCommonData.FCacheBMP.Canvas.Handle, R.Left, R.Top, Bmp.Width, Bmp.Height, BMP.Canvas.Handle, 0, 0, SRCCOPY);

    Bmp.Free;
  end;
end;

{ TsGroupButton }

type
  TsGroupButton = class(TsRadioButton)
  private
    FInClick : Boolean;
    FInModifying : boolean;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    function CanModify : boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor InternalCreate(RadioGroup: TsRadioGroup);
    destructor Destroy; override;
  end;

constructor TsGroupButton.InternalCreate(RadioGroup: TsRadioGroup);
begin
  inherited Create(RadioGroup);
  SkinData.SkinManager := RadioGroup.SkinData.SkinManager;
  SkinData.SkinSection := s_CheckBox;
  AutoSize := False;
  ShowFocus := True;
  RadioGroup.FButtons.Add(Self);
  Visible := False;
  Enabled := RadioGroup.Enabled;
  ParentShowHint := False;
  OnClick := RadioGroup.ButtonClick;
  TabStop := False;
  SkinData.CustomFont := RadioGroup.SkinData.CustomFont;
  AnimatEvents := RadioGroup.AnimatEvents;
  Parent := RadioGroup;
end;

destructor TsGroupButton.Destroy;
begin
  TsRadioGroup(Owner).FButtons.Remove(Self);
  inherited Destroy;
end;

procedure TsGroupButton.CNCommand(var Message: TWMCommand);
begin
  if not FInClick and not FInModifying and not (csLoading in ComponentState) then begin
    FInClick := True;
    try
      if ((Message.NotifyCode = BN_CLICKED) or (Message.NotifyCode = BN_DOUBLECLICKED)) and TsRadioGroup(Parent).CanModify(TsRadioGroup(Parent).FButtons.IndexOf(Self)) then inherited;
    except
      Application.HandleException(Self);
    end;
    FInClick := False;
  end;
end;

procedure TsGroupButton.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  TsRadioGroup(Parent).KeyPress(Key);
  if (Key = #8) or (Key = ' ') then begin
    if not TsRadioGroup(Parent).CanModify(TsRadioGroup(Parent).FButtons.IndexOf(Self)) then Key := #0;
  end;
end;

procedure TsGroupButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  TsRadioGroup(Parent).KeyDown(Key, Shift);
end;

function TsGroupButton.CanModify : boolean;
begin
  FInModifying := True;
  Result := TsRadioGroup(Parent).CanModify(TsRadioGroup(Parent).FButtons.IndexOf(Self));
  FInModifying := False;
end;

{ TsRadioGroup }

procedure TsRadioGroup.ArrangeButtons;
var
  ButtonsPerCol, ButtonWidth, ButtonHeight, TopMargin, I: Integer;
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
  DeferHandle: THandle;
  ALeft: Integer;
begin
  if (FButtons.Count <> 0) and not FReading and not (csLoading in ComponentState) then begin
    DC := GetDC(0);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    ButtonsPerCol := (FButtons.Count + FColumns - 1) div FColumns;
    ButtonWidth := (Width - 10) div FColumns;
    I := Height - Metrics.tmHeight - 5;
    ButtonHeight := I div ButtonsPerCol;
    TopMargin := Metrics.tmHeight + 1 + (I mod ButtonsPerCol) div 2;
    DeferHandle := BeginDeferWindowPos(FButtons.Count);
    try
      for I := 0 to FButtons.Count - 1 do with TsGroupButton(FButtons[I]) do begin
        SkinData.SkinManager := Self.SkinData.SkinManager;
        BiDiMode := self.BiDiMode;
        ShowFocus := Self.ShowFocus;
        if UseRightToLeftAlignment
          then ALeft := (I div ButtonsPerCol) * ButtonWidth + 8 + ButtonWidth - TsGroupButton(FButtons[I]).Width
          else ALeft := (I div ButtonsPerCol) * ButtonWidth + 8;
        DeferHandle := DeferWindowPos(DeferHandle, Handle, 0, ALeft, (I mod ButtonsPerCol) * ButtonHeight + TopMargin,
                                      ButtonWidth, ButtonHeight, SWP_NOZORDER or SWP_NOACTIVATE);
        Visible := True;
      end;
    finally
      EndDeferWindowPos(DeferHandle);
    end;
  end;
end;

procedure TsRadioGroup.ButtonClick(Sender: TObject);
begin
  if not FUpdating then begin
    FItemIndex := FButtons.IndexOf(Sender);
    Changed;
    Click;
  end;
end;

function TsRadioGroup.CanModify(NewIndex : integer): Boolean;
begin
  Result := True;
  if Assigned(FOnChanging) then FOnChanging(Self, NewIndex, Result );
end;

procedure TsRadioGroup.CMEnabledChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FButtons.Count - 1 do begin
    TsGroupButton(FButtons[I]).Enabled := Enabled;
    TsGroupButton(FButtons[I]).SkinData.BGChanged := True;
  end;
end;

procedure TsRadioGroup.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ArrangeButtons;
end;

constructor TsRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csSetCaption, csDoubleClicks];
  FButtons := TList.Create;
{$IFDEF TNTUNICODE}
  FItems := TTntStringList.Create;
  TTntStringList(FItems).OnChange := ItemsChange;
{$ELSE}
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
{$ENDIF}
  FItemIndex := -1;
  FColumns := 1;
  FAnimatEvents := [aeGlobalDef];
  FShowFocus := True;
end;

destructor TsRadioGroup.Destroy;
begin
  SetButtonCount(0);
{$IFDEF TNTUNICODE}
  TTntStringList(FItems).OnChange := Nil;
{$ELSE}
  TStringList(FItems).OnChange := Nil;
{$ENDIF}
  FreeAndNil(FItems);
  FButtons.Free;
  inherited Destroy;
end;

procedure TsRadioGroup.FlipChildren(AllLevels: Boolean);
begin
//
end;

function TsRadioGroup.GetButtons(Index: Integer): TsRadioButton;
begin
  Result := TsRadioButton(FButtons[Index]);
end;

procedure TsRadioGroup.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
//
end;

procedure TsRadioGroup.ItemsChange(Sender: TObject);
var
  i : integer;
begin
  if not FReading and not(csLoading in ComponentState) then begin
    if FItemIndex >= FItems.Count then FItemIndex := FItems.Count - 1;
    UpdateButtons;
  end;
  for i := 0 to FButtons.Count - 1 do TsRadioButton(FButtons[i]).Loaded;
end;

procedure TsRadioGroup.Loaded;
begin
  inherited Loaded;
  UpdateButtons;
  if (FItemIndex >= 0) and (FItemIndex < FButtons.Count) then begin
    FUpdating := True;
    TsGroupButton(FButtons[FItemIndex]).Checked := True;
    FUpdating := False;
  end;
end;

procedure TsRadioGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  inherited ReadState(Reader);
  FReading := False;
  UpdateButtons;
end;

procedure TsRadioGroup.SetButtonCount(Value: Integer);
begin
  while FButtons.Count < Value do TsGroupButton.InternalCreate(Self);
  while FButtons.Count > Value do TsGroupButton(FButtons.Last).Free;
end;

procedure TsRadioGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 16 then Value := 16;
  if FColumns <> Value then begin
    FColumns := Value;
    ArrangeButtons;
    Invalidate;
  end;
end;

procedure TsRadioGroup.SetItemIndex(Value: Integer);
begin
  if FReading then FItemIndex := Value else begin
    if Value < -1 then Value := -1;
    if Value >= FButtons.Count then Value := FButtons.Count - 1;
    if FItemIndex <> Value then begin
      if FItemIndex >= 0 then TsGroupButton(FButtons[FItemIndex]).Checked := False;
      FItemIndex := Value;
      if FItemIndex >= 0 then TsGroupButton(FButtons[FItemIndex]).Checked := True;
    end;
  end;
end;

procedure TsRadioGroup.SetItems(Value: {$IFDEF TNTUNICODE}TTntStrings{$ELSE}TStrings{$ENDIF});
begin
  FItems.Assign(Value);
end;

procedure TsRadioGroup.UpdateButtons;
var
  I: Integer;
begin
  if FReading or (csLoading in ComponentState) then Exit;
  SetButtonCount(FItems.Count);
  for I := 0 to FButtons.Count - 1 do TsGroupButton(FButtons[I]).Caption := FItems[I];
  ArrangeButtons;
  Invalidate;
end;

procedure TsRadioGroup.WMSize(var Message: TWMSize);
begin
  inherited;
  ArrangeButtons;
end;

procedure TsRadioGroup.WndProc(var Message: TMessage);
begin
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_REFRESH : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then ArrangeButtons;
  end;
  inherited;
end;

{ TsMargin }

constructor TsMargin.Create(Control: TControl);
begin
  inherited Create;
  FControl := Control;
  FLeft := 2;
  FRight := 2;
  FTop := 0;
  FBottom := 0;
end;

procedure TsMargin.Invalidate;
begin
  if not (csLoading in FControl.ComponentState) then begin
    if FControl is TsGroupBox then TsGroupBox(FControl).SkinData.Invalidate;
  end;
end;

procedure TsMargin.SetMargin(Index: Integer; Value: TacIntProperty);
begin
  case Index of
    0: if Value <> FLeft then FLeft := Value;
    1: if Value <> FTop then FTop := Value;
    2: if Value <> FRight then FRight := Value;
    3: if Value <> FBottom then FBottom := Value;
  end;
  Invalidate;
end;

end.
