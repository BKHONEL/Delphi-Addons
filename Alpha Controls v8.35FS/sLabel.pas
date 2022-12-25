unit sLabel;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {$IFDEF LOGGED} sDebugMsgs,{$ENDIF}
  StdCtrls, sConst, sMessages{$IFDEF DELPHI7UP}, Types{$ENDIF}
  {$IFDEF TNTUNICODE}, TntControls, TntStdCtrls, TntGraphics{$ENDIF};

type
{$IFNDEF NOTFORHELP}
  TsShadowMode = (smNone, smCustom, smSkin1);
  TsKindType = (ktStandard, ktCustom, ktSkin);
{$ENDIF}

{$IFNDEF NOTFORHELP}
  TsCustomLabel = class(TCustomLabel)
  private
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FSkinSection: string;
{$IFDEF TNTUNICODE}
    function GetCaption: TWideCaption;
    function IsCaptionStored: Boolean;
    procedure SetCaption(const Value: TWideCaption);
    function GetHint: WideString;
    function IsHintStored: Boolean;
    procedure SetHint(const Value: WideString);
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    function GetLabelText: WideString; reintroduce; virtual;
{$ENDIF}
    procedure SetSkinSection(const Value: string);
  protected
    function GetCurrentFont : TFont; virtual;
    function TextColor : TColor; virtual;
    procedure WndProc (var Message: TMessage); override;
  public
    FSkinIndex : integer;
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
    property Font;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property SkinSection : string read FSkinSection write SetSkinSection;
{$IFDEF TNTUNICODE}
    property Caption: TWideCaption read GetCaption write SetCaption stored IsCaptionStored;
    property Hint: WideString read GetHint write SetHint stored IsHintStored;
{$ELSE}
    property Caption;
{$ENDIF}
{$IFDEF D2005}
    property EllipsisPosition;
{$ENDIF}
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent default True;
{$IFDEF D2010}
    property Touch;
{$ENDIF}
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TsClassSkinData = record
    CustomColor : boolean;
    CustomFont : boolean;
  end;
{$ENDIF} // NOTFORHELP

  TsLabel = class(TsCustomLabel)
{$IFNDEF NOTFORHELP}
  private
    FUseSkinColor: boolean;
  protected
    function TextColor : TColor; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Font;
{$ENDIF} // NOTFORHELP
    property UseSkinColor : boolean read FUseSkinColor write FUseSkinColor default True;
  end;

{$IFNDEF ALITE}
  TsHTMLLabel = class(TsLabel)
  private
    function GetPlainCaption: acString;
  public
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
  published
    property PlainCaption : acString read GetPlainCaption;
  end;
{$ENDIF}

