unit acTitleBar;
{$I sDefs.inc}

interface

uses Windows, Classes, ImgList, Messages, Graphics, Forms, {$IFNDEF DELPHI5}Types,{$ENDIF} {$IFDEF DELPHI_XE3}UITypes, {$ENDIF}Controls,
  Menus, ExtCtrls{$IFDEF TNTUNICODE}, TntControls{$ENDIF};

type

{$IFDEF UNICODE}
  ACString = String;
  ACChar   = Char;
  PACChar  = PChar;
{$ELSE} // UNICODE
{$IFDEF TNTUNICODE}
  ACString = WideString;
  ACChar   = WideChar;
  PACChar  = PWideChar;
{$ELSE}
  ACString = AnsiString;
  ACChar   = AnsiChar;
  PACChar  = PAnsiChar;
{$ENDIF}
{$ENDIF} // UNICODE

  PObject = ^TObject;

  TacTitleBarItem = class;

  TacDrawItemEvent = procedure(Item: TacTitleBarItem; R : TRect; Bmp : TBitmap; NoAlpha : boolean) of object;

  TacItemAnimation = class(TTimer)
  public
    FormHandle : hwnd;
    Item : TacTitleBarItem;
    CurrentLevel : integer;
    CurrentState : integer;
    ToShow : boolean;
    MaxIterations : integer;
    AForm : TForm;
    OldForm : TForm;
    NewBmp : TBitmap;
    OldBmp : TBitmap;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function GetFormBounds : TRect;
    function Offset : integer;
    function Step : integer;
    procedure MakeForm;
    procedure UpdateForm(const Blend: integer);
    procedure StartAnimation(NewState : integer; Show : boolean);
    procedure ChangeState(NewState : integer; Show : boolean);
    procedure MakeImg;
    procedure CheckMouseLeave;
    procedure OnAnimTimer(Sender: TObject);
  end;

  TacFontData = class(TPersistent)
  private
    FFont: TFont;
    WndHandle : hwnd;
    FUseSysColor : boolean;
    FUseSysSize : boolean;
    FUseSysStyle : boolean;
    FUseSysFontName : boolean;
    FUseSysGlowing : boolean;
    FGlowSize: integer;
    FGlowColor: TColor;
    procedure SetBool(const Index: Integer; const Value: boolean);
    function GetBool(const Index: Integer): boolean;
    procedure SetFont(const Value: TFont);
    procedure SetGlowSize(const Value: integer);
    procedure SetGlowColor(const Value: TColor);
  public
    UsedFont : TFont;
    GlowMask : TBitmap;
    constructor Create(WindowHandle : hwnd);
    destructor Destroy; override;
    procedure Invalidate;
  published
    property Font : TFont read FFont write SetFont;
    property GlowColor : TColor read FGlowColor write SetGlowColor default clGray;
    property GlowSize : integer read FGlowSize write SetGlowSize default 0;
    property UseSysColor    : boolean index 0 read GetBool write SetBool default True;
    property UseSysFontName : boolean index 1 read GetBool write SetBool default True;
    property UseSysGlowing  : boolean index 2 read GetBool write SetBool default True;
    property UseSysSize     : boolean index 3 read GetBool write SetBool default True;
    property UseSysStyle    : boolean index 4 read GetBool write SetBool default True;
  end;

  TacBtnStyle = (bsButton, bsMenu, bsTab, bsSpacing, bsInfo);
  TacItemAlignment = (taLeftJustify, taRightJustify, taCenter, taCenterInSpace);

  TacTitleBarItem = class(TCollectionItem)
{$IFNDEF NOTFORHELP}
  private
    FName: string;
    FGlyph: TBitmap;
    FEnabled: boolean;
    FHint: acString;
    FVisible: boolean;
    FCaption: acString;
    FGroupIndex: integer;
    FNumGlyphs: integer;
    FImageIndex: integer;
    FStyle: TacBtnStyle;
    FAlignment: TacItemAlignment;
    FOnMouseUp: TMouseEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FHeight: integer;
    FWidth: integer;
    FAutoSize: boolean;
    FBorderIndex: integer;
    FDropdownMenu: TPopupMenu;
    FDefaultMenuBtn: TBitmap;
    FSpacing: integer;
    FFontData: TacFontData;
    FShowHint: boolean;
    FOnDrawItem: TacDrawItemEvent;
    FDroppedDown: boolean;
    FOnClick: TNotifyEvent;
    FOnChanged: TNotifyEvent;
    FContentSize : TSize;
{$IFDEF ALPHASKINS}
    FSkinSection: string;
    FHotImageIndex: integer;
    FDisabledImageIndex: integer;
    FPressedImageIndex: integer;
{$ENDIF}
    procedure SetGlyph(const Value: TBitmap);
    procedure SetName(const Value: string);
    procedure SetVisible(const Value: boolean);
    procedure OnGlyphChange(Sender: TObject);
    procedure SetAlignment(const Value: TacItemAlignment);
    procedure SetCaption(const Value: acString);
    procedure SetGroupIndex(const Value: integer);
    procedure SetNumGlyphs(const Value: integer);
    procedure SetStyle(const Value: TacBtnStyle);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    procedure SetAutoSize(const Value: boolean);
    procedure SetDown(const Value: boolean);
    procedure SetSpacing(const Value: integer);

    procedure UpdateSize;
    procedure SetState(const Value: integer);
    procedure SetSkinSection(const Value: string);
    function GetState: integer;
    procedure SetImageIndex(const Index, Value: integer); // Calc size when AutoSize is True
  protected
    FDown: boolean;
    FState: integer;
    FPressed: boolean;
  public
{$IFDEF TNTUNICODE}
    HintWnd : TTntHintWindow;
{$ELSE}
    HintWnd : THintWindow;
{$ENDIF}
    Rect : TRect;
    Data : ^TObject;
    Timer : TacItemAnimation;
    ExtForm : TForm;
    procedure AssignTo(Dest: TPersistent); override;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoClick;
    procedure Changed;

    procedure Invalidate(RecalcSize : boolean = False);
    function GetDisplayName: string; override;
    function IntXMargin : integer;
    property DefaultMenuBtn : TBitmap read FDefaultMenuBtn;
    property DroppedDown : boolean read FDroppedDown;
    property GroupIndex : integer read FGroupIndex write SetGroupIndex;
    property ContentSize : TSize read FContentSize;
    property Pressed : boolean read FPressed;
    property State : integer read GetState write SetState;
    property OnDrawItem: TacDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
{$ENDIF} // NOTFORHELP
    property Alignment : TacItemAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize : boolean read FAutoSize write SetAutoSize default True;
    property Caption : acString read FCaption write SetCaption;
    property DropdownMenu : TPopupMenu read FDropdownMenu write FDropdownMenu;
    property Down : boolean read FDown write SetDown default False;
    property Enabled : boolean read FEnabled write FEnabled default True;
    property FontData : TacFontData read FFontData write FFontData;
    property Glyph : TBitmap read FGlyph write SetGlyph;
    property Height : integer read FHeight write SetHeight default 18;
    property Hint : acString read FHint write FHint;

    property DisabledImageIndex : integer index 0 read FDisabledImageIndex write SetImageIndex default -1;
    property ImageIndex         : integer index 1 read FImageIndex write SetImageIndex default -1;
    property HotImageIndex      : integer index 2 read FHotImageIndex write SetImageIndex default -1;
    property PressedImageIndex  : integer index 3 read FPressedImageIndex write SetImageIndex default -1;

    property Index;
    property Name : string read FName write SetName;
    property NumGlyphs : integer read FNumGlyphs write SetNumGlyphs default 1;
    property ShowHint : boolean read FShowHint write FShowHint;
{$IFDEF ALPHASKINS}
    property SkinSection : string read FSkinSection write SetSkinSection;
{$ENDIF}
    property Spacing : integer read FSpacing write SetSpacing default 4;
    property Style : TacBtnStyle read FStyle write SetStyle default bsButton;
    property Visible : boolean read FVisible write SetVisible default True;
    property Width : integer read FWidth write SetWidth default 22;
    property OnClick : TNotifyEvent read FOnClick write FOnClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
  end;

  TsTitleBar = class;

  TacTitleItems = class(TCollection)
{$IFNDEF NOTFORHELP}
  private
    FOwner: TsTitleBar;
    function GetItem(Index: Integer): TacTitleBarItem;
    procedure SetItem(Index: Integer; Value: TacTitleBarItem);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;
{$ENDIF} // NOTFORHELP
    function Add: TacTitleBarItem;
    function Insert(Index: Integer): TacTitleBarItem;
    property Items[Index: Integer]: TacTitleBarItem read GetItem write SetItem; default;
  end;

