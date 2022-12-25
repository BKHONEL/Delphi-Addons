unit sPageControl;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs{$IFNDEF DELPHI5}, Types{$ENDIF},
  ComCtrls, sCommonData, sConst, sFade, sUpDown, extctrls, sSpeedButton, acSBUtils, {$IFDEF DELPHI_XE3}UITypes, {$ENDIF}menus
  {$IFDEF TNTUNICODE}, TntComCtrls, TntGraphics{$ENDIF};

type
{$IFNDEF NOTFORHELP}
  TacCloseAction = (acaHide, acaFree);
  TacCloseBtnClick = procedure(Sender: TComponent; TabIndex : integer; var CanClose: boolean; var Action: TacCloseAction) of object;
  TacTabMouseEvent = procedure(Sender: TComponent; TabIndex : integer) of object;

  TsPageControl = class;

  TsTabSkinData = class(TPersistent)
  private
    FCustomColor: boolean;
    FCustomFont: boolean;
    FSkinSection: string;
    procedure SetCustomColor(const Value: boolean);
    procedure SetCustomFont(const Value: boolean);
    procedure SetSkinSection(const Value: string);
  published
    property CustomColor : boolean read FCustomColor write SetCustomColor;
    property CustomFont : boolean read FCustomFont write SetCustomFont;
    property SkinSection : TsSkinSection read FSkinSection write SetSkinSection;
  end;

  TsTabSheet = class;

  TsTabBtn = class(TsSpeedButton)
  public
    Page : TsTabSheet;
    constructor Create(AOwner:TComponent); override;
    procedure Paint; override;
    procedure UpdateGlyph;
  end;

  TacTabType = (ttButton, ttMenu, ttTab);

