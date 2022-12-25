unit sSplitter;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs{$IFNDEF DELPHI5}, Types{$ENDIF},
  sCommonData, Extctrls{$IFDEF LOGGED}, sDebugMsgs{$ENDIF};

type

  TsSplitter = class(TSplitter)
{$IFNDEF NOTFORHELP}
  private
    FCommonData: TsCommonData;
    FSizing: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FGlyph: TBitmap;
    FShowGrip: boolean;
    procedure SetGlyph(const Value: TBitmap);
    procedure SetShowGrip(const Value: boolean);
  protected
    procedure Paint; override;
    procedure WndProc (var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Loaded; override;
  published
    property Enabled;
    property Color;
    property Glyph : TBitmap read FGlyph write SetGlyph;
    property ParentColor;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property ShowGrip : boolean read FShowGrip write SetShowGrip default False;
    property Visible;
    property Width default 6;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseEnter : TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp;
    property OnResize;
{$ENDIF} // NOTFORHELP
    property SkinData : TsCommonData read FCommonData write FCommonData;
  end;

implementation

uses sConst, sVclUtils, sMaskData, sMessages, sStyleSimply, sGraphUtils, acntUtils, sSKinManager, sSkinProps, sAlphaGraph;

const
  DefGripHeight = 4;
  DefGripWidth = 21;

{ TsSplitter }

procedure TsSplitter.AfterConstruction;
begin
  inherited;
  SkinData.Loaded;
end;

constructor TsSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommonData := TsCommonData.Create(Self, False);
  FCommonData.COC := COC_TsSplitter;
  FGlyph := TBitmap.Create;

  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csOpaque, csDoubleClicks];
  Width := 6;
  FSizing := False;
  FShowGrip := False;
end;

destructor TsSplitter.Destroy;
begin
  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  if Assigned(FGlyph) then FreeAndNil(FGlyph);
  inherited Destroy;
end;

procedure TsSplitter.Loaded;
begin
  inherited Loaded;
  SkinData.Loaded;
end;

procedure TsSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : integer;
begin
  if not ShowHintStored then begin
    AppShowHint := Application.ShowHint;
    Application.ShowHint := False;
    ShowHintStored := True;
  end;
  if AutoSnap and (Parent <> nil) then begin // Hack for standard bug with Realign procedure removing
    for i := 0 to Parent.ControlCount - 1 do begin
      case Align of
        alLeft : if Parent.Controls[i].Width = 0 then Parent.Controls[i].Left := Left;
        alTop : if Parent.Controls[i].Height = 0 then Parent.Controls[i].Top := Top;
      end;
    end;
  end;
  inherited;
  FSizing := True;
  if (ResizeStyle = rsUpdate) then Repaint;
end;

procedure TsSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FSizing := False;
  if (ResizeStyle = rsUpdate) then Repaint;
  Application.ShowHint := AppShowHint;
  ShowHintStored := False;
end;

procedure TsSplitter.Paint;
const
  XorColor = $00FFD8CE;
var
  R: TRect;
  State, Ndx : integer;
  ParentBG : TacBGInfo;
  TmpBmp : TBitmap;
  GripPos : TPoint;
  procedure FillGripColor(Canvas : TCanvas; R : TRect; ColorLight, ColorDark : TColor);
  var
    x, y : integer;
  begin
    y := R.Top;
    while y < R.Bottom do begin
      x := R.Left;
      while x < R.Right do begin
        Canvas.Pixels[x, y] := ColorLight;
        Canvas.Pixels[x + 1, y + 1] := ColorDark;
        inc(x, 2);
      end;
      inc(y, 2);
    end;
  end;
