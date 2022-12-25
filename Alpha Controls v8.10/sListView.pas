unit sListView;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, ImgList, StdCtrls, sConst, {$IFNDEF DELPHI5}types,{$ENDIF}
  Commctrl{$IFDEF DELPHI_XE3}, UITypes {$ENDIF}, sCommonData, sMessages, acSBUtils{$IFDEF LOGGED}, sDebugMsgs{$ENDIF}
  {$IFDEF TNTUNICODE}, TntComCtrls{$ENDIF};

{$I sDefs.inc}

type

  TColumnResizeEvent = procedure(sender: TCustomListview; columnIndex: Integer; columnWidth: Integer) of object;

{$IFDEF TNTUNICODE}
  TsCustomListView = class(TTntCustomListView)
{$ELSE}
  TsCustomListView = class(TCustomListView)
{$ENDIF}
{$IFNDEF NOTFORHELP}
  private
    Loading          : boolean;
    FhWndHeader      : HWnd;
    FhHeaderProc     : Pointer;
    FhDefHeaderProc  : Pointer;
    FPressedColumn   : Integer;
    FCommonData: TsCommonData;
    HoverColIndex : integer;
    FBoundLabel: TsBoundLabel;
    FHighlightHeaders: boolean;
    FOldAdvancedCustomDraw: TLVAdvancedCustomDrawEvent;
    FOldAdvancedCustomDrawItem: TLVAdvancedCustomDrawItemEvent;
    FFlag: Boolean;
    FOnMeasureItem: TMeasureItemEvent;
    FColumnResizeEvent: TColumnResizeEvent;
    FEndColumnResizeEvent: TColumnResizeEvent;
    FBeginColumnResizeEvent: TColumnResizeEvent;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure WMHitTest(var Message: TMessage); message WM_NCHITTEST;
//    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMParentNotify(var Message: TWMParentNotify); message WM_PARENTNOTIFY;
    procedure NewAdvancedCustomDraw(Sender: TCustomListView; const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure NewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure NewAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean; Bmp : TBitmap); overload;

    procedure PrepareCache;
    function GetHeaderColumnRect(Index: Integer): TRect;
    procedure ColumnSkinPaint(ControlRect : TRect; cIndex : Integer);
    procedure PaintHeader;
  protected
    NewStyleItems : boolean;
    HotItem : integer;
    ListSW : TacScrollWnd;
    // Varibles initialized after skin changing
    GridColor : TColor;
    iSelectIndex : integer;
    StyleChanging : boolean;

{$IFNDEF D2006}
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
{$ENDIF}
    procedure DoBeginColumnResize(ColumnIndex, ColumnWidth: integer); virtual;
    procedure DoEndColumnResize(ColumnIndex, ColumnWidth: integer); virtual;
    procedure DoColumnResize(ColumnIndex, ColumnWidth: integer); virtual;

    procedure WMNotify(var msg: TWMNotify); message WM_NOTIFY;

    function FindColumnIndex(pHeader: pNMHdr): integer;
    function FindColumnWidth(pHeader: pNMHdr): integer;
    procedure WndProc (var Message: TMessage); override;
    procedure HeaderWndProc(var Message: TMessage);
    procedure InitSkinParams;
    function AllColWidth : integer;
    function FullRepaint : boolean;
    property BorderStyle;
    function MakeDragImage(Message : TMessage) : HImageList;
    procedure InvalidateSmooth(Always : boolean);
    function GetImageList : TCustomImageList; virtual;
    procedure SetViewStyle(Value: TViewStyle); {$IFDEF DELPHI7UP}override;{$ENDIF}
  public
    ListLineHeight : Integer;
    function ColumnLeft(Index : integer) : integer;
    constructor Create(AOwner: TComponent); override;
    procedure InitControl(const Skinned : boolean); virtual;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure SelectItem(Index: Integer);
  published
{$ENDIF} // NOTFORHELP
{$IFDEF D2009}
    property Action;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelEdges;
    property DoubleBuffered;
    property Groups;
    property GroupView default False;
    property GroupHeaderImages;
{$ENDIF}
    property BoundLabel : TsBoundLabel read FBoundLabel write FBoundLabel;
    property SkinData : TsCommonData read FCommonData write FCommonData;
    property HighlightHeaders : boolean read FHighlightHeaders write FHighlightHeaders default True;
{$IFDEF D2006}
    property OnMouseEnter;
    property OnMouseLeave;
{$ELSE}
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
{$ENDIF}
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
{$IFDEF D2009}
    property OnItemChecked;
{$ENDIF}
    property OnBeginColumnResize: TColumnResizeEvent read FBeginColumnResizeEvent write FBeginColumnResizeEvent;
    property OnEndColumnResize: TColumnResizeEvent read FEndColumnResizeEvent write FEndColumnResizeEvent;
    property OnColumnResize: TColumnResizeEvent read FColumnResizeEvent write FColumnResizeEvent;
  end;

  TsListView = class(TsCustomListView)
{$IFNDEF NOTFORHELP}
  published
    property Align;
    property AllocBy;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatScrollBars;
    property FullDrag;
    property GridLines;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property HoverTime;
    property IconOptions;
    property Items;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ReadOnly default False;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property ShowWorkAreas;
    property ShowHint;
    property SmallImages;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSubItemImage;
    property OnDragDrop;
    property OnDragOver;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;
    property BoundLabel;
    property SkinData;
{$ENDIF} // NOTFORHELP
  end;

{$IFNDEF NOTFORHELP}
{$IFDEF TNTUNICODE}
  TsHackedListItems = class(TTntListItems)
{$ELSE}
  TsHackedListItems = class(TListItems)
{$ENDIF}
  public
    FNoRedraw: Boolean;
  end;
{$ENDIF} // NOTFORHELP

procedure ListViewToCSV(LV : TsListView; FileName : string);

implementation

uses sStyleSimply, acntUtils, sVclUtils, sMaskData, sGraphUtils, sSkinProps, sAlphaGraph, sSkinManager, acPNG,
  math{$IFDEF DELPHI7UP}, Themes{$ENDIF};

var
  LocalMsg : TMessage;
  LocalFlag : boolean;

procedure ListViewToCSV(LV : TsListView; FileName : string);
var
  Str : TStringList;
  X,Y : Integer;
  ColCount : Byte;
  Header : array of string;
  TS : string;
begin
  ColCount := LV.Columns.Count;
  SetLength(Header, ColCount);
  for X := 0 to ColCount - 1 do Header[X] := TSListView(LV).Columns[X].Caption;
  Str := TStringList.Create;
  Ts := '';
  for X := High(Header) downto 0 Do Ts := Ts + Header[X] + ',';
  if Ts[Length(Ts)] = ',' then Delete (Ts, Length(TS), 1);
  Str.Add(TS);
  for X := 0 To TsListView(LV).Items.Count - 1 do begin
    TS := '';
    for Y := High(Header) downto 0 Do
      if Y = 0 then Ts := TS + TsListView(LV).Items.Item[X].Caption + ',' else Ts := Ts + TsListView(LV).Items.Item[X].SubItems.Strings[Y - 1] + ',';
    if Ts[Length(Ts)] = ',' then Delete (Ts, Length(TS), 1);
    Str.Add(TS);
  end;
  if Pos('.csv', LowerCase(FileName)) > 0 then Str.SaveToFile(FileName) else Str.SaveToFile(FileName + '.CSV');
  Str.Free;
end;

constructor TsCustomListView.Create(AOwner: TComponent);
begin
  FhWndHeader     := 0;
  FhDefHeaderProc := nil;
  FPressedColumn  := -1;
  HotItem := -1;
  Loading := True;

  inherited Create(AOwner);
  FCommonData := TsCommonData.Create(Self, True);
  FCommonData.COC := COC_TsListView;
  SkinData.BGChanged := True;
  FBoundLabel := TsBoundLabel.Create(Self, FCommonData);
  ListLineHeight := Font.Size;
  FHighlightHeaders := True;
  HoverColIndex := -2;
  NewStyleItems := True;
  StyleChanging := False;
  FOldAdvancedCustomDraw := nil;
  FOldAdvancedCustomDrawItem := nil;
  try
    FhHeaderProc := MakeObjectInstance(HeaderWndProc);
  except
    Application.HandleException(Self);
  end;
end;

destructor TsCustomListView.Destroy;
begin
  if ListSW <> nil then FreeAndNil(ListSW);
  SmallImages := nil;
  LargeImages := nil;
  if FhWndHeader <> 0 then begin
    SetWindowLong(FhWndHeader, GWL_WNDPROC, LONG_PTR(FhDefHeaderProc));
  end;
  if FhHeaderProc <> nil then begin
    FreeObjectInstance(FhHeaderProc);
  end;
  FreeAndNil(FBoundLabel);
  InitControl(False);
  if Assigned(FCommonData) then FreeAndNil(FCommonData);
  inherited Destroy;
end;

procedure TsCustomListView.AfterConstruction;
begin
  Loading := True;
  inherited AfterConstruction;
end;

procedure TsCustomListView.WndProc(var Message: TMessage);
var
{$IFDEF D2009}
  si : TScrollInfo;
{$ENDIF}
  R : TRect;
  SavedDC : hdc;
  DstPos, Delta : integer;
  li : TListItem;
  i : integer;