{$IFDEF TNTUNICODE}
  TsTabSheet = class(TTntTabSheet)
{$ELSE}
  TsTabSheet = class(TTabSheet)
{$ENDIF}
  private
    FTabMenu: TPopupMenu;
    FTabSkin: TsSkinSection;
    FTabType: TacTabType;
    FButtonSkin: TsSkinSection;
    FUseCloseBtn: boolean;
    FCommonData: TsTabSkinData;
    FOnClickBtn: TNotifyEvent;
    procedure SetUseCloseBtn(const Value: boolean);
    procedure SetButtonSkin(const Value: TsSkinSection);
    procedure SetTabSkin(const Value: TsSkinSection);
    procedure SetTabMenu(const Value: TPopupMenu);
    procedure SetTabType(const Value: TacTabType);
  public
    Btn : TsTabBtn;
    constructor Create(AOwner:TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    destructor Destroy; override;
    procedure WMEraseBkGnd (var Message: TWMPaint); message WM_ERASEBKGND;
    procedure WMNCPaint (var Message: TWMPaint); message WM_NCPAINT;
    procedure WndProc (var Message: TMessage); override;
  published
    property ButtonSkin : TsSkinSection read FButtonSkin write SetButtonSkin;
    property TabType : TacTabType read FTabType write SetTabType default ttTab;
    property TabMenu : TPopupMenu read FTabMenu write SetTabMenu;
    property TabSkin : TsSkinSection read FTabSkin write SetTabSkin;
    property SkinData : TsTabSkinData read FCommonData write FCommonData;
    property UseCloseBtn : boolean read FUseCloseBtn write SetUseCloseBtn default True;
    property OnClickBtn : TNotifyEvent read FOnClickBtn write FOnClickBtn;
  end;
{$ENDIF}

  TacTabData = record
    GlyphRect : TRect;
    TextRect  : TRect;
    BtnRect   : TRect;
    ArrowRect : TRect;
    FocusRect : TRect;
    TextSize  : TSize;
    TextPos   : TPoint;
    ArrowDirection : integer;
  end;

  TacTabChangingEvent = procedure(Sender: TObject; NewPage : TsTabSheet; var AllowChange: Boolean) of object;

  {$IFDEF TNTUNICODE}
  TsPageControl = class(TTntPageControl)
{$ELSE}
  TsPageControl = class(TPageControl)
{$ENDIF}
{$IFNDEF NOTFORHELP}
  private
    StoredVisiblePageCount : integer;
    ChangedSkinSection : string;
    FCommonData: TsCommonData;
    FAnimatEvents: TacAnimatEvents;
    FShowCloseBtns: boolean;
    FOnCloseBtnClick: TacCloseBtnClick;
    FCloseBtnSkin: TsSkinSection;
    FNewDockSheet: TsTabSheet;
    procedure CheckUpDown;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;

    procedure StdPaint(var Message: TWMPaint);
    procedure DrawStdTabs(DC : hdc);
    procedure DrawStdTab(PageIndex: Integer; State : integer; DC : hdc);

    procedure InitTabContentData(Canvas : TCanvas; Page : TTabSheet; TabRect : TRect; State : integer; IsTabMenu : boolean; var Data: TacTabData);

    procedure AcPaint(var Message: TWMPaint);
    procedure DrawSkinTabs;
    procedure DrawSkinTab(PageIndex: Integer; State : integer; DstDC : hdc);

    function PageRect: TRect;
    function TabsRect: TRect;
    function SkinTabRect(Index : integer; Active : boolean) : TRect;
    function GetActivePage: TsTabSheet;
    procedure SetActivePage(const Value: TsTabSheet);
    procedure UpdateBtnData;
//    procedure PaintButtons(DC : hdc);
    procedure SetShowCloseBtns(const Value: boolean);
    procedure SetCloseBtnSkin(const Value: TsSkinSection);
    function SpinSection : string;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
  private
    FShowUpDown: boolean;
    FShowFocus: boolean;
    FHoveredBtnIndex: integer;
    FPressedBtnIndex: integer;
    FRotateCaptions: boolean;
    FActiveIsBold: boolean;
    FOnPageChanging: TacTabChangingEvent;
    FTabPadding: integer;
    FOnTabMouseEnter: TacTabMouseEvent;
    FOnTabMouseLeave: TacTabMouseEvent;
    FAccessibleDisabledPages: boolean;
    procedure SetShowUpDown(const Value: boolean);
    procedure SetShowFocus(const Value: boolean);
    procedure SetHoveredBtnIndex(const Value: integer);
    procedure SetRotateCaptions(const Value: boolean);
    procedure SetActiveIsBold(const Value: boolean);
    function GetActivePageIndex: Integer;
    procedure SetActivePageIndex(const Value: Integer);
    procedure SetTabPadding(const Value: integer);
    procedure SetCurItem(const Value: integer);
  protected
    SpinWnd : TacSpinWnd;
    FCurItem : integer;
    DroppedDownItem : integer;
    BtnIndex : integer;
    BtnWidth : integer;
    BtnHeight : integer;
    function BtnOffset(TabHeight : integer; Active : boolean) : integer;
    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
    procedure PaintButton(DC : hdc; TabRect : TRect; State : integer); virtual;
    function GetTabUnderMouse(p : TPoint) : integer;
    procedure RepaintTabs(DC : HDC; ActiveTabNdx : integer);
    procedure RepaintTab(i, State : integer; TabDC : hdc = 0);
    function VisibleTabsCount : integer;
    function IsSpecialTab(i : integer; IsMenu : boolean = False) : boolean;
    function CheckActiveTab(PageIndex : integer) : TTabSheet;
    function PageIndexFromTabIndex(TabIndex: Integer): Integer;
{$IFDEF DELPHI7UP}
    procedure SetTabIndex(Value: Integer); override;
{$ENDIF}
    property HoveredBtnIndex: integer read FHoveredBtnIndex write SetHoveredBtnIndex default -1;
  public
    property ActivePageIndex: Integer read GetActivePageIndex write SetActivePageIndex;
    property CurItem : integer read FCurItem write SetCurItem default -1;
    property ShowUpDown : boolean read FShowUpDown write SetShowUpDown default True;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
    procedure AfterConstruction; override;
    procedure UpdateActivePage; override;
    procedure CloseClick(Sender: TObject);
    procedure SetPadding(Value : boolean);
  published
    property ActivePage: TsTabSheet read GetActivePage write SetActivePage;
    property AnimatEvents : TacAnimatEvents read FAnimatEvents write FAnimatEvents default [aeGlobalDef];
    property AccessibleDisabledPages : boolean read FAccessibleDisabledPages write FAccessibleDisabledPages default True;
    property Style;
{$ENDIF}
    property ActiveIsBold : boolean read FActiveIsBold write SetActiveIsBold default False;
    property CloseBtnSkin : TsSkinSection read FCloseBtnSkin write SetCloseBtnSkin;
    property RotateCaptions : boolean read FRotateCaptions write SetRotateCaptions default False;
    property ShowCloseBtns : boolean read FShowCloseBtns write SetShowCloseBtns default False;
    property ShowFocus : boolean read FShowFocus write SetShowFocus default True;
    property SkinData : TsCommonData read FCommonData write FCommonData;
    property TabPadding : integer read FTabPadding write SetTabPadding default 0;
    property OnCloseBtnClick: TacCloseBtnClick read FOnCloseBtnClick write FOnCloseBtnClick;
    property OnDblClick;
    property OnPageChanging: TacTabChangingEvent read FOnPageChanging write FOnPageChanging;
    property OnTabMouseEnter: TacTabMouseEvent read FOnTabMouseEnter write FOnTabMouseEnter;
    property OnTabMouseLeave: TacTabMouseEvent read FOnTabMouseLeave write FOnTabMouseLeave;
  end;

procedure DeletePage(Page : TsTabSheet); // Page removing without switching to the first page

implementation

uses sMessages, sVclUtils, acntUtils, sMaskData, sStyleSimply, math, Commctrl, sSkinProps, sAlphaGraph, Buttons, sDefaults,
  sGraphUtils, sTabControl{$IFDEF DELPHI7UP}, Themes{$ENDIF}, sSkinManager {$IFDEF LOGGED}, sDebugMsgs{$ENDIF};

{ TsPageControl }

const
  BtnOffsX = 4; // Offset of the Close button from right border
  iBtnWidth = 15;
  iBtnHeight = 15;

var
  acBtnPressed : boolean = False;

procedure DeletePage(Page : TsTabSheet);
begin
  if (Page <> nil) and (Page.PageIndex > 0) then begin
    Page.PageIndex := Page.PageIndex - 1;
    Page.Free
  end;
end;

procedure TsPageControl.AfterConstruction;
begin
  inherited;
  SkinData.Loaded;
end;

procedure TsPageControl.CheckUpDown;
var
  Wnd : HWND;
begin
  if (csLoading in ComponentState) or (csCreating in ControlState) then Exit;
  if FCommonData.Skinned then begin
    Wnd := FindWindowEx(Handle, 0, UPDOWN_CLASS, nil);
    if (Wnd <> 0) then begin
      if FShowUpDown then begin
        if (SpinWnd <> nil) and (SpinWnd.CtrlHandle <> Wnd) then FreeAndNil(SpinWnd);
        if SpinWnd = nil then begin
          SpinWnd := TacSpinWnd.Create(Wnd, nil, SkinData.SkinManager, SpinSection);
          InitCtrlData(Wnd, SpinWnd.ParentWnd, SpinWnd.WndRect, SpinWnd.ParentRect, SpinWnd.WndSize, SpinWnd.WndPos);
        end;
      end
      else DestroyWindow(Wnd);
    end;
  end
  else if SpinWnd <> nil then FreeAndNil(SpinWnd);
end;

procedure TsPageControl.CMDockClient(var Message: TCMDockClient);
var
  IsVisible: Boolean;
  DockCtl: TControl;
  I: Integer;
begin
  with Message do begin
    Result := 0;
    DockCtl := DockSource.Control;
    for I := 0 to PageCount - 1 do begin
      if DockCtl.Parent = Pages[I] then begin
        Pages[I].PageIndex := PageCount - 1;
        Exit;
      end;
    end;
    FNewDockSheet := TsTabSheet.Create(Self);
    try
      try
        if DockCtl is TCustomForm then FNewDockSheet.Caption := TCustomForm(DockCtl).Caption;
        FNewDockSheet.PageControl := Self;
        DockCtl.Dock(Self, DockSource.DockRect);
      except
        FNewDockSheet.Free;
        raise;
      end;
      IsVisible := DockCtl.Visible;
      FNewDockSheet.TabVisible := IsVisible;
      if IsVisible then ActivePage := FNewDockSheet;
      DockCtl.Align := alClient;
    finally
      FNewDockSheet := nil;
    end;
  end;
end;

procedure TsPageControl.CMHintShow(var Message: TMessage);
var
  Item : integer;
  P : TPoint;
begin
  with TCMHintShow(Message) do begin
    Item := GetTabUnderMouse(Point(HintInfo.CursorPos.X, HintInfo.CursorPos.Y));
    if Item <> -1 then with HintInfo^ do begin
      P := ClientToScreen(HintInfo.CursorPos);
      P.X := P.X + GetSystemMetrics(SM_CXCURSOR) div 2;
      P.Y := P.Y + GetSystemMetrics(SM_CYCURSOR) div 2;
      HintInfo.HintPos := P;
      HintInfo.HintStr := Pages[Item].Hint;
      Message.Result := 0;
    end;
  end;
end;

procedure TsPageControl.CNNotify(var Message: TWMNotify);
begin
  if FCommonData.Skinned then case Message.NMHdr^.code of
    TCN_SELCHANGE : begin
      inherited;
      if not (csDesigning in ComponentState) and FCommonData.SkinManager.AnimEffects.PageChange.Active and (ow <> nil) then begin
        AnimShowControl(Self, FCommonData.SkinManager.AnimEffects.PageChange.Time);
        if ActivePage <> nil then RedrawWindow(ActivePage.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);
      end;
      Exit;
    end;
    TCN_SELCHANGING : begin
      if not (csDesigning in ComponentState) and FCommonData.SkinManager.AnimEffects.PageChange.Active then PrepareForAnimation(Self);
    end;
  end;
  inherited;
  if FCommonData.Skinned then case Message.NMHdr^.code of
    TCN_SELCHANGING : if (Message.Result = 1) or (ow = nil) {Animation cancelled} then begin
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
      if ow <> nil then FreeAndNil(ow);
      SendMessage(Handle, WM_MOUSEMOVE, 0, 0);
    end;
  end;
end;

constructor TsPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommonData := TsCommonData.Create(Self, True);
  FCommonData.COC := COC_TsPageControl;
  FAnimatEvents := [aeGlobalDef];
  FShowCloseBtns := False;
  FShowUpDown := True;
  FShowFocus := True;
  FHoveredBtnIndex := -1;
  FPressedBtnIndex := -1;
  FRotateCaptions := False;
  FActiveIsBold := False;
  FAccessibleDisabledPages := True;
  DroppedDownItem := -1;
  SpinWnd := nil;
  FCurItem := -1;
end;

destructor TsPageControl.Destroy;
begin
  if Assigned(SpinWnd) then FreeAndNil(SpinWnd);
  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  inherited Destroy;
end;

procedure TsPageControl.DoAddDockClient(Client: TControl; const ARect: TRect);
begin
  if FNewDockSheet <> nil then Client.Parent := FNewDockSheet;
end;

const
  Spacing = 6;

function MakeVertFont(DC : hdc; Font : TFont; Orient : integer) : hFont;
var
  pFont : PLogFontA;
  NewFont : hFont;
  VertFont : TLogFont;
begin
  pFont := PLogFontA(@VertFont);
  GetObject(DC, SizeOf(TLogFont), pFont);

  VertFont.lfEscapement := Orient;
  VertFont.lfHeight := Font.Height;
  VertFont.lfStrikeOut := integer(fsStrikeOut in Font.Style);
  VertFont.lfItalic := integer(fsItalic in Font.Style);
  VertFont.lfUnderline := integer(fsUnderline in Font.Style);
  if fsBold in Font.Style then VertFont.lfWeight := FW_BOLD else VertFont.lfWeight := FW_NORMAL;
  VertFont.lfCharSet := Font.Charset;

  VertFont.lfWidth := 0;
  VertFont.lfOutPrecision := OUT_DEFAULT_PRECIS;
  VertFont.lfClipPrecision := CLIP_DEFAULT_PRECIS;
  VertFont.lfOrientation := VertFont.lfEscapement;
  VertFont.lfPitchAndFamily := Default_Pitch;
  VertFont.lfQuality := Default_Quality;
  if Font.Name <> 'MS Sans Serif' then StrPCopy(VertFont.lfFaceName, Font.Name) else VertFont.lfFaceName := 'Arial';
  NewFont := CreateFontIndirect(VertFont);
  Result := SelectObject(DC, NewFont);
  SetTextColor(DC, ColorToRGB(Font.Color));
end;

procedure TsPageControl.DrawSkinTab(PageIndex, State: integer; DstDC : hdc);
var
  rText, aRect, rTab, rBmp : TRect;
  Page : TsTabSheet;
  CI : TCacheInfo;
  TabIndex, TabState : integer;
  TabSection : string;
  TempBmp : Graphics.TBitmap;
  SavedDC, DC : hdc;
  lCaption: ACString;
  Flags : Cardinal;
  bTabMenu : boolean;
  OldFont : hFont;
  dContent : TacTabData;
begin
  if (PageIndex = -1) then Exit;
  bTabMenu := IsSpecialTab(PageIndex);
  Page := TsTabSheet(Pages[PageIndex]);
  if not Page.TabVisible then Exit;

  rTab := SkinTabRect(Page.TabIndex, (State = 2) and not bTabMenu);
  if (State <> 0) and (rTab.Left < 0) then Exit;

  if FCommonData.SkinManager.ConstData.IndexTabTop = -1 then Exit;

  // Tabs drawing
  TabState := State;
  if bTabMenu then begin
    if TsTabSheet(Page).TabSkin <> '' then begin
      TabSection := Page.TabSkin;
      TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
    end
    else begin
      TabSection := s_MenuButton;
      TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
    end;
    if TabIndex < 0 then begin
      if Page.TabType = ttMenu then TabSection := s_MenuItem else begin
        TabSection := s_SpeedButton;
      end;
      TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
    end;
    if TabPosition in [tpTop, tpBottom] then InflateRect(rTab, -3, -1) else InflateRect(rTab, -1, -3);
  end
  else case Style of
    tsTabs : begin
      if TsTabSheet(Page).TabSkin <> '' then begin
        TabSection := Page.TabSkin;
        TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
      end
      else case TabPosition of // Init of skin data
        tpTop : begin TabIndex := FCommonData.SkinManager.ConstData.IndexTabTop; TabSection := s_TabTop end;
        tpLeft : begin TabIndex := FCommonData.SkinManager.ConstData.IndexTabLeft; TabSection := s_TabLeft end;
        tpBottom : begin TabIndex := FCommonData.SkinManager.ConstData.IndexTabBottom; TabSection := s_TabBottom end
        else begin TabIndex := FCommonData.SkinManager.ConstData.IndexTabRight; TabSection := s_TabRight end;
      end;
    end;
    tsButtons : begin
      if Page.TabSkin <> '' then TabSection := Page.TabSkin else TabSection := s_Button;
      TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
    end
    else begin
      if Page.TabSkin <> '' then TabSection := Page.TabSkin else TabSection := s_ToolButton;
      TabIndex := FCommonData.SkinManager.GetSkinIndex(TabSection);
    end;
  end;
  rText := rTab;
  aRect := rTab;

{$IFDEF TNTUNICODE}
  if Page is TTntTabSheet then lCaption := TTntTabSheet(Page).Caption else
{$ENDIF}
  lCaption := Page.Caption;
  CI := GetParentCache(FCommonData);
  // Draw tab on bitmap
  TempBmp := CreateBmp32(WidthOf(rTab), HeightOf(rTab));
  rBmp := Rect(0, 0, TempBmp.Width, TempBmp.Height);
  TempBmp.Canvas.Font := Font;
  if ActiveIsBold and (Page = ActivePage)
    then TempBmp.Canvas.Font.Style := TempBmp.Canvas.Font.Style + [fsBold];
  TempBmp.Canvas.Brush.Style := bsClear;
  if TabIndex <> -1 then begin
    if FCommonData.SkinManager.gd[TabIndex].States <= TabState then TabState := FCommonData.SkinManager.gd[TabIndex].States - 1;
    if State <> 0
      then TempBmp.Canvas.Font.Color := FCommonData.SkinManager.gd[TabIndex].HotFontColor[1]
      else TempBmp.Canvas.Font.Color := FCommonData.SkinManager.gd[TabIndex].FontColor[1];
  end;

  inc(CI.X, Left);
  inc(CI.Y, Top);
  PaintItem(TabIndex, TabSection, CI, True, TabState, rBmp, Point(rTab.Left, rTab.Top), TempBmp, FCommonData.SkinManager);

  // End of tabs drawing
  if not OwnerDraw then begin
    // Tab content drawing
    Flags := DT_SINGLELINE or DT_VCENTER;
    if UseRightToLeftReading then Flags := Flags or DT_RTLREADING or DT_NOCLIP;

    OldFont := 0;
    if (TabPosition in [tpLeft, tpRight]) and not RotateCaptions or (TabPosition in [tpTop, tpBottom]) and RotateCaptions // If vertical text
      then OldFont := MakeVertFont(TempBmp.Canvas.Handle, TempBmp.Canvas.Font, -2700); // Rotated font initialization
    // Get coordinates for tab content
    InitTabContentData(TempBmp.Canvas, Page, rBmp, State, bTabMenu, dContent);
    // Draw glyph if rect is not empty
    if not IsRectEmpty(dContent.GlyphRect) then Images.Draw(TempBmp.Canvas, dContent.GlyphRect.Left, dContent.GlyphRect.Top, Page.ImageIndex, True);
    // Write Text
    if dContent.ArrowRect.Left = dContent.ArrowRect.Right then Flags := Flags or DT_END_ELLIPSIS; // Draw ellipsis if not menu
    if OldFont <> 0 then begin // If font is rotated
      lCaption := CutText(TempBmp.Canvas, lCaption, HeightOf(dContent.TextRect));
      acTextRect(TempBmp.Canvas, dContent.TextRect, dContent.TextPos.X, dContent.TextPos.Y, lCaption);
      SelectObject(TempBmp.Canvas.Handle, OldFont); // Returning prev. font
    end
    else begin
      WriteText32(TempBmp, PacChar(lCaption), True, dContent.TextRect, Flags, -1, True, SkinData.SkinManager);
    end;
    // Paint focus rect
    if not IsRectEmpty(dContent.FocusRect) then begin
      TempBmp.Canvas.Pen.Color := clWindowFrame;
      TempBmp.Canvas.Brush.Color := clBtnFace;
      TempBmp.Canvas.Brush.Style := bsClear;
      TempBmp.Canvas.DrawFocusRect(dContent.FocusRect);
    end;
    // Paint Close btn
    if not IsRectEmpty(dContent.BtnRect)
      then PaintButton(TempBmp.Canvas.Handle, dContent.BtnRect, integer(FHoveredBtnIndex = PageIndex) + integer(FPressedBtnIndex = PageIndex));
    // Draw Arrow
    if not IsRectEmpty(dContent.ArrowRect) then DrawColorArrow(TempBmp.Canvas, TempBmp.Canvas.Font.Color, dContent.ArrowRect, dContent.ArrowDirection);

    if not Page.Enabled or not Enabled then BlendTransRectangle(TempBmp, 0, 0, FCommonData.FCacheBmp, rTab, DefDisabledBlend);

    BitBlt(DstDC, aRect.Left, aRect.Top, TempBmp.Width, TempBmp.Height, TempBmp.Canvas.Handle, 0, 0, SRCCOPY);
  end
  else if Assigned(OnDrawTab) then begin
    BitBlt(DstDC, aRect.Left, aRect.Top, TempBmp.Width, TempBmp.Height, TempBmp.Canvas.Handle, 0, 0, SRCCOPY);
    DC := Canvas.Handle;
    Canvas.Handle := DstDC;
    SavedDC := SaveDC(Canvas.Handle);
    OnDrawTab(Self, Page.TabIndex, aRect, State <> 0);
    RestoreDC(Canvas.Handle, SavedDC);
    Canvas.Handle := DC;
  end;
  FreeAndNil(TempBmp);
end;

procedure TsPageControl.DrawSkinTabs;
var
  i : integer;
begin
  if (csDestroying in ComponentState) then Exit;
  FCommonData.FCacheBmp.Canvas.Lock;
  for i := 0 to PageCount - 1 do if Pages[i].TabVisible and ((Pages[i] <> ActivePage) or (TsTabSheet(Pages[i]).TabType <> ttTab)) then begin
    if DroppedDownItem = i
      then DrawSkinTab(i, 2, FCommonData.FCacheBmp.Canvas.Handle)
      else DrawSkinTab(i, integer(CurItem = i), FCommonData.FCacheBmp.Canvas.Handle);
  end;
  // Draw active tab
  if (Tabs.Count > 0) and (ActivePage <> nil) and (ActivePage.TabType = ttTab) then DrawSkinTab(ActivePage.PageIndex, 2, FCommonData.FCacheBmp.Canvas.Handle);
  FCommonData.FCacheBmp.Canvas.UnLock;
end;

function TsPageControl.GetActivePage: TsTabSheet;
begin
  Result := TsTabSheet(inherited ActivePage);
end;

function TsPageControl.GetTabUnderMouse(p: TPoint): integer;
var
  i : integer;
  R : TRect;
begin
  Result := -1;
  for i := 0 to Self.PageCount - 1 do begin
    R := SkinTabRect(Pages[i].TabIndex, False);
    if PtInRect(R, p) then begin
      Result := i;
      Exit;
    end;
  end;
end;

procedure TsPageControl.Loaded;
begin
  inherited;
  SkinData.Loaded;
  if ActivePage <> nil then begin
    AddToAdapter(ActivePage);
    CheckUpDown;
    inherited ActivePage := CheckActiveTab(ActivePage.PageIndex);
  end;
end;

function TsPageControl.PageRect: TRect;
var
  r : TRect;
begin
  Result := Rect(0, 0, Width, Height);
  if Tabs.Count > 0 then begin
    AdjustClientRect(r);
    case TabPosition of
      tpTop : Result.Top := R.Top - TopOffset;
      tpBottom : Result.Bottom := R.Bottom + BottomOffset;
      tpLeft : Result.Left := R.Left - LeftOffset;
      tpRight : Result.Right := R.Right + RightOffset;
    end;
  end;
end;

procedure TsPageControl.RepaintTab(i, State: integer; TabDC : hdc = 0);
var
  DC, SavedDC : hdc;
  R : TRect;
begin
  if (i < 0) or (i >= PageCount) then Exit;  
  if TabDC = 0 then DC := GetDC(Handle) else DC := TabDC;
  SavedDC := SaveDC(DC);
  try
    R := TabRect(Pages[i].TabIndex);
    if (ActivePage <> nil) and (ActivePage.TabType = ttTab) and (Pages[i] <> ActivePage) then begin
      InterSectClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
      if FCommonData.Skinned then R := SkinTabRect(ActivePage.TabIndex, True) else begin
        R := TabRect(ActivePage.TabIndex);
        InflateRect(R, 2, 2);
      end;
      ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom)
    end;
    if DroppedDownItem = i
      then State := 2;
    if FCommonData.Skinned then DrawSkinTab(i, State, DC) else DrawStdTab(i, State, DC);
  finally
    RestoreDC(DC, SavedDC);
    if TabDC = 0 then ReleaseDC(Handle, DC);
  end;