begin
  if not FCommonData.Skinned then begin
    inherited;
    if not FGlyph.Empty then begin
      R.Top := (Height - FGlyph.Height) div 2;
      R.Left := (Width - FGlyph.Width) div 2;

      if FGlyph.PixelFormat = pf32bit then begin
        TmpBmp := CreateBmp32(FGlyph.Width, FGlyph.Height);
        BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, Canvas.Handle, R.Left, R.Top, SRCCOPY);

        CopyByMask(Rect(0, 0, FGlyph.Width, FGlyph.Height),
                   Rect(0, 0, FGlyph.Width, FGlyph.Height), TmpBmp, FGlyph, EmptyCI, False);

        BitBlt(Canvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(TmpBmp);
      end
      else begin
        FGlyph.Transparent := True;
        Canvas.Draw(R.Left, R.Top, FGlyph);
      end;
    end
    else if FShowGrip then begin // Grip paint
      case Align of
        alLeft, alRight : begin
          GripPos.X := (Width - DefGripHeight) div 2;
          GripPos.Y := (Height - DefGripWidth) div 2;
          FillGripColor(Canvas, Rect(GripPos.X, GripPos.Y, GripPos.X + DefGripHeight, GripPos.Y + DefGripWidth), clWhite, clBlack);
        end
        else begin
          GripPos.X := (Width - DefGripWidth) div 2;
          GripPos.Y := (Height - DefGripHeight) div 2;
          FillGripColor(Canvas, Rect(GripPos.X, GripPos.Y, GripPos.X + DefGripWidth, GripPos.Y + DefGripHeight), clWhite, clBlack);
        end;
      end;
    end;
  end
  else begin
    R := ClientRect;
    InitCacheBmp(SkinData);
    State := integer(ControlIsActive(FCommonData));
    if FSizing and (ResizeStyle = rsUpdate) then State := 2;
    ParentBG.PleaseDraw := False;
    GetBGInfo(@ParentBG, Parent);
    PaintItem(FCommonData, BGInfoToCI(@ParentBG), True, State, R, Point(Left, Top), FCommonData.FCacheBmp, True);

    if not FGlyph.Empty then begin
      R.Top := (Height - FGlyph.Height) div 2;
      R.Left := (Width - FGlyph.Width) div 2;

      if FGlyph.PixelFormat = pf32bit then begin
        CopyByMask(Rect(R.Left, R.Top, R.Left + FGlyph.Width, R.Top + FGlyph.Height),
                   Rect(0, 0, FGlyph.Width, FGlyph.Height), FCommonData.FCacheBmp, FGlyph, EmptyCI, False);
      end
      else begin
        FGlyph.Transparent := True;
        FCommonData.FCacheBmp.Canvas.Draw(R.Left, R.Top, FGlyph);
      end;
    end
    else if FShowGrip then begin // Grip paint
      case Align of
        alLeft, alRight : begin
          Ndx := SkinData.SkinManager.ConstData.GripVertical;
        end
        else begin
          Ndx := SkinData.SkinManager.ConstData.GripHorizontal;
        end;
      end;
      if Ndx >= 0 then begin
        GripPos.X := (Width - WidthOfImage(SkinData.SkinManager.ma[Ndx])) div 2;
        GripPos.Y := (Height - HeightOfImage(SkinData.SkinManager.ma[Ndx])) div 2;
        DrawSkinGlyph(FCommonData.FCacheBmp, GripPos, State, 1, FCommonData.SkinManager.ma[Ndx], MakeCacheInfo(FCommonData.FCacheBmp));
      end
      else begin
        case Align of
          alLeft, alRight : begin
            GripPos.X := (Width - DefGripHeight) div 2;
            GripPos.Y := (Height - DefGripWidth) div 2;
            FillGripColor(FCommonData.FCacheBmp.Canvas, Rect(GripPos.X, GripPos.Y, GripPos.X + DefGripHeight, GripPos.Y + DefGripWidth), clWhite, clBlack);
          end
          else begin
            GripPos.X := (Width - DefGripWidth) div 2;
            GripPos.Y := (Height - DefGripHeight) div 2;
            FillGripColor(FCommonData.FCacheBmp.Canvas, Rect(GripPos.X, GripPos.Y, GripPos.X + DefGripWidth, GripPos.Y + DefGripHeight), clWhite, clBlack);
          end;
        end;
      end;
    end;


    BitBlt(Canvas.Handle, 0, 0, Width, Height, FCommonData.FCacheBmp.Canvas.Handle, 0,0, SRCCOPY);
    if Assigned(FCommonData.FCacheBmp) then FreeAndNil(FCommonData.FCacheBmp);

    if csDesigning in ComponentState then with Canvas do begin
      Pen.Style := psDot;
      Pen.Mode := pmXor;
      Pen.Color := XorColor;
      Brush.Style := bsClear;
      Rectangle(0, 0, ClientWidth, ClientHeight);
    end;
    if Assigned(OnPaint) then OnPaint(Self);
  end;
end;

procedure TsSplitter.SetGlyph(const Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Repaint;
end;

procedure TsSplitter.SetShowGrip(const Value: boolean);
begin
  FShowGrip := Value;
  Repaint;
end;

procedure TsSplitter.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_CTRLHANDLED : begin Message.Result := 1; Exit end; // AlphaSkins supported
    AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
    AC_SETNEWSKIN : if (ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager)) then begin
      CommonWndProc(Message, FCommonData);
      exit
    end;
    AC_REMOVESKIN : if ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager) then begin
      CommonWndProc(Message, FCommonData);
      Repaint;
      exit
    end;
    AC_REFRESH : if (ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager)) then begin
      CommonWndProc(Message, FCommonData);
      Repaint;
      exit
    end
  end;
  if not ControlIsReady(Self) or not FCommonData.Skinned then begin
    case Message.Msg of
      CM_MOUSEENTER : if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
    end;
    inherited;
    case Message.Msg of
      CM_MOUSELEAVE : if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
    end;
  end
  else begin
    if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
      AC_ENDPARENTUPDATE : if FCommonData.Updating then begin
        FCommonData.Updating := False;
        Perform(WM_PAINT, 0, 0);
        Exit
      end;
    end
    else
    case Message.Msg of
      WM_NCPAINT, WM_ERASEBKGND : begin
        Message.Result := 1;
        Exit;
      end;
      CM_VISIBLECHANGED, WM_SIZE, CM_ENABLEDCHANGED, WM_MOUSEWHEEL, WM_MOVE : FCommonData.BGChanged := True;
      CM_MOUSEENTER : if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
    end;
    CommonWndProc(Message, FCommonData);
    inherited;
    case Message.Msg of
      WM_SETFOCUS, CM_ENTER, WM_KILLFOCUS, CM_EXIT: begin
        FCommonData.FFocused := (Message.Msg = CM_ENTER) or (Message.Msg = WM_SETFOCUS);
        FCommonData.FMouseAbove := False;
        FCommonData.BGChanged := True;
        Repaint;
      end;
      CM_MOUSELEAVE, CM_MOUSEENTER : begin
        if not FCommonData.FFocused and not(csDesigning in ComponentState) then begin
          FCommonData.FMouseAbove := Message.Msg = CM_MOUSEENTER;
          FCommonData.BGChanged := True;
          Repaint;
        end;
        if (CM_MOUSELEAVE = Message.Msg) and Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
      end;
    end;
  end;
end;

end.
