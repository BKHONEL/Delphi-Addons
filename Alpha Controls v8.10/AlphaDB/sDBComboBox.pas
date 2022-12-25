unit sDBComboBox;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, acSBUtils,
  StdCtrls, DBCtrls, sConst, acntUtils, sGraphUtils, sGlyphUtils, math, sCommonData,
  sDefaults{$IFDEF LOGGED}, sDebugMsgs{$ENDIF};

type
  TsDBComboBox = class(TDBComboBox)
  private
    FAlignment : TAlignment;
    FButtonMargin: integer;
    FBoundLabel: TsBoundLabel;
    FCommonData: TsCommonData;
    FDisabledKind: TsDisabledKind;

    procedure SetAlignment(const Value: TAlignment);
    procedure SetButtonMargin(const Value: integer);
    procedure SetDisabledKind(const Value: TsDisabledKind);
  protected
    lboxhandle : hwnd;
    ListSW : TacScrollWnd;
    actM : integer;
    actD : integer;

    procedure DropDown; override;

    procedure PaintBorder(ADC : HDC);
    procedure PrepareCache;
    procedure PaintText;
    procedure PaintButton;
    procedure OurPaintHandler(iDC : hdc);

    procedure ChangeScale(M, D: Integer); override;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
{$IFNDEF DELPHI5}
    function GetItemHt: Integer; override;
{$ENDIF}
//    procedure DrawSkinItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);

    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure WndProc (var Message: TMessage); override;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure WMMouseWheel(var Message: TMessage); message WM_MOUSEWHEEL;
  public
    FDropDown : boolean;

    procedure AfterConstruction; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;

    property Color;
    procedure Invalidate; override;
    procedure InvalidateSelection;
    function ButtonRect: TRect;
    function ButtonHeight : integer;

    procedure WriteText;
    function Focused: Boolean; override;
    property Alignment : TAlignment read FAlignment write SetAlignment;
    property ButtonMargin : integer read FButtonMargin write SetButtonMargin default 2;
  published
    property BoundLabel : TsBoundLabel read FBoundLabel write FBoundLabel;
    property DisabledKind : TsDisabledKind read FDisabledKind write SetDisabledKind default DefDisabledKind;
    property DropDownCount default 16;
    property SkinData : TsCommonData read FCommonData write FCommonData;
  end;

implementation

uses sMessages, sMaskData, sStyleSimply, sSkinProps, sVCLUtils, sAlphaGraph, acGlow{$IFDEF DELPHI7UP}{$IFNDEF D2009}, Themes{$ENDIF}{$ENDIF};

const
  BordWidth = 3;
    
{ TsDBComboBox }

procedure TsDBComboBox.AfterConstruction;
begin
  inherited AfterConstruction;
  FCommonData.Loaded;
end;

function TsDBComboBox.ButtonHeight: integer;
var
  i : integer;
begin
  if FCommonData.Skinned then begin
    i := FCommonData.SkinManager.GetMaskIndex(FCommonData.SkinIndex, FCommonData.SkinSection, s_ItemGlyph);
    if FCommonData.SkinManager.ma[i].Bmp = nil
      then Result := HeightOfImage(FCommonData.SkinManager.ma[i])
      else Result := FCommonData.SkinManager.ma[i].Bmp.Height div 2;
  end
  else begin
    Result := 16;
  end;
end;

function TsDBComboBox.ButtonRect: TRect;
var
  w : integer;
begin
  if (Style <> csSimple) then w := GetSystemMetrics(SM_CXVSCROLL) else w := 0;
  if UseRightToLeftAlignment then Result.Left := 3 else Result.Left := Width - w - 3;
  Result.Top := 3;
  Result.Right := Result.Left + w;
  Result.Bottom := Height - 3;
end;

procedure TsDBComboBox.ChangeScale(M, D: Integer);
var
  UpdateNeeded : boolean;
begin
  UpdateNeeded := (actM <> M) or (actD <> D);
  actM := M;
  actD := D;
  inherited;
  if UpdateNeeded then RecreateWnd;
end;

procedure TsDBComboBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    if itemState and ODS_COMBOBOXEDIT <> 0 then Include(State, odComboBoxEdit);
    if itemState and ODS_DEFAULT <> 0 then Include(State, odDefault);
    Canvas.Handle := hDC;
    DrawItem(integer(itemID), rcItem, State);
    Canvas.Handle := 0;
  end;