{  TacTitlePanel = class(TPersistent)
  end;}

  TsTitleBar = class(TComponent)
  private
    Form : TForm;
    FItems: TacTitleItems;
    FItemsSpacing: integer;
    FItemsMargin: integer;
    FCaptionRect : TRect;
    FLeftWidth : integer;
    FRightWidth : integer;
    FCenterWidth : integer;
    FCenterWidthS : integer;
    FImages: TCustomImageList;
    FShowCaption: boolean;
    procedure SetItems(const Value: TacTitleItems);
    procedure SetItemsMargin(const Value: integer);
    procedure SetItemsSpacing(const Value: integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetShowCaption(const Value: boolean);
  protected
    FBarVCenter : integer;
    FBarRect: TRect;
    FFullRight : integer;
  public
    FDefaultMenuBtn: TBitmap;
    procedure CalcSizes;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Invalidate;
    procedure PaintItem(Index : integer; R : TRect; Bmp : TBitmap);

    property BarRect : TRect read FBarRect;
    property CaptionRect : TRect read FCaptionRect;
    property LeftWidth : integer read FLeftWidth;
    property RightWidth : integer read FRightWidth;
  published
    property Images : TCustomImageList read FImages write SetImages;
    property Items : TacTitleItems read FItems write SetItems;
    property ItemsMargin : integer read FItemsMargin write SetItemsMargin default 3;
    property ItemsSpacing : integer read FItemsSpacing write SetItemsSpacing default 0;
    property ShowCaption : boolean read FShowCaption write SetShowCaption;
  end;

procedure PaintItemNoAlpha(const DstBmp, SrcBmp : TBitmap; const DstRect, SrcRect, BorderWidths : TRect);
procedure ShowHintWnd(Item : TacTitleBarItem);
procedure HideHintWnd(Item : TacTitleBarItem);
procedure StartItemAnimation(const Item: TacTitleBarItem; const State: integer; const Iterations : integer; const Show : boolean; ExtendedForm : TForm = nil);

const
  acDownChar = #117;
  acDownFont = 'Marlett';

implementation

uses SysUtils, math, Dialogs, sConst, sGraphUtils;

{$R acTitleBar.res}

type
  TsColor = record
    case integer of
      0  : (C : TColor);
      1  : (B, G, R, A : Byte);
      2  : (I : integer);
    end;

  PRGBAArray = ^TRGBAArray;
  TRGBAArray = array[0..100000] of TsColor;

const
  // AlphaSkins message
  SM_ALPHACMD = $A100;
  // AlphaSkins commands
  AC_NCPAINT = 62;

function SwapRedBlue(Color : TColor) : TColor;
begin
  TsColor(Result).A := TsColor(Color).A;
  TsColor(Result).R := TsColor(Color).B;
  TsColor(Result).G := TsColor(Color).G;
  TsColor(Result).B := TsColor(Color).R;
end;

procedure FillRect32(const Bmp : TBItmap; R : TRect; Color : TColor);
var
  S : PRGBAArray;
  X, Y : integer;
  C : TsColor;
begin
  if Bmp.Height < R.Bottom then R.Bottom := Bmp.Height;

  C.C := SwapRedBlue(Color);
  C.A := MaxByte;

  if Bmp.Height = 1 then begin
    if (R.Top >= 0) and (R.Top < Bmp.Height) then begin
      S := Bmp.ScanLine[R.Top];
      for X := 0 to Bmp.Width - 1 do S[R.Left + X] := C
    end;
  end
  else begin
    for Y := max(0, R.Top) to min(Bmp.Height, R.Bottom) - 1 do begin
      S := Bmp.ScanLine[Y];
      for X := max(0, R.Left) to min(Bmp.Width, R.Right) - 1 do S[X] := C;
    end;
  end;  
end;

procedure FillAlphaRect(const Bmp : TBItmap; const R : TRect; Value : byte; SkipFuchsia : boolean = False);
var
  S : PRGBAArray;
  X, Y, w, h : integer;
begin
  w := R.Right - R.Left - 1;
  h := R.Bottom - R.Top - 1;
  if SkipFuchsia then for Y := 0 to h do begin
    S := Bmp.ScanLine[R.Top + Y];
    for X := 0 to w do if TsColor(S[R.Left + X]).C <> clFuchsia then TsColor(S[R.Left + X]).A := Value;
  end
  else for Y := 0 to h do begin
    S := Bmp.ScanLine[R.Top + Y];
    for X := 0 to w do TsColor(S[R.Left + X]).A := Value;
  end;
end;

procedure StartItemAnimation(const Item: TacTitleBarItem; const State: integer; const Iterations : integer; const Show : boolean; ExtendedForm : TForm = nil);
begin
  with Item do begin
    if Timer = nil then begin
      if TacTitleItems(Item.Collection).FOwner.Form <> nil then begin
        Timer := TacItemAnimation.Create(TacTitleItems(Item.Collection).FOwner.Form);
        Item.ExtForm := ExtendedForm;
        Timer.FormHandle := TacTitleItems(Item.Collection).FOwner.Form.Handle;
      end
      else Exit;
      if Timer <> nil then begin
        Timer.Enabled := False;
        Timer.Item := Item;
        Timer.MaxIterations := Iterations;
        Timer.Interval := 12;
        Timer.StartAnimation(State, True);
      end;
    end
    else begin
      if (State = 1) and (Timer.CurrentState = 2) or (State = 2) then begin
        if Item.Timer.OldForm <> nil then Item.Timer.OldForm.Free;
        Item.Timer.OldForm := Item.Timer.AForm;
        Item.Timer.AForm := nil;
        if Timer.NewBmp <> nil then FreeAndNil(Timer.NewBmp);
      end;

      if Show then Timer.CurrentState := State;
      Item.Timer.MaxIterations := Iterations;
      Timer.ToShow := Show;
      Timer.Enabled := True;
      ExtForm := ExtendedForm;
      Timer.StartAnimation(State, True);

      case State of
        2 : begin
          Timer.CurrentLevel := Iterations;
        end;
      end;
    end;
  end
end;

procedure ShowHintWnd(Item : TacTitleBarItem);
var
  R, wR : TRect;
  mPos : TPoint;
{$IFNDEF DELPHI5}
  Animate: BOOL;
{$ENDIF}
begin
  with Item do begin
    if HintWnd <> nil then Exit;//FreeAndNil(HintWnd);
    if ShowHint and (Hint <> '') then begin
  {$IFDEF TNTUNICODE}
      HintWnd := TTntHintWindow.Create(nil);
  {$ELSE}
      HintWnd := THintWindow.Create(nil);
  {$ENDIF}
      HintWnd.Visible := False;
      HintWnd.Color := clInfoBk;
      R := HintWnd.CalcHintRect(800, Hint, nil);
      GetCursorPos(mPos);
      OffsetRect(R, mPos.X + 8, mPos.Y + 16);

{$IFDEF DELPHI6UP}
      wR := TacTitleItems(Item.Collection).FOwner.Form.Monitor.WorkareaRect;
{$ELSE}
      SystemParametersInfo(SPI_GETWORKAREA, 0, @wR, 0);
{$ENDIF}
      if R.Right > wR.Right then OffsetRect(R, wR.Right - R.Right, 0);
      if R.Bottom > wR.Bottom then OffsetRect(R, 0, wR.Bottom - R.Bottom);

      // < Solving the "Owner Z-ordering" problem when BorderForm is used
      HintWnd.Caption := Hint;
      Inc(R.Bottom, 4);

      HintWnd.ParentWindow := Application.Handle;
      HintWnd.SetBounds(R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top);
      SetWindowPos(HintWnd.Handle, HWND_TOPMOST, R.Left, R.Top, HintWnd.Width, HintWnd.Height,
        SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE or SWP_NOOWNERZORDER);
  {$IFNDEF DELPHI5}
      if (Length(Hint) < 100) and Assigned(AnimateWindowProc) then begin
        SystemParametersInfo(SPI_GETTOOLTIPANIMATION, 0, {$IFNDEF CLR}@{$ENDIF}Animate, 0);
        if Animate then begin
          SystemParametersInfo(SPI_GETTOOLTIPFADE, 0, {$IFNDEF CLR}@{$ENDIF}Animate, 0);
          if Animate then AnimateWindowProc(HintWnd.Handle, 200, AW_BLEND);
        end;
      end;
  {$ENDIF}
      ShowWindow(HintWnd.Handle, SW_SHOWNOACTIVATE);
      HintWnd.Invalidate;
      // >
    end;
  end;
end;

procedure HideHintWnd(Item : TacTitleBarItem);
begin
  if Item.HintWnd <> nil then FreeAndNil(Item.HintWnd);
end;

function acGetTitleFont : hFont;
var
{$IFDEF TNTUNICODE}
  NonClientMetrics: TNonClientMetricsW;
{$ELSE}
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
{$IFDEF D2010}
  NonClientMetrics.cbSize := TNonClientMetrics.SizeOf;
{$ELSE}
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
{$ENDIF}
{$IFDEF TNTUNICODE}
  if SystemParametersInfoW(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then Result := CreateFontIndirectW(NonClientMetrics.lfCaptionFont)
{$ELSE}
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then Result := CreateFontIndirect(NonClientMetrics.lfCaptionFont)
{$ENDIF}
  else Result := 0;
end;

function GetCaptionFontSize : integer;
var
{$IFDEF TNTUNICODE}
  NonClientMetrics: TNonClientMetricsW;
{$ELSE}
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
{$IFDEF D2010}
  NonClientMetrics.cbSize := TNonClientMetrics.SizeOf;
{$ELSE}
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
{$ENDIF}
{$IFDEF TNTUNICODE}
  if SystemParametersInfoW(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then Result := NonClientMetrics.lfCaptionFont.lfHeight
{$ELSE}
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then Result := NonClientMetrics.lfCaptionFont.lfHeight
{$ENDIF}
  else Result := 0;
end;

function GetStringSize(hFont : hgdiobj; const Text : acString): TSize;
var
  DC: HDC;
  SaveFont: LongInt;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, hFont);
{$IFDEF TNTUNICODE}
    if not GetTextExtentPoint32W(DC, PWideChar(Text), Length(Text), Result) then begin
{$ELSE}
    if not GetTextExtentPoint32(DC, PChar(Text), Length(Text), Result) then begin
{$ENDIF}
      Result.cx := 0;
      Result.cy := 0;
    end;
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
end;                             

procedure UpdateAlpha(Img: TBitmap);
var
  x, y : integer;
  S : PRGBAArray;
begin
  for Y := 0 to Img.Height - 1 do begin
    S := Img.ScanLine[Y];
    for X := 0 to Img.Width - 1 do with S[X] do if C <> clFuchsia then begin
      A := MaxByte - A;
      R := (R * A) shr 8;
      G := (G * A) shr 8;
      B := (B * A) shr 8;
    end;
  end;
end;

procedure CopyTransRect(DstBmp, SrcBmp: Graphics.TBitMap; X, Y : integer; SrcRect: TRect);
var
  Dst, Src : PRGBAArray;
  sX, sY, DstX, DstY, SrcX, SrcY : Integer;
  h, w, dh : integer;
begin
  // Check ranges
  if SrcRect.Top < 0 then SrcRect.Top := 0;
  if SrcRect.Bottom > SrcBmp.Height - 1 then SrcRect.Bottom := SrcBmp.Height - 1;
  if SrcRect.Left < 0 then SrcRect.Left := 0;
  if SrcRect.Right > SrcBmp.Width - 1 then SrcRect.Right := SrcBmp.Width - 1;
  // Calc delta
  h := SrcRect.Bottom - SrcRect.Top;
  w := SrcRect.Right - SrcRect.Left;
  dh := DstBmp.Height - 1;

  DstY := Y;
  SrcY := SrcRect.Top;

  for sY := 0 to h do begin
    if (DstY <= dh) and (DstY >= 0) then begin
      Dst := DstBmp.ScanLine[DstY];
      Src := SrcBmp.ScanLine[SrcY];
      DstX := X;
      SrcX := SrcRect.Left;
      for sX := 0 to w do begin
        if (Src[SrcX].C <> clFuchsia)
          then Dst[DstX] := Src[SrcX];
        inc(DstX);
        inc(SrcX);
      end
    end;
    inc(DstY);
    inc(SrcY);
  end
end;

procedure PaintItemNoAlpha(const DstBmp, SrcBmp : TBitmap; const DstRect, SrcRect, BorderWidths : TRect);
var
  w, h : integer;
begin
  DstBmp.Transparent := True;
  DstBmp.TransparentColor := clFuchsia;
  SrcBmp.Transparent := True;
  SrcBmp.TransparentColor := clFuchsia;
  SetStretchBltMode(DstBmp.Canvas.Handle, COLORONCOLOR);
  // Copy corners
  // Left top
  CopyTransRect(DstBmp, SrcBmp, DstRect.Left, DstRect.Top, Rect(SrcRect.Left, SrcRect.Top, SrcRect.Left + BorderWidths.Right - 1, SrcRect.Top + BorderWidths.Top - 1));
  // Left bottom
  CopyTransRect(DstBmp, SrcBmp, DstRect.Left, DstRect.Bottom - BorderWidths.Bottom, Rect(SrcRect.Left, SrcRect.Bottom - BorderWidths.Bottom, SrcRect.Left + BorderWidths.Right - 1, SrcRect.Bottom - 1));
  // Right top
  CopyTransRect(DstBmp, SrcBmp, DstRect.Right - BorderWidths.Right, DstRect.Top, Rect(SrcRect.Right - BorderWidths.Right, SrcRect.Top, SrcRect.Right - 1, SrcRect.Top + BorderWidths.Top - 1));
  // Right bottom
  CopyTransRect(DstBmp, SrcBmp, DstRect.Right - BorderWidths.Right, DstRect.Bottom - BorderWidths.Bottom, Rect(SrcRect.Right - BorderWidths.Right, SrcRect.Bottom - BorderWidths.Bottom, SrcRect.Right - 1, SrcRect.Bottom - 1));

  w := max(0, SrcRect.Right - SrcRect.Left - BorderWidths.Right - BorderWidths.Left);
  h := max(0, SrcRect.Bottom - SrcRect.Top - BorderWidths.Bottom - BorderWidths.Top);

  if (h <> 0) then // Left border
    StretchBlt(DstBmp.Canvas.Handle, DstRect.Left, DstRect.Top + BorderWidths.Top, BorderWidths.Left, DstRect.Bottom - DstRect.Top - BorderWidths.Top - BorderWidths.Bottom,
               SrcBmp.Canvas.Handle, SrcRect.Left, SrcRect.Top + BorderWidths.Top, BorderWidths.Left, SrcRect.Bottom - SrcRect.Top - BorderWidths.Top - BorderWidths.Bottom, SRCCOPY);
  if (w <> 0) then // Top border
    StretchBlt(DstBmp.Canvas.Handle, DstRect.Left + BorderWidths.Left, DstRect.Top, DstRect.Right - DstRect.Left - BorderWidths.Left - BorderWidths.Right, BorderWidths.Top,
               SrcBmp.Canvas.Handle, SrcRect.Left + BorderWidths.Left, SrcRect.Top, SrcRect.Right - SrcRect.Left - BorderWidths.Left - BorderWidths.Right, BorderWidths.Top, SRCCOPY);
  if (h <> 0) then // Right border
    StretchBlt(DstBmp.Canvas.Handle, DstRect.Right - BorderWidths.Right, DstRect.Top + BorderWidths.Top, BorderWidths.Right, DstRect.Bottom - DstRect.Top - BorderWidths.Bottom - BorderWidths.Top,
               SrcBmp.Canvas.Handle, SrcRect.Right - BorderWidths.Right, SrcRect.Top + BorderWidths.Top, BorderWidths.Right, SrcRect.Bottom - SrcRect.Top - BorderWidths.Bottom - BorderWidths.Top, SRCCOPY);
  if (w <> 0) then // Bottom border
    StretchBlt(DstBmp.Canvas.Handle, DstRect.Left + BorderWidths.Left, DstRect.Bottom - BorderWidths.Bottom, DstRect.Right - DstRect.Left - BorderWidths.Right - BorderWidths.Left, BorderWidths.Bottom,
               SrcBmp.Canvas.Handle, SrcRect.Left + BorderWidths.Left, SrcRect.Bottom - BorderWidths.Bottom, SrcRect.Right - SrcRect.Left - BorderWidths.Right - BorderWidths.Left, BorderWidths.Bottom, SRCCOPY);
  // Center
  StretchBlt(DstBmp.Canvas.Handle, DstRect.Left + BorderWidths.Left, DstRect.Top + BorderWidths.Top, DstRect.Right - DstRect.Left - BorderWidths.Right - BorderWidths.Left, DstRect.Bottom - DstRect.Top - BorderWidths.Bottom - BorderWidths.Top,
             SrcBmp.Canvas.Handle, SrcRect.Left + BorderWidths.Left, SrcRect.Top + BorderWidths.Top, SrcRect.Right - SrcRect.Left - BorderWidths.Right - BorderWidths.Left, SrcRect.Bottom - SrcRect.Top - BorderWidths.Bottom - BorderWidths.Top, SRCCOPY);
end;

{ TsTitleBar }

procedure TsTitleBar.CalcSizes;
var
  i : integer;
  LastLeft, LastCenter, LastCenterS, LastRight : integer;
  procedure CalcItem(Item: TacTitleBarItem);
  begin
    case Item.Style of
      bsButton  : Item.Rect.Top := FBarVCenter - Item.Height div 2;
      bsMenu    : Item.Rect.Top := FBarRect.Top;
      bsTab     : Item.Rect.Top := FBarRect.Bottom - Item.Height;
      bsSpacing : Item.Rect.Top := FBarVCenter - Item.Height div 2;
      bsInfo    : Item.Rect.Top := FBarVCenter - Item.Height div 2;
    end;
    Item.Rect.Bottom := Item.Rect.Top + Item.Height;
    case Item.Alignment of
      taLeftJustify : begin
        Item.Rect.Left := LastLeft;
        Item.Rect.Right := Item.Rect.Left + Item.Width;
        inc(LastLeft, Item.Width);
      end;
      taRightJustify : begin
        Item.Rect.Left := LastRight;
        Item.Rect.Right := Item.Rect.Left + Item.Width;
        inc(LastRight, Item.Width);
      end;
      taCenter : begin
        Item.Rect.Left := LastCenter;
        Item.Rect.Right := Item.Rect.Left + Item.Width;
        inc(LastCenter, Item.Width);
      end;
      taCenterInSpace : begin
        Item.Rect.Left := LastCenterS;
        Item.Rect.Right := Item.Rect.Left + Item.Width;
        inc(LastCenterS, Item.Width);
      end;
    end;
  end;
begin
  // Init
  FLeftWidth := 0;
  FRightWidth := 0;
  FCenterWidth := 0;
  FCenterWidthS := 0;
  // Calc main parts sizes
  for i := 0 to FItems.Count - 1 do if FItems[i].Visible then begin
    case FItems[i].Alignment of
      taLeftJustify  : inc(FLeftWidth, FItems[i].Width);
      taRightJustify : inc(FRightWidth, FItems[i].Width);
      taCenter       : inc(FCenterWidth, FItems[i].Width);
      taCenterInSpace : inc(FCenterWidthS, FItems[i].Width);
    end;
  end;
  // Items positions
  LastLeft := FBarRect.Left;// + FLeftWidth;
  LastCenter := FBarRect.Left + (FFullRight - FBarRect.Left - FCenterWidth) div 2;
  LastCenterS := FBarRect.Left + FLeftWidth + (FBarRect.Right - FBarRect.Left - FRightWidth - FLeftWidth - FCenterWidthS) div 2;
  LastRight := FBarRect.Right - FRightWidth;
  for i := 0 to FItems.Count - 1 do if FItems[i].Visible then CalcItem(FItems[i]);
end;

constructor TsTitleBar.Create(AOwner: TComponent);
begin
  if not (AOwner is TCustomForm) then Raise EAbort.Create('TsTitleBar component may be used with forms only!');
  inherited Create(AOwner);
  Form := TForm(AOwner);

  FDefaultMenuBtn := TBitmap.Create;
  FDefaultMenuBtn.Handle := LoadBitmap(hInstance, 'MENUBTN');
  FDefaultMenuBtn.PixelFormat := pf32bit;
  UpdateAlpha(FDefaultMenuBtn);
  FFullRight := 0;

  FItems := TacTitleItems.Create(Self);
  FItemsMargin := 3;
end;

destructor TsTitleBar.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FDefaultMenuBtn);
  inherited;
end;

procedure TsTitleBar.Invalidate;
begin
  if Assigned(Form) and not (csLoading in Form.ComponentState) then SendMessage(Form.Handle, SM_ALPHACMD, MakeWParam(0, AC_NCPAINT), 1);
end;

procedure TsTitleBar.Loaded;
var
  i : integer;
begin
  for i := 0 to Items.Count - 1 do if Items[i].AutoSize then Items[i].UpdateSize;
  inherited;
end;

procedure TsTitleBar.PaintItem(Index: integer; R: TRect; Bmp: TBitmap);
begin
{
  if (FOwner.BorderForm <> nil) and (FOwner.SkinData.SkinManager.SkinData.ExDrawMode = 1) then begin // Semitransparent title
  end
  else begin // Simple title
  end;
}
end;

procedure TsTitleBar.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then begin
    FImages := Value;
    Invalidate;
  end;
end;

procedure TsTitleBar.SetItems(const Value: TacTitleItems);
begin
  FItems := Value;
end;

procedure TsTitleBar.SetItemsMargin(const Value: integer);
begin
  FItemsMargin := Value;
end;

procedure TsTitleBar.SetItemsSpacing(const Value: integer);
begin
  FItemsSpacing := Value;
end;

procedure TsTitleBar.SetShowCaption(const Value: boolean);
begin
  if FShowCaption <> Value then begin
    FShowCaption := Value;
    Invalidate;
  end;
end;

{ TacTitleBarItem }

procedure TacTitleBarItem.AssignTo(Dest: TPersistent);
begin
  if Dest = nil then inherited else begin
    TacTitleBarItem(Dest).AutoSize := AutoSize;
    TacTitleBarItem(Dest).Alignment := Alignment;
    TacTitleBarItem(Dest).Caption := Caption;
    TacTitleBarItem(Dest).Enabled := Enabled;
    TacTitleBarItem(Dest).Glyph := Glyph;
    TacTitleBarItem(Dest).GroupIndex := GroupIndex;
    TacTitleBarItem(Dest).Hint := Hint;
    TacTitleBarItem(Dest).ImageIndex := ImageIndex;
    TacTitleBarItem(Dest).Name := Name;
    TacTitleBarItem(Dest).NumGlyphs := NumGlyphs;
    TacTitleBarItem(Dest).Style := Style;
    TacTitleBarItem(Dest).Visible := Visible;
    TacTitleBarItem(Dest).OnMouseDown := OnMouseDown;
    TacTitleBarItem(Dest).OnMouseUp := OnMouseUp;
  end;
end;

procedure TacTitleBarItem.Changed;
begin
  if Assigned(FOnChanged) then FOnChanged(Self);
end;

constructor TacTitleBarItem.Create(Collection: TCollection);
begin
  FAutoSize := True;
  FFontData := TacFontData.Create(TacTitleItems(Collection).FOwner.Form.Handle);
  FGlyph := TBitmap.Create;
  FGlyph.OnChange := OnGlyphChange;
  FEnabled := True;
  ExtForm := nil;
  FVisible := True;
  FAlignment := taLeftJustify;
  FDown := False;
  FImageIndex := -1;
  FSpacing := 4;
  FBorderIndex := -1;
  FNumGlyphs := 1;
  FHeight := 18;
  FWidth := 22;

  FDisabledImageIndex := -1;
  FImageIndex := -1;
  FHotImageIndex := -1;
  FPressedImageIndex := -1;

  HintWnd := nil;
  inherited Create(Collection);
  if FName = '' then FName := ClassName;
end;

destructor TacTitleBarItem.Destroy;
begin
  if Timer <> nil then FreeAndNil(Timer);
  FreeAndNil(FGlyph);
  FreeAndNil(FFontData);
  if HintWnd <> nil then FreeAndNil(HintWnd);

  if Data <> nil then begin
    Data.Free;
    FreeMem(Data);
  end;

  inherited Destroy;
end;

procedure TacTitleBarItem.DoClick;
begin
  FPressed := False;
  if Assigned(FOnClick) then FOnClick(Self);
end;

procedure TacTitleBarItem.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  i : integer;
  NewItem : TacTitleBarItem;
begin
  if FPressed or not Enabled then Exit;
  FPressed := True;
  if Assigned(FOnMouseDown) then FOnMouseDown(Self, Button, Shift, X, Y);
  case Style of
    bsMenu, bsButton : if (FDropDownMenu <> nil) and (FDropDownMenu.Items.Count > 0) then begin
      FDropDownMenu.WindowHandle := TacTitleItems(Collection).FOwner.Form.Handle;
      p.X := Rect.Left;
      p.Y := Rect.Bottom;
      if Assigned(ExtForm) then begin
        inc(p.X, ExtForm.Left);
        inc(p.Y, ExtForm.Top);
      end
      else begin
        inc(p.X, TacTitleItems(Collection).FOwner.Form.Left);
        inc(p.Y, TacTitleItems(Collection).FOwner.Form.Top);
      end;
      FDroppedDown := True;
      FDropDownMenu.Popup(p.X, p.Y);
      FDroppedDown := False;
      FState := 0;
      if Timer <> nil then FreeAndNil(Timer);
      // Repaint a form title
      Invalidate;
      FDropDownMenu.WindowHandle := 0;
      DoClick;
    end;
    bsTab : begin
      if not Down then begin
        DoClick;
        for i := 0 to Collection.Count - 1 do begin
          NewItem := TacTitleBarItem(Collection.Items[i]);
          if NewItem.Visible and (NewItem.GroupIndex = GroupIndex) and NewItem.Down then begin
            NewItem.Down := False;
          end;
        end;
        Down := True;
      end;
    end;
  end;
end;

procedure TacTitleBarItem.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Enabled then Exit;
  if Assigned(FOnMouseUp) then FOnMouseUp(Self, Button, Shift, X, Y);
  if FPressed and (Style <> bsTab) then DoClick;
  FPressed := False;
end;

function TacTitleBarItem.GetDisplayName: string;
begin
  Result := Name;
end;

function TacTitleBarItem.GetState: integer;
begin
  if (FDroppedDown or FDown) and (Style = bsTab) then Result := 2 else Result := FState;
end;

function TacTitleBarItem.IntXMargin: integer;
begin
  case Style of
    bsMenu{, bsTab} : begin
      Result := 4;
    end
    else Result := 0;
  end;
end;

procedure TacTitleBarItem.Invalidate;
begin
  if Assigned(TacTitleItems(Collection).FOwner.Form) and not (csLoading in TacTitleItems(Collection).FOwner.Form.ComponentState) then begin
    if RecalcSize then begin
      if FAutoSize then UpdateSize;
    end;
    if Timer <> nil then begin
      if Timer.NewBmp <> nil then FreeAndNil(Timer.NewBmp);
      if Timer.AForm <> nil then FreeAndNil(Timer.AForm);
    end;
    SendMessage(TacTitleItems(Collection).FOwner.Form.Handle, SM_ALPHACMD, MakeWParam(0, AC_NCPAINT), 1); // Change cache in AlphaSkins and repaint a non-client area
  end;
end;

procedure TacTitleBarItem.OnGlyphChange(Sender: TObject);
begin
//  if Data.Timer <> nil then FreeAndNil(Data.Timer);
end;

procedure TacTitleBarItem.SetAlignment(const Value: TacItemAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetAutoSize(const Value: boolean);
begin
  if FAutoSize <> Value then begin
    FAutoSize := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetCaption(const Value: acString);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetDown(const Value: boolean);
begin
  if FDown <> Value then begin
    FDown := Value;
    State := integer(Value) * 2;
    Invalidate;
  end;
end;

procedure TacTitleBarItem.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate(True);
end;

procedure TacTitleBarItem.SetGroupIndex(const Value: integer);
begin
  if FGroupIndex <> Value then begin
    FGroupIndex := Value;
    Invalidate;
  end;
end;

procedure TacTitleBarItem.SetHeight(const Value: integer);
begin
  if FHeight <> Value then begin
    FHeight := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetImageIndex(const Index, Value: integer);
begin
  State := 0;
  case Index of
    0 : if FDisabledImageIndex <> Value then begin
      FDisabledImageIndex := Value;
      Invalidate;
    end;
    1 : if FImageIndex <> Value then begin
      FImageIndex := Value;
      Invalidate;
    end;
    2 : if FHotImageIndex <> Value then begin
      FHotImageIndex := Value;
      Invalidate;
    end;
    3 : if FPressedImageIndex <> Value then begin
      FPressedImageIndex := Value;
      Invalidate;
    end;
  end;
end;

procedure TacTitleBarItem.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TacTitleBarItem.SetNumGlyphs(const Value: integer);
begin
  if FNumGlyphs <> Value then begin
    FNumGlyphs := Value;
    Invalidate(True);
  end;
end;

{$IFDEF ALPHASKINS}
procedure TacTitleBarItem.SetSkinSection(const Value: string);
begin
  if FSkinSection <> Value then begin
    FSkinSection := Value;
    Changed;
    Invalidate;
  end;
end;
{$ENDIF}

procedure TacTitleBarItem.SetSpacing(const Value: integer);
begin
  if FSpacing <> Value then begin
    FSpacing := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetState(const Value: integer);
begin
  if FState <> Value then begin
    if FDroppedDown then FState := 2 else FState := Value;
  end;
end;

procedure TacTitleBarItem.SetStyle(const Value: TacBtnStyle);
begin
  if FStyle <> Value then begin
    FStyle := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetVisible(const Value: boolean);
begin
  if FVisible <> Value then begin
    FVisible := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.SetWidth(const Value: integer);
begin
  if FWidth <> Value then begin
    FWidth := Value;
    Invalidate(True);
  end;
end;

procedure TacTitleBarItem.UpdateSize;
var
  ts : TSize;
  s : string;
begin
  if Visible then with TacTitleItems(Collection).FOwner do begin
    // Size and pos of icon
    if Assigned(TacTitleItems(Collection).FOwner.Images) and (TacTitleItems(Collection).FOwner.Images.Count > ImageIndex) and (ImageIndex >= 0) then begin
      FContentSize.cx := Images.Width;// div NumGlyphs;
      FContentSize.cy := Images.Height;
    end
    else begin // Min size
      if Assigned(FGlyph) and not FGlyph.Empty then begin
        FContentSize.cx := FGlyph.Width div NumGlyphs;
        FContentSize.cy := FGlyph.Height;
      end
      else begin
        FContentSize.cx := 0;
        FContentSize.cy := 0;
      end;
    end;
    // Text size
    if Caption <> '' then begin
      // Init font
      FFontData.UsedFont.Handle := acGetTitleFont;
      if not FFontData.FUseSysStyle then FFontData.UsedFont.Style := FFontData.Font.Style;
      if not FFontData.UseSysFontName then FFontData.UsedFont.Name := FFontData.Font.Name;
      if not FFontData.FUseSysSize then FFontData.UsedFont.Height := FFontData.Font.Height else FFontData.UsedFont.Height := GetCaptionFontSize;

      s := Caption;
      ts := GetStringSize(FFontData.UsedFont.Handle, s);

      if FContentSize.cx <> 0 then inc(FContentSize.cx, FSpacing); // If image is defined then add a spacing
      FContentSize.cx := FContentSize.cx + ts.cx + 4 * integer(Style = bsTab);
      FContentSize.cy := max(FContentSize.cy, ts.cy);
    end;
    if (Style in [bsMenu, bsButton]) and (DropDownMenu <> nil) then begin
      if Style = bsMenu then inc(FContentSize.cx, 4) else inc(FContentSize.cx, 1); // Additional spacing for arrow
      FFontData.UsedFont.Name := acDownFont;
      FFontData.UsedFont.Charset := DEFAULT_CHARSET;
      ts := GetStringSize(FFontData.UsedFont.Handle, acDownChar); // Size of arrow
      inc(FContentSize.cx, ts.cx);
    end;

    if Style in [bsTab, bsMenu] then inc(FContentSize.cy, 1);
    if not (Style in [bsSpacing]) then begin
      FWidth := max(16, FContentSize.cx + 2 * (TacTitleItems(Collection).FOwner.ItemsMargin + IntXMargin));
      FHeight := max(16, FContentSize.cy + 2 * (TacTitleItems(Collection).FOwner.ItemsMargin));
    end;
  end;
end;

{ TacTitleItems }

function TacTitleItems.Add: TacTitleBarItem;
begin
  Result := TacTitleBarItem(inherited Add);
end;

constructor TacTitleItems.Create(AOwner: TPersistent);
begin
  FOwner := TsTitleBar(AOwner);
  inherited Create(TacTitleBarItem);
end;

destructor TacTitleItems.Destroy;
begin
  inherited Destroy;
end;

function TacTitleItems.GetItem(Index: Integer): TacTitleBarItem;
begin
  Result := TacTitleBarItem(inherited GetItem(Index))
end;

function TacTitleItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TacTitleItems.Insert(Index: Integer): TacTitleBarItem;
begin
  Result := TacTitleBarItem(inherited Insert(Index));
end;

procedure TacTitleItems.SetItem(Index: Integer; Value: TacTitleBarItem);
begin
  inherited SetItem(Index, Value);
end;

{ TacFontData }

constructor TacFontData.Create;
begin
  FFont := TFont.Create;
  GlowMask := nil;
  FGlowColor := clGray;
  FGlowSize := 0;
  UsedFont := TFont.Create;
  FUseSysColor := True;
  FUseSysFontName := True;
  FUseSysGlowing := True;
  FUseSysSize := True;
  FUseSysStyle := True;
end;

destructor TacFontData.Destroy;
begin
  FreeAndNil(FFont);
  FreeAndNil(UsedFont);
  if GlowMask <> nil then FreeAndNil(GlowMask);
  inherited;
end;

function TacFontData.GetBool(const Index: Integer): boolean;
begin
  case Index of
    0 : Result := FUseSysColor;
    1 : Result := FUseSysFontName;
    2 : Result := FUseSysGlowing;
    3 : Result := FUseSysSize;
    4 : Result := FUseSysStyle;
  end;
end;

procedure TacFontData.Invalidate;
begin
  if WndHandle <> 0 then SendMessage(WndHandle, SM_ALPHACMD, MakeWParam(0, AC_NCPAINT), 1); // Change cache in AlphaSkins and repaint a non-client area
end;

procedure TacFontData.SetBool(const Index: Integer; const Value: boolean);
begin
  case Index of
    0 : FUseSysColor    := Value;
    1 : FUseSysFontName := Value;
    2 : FUseSysGlowing  := Value;
    3 : FUseSysSize     := Value;
    4 : FUseSysStyle    := Value;
  end;
  Invalidate;
end;

procedure TacFontData.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TacFontData.SetGlowColor(const Value: TColor);
begin
  if FGlowColor <> Value then begin
    FGlowColor := Value;
    Invalidate;
  end;
end;

procedure TacFontData.SetGlowSize(const Value: integer);
begin
  if FGlowSize <> Value then begin
    FGlowSize := Value;
    Invalidate;
  end;
end;

{ TacItemAnimation }

procedure TacItemAnimation.ChangeState(NewState: integer; Show: boolean);
begin
  ToShow := Show;
  Enabled := True;
end;

procedure TacItemAnimation.CheckMouseLeave;
var
  P, mPos : TPoint;
  R : TRect;
begin
  GetCursorPos(mPos);
  if Item.ExtForm <> nil then p := Point(mPos.X - Item.ExtForm.Left, mPos.Y - Item.ExtForm.Top) else begin
    GetWindowRect(FormHandle, R);
    p := Point(mPos.X - R.Left, mPos.Y - R.Top);
  end;
  if not PtInRect(Item.Rect, P) then begin
    Enabled := False;
    SendMessage(FormHandle, WM_MOUSELEAVE, 0, 0);
  end;
end;

constructor TacItemAnimation.Create(AOwner: TComponent);
begin
  inherited;
  CurrentLevel := 0;
  CurrentState := 0;
  NewBmp := nil;
  OldBmp := nil;
  AForm := nil;
  OldForm := nil;
  ToShow := False;
  OnTimer := OnAnimTimer;
end;

destructor TacItemAnimation.Destroy;
begin
  Enabled := False;
  if AForm <> nil then FreeAndNil(AForm);
  if OldForm <> nil then FreeAndNil(OldForm);
  if NewBmp <> nil then FreeAndNil(NewBmp);
  Item.Timer := nil;
  inherited;
end;

function TacItemAnimation.GetFormBounds: TRect;
var
//  mi,
  mOffset : integer;
begin
  if Item.ExtForm <> nil then GetWindowRect(Item.ExtForm.Handle, Result) else GetWindowRect(FormHandle, Result);
  OffsetRect(Result, Item.Rect.Left, Item.Rect.Top);

  mOffset := Offset;
{
  if mOffset <> 0 then begin
    mi := SkinData.SkinManager.GetMaskIndex(s_GlobalInfo, SkinData.SkinManager.ma[PBtnData^.ImageIndex].PropertyName + s_Glow + '0');
    if (mi > -1) then begin
      Result.Left := Result.Left - mOffset;
      Result.Top := Result.Top - mOffset;
      Result.Right := Result.Left + WidthOf(SkinData.SkinManager.ma[mi].R);
      Result.Bottom := Result.Top + HeightOf(SkinData.SkinManager.ma[mi].R);
    end
    else mOffset := 0;
  end;
}
  if mOffset = 0 then begin
    Result.Right := Result.Left + Item.Rect.Right - Item.Rect.Left;
    Result.Bottom := Result.Top + Item.Rect.Bottom - Item.Rect.Top;
  end;
end;

procedure TacItemAnimation.MakeForm;
begin
  if AForm = nil then begin
    AForm := TForm.Create(nil);
    AForm.Tag := -98; // Except this form from automatic skinning
    AForm.Visible := False;
    AForm.BorderStyle := bsNone;
    SetWindowLong(AForm.Handle, GWL_EXSTYLE, GetWindowLong(AForm.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE or WS_EX_TRANSPARENT);

    if (Item.ExtForm <> nil) and (Item.ExtForm.FormStyle = fsStayOnTop) then begin
      SetWindowLong(AForm.Handle, GWL_EXSTYLE, GetWindowLong(AForm.Handle, GWL_EXSTYLE) or WS_EX_TOPMOST);
    end;
  end;
end;

procedure TacItemAnimation.MakeImg;
var
  R : TRect;
//  mi : integer;
//  b : boolean;
//  CI : TCacheInfo;
//  x, y, j : integer;
//  p : PRGBAArray;
//  ImgIndex : integer;
//  TitleButton : TsTitleButton;
begin
//  mi := -1;
  if (CurrentState = 0) and (NewBmp <> nil) then Exit; // Updating is not required
  R := GetFormBounds;

//  b := SkinData.SkinManager.Effects.AllowGlowing and (CurrentState = 1) and (PBtnData^.HitCode in [HTCLOSE, HTMAXBUTTON, HTMINBUTTON]);
{
  if (SkinData.FOwnerObject is TsSkinProvider) and (PBtnData^.HitCode = HTMINBUTTON) and IsIconic(TsSkinProvider(SkinData.FOwnerObject).Form.Handle)
    then ImgIndex := SkinData.SkinManager.GetMaskIndex(SkinData.SkinManager.ConstData.IndexGlobalInfo, s_GlobalInfo, s_BorderIconNormalize)
    else ImgIndex := PBtnData^.ImageIndex;
  if b then begin
    mi := SkinData.SkinManager.GetMaskIndex(s_GlobalInfo, SkinData.SkinManager.ma[ImgIndex].PropertyName + s_Glow + '0');
    b := mi <> -1;
  end;
}
  if NewBmp = nil then NewBmp := TBitmap.Create;
  NewBmp.Width := R.Right - R.Left;
  NewBmp.Height := R.Bottom - R.Top;
  NewBmp.PixelFormat := pf32bit;

  if Assigned(Item.OnDrawItem) then begin
    Item.OnDrawItem(Item, Rect(0, 0, NewBmp.Width, NewBmp.Height), NewBmp, True);
  end
  else begin
//  CreateBmp32(WidthOf(R, True), HeightOf(R, True));
    FillRect32(NewBmp, Rect(0, 0, NewBmp.Width, NewBmp.Height), clYellow);
    FillAlphaRect(NewBmp, Rect(0, 0, NewBmp.Width, NewBmp.Height), 255);
  end;
{

  if b then with SkinData.SkinManager do begin
    if IsValidImgIndex(mi) then BitBlt(ABmp.Canvas.Handle, 0, 0, ABmp.Width, ABmp.Height, ma[mi].Bmp.Canvas.Handle, 0, 0, SRCCOPY);
  end
  else begin
    CI.X := PBtnData^.Rect.Left;
    CI.Y := PBtnData^.Rect.Top;
    if (SkinData.FOwnerObject is TsSkinProvider) and (TsSkinProvider(SkinData.FOwnerObject).TempBmp <> nil) then begin
      CI.X := CI.X - (TsSkinProvider(SkinData.FOwnerObject).CaptionWidth - TsSkinProvider(SkinData.FOwnerObject).TempBmp.Width - 1);
      CI.Bmp := TsSkinProvider(SkinData.FOwnerObject).TempBmp;
    end
    else CI.Bmp := SkinData.FCacheBmp;
    CI.Ready := True;
    FillRect32(ABmp, Rect(0, 0, ABmp.Width, ABmp.Height), 0);
    FillAlphaRect(ABmp, Rect(0, 0, ABmp.Width, ABmp.Height), 0);
    if (ImgIndex > -1) then begin
      DrawSkinGlyph(ABmp, Point(0, 0), PBtnData^.State, 1, SkinData.SkinManager.ma[ImgIndex], MakeCacheInfo(ABmp));
    end;
    if (BorderForm = nil) then begin
      if (ImgIndex < 0) or (SkinData.SkinManager.ma[ImgIndex].MaskType = 0) then for y := 0 to ABmp.Height - 1 do begin // If AlphaChannel must be updated
        p := ABmp.ScanLine[y];
        for x := 0 to ABmp.Width - 1 do if p[x].C = clFuchsia then p[x].A := MaxByte;
      end;
    end;
  end;
  if (SkinData.FOwnerObject is TsSkinProvider) then with TsSkinProvider(SkinData.FOwnerObject) do if Between(PBtnData^.HitCode, HTUDBTN, HTUDBTN + TitleButtons.Count - 1) then begin // User defined button glyph
    j := PBtnData^.HitCode - HTUDBTN;
    TitleButton := TitleButtons.Items[j];
    if not TitleButton.Glyph.Empty then begin
      if TitleButton.Glyph.PixelFormat = pf32bit then begin
        x := (ABmp.Width - TitleButton.Glyph.Width) div 2;
        y := (ABmp.Height - TitleButton.Glyph.Height) div 2;
        if (PBtnData^.State = 2) then begin inc(x); inc(y) end;
        CopyByMask(Rect(x, y, x + TitleButton.Glyph.Width, y + TitleButton.Glyph.Height),
                   Rect(0, 0, TitleButton.Glyph.Width, TitleButton.Glyph.Height), ABmp, TitleButton.Glyph, EmptyCI, True);
      end
      else begin
        CopyTransBitmaps(ABmp, TitleButton.Glyph,
             integer(PBtnData^.State = 2) + (WidthOf(PBtnData^.Rect) - TitleButton.Glyph.Width) div 2,
             integer(PBtnData^.State = 2) + (HeightOf(PBtnData^.Rect) - TitleButton.Glyph.Height) div 2,
             TsColor(TitleButton.Glyph.Canvas.Pixels[0, TitleButton.Glyph.Height - 1]));
      end;
    end
  end;
}
end;

function TacItemAnimation.Offset: integer;
begin
  Result := 0;
end;

procedure TacItemAnimation.OnAnimTimer(Sender: TObject);
begin
  if not Enabled then Exit;
  if ToShow then begin
    if CurrentLevel >= MaxIterations then begin // Showing is finished
      CheckMouseLeave;
      if MaxIterations <> -1 then begin
        MaxIterations := -1;
        UpdateForm(MaxByte);
      end;
      if OldForm <> nil then FreeAndNil(OldForm);
    end
    else begin
      UpdateForm(max(min(CurrentLevel * Step, MaxByte), 0));
      inc(CurrentLevel);
    end;
  end
  else begin
    if CurrentLevel <= 0 then begin // Hiding is finished
      CurrentState := -1;
      Enabled := False;
      if (NewBmp <> nil) then FreeAndNil(NewBmp);
      if (AForm <> nil) then FreeAndNil(AForm);
    end
    else begin
      UpdateForm(max(0, min(CurrentLevel * Step, MaxByte)));
      dec(CurrentLevel);
    end;
  end;
end;

procedure TacItemAnimation.StartAnimation(NewState: integer; Show: boolean);
begin
  if CurrentState <> NewState then begin
    CurrentState := NewState;
    if NewState <> 0 then begin
      if NewState = 2 then begin
        FreeAndNil(AForm);
        FreeAndNil(NewBmp);
      end;
      CurrentLevel := 1;
      ToShow := Show;
      UpdateForm(min(Step, MaxByte));
      inc(CurrentLevel);
      if Maxiterations > 1 then Enabled := True;
    end
    else begin
        FreeAndNil(AForm);
        FreeAndNil(NewBmp);
      ToShow := False;
      dec(CurrentLevel);
      UpdateForm(min(Step, MaxByte));
      if Maxiterations > 1 then Enabled := True;
    end;
  end;
end;

function TacItemAnimation.Step: integer;
begin
  Result := max(MaxByte div MaxIterations, 0); 
end;

procedure TacItemAnimation.UpdateForm(const Blend: integer);
var
  R : TRect;
  iInsAfter, Flags : Cardinal;
  FBmpSize : TSize;
  OwnerHandle : THandle;
  DC : hdc;
  FBmpTopLeft : TPoint;
  FBlend: TBlendFunction;
begin
  if NewBmp = nil then MakeImg;
  if AForm = nil then MakeForm;
  if (NewBmp = nil) or (AForm = nil) then Exit;
  FBmpSize.cx := NewBmp.Width;
  FBmpSize.cy := NewBmp.Height;

  R := GetFormBounds;
  if FBmpSize.cx <> R.Right - R.Left then begin // If image is hiding
    InflateRect(R, (FBmpSize.cx - R.Right + R.Left) div 2, (FBmpSize.cy - R.Bottom + R.Top) div 2);
  end;
  if Item.ExtForm <> nil then OwnerHandle := Item.ExtForm.Handle else OwnerHandle := FormHandle;
  if GetWindowLong(OwnerHandle, GWL_EXSTYLE) and WS_EX_TOPMOST = WS_EX_TOPMOST
    then iInsAfter := HWND_TOPMOST
    else iInsAfter := GetNextWindow(OwnerHandle, GW_HWNDPREV);
  Flags := SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSENDCHANGING;

  // Replacement of SetWindowPos (for Aero)
  AForm.Left := R.Left;
  AForm.Top := R.Top;
  AForm.Width := FBmpSize.cx;
  
  AForm.Height := FBmpSize.cy;

  FBmpTopLeft := Point(0, 0);
  FBlend.SourceConstantAlpha := Blend;
  FBlend.BlendOp := AC_SRC_OVER;
  FBlend.BlendFlags := 0;
  FBlend.AlphaFormat := AC_SRC_ALPHA;

  SetWindowPos(AForm.Handle, iInsAfter, 0, 0, 0, 0, Flags or SWP_NOMOVE or SWP_NOSIZE);
  DC := GetDC(0);
  SetWindowLong(AForm.Handle, GWL_EXSTYLE, GetWindowLong(AForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_NOACTIVATE or WS_EX_TRANSPARENT);
  UpdateLayeredWindow(AForm.Handle, DC, nil, @FBmpSize, NewBmp.Canvas.Handle, @FBmpTopLeft, clNone, @FBlend, ULW_ALPHA);
  ShowWindow(AForm.Handle, SW_SHOWNOACTIVATE);
  ReleaseDC(0, DC);
end;

end.