end;

procedure TsPageControl.RepaintTabs(DC : HDC; ActiveTabNdx : integer);
var
  R : TRect;
  CI : TCacheInfo;
begin
  if not ((csDesigning in ComponentState) or not SkinData.SkinManager.AnimEffects.PageChange.Active) then Exit;
  CI := GetParentCache(FCommonData);
  R := TabsRect;
  if not ci.Ready then begin
    FCommonData.FCacheBmp.Canvas.Brush.Style := bsSolid;
    FCommonData.FCacheBmp.Canvas.Brush.Color := CI.FillColor;
    FCommonData.FCacheBmp.Canvas.FillRect(R);
  end
  else BitBlt(FCommonData.FCacheBmp.Canvas.Handle, R.Left, R.Top, min(WidthOf(R), ci.Bmp.Width), min(HeightOf(R), ci.Bmp.Height),
         ci.Bmp.Canvas.Handle, ci.X + Left + R.Left, ci.Y + Top + R.Top, SRCCOPY);

  if Tabs.Count > 0 then DrawSkinTabs;

  BitBlt(DC, R.Left, R.Top, WidthOf(R), HeightOf(R) + 2, FCommonData.FCacheBmp.Canvas.Handle, R.Left, R.Top, SRCCOPY);
//  PaintButtons(DC);
end;

procedure TsPageControl.SetActivePage(const Value: TsTabSheet);
begin
  if Value <> nil then begin
    inherited ActivePage := CheckActiveTab(Value.PageIndex);
    if not Value.TabVisible and not SkinData.FUpdating then SetParentUpdated(Value); // Update because TCM_SETCURSEL is not received
  end
  else inherited ActivePage := nil;
end;

function TsPageControl.SkinTabRect(Index: integer; Active : boolean): TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (Index >= 0) and (Index < PageCount) then begin
    Result := TabRect(Index);
    if (Style = tsTabs) and (Result.Left <> Result.Right) and Active then InflateRect(Result, 2, 2);
  end;
end;

function TsPageControl.SpinSection: string;
begin
  if SkinData.SkinManager.GetSkinIndex(s_UpDown) < 0 then Result := s_Button else Result := s_UpDown;
end;

function TsPageControl.TabsRect: TRect;
var
  r : TRect;
begin
  if Tabs.Count > 0 then begin
    Result := Rect(0, 0, Width, Height);
    AdjustClientRect(r);
    case TabPosition of
      tpTop : Result.Bottom := R.Top - TopOffset;
      tpBottom : Result.Top := R.Bottom + BottomOffset;
      tpLeft : Result.Right := R.Left - LeftOffset;
      tpRight : Result.Left := R.Right + RightOffset;
    end;
  end
  else Result := Rect(0, 0, 0, 0);
end;

procedure TsPageControl.UpdateActivePage;
var
  DC, SavedDC : hdc;
begin
  inherited;
  if FCommonData.Skinned then begin
    if not SkinData.SkinManager.AnimEffects.PageChange.Active then begin
      if FCommonData.Updating then Exit;
      if StoredVisiblePageCount <> VisibleTabsCount then begin
        Perform(WM_PAINT, 0, 0);
        if Assigned(ActivePage) then ActivePage.Repaint
      end
      else begin
        if ActivePage <> nil then begin // Active tab repainting
          DC := GetDC(Handle);
          SavedDC := SaveDC(DC);
          SkinData.BGChanged := True;
          RepaintTabs(DC, ActivePage.PageIndex);
          try
            DrawSkinTab(ActivePage.PageIndex, 2, DC)
          finally
            RestoreDC(DC, SavedDC);
            ReleaseDC(Handle, DC);
          end;
        end
        else FCommonData.Invalidate;
      end;
    end;
  end
(*  else
{$IFDEF DELPHI7UP}
  if not ThemeServices.ThemesEnabled then
{$ENDIF}
  InvalidateRect(Handle, nil, False);
  RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW);// or RDW;*)
end;

function TsPageControl.VisibleTabsCount: integer;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to PageCount - 1 do if Pages[i].TabVisible then inc(Result);
end;

procedure TsPageControl.AcPaint(var Message: TWMPaint);
var
  DC, SavedDC : hdc;
  ci : TCacheInfo;
  i : integer;
  R : TRect;
  b : boolean;