end;

procedure TsDBComboBox.CNMeasureItem(var Message: TWMMeasureItem);
begin
  if not (Style in [csOwnerDrawFixed, csOwnerDrawVariable]) then begin
    Message.MeasureItemStruct^.itemHeight := MulDiv(GetFontHeight(Font.Handle) - 4, actM, actD);
  end
  else inherited;
end;

procedure TsDBComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer);
var
  ps : TPaintStruct;
begin
{$IFDEF LOGGED}
//  AddToLog(Message);
{$ENDIF}
  if ReadOnly then begin
    case Message.Msg of
      WM_KEYDOWN, WM_CHAR, WM_KEYUP, WM_SYSKEYUP, CN_KEYDOWN, CN_CHAR, CN_SYSKEYDOWN, CN_SYSCHAR, WM_PASTE, WM_CUT, WM_CLEAR, WM_UNDO: Exit
      else
    end
  end;
  begin
    if not (csDestroying in ComponentState) and FCommonData.Skinned then case Message.Msg of
      WM_ERASEBKGND, WM_NCPAINT : if (Style <> csSimple) and (not (Focused or FCommonData.FFocused) or not Enabled or ReadOnly) then begin
        Message.Result := 1;
        Exit;
      end;
      WM_PAINT : if (Style <> csSimple) and (not (Focused or FCommonData.FFocused) or not Enabled or ReadOnly) then begin
        BeginPaint(ComboWnd, PS);
        EndPaint(ComboWnd, PS);
        Exit;
      end;
    end;
    inherited;
  end;
end;

constructor TsDBComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csFixedHeight, csFramed, csOpaque];
  TControlCanvas(Canvas).Control := self;
  FDropDown := False;

  ParentColor := False;
  actM := 1;
  actD := 1;

  FCommonData := TsCommonData.Create(Self, True);
  FCommonData.COC := COC_TsEdit;
  if FCommonData.SkinSection = '' then FCommonData.SkinSection := s_ComboBox;
  FDisabledKind := DefDisabledKind;

  FBoundLabel := TsBoundLabel.Create(Self, FCommonData);
  FButtonMargin := 2;

//  ItemHeight := 13;

  DropDownCount := 16;
  DoubleBuffered := True;
end;

procedure TsDBComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if Style in [csDropDown, csDropDownList] then Params.Style := Params.Style or CBS_OWNERDRAWFIXED and not CBS_OWNERDRAWVARIABLE;
end;

procedure TsDBComboBox.CreateWnd;
begin
  inherited;
{$IFDEF DELPHI7UP}
{$IFNDEF D2009}
  if CheckWin32Version(5, 1) and ThemeServices.ThemesEnabled then SendMessage(Handle, $1701{CB_SETMINVISIBLE}, WPARAM(DropDownCount), 0);
{$ENDIF}
{$ENDIF}
  FCommonData.Loaded;
end;

destructor TsDBComboBox.Destroy;
begin
  if lBoxHandle <> 0 then begin
    SetWindowLong(lBoxHandle, GWL_STYLE, GetWindowLong(lBoxHandle, GWL_STYLE) and not WS_THICKFRAME or WS_BORDER);
    UninitializeACScroll(lBoxHandle, True, False, ListSW);
    lBoxHandle := 0;
  end;
  FreeAndNil(FBoundLabel);
  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  inherited Destroy;
end;

procedure TsDBComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Bmp : TBitmap;
  aRect : TRect;
  TmpColor : TColor;
  sNdx : integer;
  CI : TCacheInfo;
  DrawStyle : longint;
  OldDC, SavedDC : hdc;
  C : TColor;
