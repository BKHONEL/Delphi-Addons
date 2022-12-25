unit acWB;
{$I sDefs.inc}

interface

uses Windows, Messages, sCommonData, SysUtils, Controls, Graphics, Classes, ExtCtrls, acSBUtils, sScrollBar, sSkinManager, sPanel,
  sSkinProps, SHDocVw, MSHTML, Activex;

type
  TacWBWnd = class;
  TacWBScrollBar = class;

  TacWBContainer = class(TsPanel)
  public
    WB : TWebBrowser;
    WBWnd : TacWBWnd;
    VScrollBar : TacWBScrollBar;
    HScrollBar : TacWBScrollBar;
    SkinSection : string;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Invalidate; override;
    procedure UpdateScrollsWB(SizeChanged : boolean = True);
    procedure UpdateRgn;
  end;

  TacWBScrollBar = class(TsScrollBar)
  public
    Container : TacWBContainer;
    destructor Destroy; override;
  end;

  TacWBWnd = class(TacMainWnd)
  public
    WB : TWebBrowser;
    Container : TacWBContainer;
    bLoading : boolean;

    constructor Create(AHandle : hwnd; ASkinData : TsCommonData; ASkinManager : TsSkinManager; const SkinSection : string; Repaint : boolean = True); override;
    destructor Destroy; override;
    function ScrollPos(Vert : boolean) : integer;
    procedure acWndProc(var Message: TMessage); override;

{$IFNDEF DELPHI_XE2}
    procedure DoBeforeNavigate2(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure DoNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure DoDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
{$ELSE}
    procedure DoBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant; const Flags: OleVariant; const TargetFrameName: OleVariant;
                                 const PostData: OleVariant; const Headers: OleVariant; var Cancel: WordBool);
    procedure DoNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure DoDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
{$ENDIF}
    procedure DoCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
    procedure DoScrollV(Sender: TObject);
    procedure DoScrollH(Sender: TObject);
  end;

implementation

uses sMessages, Forms;

{ TacWBWnd }

const
  bWidth = 2;

procedure TacWBWnd.acWndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
  inherited acWndProc(Message);
  case Message.Msg of
    WM_WINDOWPOSCHANGING, WM_WINDOWPOSCHANGED, WM_SIZE : if Assigned(Container) and IsWindowVisible(CtrlHandle) then begin
      if not Container.VScrollBar.DrawingForbidden {If not locked} then Container.UpdateScrollsWB(True);
    end;
    CM_VISIBLECHANGED : begin
      Container.Visible := WB.Visible;
    end;
  end;
end;

constructor TacWBWnd.Create(AHandle: hwnd; ASkinData: TsCommonData; ASkinManager: TsSkinManager; const SkinSection: string; Repaint: boolean);
begin
  inherited;
  bLoading := False;
  if SkinData.FOwnerControl <> nil then begin
    WB := TWebBrowser(SkinData.FOwnerControl);
    WB.OnBeforeNavigate2 := DoBeforeNavigate2;
    WB.OnCommandStateChange := DoCommandStateChange;
    WB.OnNavigateComplete2 := DoNavigateComplete2;
    WB.OnDocumentComplete := DoDocumentComplete;

    Container := TacWBContainer.Create(nil);
    Container.SkinSection := SkinData.SkinSection;
    Container.Tag := 5;
    Container.WB := WB;
    Container.WBWnd := Self;
    Container.Name := SkinData.FOwnerControl.Name + 'Cntnr';
    Container.Caption := '';
    Container.VScrollBar.OnChange := DoScrollV;
    Container.HScrollBar.OnChange := DoScrollH;
    Container.UpdateScrollsWB(True);
  end
  else begin
    Container := nil;                                
    WB := nil;
  end;
end;

destructor TacWBWnd.Destroy;
begin
  if Container <> nil then FreeAndNil(Container);
  WB.OnBeforeNavigate2 := nil;
  WB.OnCommandStateChange := nil;
  WB.OnNavigateComplete2 := nil;
  WB.OnDocumentComplete := nil;
  inherited;
end;

procedure TacWBWnd.DoBeforeNavigate2;
begin
  bLoading := True;
  Container.UpdateScrollsWB(True);
end;

procedure TacWBWnd.DoCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
//var
//  VPos, HPos : integer;
begin
//  if Enable // Command <> -1 then
//  Container.UpdateScrollsWB(True);