//  i, TopIndex, LastIndex : integer;
//  iSize : TSize;
//  himg : HIMAGELIST;
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
{$IFNDEF D2006}
  case Message.Msg of
    CM_MOUSEENTER : if (Message.LParam = 0) and Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
    CM_MOUSELEAVE : if (Message.LParam = 0) and Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
  end;
{$ENDIF}
{  case Message.Msg of // Is not ready for Aero
    WM_ERASEBKGND : begin
      if SkinData.Skinned then begin
        if (acPrintDC <> 0) then begin
          TWMPaint(Message).DC := acPrintDC;
        end;
        inherited;
      end
      else if TWMPaint(Message).DC <> 0 then begin
        if ViewStyle = vsIcon then begin // blinking removing
          SavedDC := SaveDC(hdc(TWMPaint(Message).DC));

          iSize.cx := 0;
          iSize.cy := 0;

          if ViewStyle = vsIcon then himg := ListView_GetImageList(Handle, LVSIL_NORMAL) else himg := ListView_GetImageList(Handle, LVSIL_SMALL);
          if (himg <> 0) then ImageList_GetIconSize(himg, iSize.cx, iSize.cy);

          if not (ViewStyle in [vsSmallIcon, vsIcon]) then TopIndex := ListView_GetTopIndex(Handle) else TopIndex := 0;
          if ViewStyle in [vsReport, vsList] then LastIndex := TopIndex + ListView_GetCountPerPage(Handle) -1 else LastIndex := Items.Count - 1;
          for i := TopIndex to LastIndex do begin
            if ListView_GetItemRect(Handle, i, NewR, LVIR_ICON) then begin
              R.Left := NewR.Left + (WidthOf(NewR) - iSize.cx) div 2;
              R.Top := NewR.Top + (HeightOf(NewR) - iSize.cy) div 2;
              R.Right := R.Left + iSize.cx;
              R.Bottom := R.Top + iSize.cy;
              ExcludeClipRect(hdc(TWMPaint(Message).DC), R.Left, R.Top, R.Right, R.Bottom);
            end;
            if ListView_GetItemRect(Handle, i, R, LVIR_LABEL) then ExcludeClipRect(hdc(TWMPaint(Message).DC), R.Left, R.Top, R.Right, R.Bottom);
          end;

          inherited;
          RestoreDC(hdc(TWMPaint(Message).DC), SavedDC);
        end
        else inherited;
      end else inherited;
      Exit;
    end;
    WM_VSCROLL : if not SkinData.Skinned then begin
      SendMessage(Handle, WM_SETREDRAW, 0, 0);
      inherited;
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
      Exit;
    end;
  end;  }
  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_CTRLHANDLED : begin Message.Result := 1; Exit end;
    AC_GETAPPLICATION : begin Message.Result := LRESULT(Application); Exit end;
    AC_REMOVESKIN : if LongWord(Message.LParam) = LongWord(SkinData.SkinManager) then begin
      Items.BeginUpdate;
      CommonWndProc(Message, FCommonData);
      if ListSW <> nil then FreeAndNil(ListSW);
      // ScrollBars update
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOREPOSITION or SWP_FRAMECHANGED);
      if not FCommonData.CustomColor then begin
        Color := clWindow;
        ListView_SetBkColor(Handle, ColorToRgb(clWindow));
        ListView_SetTextBkColor(Handle, ColorToRgb(clWindow));
      end;
      if not FCommonData.CustomFont then begin
        Font.Color := clWindowText;
        ListView_SetTextColor(Handle, ColorToRgb(clWindowText));
      end;
      Items.EndUpdate;
      InitControl(False);
      RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_ERASE);
      Exit
    end;
    AC_SETNEWSKIN : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
      CommonWndProc(Message, FCommonData);
      InitControl(FCommonData.Skinned);
      exit
    end;
    AC_REFRESH : if (LongWord(Message.LParam) = LongWord(SkinData.SkinManager)) then begin
      Items.BeginUpdate;
      InitControl(True);
      CommonWndProc(Message, FCommonData);
      if FCommonData.Skinned and not Loading then begin
        if not FCommonData.CustomColor then Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;
        if not FCommonData.CustomFont then Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1];
        if HandleAllocated and Assigned(Ac_UninitializeFlatSB) then Ac_UninitializeFlatSB(Handle);
        RefreshEditScrolls(SkinData, ListSW);
        InitSkinParams;
        RedrawWindow(Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_UPDATENOW);
        HeaderWndProc(LocalMsg);
      end;
      Items.EndUpdate;
      Exit;
    end;
    AC_ENDPARENTUPDATE : if not SkinData.FUpdating then begin
      SkinData.PrintDC := 0;
      SkinData.FUpdating := False;
      PaintHeader;
      Exit
    end;
    AC_PREPARING : begin
      Message.Result := integer(SkinData.FUpdating);
      Exit;
    end;
    AC_BEFORESCROLL : begin
      Message.Result := 1;
      Exit;
    end;
{    AC_MOUSELEAVE : begin
      CMMouseLeave(Message);
    end;}
  end;
  if (csCreating in ControlState) or (FCommonData = nil) or not FCommonData.Skinned then inherited else begin // <- csLoading state is damaged (enabled always)???
    case Message.Msg of
      LVM_CREATEDRAGIMAGE : begin
        Message.Result := MakeDragImage(Message);
        Exit;
      end;
      CM_UIACTIVATE : begin
        Message.Result := 1; // Forbidden a processing by ListWnd (no blinking)
        Exit;
      end;
      LVM_SETCOLUMN, LVM_INSERTCOLUMN : with PLVColumn(Message.LParam)^ do begin
        if iImage = - 1 then Mask := Mask and not LVCF_IMAGE;
      end;
      WM_PRINT : begin
        inherited;
        if (ViewStyle = vsReport) and (ListSW <> nil) then begin
          SavedDC := SaveDC(TWMPaint(Message).DC);
          MoveWindowOrg(TWMPaint(Message).DC, ListSW.cxLeftEdge, ListSW.cxLeftEdge);
          IntersectClipRect(TWMPaint(Message).DC, 0, 0,
                            SkinData.FCacheBmp.Width - 2 * ListSW.cxLeftEdge - integer(ListSW.sBarVert.fScrollVisible) * GetScrollMetric(ListSW.sBarVert, SM_CXVERTSB),
                            SkinData.FCacheBmp.Height - 2 * ListSW.cxLeftEdge - integer(ListSW.sBarHorz.fScrollVisible) * GetScrollMetric(ListSW.sBarHorz, SM_CYHORZSB));
          SkinData.PrintDC := TWMPaint(Message).DC;
          HeaderWndProc(Message);
          RestoreDC(TWMPaint(Message).DC, SavedDC);
        end;
        Exit;
      end;
      WM_SETFOCUS, WM_KILLFOCUS : if not DoubleBuffered then begin
        SendMessage(Handle, WM_SETREDRAW, 0, 0);
        inherited;
        SendMessage(Handle, WM_SETREDRAW, 1, 0);
        if Selected <> nil then ListView_RedrawItems(Handle, Selected.Index, Selected.Index);
        Exit;
      end;
      WM_ERASEBKGND : if (SkinData.PrintDC <> 0) and not StyleChanging then begin
        TWMPaint(Message).DC := SkinData.PrintDC;
        inherited;
        Exit;
      end
      else begin
        FCommonData.FUpdating := FCommonData.Updating;
        if FCommonData.FUpdating then Exit;
      end;
      WM_VSCROLL : begin
        UpdateScrolls(ListSW, True);
        if Message.WParamLo = SB_THUMBTRACK then begin
          if Message.LParam <> 0 then DstPos := Message.LParam else DstPos := Message.WParamHi;
{$IFDEF D2009}
          if GroupView and (ViewStyle = vsReport) then begin
            si.cbSize := SizeOf(TScrollInfo);
            si.fMask := SIF_ALL;
            GetScrollInfo(Handle, SB_VERT, si);
            nLastSBPos := si.nPos
          end;
{$ENDIF}
          if nLastSBPos <> DstPos then begin // If CurPos is changed
            Delta := DstPos - nLastSBPos;
            if (ViewStyle = vsReport) {$IFDEF D2009} and not GroupView {$ENDIF} then begin
              ListView_GetItemRect(Handle, 0, R, LVIR_BOUNDS);
              Delta := Delta * HeightOf(R);
            end;

            if ViewStyle in [vsIcon, vsSmallIcon, vsReport] then begin
              SendMessage(Handle, WM_SETREDRAW, 0, 0);
              ListView_Scroll(Handle, 0, Delta);
              SendMessage(Handle, WM_SETREDRAW, 1, 0);
              R := ClientRect;
              if Delta < 0 then R.Bottom := R.Top - Delta else R.Top := R.Bottom - Delta;
              RedrawWindow(Handle, @R, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
{
              if ItemIndex > -1 then begin
                Self.UpdateItems(ItemIndex, ItemIndex);
              end;
}
            end
            else ListView_Scroll(Handle, 0, Delta);
          end;
        end
        else begin
          Message.LParam := 0;
          inherited;
        end;
        Exit;
      end;
      WM_NCPAINT: begin
        if SkinData.BGChanged then PrepareCache;
      end;
      WM_HSCROLL : case Message.WParamLo of
        SB_THUMBTRACK : begin
          if Message.LParam <> 0 then DstPos := Message.LParam else DstPos := Message.WParamHi;
          Delta := DstPos - nLastSBPos;
          if ViewStyle = vsList then begin
            ListView_GetItemRect(Handle, 0, R, LVIR_BOUNDS);
            Delta := Delta * WidthOf(R);
          end;
          ListView_Scroll(Handle, Delta, 0);
          InvalidateSmooth(False);
          PaintHeader;
          Exit;
        end;
        SB_LINELEFT, SB_LINERIGHT : begin
          inherited;
          InvalidateSmooth(False);
          Exit;
        end;
      end;
    end;
    CommonWndProc(Message, FCommonData);
    inherited;
    if Assigned(FCommonData) and FCommonData.Skinned then case Message.Msg of
      WM_MOUSEMOVE : if (Win32MajorVersion >= 6) then begin
        R.TopLeft := ScreenToClient(acMousePos);
        li := GetItemAt(R.Left, R.Top);
        if li <> nil then begin
          if (HotItem >= 0) and (HotItem < Items.Count) then begin // Repaint prev Hot Item
            if li.Index <> HotItem then begin
              R := Items[HotItem].DisplayRect(drBounds);
              InvalidateRect(Handle, @R, True);
              HotItem := -1;
            end
          end
        end;
      end;
      CM_MOUSEWHEEL, WM_MOUSEWHEEL : if (TWMMouseWheel(Message).Keys = 0) then begin
        InvalidateSmooth(False);
      end;
      CN_KEYDOWN, CN_KEYUP : case TWMKey(Message).CharCode of VK_PRIOR..VK_DOWN : InvalidateSmooth(False) end;
      CM_SHOWINGCHANGED : begin
        if HandleAllocated and Assigned(Ac_UninitializeFlatSB) then Ac_UninitializeFlatSB(Handle);
        RefreshEditScrolls(SkinData, ListSW);
        InitSkinParams;
      end;
      WM_STYLECHANGED : if not (csReadingState in ControlState) then begin
        ListView_Scroll(Handle, 0, 0);
        UpdateScrolls(ListSW, True);
      end;
      LVM_DELETEITEM, LVM_REDRAWITEMS, LVM_INSERTITEMA : if not FCommonData.Updating then UpdateScrolls(ListSW, True);
      WM_NCPAINT: begin
        PaintHeader;
      end;
      CM_VISIBLECHANGED, CM_ENABLEDCHANGED, WM_MOVE, WM_SIZE, WM_WINDOWPOSCHANGED : if FCommonData.Skinned and not (csDestroying in ComponentState) then begin
        Perform(WM_NCPAINT, 0, 0);
        LocalFlag := True;
        InvalidateSmooth(True);
        LocalFlag := False;
        case Message.Msg of
          WM_MOVE, WM_SIZE : begin
            if FullRepaint then SendMessage(Handle, WM_NCPAINT, 0, 0) // Scrollbars repainting if transparent
          end;
        end;
      end;
    end;
  end;
  // Aligning of the bound label
  if Assigned(BoundLabel) and Assigned(BoundLabel.FtheLabel) then case Message.Msg of
    WM_SIZE, WM_WINDOWPOSCHANGED : begin BoundLabel.AlignLabel end;
    CM_VISIBLECHANGED : begin BoundLabel.FtheLabel.Visible := Visible; BoundLabel.AlignLabel end;
    CM_BIDIMODECHANGED : begin BoundLabel.FtheLabel.BiDiMode := BiDiMode; BoundLabel.AlignLabel end;
  end;
  case Message.Msg of
    CN_MEASUREITEM, WM_MEASUREITEM : begin
      if Assigned(FOnMeasureItem) and (ViewStyle = vsReport) then begin
        i := TWMMeasureItem(Message).MeasureItemStruct^.itemHeight;
        FOnMeasureItem(TListView(Self), integer(TWMMeasureItem(Message).MeasureItemStruct^.itemID), i);
        TWMMeasureItem(Message).MeasureItemStruct^.itemHeight := i;
        Message.Result := 1;
      end;
    end;
  end;
end;

procedure TsCustomListView.Loaded;
begin
  Loading := True;
  inherited Loaded;
  Loading := False;
end;

function TsCustomListView.MakeDragImage(Message : TMessage) : HImageList;
var
  Bmp : TBitmap;
  Ico : HIcon;
  R : TRect;
begin
  ListView_GetItemRect(Handle, Message.WParam, R, LVIR_BOUNDS);
  Result := ImageList_Create(WidthOf(R), HeightOf(R), ILC_COLOR32, 0, AllocBy);
  Bmp := CreateBmp32(WidthOf(R), HeightOf(R));

  BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Canvas.Handle, R.Left, R.Top, SRCCOPY);

  Ico := MakeIcon32(Bmp, True);
  ImageList_AddIcon(Result, Ico);
  Bmp.Free;