begin
  aRect := Classes.Rect(0, 0, WidthOf(Rect), HeightOf(Rect));
  DrawStyle := DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or DT_TOP or DT_NOCLIP;
  if SkinData.Skinned then begin
    Bmp := CreateBmp32(WidthOf(Rect, True), HeightOf(Rect, True));
    Bmp.Canvas.Font.Assign(Font);
    if odComboBoxEdit in State then CI := MakeCacheInfo(FCommonData.FCacheBmp, Rect.Left, Rect.Top) else begin
      CI.Bmp := nil;
      CI.Ready := False;
      CI.FillColor := Color;
    end;
    if (odSelected in State) then begin
      sNdx := SkinData.SkinManager.GetSkinIndex(s_Selection);
      C := SkinData.SkinManager.GetHighLightColor(True);//odFocused in State);
      Canvas.Brush.Color := C;
      if sNdx < 0
        then FillDC(Bmp.Canvas.Handle, Classes.Rect(0, 0, Bmp.Width, Bmp.Height), C)
        else PaintItem(sNdx, s_Selection, CI, True, 1{integer((odFocused in State) or (Style = csDropDown))}, Classes.Rect(0, 0, Bmp.Width, Bmp.Height), Point(0, 0), Bmp, SkinData.SkinManager);
      Canvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor(True);
    end
    else begin
      sNdx := -1;
      if (odComboBoxEdit in State) then C := Color else C := SkinData.SkinManager.GetActiveEditColor;
      if CI.Ready
        then BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, CI.Bmp.Canvas.Handle, CI.X, CI.Y, SRCCOPY)
        else FillDC(Bmp.Canvas.Handle, Classes.Rect(0, 0, Bmp.Width, Bmp.Height), C);
      Canvas.Brush.Color := C;
    end;
    if Assigned(OnDrawItem) and (Style in [csOwnerDrawFixed, csOwnerDrawVariable]) then begin
      if (Index > -1) and (Index < Items.Count) then begin
        OldDC := Canvas.Handle;
        Canvas.Handle := Bmp.Canvas.Handle;
        Bmp.Canvas.Lock;
        SavedDC := SaveDC(Canvas.Handle);
        try
          MovewindowOrg(Canvas.Handle, -Rect.Left, -Rect.Top);
          OnDrawItem(Self, Index, Rect, State);
        finally
          RestoreDC(Canvas.Handle, SavedDC);
          Bmp.Canvas.UnLock;
        end;
        Canvas.Handle := OldDC;
      end
    end
    else begin
      if UseRightToLeftAlignment then DrawStyle := DrawStyle or DT_RIGHT;
      if UseRightToLeftReading then DrawStyle := DrawStyle or DT_RTLREADING;
      if (csDropDown = Style) and (odComboBoxEdit in State) then begin
        Bmp.Canvas.Brush.Style := bsClear;
        AcDrawText(Bmp.Canvas.Handle, Text, aRect, DrawStyle);
      end
      else begin
        InflateRect(aRect, -2, 0);

        if sNdx = -1 then begin
          if odSelected in State then Bmp.Canvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor(True) else begin
            if (odComboBoxEdit in State) then Bmp.Canvas.Font.Color := Font.Color else Bmp.Canvas.Font.Color := SkinData.SkinManager.GetActiveEditFontColor;
          end;
          Bmp.Canvas.Brush.Style := bsClear;
          AcDrawText(Bmp.Canvas.Handle, Items[Index], aRect, DrawStyle);
        end
        else acWriteTextEx(Bmp.Canvas, PacChar(Items[Index]), True, aRect, DrawStyle, sNdx, True, SkinData.SkinManager);
        if (odFocused in State) and (sNdx < 0) then begin
          Bmp.Canvas.Brush.Style := bsSolid;
          InflateRect(aRect, 2, 0);
          DrawFocusRect(Bmp.Canvas.Handle, aRect);
        end;
      end;
    end;
    BitBlt(Canvas.Handle, Rect.Left, Rect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(Bmp);
  end
  else begin
    Canvas.Font.Assign(Font);
    if (odSelected in State) then begin
      TmpColor := ColorToRGB(clHighLight);
      Canvas.Font.Color := ColorToRGB(clHighLightText);
      Canvas.Brush.Color := ColorToRGB(clHighLight);
    end
    else begin
      TmpColor := ColorToRGB(Color);
      Canvas.Font.Color := ColorToRGB(Font.Color);
      Canvas.Brush.Color := Color;
    end;
    FillDC(Canvas.Handle, Rect, TmpColor);
    if (Index > -1) and (Index < Items.Count) then begin
      InflateRect(Rect, -2, 0);
      if Assigned(OnDrawItem) and (Style in [csOwnerDrawFixed, csOwnerDrawVariable]) then OnDrawItem(Self, Index, Rect, State) else begin
        Canvas.Brush.Style := bsClear;
        AcDrawText(Canvas.Handle, Items[Index], Rect, DrawStyle);
      end;
      if (odFocused in State) then begin
        InflateRect(Rect, 2, 0);
        DrawFocusRect(Canvas.Handle, Rect);
      end;
    end;
  end;
end;

procedure TsDBComboBox.DropDown;
begin
  FDropDown := True;
  inherited;
end;

function TsDBComboBox.Focused: Boolean;
var
  FocusedWnd: HWND;
begin
  Result := False;
  if HandleAllocated then begin
    FocusedWnd := GetFocus;
    Result := (FocusedWnd <> 0) and ((FocusedWnd = EditHandle) or (FocusedWnd = ListHandle)) or (Assigned(FCommonData) and FCommonData.FFocused);
  end;
end;

{$IFNDEF DELPHI5}
function TsDBComboBox.GetItemHt: Integer;
begin
  Result := SendMessage(Handle, CB_GETITEMHEIGHT, 0, 0);
end;
{$ENDIF}

procedure TsDBComboBox.Invalidate;
begin
  if Focused then FCommonData.FFocused := True;
  inherited Invalidate;
end;

procedure TsDBComboBox.InvalidateSelection;
begin
//
end;

procedure TsDBComboBox.Loaded;
begin
  inherited Loaded;
  FCommonData.Loaded;
  if FCommonData.Skinned then begin
    if not FCommonData.CustomColor then Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;
    if not FCommonData.CustomFont then Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1];
  end;