{  if (WB.Document <> nil) and (IHtmldocument2(WB.Document).Body <> nil) then begin
    if Variant(WB.Document).DocumentElement.scrollTop = 0
      then VPos := IHtmldocument2(WB.Document).Body.getAttribute('ScrollTop', 0)
      else VPos := Variant(WB.Document).DocumentElement.scrollTop;
    if Variant(WB.Document).DocumentElement.scrollLeft = 0
      then HPos := IHtmldocument2(WB.Document).Body.getAttribute('ScrollLeft', 0)
      else HPos := Variant(WB.Document).DocumentElement.scrollLeft;
  end;
}
  Container.UpdateScrollsWB(True);
{
  if Assigned(FOnNewCommandStateChange)
  then
    FOnNewCommandStateChange(Sender, Command, Enable);
}
end;

procedure TacWBWnd.DoDocumentComplete;
begin
  bLoading := False;
  Container.UpdateScrollsWB(True);
end;

procedure TacWBWnd.DoNavigateComplete2;
begin
//  bLoading := False;
  Container.UpdateScrollsWB(True);
end;

procedure TacWBWnd.DoScrollH(Sender: TObject);
begin
  if WB.Document <> nil then IHTMLWindow2(IHTMLDocument2(WB.Document).ParentWindow).Scroll(Container.HScrollBar.Position, Container.VScrollBar.Position);
end;

procedure TacWBWnd.DoScrollV(Sender: TObject);
begin
  if Self.WB.Document <> nil then IHTMLWindow2(IHTMLDocument2(WB.Document).ParentWindow).Scroll(Container.HScrollBar.Position, Container.VScrollBar.Position);
end;

function TacWBWnd.ScrollPos(Vert: boolean): integer;
begin
  if (WB.Document <> nil) and (IHtmldocument2(WB.Document).Body <> nil) then begin
    if Vert then begin
      if Variant(WB.Document).DocumentElement.scrollTop = 0
        then Result := IHtmldocument2(WB.Document).Body.getAttribute('ScrollTop', 0)
        else Result := Variant(WB.Document).DocumentElement.scrollTop;
    end
    else begin
      if Variant(WB.Document).DocumentElement.scrollLeft = 0
        then Result := IHtmldocument2(WB.Document).Body.getAttribute('ScrollLeft', 0)
        else Result := Variant(WB.Document).DocumentElement.scrollLeft;
    end;
  end
  else Result := 0;
end;

{ TacWBContainer }

procedure TacWBContainer.WndProc(var Message: TMessage);
begin
  inherited;
  if Message.Msg = SM_ALPHACMD then
  case Message.WParamHi of
    AC_REFRESH : begin
      UpdateScrollsWB(True);
    end;
  end;
end;

constructor TacWBContainer.Create(AOwner: TComponent);
begin
  inherited;
  VScrollBar := TacWBScrollBar.Create(nil);
  VScrollBar.Kind := sbVertical;
  VScrollBar.Parent := Self;
  VScrollBar.Container := Self;
//  VScrollBar.LinkedControl := Self;

  HScrollBar := TacWBScrollBar.Create(nil);
  HScrollBar.Visible := False;
  HScrollBar.Parent := Self;
  HScrollBar.Container := Self;
//  HScrollBar.LinkedControl := Self;
end;

destructor TacWBContainer.Destroy;
begin
  if VScrollBar <> nil then begin
    VScrollBar.OnChange := nil;
    VScrollBar.Free;
  end;
  if HScrollBar <> nil then begin
    HScrollBar.OnChange := nil;
    HScrollBar.Free;
  end;
  WBWnd.Container := nil;
  inherited;
end;

procedure TacWBContainer.Invalidate;
begin
  if (SkinData <> nil) and (SkinData.SkinSection <> SkinSection) then SkinData.SkinSection := SkinSection;
  inherited;
end;

procedure TacWBContainer.UpdateRgn;
var
  Rgn, SubRgn : hrgn;
begin
  Rgn := CreateRectRgn(0, 0, Width, Height);
  SubRgn := CreateRectRgn(bWidth, bWidth, Width - integer(VScrollBar.Visible) * VScrollBar.Width - bWidth, Height - integer(HScrollBar.Visible) * HScrollBar.Height - bWidth);
  CombineRgn(Rgn, Rgn, SubRgn, RGN_DIFF);
  DeleteObject(SubRgn);
  SetWindowRgn(Handle, Rgn, False); // True - repainting is required