{$IFNDEF NOTFORHELP}
  TsEditLabel = class(TsLabel)
  public
    BoundLabel : TObject;
    constructor InternalCreate(AOwner: TComponent; BoundStruct : TObject);
    destructor Destroy; override;
  end;
{$ENDIF} // NOTFORHELP

  TsWebLabel = class(TsLabel)
{$IFNDEF NOTFORHELP}
  private
    FNormalFont: TFont;
    procedure SetHoverFont(const Value: TFont);
    procedure SetNormalFont(const Value: TFont);
  protected
    FHoverFont : TFont;
    FURL : string;
    FShowMode: TsWindowShowMode;
    function TextColor : TColor; override;
    function GetCurrentFont: TFont; override;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMEraseBkGnd(var Message: TWMLButtonDown); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
  public
    MouseAbove: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
  published
    property Font: TFont read FNormalFont write SetNormalFont;
    property Cursor default crHandPoint;
{$ENDIF} // NOTFORHELP
    property HoverFont: TFont read FHoverFont write SetHoverFont;
    property ShowMode : TsWindowShowMode read FShowMode write FShowMode default soDefault;
    property URL : string read FURL write FURL;
  end;

  TsKind = class(TPersistent)
{$IFNDEF NOTFORHELP}
  private
    FOwner : TControl;
    FKindType: TsKindType;
    FColor: TColor;
    constructor Create(AOwner: TControl);
    procedure SetKindType(const Value: TsKindType);
    procedure SetColor(const Value: TColor);
  public
    destructor Destroy; override;
  published
{$ENDIF} // NOTFORHELP
    property KindType : TsKindType read FKindType write SetKindType default ktSkin;
    property Color : TColor read FColor write SetColor default clWhite;
  end;

  TsLabelFX = class;

  TShadowData = record
    Color : TColor;
    Blur : integer;
    Offset : integer;
    Alpha : integer;
  end;

  TacOffsetKeeper = class(TPersistent)
  private
    FRightBottom: integer;
    FLeftTop: integer;
  published
    property LeftTop : integer read FLeftTop write FLeftTop stored True;
    property RightBottom : integer read FRightBottom write FRightBottom stored True;
  end;

  TsShadow = class(TPersistent)
{$IFNDEF NOTFORHELP}
  private
    FBuffered: Boolean;
    FBlurCount: Integer;
    FDistance: Integer;
    FColor: TColor;
    ParentControl : TsLabelFX;
    FMode: TsShadowMode;
    FAlphaValue: byte;
    FOffsetKeeper: TacOffsetKeeper;
    procedure SetBlurCount(const Value: Integer);
    procedure SetDistance(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetMode(const Value: TsShadowMode);
    procedure UpdateRGB;
    procedure SetAlphaValue(const Value: byte);
  public
    sr, sg, sb : Integer;
    constructor Create(AOwner: TComponent; Control : TsLabelFX);
    destructor Destroy; override;
    property ShadowBuffered : Boolean read FBuffered write FBuffered default False;
  published
{$ENDIF} // NOTFORHELP
    property AlphaValue : byte read FAlphaValue write SetAlphaValue default MaxByte;
    property BlurCount : Integer read FBlurCount write SetBlurCount default 4;
    property Color : TColor read FColor write SetColor default clBlack;
    property Distance : Integer read FDistance write SetDistance default 1;
    property Mode : TsShadowMode read FMode write SetMode default smSkin1;
    property OffsetKeeper : TacOffsetKeeper read FOffsetKeeper write FOffsetKeeper;
  end;

  // Used shading algorithm by Gennady Ermakovets (gen@godeltech.com)
  TsLabelFX = class(TsCustomLabel)
{$IFNDEF NOTFORHELP}
  private
    FMask : TBitmap;
    FMaskBits : Pointer;
    FMaskBitsSize : Integer;
    FShadow : TsShadow;
    FNeedInvalidate : Boolean;
    OffsTopLeft{, OffsRightBottom} : Integer;
    FKind: TsKind;

    IntPosChanging : boolean;
    FAngle: integer;

    procedure SetAngle(const Value: integer);
  public
    procedure AdjustBounds; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    procedure WndProc (var Message: TMessage); override;
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
    function CurrentShadowData : TShadowData;
    function CurrentFontColor : TColor;
    procedure UpdatePosition;

  published
    property Font;
{$ENDIF} // NOTFORHELP
    property Angle : integer read FAngle write SetAngle;
    property Kind : TsKind read FKind write FKind;
    property Shadow : TsShadow read FShadow write FShadow;
  end;

(* ///////////////////////////////////////////////////////////////////////
TsStickyLabel component was based on the TGMSStickyLabel control code

GMSStickyLabel v1.1 July/5/97        by Glenn Shukster & Jacques Scoatarin

  GMS COMPUTING INC.                 Phone         (905)771-6458
  53 COLVIN CRES.                    Fax                   -6819
  THORNHILL, ONT.                    Compuserve:       72734,123
  CANADA  L4J 2N7                    InternetId:Gms@Shaw.wave.ca
                                     http://members.tor.shaw.wave.ca/~gms/

  Jacques Scoatarin                  Phone (357)2-492591
  52 Athalassis Ave, (flat 202)      InternetId:j.scoatarin@cytanet.com.cy
  Nicosia, Cyprus
/////////////////////////////////////////////////////////////////////// *)
{$IFNDEF NOTFORHELP}
  TAlignTo = (altLeft, altTop, altBottom,  altRight);
{$ENDIF}
  TsStickyLabel = class(TsLabel)
{$IFNDEF NOTFORHELP}
  private
    FAttachTo: TControl;
    FAlignTo: TAlignTo;
    FGap : Integer;
    FOldWinProc: TWndMethod;
    FRealigning: Boolean;
    Procedure SetGap(Value: Integer);
    procedure SetAttachTo(Value: TControl);
    Procedure SetAlignTo(Value: TAlignTo);
    procedure NewWinProc(var Message: TMessage);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Adjust(MoveLabel: boolean);
  published
    property Font;
{$ENDIF} // NOTFORHELP
    property AlignTo: TAlignTo read FAlignTo write SetAlignTo default altLeft;
    property AttachTo: TControl read FAttachTo write SetAttachTo;
    Property Gap : Integer Read FGap write SetGap Default 2;
  end;

{$IFNDEF NOTFORHELP}
function GetParentCache(Control : TControl) : TCacheInfo;
{$ENDIF} // NOTFORHELP

implementation

uses ShellAPI, {$IFNDEF ALITE}sPageControl, {$ENDIF}sStyleSimply, {$IFDEF TNTUNICODE}TntWindows, {$ENDIF}
  sVCLUtils, sGraphUtils, acntUtils, sCommonData, math, sMaskData, sDefaults,
  sSkinManager{$IFNDEF ALITE}, sHtmlParse{$ENDIF};

var
  FontChanging : boolean;

function GetParentCache(Control : TControl) : TCacheInfo;
var
  ParentBG : TacBGInfo;
begin
  ParentBG.PleaseDraw := False;
  GetBGInfo(@ParentBG, Control.Parent);
  Result := BGInfoToCI(@ParentBG);
end;

{ TsCustomLabel }

constructor TsCustomLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Transparent := True;
end;

{$IFDEF TNTUNICODE}
procedure TsCustomLabel.DoDrawText(var Rect: TRect; Flags: Integer);
begin
  if (DefaultManager <> nil) and DefaultManager.SkinData.Active then begin
    Canvas.Font := Font;
    Canvas.Font.Color := TextColor;
  end;
  if not TntLabel_DoDrawText(Self, Rect, Flags, GetLabelText) then inherited;
end;
{$ELSE}
procedure TsCustomLabel.DoDrawText(var Rect: TRect; Flags: Integer);
var
  Text: string;
begin
  if (DefaultManager = nil) or not DefaultManager.SkinData.Active then inherited else begin
    Text := GetLabelText;
    if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
      (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
    if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
    Flags := DrawTextBiDiModeFlags(Flags);
    Canvas.Font := GetCurrentFont;
    Canvas.Font.Color := TextColor;
    DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end;
end;
{$ENDIF}

function TsCustomLabel.GetCurrentFont: TFont;
begin
  Result := inherited Font;
end;

{$IFDEF TNTUNICODE}
function TsCustomLabel.GetCaption: TWideCaption;
begin
  Result := TntControl_GetText(Self);
end;

function TsCustomLabel.IsCaptionStored: Boolean;
begin
  Result := TntControl_IsCaptionStored(Self)
end;

procedure TsCustomLabel.SetCaption(const Value: TWideCaption);
begin
  TntControl_SetText(Self, Value);
  AdjustBounds;
end;

function TsCustomLabel.GetHint: WideString;
begin
  Result := TntControl_GetHint(Self)
end;

function TsCustomLabel.IsHintStored: Boolean;
begin
  Result := TntControl_IsHintStored(Self)
end;

procedure TsCustomLabel.SetHint(const Value: WideString);
begin
  TntControl_SetHint(Self, Value);
end;

procedure TsCustomLabel.CMDialogChar(var Message: TCMDialogChar);
begin
  TntLabel_CMDialogChar(Self, Message, Caption);
end;

procedure TsCustomLabel.CMHintShow(var Message: TMessage);
begin
  ProcessCMHintShowMsg(Message);
  inherited;
end;

function TsCustomLabel.GetLabelText: WideString;
begin
  Result := Caption;
end;

{$ENDIF}

procedure TsCustomLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
begin
  FSkinIndex := -1;
  if not (csDestroying in ComponentState) then begin
    if not FontChanging then begin
      FontChanging := True;
      if (SkinSection <> '') and (DefaultManager <> nil) and DefaultManager.Active then begin
        FSkinIndex := DefaultManager.GetSkinIndex(SkinSection);
        if (FSkinIndex >= 0) and (Font.Color <> DefaultManager.gd[FSkinIndex].FontColor[1]) then Font.Color := DefaultManager.gd[FSkinIndex].FontColor[1];
      end;
      FontChanging := False;
    end;
    if FSkinIndex > 0 then PaintItem(FSkinIndex, SkinSection, GetParentCache(Self), True, 0, Rect(0, 0, Width, Height), Point(Left, Top), Canvas.Handle);
  end;
  inherited Paint;
  FSkinIndex := -1;
end;

var
  acLabelFontChanging : boolean = False;

procedure TsCustomLabel.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_FONTCHANGED : if not (csDestroying in ComponentState) and not (csLoading in ComponentState) and not acLabelFontChanging then begin
      if not FontChanging then begin
        acLabelFontChanging := True;
        if AutoSize then AdjustBounds;
        Invalidate;
        acLabelFontChanging := False;
      end;
      Exit
    end;
    CM_MOUSEENTER : if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
  end;
  inherited;
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_REMOVESKIN, AC_REFRESH : if (csDesigning in ComponentState) and not (csDestroying in ComponentState) then begin
      Invalidate;
    end;
  end
  else case Message.Msg of
    CM_MOUSELEAVE : if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
  end;
end;

procedure TsCustomLabel.SetSkinSection(const Value: string);
begin
  if FSkinSection <> Value then begin
    FSkinSection := Value;
    Repaint;
  end;
end;

function TsCustomLabel.TextColor: TColor;
begin
  if Enabled
    then Result := DefaultManager.Palette[pcLabelText]
    else Result := MixColors(ColorToRGB(Font.Color), GetControlColor(Parent), DefDisabledBlend);
end;

{ TsWebLabel }

procedure TsWebLabel.CMMouseEnter(var Message: TMessage);
var
  R : TRect;
begin
  inherited;
  if not Enabled then Exit;
  MouseAbove := True;
  if AutoSize then begin
    Invalidate;
    Update;
    AdjustBounds;
  end;
  R := BoundsRect;
  InvalidateRect(Parent.Handle, @R, True);
end;

procedure TsWebLabel.CMMouseLeave(var Message: TMessage);
var
  R : TRect;
begin
  inherited;
  if not Enabled then Exit;
  MouseAbove := False;
  if AutoSize then begin
    Invalidate;
    Update;
    AdjustBounds;
  end;
  R := BoundsRect;
  InvalidateRect(Parent.Handle, @R, True);
end;

procedure TsWebLabel.CMParentFontChanged(var Message: TMessage);
var
  c : TColor;
begin
  inherited;
  if ParentFont and Assigned(Parent) then begin
    C := FNormalFont.Color;
    FNormalFont.Assign(TsHackedControl(Parent).Font);
    FHoverFont.Name := Font.Name;
    FHoverFont.Size := Font.Size;
    FNormalFont.Color := C;
  end;
end;

constructor TsWebLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowMode := soDefault;

  FHoverFont := TFont.Create;
  FNormalFont := TFont.Create;
  Cursor := crHandPoint;
  ControlStyle := ControlStyle + [csOpaque];
  Transparent := True;
end;

destructor TsWebLabel.Destroy;
begin
  if Assigned(FHoverFont) then FreeAndNil(FHoverFont);
  if Assigned(FNormalFont) then FreeAndNil(FNormalFont);
  inherited Destroy;
end;

function TsWebLabel.GetCurrentFont: TFont;
begin
  if MouseAbove and not (csDesigning in ComponentState)
    then Result := FHoverFont
    else Result := FNormalFont;
end;

procedure TsWebLabel.Loaded;
begin
  inherited Loaded;
  inherited Font.Assign(FNormalFont);
end;

procedure TsWebLabel.SetHoverFont(const Value: TFont);
begin
  FHoverFont.Assign(Value);
end;

procedure TsWebLabel.SetNormalFont(const Value: TFont);
begin
  inherited Font.Assign(Value);
  FNormalFont.Assign(Value);
  Paint;
end;

function TsWebLabel.TextColor: TColor;
var
  DefManager : TsSkinManager;
  Ndx : integer;
begin
  DefManager := DefaultManager;
  if MouseAbove and not (csDesigning in ComponentState) then begin
    if UseSkinColor and (DefManager <> nil) and DefManager.Active then Result := DefManager.Palette[pcWebTextHot] else Result := FHoverFont.Color; // TCTop
  end
  else begin
    if not (csDestroying in ComponentState) and (DefManager <> nil) and DefManager.Active and UseSkinColor {$IFNDEF SKININDESIGN}and not ((csDesigning in ComponentState) and (GetOwnerFrame(Self) <> nil)){$ENDIF} then begin
      Ndx := GetFontIndex(Self, -1, DefManager);
      if Ndx < 0
        then Result := DefManager.Palette[pcWebText]
        else Result := DefManager.gd[Ndx].FontColor[1];
    end
    else Result := ColorToRGB(FNormalFont.Color);
  end;
end;

procedure TsWebLabel.WMEraseBkGnd(var Message: TWMLButtonDown);
begin
end;

procedure TsWebLabel.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if FURL <> '' then ShellExecute(Application.Handle, 'open', PChar(FURL), nil, nil, ord(FShowMode));
end;

{ TsEditLabel }

destructor TsEditLabel.Destroy;
begin
  TsBoundLabel(BoundLabel).FActive := False;
  inherited Destroy;
end;

constructor TsEditLabel.InternalCreate(AOwner: TComponent; BoundStruct: TObject);
begin
  inherited Create(AOwner);
  BoundLabel := BoundStruct;
end;

{ TsStickyLabel }

procedure TsStickyLabel.Adjust(MoveLabel: boolean);
var
  iNewTop, iNewLeft : Integer;
  MoveRelativeTo : TControl;
  Mover : TControl;
  Alignment : TAlignTo;
begin
  FRealigning := True;
  if FAttachTo <> nil then begin
    if MoveLabel then begin
      MoveRelativeTo := FAttachTo;
      Mover := Self;
      Alignment := FAlignTo;
    end
    else begin
      MoveRelativeTo := Self;
      Mover := FAttachTo;
      Alignment := altRight;
      case FAlignTo of
        altTop:    Alignment := altBottom;
        altRight:  Alignment := altLeft;
        altBottom: Alignment := altTop;
      end;
    end;

    Case Alignment of
       altLeft : begin
         iNewTop :=  MoveRelativeTo.Top + (MoveRelativeTo.Height - Mover.Height) div 2;
         iNewLeft := MoveRelativeTo.Left - Mover.Width - FGap;
       end;
       altRight : begin
         iNewTop :=  MoveRelativeTo.Top + (MoveRelativeTo.Height - Mover.Height) div 2;
         iNewLeft := MoveRelativeTo.Left + MoveRelativeTo.Width + FGap;
       end;
       altTop: begin
         iNewTop := MoveRelativeTo.Top - Mover.Height - FGap;
         iNewLeft := MoveRelativeTo.Left;
       end;
       else begin
         iNewTop := MoveRelativeTo.Top + MoveRelativeTo.Height + FGap;
         iNewLeft := MoveRelativeTo.Left;
       end;
    end;
    { Set all propertied in one call to avoid multiple re-drawing & pos changes }
    Mover.SetBounds(iNewLeft, iNewTop, Mover.Width, Mover.Height);
  end;
  FRealigning := False;
end;

constructor TsStickyLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGap := 2;
  FRealigning := False;
end;

destructor TsStickyLabel.Destroy;
begin
  SetAttachTo(nil);
  inherited Destroy;
end;

procedure TsStickyLabel.NewWinProc(var Message: TMessage);
begin
  if not (csDestroying in ComponentState) then begin
    if Assigned(FAttachTo) and (not FRealigning) then begin
      FRealigning := True;
      try
        case(Message.Msg) of
          CM_ENABLEDCHANGED : Enabled := FAttachTo.Enabled;
          CM_VISIBLECHANGED : Visible := FAttachTo.Visible;
          WM_SIZE, WM_MOVE, WM_WINDOWPOSCHANGED : Adjust(Message.Msg <> WM_SIZE);
        end;
      finally
        FRealigning := FALSE;
      end;
    end;
  end;
  if Assigned(FOldWinProc) then FOldWinProc(Message);
end;

procedure TsStickyLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FAttachTo) then SetAttachTo(nil);
  inherited Notification(AComponent, Operation);
end;

procedure TsStickyLabel.SetAlignTo(Value: TAlignTo);
begin
  if (FAlignTo <> Value) then begin
    FAlignTo := Value;
    Adjust(True);
  end;
end;

procedure TsStickyLabel.SetAttachTo(Value: TControl);
begin
  if(Value <> FAttachTo) then begin
    if (Assigned(FAttachTo)) then FAttachTo.WindowProc := FOldWinProc;
    FAttachTo := Value;
    if (Assigned(Value)) then begin
      Adjust(True);
      Enabled := FAttachTo.Enabled;
      Visible := FAttachTo.Visible;
      FOldWinProc := FAttachTo.WindowProc;
      FAttachTo.WindowProc := NewWinProc;
    end;
  end;
end;

procedure TsStickyLabel.SetGap(Value: Integer);
begin
  if (FGap <> Value) then begin
    FGap := Value;
    Adjust(True);
  end;
end;

procedure TsStickyLabel.WndProc(var Message: TMessage);
begin
  if not (csDestroying in ComponentState) and Assigned(FAttachTo) and not FRealigning then begin
    FRealigning := True;
    try
      if Message.Msg = WM_WINDOWPOSCHANGED then Adjust(False);
   finally
      FRealigning := False;
    end;
  end;
  inherited WndProc(Message);
end;

{ TsShadow }

constructor TsShadow.Create(AOwner: TComponent; Control : TsLabelFX);
begin
  FColor := clBlack;
  FBlurCount := 4;
  FDistance := 1;
  FMode := smSkin1;
  FAlphaValue := MaxByte;
  ParentControl := Control;
  FOffsetKeeper := TacOffsetKeeper.Create;
end;

destructor TsShadow.Destroy;
begin
  FreeAndNil(FOffsetKeeper);
  inherited;
end;

procedure TsShadow.SetBlurCount(const Value: Integer);
begin
  if FBlurCount <> Value then begin
    FBlurCount := Value;
    ParentControl.UpdatePosition;
    ParentControl.Invalidate;
  end;
end;

procedure TsShadow.SetDistance(const Value: Integer);
begin
  if FDistance <> Value then begin
    FDistance := Value;
    ParentControl.UpdatePosition;
    ParentControl.Invalidate;
  end;
end;

procedure TsShadow.SetColor(const Value: TColor);
begin
  if FColor <> Value then begin
    FColor := Value;
    UpdateRGB;
    ParentControl.Invalidate;
  end;
end;

procedure TsShadow.SetMode(const Value: TsShadowMode);
begin
  if FMode <> Value then begin
    FMode := Value;
    UpdateRGB;
    ParentControl.UpdatePosition;
    ParentControl.Invalidate;
  end;
end;

procedure TsShadow.UpdateRGB;
var
  rgb : Integer;
begin
  rgb := ColorToRGB(FColor);
  sr := rgb and MaxByte;
  sg := (rgb shr 8) and MaxByte;
  sb := (rgb shr 16) and MaxByte;
end;

procedure TsShadow.SetAlphaValue(const Value: byte);
begin
  if FAlphaValue <> Value then begin
    FAlphaValue := Value;
    ParentControl.Invalidate;
  end;
end;

{ TsLabelFX }
{
function AngledTextSize(DC: hdc; R: TRect; Text : acString; Flags : cardinal) : TSize;
begin
  acDrawText(DC, PacChar(Text), R, DT_CALCRECT);
  Result.cx := WidthOf(R);
  Result.cy := HeightOf(R);
end;
}
procedure TsLabelFX.AdjustBounds;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  DC: HDC;
  X, Y: Integer;
  AAlignment: TAlignment;
  Size, ActSize, OldSize : TSize;
  Text: acString;
  OffsTopLeft, OffsRightBottom : integer;
  rad, rcos, rsin : real;
  R : TRect;
begin
  if not (csReading in ComponentState) and not (csLoading in ComponentState) then begin

    AAlignment := Alignment;
    if UseRightToLeftAlignment then ChangeBiDiModeAlignment(AAlignment);

    with CurrentShadowData do begin
      OffsTopLeft := min(0, Offset - Blur);
      OffsRightBottom := Max(0, Offset + Blur);
    end;

    X := Left;
    Y := Top;

    if AutoSize then begin
      DC := GetDC(0);

      Text := GetLabelText;
      if ((Text = '') or ShowAccelChar and (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';

      SelectObject(DC, Font.Handle);

      R := Rect(0, 0, MaxInt, 0);
      acDrawText(DC, Text, R, (DT_EXPANDTABS or DT_CALCRECT or DT_NOPREFIX) or WordWraps[WordWrap]);
      Size.cx := WidthOf(R);
      Size.cy := HeightOf(R);


      if Angle <> 0 then begin
        rad := Pi * Angle / 180;
        rcos := cos(rad);
        rsin := sin(rad);

        ActSize.cx := Round(Size.cx * abs(rcos) + Size.cy * abs(rsin));
        ActSize.cy := Round(Size.cx * abs(rsin) + Size.cy * abs(rcos));

        Size.cx := ActSize.cx;
        Size.cy := ActSize.cy;
      end;

      ActSize := Size;
      ReleaseDC(0, DC);

      inc(Size.cx, - OffsTopLeft + OffsRightBottom);
      inc(Size.cy, - OffsTopLeft + OffsRightBottom);

      OldSize.cx := Width + Shadow.OffsetKeeper.LeftTop - Shadow.OffsetKeeper.RightBottom;
      OldSize.cy := Height + Shadow.OffsetKeeper.LeftTop - Shadow.OffsetKeeper.RightBottom;

      case AAlignment of
        taLeftJustify: begin
          X := X - Shadow.OffsetKeeper.LeftTop + OffsTopLeft;
        end;
        taCenter: begin
          X := X - (Shadow.OffsetKeeper.LeftTop - OffsTopLeft - Shadow.OffsetKeeper.RightBottom + OffsRightBottom) div 2;
        end;
        taRightJustify: begin
          X := X + 2 * (OffsTopLeft + Width - Shadow.OffsetKeeper.RightBottom) - OldSize.cx;
          X := X {+ OffsTopLeft + Width - Shadow.OffsetKeeper.RightBottom} - ActSize.cx;
         end;
      end;

      case Layout of
        tlTop : begin
          Y := Y - Shadow.OffsetKeeper.LeftTop + OffsTopLeft;
        end;
        tlCenter: begin
          Y := Y - (Shadow.OffsetKeeper.LeftTop - OffsTopLeft - Shadow.OffsetKeeper.RightBottom + OffsRightBottom) div 2;
        end;
        tlBottom : begin
          Y := Y + OffsTopLeft + Height - Shadow.OffsetKeeper.RightBottom - OldSize.cy;
        end;
      end;

//      X := X - Shadow.OffsetKeeper.LeftTop + OffsTopLeft;

//      if AAlignment = taRightJustify
//        then X := X + OffsTopLeft + Width - Shadow.OffsetKeeper.RightBottom - ActSize.cx;
      if Layout = tlBottom
        then Y := Y + OffsTopLeft + Height - Shadow.OffsetKeeper.RightBottom - ActSize.cy;
      SetBounds(X, Y, Size.cx, Size.cy);
    end
    else begin
      OldSize.cx := Width + Shadow.OffsetKeeper.LeftTop - Shadow.OffsetKeeper.RightBottom;
      OldSize.cy := Height + Shadow.OffsetKeeper.LeftTop - Shadow.OffsetKeeper.RightBottom;

      case AAlignment of
        taLeftJustify: begin
          X := X - Shadow.OffsetKeeper.LeftTop + OffsTopLeft;
        end;
        taCenter: begin
          X := X - (Shadow.OffsetKeeper.LeftTop - OffsTopLeft - Shadow.OffsetKeeper.RightBottom + OffsRightBottom) div 2;
        end;
        taRightJustify: begin
          X := X + OffsTopLeft + Width - Shadow.OffsetKeeper.RightBottom - OldSize.cx;
        end;
      end;

      case Layout of
        tlTop : begin
          Y := Y - Shadow.OffsetKeeper.LeftTop + OffsTopLeft;
        end;
        tlCenter: begin
          Y := Y - (Shadow.OffsetKeeper.LeftTop - OffsTopLeft - Shadow.OffsetKeeper.RightBottom + OffsRightBottom) div 2;
        end;
        tlBottom : begin
          Y := Y + OffsTopLeft + Height - Shadow.OffsetKeeper.RightBottom - OldSize.cy;
        end;
      end;

      inc(OldSize.cx, - OffsTopLeft + OffsRightBottom);
      inc(OldSize.cy, - OffsTopLeft + OffsRightBottom);

      SetBounds(X, Y, OldSize.cx, OldSize.cy);
    end;
//    Shadow.OffsetKeeper.RightBottom := OffsRightBottom;
//    Shadow.OffsetKeeper.LeftTop := Offs;
  end;
end;

constructor TsLabelFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinIndex := -1;
  FShadow := TsShadow.Create(AOwner, Self);
  FKind := TsKind.Create(Self);
  FMask := CreateBmp32(0, 0);
  FMaskBits := nil;
  IntPosChanging := False;
  FNeedInvalidate := True;
end;

function TsLabelFX.CurrentFontColor: TColor;
begin
  case FKind.KindType of
    ktStandard : Result := ColorToRGB(Color);
    ktCustom : Result := ColorToRGB(Kind.Color);
    ktSkin : begin
      if (DefaultManager <> nil) and DefaultManager.SkinData.Active then begin
        if SkinSection <> '' then FSkinIndex := DefaultManager.GetSkinIndex(Skinsection);
        if FSkinIndex = -1 then begin
          if (DefaultManager.ConstData.IndexGlobalInfo > -1) and
               (DefaultManager.ConstData.IndexGlobalInfo <= Length(DefaultManager.gd) - 1) and
                 (DefaultManager.gd[DefaultManager.ConstData.IndexGlobalInfo].FontColor[2] <> -1)
            then Result := ColorToRGB(DefaultManager.gd[DefaultManager.ConstData.IndexGlobalInfo].FontColor[2])
            else Result := ColorToRGB(Kind.Color)
        end;
      end
      else Result := ColorToRGB(Kind.Color);
    end;
  end;
end;

function TsLabelFX.CurrentShadowData: TShadowData;
begin
  case FShadow.Mode of
    smCustom : begin
      Result.Color := FShadow.Color;
      Result.Blur := FShadow.BlurCount;
      Result.Offset := FShadow.FDistance;
      Result.Alpha := FShadow.AlphaValue;
    end;
    smSkin1 : begin
      if (DefaultManager <> nil) and DefaultManager.Active and (DefaultManager.SkinData.Shadow1Blur <> -1) then begin
        Result.Color := DefaultManager.SkinData.Shadow1Color;
        Result.Blur := DefaultManager.SkinData.Shadow1Blur;
        Result.Offset := DefaultManager.SkinData.Shadow1Offset;
      end
      else begin
        Result.Color := FShadow.Color;
        Result.Blur := FShadow.BlurCount;
        Result.Offset := FShadow.FDistance;
      end;
      Result.Alpha := FShadow.AlphaValue;
    end
    else begin
      Result.Blur := 0;
      Result.Color := 0;
      Result.Offset := 0;
      Result.Alpha := 0;
    end;
  end;
end;

destructor TsLabelFX.Destroy;
begin
  FreeAndNil(FShadow);
  FreeAndNil(FMask);
  FreeAndNil(FKind);
  if FMaskBits <> nil then FreeMem(FMaskBits);
  inherited;
end;

procedure TsLabelFX.DoDrawText(var Rect: TRect; Flags: Integer);
const
  LB_BORDER = 3;
var
  Text: acString;
  x, y :Integer;
  i : Integer;
  aRect, DstRect : TRect;
  sP : TPoint;
  MaskOffs, pb : PByte;
  W, H, nW, nH : Integer;
  offs_North, offs_South, offs_West, offs_East : PByte;
  invert : byte;
  cr, cg, cb : Integer;
  ShadowData : TShadowData;
  rgb, OffsRightBottom : Integer;
  rad, rcos, rsin : real;
  Size : TSize;
  procedure AddMask;
  var
    y, x : Integer;
    MaskOffs, pb : PByte;
  begin // Fill mask
    MaskOffs := PByte(Integer(FMaskBits) + W + 1);
    for y := 0 to FMask.Height - 1 do begin
      pb := FMask.ScanLine[y];
      for x := 0 to FMask.Width - 1 do begin
        if pb^ <> 0 then MaskOffs^ := MaxByte;
        pb := PByte(Integer(pb) + 4);
        MaskOffs := PByte(Integer(MaskOffs) + 1);
      end;
      MaskOffs := PByte(Integer(MaskOffs) + 2);
    end;
  end;
begin
  if not (csLoading in ComponentState) and ((FShadow.Mode <> smNone) or (FSkinIndex >= 0)) then begin // If not standard kind
    aRect := Rect;
    ShadowData := CurrentShadowData;
    rgb := ColorToRGB(ShadowData.Color);
    Shadow.sr := rgb and MaxByte;
    Shadow.sg := (rgb shr 8) and MaxByte;
    Shadow.sb := (rgb shr 16) and MaxByte;
    // If orig. offset is not initialized yet
    OffsTopLeft := Min(0, ShadowData.Offset - ShadowData.Blur);
    OffsRightBottom := Max(0, ShadowData.Offset + ShadowData.Blur);

    Text := GetLabelText;
    if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
    Flags := DrawTextBiDiModeFlags(Flags) or DT_NOCLIP;
    if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
    if WordWrap
      then Flags := Flags or DT_WORDBREAK and not DT_SINGLELINE
      else Flags := Flags or DT_SINGLELINE;
    Canvas.Font.Assign(Font);
    Size := GetStringSize(Font.Handle, Text, Flags, WordWrap, WidthOf(aRect));

    if Angle <> 0 then begin
      MakeAngledFont(Canvas.Handle, Font, Angle * 10);
      rad := Pi * Angle / 180;
      rcos := cos(rad);
      rsin := sin(rad);

      nW := Round(Size.cx * abs(rcos) + Size.cy * abs(rsin));
      nH := Round(Size.cx * abs(rsin) + Size.cy * abs(rcos));

      sP.X := Round((Size.cx - Size.cx * rcos - Size.cy * rsin) / 2) + (nW - Size.cx) div 2;
      sP.Y := Round((Size.cy * (1 - rcos) + Size.cx * rsin) / 2) + (nH - Size.cy) div 2;
    end
    else begin
      nW := Size.cx;
      nH := Size.cy;
    end;

    case Alignment of
      taLeftJustify  : begin
        DstRect.Left := aRect.Left;
        DstRect.Left := DstRect.Left - min(0, ShadowData.Offset - ShadowData.Blur);
      end;
      taCenter : begin
        DstRect.Left := (aRect.Right - nW - OffsRightBottom - OffsTopLeft) div 2;
        DstRect.Left := DstRect.Left + ShadowData.Offset;
      end;
      taRightJustify : begin
        DstRect.Left := aRect.Right - nW - OffsRightBottom;
      end;
    end;
    DstRect.Right := DstRect.Left + nW;

    case Layout of
      tlTop : begin
        DstRect.Top := aRect.Top;
        DstRect.Top := DstRect.Top - min(0, ShadowData.Offset - ShadowData.Blur);
      end;
      tlCenter : begin
        DstRect.Top := (aRect.Bottom - nH - OffsRightBottom - OffsTopLeft) div 2;
        DstRect.Top := DstRect.Top + ShadowData.Offset;
      end;
      tlBottom : DstRect.Top := aRect.Bottom - nH - OffsRightBottom;
    end;
    DstRect.Bottom := DstRect.Top + nH;

    if not Enabled then begin
      OffsetRect(DstRect, 1, 1);
      SetTextColor(Canvas.Handle, ColorToRGB(clBtnHighlight));
      if Angle = 0
        then acDrawText(Canvas.Handle, PacChar(Text), DstRect, Flags)
        else ExtTextOut(Canvas.Handle, DstRect.Left + sP.X, DstRect.Top + sP.Y, 0, @DstRect, PAnsiChar(Text), Length(Text), 0);
      OffsetRect(DstRect, -1, -1);
      SetTextColor(Canvas.Handle, ColorToRGB(clBtnShadow));
      if Angle = 0
        then acDrawText(Canvas.Handle, PacChar(Text), DstRect, Flags)
        else ExtTextOut(Canvas.Handle, DstRect.Left + sP.X, DstRect.Top + sP.Y, 0, @DstRect, PAnsiChar(Text), Length(Text), 0);
    end
    else begin
      SetTextColor(Canvas.Handle, CurrentFontColor);
      if (Flags and DT_CALCRECT <> DT_CALCRECT) and (ShadowData.Color <> clNone) and (ShadowData.Blur <> 0) then begin
        if (FNeedInvalidate) or (not FShadow.FBuffered) then begin
          FMask.Width := WidthOf(Rect, True);
          FMask.Height := HeightOf(Rect, True);
          FMask.Canvas.Brush.Color := 0;
          FMask.Canvas.FillRect(Classes.Rect(0, 0, FMask.Width, FMask.Height));
          // Text props
          if Angle = 0 then begin
            FMask.Canvas.Font.Assign(Font);
            FMask.Canvas.Font.Color := clWhite;
          end
          else begin
            MakeAngledFont(FMask.Canvas.Handle, Font, Angle * 10);
            SetTextColor(FMask.Canvas.Handle, clWhite);
          end;
          // Draw text
          OffsetRect(DstRect, ShadowData.Offset, ShadowData.Offset);
          if Angle = 0
            then acDrawText(FMask.Canvas.Handle, PacChar(Text), DstRect, Flags)
            else ExtTextOut(FMask.Canvas.Handle, DstRect.Left + sP.X, DstRect.Top + sP.Y, 0, @DstRect, PacChar(Text), Length(Text), 0);

          W := FMask.Width + 2;
          H := FMask.Height + 2;
          if FMaskBitsSize < W * H * 2 then begin
            FMaskBitsSize := W * H * 2;
            ReallocMem(FMaskBits, FMaskBitsSize);
          end;
          FillChar(PChar(FMaskBits)^, W * H * 2, 0);    
          //Blur Mask
          for i := 1 to ShadowData.Blur do begin
            MaskOffs := PByte(Integer(FMaskBits) + W + 1);

            AddMask;
            offs_North := PByte(Integer(MaskOffs) - W);
            offs_South := PByte(Integer(MaskOffs) + W);
            offs_West  := PByte(Integer(MaskOffs) - 1);
            offs_East  := PByte(Integer(MaskOffs) + 1);

            for y := 0 to H - 3 do begin
              for x := 0 to W - 3 do begin
                MaskOffs^ := (offs_North^ + offs_South^ + offs_West^ + offs_East^) shr 2;
                MaskOffs := PByte(Integer(MaskOffs) + 1);
                offs_North := PByte(Integer(offs_North) + 1);
                offs_South := PByte(Integer(offs_South) + 1);
                offs_West := PByte(Integer(offs_West) + 1);
                offs_East := PByte(Integer(offs_East) + 1);
              end;
              MaskOffs := PByte(Integer(MaskOffs) + 2);
              offs_North := PByte(Integer(offs_North) + 2);
              offs_South := PByte(Integer(offs_South) + 2);
              offs_West := PByte(Integer(offs_West) + 2);
              offs_East := PByte(Integer(offs_East) + 2);
            end;       
          end;

          MaskOffs := PByte(Integer(FMaskBits) + FMask.Width + 3);

          if Transparent then begin
            // GetBackground
            BitBlt(FMask.Canvas.Handle, 0, 0, FMask.Width, FMask.Height, Canvas.Handle, 0, 0, SRCCOPY);
            // setAlpha
            for y := 0 to FMask.Height - 1  do begin
              pb := FMask.ScanLine[y];
              for x := 0 to FMask.Width - 1 do begin
                MaskOffs^ := MaskOffs^ * ShadowData.Alpha shr 8;
                invert := not MaskOffs^;
                pb^ := (pb^ * invert + FShadow.sb * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 1);
                pb^ := (pb^ * invert + FShadow.sg * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 1);
                pb^ := (pb^ * invert + FShadow.sr * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 2);
                MaskOffs := PByte(Integer(MaskOffs) + 1);
              end;
              MaskOffs := PByte(Integer(MaskOffs) + 2);
            end;
          end
          else begin
            // SetAlpha
            i := ColorToRGB(Color);

            cr := i and MaxByte;
            cg := (i shr 8) and MaxByte;
            cb := (i shr 16) and MaxByte;

            for y := 0 to FMask.Height - 1  do begin
              pb := FMask.ScanLine[y];
              for x := 0 to FMask.Width - 1 do begin
                MaskOffs^ := MaskOffs^ * ShadowData.Alpha shr 8;
                invert := not MaskOffs^;
                pb^ := (cb * invert + FShadow.sb * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 1);
                pb^ := (cg * invert + FShadow.sg * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 1);
                pb^ := (cr * invert + FShadow.sr * MaskOffs^) shr 8;
                pb := PByte(Integer(pb) + 2);
                MaskOffs := PByte(Integer(MaskOffs) + 1);
              end;
              MaskOffs := PByte(Integer(MaskOffs) + 2);
            end;
          end;
          FNeedInvalidate := False;
        end; // Need Invalidate

        BitBlt(Canvas.Handle, 0, 0, FMask.Width, FMask.Height, FMask.Canvas.Handle, 0, 0, SRCCOPY);
        OffsetRect(DstRect, -ShadowData.Offset, -ShadowData.Offset);

//        FillDC(Canvas.Handle, DstRect, clNavy);//clYellow);
        if Angle = 0
          then acDrawText(Canvas.Handle, PacChar(Text), DstRect, Flags)
          else ExtTextOut(Canvas.Handle, DstRect.Left + sP.X, DstRect.Top + sP.Y, 0, @DstRect, PacChar(Text), Length(Text), 0);
      end
      else begin
//        FillDC(Canvas.Handle, DstRect, clNavy);//clYellow);
        acDrawText(Canvas.Handle, PacChar(Text), DstRect, Flags); // Calc size of text
      end;
      if (Flags and DT_CALCRECT = DT_CALCRECT) and (ShadowData.Color <> clNone) and (ShadowData.Blur <> 0) then begin
        inc(aRect.Right, OffsRightBottom - OffsTopLeft);
        inc(aRect.Bottom, OffsRightBottom - OffsTopLeft);
      end;
    end;
  end
  else inherited;
end;

procedure TsLabelFX.Invalidate;
begin
  if WordWrap and (Angle <> 0) then Angle := 0;
  inherited;
end;

procedure TsLabelFX.SetAngle(const Value: integer);
begin
  if FAngle <> Value then begin
    FAngle := Value;
    if (Value <> 0) and WordWrap then WordWrap := False;
    if AutoSize then AdjustBounds else Invalidate;
  end;
end;

procedure TsLabelFX.UpdatePosition;
var
  CurrentOffset1, CurrentOffset2 : integer;
begin
  if (csLoading in ComponentState) then Exit;
  with CurrentShadowData do begin
    CurrentOffset1 := min(0, CurrentShadowData.Offset - CurrentShadowData.Blur);
    CurrentOffset2 := max(0, Offset + Blur);
  end;
  if (CurrentOffset1 <> Shadow.OffsetKeeper.LeftTop) or (CurrentOffset2 <> Shadow.OffsetKeeper.RightBottom) then begin
    IntPosChanging := True;
    AdjustBounds;
    Shadow.OffsetKeeper.LeftTop := CurrentOffset1;
    Shadow.OffsetKeeper.RightBottom := CurrentOffset2;
    IntPosChanging := False;
  end;
end;

procedure TsLabelFX.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  inherited;
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_REMOVESKIN, AC_SETNEWSKIN : if not (csDestroying in ComponentState) then begin
      UpdatePosition;
    end;
  end
  else
  case Message.Msg of
    WM_WINDOWPOSCHANGED, WM_SIZE, WM_MOVE : begin
      if (FShadow <> nil) and not IntPosChanging then
        with CurrentShadowData do begin
          Shadow.OffsetKeeper.LeftTop := min(0, Offset - Blur);
          Shadow.OffsetKeeper.RightBottom := Max(0, Offset + Blur);
        end;
    end;
  end;
end;

{ TsKind }

constructor TsKind.Create(AOwner: TControl);
begin
  FKindType := ktSkin;
  FColor := clWhite;
  FOwner := AOwner
end;

destructor TsKind.Destroy;
begin
  inherited;
end;

procedure TsKind.SetColor(const Value: TColor);
begin
  if FColor <> Value then begin
    FColor := Value;
    FOwner.Invalidate
  end
end;

procedure TsKind.SetKindType(const Value: TsKindType);
begin
  if FKindType <> Value then begin
    FKindType := Value;
    FOwner.Invalidate
  end
end;

{ TsLabel }

constructor TsLabel.Create(AOwner: TComponent);
begin
  inherited;
  FUseSkinColor := True;
end;

function TsLabel.TextColor: TColor;
var
  Ndx : integer;
begin
  if FUseSkinColor and (DefaultManager <> nil) and DefaultManager.SkinData.Active then begin
    if Enabled then begin
      if SkinSection <> '' then begin
        Ndx := DefaultManager.GetSkinIndex(SkinSection);
      end
      else Ndx := -1;                                          
      Ndx := GetFontIndex(Self, Ndx, DefaultManager);
      if Ndx < 0 then Result := DefaultManager.Palette[pcLabelText] else Result := DefaultManager.gd[Ndx].FontColor[1];
    end
    else Result := MixColors(ColorToRGB(Font.Color), GetControlColor(Parent), DefDisabledBlend);
  end
  else Result := Font.Color;
end;

{$IFNDEF ALITE}
{ TsHTMLLabel }

procedure TsHTMLLabel.DoDrawText(var Rect: TRect; Flags: Integer);
var
  Html: TsHtml;
  R: TRect;
  Bmp: TBitmap;
begin
  if Caption <> '' then begin
    Html := TsHtml.Create;
    R := Rect;
    Bmp := TBitmap.Create;
    Bmp.Height := Height;
    Bmp.Width := Width;
    Bmp.Canvas.Font.Assign(Font);
    Bmp.Canvas.Brush.Style := bsClear;
    Bmp.Canvas.Font.Color := TextColor;
    try
      if (Flags and DT_CALCRECT <> 0) then begin
        HTML.Init(Bmp, Caption, Classes.Rect(0, 0, 0, 0));
        Rect := HTML.HTMLText(True);
      end
      else begin
        HTML.Init(Bmp, Caption, R);
        BitBlt(Bmp.Canvas.Handle, 0, 0, Width, Height, Canvas.Handle, 0, 0, SRCCOPY);
        R := HTML.HTMLText;
        BitBlt(Canvas.Handle, 0, 0, Width, Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
      end;
    finally
      Bmp.Free;
      Html.Free;
    end;
  end;
end;

function TsHTMLLabel.GetPlainCaption: acString;
var
  TagStart, TagEnd, TagLength: integer;
begin
  Result := Caption;
  TagStart := Pos( '<', Result);
  while (TagStart > 0) and (TagStart < Length(Result)) do begin
    TagEnd := Pos('>', Result);
    if TagEnd = 0 then Exit;
    TagLength := TagEnd - TagStart + 1;
    Delete(Result, TagStart, TagLength);
    TagStart := Pos( '<', Result);
  end;
end;

{$ENDIF}

end.