end;

function IsOwnerDraw(Ctrl : TsDBComboBox) : boolean;
begin
  Result := (Ctrl.Style in [csOwnerDrawFixed, csOwnerDrawVariable]) and Assigned(Ctrl.OnDrawItem)
end;

procedure TsDBComboBox.OurPaintHandler(iDC: hdc);
const
  BordWidth = 3;
var
  DC : hdc;
  R : TRect;
begin
  if not Showing or not HandleAllocated then Exit;
  if iDC = 0 then DC := GetDC(Handle) else DC := iDC;
  R := ButtonRect;
  try
    FCommonData.FUpdating := FCommonData.Updating;
    if not (InAnimationProcess and (DC <> SkinData.PrintDC) and (SkinData.PrintDC <> 0)) and not FCommonData.FUpdating then begin
      FCommonData.BGChanged := FCommonData.BGChanged or FCommonData.HalfVisible or GetBoolMsg(Parent, AC_GETHALFVISIBLE) or IsOwnerDraw(Self);
      FCommonData.HalfVisible := not RectInRect(Parent.ClientRect, BoundsRect);

      if FCommonData.BGChanged then PrepareCache;
      UpdateCorners(FCommonData, 0);

      case Style of
        csSimple : begin
          BitBltBorder(DC, 0, 0, Width, FCommonData.FCacheBmp.Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, BordWidth);
        end;
        csDropDown : begin
          if Focused then begin
            BitBltBorder(DC, 0, 0, Width, FCommonData.FCacheBmp.Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, BordWidth);
            R := ButtonRect;
            BitBlt(DC, R.Left, R.Top, WidthOf(R), HeightOf(R), FCommonData.FCacheBmp.Canvas.Handle, R.Left, R.Top, SRCCOPY);
          end
          else BitBlt(DC, 0, 0, Width, FCommonData.FCacheBmp.Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
        end;
        csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable : begin
          BitBlt(DC, 0, 0, Width, Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
          Canvas.Handle := 0;
        end;
      end;

{$IFDEF DYNAMICCACHE}
    if Assigned(FCommonData.FCacheBmp) then FreeAndNil(FCommonData.FCacheBmp);
{$ENDIF}
    end;
  finally
    if iDC = 0 then ReleaseDC(Handle, DC);
  end;
end;

procedure TsDBComboBox.PaintBorder(ADC : HDC);
var
  DC, SavedDC: HDC;
  R : TRect;
begin
  SavedDC := 0;
  if ADC = 0 then begin
    DC := GetWindowDC(Handle);
    SavedDC := SaveDC(DC);
  end
  else begin
    DC := ADC;
    MoveWindowOrg(DC, -BordWidth, -BordWidth);
    SelectClipRgn(DC,0);
  end;
  try
    PrepareCache;
    UpdateCorners(FCommonData, 0);

    BitBlt(DC, 0, 0, Width, BordWidth, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
    BitBlt(DC, 0, BordWidth, BordWidth, Height, FCommonData.FCacheBmp.Canvas.Handle, 0, BordWidth, SRCCOPY);
    BitBlt(DC, BordWidth, Height - BordWidth, Width - BordWidth, BordWidth, FCommonData.FCacheBmp.Canvas.Handle, BordWidth, Height - BordWidth, SRCCOPY);
    BitBlt(DC, Width - BordWidth, BordWidth, BordWidth, Height - BordWidth, FCommonData.FCacheBmp.Canvas.Handle, Width - BordWidth, BordWidth, SRCCOPY);
    R := ButtonRect;
    BitBlt(DC, R.Left, R.Top, WidthOf(R), HeightOf(R), FCommonData.FCacheBmp.Canvas.Handle, R.Left, R.TOp, SRCCOPY);

{$IFDEF DYNAMICCACHE}
    if Assigned(FCommonData.FCacheBmp) then FreeAndNil(FCommonData.FCacheBmp);
{$ENDIF}
  finally
    if SavedDC > 0 then begin
      RestoreDC(DC, SavedDC);
      ReleaseDC(Handle, DC);
    end
    else MoveWindowOrg(DC, BordWidth, BordWidth);
  end;
end;

procedure TsDBComboBox.PaintButton;
var
  R : TRect;
  Mode : integer;
  c : TsColor;
  glIndex : integer;
  TmpBtn : TBitmap;
begin
  if FDropDown then Mode := 2 else if ControlIsActive(FCommonData) then Mode := 1 else Mode := 0;
  R := ButtonRect;

  if FCommonData.SkinManager.ConstData.ComboBtnIndex > -1 then begin
    TmpBtn := CreateBmpLike(FCommonData.FCacheBmp);
    BitBlt(TmpBtn.Canvas.Handle, 0, 0, TmpBtn.Width, TmpBtn.Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
    PaintItem(FCommonData.SkinManager.ConstData.ComboBtnIndex, s_ComboBtn, MakeCacheInfo(FCommonData.FCacheBmp),
      True, Mode, R, Point(0, 0), FCommonData.FCacheBmp, FCommonData.SkinManager, FCommonData.SkinManager.ConstData.ComboBtnBG, FCommonData.SkinManager.ConstData.ComboBtnBGHot);
    FreeAndNil(TmpBtn);
  end;
  glIndex := FCommonData.SkinManager.ConstData.ComboGlyph;
  if FCommonData.SkinManager.IsValidImgIndex(glIndex) then begin
    if ControlIsActive(FCommonData) then c.C := FCommonData.SkinManager.gd[FCommonData.SkinIndex].HotColor else c.C := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;

    DrawSkinGlyph(FCommonData.FCacheBmp,
      Point(R.Left + (WidthOf(R) - WidthOfImage(FCommonData.SkinManager.ma[glIndex])) div 2,
            (Height - ButtonHeight) div 2), Mode, 1, FCommonData.SkinManager.ma[FCommonData.SkinManager.ConstData.ComboGlyph], MakeCacheInfo(SkinData.FCacheBmp));
  end;
end;

procedure TsDBComboBox.PaintText;
var
  R : TRect;
begin
  FCommonData.FCacheBMP.Canvas.Font.Assign(Font);
  R := Rect(3, 3, Width - 3, Height - 3);
  WriteTextEx(FCommonData.FCacheBMP.Canvas, PChar(Text), True, R, DT_NOPREFIX or DT_TOP or DT_SINGLELINE or DT_WORDBREAK or GetStringFlags(Self, Alignment),
              FCommonData, ControlIsActive(FCommonData));
end;

procedure TsDBComboBox.PrepareCache;
const
  BordWidth = 3;
var
  R, bRect : TRect;
  State : TOwnerDrawState;
begin
  InitCacheBmp(SkinData);
  if Style <> csSimple then begin
    PaintItem(FCommonData, GetParentCache(FCommonData), True, integer(ControlIsActive(FCommonData)), Rect(0, 0, Width, Height), Point(Left, top), FCommonData.FCacheBmp, False);
  end
  else begin
    FCommonData.FCacheBmp.Height := ItemHeight + 8;
    PaintItem(FCommonData, GetParentCache(FCommonData), True, integer(ControlIsActive(FCommonData)), Rect(0, 0, Width, FCommonData.FCacheBmp.Height), Point(Left, top), FCommonData.FCacheBmp, False);
  end;
  case Style of
    csDropDown, csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable : begin
      bRect := ButtonRect;
      if UseRightToLeftAlignment
        then R := Rect(bRect.Right + 1, BordWidth, Width - BordWidth, FCommonData.FCacheBmp.Height - BordWidth)
        else R := Rect(BordWidth, BordWidth, bRect.Left - 1, FCommonData.FCacheBmp.Height - BordWidth);
      State := [odComboBoxEdit];
      if (Focused or SkinData.FFocused) and not (Style in [csDropDown, csSimple]) then State := State + [odFocused, odSelected];
      Canvas.Handle := FCommonData.FCacheBmp.Canvas.Handle;
      FCommonData.FCacheBmp.Canvas.Lock;
      DrawItem(ItemIndex, R, State);
      FCommonData.FCacheBmp.Canvas.Unlock;
      Canvas.Handle := 0;
//      if FShowButton then
      PaintButton;
    end;
  end;
  if not Enabled and not IsOwnerDraw(Self) then BmpDisabledKind(FCommonData.FCacheBmp, FDisabledKind, Parent, GetParentCache(FCommonData), Point(Left, Top));
  FCommonData.BGChanged := False;
end;

procedure TsDBComboBox.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    FCommonData.Invalidate;
  end;
end;

procedure TsDBComboBox.SetButtonMargin(const Value: integer);
begin
  if FButtonMargin <> Value then begin
    FButtonMargin := Value;
    FCommonData.Invalidate;
  end;
end;

procedure TsDBComboBox.SetDisabledKind(const Value: TsDisabledKind);
begin
  if FDisabledKind <> Value then begin
    FDisabledKind := Value;
    FCommonData.Invalidate;
  end;
end;

var
  bFlag : boolean = False;

procedure TsDBComboBox.WMMouseWheel(var Message: TMessage);
begin
  if not FDropDown then begin // If not dropped down
    case Message.Msg of
      WM_MOUSEWHEEL: begin
        Message.Msg := WM_KEYDOWN;
        Message.lParam := 0;
        if SmallInt(Message.wParamHi) > 0 then Message.wParam := VK_UP else Message.wParam := VK_DOWN;
        MainWndProc(Message);
      end;
    end;
  end
  else inherited;
end;

procedure TsDBComboBox.WndProc(var Message: TMessage);
var
  PS : TPaintStruct;
  DC : hdc;
  R : TRect;
  P : TPoint;
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_CTRLHANDLED : begin Message.Result := 1; Exit end;
    AC_REMOVESKIN : begin
      CommonWndProc(Message, FCommonData);
      Color := clWindow;
      RecreateWnd;
      exit
    end;
    AC_REFRESH : begin
      CommonWndProc(Message, FCommonData);
      if FCommonData.Skinned then begin
        if not FCommonData.CustomColor then Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;
        if not FCommonData.CustomFont then Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1];
      end;
      Repaint;
      exit
    end;
    AC_SETNEWSKIN : begin
      CommonWndProc(Message, FCommonData);
      exit
    end;
    AC_DROPPEDDOWN : begin
      Message.WParamLo := integer(DroppedDown);
    end;
    AC_MOUSELEAVE : SendMessage(Handle, CM_MOUSELEAVE, 0, 0);
    AC_ENDPARENTUPDATE : if FCommonData.Updating then begin
      FCommonData.Updating := False;
      Repaint;
      Exit
    end;
  end;
  if not ControlIsReady(Self) or not FCommonData.Skinned then inherited else begin
    case Message.Msg of
      WM_SETFOCUS, CM_ENTER : if CanFocus and not bFlag then begin
        bFlag := True;
        FCommonData.FFocused := True;
        FCommonData.FMouseAbove := False;
        FCommonData.BGChanged := True;
        inherited;
        bFlag := False;
        Exit;
      end;
      WM_KILLFOCUS, CM_EXIT: if not bFlag then begin
        bFlag := True;
        DroppedDown := False;
        FCommonData.FFocused := False;
        FCommonData.FMouseAbove := False;
        FCommonData.BGChanged := True;
        inherited;
        bFlag := False;
        Exit;
      end;
      CM_INVALIDATE, CM_FOCUSCHANGED : if not bFlag then begin
//        bFlag := True;
        inherited;
//        bFlag := False;
        Exit;
      end;
      WM_PRINT : begin
        ControlState := ControlState + [csPaintCopy];
        if not FCommonData.CustomColor then Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;
        if not FCommonData.CustomFont then Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1];
        SendMessage(Handle, WM_PAINT, Message.WParam, 0);
        ControlState := ControlState - [csPaintCopy];
      end;
      WM_NCPAINT : begin
        if InanimationProcess then OurPaintHandler(0);
        Exit;
      end;
      WM_PAINT : begin
        BeginPaint(Handle, PS);
        if not InAnimationProcess then begin
          if TWMPaint(Message).DC = 0 then DC := GetDC(Handle) else DC := TWMPaint(Message).DC;
          OurPaintHandler(DC);
          if TWMPaint(Message).DC = 0 then ReleaseDC(Handle, DC);
        end;
        EndPaint(Handle, PS);
        Exit
      end;
      WM_MOUSELEAVE, CM_MOUSEENTER, CM_MOUSELEAVE : if not (csDesigning in ComponentState) then begin
        if not DroppedDown then begin
          GetWindowRect(Handle, R);
          if (Message.Msg <> CM_MOUSEENTER) then begin
            P := acMousePos;
            if PtInRect(R, P) then Exit;
          end
          else begin
            if FCommonData.FMouseAbove then Exit;
            SkinData.SkinManager.ActiveControl := Handle;
          end;

          FCommonData.FMouseAbove := Message.Msg = CM_MOUSEENTER;
          FCommonData.BGChanged := True;
          Repaint;
          inherited;
          if FCommonData.FMouseAbove then begin
            if SkinData.GlowID <> -1 then HideGlow(SkinData.GlowID);
            ShowGlowingIfNeeded(SkinData)
          end
          else ClearGlows;
        end
        else inherited;
        Exit;
      end;
{$IFNDEF TNTUNICODE}
      WM_CTLCOLORLISTBOX : if not (csLoading in ComponentState) and (lBoxHandle = 0) then begin
        lBoxHandle := hwnd(Message.LParam);
        ListSW := TacComboListWnd.CreateEx(lboxhandle, nil, SkinData.SkinManager, s_Edit, True, Style = csSimple);
      end;
{$ENDIF}
      CM_VISIBLECHANGED, CM_ENABLEDCHANGED, WM_SETFONT : begin
        FCommonData.BGChanged := True;
      end;
      CN_COMMAND : begin
        FDropDown := False;
        Repaint;
      end;
      CM_CHANGED, CM_TEXTCHANGED : begin
        FCommonData.BGChanged := True;
        Repaint;
      end;
    end;
    CommonWndProc(Message, FCommonData);
    inherited;
    case Message.Msg of CB_SETCURSEL, CM_VISIBLECHANGED, CM_ENABLEDCHANGED, WM_SETFONT : FCommonData.Invalidate; end;
  end;
  // Aligning of the bound label
  if Assigned(BoundLabel) and Assigned(BoundLabel.FtheLabel) then case Message.Msg of
    WM_SIZE, WM_WINDOWPOSCHANGED : BoundLabel.AlignLabel;
    CM_VISIBLECHANGED : begin BoundLabel.FtheLabel.Visible := Visible; BoundLabel.AlignLabel end;
    CM_ENABLEDCHANGED : begin BoundLabel.FtheLabel.Enabled := Enabled or not (dkBlended in DisabledKind); BoundLabel.AlignLabel end;
    CM_BIDIMODECHANGED : begin BoundLabel.FtheLabel.BiDiMode := BiDiMode; BoundLabel.AlignLabel end;
  end;
end;

procedure TsDBComboBox.WriteText;
var
  Flags: Longint;
  R : TRect;
begin
  if Text <> '' then begin
    Flags := 0;
    Canvas.Font.Assign(Font);
    R := ClientRect;
    dec(R.Left);
    dec(R.Top);
    dec(R.Right, ButtonRect.Left);

    case Alignment of
      taLeftJustify : Flags := DT_LEFT;
      taRightJustify : Flags := DT_RIGHT;
      taCenter : Flags := DT_CENTER;
    end;
    Flags := Flags or DT_EXPANDTABS or DT_VCENTER or DT_SINGLELINE;
    Flags := DrawTextBiDiModeFlags(Flags);

    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), R, Flags);
  end;
end;

end.