end;

procedure TsCustomListView.CMMouseLeave(var Msg: TMessage);
var
  p : TPoint;
  r : TRect;
begin
  if FCommonData.Skinned and (ViewStyle = vsReport) then begin
    p := ClientToScreen(Point(Left, Top));
    r := Rect(p.x, p.y, p.x + Width, p.y + Height);

    if not PtInRect(r, acMousePos) then inherited;

    if (HoverColIndex >= 0) or (FPressedColumn >= 0) then begin
      HoverColIndex := -2;
      FPressedColumn := -1;
      PaintHeader;
    end;
  end;
  inherited;
end;

procedure TsCustomListView.HeaderWndProc(var Message: TMessage);
var
  Info : THDHitTestInfo;
  CurIndex, w : integer;
  function MouseToColIndex(p : TSmallPoint) : integer;
  var
    ltPoint : TPoint;
    i, c : integer;
    rc : TRect;
  begin
    w := 0;
    if Assigned(ListSW) and Assigned(ListSW.sBarHorz) then w := ListSW.sBarHorz.ScrollInfo.nPos else w := 0;
    ltPoint := ScreenToClient(Point(p.x + w, p.y));
    Result := -2;
    c := (Header_GetItemCount(FhWndHeader) - 1);
    for i := 0 to c do begin
      rc := GetHeaderColumnRect(i);
      if PtInRect(rc, ltPoint) then begin
        Result := Header_OrderToIndex(FhWndHeader, i);
        exit;
      end;
    end;
  end;
begin
  if (ViewStyle = vsReport) and Assigned(FCommonData) and FCommonData.Skinned then begin
    try
      if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
        AC_MOUSELEAVE : begin
          HoverColIndex := -2;
          PaintHeader;
        end;
      end
      else with Message do begin
        case Msg of
          WM_NCHITTEST : if ColumnClick then begin
            Result := CallWindowProc(FhDefHeaderProc, FhWndHeader, Msg, WParam, LParam);
            if FCommonData.Skinned and FHighLightHeaders then begin
              CurIndex := MouseToColIndex(TWMNCHitTest(Message).Pos);
              if HoverColIndex <> CurIndex then begin
                HoverColIndex := CurIndex;
                FCommonData.SkinManager.ActiveControl := FhWndHeader;
                PaintHeader;
              end;
            end;
          end;
          WM_LBUTTONUP: if ColumnClick then begin
            FPressedColumn := -1;
            FFlag := False;
          end;
          {WM_NCPAINT, }WM_PRINT : begin
            PaintHeader
          end;
          WM_PAINT: if FCommonData.Skinned then begin
            PaintHeader;
            Exit;
          end;
          WM_ERASEBKGND: Exit;
          WM_NCDESTROY: begin
            Result := CallWindowProc(FhDefHeaderProc, FhWndHeader, Msg, WParam, LParam);
            FhWndHeader := 0;
            FhDefHeaderProc := nil;
            Exit;
          end;
        end;
        Result := CallWindowProc(FhDefHeaderProc, FhWndHeader, Msg, WParam, LParam);
        case Msg of
          WM_LBUTTONDOWN: if ColumnClick then begin
            FFlag := True;
            Info.Point.X := TWMMouse(Message).XPos;
            Info.Point.Y := TWMMouse(Message).YPos;
            SendMessage(FhWndHeader, HDM_HITTEST, 0, Integer(@Info));

            if (Info.Flags and HHT_ONDIVIDER = 0) and (Info.Flags and HHT_ONDIVOPEN = 0) then begin
              FPressedColumn := Info.Item
            end
            else FPressedColumn := -1;
            RedrawWindow(FhWndHeader, nil, 0, RDW_INVALIDATE);
          end;
          WM_MOUSEMOVE : begin
            if FFlag then UpdateScrolls(ListSW, True)
          end;
        end;
      end;
    except
      Application.HandleException(Self);
    end;
  end
  else with Message do
    Result := CallWindowProc(FhDefHeaderProc, FhWndHeader, Msg, WParam, LParam);
end;

procedure TsCustomListView.WMParentNotify(var Message: TWMParentNotify);
var
  WndName : string;
begin
  try
    with Message do begin
      SetLength(WndName, 96);
      SetLength(WndName, GetClassName(ChildWnd, PChar(WndName), Length(WndName)));
      if (Event = WM_CREATE) and (WndName = WC_HEADER) then begin
        if (FhWndHeader <> 0) then begin
          SetWindowLong(FhWndHeader, GWL_WNDPROC, LONG_PTR(FhDefHeaderProc));
          FhWndHeader := 0;
        end;
        if (FhWndHeader = 0) then begin
          FhWndHeader := ChildWnd;
          FhDefHeaderProc := Pointer(GetWindowLong(FhWndHeader, GWL_WNDPROC));
          SetWindowLong(FhWndHeader, GWL_WNDPROC, LONG_PTR(FhHeaderProc));
        end;
      end else
      if (Event = WM_DESTROY) and (WndName = WC_HEADER) then begin
        if (FhWndHeader <> 0) then begin
          SetWindowLong(FhWndHeader, GWL_WNDPROC, LONG_PTR(FhDefHeaderProc));
          FhWndHeader := 0;
        end;
        if (FhWndHeader = 0) then begin
          FhWndHeader := ChildWnd;
          FhDefHeaderProc := Pointer(GetWindowLong(FhWndHeader, GWL_WNDPROC));
          SetWindowLong(FhWndHeader, GWL_WNDPROC, LONG_PTR(FhHeaderProc));
        end;
      end;
    end;
  except
    Application.HandleException(Self);
  end;
  inherited;
end;

procedure TsCustomListView.PaintHeader;
var
  i, Index, count, RightPos : Integer;
  rc, HeaderR : TRect;
  PS : TPaintStruct;