begin
  if (csDestroying in Parent.ComponentState) or (csLoading in ComponentState) {or (DroppedDownItem >= 0) {If tabmenu is dropped down} then Exit;

  FCommonData.FUpdating := FCommonData.Updating;
  if not FCommonData.FUpdating then FCommonData.FUpdating := GetBoolMsg(Parent, AC_PREPARING); // Transparent BG may be not ready if PageControl haven't cached BG
  if not FCommonData.FUpdating then begin
    if (SkinData.CtrlSkinState and ACS_PRINTING = ACS_PRINTING) and (Message.DC = SkinData.PrintDC) then DC := Message.DC else begin
      DC := GetDC(Handle);
    end;
    try
      // If transparent and form resizing processed
      b := FCommonData.BGChanged or FCommonData.HalfVisible or GetBoolMsg(Parent, AC_GETHALFVISIBLE);
      GetClipBox(DC, R); // If control is shown partially (remember it)
      FCommonData.HalfVisible := (WidthOf(R) <> Width) or (HeightOf(R) <> Height);
      if b then begin // If cache is changed
        if (TabPosition <> tpTop) and (FCommonData.SkinSection = s_PageControl) then begin
          case TabPosition of
            tpLeft :   ChangedSkinSection := s_PageControl + 'LEFT';
            tpRight :  ChangedSkinSection := s_PageControl + 'RIGHT';
            tpBottom : ChangedSkinSection := s_PageControl + 'BOTTOM';
          end;
          FCommonData.SkinIndex := FCommonData.SkinManager.GetSkinIndex(ChangedSkinSection);
          FCommonData.BorderIndex := FCommonData.SkinManager.GetMaskIndex(FCommonData.SkinIndex, ChangedSkinSection, s_BordersMask);
        end
        else ChangedSkinSection := FCommonData.SkinSection;
        InitCacheBmp(SkinData);
        CI := GetParentCache(FCommonData);

        R := PageRect;
        PaintItemBG(FCommonData, CI, 0, R, Point(Left + R.Left, Top + r.Top), FCommonData.FCacheBmp);

        with FCommonData.SkinManager.gd[SkinData.SkinIndex], FCommonData.SkinManager do begin
          if IsValidImgIndex(ImgTL) then DrawSkinGlyph(FCommonData.FCacheBmp, Point(R.Left, R.Top), 0, 1, ma[ImgTL], MakeCacheInfo(FCommonData.FCacheBmp));
          if IsValidImgIndex(ImgTR) then DrawSkinGlyph(FCommonData.FCacheBmp, Point(R.Right - WidthOfImage(ma[ImgTR]), R.Top), 0, 1, ma[ImgTR], MakeCacheInfo(FCommonData.FCacheBmp));
          if IsValidImgIndex(ImgBL) then DrawSkinGlyph(FCommonData.FCacheBmp, Point(0, R.Bottom - HeightOfImage(ma[ImgBL])), 0, 1, ma[ImgBL], MakeCacheInfo(FCommonData.FCacheBmp));
          if IsValidImgIndex(ImgBR) then DrawSkinGlyph(FCommonData.FCacheBmp, Point(R.Right - WidthOfImage(ma[ImgBR]), R.Bottom - HeightOfImage(ma[ImgBR])), 0, 1, ma[ImgBR], MakeCacheInfo(FCommonData.FCacheBmp));
        end;
        if FCommonData.BorderIndex > -1 then DrawSkinRect(FCommonData.FCacheBmp, R, True, CI, FCommonData.SkinManager.ma[FCommonData.BorderIndex], 0, True);

        if (ActivePage <> nil) and not (csDestroying in ActivePage.ComponentState) and (ActivePage.SkinData.SkinSection <> '') then begin
          i := FCommonData.SkinManager.GetSkinIndex(ActivePage.SkinData.SkinSection);
          if FCommonData.SkinManager.IsValidSkinIndex(i) then begin
            R := ActivePage.BoundsRect;
            PaintItem(i, ActivePage.SkinData.SkinSection, MakeCacheInfo(FCommonData.FCacheBmp), True, 0, R, Point(0, 0), FCommonData.FCacheBmp, FCommonData.SkinManager);
          end;
        end;

        R := TabsRect;
        // Update BG under tabs
        if not ci.Ready then begin
          FCommonData.FCacheBmp.Canvas.Brush.Style := bsSolid;
          FCommonData.FCacheBmp.Canvas.Brush.Color := CI.FillColor;
          FCommonData.FCacheBmp.Canvas.FillRect(R);
        end
        else BitBlt(FCommonData.FCacheBmp.Canvas.Handle, R.Left, R.Top, min(WidthOf(R), ci.Bmp.Width), min(HeightOf(R), ci.Bmp.Height),
               ci.Bmp.Canvas.Handle, ci.X + Left + R.Left, ci.Y + Top + R.Top, SRCCOPY);

        R := PageRect;
        SavedDC := SaveDC(DC);
        ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
        if Tabs.Count > 0 then DrawSkinTabs;
        RestoreDC(DC, SavedDC);

        FCommonData.BGChanged := False;
      end;
      // Output to DC
      if DroppedDownItem >= 0 then begin // If TabMenu is dropped down then don't repaint
        SavedDC := SaveDC(DC);
        R := TabRect(DroppedDownItem);
        ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
        CopyWinControlCache(Self, FCommonData,  Rect(0, 0, 0, 0), Rect(0, 0, Width, Height), DC, True);
        RestoreDC(DC, SavedDC);
      end
      else CopyWinControlCache(Self, FCommonData,  Rect(0, 0, 0, 0), Rect(0, 0, Width, Height), DC, True);
      sVCLUtils.PaintControls(DC, Self, True, Point(0, 0)); // Paint skinned TGraphControls

      if (Tabs.Count > 0) and (ActivePage <> nil) then begin // Draw active tab
{$IFDEF D2005}
        if (csDesigning in ComponentState) then begin
          RedrawWindow(ActivePage.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE);
          SetParentUpdated(ActivePage);
        end
        else
{$ENDIF}
          if (ActivePage.BorderWidth > 0) then ActivePage.Perform(WM_NCPAINT, 0, 0);
      end;
    finally
      if DC <> Message.DC then begin
        ReleaseDC(Handle, DC);
      end;
    end;
  end;
  StoredVisiblePageCount := VisibleTabsCount;
  Message.Result := 1;
end;

function CanBeActive(Page : TsTabSheet; PageControl : TsPageControl) : boolean;
var
  b : boolean;
begin
  Result := False;
  if (Page = nil) or (Page.TabType <> ttTab) or (not PageControl.AccessibleDisabledPages and not Page.Enabled) then Exit;
  if Assigned(PageControl.OnPageChanging) then begin
    b := True;
    PageControl.OnPageChanging(PageControl, Page, b);
    if not b then Exit;
  end;
  Result := True;
end;

procedure TsPageControl.WndProc(var Message: TMessage);
var
  DC, SavedDC : hdc;
  R : TRect;
  p : TPoint;
  NewItem, i : integer;
  b : boolean;
  Act : TacCloseAction;
  PS : TPaintStruct;
  Page : TsTabSheet;
  TabData : TacTabData;
  aMsg : tagMSG;
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  case Message.Msg of
    WM_PAINT : if (Visible or (csDesigning in ComponentState)) then begin
      TWMPaint(Message).DC := BeginPaint(Handle, PS);
      if FCommonData.Skinned then begin
        if IsCached(FCommonData) and not InAnimationProcess then AcPaint(TWMPaint(Message));
      end
      else StdPaint(TWMPaint(Message));
      ReleaseDC(Handle, TWMPaint(Message).DC);
      EndPaint(Handle, PS);
      Message.Result := 0;
      Exit;
    end
    else inherited;
    TCM_SETCURSEL : begin
      inherited;
      if FCommonData.Skinned then begin
        FCommonData.BGChanged := True;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME);
        if not SkinData.FUpdating
          then SetParentUpdated(Self);
      end
      else RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME);
      Exit;
    end;
    TCM_SETIMAGELIST : begin
      inherited;
      if HandleAllocated then Perform(WM_SIZE, 0, 0);
      CheckUpDown;
      Exit;
    end;
    CM_DIALOGKEY : If (TWMKey(Message).CharCode = Ord(#9)) and (GetKeyState(VK_CONTROL) < 0) and (ActivePage <> nil) then begin
      Page := nil;
      if ActivePage.PageIndex = PageCount - 1 then i := 0 else i := ActivePage.PageIndex + 1;
      while i < PageCount do begin
        if Pages[i].TabVisible then begin
          Page := TsTabSheet(Pages[i]);
          Break;
        end;
        inc(i);
      end;
      if not CanBeActive(Page, Self) then Exit;
    end;
    WM_KEYDOWN : begin
      case Message.WParamLo of
        VK_LEFT : if ActivePage <> nil then begin
          Page := nil;
          for i := ActivePage.PageIndex - 1 downto 0 do if Pages[i].TabVisible then begin
            Page := TsTabSheet(Pages[i]);
            Break;
          end;
          if not CanBeActive(Page, Self) then Exit;
        end;
        VK_RIGHT : if ActivePage <> nil then begin
          Page := nil;
          for i := ActivePage.PageIndex + 1 to PageCount - 1 do if Pages[i].TabVisible then begin
            Page := TsTabSheet(Pages[i]);
            Break;
          end;
          if not CanBeActive(Page, Self) then Exit;
        end;
      end;
    end;
    WM_MOUSELEAVE, CM_MOUSELEAVE : if not (csDesigning in ComponentState) {and (HotTrack or FShowCloseBtns) }then begin
      FPressedBtnIndex := -1;
      acBtnPressed := False;
      if (CurItem >= 0) and (CurItem < PageCount) and Assigned(FOnTabMouseLeave) then FOnTabMouseLeave(Self, CurItem);
      if (CurItem >= 0) and (CurItem < PageCount) and (DroppedDownItem = -1) {and ((Pages[CurItem] <> ActivePage) {or (TsTabSheet(Pages[CurItem]).TabType <> ttTab))}  then begin
        if (Pages[CurItem] <> ActivePage) then begin
          if TsTabSheet(Pages[CurItem]).TabType <> ttTab then begin // If tab have transparent BG
            R := TabRect(Pages[CurItem].TabIndex);
            CurItem := -1;
            RedrawWindow(Handle, @R, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE);
          end
          else RepaintTab(CurItem, 0); // Repaint old tab in normal state
        end
        else begin
          RepaintTab(CurItem, 2); // Repaint old tab in normal state
        end;
        if (SkinData = nil) or not SkinData.Skinned then inherited;
      end
      else inherited;
      FPressedBtnIndex := -1;
      FHoveredBtnIndex := -1;
      CurItem := -1;
      Exit;
    end;
    WM_MOUSEMOVE : if not (csDesigning in ComponentState) then begin
      if (DefaultManager <> nil) and not (csDesigning in DefaultManager.ComponentState) then DefaultManager.ActiveControl := Handle;
      if True{HotTrack or (Style <> tsTabs) or FShowCloseBtns} then begin
        p.x := TCMHitTest(Message).XPos; p.y := TCMHitTest(Message).YPos;
        NewItem := GetTabUnderMouse(p);
        if (NewItem > -1) and TsTabSheet(Pages[NewItem]).Enabled then begin // If tab is hovered
          inherited;
          PeekMessage(aMsg, Handle, WM_PAINT, WM_PAINT, PM_REMOVE); // Prevent an automatic repainting
          Application.ProcessMessages;
          if (NewItem < 0) or (NewItem >= PageCount) then Exit;

          if FShowCloseBtns and (NewItem > -1) then case TsTabSheet(Pages[NewItem]).TabType of
            ttTab : begin // Check if Close button was hovered
              InitTabContentData(Canvas, Pages[NewItem], TabRect(Pages[NewItem].TabIndex), 1 + integer(Pages[NewItem] = ActivePage), False, TabData);
              if PtInRect(TabData.BtnRect, p) then begin
                if (FHoveredBtnIndex <> NewItem) then begin
                  if (FHoveredBtnIndex <> -1) then RepaintTab(FHoveredBtnIndex, 0);
                  FHoveredBtnIndex := NewItem;
                  RepaintTab(FHoveredBtnIndex, 1 + integer(Pages[NewItem] = ActivePage));
                end;
                Exit;
              end
              else if (FHoveredBtnIndex <> -1) then begin
                FHoveredBtnIndex := -1;
                FPressedBtnIndex := -1;
                RepaintTab(NewItem, 1 + integer(Pages[NewItem] = ActivePage));
              end;
            end
          end;
          if (NewItem <> CurItem) then begin // If hot item is changed
            if (CurItem > -1) and (CurItem < PageCount) {and (ActivePage <> Pages[CurItem]) }then begin
              if ActivePage <> Pages[CurItem] then begin
                if Assigned(FOnTabMouseLeave) then FOnTabMouseLeave(Self, CurItem);
                if TsTabSheet(Pages[CurItem]).TabType <> ttTab then begin // If tab have transparent BG
                  R := TabRect(Pages[CurItem].TabIndex);
                  if (Pages[NewItem] <> ActivePage) then CurItem := NewItem else CurItem := -1;
                  RedrawWindow(Handle, @R, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE);
                end
                else begin
                  RepaintTab(CurItem, 0); // Repaint old tab in normal state
                  CurItem := NewItem;
                end;
              end
              else begin // If CurItem is ActiveTab
                if Assigned(FOnTabMouseLeave) then FOnTabMouseLeave(Self, CurItem);
                RepaintTab(CurItem, 2); // Repaint old tab in normal state
              end;
            end;
            if Assigned(FOnTabMouseEnter) then FOnTabMouseEnter(Self, NewItem);
            CurItem := NewItem;
            if (Pages[NewItem] <> ActivePage) then begin
              if (CurItem > -1) and ((Pages[CurItem] <> ActivePage) or (TsTabSheet(Pages[CurItem]).TabType <> ttTab)) then RepaintTab(CurItem, 1);
            end;
          end;
        end
        else begin
          FHoveredBtnIndex := -1;
          FPressedBtnIndex := -1;
          if (CurItem <> -1) then begin
            RepaintTab(CurItem, 2 * integer(Pages[CurItem] = ActivePage)); // Repaint old tab in normal state
            CurItem := -1;
            acBtnPressed := False;
          end;
        end;
      end;
      Exit;
    end;
    WM_LBUTTONUP, WM_LBUTTONDOWN : if not (csDesigning in ComponentState) then begin
      if not Enabled then Exit;
      p.x := TCMHitTest(Message).XPos;
      p.y := TCMHitTest(Message).YPos;
      NewItem := GetTabUnderMouse(p);
      if (NewItem > -1) then begin // If tab is pressed
        if not FAccessibleDisabledPages and not TsTabSheet(Pages[NewItem]).Enabled then Exit;
        case TsTabSheet(Pages[NewItem]).TabType of
          ttMenu : begin
            if (TsTabSheet(Pages[NewItem]).TabMenu <> nil) and (Message.Msg = WM_LBUTTONDOWN) then begin
              DroppedDownItem := NewItem;
              RepaintTab(NewItem, 2);
              p := ClientToScreen(Point(0, 0));
              R := TabRect(Pages[NewItem].TabIndex);
              TempControl := pointer(Self);
              TsTabSheet(Pages[NewItem]).TabMenu.PopupComponent := Self;
              if (TabPosition in [tpLeft, tpRight]) and not RotateCaptions or (TabPosition in [tpTop, tpBottom]) and RotateCaptions
                then TsTabSheet(Pages[NewItem]).TabMenu.Popup(p.X + R.Right, p.Y + R.Top)
                else TsTabSheet(Pages[NewItem]).TabMenu.Popup(p.X + R.Left, p.Y + R.Bottom);
              TsTabSheet(Pages[NewItem]).TabMenu.PopupComponent := nil;
              TempControl := nil;
            end;
            DroppedDownItem := -1;
            CurItem := -1;
            RepaintTab(NewItem, 1);
            FCommonData.FUpdating := False;
            RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW or RDW_FRAME);
            Perform(WM_NCPAINT, 0, 0);
            Exit;
          end;
          ttButton : begin
            if Message.Msg = WM_LBUTTONDOWN then begin
              FCommonData.FUpdating := True;
              RepaintTab(NewItem, 2);
              FCommonData.FUpdating := False;
            end
            else begin
              RepaintTab(NewItem, 1);
              if Assigned(TsTabSheet(Pages[NewItem]).OnClickBtn) then TsTabSheet(Pages[NewItem]).OnClickBtn(Pages[NewItem]);
            end;
            Exit;
          end
          else if FShowCloseBtns and TsTabSheet(Pages[NewItem]).UseCloseBtn then begin
            InitTabContentData(Canvas, Pages[NewItem], TabRect(Pages[NewItem].TabIndex), 1 + integer(Pages[NewItem] = ActivePage), IsSpecialTab(NewItem), TabData);
            if PtInRect(TabData.BtnRect, p) then begin
              if (WM_LBUTTONDOWN = Message.Msg) then FPressedBtnIndex := NewItem;
              RepaintTab(NewItem, 1 + integer(ActivePage = Pages[NewItem]));
              if (WM_LBUTTONUP = Message.Msg) then begin
                if not acBtnPressed then Exit;
                Act := acaFree;
                b := True;
                if Assigned(OnCloseBtnClick) then OnCloseBtnClick(Self, NewItem, b, Act);
                if b and (Pages[NewItem] <> nil) then begin
                  i := ActivePageIndex;
                  Perform(WM_SETREDRAW, 0, 0);
                  if Act = acaFree then Pages[NewItem].Free else Pages[NewItem].TabVisible := False;
                  if (i >= 0) and (PageCount > 0) then begin
                    ActivePage := TsTabSheet(Pages[min(i, PageCount - 1)]);
                    if Assigned(OnChange) then OnChange(Self);
                  end;
                  Perform(WM_SETREDRAW, 1, 0);
                  FCommonData.BGChanged := True;
                  RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW or RDW_FRAME);
                end;
                acBtnPressed := False;
                FPressedBtnIndex := -1;
              end
              else acBtnPressed := True;
              Exit;
            end
            else begin
              if not CanBeActive(TsTabSheet(Pages[NewItem]), Self) then Exit; // Preventing of the page activation
              if (WM_LBUTTONUP = Message.Msg) then FPressedBtnIndex := -1;
            end;
          end
          else begin
            if not CanBeActive(TsTabSheet(Pages[NewItem]), Self) then Exit; // Preventing of the page activation
          end;
        end;
      end;
    end;
  end;
  if (Message.Msg = cardinal(SM_ALPHACMD)) and Assigned(FCommonData) then case Message.WParamHi of
    AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
    AC_REMOVESKIN : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
      if Message.LParam = LPARAM(SkinData.SkinManager) then begin
        CommonWndProc(Message, FCommonData);
        CheckUpDown;
        UpdateBtnData;
      end;
      AlphaBroadcast(Self, Message);
      if HandleAllocated and Showing and not (csLoading in ComponentState) and not (csDestroying in ComponentState) then begin
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
      end;
    end;
    AC_REFRESH : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
      if (Message.LParam = LPARAM(SkinData.SkinManager)) then begin
        CommonWndProc(Message, FCommonData);
        UpdateBtnData;
        if HandleAllocated and Showing and not (csLoading in ComponentState) then begin
          RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
        end;
        if ActivePage <> nil then begin
          AddToAdapter(ActivePage);
        end;
        CheckUpDown;
        if (SpinWnd <> nil) then SendMessage(SpinWnd.CtrlHandle, Message.Msg, Message.WParam, Message.LParam);
      end;
      AlphaBroadcast(Self, Message);
      Exit;
    end;
    AC_SETNEWSKIN : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
      AlphaBroadcast(Self, Message);
      if (Message.LParam = LPARAM(SkinData.SkinManager)) then CommonWndProc(Message, FCommonData);
      UpdateBtnData;
      if not (csLoading in ComponentState) then SendMessage(Handle, WM_SIZE, 0, 0);
      Exit;
    end;
    AC_PREPARING : begin
      Message.Result := integer(FCommonData.FUpdating);
      Exit;
    end;
    AC_ENDPARENTUPDATE : if FCommonData.FUpdating then begin
      FCommonData.FUpdating := False;
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW or RDW_ERASE or RDW_FRAME);
      if Assigned(ActivePage) then SendMessage(ActivePage.Handle, Message.Msg, Message.WParam, Message.LParam);
    end;
    AC_ENDUPDATE : if not FCommonData.FUpdating then begin
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_UPDATENOW or RDW_ERASE or RDW_FRAME);
      SetParentUpdated(Self);
    end;
    AC_PREPARECACHE : ;
    AC_MOUSELEAVE : begin
      Perform(WM_MOUSELEAVE, 0, 0);
      Exit;
    end;
    AC_GETSKINSTATE : begin
      if Message.LParam = 1 then begin
        if (Parent <> nil) and Parent.HandleAllocated then begin
          UpdateSkinState(FCommonData, False); // Copy Skin state from Parent
          if ActivePage <> nil then for i := 0 to ActivePage.ControlCount - 1 do SendAMessage(ActivePage.Controls[i], AC_GETSKINSTATE, 1); // !!!
        end;
      end
      else Message.Result := FCommonData.CtrlSkinState;
      Exit;
    end
    else if CommonMessage(Message, FCommonData) then Exit;
  end
  else if (FCommonData <> nil) and FCommonData.Skinned(True) then case Message.Msg of
    4871 : FCommonData.BGChanged := True; // Items were added
    WM_KILLFOCUS, WM_SETFOCUS : if not (csDesigning in ComponentState) then begin
//      b := FCommonData.BGChanged;
      FCommonData.BGChanged := True;
      inherited;
//      FCommonData.BGChanged := b;
      if ActivePage <> nil then RepaintTab(ActivePage.PageIndex, 2);
      Exit;
    end
    else exit;
  end;
  if Assigned(FCommonData) and FCommonData.Skinned then begin
    if CommonWndProc(Message, FCommonData) then Exit;
    case Message.Msg of
      WM_PRINT : begin
        CheckUpDown;
        SkinData.FUpdating := False;
        AcPaint(TWMPaint(Message));
        if (SpinWnd <> nil) and IsWindowVisible(SpinWnd.CtrlHandle) then begin
          SavedDC := SaveDC(TWMPaint(Message).DC);
          try
            MoveWindowOrg(TWMPaint(Message).DC, SpinWnd.WndPos.X, SpinWnd.WndPos.Y);
            SendMessage(SpinWnd.CtrlHandle, WM_PAINT, Message.WParam, Message.LParam);
          finally
            RestoreDC(TWMPaint(Message).DC, SavedDC);
          end;