end;

procedure TacWBContainer.UpdateScrollsWB;
var
  bVisibleH, bVisibleV : boolean;
  siH, siV : TScrollInfo;
  s : string;
begin
  if not WBWnd.bLoading and Assigned(WB.Document) and (IHtmldocument2(WB.Document).Body <> nil) and not VScrollBar.DrawingForbidden then begin
    // Lock scrolls
    VScrollBar.DrawingForbidden := True;
    HScrollBar.DrawingForbidden := True;
    // Preventing of the "out of range" error
    VScrollBar.LargeChange := 1;
    HScrollBar.LargeChange := 1;
    VScrollBar.PageSize := 1;
    HScrollBar.PageSize := 1;


    // Scrolls data receiving
    siV.nMax := WB.OleObject.Document.Body.ScrollHeight;
    siH.nMax := WB.OleObject.Document.Body.ScrollWidth;

    
    if (siH.nMax > WB.Width - GetSystemMetrics(SM_CXHTHUMB)) and (siH.nMax > 0) and (siH.nMax <> WB.Width)
      then siV.nPage := WB.Height - GetSystemMetrics(SM_CYVTHUMB)
      else siV.nPage := WB.Height;
      
    if siV.nPage <= 0 then Exit;
    siV.nPos := WBWnd.ScrollPos(True);
    if siV.nPos >= siV.nMax then Exit;
    VScrollBar.SetParams(siV.nPos, 0, siV.nMax);
    VScrollBar.PageSize := siV.nPage;
    VScrollBar.LargeChange := siV.nPage;

    siH.nPage := WB.Width - GetSystemMetrics(SM_CXHTHUMB);
    siH.nPos := WBWnd.ScrollPos(False);
    HScrollBar.SetParams(siH.nPos, 0, siH.nMax);
    if siH.nPage <= 0 then Exit;
    HScrollBar.PageSize := siH.nPage;
    HScrollBar.LargeChange := siH.nPage;

    s := WB.OleObject.Document.Body.Style.overflow;
    if (s = 'scroll')
      then bVisibleV := True
      else if (s = 'visible') or (s = 'hidden')
        then bVisibleV := False
        else begin
          bVisibleV := True;
          VScrollBar.Enabled := (siV.nPage < Cardinal(siV.nMax)) and (siV.nPage > 0) and (siV.nMax > 0) and (siV.nMax <> WB.Height);
        end;

    bVisibleH := (siH.nPage < Cardinal(siH.nMax)) and (siH.nPage < Cardinal(siH.nMax)) and (siH.nMax > 0) and (siH.nMax <> WB.Width);

    Self.SetBounds(WB.Left, WB.Top, WB.Width, WB.Height);
    // Sizes of scrolls
    VScrollBar.Width := GetSystemMetrics(SM_CXHTHUMB);
    HScrollBar.Height := GetSystemMetrics(SM_CYVTHUMB);

    VScrollBar.Height := Height - integer(bVisibleH) * (HScrollBar.Height) - 2 * bWidth;
    HScrollBar.Width := WB.Width - VScrollBar.Width - 2 * bWidth;

    VScrollBar.Left := WB.Width - VScrollBar.Width - bWidth;
    VScrollBar.Top := bWidth;

    HScrollBar.Left := bWidth;
    HScrollBar.Top := WB.Height - HScrollBar.Height - bWidth;

    Parent := TWinControl(WB).Parent;

    if not HScrollBar.Visible and bVisibleH then begin
      HScrollBar.Visible := True;
    end
    else if not bVisibleH then begin
      HScrollBar.Visible := False;
    end;
    if not VScrollBar.Visible and bVisibleV then begin
      VScrollBar.Visible := True;
    end
    else if not bVisibleV then begin
      VScrollBar.Visible := False;
    end;
    UpdateRgn;
    // Unlock scrolls
    VScrollBar.DrawingForbidden := False;
    HScrollBar.DrawingForbidden := False;
    BringToFront;
  end;
end;

{ TacWBScrollBar }

destructor TacWBScrollBar.Destroy;
begin
  if Kind = sbVertical
    then Container.VScrollBar := nil
    else Container.HScrollBar := nil;
  inherited;
end;

end.