begin
  BeginPaint(FhWndHeader, PS);
  try
    if not FCommonData.FCacheBmp.Empty and not StyleChanging then begin
      RightPos := 0;
      count := Header_GetItemCount(FhWndHeader) - 1;
      if count > -1 then begin
        // Draw Columns Headers
        for i := 0 to count do begin
          rc := GetHeaderColumnRect(i);
          if not IsRectEmpty(rc) then begin
            ListLineHeight := HeightOf(rc);
            Index := Header_OrderToIndex(FhWndHeader, i);
            ColumnSkinPaint(rc, Index);
          end;
          if RightPos < rc.Right then RightPos := rc.Right;
        end;
      end
      else begin
        rc := GetHeaderColumnRect(0);
        ListLineHeight := HeightOf(rc);
      end;
      // Draw background section
      if Windows.GetWindowRect(FhWndHeader, HeaderR) then begin
        rc := Rect(RightPos, 0, WidthOf(HeaderR), HeightOf(HeaderR));
        if not IsRectEmpty(rc) then begin ColumnSkinPaint(rc, -1); end;
      end;
    end;
  finally
    EndPaint(FhWndHeader, PS);
  end;
end;

function TsCustomListView.GetHeaderColumnRect(Index: Integer): TRect;
var
  SectionOrder : array of Integer;
  rc : TRect;
begin
  if FhWndHeader <> 0 then begin
    if Self.FullDrag then begin
      SetLength(SectionOrder, Columns.Count);
      Header_GetOrderArray(FhWndHeader, Columns.Count, PInteger(SectionOrder));
      Header_GETITEMRECT(FhWndHeader, SectionOrder[Index] , @rc);
    end
    else begin
      Header_GETITEMRECT(FhWndHeader, Index, @rc);
    end;
    Result := rc;
  end
  else Result := Rect(0, 0, 0, 0);
end;

procedure TsCustomListView.ColumnSkinPaint(ControlRect : TRect; cIndex : Integer);
const
  HDF_SORTDOWN = $0200;
  HDF_SORTUP = $0400;
var
  R, TextRC   : TRect;
  tmpdc : HDC;
  TempBmp : Graphics.TBitmap;
  State, si, rWidth : integer;
  Flags : integer;
{$IFDEF TNTUNICODE}
  Item: THDItemW;
{$ELSE}
  Item: THDItem;
{$ENDIF}
  Buf: array[0..128] of acChar;
  ws : acString;
  ts, ArrowSize : TSize;
  ArrowIndex : integer;
  CI : TCacheInfo;
  gWidth : integer;
begin
  try
    TempBmp := CreateBmp32(WidthOf(ControlRect), HeightOf(ControlRect));
    R := Rect(0, 0, TempBmp.Width, TempBmp.Height);
    if FPressedColumn >= 0 then State := iffi(FPressedColumn = cIndex, 2, 0) else if HoverColIndex = cIndex then State := 1 else State := 0;
    CI.Ready := False;
    CI.FillColor := Color;
    si := PaintSection(TempBmp, s_ColHeader, s_Button, State, SkinData.SkinManager, ControlRect.TopLeft, CI.FillColor);
    TempBmp.Canvas.Font.Assign(Font);
    TextRC := R;
    InflateRect(TextRC, -4, -1);
    TempBmp.Canvas.Brush.Style := bsClear;
    FillChar(Item, SizeOf(Item), 0);
    FillChar(Buf, SizeOf(Buf), 0);
    Item.pszText := PacChar(@Buf);
    Item.cchTextMax := SizeOf(Buf);
    Item.Mask := HDI_TEXT or HDI_FORMAT or HDI_IMAGE or HDI_BITMAP;
    if (cIndex >= 0) and bool(SendMessage(FHwndHeader, {$IFDEF TNTUNICODE}HDM_GETITEMW{$ELSE}HDM_GETITEM{$ENDIF}, cIndex, LPARAM(@Item))) then begin
      ws := acString(Item.pszText);
      Flags := DT_END_ELLIPSIS or DT_EXPANDTABS or DT_SINGLELINE or DT_VCENTER;
      if (SmallImages = nil) or (Item.fmt and (LVCFMT_IMAGE or LVCFMT_COL_HAS_IMAGES) = 0) then begin
        Item.iImage := -1;
        gWidth := 0;
      end
      else gWidth := SmallImages.Width + 4;

      if item.fmt and HDF_SORTDOWN = HDF_SORTDOWN
        then ArrowIndex := SkinData.SkinManager.GetMaskIndex(SkinData.SkinManager.ConstData.IndexScrollBottom, s_ScrollBtnBottom, s_ItemGlyph)
        else if item.fmt and HDF_SORTUP = HDF_SORTUP
          then ArrowIndex := SkinData.SkinManager.GetMaskIndex(SkinData.SkinManager.ConstData.IndexScrollTop, s_ScrollBtnTop, s_ItemGlyph)
          else ArrowIndex := -1;
      if ArrowIndex <> -1 then begin
        ArrowSize.cx := WidthOfImage(SkinData.SkinManager.ma[ArrowIndex]) + 6;
        ArrowSize.cy := HeightOfImage(SkinData.SkinManager.ma[ArrowIndex]);
      end
      else begin
        ArrowSize.cx := 0;
        ArrowSize.cy := 0;
      end;

{$IFDEF TNTUNICODE}
      GetTextExtentPoint32W(TempBmp.Canvas.Handle, PacChar(ws), Length(ws), ts);
{$ELSE}
      GetTextExtentPoint32(TempBmp.Canvas.Handle, PacChar(ws), Length(ws), ts);
{$ENDIF}
      inc(ts.cx, 6);
      rWidth := WidthOf(ControlRect, True) - 6;
      case (Item.fmt and $0ff) of
        HDF_CENTER : begin
          if ts.cx + gWidth + ArrowSize.cx + 6 >= rWidth then begin
            TextRc.Left := gWidth + 6;
            TextRc.Right := TextRc.Right - ArrowSize.cx;
          end
          else begin
            TextRc.Left := (WidthOf(TextRc) - ts.cx - ArrowSize.cx - gWidth) div 2 + TextRc.Left + gWidth;
            TextRc.Right := TextRc.Left + ts.cx;
          end;
        end;
        HDF_RIGHT : begin
          TextRc.Right := TextRc.Right - ArrowSize.cx;
          if ts.cx + gWidth + ArrowSize.cx + 6 >= rWidth then TextRc.Left := gWidth + 6 else TextRc.Left := TextRc.Right - ts.cx;
        end
        else begin
          TextRc.Left := TextRc.Left + gWidth;
          TextRc.Right := min(rWidth, TextRc.Left + ts.cx);
{          if ts.cx + TextRc.Left >= rWidth
            then TextRc.Right := rWidth - TextRc.Left
            else TextRc.Right := TextRc.Left + ts.cx;}
        end
      end;
      if ArrowIndex <> -1 then DrawSkinGlyph(TempBmp, Point(TextRc.Right + 6, (HeightOf(TextRc) - ArrowSize.cy) div 2), State, 1, SkinData.SkinManager.ma[ArrowIndex], MakeCacheInfo(TempBmp));

      if (State = 2) then OffsetRect(TextRc, 1, 1);
      if UseRightToLeftReading then Flags := Flags or DT_RTLREADING;
      acWriteTextEx(TempBmp.Canvas, PacChar(ws), True, TextRc, Flags, si, (State <> 0), SkinData.SkinManager);
      if (item.iImage <> -1)
        then SmallImages.Draw(TempBmp.Canvas, TextRc.Left - gWidth, (HeightOf(TextRc) - SmallImages.Height) div 2 + integer(State = 2), Item.iImage, Enabled);
    end;

    if SkinData.PrintDC = 0 then tmpdc := GetDC(FhWndHeader) else tmpdc := SkinData.PrintDC;
    try
      BitBlt(tmpdc, ControlRect.Left, ControlRect.Top, R.Right, R.Bottom, TempBmp.Canvas.Handle, 0, 0, SRCCOPY);
    finally
      if SkinData.PrintDC = 0 then ReleaseDC(FhWndHeader, tmpdc);
    end;
    FreeAndNil(TempBmp);
  except
    Application.HandleException(Self);
  end;
end;

procedure TsCustomListView.PrepareCache;
begin
  InitCacheBmp(SkinData);
  PaintItem(FCommonData, GetParentCache(FCommonData), False, 0, Rect(0, 0, Width, Height), Point(Left, Top), FCommonData.FCacheBmp, True);
  FCommonData.BGChanged := False;
end;

procedure TsCustomListView.WMHitTest(var Message: TMessage);
begin
  inherited;
  if FCommonData.Skinned and (HoverColIndex > -1) and FHighLightHeaders then begin
    HoverColIndex := -2;
    PaintHeader;
  end;
end;

function TsCustomListView.AllColWidth: integer;
var
  i, w, c : integer;
begin
  Result := 0;
  c := Columns.Count - 1;
  for i := 0 to c do begin
    w := integer(ListView_GetColumnWidth(Handle, i));
    if abs(w) > 999999 then Exit;
    Result := integer(Result + w);
  end
end;