//          RedrawWindow(SpinWnd.CtrlHandle, nil, 0, RDW_INVALIDATE or RDW_FRAME);
        end;
        Exit;
      end;
      WM_NCPAINT : begin
        if InAnimationProcess or not (IsCached(FCommonData) or (DroppedDownItem <> -1)) {or (DroppedDownItem >= 0) {If tabmenu is dropped down} then Exit;
        if ActivePage <> nil then begin
          FCommonData.FUpdating := FCommonData.Updating;
          if FCommonData.FUpdating then Exit;
          DC := GetDC(Handle);
          SavedDC := SaveDC(DC);
          try
            R := TabsRect;
            ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
            R := ActivePage.BoundsRect;
            ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
            if (Tabs.Count > 0) and (ActivePage <> nil) then begin
              R := SkinTabRect(ActivePage.TabIndex, True);
              ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
            end;
            CopyWinControlCache(Self, FCommonData,  Rect(0, 0, 0, 0), Rect(0, 0, Width, Height), DC, True);
          finally
            RestoreDC(DC, SavedDC);
            ReleaseDC(Handle, DC);
          end;
        end;
        if SpinWnd <> nil then RedrawWindow(SpinWnd.CtrlHandle, nil, 0, RDW_INVALIDATE or RDW_FRAME or RDW_UPDATENOW);
        Message.Result := 0;
      end;
      WM_ERASEBKGND : begin
        if not (InAnimationProcess or (SkinData.CtrlSkinState and ACS_FAST <> ACS_FAST)) and not InAnimationProcess then begin
          AcPaint(TWMPaint(Message));
        end;
        Message.Result := 1;
        Exit
      end;
      WM_STYLECHANGED, WM_STYLECHANGING : if not (csLoading in ComponentState) then begin
        FCommonData.BGChanged := True;
      end;
      WM_HSCROLL : if not (csLoading in ComponentState) then begin
        FCommonData.BGChanged := True;
        inherited;
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME);
        Exit;
      end;
      WM_PARENTNOTIFY : if not ((csDesigning in ComponentState) or (csLoading in ComponentState)) and ((Message.WParam and $FFFF = WM_CREATE) or (Message.WParam and $FFFF = WM_DESTROY)) then begin
        i := PageCount;
        inherited;
        if (Message.WParamLo = WM_CREATE) then begin
          if (srThirdParty in SkinData.SkinManager.SkinningRules) and (i <> PageCount) then AddToAdapter(Self);
//          if HandleAllocated then Perform(WM_SIZE, 0, 0); // Update tab sizes after creation
        end;
        CheckUpDown;
        Exit;
      end;
      CM_CONTROLLISTCHANGE : begin
        i := PageCount;
        inherited;
        if i <> PageCount then begin
          CheckUpDown;
          if (srThirdParty in SkinData.SkinManager.SkinningRules) then AddToAdapter(Self);
        end;
        Exit;
      end;
    end
  end;
  inherited;
  case Message.Msg of
    WM_STYLECHANGED : if not (csLoading in ComponentState) and FCommonData.Skinned then begin
      UpdateBtnData;
      CheckUpDown;
    end;
    CM_DIALOGCHAR : if FCommonData.Skinned then begin
      FCommonData.BGChanged := True;
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME);
      SetParentUpdated(Self);
    end;
    TCM_DELETEITEM : if FCommonData.Skinned and not SkinData.FUpdating then SkinData.BGChanged := True;
    WM_LBUTTONDBLCLK : if (CurItem >= 0) and (CurItem < PageCount) and ((Style <> tsTabs) or (TsTabSheet(Pages[CurItem]).TabType = ttButton)) then begin
      RepaintTab(CurItem, 2); // If button is dblclicked
    end;
    WM_CREATE : if HandleAllocated then begin
      UpdateBtnData;
      SendMessage(Handle, WM_SIZE, 0, 0); // Update tab sizes after creation or style changing
      CheckUpDown;
    end;
    CM_ENABLEDCHANGED : if not (csDestroying in ComponentState) and not (csLoading in ComponentState) then begin
      SkinData.Invalidate;
    end;
  end;
end;

procedure TsPageControl.SetShowCloseBtns(const Value: boolean);
begin
  if FShowCloseBtns <> Value then begin
    FShowCloseBtns := Value;
    UpdateBtnData;
    if HandleAllocated and not(csLoading in ComponentState) then begin
      Perform(WM_SIZE, 0, 0);
      if SkinData.Skinned then RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW);
    end;
  end;
end;

procedure TsPageControl.CloseClick(Sender: TObject);
var
  ToClose : boolean;
  Act : TacCloseAction;
  i : integer;
begin
  ToClose := True;
  Act := acaFree;
  if Assigned(OnCloseBtnClick) then OnCloseBtnClick(Self, TsTabBtn(Sender).Page.TabIndex, ToClose, Act);
  if ToClose then begin
    i := ActivePageIndex;
    if Act = acaFree then FreeAndNil(TsTabBtn(Sender).Page) else TsTabBtn(Sender).Page.TabVisible := False;
    if (i < PageCount) and (i <> 0) then begin
      ActivePageIndex := i;
    end;
    TsTabBtn(Sender).Visible := False;
    RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW);
  end;
end;

procedure TsPageControl.PaintButton(DC: hdc; TabRect: TRect; State: integer);
const
  sx = 'X';
var
  TmpBmp : TBitmap;
begin
  if BtnIndex < 0 then Exit;
  TmpBmp := CreateBmp32(BtnWidth, BtnHeight);
  BitBlt(TmpBmp.Canvas.Handle, 0, 0, BtnWidth, BtnHeight, DC, TabRect.Left, TabRect.Top, SRCCOPY);

  if CloseBtnSkin = '' then DrawSkinGlyph(TmpBmp, Point(BtnWidth - WidthOfImage(FCommonData.SkinManager.ma[BtnIndex]), 0), State, 1, FCommonData.SkinManager.ma[BtnIndex], MakeCacheInfo(TmpBmp)) else begin
    PaintItem(BtnIndex, CloseBtnSkin, MakeCacheInfo(TmpBmp), True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, SkinData.SkinManager);
    SelectObject(TmpBmp.Canvas.Handle, CreatePen(PS_SOLID, 2, clRed));
    MoveToEx(TmpBmp.Canvas.Handle, 4, 4, nil);
    LineTo(TmpBmp.Canvas.Handle, TmpBmp.Width - 5, TmpBmp.Height - 5);
    MoveToEx(TmpBmp.Canvas.Handle, 4, TmpBmp.Height - 5, nil);
    LineTo(TmpBmp.Canvas.Handle, TmpBmp.Width - 5, 4);
  end;

  BitBlt(DC, TabRect.Left, TabRect.Top, BtnWidth, BtnHeight, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
  FreeAndNil(TmpBmp);
end;

var
  bUpdating : boolean = False;

procedure TsPageControl.UpdateBtnData;
begin
  BtnWidth := iBtnWidth;
  BtnHeight := iBtnHeight;
  if SkinData.Skinned then begin
    if FCommonData.SkinManager = nil then Exit;
    if CloseBtnSkin <> '' then begin
      BtnIndex := FCommonData.SkinManager.GetSkinIndex(CloseBtnSkin);
    end
    else begin
      BtnIndex := FCommonData.SkinManager.GetMaskIndex(FCommonData.SkinManager.ConstData.IndexGlobalInfo, s_GlobalInfo, s_SmallIconClose);
      if BtnIndex < 0 then BtnIndex := FCommonData.SkinManager.GetMaskIndex(FCommonData.SkinManager.ConstData.IndexGlobalInfo, s_GlobalInfo, s_BorderIconClose);
      if BtnIndex > -1 then begin
        BtnWidth := max(WidthOfImage(FCommonData.SkinManager.ma[BtnIndex]), 8);
        BtnHeight := HeightOfImage(FCommonData.SkinManager.ma[BtnIndex]);
      end;
    end;
  end;
  if not bUpdating then begin
    bUpdating := True;
    SetPadding(FShowCloseBtns);
    bUpdating := False;
  end;
end;


procedure TsPageControl.SetCloseBtnSkin(const Value: TsSkinSection);
begin
  if FCloseBtnSkin <> Value then begin
    FCloseBtnSkin := Value;
    FCommonData.Invalidate;
  end;
end;

procedure TsPageControl.SetShowUpDown(const Value: boolean);
var
  Wnd : THandle;
begin
  FShowUpDown := Value;
  if not FShowUpDown then begin
    if (SpinWnd <> nil) then begin
      Wnd := SpinWnd.CtrlHandle;
      FreeAndNil(SpinWnd);
    end
    else Wnd := FindWindowEx(Handle, 0, UPDOWN_CLASS, nil);
    if Wnd <> 0 then DestroyWindow(Wnd);
  end
  else if not (csLoading in ComponentState) then RecreateWnd;
end;

procedure TsPageControl.SetTabPadding(const Value: integer);
begin
  if FTabPadding <> Value then begin
    FTabPadding := Value;
    if not (csLoading in ComponentState) then begin
      UpdateBtnData;
      if HandleAllocated then Perform(WM_SIZE, 0, 0);
      FCommonData.Invalidate;
    end;
  end;
end;

procedure TsPageControl.SetPadding(Value: boolean);
var
  i : integer;
begin
  if Value then begin
    if Images = nil then i := 7 else i := 4;
    SendMessage(Handle, TCM_SETPADDING, 0, MakeLParam(BtnWidth div 2 + i + FTabPadding, 3))
  end
  else begin
    if Images = nil then i := 6 else i := 4;
    SendMessage(Handle, TCM_SETPADDING, 0, MakeLParam(i + FTabPadding, 3));
  end;
end;

function TsPageControl.BtnOffset(TabHeight : integer; Active : boolean) : integer;
begin
  Result := (TabHeight - iBtnHeight - 1) div 2 - 2
end;

function TsPageControl.IsSpecialTab(i: integer; IsMenu : boolean = False): boolean;
begin
  Result := Pages[i].TabVisible and (TsTabSheet(Pages[i]).TabType <> ttTab) {and (TsTabSheet(Pages[i]).TabMenu <> nil)};
  if Result and IsMenu then begin
    Result := TsTabSheet(Pages[i]).TabType = ttMenu;
  end;
end;

function TsPageControl.CheckActiveTab(PageIndex : integer) : TTabSheet;
var
  i : integer;
begin
  if IsSpecialTab(PageIndex) or not Pages[PageIndex].TabVisible then begin
    for i := PageIndex to PageCount - 1 do if {Pages[i].TabVisible and }not IsSpecialTab(i) then begin
      Result := Pages[i];
      Exit;
    end;
    for i := PageIndex downto 0 do if {Pages[i].TabVisible and }not IsSpecialTab(i) then begin
      Result := Pages[i];
      Exit;
    end;
    Result := Pages[PageIndex];
  end
  else Result := Pages[PageIndex];
end;

procedure TsPageControl.SetShowFocus(const Value: boolean);
begin
  if FShowFocus <> Value then begin
    FShowFocus := Value;
    SkinData.Invalidate;
  end;
end;

{$IFDEF DELPHI7UP}
procedure TsPageControl.SetTabIndex(Value: Integer);
var
  PageIndex : integer;
begin
  if (Value >= 0) and (Value < PageCount) then begin
    PageIndex := PageIndexFromTabIndex(Value);
    if (TsTabSheet(Pages[PageIndex]).TabType = ttTab) then inherited;
  end
  else inherited;
end;
{$ENDIF}

procedure TsPageControl.StdPaint(var Message: TWMPaint);
var
  DC, SavedDC : hdc;
  R : TRect;
{$IFDEF DELPHI7UP}
  Details: TThemedElementDetails;
  Page: TThemedTab;
{$ENDIF}
begin
  if (csDestroying in Parent.ComponentState) or (csLoading in ComponentState) then begin Exit end;
  if (Message.DC <> 0) then DC := Message.DC else begin
    DC := GetDC(Handle);
    SavedDC := SaveDC(DC);
  end;
  Canvas.Handle := DC;
  Canvas.Lock;
  try
    if Style = tsTabs then begin
{$IFDEF DELPHI7UP}
      if ThemeServices.ThemesEnabled then begin
        // Transparent part drawing
        R := Rect(0, 0, Width, Height);
        Page := ttBody;
        Details := ThemeServices.GetElementDetails(Page);
        ThemeServices.DrawParentBackground(Handle, DC, @Details, True);
        ThemeServices.DrawElement(DC, Details, R);
        // Page painting
        R := PageRect;
        Page := ttPane;
        Details := ThemeServices.GetElementDetails(Page);
        ThemeServices.DrawParentBackground(Handle, DC, @Details, False);
        ThemeServices.DrawElement(DC, Details, R);
      end
      else
{$ENDIF}
      begin
        R := PageRect;
        FillDC(DC, ClientRect, ColorToRGB(Color));
        DrawEdge(DC, R, EDGE_RAISED, BF_RECT);
      end;
    end
    else begin
{$IFDEF DELPHI7UP}
      if ThemeServices.ThemesEnabled then begin
        Page := ttBody;
        Details := ThemeServices.GetElementDetails(Page);
        ThemeServices.DrawParentBackground(Handle, DC, @Details, False);
      end else
{$ENDIF}
      FillDC(DC, R, Color);
    end;
    DrawStdTabs(DC);
  finally
    Canvas.UnLock;
    if DC <> Message.DC then begin
      RestoreDC(DC, SavedDC);
      ReleaseDC(Handle, DC);
    end;
  end;
  StoredVisiblePageCount := VisibleTabsCount;
  Message.Result := 1;
end;

procedure DrawCloseBtn(DC : hdc; R : TRect; State : integer);
{$IFDEF DELPHI7UP}
var
  tw : TThemedWindow;
  Details: TThemedElementDetails;
{$ENDIF}
begin
{$IFDEF DELPHI7UP}
  if ThemeServices.ThemesEnabled then begin
    case State of
      0 : tw := twSmallCloseButtonNormal;
      1 : tw := twSmallCloseButtonHot;
      2 : tw := twSmallCloseButtonPushed;
    end;
    Details := ThemeServices.GetElementDetails(tw);
    ThemeServices.DrawElement(DC, Details, R);
  end
  else
{$ENDIF}
  begin
    FillDC(DC, R, clWhite);
    InflateRect(R, -1, -1);
    case State of
      0 : FillDC(DC, R, $005858AB);
      1 : FillDC(DC, R, clRed);
      2 : FillDC(DC, R, clMaroon);
    end;
    SelectObject(DC, CreatePen(PS_SOLID, 2, clWhite));
    MoveToEx(DC, R.Left + 3, R.Top + 3, nil);
    LineTo(DC, R.Right - 4, R.Bottom - 4);
    MoveToEx(DC, R.Left + 3, R.Bottom - 4, nil);
    LineTo(DC, R.Right - 4, R.Top + 3);
  end;
end;

procedure TsPageControl.DrawStdTab(PageIndex, State: integer; DC: hdc);
const
  Spacing = 3;
  FixOffset = 6;
var
{$IFDEF DELPHI7UP}
  Details: TThemedElementDetails;
  Tab: TThemedTab;
  ToolBtn: TThemedToolBar;
  Btn: TThemedButton;
{$ENDIF}
  SavedDC : hdc;
  OldFont : hFont;
  aRect, R, rTmp : TRect;
  Page : TsTabSheet;
  TempBmp : TBitmap;
  lCaption: ACString;
  Flags : Cardinal;
  bTabMenu : boolean;
  dContent : TacTabData;
begin
  if (PageIndex < 0) then Exit;
  bTabMenu := IsSpecialTab(PageIndex);
  Page := TsTabSheet(Pages[PageIndex]);
  R := TabRect(Pages[PageIndex].TabIndex);
  if ((State <> 0) and (R.Left < 0)) then Exit;
  if bTabMenu then begin
    if TabPosition in [tpTop, tpBottom] then InflateRect(R, -3, -1) else InflateRect(R, -1, -3);
  end
  else begin
    if (State = 2) and not bTabMenu and (Style = tsTabs) then InflateRect(R, 2, 2);
  end;

  TempBmp := CreateBmp32(WidthOf(R), HeightOf(R));
  TempBmp.Canvas.Font := Font;
  if ActiveIsBold and (Page = ActivePage)
    then TempBmp.Canvas.Font.Style := TempBmp.Canvas.Font.Style + [fsBold];
  TempBmp.Canvas.Brush.Style := bsClear;
  aRect := Rect(0, 0, TempBmp.Width, TempBmp.Height);

  if not Page.TabVisible then Exit;
{$IFDEF DELPHI7UP}
  if ThemeServices.ThemesEnabled then begin
    // Tabs drawing
    if bTabMenu then begin
      if State = 0
        then BitBlt(TempBmp.Canvas.Handle, 0, 0, TempBmp.Width, TempBmp.Height, DC, R.Left, R.Top, SRCCOPY) { Copy background }
        else FillDC(TempBmp.Canvas.Handle, Rect(0, 0, TempBmp.Width, TempBmp.Height), Color);
      if Page.TabType = ttMenu then begin
        case State of
          0 : begin
            TempBmp.Canvas.Font.Color := clMenuText;
//            Mnu := tmMenuItemNormal;
          end;
          1, 2 : begin
            FillDC(TempBmp.Canvas.Handle, Rect(1, 1, TempBmp.Width - 1, TempBmp.Height - 1), clMenuHighlight);
            TempBmp.Canvas.Font.Color := clHighlightText;
//            Mnu := tmMenuBarItem;//tmMenuItemSelected;
          end;
        end;
        Details.Part := -1;
//        Details := ThemeServices.GetElementDetails(Mnu);
      end
      else begin
        case State of
          0 : ToolBtn := ttbButtonNormal;
          1 : ToolBtn := ttbButtonHot;
          2 : ToolBtn := ttbButtonPressed;
        end;
        Details := ThemeServices.GetElementDetails(ToolBtn);
      end;
    end
    else case Style of
      tsTabs : begin
        if (TabPosition <> tpTop) then begin // Others tabs are not supported by API
          case State of
            0 : begin
              ToolBtn := ttbButtonPressed;
              Details := ThemeServices.GetElementDetails(ToolBtn);
            end;
            1 : begin
              ToolBtn := ttbButtonHot;
              Details := ThemeServices.GetElementDetails(ToolBtn);
            end;
            2 : begin
              Tab := ttPane;
              Details := ThemeServices.GetElementDetails(Tab);
            end;
          end;
        end
        else begin // Draw buttons with a special offset (tabs emulation)
          case State of
            0 : Tab := ttTabItemNormal;
            1 : Tab := ttTabItemHot;
            2 : Tab := ttTabItemSelected;
          end;
          Details := ThemeServices.GetElementDetails(Tab);
        end;
        case TabPosition of
          tpTop : ThemeServices.DrawElement(TempBmp.Canvas.Handle, Details, aRect); // Draw tab
          tpBottom : ThemeServices.DrawElement(TempBmp.Canvas.Handle, Details, Rect(0, -FixOffset, TempBmp.Width, TempBmp.Height)); // Draw button
          tpLeft : ThemeServices.DrawElement(TempBmp.Canvas.Handle, Details, Rect(0, 0, TempBmp.Width + FixOffset, TempBmp.Height)); // Draw button
          tpRight : ThemeServices.DrawElement(TempBmp.Canvas.Handle, Details, Rect(-FixOffset, 0, TempBmp.Width, TempBmp.Height)); // Draw button
        end;
        Details.Part := -1;
      end;
      tsButtons : begin
        case State of
          0 : Btn := tbPushButtonNormal;
          1 : Btn := tbPushButtonHot;
          2 : Btn := tbPushButtonPressed;
        end;
        Details := ThemeServices.GetElementDetails(Btn);
      end
      else begin
        if R.Left > 6 then begin // Draw a separator
          rTmp := Rect(R.Left - 6, R.Top, R.Left, R.Bottom);
          DrawEdge(DC, rTmp, EDGE_ETCHED, BF_LEFT);
        end;
        case State of
          0 : begin
            FillDC(TempBmp.Canvas.Handle, Rect(0, 0, TempBmp.Width, TempBmp.Height), Color); { Fill background }
            ToolBtn := ttbButtonNormal;
          end;
          1 : begin
            FillDC(TempBmp.Canvas.Handle, Rect(0, 0, TempBmp.Width, TempBmp.Height), Color); { Fill background }
            ToolBtn := ttbButtonHot;
          end;
          2 : ToolBtn := ttbButtonPressed;
        end;
        Details := ThemeServices.GetElementDetails(ToolBtn);
      end;
    end;
    if Details.Part <> -1 then
      ThemeServices.DrawElement(TempBmp.Canvas.Handle, Details, aRect); // Draw tab
  end
  else
{$ENDIF}
  begin // Draw without themes (very od style)
    FillDC(TempBmp.Canvas.Handle, aRect, Color);
    if bTabMenu then begin
      if Page.TabType = ttMenu then begin
        case State of
          1 : begin
            FillDC(TempBmp.Canvas.Handle, Rect(1, 1, TempBmp.Width - 1, TempBmp.Height - 1), {$IFDEF DELPHI7UP}clMenuHighlight{$ELSE}clHighlight{$ENDIF});
            TempBmp.Canvas.Font.Color := clHighlightText;
          end;
          2 : begin
            FillDC(TempBmp.Canvas.Handle, Rect(1, 1, TempBmp.Width - 1, TempBmp.Height - 1), {$IFDEF DELPHI7UP}clMenuHighlight{$ELSE}clHighlight{$ENDIF});
            TempBmp.Canvas.Font.Color := clHighlightText;
          end;
        end;
      end
      else begin
        case State of
          1 : Frame3D(TempBmp.Canvas, aRect, ColorToRGB(clWhite), ColorToRGB(clBtnShadow), 1);
          2 : Frame3D(TempBmp.Canvas, aRect, ColorToRGB(clBtnShadow), ColorToRGB(clWhite), 1);
        end;
      end;
    end
    else begin
      case Style of
        tsTabs : begin
          case TabPosition of
            tpTop : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_RAISED, BF_RECT and not BF_BOTTOM);
            tpBottom : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_RAISED, BF_RECT and not BF_TOP);
            tpLeft : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_RAISED, BF_RECT and not BF_RIGHT);
            tpRight : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_RAISED, BF_RECT and not BF_LEFT);
          end;
        end;
        tsButtons : begin
          case State of
            0, 1 : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_RAISED, BF_RECT);
            2 : DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_SUNKEN, BF_RECT);
          end;
        end
        else begin
          if R.Left > 6 then begin // Draw a separator
            rTmp := Rect(R.Left - 6, R.Top, R.Left, R.Bottom);
            DrawEdge(DC, rTmp, EDGE_ETCHED, BF_LEFT);
          end;
          case State of
            1 : Frame3D(TempBmp.Canvas, aRect, ColorToRGB(clWhite), ColorToRGB(clBtnShadow), 1);
            2 : begin
              FillDC(TempBmp.Canvas.Handle, aRect, ColorToRGB(cl3DLight));
              DrawEdge(TempBmp.Canvas.Handle, aRect, EDGE_SUNKEN, BF_RECT);
            end;
          end;
        end;
      end;
    end;
  end;

  if not OwnerDraw then begin
    // Drawing of tab content
    Flags := DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS;
    if UseRightToLeftReading then Flags := Flags or DT_RTLREADING or DT_NOCLIP;
{$IFDEF TNTUNICODE}
    if Page is TTntTabSheet then lCaption := TTntTabSheet(Page).Caption else
{$ENDIF}
    lCaption := Page.Caption;

    OldFont := 0;
    if (TabPosition in [tpLeft, tpRight]) and not RotateCaptions or (TabPosition in [tpTop, tpBottom]) and RotateCaptions // If vertical text
      then OldFont := MakeVertFont(TempBmp.Canvas.Handle, TempBmp.Canvas.Font, -2700); // Rotated font initialization
    // Get coordinates for tab content
    InitTabContentData(TempBmp.Canvas, Page, aRect, State, bTabMenu, dContent);
    // Draw glyph if rect is not empty
    if not IsRectEmpty(dContent.GlyphRect) then Images.Draw(TempBmp.Canvas, dContent.GlyphRect.Left, dContent.GlyphRect.Top, Page.ImageIndex, Page.Enabled and Enabled);
    // Write Text
    if not Page.Enabled or not Enabled then TempBmp.Canvas.Font.Color := clGrayText;
    TempBmp.Canvas.Brush.Style := bsClear;
    if OldFont <> 0 then begin // If font is rotated
      lCaption := CutText(TempBmp.Canvas, lCaption, HeightOf(dContent.TextRect));
      acTextRect(TempBmp.Canvas, dContent.TextRect, dContent.TextPos.X, dContent.TextPos.Y, lCaption);
      SelectObject(TempBmp.Canvas.Handle, OldFont); // Returning prev. font
    end
    else begin
      WriteText32(TempBmp, PacChar(lCaption), True, dContent.TextRect, Flags, -1, True, SkinData.SkinManager);
    end;
    // Paint focus rect
    if not IsRectEmpty(dContent.FocusRect) then begin
      TempBmp.Canvas.Pen.Color := clWindowFrame;
      TempBmp.Canvas.Brush.Color := clBtnFace;
      TempBmp.Canvas.DrawFocusRect(dContent.FocusRect);
    end;
    // Paint Close btn
    if not IsRectEmpty(dContent.BtnRect) then DrawCloseBtn(TempBmp.Canvas.Handle, dContent.BtnRect, integer(FHoveredBtnIndex = PageIndex) + integer(FPressedBtnIndex = PageIndex));
    // Draw Arrow
    if not IsRectEmpty(dContent.ArrowRect) then DrawColorArrow(TempBmp.Canvas, TempBmp.Canvas.Font.Color, dContent.ArrowRect, dContent.ArrowDirection);
  end
  else if Assigned(OnDrawTab) then begin
    Canvas.Handle := TempBmp.Canvas.Handle;
    SavedDC := SaveDC(Canvas.Handle);
    Canvas.Lock;
    MoveWindowOrg(Canvas.Handle, -R.Left, -R.Top);
    OnDrawTab(Self, Page.TabIndex, R, State <> 0);
    Canvas.UnLock;
    RestoreDC(Canvas.Handle, SavedDC);
    BitBlt(DC, R.Left, R.Top, TempBmp.Width, TempBmp.Height, TempBmp.Canvas.Handle, 0, 0, SRCCOPY);
  end;
  BitBlt(DC, R.Left, R.Top, TempBmp.Width, TempBmp.Height, TempBmp.Canvas.Handle, 0, 0, SRCCOPY); // Copy Tab to DC
  TempBmp.Free;
end;

procedure TsPageControl.DrawStdTabs(DC: hdc);
var
  i : integer;