procedure TsCustomListView.NewAdvancedCustomDraw(Sender: TCustomListView; const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  SavedDC : hdc;
  i, TopIndex, LastIndex : integer;
  R : TRect;
begin
  // inherited
  if not (csDesigning in ComponentState) and Assigned(FOldAdvancedCustomDraw) then FOldAdvancedCustomDraw(Sender, Arect, Stage, DefaultDraw) else begin
    DefaultDraw := False;
    if StyleChanging then Exit;
    if (Stage in [cdPostErase, cdPostPaint]) then Exit;
    if (Stage in [cdPreErase, cdPrePaint]) then begin
      DefaultDraw := True;
      if SkinData.Skinned then begin
        FCommonData.FUpdating := FCommonData.Updating;
        if FCommonData.FUpdating then Exit;
        if SkinData.BGChanged then PrepareCache;
      end;
      if FullRepaint then begin
        SavedDC := SaveDC(Canvas.Handle);
        if (Stage in [cdPrePaint]) and LocalFlag then begin
          if not (ViewStyle in [vsSmallIcon, vsIcon]) then TopIndex := ListView_GetTopIndex(Handle) else TopIndex := 0;
          if ViewStyle in [vsReport, vsList] then LastIndex := TopIndex + ListView_GetCountPerPage(Handle) -1 else LastIndex := Items.Count - 1;
          for i := TopIndex to LastIndex do begin
            if ListView_GetItemRect(Handle, i, R, LVIR_ICON) then ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
            if ListView_GetItemRect(Handle, i, R, LVIR_LABEL) then ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          end;
        end;
        BitBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight, FCommonData.FCacheBmp.Canvas.Handle,
                        integer(BorderStyle = bsSingle) * 2, integer(BorderStyle = bsSingle) * 2, SRCCOPY);
        RestoreDC(Canvas.Handle, SavedDC);
        if (Stage in [cdPrePaint]) and not SkinData.CustomColor then begin
          // Ensure that the items are drawn transparently
          SetBkMode(Canvas.Handle, TRANSPARENT);
          ListView_SetTextBkColor(Handle, CLR_NONE);
          ListView_SetBKColor(Handle, CLR_NONE);
        end;
      end
      else if not SkinData.CustomColor then begin
//        Color := GetBGColor(SkinData, 0);
      end;
      if Stage = cdPreErase then DefaultDraw := False
    end
    else if Stage = cdPostErase then DefaultDraw := False;
  end
end;

function TsCustomListView.FullRepaint: boolean;
begin
  Result := False;
end;

procedure TsCustomListView.InvalidateSmooth(Always : boolean);
begin
  if FullRepaint then begin
    if Always then InvalidateRect(Handle, nil, False) else case ViewStyle of
      vsList : begin
        if (ListSW.sBarHorz.ScrollInfo.nPos < ListSW.sBarHorz.ScrollInfo.nMax - 1) and
          (ListSW.sBarHorz.ScrollInfo.nPos > ListSW.sBarHorz.ScrollInfo.nMin) then InvalidateRect(Handle, nil, False);
      end;
      vsReport : begin
        GetScrollInfo(Handle, SB_VERT, ListSW.sBarVert.ScrollInfo);
        if (ListSW.sBarVert.ScrollInfo.nPos < ListSW.sBarVert.ScrollInfo.nMax - Font.Size - 3) and
             (ListSW.sBarVert.ScrollInfo.nPos > ListSW.sBarVert.ScrollInfo.nMin) then begin
          InvalidateRect(Handle, nil, False);
        end
      end;
    end;
  end;
end;

procedure TsCustomListView.SelectItem(Index: Integer);
begin
  if (Index > -1) and (Index < Items.Count) then begin
    (Items[Index] as TListItem).Selected := True;
    (Items[Index] as TListItem).Focused := True;
    SendMessage(Handle, LVM_ENSUREVISIBLE, Index, 0);
  end;
end;

procedure TsCustomListView.SetViewStyle(Value: TViewStyle);
begin
  if StyleChanging then Exit;

  if HandleAllocated then begin
    StyleChanging := True;
    SkinData.BeginUpdate;
    inherited;
    StyleChanging := False;
    ListView_Arrange(Handle, LVA_DEFAULT);
    SkinData.EndUpdate;
    if SkinData.Skinned then begin
      RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ERASE);
      if ViewStyle = vsReport then PaintHeader;
    end;
  end
  else inherited;
end;

procedure TsCustomListView.InitControl(const Skinned: boolean);
var
  FTempValue : TLVAdvancedCustomDrawEvent;
  FTempItemValue : TLVAdvancedCustomDrawItemEvent;
begin
  if (csDesigning in ComponentState) then Exit;
  if Skinned then begin
    if Assigned(OnAdvancedCustomDraw) then begin
      FTempValue := NewAdvancedCustomDraw;
      if not Assigned(FOldAdvancedCustomDraw) and (addr(OnAdvancedCustomDraw) <> addr(FTempValue)) then FOldAdvancedCustomDraw := OnAdvancedCustomDraw;
    end
    else FOldAdvancedCustomDraw := nil;
    OnAdvancedCustomDraw := NewAdvancedCustomDraw;

    if not Assigned(OnDrawItem) then begin
      if Assigned(OnAdvancedCustomDrawItem) then begin
        FTempItemValue := NewAdvancedCustomDrawItem;
        if not Assigned(FOldAdvancedCustomDrawItem) and (addr(OnAdvancedCustomDrawItem) <> addr(FTempITemValue))
          then FOldAdvancedCustomDrawItem := OnAdvancedCustomDrawItem;
      end
      else FOldAdvancedCustomDrawItem := nil;
      OnAdvancedCustomDrawItem := NewAdvancedCustomDrawItem;
    end;
  end
  else begin
    if Assigned(FOldAdvancedCustomDraw) then begin
      OnAdvancedCustomDraw := FOldAdvancedCustomDraw;
      FOldAdvancedCustomDraw := nil;
    end
    else begin
      FTempValue := NewAdvancedCustomDraw;
      if addr(OnAdvancedCustomDraw) = addr(FTempValue)
        then OnAdvancedCustomDraw := nil;
    end;

    if not Assigned(OnDrawItem) then begin
      if Assigned(FOldAdvancedCustomDrawItem) then begin
        OnAdvancedCustomDrawItem := FOldAdvancedCustomDrawItem;
        FOldAdvancedCustomDrawItem := nil;
      end
      else begin
        FTempItemValue := NewAdvancedCustomDrawItem;
        if addr(OnAdvancedCustomDrawItem) = addr(FTempItemValue)
          then OnAdvancedCustomDrawItem := nil;
      end;
    end;
  end
end;

procedure TsCustomListView.CreateWnd;
var
  Wnd : Hwnd;
begin
  inherited;
  try
    FCommonData.Loaded;
  except
    Application.HandleException(Self);
  end;
  if FCommonData.Skinned then begin
    if not FCommonData.CustomColor then Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color;
    if not FCommonData.CustomFont then Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1];
    InitControl(True);
  end;
{$IFDEF DELPHI7UP}
  {$IFNDEF D2010}
  if NewStyleItems and ThemeServices.ThemesEnabled and (Win32MajorVersion >= 6) then Ac_SetWindowTheme(Handle, 'explorer', nil); // do not localize
  {$ENDIF}
{$ENDIF}
  Wnd := GetWindow(Handle, GW_CHILD);
  SetWindowLong(Wnd, GWL_STYLE, GetWindowLong(Wnd, GWL_STYLE) and not HDS_FULLDRAG);
end;

function EllipsifyEnd(DC: hDC; sText: acString; Width, Height: integer; dwFlags: Cardinal) : acstring;
var
  rct : TRect;
  len_str : integer;
  i : integer;
  sTemp : string;
Const
  cEllipsis : String = '...';
begin
  Result := sText;
  if sText = '' then Exit;

  rct.Left := 0;
  rct.Top := 0;
  rct.Bottom := 0;
  rct.Right := Width;

  acDrawText(DC, PacChar(sText), rct, dwFlags or DT_CALCRECT);
  if rct.Bottom <= Height then Exit;

  len_str := Length(sText);
  Result := sText;

  for i := len_str downto 1 do begin
    Delete(Result, i, 1);
    sTemp := Result + cEllipsis;
    rct.Right := Width;
    rct.Bottom := 0;
    acDrawText(DC, PacChar(sTemp), rct, dwFlags or DT_CALCRECT);
    if rct.Bottom <= Height then begin
      Result := Result + cEllipsis;
      Exit;
    end
  end;
  Result := cEllipsis;
end;

procedure TsCustomListView.NewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  Bmp : TBitmap;
  ACanvas : TCanvas;
  fText, nRect, aRect, imgRect, cRect, iRect, CellRect : TRect;
  SavedDC : hdc;
  cw, sNdx, ColWidth : integer;
  vStyle : TViewStyle;
  CI : TCacheInfo;
  Size : TSize;
  DrawStyle : Cardinal;
  p : TPoint;
  sTemp : acString;
  ImgList : TCustomImageList;
  b, bSelected, bHot : boolean;
{$IFDEF DELPHI6UP}
  iDrawStyle : TDrawingStyle;
{$ENDIF}
  CheckState : TCheckBoxState;