begin
  for i := 0 to PageCount - 1 do if Pages[i].TabVisible and (Pages[i] <> ActivePage) then begin
    if DroppedDownItem = i
      then DrawStdTab(i, 2, DC)
      else DrawStdTab(i, integer(CurItem = i), DC);
  end;
  // Draw active tab
  if (Tabs.Count > 0) and (ActivePage <> nil) and (ActivePage.TabType = ttTab) then DrawStdTab(ActivePage.PageIndex, 2, DC);
end;

const
  ArrowSize = 9;

procedure TsPageControl.InitTabContentData(Canvas : TCanvas; Page : TTabSheet; TabRect: TRect; State : integer; IsTabMenu : boolean; var Data: TacTabData);
var
  IsVertical, ArrowUnderText : boolean;
  lCaption : ACString;
  R : TRect;
begin
{$IFDEF TNTUNICODE}
  if Page is TTntTabSheet then lCaption := TTntTabSheet(Page).Caption else
{$ENDIF}
  lCaption := Page.Caption; // Text size received

  FillChar(R, SizeOf(TRect), 0);
  acDrawText(Canvas.Handle, Page.Caption, R, DT_CALCRECT);
  Data.TextSize.cx := WidthOf(R);
  Data.TextSize.cy := HeightOf(R);

  if RotateCaptions then IsVertical := TabPosition in [tpTop, tpBottom] else IsVertical := TabPosition in [tpLeft, tpRight];
  if not IsVertical then begin
    if TabPosition = tpTop then begin
      dec(TabRect.Bottom, 2);
    end
    else begin
      inc(TabRect.Top, 2);
    end;
    if IsTabMenu then begin
    end
    else if Style = tsTabs then begin
      if TabPosition = tpTop then begin
        inc(TabRect.Top, 2);
        if State = 2 then OffsetRect(TabRect, -1, -2) else OffsetRect(TabRect, 0, 1);
      end
      else begin
        if State = 2 then OffsetRect(TabRect, -1, -2) else OffsetRect(TabRect, 0, -2);
      end;
    end
    else begin
      OffsetRect(TabRect, 0, 1);
    end;
    Data.TextRect := TabRect;
    // Arrow rect
    if IsTabMenu and (TsTabSheet(Page).TabType = ttMenu) then begin
      ArrowUnderText := False;
      if TabPosition in [tpTop, tpBottom] // Can arrow be placed under text?
        then if HeightOf(TabRect) - Data.TextSize.cy - 6 > ArrowSize then ArrowUnderText := True;
//        else if WidthOf(TabRect) - Data.TextSize.cy > ArrowSize then ArrowUnderText := True;
      Data.ArrowDirection := BF_BOTTOM;
      if not ArrowUnderText then begin
        Data.ArrowRect.Left := Data.TextRect.Right - ArrowSize - 4;
        Data.ArrowRect.Top := Data.TextRect.Top + (HeightOf(Data.TextRect) - ArrowSize) div 2 + 1;
        Data.ArrowRect.Right := Data.ArrowRect.Left + ArrowSize;
        Data.ArrowRect.Bottom := Data.ArrowRect.Top + ArrowSize;
        if (State = 2) then OffsetRect(Data.ArrowRect, 1, 1);
      end;
    end
    else begin
      Data.ArrowRect := Rect(0, 0, 0, 0);
      ArrowUnderText := False;
    end;
    // Close btn rect
    if FShowCloseBtns and not IsTabMenu and TsTabSheet(Page).UseCloseBtn then begin
      Data.BtnRect.Left := TabRect.Right - BtnWidth - BtnOffsX;
      Data.BtnRect.Top := TabRect.Top + (HeightOf(TabRect) - BtnHeight) div 2;
      Data.BtnRect.Right := TabRect.Right - BtnOffsX;
      Data.BtnRect.Bottom := Data.BtnRect.Top + BtnHeight;
      Data.TextRect.Right := Data.BtnRect.Left;// - 2;
      if (State = 2) then begin
        OffsetRect(TabRect, 3, 0);
        if TabPosition = tpTop
          then OffsetRect(Data.BtnRect, 1, 1)
          else OffsetRect(Data.BtnRect, 0, 2);
      end;
    end
    else Data.BtnRect := Rect(0, 0, 0, 0);
    // Image rect
    if (Images <> nil) and (Page.ImageIndex > -1) and (Page.ImageIndex <= Images.Count - 1) then begin
      if not IsRectEmpty(Data.BtnRect) then begin // If button exists
        Data.GlyphRect.Left := TabRect.Left + 3; // then content aligned to the left
      end
      else begin // Glyph with text are aligned to center
        Data.GlyphRect.Left := max(Data.TextRect.Left + (WidthOf(Data.TextRect) - (Data.TextSize.cx + Images.Width + Spacing)) div 2, TabRect.Left + 3);
      end;
      Data.GlyphRect.Top := TabRect.Top + (HeightOf(TabRect) - Images.Height) div 2;
      Data.GlyphRect.Right := Data.GlyphRect.Left + Images.Width;
      Data.GlyphRect.Bottom := Data.GlyphRect.Top + Images.Height;
      Data.TextRect.Left := Data.GlyphRect.Right + Spacing; // Change text rect
      if State = 2 then OffsetRect(Data.GlyphRect, 1, integer(Style = tsTabs))
    end
    else begin
      Data.GlyphRect := Rect(0, 0, 0, 0);
      if (Data.BtnRect.Left <> Data.BtnRect.Right) or (Data.ArrowRect.Left <> Data.ArrowRect.Right) or (ShowCloseBtns and (TsTabSheet(Page).TabType = ttTab)) then begin // If button or arrow exists
        Data.TextRect.Left := TabRect.Left + 4;
      end
      else begin
        Data.TextRect.Left := TabRect.Left + (WidthOf(TabRect) - Data.TextSize.cx) div 2;
      end;
    end;
    Data.TextRect.Right := min(Data.TextRect.Left + Data.TextSize.cx + 2, Data.TextRect.Right - integer(Data.ArrowRect.Left = Data.BtnRect.Right) * 3); //
    Data.TextRect.Top := Data.TextRect.Top + (HeightOf(Data.TextRect) - Data.TextSize.cy) div 2;
    Data.TextRect.Bottom := Data.TextRect.Top + Data.TextSize.cy;
    if ArrowUnderText then begin
      if TabPosition in [tpTop, tpBottom] then begin
        OffsetRect(Data.TextRect, 0, -4);
        Data.ArrowRect.Left := Data.TextRect.Left + (WidthOf(Data.TextRect) - ArrowSize) div 2;
        Data.ArrowRect.Top := Data.TextRect.Bottom;
        Data.ArrowRect.Right := Data.ArrowRect.Left + ArrowSize;
        Data.ArrowRect.Bottom := Data.ArrowRect.Top + ArrowSize;
      end
      else begin
      end;
      if (State = 2) then OffsetRect(Data.ArrowRect, 1, 1);
    end;
    // Focus rect
    if FShowFocus and (Focused or FCommonData.FFocused) and (State = 2) and (Page.Caption <> '') and not IsTabMenu then begin
      Data.FocusRect := Data.TextRect;
      InflateRect(Data.FocusRect, 3, 0);
      inc(Data.FocusRect.Bottom, 3);
    end
    else Data.FocusRect := Rect(0, 0, 0, 0);

    Data.TextPos.X := Data.TextRect.Left;
    Data.TextPos.Y := Data.TextRect.Top;
    if (State = 2) then OffsetRect(Data.TextRect, 1, 1);
  end
  else begin
    if IsTabMenu then begin
      if (State = 2) then OffsetRect(TabRect, 1, 1);
    end
    else begin
      if State = 2 then OffsetRect(TabRect, -1, -1);
    end;
    Data.TextRect := TabRect;
    // Arrow rect
    if IsTabMenu and (TsTabSheet(Page).TabType = ttMenu) then begin
      Data.ArrowRect.Top := Data.TextRect.Top + 8;
      Data.ArrowRect.Left := Data.TextRect.Left + (WidthOf(Data.TextRect) - ArrowSize) div 2;
      Data.ArrowRect.Right := Data.ArrowRect.Left + ArrowSize;
      Data.ArrowRect.Bottom := Data.ArrowRect.Top + ArrowSize;
      Data.TextRect.Top := Data.ArrowRect.Bottom + 2;
      Data.ArrowDirection := BF_RIGHT;
      if (State = 2) then begin
        if IsVertical then OffsetRect(Data.ArrowRect, 0, -1) else OffsetRect(Data.ArrowRect, 0, 1);
      end;
    end
    else Data.ArrowRect := Rect(0, 0, 0, 0);
    // Close btn rect
    if FShowCloseBtns and not IsTabMenu and TsTabSheet(Page).UseCloseBtn then begin
      Data.BtnRect.Top := TabRect.Top + BtnOffsX;
      Data.BtnRect.Left := TabRect.Left + (WidthOf(TabRect) - BtnWidth) div 2;
      Data.BtnRect.Right := Data.BtnRect.Left + BtnWidth;
      Data.BtnRect.Bottom := Data.BtnRect.Top + BtnHeight;
      Data.TextRect.Top := Data.BtnRect.Bottom + 2;
      if (State = 2) then begin
        OffsetRect(TabRect, 0, -2);
        OffsetRect(Data.BtnRect, 2, 2);
      end;
    end
    else Data.BtnRect := Rect(0, 0, 0, 0);
    // Image rect
    if (Images <> nil) and (Page.ImageIndex > -1) and (Page.ImageIndex <= Images.Count - 1) then begin
      if not IsRectEmpty(Data.BtnRect) then begin     // If button exists
        Data.GlyphRect.Bottom := TabRect.Bottom - 3; // then content aligned to bottom
      end
      else begin // Glyph with text are aligned to center
        Data.GlyphRect.Bottom := min(TabRect.Bottom - (HeightOf(TabRect) - (Data.TextSize.cx + Images.Height + Spacing)) div 2, TabRect.Bottom - 3);
      end;
      Data.GlyphRect.Top := Data.GlyphRect.Bottom - Images.Height;
      Data.GlyphRect.Left := TabRect.Left + (WidthOf(TabRect) - Images.Width) div 2 + 1;
      Data.GlyphRect.Right := Data.GlyphRect.Left + Images.Width;
      if (State = 2) then begin
        if IsVertical and IsTabMenu then OffsetRect(Data.GlyphRect, 3, 0);
      end;
      Data.TextRect.Bottom := Data.GlyphRect.Top - Spacing; // Change text rect
    end
    else begin
      Data.GlyphRect := Rect(0, 0, 0, 0);
      if not IsRectEmpty(Data.BtnRect) then begin // If button exists
        Data.TextRect.Bottom := TabRect.Bottom - 5;
      end
      else begin
        Data.TextRect.Bottom := TabRect.Bottom - (HeightOf(TabRect) - Data.TextSize.cx) div 2;
      end;
    end;
    Data.TextRect.Top := max(Data.TextRect.Bottom - Data.TextSize.cx - 2, Data.TextRect.Top + 3);
    Data.TextRect.Left := Data.TextRect.Left + (WidthOf(Data.TextRect) - Data.TextSize.cy) div 2;
    Data.TextRect.Right := Data.TextRect.Left + Data.TextSize.cy + 2;
    // Focus rect
    if FShowFocus and Self.Focused and (State = 2) and (Page.Caption <> '') and not IsTabMenu then begin
      Data.FocusRect := Data.TextRect;
      InflateRect(Data.FocusRect, 1, 3);
      inc(Data.FocusRect.Right, 2);
    end
    else Data.FocusRect := Rect(0, 0, 0, 0);

    Data.TextPos.X := Data.TextRect.Left + (WidthOf(Data.TextRect) - Data.TextSize.cy) div 2;
    Data.TextPos.Y := Data.TextRect.Bottom;
  end;
end;

procedure TsPageControl.SetHoveredBtnIndex(const Value: integer);
begin
  FHoveredBtnIndex := Value;
end;

procedure TsPageControl.SetRotateCaptions(const Value: boolean);
var
  R : TRect;
begin
  if FRotateCaptions <> Value then begin
    FRotateCaptions := Value;
    if not (csLoading in ComponentState) and (Visible or (csDesigning in ComponentState)) then begin
      SendMessage(Handle, WM_SETREDRAW, 0, 0);
      if FRotateCaptions then begin
        if PageCount > 0 then R := TabRect(0) else R := Rect(0, 0, 24, 24);
        if TabPosition in [tpTop, tpBottom] then begin
          TabWidth := HeightOf(R);
          TabHeight := max(HeightOf(R), 140);
        end
        else begin
          TabWidth := WidthOf(R);
          TabHeight := max(HeightOf(R), 140);
        end;
      end
      else begin
        TabHeight := 0;
        TabWidth := 0;
      end;
      SkinData.BGChanged := True;
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
    end;
  end;
end;

procedure TsPageControl.SetActiveIsBold(const Value: boolean);
begin
  if FActiveIsBold <> Value then begin
    FActiveIsBold := Value;
    if not (csLoading in ComponentState) and (Visible or (csDesigning in ComponentState)) then begin
      SkinData.BGChanged := True;
      RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE);
    end;
  end;
end;

function TsPageControl.GetActivePageIndex: Integer;
begin
  Result := inherited ActivePageIndex;
end;

procedure TsPageControl.SetActivePageIndex(const Value: Integer);
begin
  if (Value >= 0) and (Value < PageCount) and (TsTabSheet(Pages[Value]).TabType = ttTab) then begin
    inherited ActivePageIndex := Value;
    if not Pages[Value].TabVisible then SetParentUpdated(Pages[Value]); // Update because TCM_SETCURSEL is not received
  end;
end;

function TsPageControl.PageIndexFromTabIndex(TabIndex: Integer): Integer;
var
  i, j{, PageIndex }: integer;