begin
  if (csDesigning in ComponentState) {$IFDEF DELPHI6UP}or not Canvas.HandleAllocated{$ENDIF} {or FCommonData.FUpdating }then Exit;
  if Assigned(FOldAdvancedCustomDrawItem) then begin
    FOldAdvancedCustomDrawItem(Sender, Item, State, Stage, DefaultDraw);
    Exit;
  end;
  if (Stage in [cdPrePaint, cdPostPaint]) then begin
    CI.Bmp := nil;
    CI.Ready := False;
    CI.FillColor := Color;
    vStyle := ViewStyle;
    Bmp := nil;
    DrawStyle := DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or DT_VCENTER or DT_NOCLIP;
    if UseRightToLeftReading then DrawStyle := DrawStyle or DT_RTLREADING;

    bSelected := Item.Selected and not (HideSelection and not Focused);
    bHot := False;

    // Check rect of item
    if not ListView_GetItemRect(Handle, Item.Index, iRect, LVIR_BOUNDS) or (iRect.Left = -2147483613 {is not ready}) then Exit;
    ColWidth := ListView_GetColumnWidth(Handle, 0);

    if bSelected then sNdx := iSelectIndex else begin
      sNdx := -1;
      // Check if Item is hot
      if (Win32MajorVersion >= 6) and (GetCapture = 0) {If mouse is not pressed} then begin
        p := Self.ScreenToClient(acMousePos);
        if PtInRect(ClientRect, p) then begin
          if PtInRect(iRect, p) then begin
            GetClipBox(Canvas.Handle, cRect);
            nRect.Left := max(iRect.Left, cRect.Left);
            nRect.Top := max(iRect.Top, cRect.Top);
            nRect.Right := min(iRect.Right, cRect.Right);
            nRect.Bottom := min(iRect.Bottom, cRect.Bottom);
            if PtInRect(nRect, p) then begin
              if (HotItem >= 0) and (HotItem < Items.Count) and (HotItem <> Item.Index) then begin // Repaint prev Hot Item
                cRect := Items[HotItem].DisplayRect(drBounds);
                InvalidateRect(Handle, @cRect, True);
              end;
              HotItem := Item.Index;
              bHot := True;
              bSelected := True;
              sNdx := iSelectIndex;
            end;
          end;
        end;
      end;
    end;
    if (vStyle = vsReport) and RowSelect then begin
      nRect := iRect;
      if IsRectEmpty(nRect) then Exit;
      DrawStyle := DrawStyle or DT_END_ELLIPSIS;

      if bSelected then begin
        Bmp := CreateBmp32(WidthOf(nRect), HeightOf(nRect));
        if GridLines then aRect := Rect(0, 0, Bmp.Width - 1, Bmp.Height - 1) else aRect := Rect(0, 0, Bmp.Width, Bmp.Height);
        aRect := Rect(0, 0, Bmp.Width, Bmp.Height);
        if sNdx < 0 then begin
          FillDC(Bmp.Canvas.Handle, aRect, SkinData.SkinManager.GetHighLightColor(cdsFocused in State))
        end
        else begin
          PaintItem(sNdx, s_Selection, CI, True, integer(Focused and (cdsFocused in State)), aRect, Point(nRect.Left, nRect.Top), Bmp, SkinData.SkinManager);
          if bHot then begin
            fText := nRect;
            if BorderStyle <> bsNone then OffsetRect(fText, 2, 2);
            BlendTransRectangle(Bmp, 0, 0, FCommonData.FCacheBmp, fText, 0.5);
          end;
        end;
        Bmp.Canvas.Font := Canvas.Font;
        ACanvas := Bmp.Canvas;
      end
      else begin
        aRect := nRect;
        ACanvas := Canvas;
        FillDC(ACanvas.Handle, nRect, Canvas.Brush.Color);
        SetBkMode(ACanvas.Handle, TRANSPARENT);
      end;

      if (StateImages <> nil) then begin
        if (Item.StateIndex >= 0) and (Item.StateIndex < StateImages.Count) then begin
          fText.Left := nRect.Left + 3;
          cw := StateImages.Width + 2;
          fText.Right := fText.Left + cw;
          fText.Top := nRect.Top;
          fText.Bottom := nRect.Bottom;

          CI.X := fText.Left;
          CI.Y := fText.Top;
          if Bmp <> nil then begin
            if not bSelected then FillDC(Bmp.Canvas.Handle, fText, Color);
            StateImages.Draw(Bmp.Canvas, 2, 0, Item.StateIndex, True);
          end
          else begin
            Bmp := CreateBmp32(cw, fText.Bottom - fText.Top);
            FillDC(Bmp.Canvas.Handle, Rect(0, 0, Bmp.Width, Bmp.Height), Color);
            StateImages.Draw(Bmp.Canvas, 0, 0, Item.StateIndex, True);
            BitBlt(Canvas.Handle, 2, fText.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
            FreeAndNil(Bmp);
          end;
        end;
      end
      else if CheckBoxes then begin
        if Item.Checked then CheckState := cbChecked else CheckState := cbUnChecked;

        fText.Left := nRect.Left + 3;
        cw := CheckWidth(SkinData.SkinManager) + 2;
        fText.Right := fText.Left + cw;
        fText.Top := nRect.Top;
        fText.Bottom := nRect.Bottom;

        CI.X := fText.Left;
        CI.Y := fText.Top;
        if Bmp <> nil then begin
          if not bSelected then FillDC(Bmp.Canvas.Handle, fText, Color);
          acDrawCheck(fText, CheckState, True, Bmp, CI, SkinData.SkinManager);
        end
        else begin
          Bmp := CreateBmp32(cw, fText.Bottom - fText.Top);
          FillDC(Bmp.Canvas.Handle, Rect(0, 0, Bmp.Width, Bmp.Height), Color);
          acDrawCheck(Rect(0, 0, Bmp.Width, Bmp.Height), CheckState, True, Bmp, CI, SkinData.SkinManager);
          BitBlt(Canvas.Handle, fText.Left, fText.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          FreeAndNil(Bmp);
        end;
      end
      else if Bmp = nil
        then cw := nRect.Left
        else cw := 0; // Offset is 0 if draw on Bmp

      // Glyph
      if (SmallImages <> nil) then begin
        imgRect := Item.DisplayRect(drIcon);
        if (Item.ImageIndex > -1) and (Item.ImageIndex < SmallImages.Count) then begin
          imgRect.Top := imgRect.Top + (HeightOf(imgRect) - SmallImages.Height) div 2;
          imgRect.Left := imgRect.Left + (WidthOf(imgRect) - SmallImages.Width) div 2;
          if bSelected then OffsetRect(imgRect, -nRect.Left, -nRect.Top);
          SmallImages.Draw(ACanvas, imgRect.Left, imgRect.Top, Item.ImageIndex, {$IFDEF DELPHI6UP}dsNormal, itImage{$ELSE}True{$ENDIF});
        end
      end
      else imgRect := Rect(cw, 0, cw, 0);

      // Text
      fText.Left := imgRect.Right + 1;
      if GetCapture = FhWndHeader // If columns is in resizing
        then fText.Right := nRect.Left + ListView_GetColumnWidth(Handle, 0) - 2
        else if Columns[0].Width <> -1 then fText.Right := nRect.Left + Columns[0].Width else fText.Right := nRect.Right;
      fText.Top := aRect.Top;
      fText.Bottom := aRect.Bottom;
      if not IsRectEmpty(fText) then begin
        inc(fText.Left);
        if (sNdx = -1) or (SkinData.CustomFont) then begin
          ACanvas.Brush.Style := bsClear;
          if SkinData.CustomFont then begin
    {$IFDEF TNTUNICODE}
            AcDrawText(ACanvas.Handle, TTntListItem(Item).Caption, fText, DrawStyle);
    {$ELSE}
            AcDrawText(ACanvas.Handle, Item.Caption, fText, DrawStyle);
    {$ENDIF}
          end
          else begin
            if bSelected and not bHot
              then ACanvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor(cdsFocused in State)
              else ACanvas.Font.Color := SkinData.SkinManager.gd[SkinData.SkinIndex].Props[0].FontColor.Color;
    {$IFDEF TNTUNICODE}
            AcDrawText(ACanvas.Handle, TTntListItem(Item).Caption, fText, DrawStyle);
    {$ELSE}
            AcDrawText(ACanvas.Handle, Item.Caption, fText, DrawStyle);
    {$ENDIF}
          end;
        end
        else begin
    {$IFDEF TNTUNICODE}
          acWriteTextEx(ACanvas, PacChar(TTntListItem(Item).Caption), True, fText, DrawStyle, sNdx, Focused and not bHot, SkinData.SkinManager);
    {$ELSE}
          acWriteTextEx(ACanvas, PacChar(Item.Caption), True, fText, DrawStyle, sNdx, Focused and not bHot, SkinData.SkinManager);
    {$ENDIF}
        end;
      end;

      if GridLines and (Mouse.Capture = 0) {If column is not resized} then begin // Draw grid horz line
        ACanvas.Pen.Color := clBtnFace;
        ACanvas.MoveTo(0, nRect.Bottom - 1);
        ACanvas.LineTo(Width, nRect.Bottom - 1);
      end;
      cw := Columns[0].Width;
      for sNdx := 1 to Columns.Count - 1 do begin
        if sNdx <= Item.SubItems.Count then begin
          b := True;
          NewAdvancedCustomDrawSubItem(Self, Item, sNdx - 1, State, Stage, b, Bmp)
        end;
        if GridLines and (Mouse.Capture = 0) {If column is not resized} then begin // Draw grid vert lines
          ACanvas.MoveTo(cw, nRect.Top);
          ACanvas.LineTo(cw, nRect.Bottom);
        end;
        inc(cw, Columns[sNdx].Width);
      end;
      if Bmp <> nil then begin // Selection
        BitBlt(TAccessCanvas(Canvas).FHandle, nRect.Left, nRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(Bmp);
      end;
    end
    else begin
      nRect := Item.DisplayRect(drLabel);
      CellRect := Item.DisplayRect(drBounds);
      ACanvas := Canvas;
      aRect := nRect;
//      if Color <> Canvas.Brush.Color then
      Canvas.FillRect(iRect); // Fill if other color was defined

      case vStyle of
        vsReport : begin
          DrawStyle := DrawStyle or DT_END_ELLIPSIS;
          SavedDC := SaveDC(TAccessCanvas(Canvas).FHandle);
          IntersectClipRect(TAccessCanvas(Canvas).FHandle, CellRect.Left, CellRect.Top, CellRect.Left + ColWidth, CellRect.Bottom);
        end;
        vsIcon : begin
          DrawStyle := DrawStyle and not DT_SINGLELINE and not DT_VCENTER and not DT_NOCLIP and not DT_EXPANDTABS;
          DrawStyle := DrawStyle or DT_CENTER or DT_WORDBREAK or DT_END_ELLIPSIS or DT_WORD_ELLIPSIS;
          if bSelected then begin
            fText := aRect;
            AcDrawText(Canvas.Handle, Item.Caption, fText, DrawStyle or DT_CALCRECT and not DT_END_ELLIPSIS);
            aRect.Bottom := min(fText.Bottom + 2, aRect.Bottom);
          end;
        end;
      end;

      if bSelected then begin
        fText := aRect;
        case vStyle of
          vsSmallIcon, vsList, vsReport : begin
            acGetTextExtent(Canvas.Handle, Item.Caption, Size);
            fText.Right := min(ftext.Left + Size.cx + 5, aRect.Right);
          end;
        end;
        if sNdx < 0 then begin
          FillDC(Canvas.Handle, Rect(aRect.Left, aRect.Top, min(aRect.Right, aRect.Left + WidthOf(fText)), aRect.Bottom), SkinData.SkinManager.GetHighLightColor(cdsFocused in State));
          SetBkMode(Canvas.Handle, TRANSPARENT);
        end
        else begin
            if (Win32MajorVersion >= 6) then begin
              cRect := iRect;
              if (vStyle = vsReport) then cRect.Right := cRect.Left + ColWidth;
            end
            else cRect := Rect(aRect.Left, aRect.Top, min(aRect.Right, aRect.Left + WidthOf(fText)), aRect.Bottom);

            // Paint selection
            Bmp := CreateBmp32(WidthOf(cRect), HeightOf(cRect));
            PaintItem(sNdx, s_Selection, CI, True, integer(Focused), Rect(0, 0, Bmp.Width, Bmp.Height), Point(0, 0), Bmp, SkinData.SkinManager);
            if bHot then begin
              if (BorderStyle <> bsNone) then cw := 1 + integer(Ctl3d) else cw := 0;
              OffsetRect(cRect, cw, cw);
              BlendTransRectangle(Bmp, 0, 0, FCommonData.FCacheBmp, cRect, 0.5);
              OffsetRect(cRect, -cw, -cw);
            end;
            BitBlt(Canvas.Handle, cRect.Left, cRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
            FreeAndNil(Bmp);
          end;
      end
      else sNdx := -1;

      if vStyle <> vsIcon then begin
        inc(aRect.Left);
        InflateRect(aRect, -1, 0);
      end;

{$IFDEF TNTUNICODE}
      sTemp := TTntListItem(Item).Caption;
{$ELSE}
      sTemp := Item.Caption;
{$ENDIF}
      if (vStyle = vsIcon) and not (bSelected and not bHot) then begin
        sTemp := EllipsifyEnd(Canvas.Handle, sTemp, WidthOf(aRect), HeightOf(aRect), DrawStyle);
{        aRect.Bottom := min(aRect.Bottom, iRect.Bottom);
        acGetTextExtent(Canvas.Handle, Item.Caption, Size);
        aRect.Bottom := aRect.Bottom - HeightOf(aRect) mod Size.cy - 1; // Fix of the Ellipsis problem

            if fText.Bottom > aRect.Bottom then begin
            end
            else aRect.Bottom := fText.Bottom + 2;
            aRect.Bottom := 4;}
      end;
      if (sNdx = -1) or (SkinData.CustomFont) then begin
        if bSelected and not SkinData.CustomFont then Canvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor(cdsFocused in State) else Canvas.Font.Color := Font.Color;
        AcDrawText(Canvas.Handle, sTemp, aRect, DrawStyle);
      end
      else begin
        acWriteTextEx(Canvas, PacChar(sTemp), True, aRect, DrawStyle, sNdx, Focused and not bHot, SkinData.SkinManager);
        Canvas.Font.Color := Font.Color;
      end;
      if bSelected and (Focused) and (sNdx < 0) then begin
        DrawFocusRect(Canvas.Handle, fText);
      end;

      cw := 0;
      if (StateImages <> nil) then begin
        if (Item.StateIndex >= 0) and (Item.StateIndex < StateImages.Count) and (vStyle = vsList) then begin
          cw := StateImages.Width + 2;

          cRect := CellRect;
          cRect.Left := cRect.Left;
          cRect.Right := cRect.Left + cw;

          Bmp := CreateBmp32(cw, cRect.Bottom - cRect.Top);
          BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, TAccessCanvas(Canvas).FHandle, cRect.Left, cRect.Top, SRCCOPY);
          StateImages.Draw(Bmp.Canvas, 0, 0, Item.StateIndex, True);
          BitBlt(TAccessCanvas(Canvas).FHandle, cRect.Left, cRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          FreeAndNil(Bmp);
        end;
      end
      else if CheckBoxes then begin
        if Item.Checked then CheckState := cbChecked else CheckState := cbUnChecked;

        cw := CheckWidth(SkinData.SkinManager) + 2;
        if vStyle = vsIcon then begin
          if (Item.ImageIndex > -1) and (LargeImages <> nil) then begin
            cRect := Item.DisplayRect(drIcon);
            if (Win32MajorVersion > 5) then begin // if Vista and newer
              cRect.Left := cRect.Left + (WidthOf(cRect) - LargeImages.Width - cw) div 2;
              cRect.Top := cRect.Bottom - cw;
            end
            else begin
              cRect.Left := cRect.Left + (WidthOf(cRect) - LargeImages.Width) div 2 - cw - 2;
              cRect.Top := cRect.Bottom - cw;
            end;
          end
          else begin
            cRect := CellRect;
            if (Win32MajorVersion > 5) then begin // if Vista and newer
              inc(cRect.Top, 4);
              cRect.Left := cRect.Left + (WidthOf(cRect) - cw - 2) div 2 - cw;
            end
            else begin
              cRect.Top := Item.DisplayRect(drLabel).Top - cw - 6;
              cRect.Left := cRect.Left + (WidthOf(cRect) - cw - 2) div 2 - cw;
            end;
          end;
          cRect.Bottom := cRect.Top + cw;
        end
        else begin
          cRect := CellRect;
          cRect.Left := cRect.Left + 3;
        end;
        cRect.Right := cRect.Left + cw;

        Bmp := CreateBmp32(cw, cRect.Bottom - cRect.Top);
        BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, TAccessCanvas(Canvas).FHandle, cRect.Left, cRect.Top, SRCCOPY);
        acDrawCheck(Rect(0, 0, Bmp.Width, Bmp.Height), CheckState, True, Bmp, CI, SkinData.SkinManager);
        BitBlt(TAccessCanvas(Canvas).FHandle, cRect.Left, cRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(Bmp);
      end
      else cRect.Right := iRect.Left;

      if (Item.ImageIndex > -1) then begin
        ImgList := GetImageList;
        if (ImgList <> nil) and (Item.ImageIndex < ImgList.Count) then begin
          if ListView_GetItemRect(Handle, Item.Index, aRect, LVIR_ICON) then begin

            if (Win32MajorVersion > 5) then begin // if Vista or newer
              if vStyle in [vsList, vsReport]
                then aRect.Left := aRect.Left + (WidthOf(aRect) - ImgList.Width) div 2
                else aRect.Left := aRect.Left + (WidthOf(aRect) - ImgList.Width - cw) div 2 + cw;
            end
            else begin
              aRect.Left := aRect.Left + (WidthOf(aRect) - ImgList.Width) div 2;
            end;
            aRect.Top := aRect.top + (HeightOf(aRect) - ImgList.Height) div 2;

            if not bSelected then FillDC(TAccessCanvas(Canvas).FHandle, aRect, Color);
{$IFDEF DELPHI6UP}
            if bSelected and Focused then iDrawStyle := dsFocus else iDrawStyle := dsNormal;
            ImgList.Draw(Canvas, aRect.Left, aRect.Top, Item.ImageIndex, iDrawStyle, itImage);
{$ELSE}
            ImgList.Draw(Canvas, aRect.Left, aRect.Top, Item.ImageIndex, True);
{$ENDIF}
          end
        end
      end;
      if (vStyle = vsReport) then begin
        RestoreDC(TAccessCanvas(Canvas).FHandle, SavedDC);
        nRect := CellRect;
        if GridLines and (Mouse.Capture = 0) {If column is not resized}then begin // Draw grid horz line
          ACanvas.Pen.Color := clBtnFace;
          ACanvas.MoveTo(0, nRect.Bottom - 1);
          ACanvas.LineTo(Width, nRect.Bottom - 1);
          cw := Columns[0].Width;
        end;
        for sNdx := 1 to Columns.Count - 1 do begin
          if sNdx <= Item.SubItems.Count then begin
            b := True;
            NewAdvancedCustomDrawSubItem(Self, Item, sNdx - 1, State, Stage, b, Bmp)
          end;
          if GridLines and (Mouse.Capture = 0) {If column is not resized}then begin // Draw grid vert lines
            ACanvas.MoveTo(cw, nRect.Top);
            ACanvas.LineTo(cw, nRect.Bottom);
            inc(cw, Columns[sNdx].Width);
          end;
        end;
      end;
    end;
    DefaultDraw := False;
  end;
end;

function TsCustomListView.GetImageList: TCustomImageList;
begin
  if (ViewStyle in [vsIcon]) then result := LargeImages else result := SmallImages;
end;

function TsCustomListView.ColumnLeft(Index: integer): integer;
var
  i : integer;
begin
  Result := 0;
  for i := 1 to Index do inc(Result, ListView_GetColumnWidth(Handle, i - 1));
end;

procedure TsCustomListView.InitSkinParams;
begin
  GridColor := ColorToRGB(clBtnFace);
//  GridColor := MixColors(ColorToRgb(FCommonData.SkinManager.gd[FCommonData.SkinIndex].FontColor[1]), ColorToRgb(FCommonData.SkinManager.gd[FCommonData.SkinIndex].Color), 0.15);
  iSelectIndex := SkinData.SkinManager.GetSkinIndex(s_Selection);
end;

procedure TsCustomListView.NewAdvancedCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean; Bmp: TBitmap);
var
  gRect, fText, nRect, aRect : TRect;
  ACanvas : TCanvas;
  sNdx : integer;
  DrawStyle : longint;
  iNdx : integer;
  bSelected : boolean;
  OldDC, SavedDC : hdc;
begin
  if (csDesigning in ComponentState) or (ViewStyle <> vsReport) then Exit;
  Canvas.Brush.Color := Color;
  bSelected := RowSelect and (Bmp <> nil); // RowSelect and Item.Selected;
  if Assigned(OnAdvancedCustomDrawSubItem) and not bSelected then begin
    OnAdvancedCustomDrawSubItem(Sender, Item, SubItem + 1, State, Stage, DefaultDraw);
    if not DefaultDraw then Exit;
  end;
  if Assigned(OnCustomDrawSubItem) and not bSelected then begin
    OnCustomDrawSubItem(Sender, Item, SubItem + 1, State, DefaultDraw);
    if not DefaultDraw then Exit;
  end;
  if SkinData.Skinned then if (Stage in [cdPrePaint, cdPostPaint]) then begin
    gRect := Item.DisplayRect(drBounds);
    if IsRectEmpty(gRect) then Exit;

    aRect.Left := gRect.Left + ColumnLeft(SubItem + 1);
    aRect.Right := aRect.Left + ListView_GetColumnWidth(Handle, SubItem + 1) + 4;
    if aRect.Left = aRect.Right then Exit;
    aRect.Bottom := gRect.Bottom;
    aRect.Top := gRect.Top;

    // Text rect receiving
    nRect := Item.DisplayRect(drLabel);
    iNdx := Item.SubItemImages[SubItem];
    fText.Left := aRect.Left;
    fText.Right := aRect.Right - 4;
    fText.Top := aRect.Top;
    fText.Bottom := aRect.Bottom;

    if bSelected then begin
      OffsetRect(fText, -gRect.Left, -gRect.Top);
      ACanvas := Bmp.Canvas;
    end
    else begin
      ACanvas := Canvas;
      FillDC(ACanvas.Handle, Rect(aRect.Left, fText.Top, fText.Right, fText.Bottom), Canvas.Brush.Color);
    end;

    if Assigned(SmallImages) and (iNdx <> -1) and (iNdx < SmallImages.Count) then begin
      SmallImages.Draw(ACanvas, fText.Left + 1, fText.Top + (fText.Bottom - fText.Top - SmallImages.Height) div 2, iNdx);
      inc(fText.Left, SmallImages.Width + 2);
    end;
    fText.Left := fText.Left + 3;

    DrawStyle := DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or GetStringFlags(Self, Columns[Subitem + 1].Alignment);
    if bSelected then sNdx := iSelectIndex else sNdx := -1;
    if sNdx = -1 then begin
      if not Enabled then begin
        if Bmp <> nil then begin
          ACanvas.Font.Color := AverageColor(Bmp.Canvas.Font.Color, Color);
          ACanvas.Brush.Style := bsClear;
        end
        else begin
          ACanvas.Font.Color := AverageColor(Font.Color, Color);
          ACanvas.Brush.Style := bsSolid;
        end;
      end;
      SelectObject(ACanvas.Handle, Canvas.Font.Handle);
      SetTextColor(ACanvas.Handle, Canvas.Font.Color);

      if ACanvas.Brush.Color = Color then begin
        SetBkMode(ACanvas.Handle, TRANSPARENT);
      end
      else begin // If Brush color is changed
        SetBkColor(ACanvas.Handle, ACanvas.Brush.Color);
        SetBkMode(ACanvas.Handle, OPAQUE);
      end;

      AcDrawText(ACanvas.Handle, Item.SubItems[SubItem], fText, DrawStyle);
    end
    else begin
      if Bmp <> nil then begin
        if not SkinData.CustomFont then begin
          if bSelected then begin
            Bmp.Canvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor((cdsFocused in State));
            if Assigned(OnCustomDrawSubItem) then begin
              OldDC := Canvas.Handle;
              Canvas.Handle := Bmp.Canvas.Handle;
              Canvas.Font.Color := Bmp.Canvas.Font.Color;
              Bmp.Canvas.Lock;

              SavedDC := SaveDC(Canvas.Handle);
              MoveWindowOrg(Canvas.Handle, 0, -aRect.Top);
              IntersectClipRect(Canvas.Handle, 0, 0, aRect.Right, aRect.Bottom);
              OnCustomDrawSubItem(Sender, Item, SubItem + 1, State, DefaultDraw);
              RestoreDC(Canvas.Handle, SavedDC);
              Canvas.Handle := OldDC;
              Bmp.Canvas.UnLock;
              if not DefaultDraw then Exit;
              if Canvas.Font.Color <> Bmp.Canvas.Font.Color
                then SelectObject(Bmp.Canvas.Handle, Canvas.Font.Handle)
                else SelectObject(Bmp.Canvas.Handle, Bmp.Canvas.Font.Handle);
              SetBkMode(ACanvas.Handle, TRANSPARENT);
            end;
          end
          else Bmp.Canvas.Font.Color := Font.Color;
        end
        else Bmp.Canvas.Font.Color := Canvas.Font.Color;
        if not Enabled then Bmp.Canvas.Font.Color := AverageColor(Bmp.Canvas.Font.Color, Color);
        Bmp.Canvas.Brush.Style := bsClear;
        AcDrawText(Bmp.Canvas.Handle, Item.SubItems[SubItem], fText, DrawStyle);
      end;
    end;
{!!!
    if GridLines then begin
      Bmp.Canvas.Pen.Color := GridColor;//clBtnFace;
      Bmp.Canvas.MoveTo(0, 0);
      Bmp.Canvas.LineTo(0, Bmp.Height - 1);
    end;
}
    DefaultDraw := False;
  end;
end;
{
procedure TsCustomListView.WMPaint(var Message: TWMPaint);
var
  PS : TPaintStruct;
  TopIndex, LastIndex, i : integer;
  b : boolean;
  SavedDC : hdc;
  TopRect : TRect;
  Orig : TPoint;
  x, y, w, h, ItemHeight : integer;
  appr1, appr2 : DWORD;
begin
  inherited;
  if GridLines and (ViewStyle = vsReport) then begin // Redraw grid lines
    if Message.DC <> 0 then Canvas.Handle := Message.DC;
    Canvas.Pen.Color := GridColor;
    ListView_GetOrigin(Handle, Orig);
    if Items.Count > 0 then begin
      if RowSelect and (ItemIndex >= 0) then begin
        TopRect := Items[ItemIndex].DisplayRect(drBounds);
        ExcludeClipRect(Canvas.Handle, TopRect.Left, TopRect.Top, TopRect.Right, TopRect.Bottom);
      end;

      TopIndex := ListView_GetTopIndex(Handle);
      TopRect := Items[TopIndex].DisplayRect(drBounds);
      X := TopRect.Left;
      ItemHeight := HeightOf(TopRect);
    end
    else begin
      X := 0;
      appr1 := ListView_ApproximateViewRect(Handle, Width, Height, 1);
      appr2 := ListView_ApproximateViewRect(Handle, Width, Height, 2);
      ItemHeight := HiWord(appr2) - HiWord(appr1); // Height of Item
    end;
    if Columns.Count > 0 then begin
      for i := 1 to Columns.Count do begin
        inc(X, Columns[i - 1].Width);
        Canvas.MoveTo(X, 0);
        Canvas.LineTo(X, Height);
      end;
    end;
    y := ItemHeight + 2;
    while y < Height do begin
      Canvas.MoveTo(0, y);
      Canvas.LineTo(Width, y);
      inc(y, ItemHeight);
    end;
  end;
end;
}
procedure TsCustomListView.DoBeginColumnResize(columnIndex, columnWidth: integer);
begin
  if Assigned(FBeginColumnResizeEvent ) then FBeginColumnResizeEvent(Self, ColumnIndex, ColumnWidth);
end;

procedure TsCustomListView.DoColumnResize(ColumnIndex, ColumnWidth: integer);
begin
  if Assigned(FColumnResizeEvent ) then FColumnResizeEvent(Self, ColumnIndex, ColumnWidth);
end;

procedure TsCustomListView.DoEndColumnResize(ColumnIndex, ColumnWidth: integer);
begin
  if Assigned(FEndColumnResizeEvent) then FEndColumnResizeEvent(Self, ColumnIndex, ColumnWidth);
end;

function TsCustomListView.FindColumnIndex(pHeader: pNMHdr): integer;
var
  hwndHeader: HWND;
  iteminfo: THdItem;
  itemindex: Integer;
  buf: array [0..128] of Char;
begin
  Result := -1;
  hwndHeader := pHeader^.hwndFrom;
  itemindex  := pHDNotify(pHeader)^.Item;
  FillChar(iteminfo, sizeof(iteminfo), 0);

  iteminfo.Mask := HDI_TEXT;
  iteminfo.pszText := buf;
  iteminfo.cchTextMax := sizeof(buf)-1;

  Header_GetItem( hwndHeader, itemindex, iteminfo );

  if CompareStr(Columns[itemindex].Caption, iteminfo.pszText ) = 0 then
    Result := itemindex
  else
  begin
    for itemindex := 0 to Columns.count-1 Do
     If CompareStr(Columns[itemindex].Caption, iteminfo.pszText ) = 0 then
     begin
       Result := itemindex;
       Break;
     end;
  end;
end;

function TsCustomListView.FindColumnWidth(pHeader: pNMHdr): integer;
begin
  Result := -1;
  if Assigned(PHDNotify( pHeader )^.pItem ) aND ((PHDNotify( pHeader )^.pItem^.mask and HDI_WIDTH) <> 0) then
    Result := PHDNotify( pHeader )^.pItem^.cxy;
end;

procedure TsCustomListView.WMNotify(var msg: TWMNotify);
begin
  inherited;
  case msg.NMHdr^.code Of
    HDN_ENDTRACK:
      DoEndColumnResize(FindColumnIndex(msg.NMHdr), FindColumnWidth(msg.NMHdr));
    HDN_BEGINTRACK:
      DoBeginColumnResize(FindColumnIndex(msg.NMHdr), FindColumnWidth(msg.NMHdr));
    HDN_TRACK:
      DoColumnResize(FindColumnIndex(msg.NMHdr), FindColumnWidth(msg.NMHdr));
  end;end;

end.