begin
  Result := -1;
  j := -1;
  for i := 0 to min(TabIndex, PageCount - 1) do begin
    inc(Result);
    if Pages[i].TabVisible then inc(j);
    if TabIndex = j then Exit;
  end;
end;

procedure TsPageControl.SetCurItem(const Value: integer);
begin
  FCurItem := Value;
end;

{ TsTabSheet }

constructor TsTabSheet.Create(AOwner: TComponent);
begin
  inherited;
  FCommonData := TsTabSkinData.Create;
  Btn := nil;
  FUseCloseBtn := True;
  FTabType := ttTab;
end;

procedure TsTabSheet.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params.WindowClass do style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

destructor TsTabSheet.Destroy;
begin
  FreeAndNil(FCommonData);
  inherited;
end;

procedure TsTabSheet.SetButtonSkin(const Value: TsSkinSection);
begin
  if FButtonSkin <> Value then begin
    FButtonSkin := Value;
    if PageControl <> nil then TsPageControl(PageControl).SkinData.Invalidate;
  end;
end;

procedure TsTabSheet.SetTabMenu(const Value: TPopupMenu);
begin
  if FTabMenu <> Value then begin
    FTabMenu := Value;
//    if Value <> nil then TabSkin := s_SpeedButton else TabSkin := '';
//    Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TsTabSheet.SetTabSkin(const Value: TsSkinSection);
begin
  if FTabSkin <> Value then begin
    FTabSkin := Value;
    if (PageControl <> nil) and not (csLoading in PageControl.ComponentState) and (Visible or (csDesigning in ComponentState)) then begin
      TsPageControl(PageControl).SkinData.BGChanged := True;
      RedrawWindow(PageControl.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE);
    end;
  end;
end;

procedure TsTabSheet.SetTabType(const Value: TacTabType);
begin
  if FTabType <> Value then begin
    FTabType := Value;
    if TabSkin = '' then case Value of
      ttMenu : TabSkin := s_MenuButton;
      ttButton : TabSkin := s_SpeedButton;
    end
    else if Value = ttTab then TabSkin := '';
    if PageControl <> nil then begin
      TsPageControl(PageControl).UpdateBtnData;
      Perform(CM_TEXTCHANGED, 0, 0);
      inherited PageControl.ActivePage := TsPageControl(PageControl).CheckActiveTab(PageControl.ActivePage.PageIndex);
    end;
  end;
end;

procedure TsTabSheet.SetUseCloseBtn(const Value: boolean);
var
  State : integer;
begin
  if FUseCloseBtn <> Value then begin
    FUseCloseBtn := Value;
    if (PageControl <> nil) and not (csLoading in PageControl.ComponentState) then begin
      if PageControl.ActivePage = Self then State := 2 else State := 0;
      TsPageControl(PageControl).RepaintTab(TabIndex, State);
    end;
  end;
end;

procedure TsTabSheet.WMEraseBkGnd(var Message: TWMPaint);
begin
  if not (csDestroying in ComponentState) and (PageControl <> nil) and not (csDestroying in PageControl.ComponentState) and TsPageControl(PageControl).SkinData.Skinned and Showing then begin
{$IFDEF D2005}
    if (csDesigning in PageControl.ComponentState) then inherited; // Fixing of designer issue
{$ENDIF}
    TsPageControl(PageControl).SkinData.FUpdating := TsPageControl(PageControl).SkinData.Updating;
    if (Message.DC = 0) or (TsPageControl(PageControl).SkinData.CtrlSkinState and ACS_PRINTING = ACS_PRINTING) and (Message.DC <> TsPageControl(PageControl).SkinData.PrintDC) then Exit;
    if not TsPageControl(PageControl).SkinData.FUpdating then begin
      CopyWinControlCache(Self, TsPageControl(PageControl).SkinData, Rect(Left + BorderWidth, Top + BorderWidth, 0, 0), Rect(0, 0, Width, Height), Message.DC, False);
      sVCLUtils.PaintControls(Message.DC, Self, True, Point(0, 0));
    end;
    Message.Result := 1;
  end
  else inherited;
end;

procedure TsTabSheet.WMNCPaint(var Message: TWMPaint);
var
  DC : hdc;
begin
  if not (csDestroying in ComponentState) and (BorderWidth > 0) and Showing and not InAnimationProcess then begin
    if TsPageControl(PageControl).SkinData.Skinned then begin
      TsPageControl(PageControl).SkinData.FUpdating := TsPageControl(PageControl).SkinData.Updating;
      if not TsPageControl(PageControl).SkinData.FUpdating then begin
        if (TsPageControl(PageControl).SkinData.CtrlSkinState and ACS_PRINTING = ACS_PRINTING) and (Message.DC = TsPageControl(PageControl).SkinData.PrintDC) then DC := Message.DC else DC := GetWindowDC(Handle);
        BitBltBorder(DC, 0, 0, Width, Height, TsPageControl(PageControl).SkinData.FCacheBmp.Canvas.Handle, Left, Top, BorderWidth);
        if DC <> Message.DC then ReleaseDC(Handle, DC);
      end;
    end
    else begin
{$IFDEF DELPHI7UP}
      if ThemeServices.ThemesEnabled then inherited else
{$ENDIF}
      begin
        DC := GetWindowDC(Handle);
        FillDCBorder(DC, Rect(0, 0, Width, Height), BorderWidth, BorderWidth, BorderWidth, BorderWidth, Color);
        if DC <> Message.DC then ReleaseDC(Handle, DC);
      end;
    end;
    Message.Result := 1;
  end;
end;

procedure TsTabSheet.WndProc(var Message: TMessage);
var
  i : integer;
  PS : TPaintStruct;
begin
{$IFDEF LOGGED}
//  AddToLog(Message);
{$ENDIF}
  if PageControl <> nil then begin
    if (Message.Msg = SM_ALPHACMD) then case Message.WParamHi of
      AC_CTRLHANDLED : begin Message.Result := 1; Exit end;
      AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
      AC_REMOVESKIN : begin
        if Message.LParam = LPARAM(TsPageControl(PageControl).SkinData.SkinManager) then Repaint;
        AlphaBroadCast(Self, Message);
      end;
      AC_SETNEWSKIN : begin
        AlphaBroadCast(Self, Message);
      end;
      AC_REFRESH : begin
        if (Message.LParam = LPARAM(TsPageControl(PageControl).SkinData.SkinManager)) and (Visible or (csDesigning in ComponentState)) then Repaint;
        AlphaBroadCast(Self, Message);
      end;
      AC_GETBG : if TsPageControl(PageControl).SkinData.Skinned then begin
        if (SkinData.SkinSection <> '') then begin
          PacBGInfo(Message.LParam).BgType := btCache;
          PacBGInfo(Message.LParam).Bmp := TsPageControl(PageControl).SkinData.FCacheBmp;
          PacBGInfo(Message.LParam).Offset := Point(0, 0);
        end
        else InitBGInfo(TsPageControl(PageControl).SkinData, PacBGInfo(Message.LParam), 0);
        if (PacBGInfo(Message.LParam)^.BgType = btCache) and not PacBGInfo(Message.LParam)^.PleaseDraw then begin
          PacBGInfo(Message.LParam)^.Offset.X := PacBGInfo(Message.LParam)^.Offset.X + Left + BorderWidth;
          PacBGInfo(Message.LParam)^.Offset.Y := PacBGInfo(Message.LParam)^.Offset.Y + Top + BorderWidth;
        end;
        Exit;
      end;
      AC_GETCONTROLCOLOR : if TsPageControl(PageControl).SkinData.Skinned then begin
        Message.Result := SendMessage(PageControl.Handle, SM_ALPHACMD, MakeWParam(0, AC_GETCONTROLCOLOR), 0);
        Exit;
      end;
      AC_PREPARING : if TsPageControl(PageControl).SkinData.Skinned then begin
        Message.Result := integer(TsPageControl(PageControl).SkinData.FUpdating);// SendAMessage(PageControl, AC_PREPARING);
        Exit;
      end;
      AC_CHILDCHANGED : if TsPageControl(PageControl).SkinData.Skinned then begin
        Message.LParam := integer((TsPageControl(PageControl).SkinData.SkinManager.gd[TsPageControl(PageControl).SkinData.SkinIndex].GradientPercent + TsPageControl(PageControl).SkinData.SkinManager.gd[TsPageControl(PageControl).SkinData.SkinIndex].ImagePercent > 0) or TsPageControl(PageControl).SkinData.RepaintIfMoved);
        Message.Result := Message.LParam;
        Exit;
      end;
      AC_GETSKININDEX : begin
        if SkinData.SkinSection <> '' then begin
          PacSectionInfo(Message.LParam)^.SkinIndex := TsPageControl(PageControl).SkinData.SkinManager.GetSkinIndex(SkinData.SkinSection);
          if PacSectionInfo(Message.LParam)^.SkinIndex < 0 then PacSectionInfo(Message.LParam)^.SkinIndex := TsPageControl(PageControl).SkinData.SkinIndex;
        end
        else PacSectionInfo(Message.LParam)^.SkinIndex := TsPageControl(PageControl).SkinData.SkinIndex;
        Exit
      end;
      AC_ENDPARENTUPDATE : begin
        RedrawWindow(Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE);
        SetParentUpdated(Self);
        Exit;
      end;
      AC_GETSKINSTATE : begin
        if Message.LParam = 1 then begin
          for i := 0 to ControlCount - 1 do SendAMessage(Controls[i], AC_GETSKINSTATE, 1);
        end
        else begin
          if TsPageControl(PageControl).SkinData.CtrlSkinState and ACS_BGUNDEF = ACS_BGUNDEF
            then UpdateSkinState(TsPageControl(PageControl).SkinData, False);
          Message.Result := TsPageControl(PageControl).SkinData.CtrlSkinState;
        end;
        Exit;
      end;
    end
    else if TsPageControl(PageControl).SkinData.Skinned then case Message.Msg of
      WM_MOUSEMOVE : if not (csDesigning in ComponentState) then begin
        if (DefaultManager <> nil) and not (csDesigning in DefaultManager.ComponentState) then DefaultManager.ActiveControl := Handle;
      end;
      WM_PARENTNOTIFY : if not ((csDesigning in ComponentState) or (csLoading in ComponentState)) and ((Message.WParam and $FFFF = WM_CREATE) or (Message.WParam and $FFFF = WM_DESTROY)) then begin
        inherited;
        if Message.WParamLo = WM_CREATE then begin
          AddToAdapter(Self);
          if Message.LParam <> 0 then SendAMessage(THandle(Message.LParam), AC_GETSKINSTATE, 1);
        end;
        Exit;
      end;
      WM_PAINT : if (Visible or (csDesigning in ComponentState)) then begin
        if not (csDestroying in ComponentState) and (Parent <> nil) then begin // Background update
          InvalidateRect(Handle, nil, True); // Background update (for repaint of graphic controls and for tansheets refreshing)
        end;
        BeginPaint(Handle, PS);
        EndPaint(Handle, PS);
        Message.Result := 0;
        Exit
      end;
      WM_PRINT : begin
        WMEraseBkGnd(TWMPaint(Message));
        Message.Result := 0;
        Exit
      end;
      CM_TEXTCHANGED : begin
        TsPageControl(PageControl).SkinData.BGChanged := True;
      end;
    end;
  end;
  inherited;
  if (PageControl <> nil) and TsPageControl(PageControl).SkinData.Skinned then case Message.Msg of
    CM_VISIBLECHANGED : if ac_OptimizeMemory and not (csDestroying in ComponentState) then begin
      if not Visible then begin
        for i := 0 to ControlCount - 1 do if (Controls[i] is TWinControl) and TWinControl(Controls[i]).HandleAllocated then begin
          SendAMessage(TWinControl(Controls[i]).Handle, AC_CLEARCACHE);
        end;
      end
      else SetParentUpdated(Handle);
    end;
    CM_ENABLEDCHANGED : if not (csDestroying in ComponentState) and not (csLoading in ComponentState) and (Parent <> nil) then begin
      TsPageControl(Parent).SkinData.BGChanged := True;
      RedrawWindow(Parent.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME);
    end;
  end;
end;

{ TsTabSkinData }

procedure TsTabSkinData.SetCustomColor(const Value: boolean);
begin
  FCustomColor := Value;
end;

procedure TsTabSkinData.SetCustomFont(const Value: boolean);
begin
  FCustomFont := Value;
end;

procedure TsTabSkinData.SetSkinSection(const Value: string);
begin
  FSkinSection := Value;
end;

{ TsTabBtn }

constructor TsTabBtn.Create(AOwner: TComponent);
begin
  inherited;
  Flat := True;
  UpdateGlyph;
end;

procedure TsTabBtn.Paint;
{$IFDEF DELPHI7UP}
var
  PaintRect: TRect;
  Button: TThemedWindow;
  Details: TThemedElementDetails;
{$ENDIF}
begin
{$IFDEF DELPHI7UP}
  if ThemeServices.ThemesEnabled then begin
    if FState in [bsDown, bsExclusive]
      then Button := twSmallCloseButtonPushed
      else if MouseInControl then Button := twSmallCloseButtonHot else Button := twSmallCloseButtonNormal;
    Details := ThemeServices.GetElementDetails(Button);
    PerformEraseBackground(Self, Canvas.Handle);
    PaintRect := Rect(0, 0, Width, Height);
    ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
  end
  else
{$ENDIF}
  inherited
end;

procedure TsTabBtn.UpdateGlyph;
begin
  Caption := 'X';
  Font.Style := [fsBold];
  Font.Color := clRed;
end;

end.
