{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       SmartFlash                                                  }
{       Version 3.40                                                }
{                                                                   }
{       Copyright (c) 2000-2013 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit sf_flash;

interface

{$R-,T-,H+,X+}
{$I sf_define.inc}
//{$DEFINE FlashTrial}
//{$DEFINE FLASHTOPNG}

uses {$IFDEF AL_COMPILER6_UP} Variants, {$ENDIF} Windows, Messages, ActiveX, SysUtils, Classes, Controls, Forms,
  ImgList, Menus, Graphics, ComObj, AxCtrls, sf_bitmap, sf_utils{$IFDEF AL_COMPILER7_UP},OLECtrls{$ENDIF},
  {$IFDEF FLASHTOPNG}sf_PngImage, {$IFDEF VER200}PngImage, {$ENDIF} {$ENDIF}
  Jpeg, UrlMon;

const
  DVASPECT_TRANSPARENT = 32;
  DVASPECT_OPAQUE = 16;
  
// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ShockwaveFlashObjectsMajorVersion = 1;
  ShockwaveFlashObjectsMinorVersion = 0;

  LIBID_ShockwaveFlashObjects: TGUID = '{D27CDB6B-AE6D-11CF-96B8-444553540000}';

  IID_IShockwaveFlash: TGUID = '{D27CDB6C-AE6D-11CF-96B8-444553540000}';
  DIID__IShockwaveFlashEvents: TGUID = '{D27CDB6D-AE6D-11CF-96B8-444553540000}';
  CLASS_ShockwaveFlash: TGUID = '{D27CDB6E-AE6D-11CF-96B8-444553540000}';
  CLASS_FlashProp: TGUID = '{1171A62F-05D2-11D1-83FC-00A0C9089C5A}';
  IID_IFlashFactory: TGUID = '{D27CDB70-AE6D-11CF-96B8-444553540000}';
  IID_IDispatchEx: TGUID = '{A6EF9860-C720-11D0-9337-00A0C90DCAA9}';
  IID_IFlashObjectInterface: TGUID = '{D27CDB72-AE6D-11CF-96B8-444553540000}';
  IID_IServiceProvider: TGUID = '{6D5140C1-7436-11CE-8034-00AA006009FA}';
  CLASS_FlashObjectInterface: TGUID = '{D27CDB71-AE6D-11CF-96B8-444553540000}';

type

//============================================================================
  LongWord = Integer;

  IDropTarget = interface;
  IViewObject = interface;
  IEnumUnknown = interface;
  IBindCtx = interface;
  IOleContainer_Flash = interface;
  IOleClientSite_Flash = interface;
  IParseDisplayName = interface;
  IMoniker_Flash = interface;
  IRunningObjectTable = interface;
  IEnumMoniker = interface;
  IEnumString = interface;
  IOleInPlaceSiteEx = interface;

//============================================================================
// interface IOleInPlaceSiteEx

  IOleInPlaceSiteEx = interface(IOleInPlaceSite)
    ['{9C2CAD80-3424-11CF-B670-00AA004CD6D8}']
    function OnInPlaceActivateEx(fNoRedraw: PBOOL;
       dwFlags: DWORD): HResult; stdcall;
    function OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult; stdcall;
    function RequestUIActivate: HResult; stdcall;
  end;

//============================================================================

//  IOleInPlaceActiveObject = interface;

  IEnumString = interface(IUnknown)
    ['{00000101-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumString): HResult; stdcall;
  end;

  PIMoniker_Flash = ^IMoniker_Flash;
  IEnumMoniker = interface(IUnknown)
    ['{00000102-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumMoniker): HResult; stdcall;
  end;

  IRunningObjectTable = interface(IUnknown)
    ['{00000010-0000-0000-C000-000000000046}']
    function Register(grfFlags: Longint; const unkObject: IUnknown;
      const mkObjectName: IMoniker_Flash; out dwRegister: Longint): HResult; stdcall;
    function Revoke(dwRegister: Longint): HResult; stdcall;
    function IsRunning(const mkObjectName: IMoniker_Flash): HResult; stdcall;
    function GetObject(const mkObjectName: IMoniker_Flash;
      out unkObject: IUnknown): HResult; stdcall;
    function NoteChangeTime(dwRegister: Longint;
      const filetime: TFileTime): HResult; stdcall;
    function GetTimeOfLastChange(const mkObjectName: IMoniker_Flash;
      out filetime: TFileTime): HResult; stdcall;
    function EnumRunning(out enumMoniker: IEnumMoniker): HResult; stdcall;
  end;

  IOleObject_Flash = interface(IUnknown)
    ['{00000112-0000-0000-C000-000000000046}']
    function SetClientSite(const clientSite: IOleClientSite_Flash): HResult;
      stdcall;
    function GetClientSite(out clientSite: IOleClientSite_Flash): HResult;
      stdcall;
    function SetHostNames(szContainerApp: POleStr;
      szContainerObj: POleStr): HResult; stdcall;
    function Close(dwSaveOption: Longint): HResult; stdcall;
    function SetMoniker(dwWhichMoniker: Longint; const mk: IMoniker_Flash): HResult;
      stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker_Flash): HResult; stdcall;
    function InitFromData(const dataObject: IDataObject; fCreation: BOOL;
      dwReserved: Longint): HResult; stdcall;
    function GetClipboardData(dwReserved: Longint;
      out dataObject: IDataObject): HResult; stdcall;
    function DoVerb(iVerb: Longint; msg: PMsg; const activeSite: IOleClientSite_Flash;
      lindex: Longint; hwndParent: HWND; const posRect: TRect): HResult;
      stdcall;
    function EnumVerbs(out enumOleVerb: IEnumOleVerb): HResult; stdcall;
    function Update: HResult; stdcall;
    function IsUpToDate: HResult; stdcall;
    function GetUserClassID(out clsid: TCLSID): HResult; stdcall;
    function GetUserType(dwFormOfType: Longint; out pszUserType: POleStr): HResult;
      stdcall;
    function SetExtent(dwDrawAspect: Longint; const size: TPoint): HResult;
      stdcall;
    function GetExtent(dwDrawAspect: Longint; out size: TPoint): HResult;
      stdcall;
    function Advise(const advSink: IAdviseSink; out dwConnection: Longint): HResult;
      stdcall;
    function Unadvise(dwConnection: Longint): HResult; stdcall;
    function EnumAdvise(out enumAdvise: IEnumStatData): HResult; stdcall;
    function GetMiscStatus(dwAspect: Longint; out dwStatus: Longint): HResult;
      stdcall;
    function SetColorScheme(const logpal: TLogPalette): HResult; stdcall;
  end;

//============================================================================
// interface IDropTarget

  IDropTarget = interface(IUnknown)
    ['{00000122-0000-0000-C000-000000000046}']
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  end;

//============================================================================

//============================================================================
// interface IViewObject

  IViewObject = interface(IUnknown)
    ['{0000010D-0000-0000-C000-000000000046}']
    function Draw(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      ptd: PDVTargetDevice; hicTargetDev: HDC; hdcDraw: HDC;
      prcBounds: PRect; prcWBounds: PRect; fnContinue: TContinueFunc;
      dwContinue: Longint): HResult; stdcall;
    function GetColorSet(dwDrawAspect: Longint; lindex: Longint;
      pvAspect: Pointer; ptd: PDVTargetDevice; hicTargetDev: HDC;
      out colorSet: PLogPalette): HResult; stdcall;
    function Freeze(dwDrawAspect: Longint; lindex: Longint; pvAspect: Pointer;
      out dwFreeze: Longint): HResult; stdcall;
    function Unfreeze(dwFreeze: Longint): HResult; stdcall;
    function SetAdvise(aspects: Longint; advf: Longint;
      const advSink: IAdviseSink): HResult; stdcall;
    function GetAdvise(pAspects: PLongint; pAdvf: PLongint;
      out advSink: IAdviseSink): HResult; stdcall;
  end;
//============================================================================

//============================================================================
// interface IEnumUnknown

  IEnumUnknown = interface(IUnknown)
    ['{00000100-0000-0000-C000-000000000046}']
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumUnknown): HResult; stdcall;
  end;
//============================================================================

//============================================================================
// interface IBindCtx

  PBindOpts = ^TBindOpts;
  TBindOpts = record
    cbStruct: Longint;
    grfFlags: Longint;
    grfMode: Longint;
    dwTickCountDeadline: Longint;
  end;

  IBindCtx = interface(IUnknown)
    ['{0000000E-0000-0000-C000-000000000046}']
    function RegisterObjectBound(const unk: IUnknown): HResult; stdcall;
    function RevokeObjectBound(const unk: IUnknown): HResult; stdcall;
    function ReleaseBoundObjects: HResult; stdcall;
    function SetBindOptions(const bindopts: TBindOpts): HResult; stdcall;
    function GetBindOptions(var bindopts: TBindOpts): HResult; stdcall;
    function GetRunningObjectTable(out rot: IRunningObjectTable): HResult;
      stdcall;
    function RegisterObjectParam(pszKey: POleStr; const unk: IUnknown): HResult;
      stdcall;
    function GetObjectParam(pszKey: POleStr; out unk: IUnknown): HResult;
      stdcall;
    function EnumObjectParam(out pEnumString: IEnumString): HResult; stdcall;
    function RevokeObjectParam(pszKey: POleStr): HResult; stdcall;
  end;
//============================================================================

  IParseDisplayName = interface(IUnknown)
    ['{0000011A-0000-0000-C000-000000000046}']
    function ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr;
      out chEaten: Longint; out mkOut: IMoniker_Flash): HResult; stdcall;
  end;

  IOleContainer_Flash = interface(IParseDisplayName)
    ['{0000011B-0000-0000-C000-000000000046}']
    function EnumObjects(grfFlags: Longint; out pEnumUnknown: IEnumUnknown): HResult;
      stdcall;
    function LockContainer(fLock: BOOL): HResult; stdcall;
  end;

  IOleClientSite_Flash = interface(IUnknown)
    ['{00000118-0000-0000-C000-000000000046}']
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker_Flash): HResult; stdcall;
    function GetContainer(out container: IOleContainer_Flash): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
  end;

  IMoniker_Flash = interface(IPersistStream)
    ['{0000000F-0000-0000-C000-000000000046}']
    function BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      const iidResult: TIID; out vResult): HResult; stdcall;
    function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      const iid: TIID; out vObj): HResult; stdcall;
    function Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker_Flash; out mkReduced: IMoniker_Flash): HResult; stdcall;
    function ComposeWith(const mkRight: IMoniker_Flash; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker_Flash): HResult; stdcall;
    function Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
      stdcall;
    function IsEqual(const mkOtherMoniker: IMoniker_Flash): HResult; stdcall;
    function Hash(out dwHash: Longint): HResult; stdcall;
    function IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      const mkNewlyRunning: IMoniker_Flash): HResult; stdcall;
    function GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      out filetime: TFileTime): HResult; stdcall;
    function Inverse(out mk: IMoniker_Flash): HResult; stdcall;
    function CommonPrefixWith(const mkOther: IMoniker_Flash;
      out mkPrefix: IMoniker_Flash): HResult; stdcall;
    function RelativePathTo(const mkOther: IMoniker_Flash;
      out mkRelPath: IMoniker_Flash): HResult; stdcall;
    function GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      out pszDisplayName: POleStr): HResult; stdcall;
    function ParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_Flash;
      pszDisplayName: POleStr; out chEaten: Longint;
      out mkOut: IMoniker_Flash): HResult; stdcall;
    function IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
  end;

//============================================================================
// interface DShockwaveFlashEvents

  DShockwaveFlashEvents = interface(IDispatch)
    ['{d27cdb6d-ae6d-11cf-96b8-444553540000}']
  end;

// interface IOleInPlaceSiteWindowless

  IOleInPlaceSiteWindowless = interface(IOleInPlaceSiteEx)
    ['{922EADA0-3424-11CF-B670-00AA004CD6D8}']
    function CanWindowlessActivate: HResult; stdcall;
    function GetCapture: HResult; stdcall;
    function SetCapture(fCapture: BOOL): HResult; stdcall;
    function GetFocus: HResult; stdcall;
    function SetFocus(fFocus: BOOL): HResult; stdcall;
    function GetDC(var Rect: TRect; qrfFlags: DWORD;
       var hDC: HDC): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function InvalidateRect(Rect: PRect; fErase: BOOL): HResult; stdcall;
    function InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult; stdcall;
    function ScrollRect(dx, dy: Integer; var RectScroll: TRect;
       var RectClip: TRect): HResult; stdcall;
    function AdjustRect(var rc: TRect): HResult; stdcall;
    function OnDefWindowMessage(msg: LongWord; wParam: WPARAM;
       lParam: LPARAM; var LResult: LRESULT): HResult; stdcall;
  end;

// interface IOleInPlaceObjectWindowless

  IOleInPlaceObjectWindowless = interface(IOleInPlaceObject)
    ['{1C2056CC-5EF4-101B-8BC8-00AA003E3B29}']
    function OnWindowMessage(msg: LongWord; wParam: WPARAM; lParam: LPARAM;
        var lResult: LRESULT): HResult; stdcall;
    function OnDropTarget(var pDropTarget: IDropTarget):HResult ; stdcall;
  end;

  TsfOleControl = class;

  TEventDispatch = class(TObject, IUnknown, IDispatch)
  private
    FControl: TsfOleControl;
  protected
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    property Control: TsfOleControl read FControl;
  public
    constructor Create(Control: TsfOleControl);
  end;

  TEnumValue = record
    Value: Longint;
    Ident: string;
  end;

  PEnumValueList = ^TEnumValueList;
  TEnumValueList = array[0..32767] of TEnumValue;

  TEnumPropDesc = class
  private
    FDispID: Integer;
    FValueCount: Integer;
    FValues: PEnumValueList;
  public
    constructor Create(DispID, ValueCount: Integer;
      const TypeInfo: ITypeInfo);
    destructor Destroy; override;
    procedure GetStrings(Proc: TGetStrProc);
    function StringToValue(const S: string): Integer;
    function ValueToString(V: Integer): string;
  end;

  PControlData = ^TControlData;
  TControlData = record
    ClassID: TGUID;
    EventIID: TGUID;
    EventCount: Longint;
    EventDispIDs: Pointer;
    LicenseKey: Pointer;
    Flags: DWORD;
    Version: Integer;
    FontCount: Integer;
    FontIDs: PDispIDList;
    PictureCount: Integer;
    PictureIDs: PDispIDList;
    Reserved: Integer;
    InstanceCount: Integer;
    EnumPropDescs: TList;
  end;

  PControlData2 = ^TControlData2;
  TControlData2 = record
    ClassID: TGUID;
    EventIID: TGUID;
    EventCount: Longint;
    EventDispIDs: Pointer;
    LicenseKey: Pointer;
    Flags: DWORD;
    Version: Integer;
    FontCount: Integer;
    FontIDs: PDispIDList;
    PictureCount: Integer;
    PictureIDs: PDispIDList;
    Reserved: Integer;
    InstanceCount: Integer;
    EnumPropDescs: TList;
    FirstEventOfs: Cardinal;
  end;

  IBinding = interface
    ['{79eac9c0-baf9-11ce-8c82-00aa004ba90b}']
    function Abort: HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function SetPriority(nPriority: Longint): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function GetBindResult(out clsidProtocol: TCLSID; out dwResult: DWORD;
      out szResult: POLEStr; dwReserved: DWORD): HResult; stdcall;
  end;

  PBindInfo = ^TBindInfo;
  {$EXTERNALSYM _tagBINDINFO}
  _tagBINDINFO = packed record
    cbSize: ULONG;
    szExtraInfo: LPWSTR;
    stgmedData: TStgMedium;
    grfBindInfoF: DWORD;
    dwBindVerb: DWORD;
    szCustomVerb: LPWSTR;
    cbstgmedData: DWORD;
    dwOptions: DWORD;
    dwOptionsFlags: DWORD;
    dwCodePage: DWORD;
    securityAttributes: TSecurityAttributes;
    iid: TGUID;
    pUnk: IUnknown;
    dwReserved: DWORD;
  end;
  TBindInfo = _tagBINDINFO;
  {$EXTERNALSYM BINDINFO}
  BINDINFO = _tagBINDINFO;

  IBindStatusCallback = interface
    ['{79eac9c1-baf9-11ce-8c82-00aa004ba90b}']
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;
      szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;
      var stgmed: TStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
  end;

  IBindHost = interface
    ['{fc4801a1-2ba9-11cf-a229-00aa003d7352}']
    function CreateMoniker(pszName: POLEStr; BC: IBindCtx; out mk: IMoniker_flash; dwReserved: DWORD): HResult; stdcall;
    function MonikerBindToStorage(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
      const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
    function MonikerBindToObject(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
      const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
  end;

  TsfFlashList = class;
  
  TsfOleControl = class(TGraphicControl, IUnknown, IOleClientSite_Flash,
    IOleControlSite, IOleWindow, IOleInPlaceSite, IOleInPlaceSiteWindowless,
    IOleInPlaceFrame, IDispatch, IOleInPlaceUIWindow,
    IPropertyNotifySink, IParseDisplayName,
    IMoniker_Flash, IServiceProvider)
  private
    FGrabProcess: boolean;
    FInLoading: Boolean;
    FResizing: boolean;
    FRefCount: Longint;
    FControlData: PControlData;
    FEventDispatch: TEventDispatch;
    FObjectData: HGlobal;
    FOleObject: IOleObject_Flash;
    FPersistStream: IPersistStreamInit;
    FControlDispatch: IDispatch;
    FPropBrowsing: IPerPropertyBrowsing;
    FViewObject: IViewObject;
    FPropConnection: Longint;
    FEventsConnection: Longint;
    FMiscStatus: Longint;
    FFonts: TList;
    FPictures: TList;
    FUpdatingPictures: Boolean;
    FUpdatingColor: Boolean;
    FUpdatingFont: Boolean;
    FUpdatingEnabled: Boolean;
    FTransparent: boolean;
    FDisableFlashPopup: boolean;
    FDisableFlashCursor: boolean;
    { paint }
    FBackBuffer, FBuffer, FBuffer2: TsfBitmap;
    FPaintRect: PRect;
    FNeedUpdate: boolean;
    {flash path}
    FFlashPath: ansistring;
    { TsfOleControl }
    procedure CreateControl;
    procedure CreateEnumPropDescs;
    procedure CreateInstance;
    procedure CreateStorage;
    procedure DesignModified;
    procedure DestroyControl;
    procedure DestroyEnumPropDescs;
    procedure DestroyStorage;
    procedure GetEventMethod(DispID: TDispID; var Method: TMethod);
    function GetMainMenu: TMainMenu;
    function GetOleObject: Variant;
    function GetDefaultDispatch: IDispatch;
    procedure HookControlWndProc;
    procedure ReadData(Stream: TStream);
    procedure SetUIActive(Active: Boolean);
    procedure WriteData(Stream: TStream);
    procedure CMDocWindowActivate(var Message: TMessage); message CM_DOCWINDOWACTIVATE;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMDialogKey(var Message: TMessage); message CM_DIALOGKEY;
    procedure CMUIActivate(var Message: TMessage); message CM_UIACTIVATE;
    procedure CMUIDeactivate(var Message: TMessage); message CM_UIDEACTIVATE;
    procedure D2InvokeEvent(DispID: TDispID; var Params: TDispParams);

    function GetParentHandle: HWnd;
    procedure SetTransparent(const Value: boolean);
    procedure SetDisableFlashPopup(const Value: boolean);
  protected
    FOleControl: IOleControl;
    FOleInPlaceObject: IOleInPlaceObject;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;
    FFlashNotExists: boolean;
    FPaintBackground: boolean;
    FOnPaint: TNotifyEvent;
    FCaptured: boolean;
    FFocused: boolean;
    FNeedHandle: boolean;
    FFlashList: TsfFlashList;
    FFlashIndex: integer;
    Furl: widestring;
    procedure StandardEvent(DispID: TDispID; var Params: TDispParams); virtual;
    procedure InvokeEvent(DispID: TDispID; var Params: TDispParams); virtual;
    { TControl }
    procedure AdjustSize; override;
    { IServiceProvider }
    function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
    { IPersist }
    function GetClassID(out classID: TCLSID): HResult; stdcall;
    { IPersistentStream }
    function IsDirty: HResult; stdcall;
    function Load(const stm: IStream): HResult; stdcall;
    function Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
    function GetSizeMax(out cbSize: Largeint): HResult; stdcall;
    { IMoniker }
    function BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      const iidResult: TIID; out vResult): HResult; stdcall;
    function BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      const iid: TIID; out vObj): HResult; stdcall;
    function Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
      mkToLeft: PIMoniker_flash; out mkReduced: IMoniker_flash): HResult; stdcall;
    function ComposeWith(const mkRight: IMoniker_flash; fOnlyIfNotGeneric: BOOL;
      out mkComposite: IMoniker_flash): HResult; stdcall;
    function Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
      stdcall;
    function IsEqual(const mkOtherMoniker: IMoniker_flash): HResult; stdcall;
    function Hash(out dwHash: Longint): HResult; stdcall;
    function IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      const mkNewlyRunning: IMoniker_flash): HResult; stdcall;
    function GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      out filetime: TFileTime): HResult; stdcall;
    function Inverse(out mk: IMoniker_flash): HResult; stdcall;
    function CommonPrefixWith(const mkOther: IMoniker_flash;
      out mkPrefix: IMoniker_flash): HResult; stdcall;
    function RelativePathTo(const mkOther: IMoniker_flash;
      out mkRelPath: IMoniker_flash): HResult; stdcall;
    function GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      out pszDisplayName: POleStr): HResult; stdcall;
    function IMoniker_flash.ParseDisplayName = IMonikerParseDisplayName;
    function IMonikerParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
      pszDisplayName: POleStr; out chEaten: Longint;
      out mkOut: IMoniker_flash): HResult; stdcall;
    function IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; override;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IParseDysplayName }
    function ParseDisplayName(const bc: IBindCtx; pszDisplayName: POleStr;
      out chEaten: Longint; out mkOut: IMoniker_Flash): HResult; stdcall;
    { IOleClientSite_Flash }
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker_Flash): HResult; stdcall;
    function GetContainer(out container: IOleContainer_Flash): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;
    { IOleControlSite }
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF;
      flags: Longint): HResult; stdcall;
    function IOleControlSite.TranslateAccelerator = OleControlSite_TranslateAccelerator;
    function OleControlSite_TranslateAccelerator(msg: PMsg;
      grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;
    { IOleWindow }
    function GetWindow(out WindowHandle: HWnd): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
    { IOleInPlaceSite }
    function IOleInPlaceSiteWindowless.GetWindow = OleInPlaceSite_GetWindow;
    function OleInPlaceSite_GetWindow(out wnd: HWnd): HResult; stdcall;
    function CanInPlaceActivate: HResult; stdcall;
    function OnInPlaceActivate: HResult; stdcall;
    function OnUIActivate: HResult; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame;
      out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
      out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
      stdcall;
    function Scroll(scrollExtent: TPoint): HResult; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
    function OnInPlaceDeactivate: HResult; stdcall;
    function DiscardUndoState: HResult; stdcall;
    function DeactivateAndUndo: HResult; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;
    { IOleInPlaceSiteEx }
    function OnInPlaceActivateEx(fNoRedraw: PBOOL; dwFlags: DWORD): HResult; stdcall;
    function OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult; stdcall;
    function RequestUIActivate: HResult; stdcall;
    { IOleInPlaceSiteWindowless }
    function CanWindowlessActivate: HResult; stdcall;
    function GetCapture: HResult; stdcall;
    function SetCapture(ACapture: BOOL): HResult; stdcall;
    function GetFocus: HResult; stdcall;
    function SetFocus(fFocus: BOOL): HResult; stdcall;
    function GetDC(var rc: TRect; qrfFlags: DWORD; var hDC: HDC): HResult; stdcall;
    function ReleaseDC(hDC: HDC): HResult; stdcall;
    function InvalidateRect(Rect: PRect; fErase: BOOL): HResult; stdcall;
    function InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult; stdcall;
    function ScrollRect(dx, dy: Integer; var RectScroll: TRect; var RectClip: TRect): HResult; stdcall;
    function AdjustRect(var rc: TRect): HResult; stdcall;
    function OnDefWindowMessage(msg: LongWord; wParam: WPARAM; lParam: LPARAM; var LResult: LRESULT): HResult; stdcall;
    { IOleInPlaceUIWindow }
    function GetBorder(out rectBorder: TRect): HResult; stdcall;
    function RequestBorderSpace(const borderwidths: TRect): HResult; stdcall;
    function SetBorderSpace(pborderwidths: PRect): HResult; stdcall;
    function SetActiveObject(const activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; stdcall;
    { IOleInPlaceFrame }
    function IOleInPlaceFrame.GetWindow = OleInPlaceFrame_GetWindow;
    function OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult; stdcall;
    function InsertMenus(hmenuShared: HMenu;
      var menuWidths: TOleMenuGroupWidths): HResult; stdcall;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWnd): HResult; stdcall;
    function RemoveMenus(hmenuShared: HMenu): HResult; stdcall;
    function SetStatusText(pszStatusText: POleStr): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
    function IOleInPlaceFrame.TranslateAccelerator = OleInPlaceFrame_TranslateAccelerator;
    function OleInPlaceFrame_TranslateAccelerator(var msg: TMsg;
      wID: Word): HResult; stdcall;
    { IDispatch }
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    { ISimpleFrameSite }
    function PreMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
      out res: Integer; out Cookie: Longint): HResult; stdcall;
    function PostMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
      out res: Integer; Cookie: Longint): HResult; stdcall;
    { TsfOleControl }
    procedure CreateWnd; //override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DestroyWindowHandle; //override;
    function GetByteProp(Index: Integer): Byte;
    function GetColorProp(Index: Integer): TColor;
    function GetTColorProp(Index: Integer): TColor;
    function GetCompProp(Index: Integer): Comp;
    function GetCurrencyProp(Index: Integer): Currency;
    function GetDoubleProp(Index: Integer): Double;
    function GetIDispatchProp(Index: Integer): IDispatch;
    function GetIntegerProp(Index: Integer): Integer;
    function GetIUnknownProp(Index: Integer): IUnknown;
    function GetWordBoolProp(Index: Integer): WordBool;
    function GetTDateTimeProp(Index: Integer): TDateTime;
    function GetTFontProp(Index: Integer): TFont;
    function GetOleBoolProp(Index: Integer): TOleBool;
    function GetOleDateProp(Index: Integer): TOleDate;
    function GetOleEnumProp(Index: Integer): TOleEnum;
    function GetTOleEnumProp(Index: Integer): TOleEnum;
    function GetOleVariantProp(Index: Integer): OleVariant;
    function GetTPictureProp(Index: Integer): TPicture;
    procedure GetProperty(Index: Integer; var Value: TVarData);
    function GetShortIntProp(Index: Integer): ShortInt;
    function GetSingleProp(Index: Integer): Single;
    function GetSmallintProp(Index: Integer): Smallint;
    function GetStringProp(Index: Integer): string;
    function GetVariantProp(Index: Integer): Variant;
    function GetWideStringProp(Index: Integer): WideString;
    function GetWordProp(Index: Integer): Word;
    procedure InitControlData; virtual; abstract;
    procedure InitControlInterface(const Obj: IUnknown); virtual;
    procedure InvokeMethod(const DispInfo; Result: Pointer);
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure PictureChanged(Sender: TObject);
    procedure SetByteProp(Index: Integer; Value: Byte);
    procedure SetColorProp(Index: Integer; Value: TColor);
    procedure SetTColorProp(Index: Integer; Value: TColor);
    procedure SetCompProp(Index: Integer; const Value: Comp);
    procedure SetCurrencyProp(Index: Integer; const Value: Currency);
    procedure SetDoubleProp(Index: Integer; const Value: Double);
    procedure SetIDispatchProp(Index: Integer; const Value: IDispatch);
    procedure SetIntegerProp(Index: Integer; Value: Integer);
    procedure SetIUnknownProp(Index: Integer; const Value: IUnknown);
    procedure SetName(const Value: TComponentName); override;
    procedure SetWordBoolProp(Index: Integer; Value: WordBool);
    procedure SetTDateTimeProp(Index: Integer; const Value: TDateTime);
    procedure SetTFontProp(Index: Integer; Value: TFont);
    procedure SetOleBoolProp(Index: Integer; Value: TOleBool);
    procedure SetOleDateProp(Index: Integer; const Value: TOleDate);
    procedure SetOleEnumProp(Index: Integer; Value: TOleEnum);
    procedure SetTOleEnumProp(Index: Integer; Value: TOleEnum);
    procedure SetOleVariantProp(Index: Integer; const Value: OleVariant);
    procedure SetParent(AParent: TWinControl); override;
    procedure SetTPictureProp(Index: Integer;  Value: TPicture);
    procedure SetProperty(Index: Integer; const Value: TVarData);
    procedure SetShortIntProp(Index: Integer; Value: Shortint);
    procedure SetSingleProp(Index: Integer; const Value: Single);
    procedure SetSmallintProp(Index: Integer; Value: Smallint);
    procedure SetStringProp(Index: Integer; const Value: string);
    procedure SetVariantProp(Index: Integer; const Value: Variant);
    procedure SetWideStringProp(Index: Integer; const Value: WideString);
    procedure SetWordProp(Index: Integer; Value: Word);
    procedure _SetColorProp(Index: Integer; Value: TColor);
    procedure _SetTColorProp(Index: Integer; Value: TColor);
    procedure _SetTOleEnumProp(Index: Integer; Value: TOleEnum);
    procedure _SetTFontProp(Index: Integer; Value: TFont);
    procedure _SetTPictureProp(Index: Integer; Value: TPicture);
    procedure WndProc(var Message: TMessage); override;
    function SuppressException(E : Exception): Boolean; virtual;
    property ControlData: PControlData read FControlData write FControlData;
    { IPropertyNotifySink }
    function OnChanged(dispid: TDispID): HResult; virtual; stdcall;
    function OnRequestEdit(dispid: TDispID): HResult; virtual; stdcall;
    procedure PaintBackground;
    procedure Paint; override;
    procedure Loaded; override;
    //
    function GrabCurrentFrame: TBitmap;
    function GrabCurrentFrameToJPG: TJpegImage;

    //
    procedure PaintFrame;
  public
    FOleInPlaceObjectWindowless: IOleInPlaceObjectWindowless;
    function GrabCurrentFrame2: TsfBitmap;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BrowseProperties;
    procedure DefaultHandler(var Message); override;
    procedure DoObjectVerb(Verb: Integer);
    function GetEnumPropDesc(DispID: Integer): TEnumPropDesc;
    function GetHelpContext(Member: string; var HelpCtx: Integer;
      var HelpFile: string): Boolean;
    procedure GetObjectVerbs(List: TStrings);
    function GetPropDisplayString(DispID: Integer): string;
    procedure GetPropDisplayStrings(DispID: Integer; List: TStrings);
    function IsCustomProperty(DispID: Integer): Boolean;
    function IsPropPageProperty(DispID: Integer): Boolean;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetPropDisplayString(DispID: Integer; const Value: string);
    procedure ShowAboutBox;

    procedure GrabFrame(ACanvas: TCanvas);

    property OleObject: Variant read GetOleObject;
    property PerPropBrowsing: IPerPropertyBrowsing read FPropBrowsing;
    property DefaultDispatch: IDispatch read GetDefaultDispatch;
    property Anchors;
    property GrabProcess: boolean read FGrabProcess write FGrabProcess;
  published
    property Color;
    property ParentColor;
    property Transparent: boolean read FTransparent write SetTransparent default true;
    property DisableFlashPopup: boolean read FDisableFlashPopup write SetDisableFlashPopup default false;
    property DisableFlashCursor: boolean read FDisableFlashCursor write FDisableFlashCursor default false;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnClick;
  end;

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IShockwaveFlash = interface;
  IShockwaveFlashDisp = dispinterface;
  _IShockwaveFlashEvents = dispinterface;
  IFlashFactory = interface;
  IDispatchEx = interface;
  IFlashObjectInterface = interface;
  IServiceProvider = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  ShockwaveFlash = IShockwaveFlash;
  FlashProp = IUnknown;
  FlashObjectInterface = IFlashObjectInterface;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^DISPPARAMS; {*}
  PSYSUINT1 = ^SYSUINT; {*}
  PUserType2 = ^TGUID; {*}


// *********************************************************************//
// Interface: IShockwaveFlash
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlash = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
    function Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const pVal: WideString); safecall;
    function Get_MovieData: WideString; safecall;
    procedure Set_MovieData(const pVal: WideString); safecall;
    function Get_InlineData: IUnknown; safecall;
    procedure Set_InlineData(const ppIUnknown: IUnknown); safecall;
    function Get_SeamlessTabbing: WordBool; safecall;
    procedure Set_SeamlessTabbing(pVal: WordBool); safecall;
    procedure EnforceLocalSecurity; safecall;
    function Get_Profile: WordBool; safecall;
    procedure Set_Profile(pVal: WordBool); safecall;
    function Get_ProfileAddress: WideString; safecall;
    procedure Set_ProfileAddress(const pVal: WideString); safecall;
    function Get_ProfilePort: Integer; safecall;
    procedure Set_ProfilePort(pVal: Integer); safecall;
    function CallFunction(const request: WideString): WideString; safecall;
    procedure SetReturnValue(const returnValue: WideString); safecall;
    procedure DisableLocalSecurity; safecall;
    function Get_AllowNetworking: WideString; safecall;
    procedure Set_AllowNetworking(const pVal: WideString); safecall;
    function Get_AllowFullScreen: WideString; safecall;
    procedure Set_AllowFullScreen(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property Scale: WideString read Get_Scale write Set_Scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property FlashVars: WideString read Get_FlashVars write Set_FlashVars;
    property AllowScriptAccess: WideString read Get_AllowScriptAccess write Set_AllowScriptAccess;
    property MovieData: WideString read Get_MovieData write Set_MovieData;
    property InlineData: IUnknown read Get_InlineData write Set_InlineData;
    property SeamlessTabbing: WordBool read Get_SeamlessTabbing write Set_SeamlessTabbing;
    property Profile: WordBool read Get_Profile write Set_Profile;
    property ProfileAddress: WideString read Get_ProfileAddress write Set_ProfileAddress;
    property ProfilePort: Integer read Get_ProfilePort write Set_ProfilePort;
    property AllowNetworking: WideString read Get_AllowNetworking write Set_AllowNetworking;
    property AllowFullScreen: WideString read Get_AllowFullScreen write Set_AllowFullScreen;
  end;

// *********************************************************************//
// DispIntf:  IShockwaveFlashDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlashDisp = dispinterface
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    property ReadyState: Integer readonly dispid -525;
    property TotalFrames: Integer readonly dispid 124;
    property Playing: WordBool dispid 125;
    property Quality: SYSINT dispid 105;
    property ScaleMode: SYSINT dispid 120;
    property AlignMode: SYSINT dispid 121;
    property BackgroundColor: Integer dispid 123;
    property Loop: WordBool dispid 106;
    property Movie: WideString dispid 102;
    property FrameNum: Integer dispid 107;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); dispid 109;
    procedure Zoom(factor: SYSINT); dispid 118;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); dispid 119;
    procedure Play; dispid 112;
    procedure Stop; dispid 113;
    procedure Back; dispid 114;
    procedure Forward; dispid 115;
    procedure Rewind; dispid 116;
    procedure StopPlay; dispid 126;
    procedure GotoFrame(FrameNum: Integer); dispid 127;
    function CurrentFrame: Integer; dispid 128;
    function IsPlaying: WordBool; dispid 129;
    function PercentLoaded: Integer; dispid 130;
    function FrameLoaded(FrameNum: Integer): WordBool; dispid 131;
    function FlashVersion: Integer; dispid 132;
    property WMode: WideString dispid 133;
    property SAlign: WideString dispid 134;
    property Menu: WordBool dispid 135;
    property Base: WideString dispid 136;
    property Scale: WideString dispid 137;
    property DeviceFont: WordBool dispid 138;
    property EmbedMovie: WordBool dispid 139;
    property BGColor: WideString dispid 140;
    property Quality2: WideString dispid 141;
    procedure LoadMovie(layer: SYSINT; const url: WideString); dispid 142;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); dispid 143;
    procedure TGotoLabel(const target: WideString; const label_: WideString); dispid 144;
    function TCurrentFrame(const target: WideString): Integer; dispid 145;
    function TCurrentLabel(const target: WideString): WideString; dispid 146;
    procedure TPlay(const target: WideString); dispid 147;
    procedure TStopPlay(const target: WideString); dispid 148;
    procedure SetVariable(const name: WideString; const value: WideString); dispid 151;
    function GetVariable(const name: WideString): WideString; dispid 152;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); dispid 153;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; dispid 154;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); dispid 155;
    procedure TCallLabel(const target: WideString; const label_: WideString); dispid 156;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); dispid 157;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; dispid 158;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; dispid 172;
    property SWRemote: WideString dispid 159;
    property FlashVars: WideString dispid 170;
    property AllowScriptAccess: WideString dispid 171;
    property MovieData: WideString dispid 190;
    property InlineData: IUnknown dispid 191;
    property SeamlessTabbing: WordBool dispid 192;
    procedure EnforceLocalSecurity; dispid 193;
    property Profile: WordBool dispid 194;
    property ProfileAddress: WideString dispid 195;
    property ProfilePort: Integer dispid 196;
    function CallFunction(const request: WideString): WideString; dispid 198;
    procedure SetReturnValue(const returnValue: WideString); dispid 199;
    procedure DisableLocalSecurity; dispid 200;
    property AllowNetworking: WideString dispid 201;
    property AllowFullScreen: WideString dispid 202;
  end;

// *********************************************************************//
// DispIntf:  _IShockwaveFlashEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {D27CDB6D-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  _IShockwaveFlashEvents = dispinterface
    ['{D27CDB6D-AE6D-11CF-96B8-444553540000}']
    procedure OnReadyStateChange(newState: Integer); dispid -609;
    procedure OnProgress(percentDone: Integer); dispid 1958;
    procedure FSCommand(const command: WideString; const args: WideString); dispid 150;
    procedure FlashCall(const request: WideString); dispid 197;
  end;

// *********************************************************************//
// Interface: IFlashFactory
// Flags:     (0)
// GUID:      {D27CDB70-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashFactory = interface(IUnknown)
    ['{D27CDB70-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IDispatchEx
// Flags:     (4096) Dispatchable
// GUID:      {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
// *********************************************************************//
  IDispatchEx = interface(IDispatch)
    ['{A6EF9860-C720-11D0-9337-00A0C90DCAA9}']
    function GetDispID(const bstrName: WideString; grfdex: LongWord; out pid: Integer): HResult; stdcall;
    function RemoteInvokeEx(id: Integer; lcid: LongWord; dwFlags: LongWord; var pdp: DISPPARAMS; 
                            out pvarRes: OleVariant; out pei: EXCEPINFO;
                            const pspCaller: IServiceProvider; cvarRefArg: SYSUINT; 
                            var rgiRefArg: SYSUINT; var rgvarRefArg: OleVariant): HResult; stdcall;
    function DeleteMemberByName(const bstrName: WideString; grfdex: LongWord): HResult; stdcall;
    function DeleteMemberByDispID(id: Integer): HResult; stdcall;
    function GetMemberProperties(id: Integer; grfdexFetch: LongWord; out pgrfdex: LongWord): HResult; stdcall;
    function GetMemberName(id: Integer; out pbstrName: WideString): HResult; stdcall;
    function GetNextDispID(grfdex: LongWord; id: Integer; out pid: Integer): HResult; stdcall;
    function GetNameSpaceParent(out ppunk: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFlashObjectInterface
// Flags:     (4096) Dispatchable
// GUID:      {D27CDB72-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashObjectInterface = interface(IDispatchEx)
    ['{D27CDB72-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IServiceProvider
// Flags:     (0)
// GUID:      {6D5140C1-7436-11CE-8034-00AA006009FA}
// *********************************************************************//
  IServiceProvider = interface(IUnknown)
    ['{6D5140C1-7436-11CE-8034-00AA006009FA}']
    function RemoteQueryService(var guidService: TGUID; var riid: TGUID; out ppvObject: IUnknown): HResult; stdcall;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TsfFlashPlayer
// Help String      : Shockwave Flash
// Default Interface: IShockwaveFlash
// Def. Intf. DISP? : No
// Event   Interface: _IShockwaveFlashEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TsfFlashPlayerOnReadyStateChange = procedure(ASender: TObject; newState: Integer) of object;
  TsfFlashPlayerOnProgress = procedure(ASender: TObject; percentDone: Integer) of object;
  TsfFlashPlayerFSCommand = procedure(ASender: TObject; const command: WideString;
                                                         const args: WideString) of object;
  TsfFlashFlashCall = procedure(ASender: TObject; const request: WideString) of object;

  TsfFlashCollection = class;

  TsfFLVSkins = (flvclearskin, flvsteelskin, flvmojaveskin, flvnoneskin);

{ TsfFlashStream }

  TsfFlashStream = class(TCollectionItem)
  private
    FFlash: TMemoryStream;
    FTag: integer;
    FOnChanged: TNotifyEvent;
    function GetFlashStore: string;
    procedure SetFlashStore(const Value: string);
  protected
    function GetDisplayName: string; override;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
    procedure DefineProperties(Filer: TFiler); override;
  public
    FFlashStore: string;
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    destructor Destroy; override;
    property Flash: TMemoryStream read FFlash;
  published
    property FlashStore: string read GetFlashStore write SetFlashStore;
    property Tag: integer read FTag write FTag;
  end;

{ TsfFlashCollection }

  TsfFlashCollection = class(TCollection)
  private
    FFlashList: TsfFlashList;
    function GetItem(Index: Integer): TsfFlashStream;
    procedure SetItem(Index: Integer; Value: TsfFlashStream);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TsfFlashList);
    function Add: TsfFlashStream;
    property Items[Index: Integer]: TsfFlashStream read GetItem write SetItem; default;
    destructor Destroy; override;
  published
  end;

{ TsfFlashList class }

  TsfFlashList = class(TComponent)
  private
    FFlashs: TsfFlashCollection;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindFlash(const AName: string): TsfFlashStream;
  published
    property Flashs: TsfFlashCollection read FFlashs write FFlashs;
  end;

// *********************************************************************//
// The Class CoFlashProp provides a Create and CreateRemote method to
// create instances of the default interface IUnknown exposed by
// the CoClass FlashProp. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.                                            
// *********************************************************************//
  CoFlashProp = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// The Class CoFlashObjectInterface provides a Create and CreateRemote method to          
// create instances of the default interface IFlashObjectInterface exposed by              
// the CoClass FlashObjectInterface. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoFlashObjectInterface = class
    class function Create: IFlashObjectInterface;
    class function CreateRemote(const MachineName: string): IFlashObjectInterface;
  end;

  TsfFlashPlayer = class(TsfOleControl, IBindHost)
  private
    FVolume: Integer;
    FVolumeControl: Boolean;
    FOnReadyStateChange: TsfFlashPlayerOnReadyStateChange;
    FOnProgress: TsfFlashPlayerOnProgress;
    FOnFSCommand: TsfFlashPlayerFSCommand;
    FOnFlashCall: TsfFlashFlashCall;
    FOnHandleFSCommand: TsfFlashPlayerFSCommand;
    FIntf: IShockwaveFlash;
    FMovie: WideString;
    FFlv: boolean;
    FFScommand, FFSargs: WideString;
    FFLVPlaybackSkin: TsfFLVSkins;
    procedure SetFLVPlaybackSkin(Value: TsfFLVSkins);
    procedure SoundSetVolume(Value: Integer);
    procedure SetVolume(Value: Integer);
    procedure SetVolumeControl(Value: Boolean);
    function  GetControlInterface: IShockwaveFlash;
    procedure SetFlashList(const Value: TsfFlashList);
    procedure SetFlashIndex(const Value: integer);
    procedure DoFSCommand(ASender: TObject; const command, args: WideString);
    function GetMovie: WideString;
    procedure SetMovie(const Value: WideString);
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_InlineData: IUnknown;
    procedure Set_InlineData(const ppIUnknown: IUnknown);
    property WMode: WideString index 133 read GetWideStringProp write SetWideStringProp stored False;
    property OnFSCommand: TsfFlashPlayerFSCommand read FOnFSCommand write FOnFSCommand;
    procedure Notification(AComponent: TComponent;
                          Operation: TOperation); override;
    { IBindHost }
    function CreateMoniker(pszName: POLEStr; BC: IBindCtx; out mk: IMoniker_flash; dwReserved: DWORD): HResult; virtual; stdcall;
    function MonikerBindToStorage(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
      const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
    function MonikerBindToObject(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
      const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //
    procedure SetReturnValue(const returnValue: WideString);
    //
    function GrabToBmp: TBitmap;
    function GrabToBmpAlpha: TsfBitmap;
    function GrabToJpg: TJpegImage;
    {$IFDEF FLASHTOPNG}
    function GrabToPng: TsfPngImage;
    {$ENDIF}
    //
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer);
    procedure Zoom(factor: SYSINT);
    procedure DisableFlashSounds(Value: Boolean);
    function IsFlashAviable: Boolean;
    function  CallFunction(const request: WideString): WideString;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT);
    procedure Play;
    procedure Stop;
    procedure Back;
    procedure Forward;
    procedure Rewind;
    procedure StopPlay;
    procedure GotoFrame(FrameNum: Integer);
    function CurrentFrame: Integer;
    function IsPlaying: WordBool;
    function PercentLoaded: Integer;
    function FrameLoaded(FrameNum: Integer): WordBool;
    function FlashVersion: Integer;
    procedure LoadMovie(layer: SYSINT; const url: WideString);
    procedure LoadMovieFromStream(layer: SYSINT; const Stream: TStream);
    procedure LoadMovieFromStreamAsync(layer: SYSINT; const Stream: TStream);
    procedure LoadMovieFromResource(layer: SYSINT; const ResName: WideString);
    procedure TGotoFrame(const target: WideString; FrameNum: Integer);
    procedure TGotoLabel(const target: WideString; const label_: WideString);
    function TCurrentFrame(const target: WideString): Integer;
    function TCurrentLabel(const target: WideString): WideString;
    procedure TPlay(const target: WideString);
    procedure TStopPlay(const target: WideString);
    procedure SetVariable(const name: WideString; const value: WideString);
    function GetVariable(const name: WideString): WideString;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString);
    function TGetProperty(const target: WideString; property_: SYSINT): WideString;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT);
    procedure TCallLabel(const target: WideString; const label_: WideString);
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
    property  ControlInterface: IShockwaveFlash read GetControlInterface;
    property  DefaultInterface: IShockwaveFlash read GetControlInterface;
    property ReadyState: Integer index -525 read GetIntegerProp;
    property TotalFrames: Integer index 124 read GetIntegerProp;
    property InlineData: IUnknown index 191 read GetIUnknownProp write SetIUnknownProp;
  published
    property Anchors;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnStartDrag;
    property Volume: Integer read FVolume write SetVolume;
    property VolumeControl: Boolean read FVolumeControl write SetVolumeControl;
    property Playing: WordBool index 125 read GetWordBoolProp write SetWordBoolProp stored False;
    property Quality: Integer index 105 read GetIntegerProp write SetIntegerProp stored False;
    property ScaleMode: Integer index 120 read GetIntegerProp write SetIntegerProp stored False;
    property AlignMode: Integer index 121 read GetIntegerProp write SetIntegerProp stored False;
    property BackgroundColor: Integer index 123 read GetIntegerProp write SetIntegerProp stored False;
    property Loop: WordBool index 106 read GetWordBoolProp write SetWordBoolProp stored False;
    property Movie: WideString read GetMovie write SetMovie stored true;
    property FrameNum: Integer index 107 read GetIntegerProp write SetIntegerProp stored False;
    property SAlign: WideString index 134 read GetWideStringProp write SetWideStringProp stored False;
    property Menu: WordBool index 135 read GetWordBoolProp write SetWordBoolProp stored False;
    property Base: WideString index 136 read GetWideStringProp write SetWideStringProp stored False;
    property Scale: WideString index 137 read GetWideStringProp write SetWideStringProp stored False;
    property DeviceFont: WordBool index 138 read GetWordBoolProp write SetWordBoolProp stored False;
    property EmbedMovie: WordBool index 139 read GetWordBoolProp write SetWordBoolProp stored False;
    property BGColor: WideString index 140 read GetWideStringProp write SetWideStringProp stored False;
    property Quality2: WideString index 141 read GetWideStringProp write SetWideStringProp stored False;
    property SWRemote: WideString index 159 read GetWideStringProp write SetWideStringProp stored False;
    property FlashVars: WideString index 170 read GetWideStringProp write SetWideStringProp stored False;
    property AllowScriptAccess: WideString index 171 read GetWideStringProp write SetWideStringProp stored False;
    property MovieData: WideString index 190 read GetWideStringProp write SetWideStringProp stored False;
    property SeamlessTabbing: WordBool index 192 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnReadyStateChange: TsfFlashPlayerOnReadyStateChange read FOnReadyStateChange write FOnReadyStateChange;
    property OnProgress: TsfFlashPlayerOnProgress read FOnProgress write FOnProgress;
    property OnHandleFSCommand: TsfFlashPlayerFSCommand read FOnHandleFSCommand write FOnHandleFSCommand;
    property OnFlashCall: TsfFlashFlashCall read FOnFlashCall write FOnFlashCall;
    { list }
    property FlashList: TsfFlashList read FFlashList write SetFlashList;
    property FlashIndex: integer read FFlashIndex write SetFlashIndex default -1;
    {}
    property FLVPlaybackSkin: TsfFLVSkins read FFLVPlaybackSkin write SetFLVPlaybackSkin;
  end;


  TsfLayeredFlashForm = class(TComponent)
  private
   FForm: TForm;
   FFlashPlayer: TsfFlashPlayer;
   OldWindowProc: TWndMethod;
   FAlphaBlendValue: Integer;
   FFirstShow: Boolean;
   //
   FDragable: Boolean;
   FIsDragging: Boolean;
   FDragX, FDragY: Integer;
   FMouseDown: Boolean;
   FApplyRegions: Boolean;
   FRegionsAlphaBlend: Boolean;
   procedure SetAlphaBlendValue(Value: Integer); 
   procedure SetFlashPlayer(Value: TsfFlashPlayer);
   procedure NewWndProc(var Message: TMessage);
   procedure DoPaint(Sender: TObject);
 protected
   procedure Loaded; override;
   procedure Notification(AComponent: TComponent;
                          Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FlashPlayer: TsfFlashPlayer read FFlashPlayer write SetFlashPlayer;
    property AlphaBlendValue: Integer read FAlphaBlendValue write SetAlphaBlendValue;
    property Dragable: Boolean read FDragable write FDragable;
    property ApplyRegions: Boolean read FApplyRegions write FApplyRegions;
    property RegionsAlphaBlend: Boolean read FRegionsAlphaBlend write FRegionsAlphaBlend;
  end;

  TsfFlashImageItem = class(TCollectionItem)
  private
    FFlashImage: TsfBitMap;
    FFlashImageFile: String;
    FName: string;
    procedure SetFlashImage(const Value: TsfBitMap);
    procedure SetFlashImageFile(Value: String);
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetDisplayName: string; override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property FlashImage: TsfBitMap read FFlashImage write SetFlashImage;
  published
    property FlashImageFile: String read FFlashImageFile write SetFlashImageFile;
    property Name: string read FName write FName;
  end;

  TsfFlashImageList = class;

  TsfFlashImageItems = class(TCollection)
  private
    function GetItem(Index: Integer): TsfFlashImageItem;
    procedure SetItem(Index: Integer; Value:  TsfFlashImageItem);
  protected
    function GetOwner: TPersistent; override;
  public
    FFlashImageList: TsfFlashImageList;
    constructor Create(AFlashImageList: TsfFlashImageList);
    property Items[Index: Integer]:  TsfFlashImageItem read GetItem write SetItem; default;
  end;

  TsfFlashImageList = class(TCustomImageList)
  private
    SF: TsfFlashPlayer;
    FTempBmp: TsfBitMap;
    FFlashImages: TsfFlashImageItems;
    FFlashList: TsfFlashList;
    function GetFlashWidth: Integer;
    function GetFlashHeight: Integer;
    procedure SetFlashWidth(Value: Integer);
    procedure SetFlashHeight(Value: Integer);
    procedure SetFlashImages(Value: TsfFlashImageItems);
    procedure SetFlashList(Value: TsfFlashList);
    procedure LoadFromFlashList;
  protected
    procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean = True); override;
    procedure InsertBitMap(Index: Integer);
    procedure DeleteBitMap(Index: Integer);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FlashImages: TsfFlashImageItems read FFlashImages write SetFlashImages;
    property FlashWidth: Integer read GetFlashWidth write SetFlashWidth;
    property FlashHeight: Integer read GetFlashHeight write SetFlashHeight;
    property FlashList: TsfFlashList read FFlashList write SetFlashList;
  end;

  TsfFlashImage = class(TGraphicControl)
  private
    FAutoSize: Boolean;
    FFlashImageList: TsfFlashImageList;
    FImageIndex: Integer;
    procedure SetAutoSize(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
  protected
    procedure AdjustBounds; 
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property FlashImageList: TsfFlashImageList
      read FFlashImageList write FFlashImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  var
    URLOpenPullStreamA: function (p1: IUnknown; p2: PAnsiChar; p3: DWORD;
      BSC: urlmon.IBindStatusCallback): HResult; stdcall;

implementation

{$R *.res}

uses OleConst, sf_winapi;

const
  OCM_BASE = $2000;

{ Control flags }

const
  cfBackColor = $00000001;
  cfForeColor = $00000002;
  cfFont      = $00000004;
  cfEnabled   = $00000008;
  cfCaption   = $00000010;
  cfText      = $00000020;

const
  MaxDispArgs = 32;

type

  PDispInfo = ^TDispInfo;
  TDispInfo = packed record
    DispID: TDispID;
    ResType: Byte;
    CallDesc: TCallDesc;
  end;

  TArgKind = (akDWord, akSingle, akDouble);

  PEventArg = ^TEventArg;
  TEventArg = record
    Kind: TArgKind;
    Data: array[0..1] of Integer;
  end;

  TEventInfo = record
    Method: TMethod;
    Sender: TObject;
    ArgCount: Integer;
    Args: array[0..MaxDispArgs - 1] of TEventArg;
  end;

function FontToOleFont(Font: TFont): Variant;
var
  Temp: IFontDisp;
begin
  GetOleFont(Font, Temp);
  Result := Temp;
end;

procedure OleFontToFont(const OleFont: Variant; Font: TFont);
begin
  SetOleFont(Font, IUnknown(OleFont) as IFontDisp);
end;

function StringToVarOleStr(const S: string): Variant;
begin
  VarClear(Result);
  TVarData(Result).VOleStr := StringToOleStr(S);
  TVarData(Result).VType := varOleStr;
end;

{ TEventDispatch }

constructor TEventDispatch.Create(Control: TsfOleControl);
begin
  FControl := Control;
end;

{ TEventDispatch.IUnknown }

function TEventDispatch.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
  begin
    Result := S_OK;
    Exit;
  end;
  if IsEqualIID(IID, FControl.FControlData^.EventIID) then
  begin
    GetInterface(IDispatch, Obj);
    Result := S_OK;
    Exit;
  end;
  Result := E_NOINTERFACE;
end;

function TEventDispatch._AddRef: Integer;
begin
  Result := FControl._AddRef;
end;

function TEventDispatch._Release: Integer;
begin
  Result := FControl._Release;
end;

{ TEventDispatch.IDispatch }

function TEventDispatch.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;

function TEventDispatch.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := E_NOTIMPL;
end;

function TEventDispatch.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TEventDispatch.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin
  if (DispID >= DISPID_MOUSEUP) and (DispID <= DISPID_CLICK) then
    FControl.StandardEvent(DispID, TDispParams(Params)) else
    FControl.InvokeEvent(DispID, TDispParams(Params));
  Result := S_OK;
end;

{ TEnumPropDesc }

constructor TEnumPropDesc.Create(DispID, ValueCount: Integer;
  const TypeInfo: ITypeInfo);
var
  I: Integer;
  VarDesc: PVarDesc;
  Name: WideString;
begin
  FDispID := DispID;
  FValueCount := ValueCount;
  FValues := AllocMem(ValueCount * SizeOf(TEnumValue));
  for I := 0 to ValueCount - 1 do
  begin
    OleCheck(TypeInfo.GetVarDesc(I, VarDesc));
    try
      OleCheck(TypeInfo.GetDocumentation(VarDesc^.memid, @Name,
        nil, nil, nil));
      with FValues^[I] do
      begin
        Value := TVarData(VarDesc^.lpVarValue^).VInteger;
        Ident := Name;
        while (Length(Ident) > 1) and (Ident[1] = '_') do
          Delete(Ident, 1, 1);
      end;
    finally
      TypeInfo.ReleaseVarDesc(VarDesc);
    end;
  end;
end;

destructor TEnumPropDesc.Destroy;
begin
  if FValues <> nil then
  begin
    Finalize(FValues^[0], FValueCount);
    FreeMem(FValues, FValueCount * SizeOf(TEnumValue));
  end;
end;

procedure TEnumPropDesc.GetStrings(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := 0 to FValueCount - 1 do
    with FValues^[I] do Proc(Format('%d - %s', [Value, Ident]));
end;

function TEnumPropDesc.StringToValue(const S: string): Integer;
var
  I: Integer;
begin
  I := 1;
  while (I <= Length(S)) and (S[I] in ['0'..'9', '-']) do Inc(I);
  if I > 1 then
  begin
    Result := StrToInt(Copy(S, 1, I - 1));
    for I := 0 to FValueCount - 1 do
      if Result = FValues^[I].Value then Exit;
  end else
    for I := 0 to FValueCount - 1 do
      with FValues^[I] do
        if AnsiCompareText(S, Ident) = 0 then
        begin
          Result := Value;
          Exit;
        end;
  raise EOleError.CreateResFmt(@SBadPropValue, [S]);
end;

function TEnumPropDesc.ValueToString(V: Integer): string;
var
  I: Integer;
begin
  for I := 0 to FValueCount - 1 do
    with FValues^[I] do
      if V = Value then
      begin
        Result := Format('%d - %s', [Value, Ident]);
        Exit;
      end;
  Result := IntToStr(V);
end;

{ TsfOleControl }

const
  // The following flags may be or'd into the TControlData.Reserved field to override
  // default behaviors.

  // cdForceSetClientSite:
  //   Call SetClientSite early (in constructor) regardless of misc status flags
  cdForceSetClientSite = 1;

  // cdDeferSetClientSite:
  //   Don't call SetClientSite early.  Takes precedence over cdForceSetClientSite and misc status flags
  cdDeferSetClientSite = 2;

constructor TsfOleControl.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FFlashPath := '';
  FBuffer := nil;
  FBuffer2 := nil;
  FGrabProcess := False;
  FInLoading := False;
  FTransparent := true;
  Include(FComponentStyle, csCheckPropAvail);
  InitControlData;
  Inc(FControlData^.InstanceCount);
  if FControlData^.FontCount > 0 then
  begin
    FFonts := TList.Create;
    FFonts.Count := FControlData^.FontCount;
    for I := 0 to FFonts.Count-1 do
      FFonts[I] := TFont.Create;
  end;
  if FControlData^.PictureCount > 0 then
  begin
    FPictures := TList.Create;
    FPictures.Count := FControlData^.PictureCount;
    for I := 0 to FPictures.Count-1 do
    begin
      FPictures[I] := TPicture.Create;
      TPicture(FPictures[I]).OnChange := PictureChanged;
    end;
  end;
  FEventDispatch := TEventDispatch.Create(Self);
  CreateInstance;
  if FFlashNotExists then Exit;
  InitControlInterface(FOleObject);
  OleCheck(FOleObject.GetMiscStatus(DVASPECT_CONTENT, FMiscStatus));
  if (FControlData^.Reserved and cdDeferSetClientSite) = 0 then
    if ((FMiscStatus and OLEMISC_SETCLIENTSITEFIRST) <> 0) or
      ((FControlData^.Reserved and cdForceSetClientSite) <> 0) then
      OleCheck(FOleObject.SetClientSite(Self));
  OleCheck(FOleObject.QueryInterface(IPersistStreamInit, FPersistStream));
  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME <> 0 then
    Visible := False;
  OleCheck(RequestNewObjectLayout);
end;

destructor TsfOleControl.Destroy;

  procedure FreeList(var L: TList);
  var
    I: Integer;
  begin
    if L <> nil then
    begin
      for I := 0 to L.Count-1 do
        TObject(L[I]).Free;
      L.Free;
      L := nil;
    end;
  end;

begin
  SetUIActive(False);
  if FOleObject <> nil then FOleObject.Close(OLECLOSE_NOSAVE);
  DestroyControl;
  DestroyStorage;
  FPersistStream := nil;
  if FOleObject <> nil then FOleObject.SetClientSite(nil);
  FOleObject := nil;
  FEventDispatch.Free;
  FreeList(FFonts);
  FreeList(FPictures);
  Dec(FControlData^.InstanceCount);
  if FControlData^.InstanceCount = 0 then DestroyEnumPropDescs;
  if FBackBuffer <> nil then FBackBuffer.Free;
  if FBuffer2 <> nil then FBuffer2.Free;
  if FBuffer <> nil then FBuffer.Free;
  inherited Destroy;
end;

procedure TsfOleControl.BrowseProperties;
begin
  DoObjectVerb(OLEIVERB_PROPERTIES);
end;

procedure TsfOleControl.PaintFrame;
const
  DVASPECT_OPAQUE         = 16;
  DVASPECT_TRANSPARENT    = 32;
var
  R: TRect;
  x, y: integer;
  A, S, T: byte;
  Color, BlackColor: PsfColor;
begin
  if FPaintBackground then Exit;

  if (Width > 0) and (Height > 0) then
  begin
     if FViewObject <> nil then
    begin
      R := ClientRect;
      begin
        { only grabbing - for layer }
        { default paint }
        FBuffer2.AlphaBlend := false;
        FBuffer2.Transparent := false;
        { white image - on BackBuffer }
        FBackBuffer.Clear($FF000000);
        FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, 
FBackBuffer.DC, nil, nil, nil, 0);
        { black image - on Buffer2 }
        FBuffer2.Clear($FFFFFFFF);
        FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, 
FBuffer2.DC, nil, nil, nil, 0);
        { Restore alpha on Buffer2 }
        for y := 0 to FBuffer.Height - 1 do
        begin
          Color := PsfColor(@FBuffer2.Bits[y * FBuffer2.Width]);
          BlackColor := PsfColor(@FBackBuffer.Bits[y * FBuffer2.Width]);
          for x := 0 to FBuffer.Width - 1 do
          begin
            { Set vars }
            S := BlackColor^ and $FF;
            T := Color^ and $FF;
            { Restore alpha }
            A := ($FF - (T - S));
            { Restore RGB }
            if A > 0 then
            begin
              PsfColorRec(Color).A := A;
              PsfColorRec(Color).R := MulDiv(PsfColorRec(BlackColor).R, 
A, $FF);
              PsfColorRec(Color).G := MulDiv(PsfColorRec(BlackColor).G, 
A, $FF);
              PsfColorRec(Color).B := MulDiv(PsfColorRec(BlackColor).B, 
A, $FF);
            end
            else
            begin
              Color^ := 0;
            end;
            Inc(Color);
            Inc(BlackColor);
          end;
        end;
      end;
    end;
  end;
  FPaintRect := nil;
end;

procedure TsfOleControl.CreateControl;
var
  Stream: IStream;
  CS: IOleClientSite_Flash;
  X: Integer;
begin
  if FOleObject = nil then Exit;
  
  if FOleControl = nil then
    try
      try  // work around ATL bug
        X := FOleObject.GetClientSite(CS);
      except
        X := -1;
      end;
      if (X <> 0) or (CS = nil) then
        OleCheck(FOleObject.SetClientSite(Self));
      if FObjectData = 0 then OleCheck(FPersistStream.InitNew) else
      begin
        OleCheck(CreateStreamOnHGlobal(FObjectData, False, Stream));
        OleCheck(FPersistStream.Load(Stream));
        DestroyStorage;
      end;
      OleCheck(FOleObject.QueryInterface(IOleControl, FOleControl));
      OleCheck(FOleObject.QueryInterface(IDispatch, FControlDispatch));
      FOleObject.QueryInterface(IPerPropertyBrowsing, FPropBrowsing);
      InterfaceConnect(FOleObject, IPropertyNotifySink,
        Self, FPropConnection);
      InterfaceConnect(FOleObject, FControlData^.EventIID,
        FEventDispatch, FEventsConnection);
      if FControlData^.Flags and cfBackColor <> 0 then
        OnChanged(DISPID_BACKCOLOR);
      if FControlData^.Flags and cfEnabled <> 0 then
        OnChanged(DISPID_ENABLED);
      if FControlData^.Flags and cfFont <> 0 then
        OnChanged(DISPID_FONT);
      if FControlData^.Flags and cfForeColor <> 0 then
        OnChanged(DISPID_FORECOLOR);
      FOleControl.OnAmbientPropertyChange(DISPID_UNKNOWN);
      RequestNewObjectLayout;
    except
      DestroyControl;
      raise;
    end;
end;

procedure TsfOleControl.CreateEnumPropDescs;

  function FindMember(DispId: Integer): Boolean;
  var
    I: Integer;
  begin
    for I := 0 to FControlData^.EnumPropDescs.Count - 1 do
      if TEnumPropDesc(FControlData^.EnumPropDescs).FDispID = DispID then
      begin
        Result := True;
        Exit;
      end;
    Result := False;
  end;

  procedure CreateEnum(TypeDesc: TTypeDesc; const TypeInfo: ITypeInfo;
    DispId: Integer);
  var
    RefInfo: ITypeInfo;
    RefAttr: PTypeAttr;
  begin
    if TypeDesc.vt <> VT_USERDEFINED then Exit;
    OleCheck(TypeInfo.GetRefTypeInfo(TypeDesc.hreftype, RefInfo));
    OleCheck(RefInfo.GetTypeAttr(RefAttr));
    try
      if RefAttr^.typekind = TKIND_ENUM then
        FControlData^.EnumPropDescs.Expand.Add(
          TEnumPropDesc.Create(Dispid, RefAttr^.cVars, RefInfo));
    finally
      RefInfo.ReleaseTypeAttr(RefAttr);
    end;
  end;

  procedure ProcessTypeInfo(const TypeInfo: ITypeInfo);
  var
    I: Integer;
    RefInfo: ITypeInfo;
    TypeAttr: PTypeAttr;
    VarDesc: PVarDesc;
    FuncDesc: PFuncDesc;
    RefType: HRefType;
  begin
    OleCheck(TypeInfo.GetTypeAttr(TypeAttr));
    try
      if IsEqualGUID(TypeAttr^.guid, IDispatch) then Exit;
      if ((TypeAttr.typekind = TKIND_INTERFACE) or
        (TypeAttr.wTypeFlags and TYPEFLAG_FDUAL <> 0)) and
        (TypeAttr.wTypeFlags and TYPEFLAG_FNONEXTENSIBLE <> 0) then
      begin
        OleCheck(TypeInfo.GetRefTypeOfImplType(0, RefType));
        OleCheck(TypeInfo.GetRefTypeInfo(RefType, RefInfo));
        ProcessTypeInfo(RefInfo);
      end;
      for I := 0 to TypeAttr^.cVars - 1 do
      begin
        OleCheck(TypeInfo.GetVarDesc(I, VarDesc));
        try
          CreateEnum(VarDesc^.elemdescVar.tdesc, TypeInfo, VarDesc^.memid);
        finally
          TypeInfo.ReleaseVarDesc(VarDesc);
        end;
      end;
      for I := 0 to TypeAttr^.cFuncs - 1 do
      begin
        OleCheck(TypeInfo.GetFuncDesc(I, FuncDesc));
        try
          if not FindMember(FuncDesc^.memid) then
            case FuncDesc^.invkind of
              INVOKE_PROPERTYGET:
                CreateEnum(FuncDesc^.elemdescFunc.tdesc, TypeInfo, FuncDesc^.memid);
              INVOKE_PROPERTYPUT:
                CreateEnum(FuncDesc^.lprgelemdescParam[FuncDesc.cParams - 1].tdesc,
                  TypeInfo, FuncDesc^.memid);
              INVOKE_PROPERTYPUTREF:
                if FuncDesc^.lprgelemdescParam[FuncDesc.cParams - 1].tdesc.vt = VT_PTR then
                  CreateEnum(FuncDesc^.lprgelemdescParam[FuncDesc.cParams - 1].tdesc.ptdesc^,
                    TypeInfo, FuncDesc^.memid);
            end;
        finally
          TypeInfo.ReleaseFuncDesc(FuncDesc);
        end;
      end;
    finally
      TypeInfo.ReleaseTypeAttr(TypeAttr);
    end;
  end;

var
  TypeInfo: ITypeInfo;
begin
  CreateControl;
  FControlData^.EnumPropDescs := TList.Create;
  try
    OleCheck(FControlDispatch.GetTypeInfo(0, 0, TypeInfo));
    ProcessTypeInfo(TypeInfo);
  except
    DestroyEnumPropDescs;
    raise;
  end;
end;

procedure TsfOleControl.CreateInstance;
var
  ClassFactory2: IClassFactory2;
  LicKeyStr: WideString;

  procedure LicenseCheck(Status: HResult; const Ident: string);
  begin
    if Status = CLASS_E_NOTLICENSED then
      raise EOleError.CreateFmt(Ident, [ClassName]);
    OleCheck(Status);
  end;

begin
  try
    if not (csDesigning in ComponentState) and
      (FControlData^.LicenseKey <> nil) then
    begin
      OleCheck(CoGetClassObject(FControlData^.ClassID, CLSCTX_INPROC_SERVER or
        CLSCTX_LOCAL_SERVER, nil, IClassFactory2, ClassFactory2));
      LicKeyStr := PWideChar(FControlData^.LicenseKey);
      LicenseCheck(ClassFactory2.CreateInstanceLic(nil, nil, IOleObject_Flash,
        LicKeyStr, FOleObject), SInvalidLicense);
    end
    else
      LicenseCheck(CoCreateInstance(FControlData^.ClassID, nil,
        CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IOleObject_Flash,
        FOleObject), SNotLicensed);
  except
    FFlashNotExists := true;
  end;
end;

procedure TsfOleControl.CreateStorage;
var
  Stream: IStream;
begin
  DestroyStorage;
  FObjectData := GlobalAlloc(GMEM_MOVEABLE, 0);
  if FObjectData = 0 then OutOfMemoryError;
  try
    OleCheck(CreateStreamOnHGlobal(FObjectData, False, Stream));
    OleCheck(FPersistStream.Save(Stream, True));
  except
     DestroyStorage;
     raise;
  end;

end;

procedure TsfOleControl.CreateWnd;
var
  Result: LResult;
  H: HWnd;
begin
  if FFlashNotExists then Exit;
  
  CreateControl;
  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME = 0 then
  begin
    FOleObject.DoVerb(OLEIVERB_INPLACEACTIVATE, nil, Self, 0,
      0, BoundsRect);
    if FOleInPlaceObject = nil then
      raise EOleError.CreateRes(@SCannotActivate);

    if FOleInPlaceObjectWindowless <> nil then
      FOleInPlaceObjectWindowless.OnWindowMessage(WM_SETFOCUS, 0, 0, Result);
    HookControlWndProc;
  end;
end;

procedure TsfOleControl.DefaultHandler(var Message);
begin
  try
{    if HandleAllocated then
      with TMessage(Message) do
      begin
        if (Msg >= CN_BASE) and (Msg < CN_BASE + WM_USER) then
          Msg := Msg - (CN_BASE - OCM_BASE);
        if FMiscStatus and OLEMISC_SIMPLEFRAME = 0 then
        begin
          Result := CallWindowProc(DefWndProc, Handle, Msg, WParam, LParam);
          Exit;
        end;
      end;}
    inherited DefaultHandler(Message);
  except
  end;
end;

function TsfOleControl.SuppressException(E : Exception): boolean;
{ Unhandled control generated exceptions created when Delphi is streaming a
  form can cause errant behavior of the IDE.  SuppressException is meant to
  allow misbehaving hosted ActiveX Controls to fail in some fashion and still not
  have the Delphi IDE fail along with them.
  If you need to see all control generated exceptions, override this function
  in your TOLEControl descendent and return FALSE.
}
begin
  if (E is EOleSysError) then
    Result := (csDesigning in ComponentState)
      else Result := False;
end;

procedure TsfOleControl.DefineProperties(Filer: TFiler);
begin
  try
    inherited DefineProperties(Filer);
    Filer.DefineBinaryProperty('ControlData', ReadData, WriteData, FOleObject <> nil);
  except
    on E: Exception do
      if not SuppressException(E) then
        raise;
  end;
end;

procedure TsfOleControl.DesignModified;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if (Form <> nil) and (Form.Designer <> nil) then Form.Designer.Modified;
end;

procedure TsfOleControl.DestroyControl;
begin
  DestroyWindowHandle;
  InterfaceDisconnect(FOleObject, FControlData^.EventIID, FEventsConnection);
  InterfaceDisconnect(FOleObject, IPropertyNotifySink, FPropConnection);
  FPropBrowsing := nil;
  FControlDispatch := nil;
  FOleControl := nil;
end;

procedure TsfOleControl.DestroyEnumPropDescs;
var
  I: Integer;
begin
  with FControlData^ do
    if EnumPropDescs <> nil then
    begin
      for I := 0 to EnumPropDescs.Count - 1 do
        TEnumPropDesc(EnumPropDescs[I]).Free;
      EnumPropDescs.Free;
      EnumPropDescs := nil;
    end;
end;

procedure TsfOleControl.DestroyStorage;
begin
  if FObjectData <> 0 then
  begin
    GlobalFree(FObjectData);
    FObjectData := 0;
  end;
end;

procedure TsfOleControl.DestroyWindowHandle;
begin
  if FMiscStatus and OLEMISC_INVISIBLEATRUNTIME = 0 then
  begin
//    SetWindowLong(WindowHandle, GWL_WNDPROC, Longint(DefWndProc));
    if FOleObject <> nil then FOleObject.Close(OLECLOSE_NOSAVE);
//    WindowHandle := 0;
  end
  else
//    inherited DestroyWindowHandle;
end;

procedure TsfOleControl.DoObjectVerb(Verb: Integer);
var
  ActiveWindow: HWnd;
  WindowList: Pointer;
begin
  CreateControl;
  ActiveWindow := GetActiveWindow;
  WindowList := DisableTaskWindows(0);
  try
{    OleCheck(FOleObject.DoVerb(Verb, nil, Self, 0,
      GetParentHandle, BoundsRect));}
  finally
    EnableTaskWindows(WindowList);
    SetActiveWindow(ActiveWindow);
    Windows.SetFocus(ActiveWindow);
  end;
  if FPersistStream.IsDirty <> S_FALSE then DesignModified;
end;

function TsfOleControl.GetByteProp(Index: Integer): Byte;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetColorProp(Index: Integer): TColor;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetTColorProp(Index: Integer): TColor;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetCompProp(Index: Integer): Comp;
begin
  Result := GetDoubleProp(Index);
end;

function TsfOleControl.GetCurrencyProp(Index: Integer): Currency;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VCurrency;
end;

function TsfOleControl.GetDoubleProp(Index: Integer): Double;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VDouble;
end;

function TsfOleControl.GetEnumPropDesc(DispID: Integer): TEnumPropDesc;
var
  I: Integer;
begin
  with FControlData^ do
  begin
    if EnumPropDescs = nil then CreateEnumPropDescs;
    for I := 0 to EnumPropDescs.Count - 1 do
    begin
      Result := EnumPropDescs[I];
      if Result.FDispID = DispID then Exit;
    end;
    Result := nil;
  end;
end;

procedure TsfOleControl.GetEventMethod(DispID: TDispID; var Method: TMethod);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    ECX
        MOV     EBX,EAX
        MOV     ECX,[EBX].TsfOleControl.FControlData
        MOV     EDI,[ECX].TControlData.EventCount
        MOV     ESI,[ECX].TControlData.EventDispIDs
        XOR     EAX,EAX
        JMP     @@1
@@0:    CMP     EDX,[ESI].Integer[EAX*4]
        JE      @@2
        INC     EAX
@@1:    CMP     EAX,EDI
        JNE     @@0
        XOR     EAX,EAX
        XOR     EDX,EDX
        JMP     @@3
@@2:    PUSH    EAX
        CMP     [ECX].TControlData.Version, 401
        JB      @@2a
        MOV     EAX, [ECX].TControlData2.FirstEventOfs
        TEST    EAX, EAX
        JNE     @@2b
@@2a:   MOV     EAX, [EBX]
        CALL    TObject.ClassParent
        CALL    TObject.InstanceSize
        ADD     EAX, 7
        AND     EAX, not 7  // 8 byte alignment
@@2b:   ADD     EBX, EAX
        POP     EAX
        MOV     EDX,[EBX][EAX*8].TMethod.Data
        MOV     EAX,[EBX][EAX*8].TMethod.Code
@@3:    POP     ECX
        MOV     [ECX].TMethod.Code,EAX
        MOV     [ECX].TMethod.Data,EDX
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure Exchange(var A,B); register;
asm
  MOV   ECX, [EDX]
  XCHG  ECX, [EAX]
  MOV   [EDX], ECX
end;

{ TsfOleControl.GetHelpContext:  Fetch the help file name and help context
  id of the given member (property, event, or method) of the Ole Control from
  the control's ITypeInfo interfaces.  GetHelpContext returns False if
  the member name is not found in the control's ITypeInfo.
  To obtain a help context for the entire control class, pass an empty
  string as the Member name.  }

function TsfOleControl.GetHelpContext(Member: string;
  var HelpCtx: Integer; var HelpFile: string): Boolean;
var
  TypeInfo: ITypeInfo;
  HlpFile: TBStr;
  ImplTypes, MemberID: Integer;
  TypeAttr: PTypeAttr;

  function Find(const MemberStr: string; var TypeInfo: ITypeInfo): Boolean;
  var
    Code: HResult;
    I, Flags: Integer;
    RefType: HRefType;
    Name: TBStr;
    Temp: ITypeInfo;
  begin
    Result := False;
    Name := StringToOleStr(Member);
    try
      I := 0;
      while (I < ImplTypes) do
      begin
        OleCheck(TypeInfo.GetImplTypeFlags(I, Flags));
        if Flags and (IMPLTYPEFLAG_FDEFAULT or IMPLTYPEFLAG_FSOURCE) <> 0 then
        begin
          OleCheck(TypeInfo.GetRefTypeOfImplType(I, RefType));
          OleCheck(TypeInfo.GetRefTypeInfo(RefType, Temp));
          Code := Temp.GetIDsOfNames(@Name, 1, @MemberID);
          if Code <> DISP_E_UNKNOWNNAME then
          begin
            OleCheck(Code);
            Exchange(TypeInfo, Temp);
            Result := True;
            Break;
          end;
        end;
        Inc(I);
      end;
    finally
      SysFreeString(Name);
    end;
  end;



begin
  HelpCtx := 0;
  HelpFile := '';
  CreateControl;
  OleCheck((FOleObject as IProvideClassInfo).GetClassInfo(TypeInfo));
  MemberID := MEMBERID_NIL;
  if Length(Member) > 0 then
  begin
    OleCheck(TypeInfo.GetTypeAttr(TypeAttr));
    ImplTypes := TypeAttr.cImplTypes;
    TypeInfo.ReleaseTypeAttr(TypeAttr);
    Result := Find(Member, TypeInfo);
    if (not Result) and (Member[Length(Member)] = '_') then
    begin
      Delete(Member, Length(Member)-1, 1);
      Result := Find(Member, TypeInfo);
    end;
    if (not Result) and (Pos('On', Member) = 1) then
    begin
      Delete(Member, 1, 2);
      Result := Find(Member, TypeInfo);
    end;
    if not Result then Exit;
  end;
  OleCheck(TypeInfo.GetDocumentation(MemberID, nil, nil, @HelpCtx, @HlpFile));
  HelpFile := OleStrToString(HlpFile);
  SysFreeString(HlpFile);
  Result := True;
end;

function TsfOleControl.GetIDispatchProp(Index: Integer): IDispatch;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := IDispatch(Temp.VDispatch);
end;

function TsfOleControl.GetIntegerProp(Index: Integer): Integer;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VInteger;
end;

function TsfOleControl.GetIUnknownProp(Index: Integer): IUnknown;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := IUnknown(Temp.VUnknown);
end;

function TsfOleControl.GetMainMenu: TMainMenu;
var
  Form: TCustomForm;
begin
  Result := nil;
  Form := GetParentForm(Self);
  if Form <> nil then
    if (Form is TForm) and (TForm(Form).FormStyle <> fsMDIChild) then
      Result := Form.Menu
    else
      if Application.MainForm <> nil then
        Result := Application.MainForm.Menu;
end;

procedure TsfOleControl.GetObjectVerbs(List: TStrings);
var
  EnumOleVerb: IEnumOleVerb;
  OleVerb: TOleVerb;
  Code: HResult;
begin
  CreateControl;
  List.Clear;
  Code := FOleObject.EnumVerbs(EnumOleVerb);
  if Code = OLE_S_USEREG then
    Code := OleRegEnumVerbs(FControlData.ClassID, EnumOleVerb);
  if Code = 0 then
    while (EnumOleVerb.Next(1, OleVerb, nil) = 0) do
      if (OleVerb.grfAttribs and OLEVERBATTRIB_ONCONTAINERMENU <> 0) then
      begin
        List.AddObject(StripHotkey(OleVerb.lpszVerbName), TObject(OleVerb.lVerb));
      end;
end;

function TsfOleControl.GetWordBoolProp(Index: Integer): WordBool;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VBoolean;
end;

function TsfOleControl.GetTDateTimeProp(Index: Integer): TDateTime;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VDate;
end;

function TsfOleControl.GetTFontProp(Index: Integer): TFont;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FFonts.Count-1 do
    if FControlData^.FontIDs^[I] = Index then
    begin
      Result := TFont(FFonts[I]);
      if Result.FontAdapter = nil then
        SetOleFont(Result, GetIDispatchProp(Index) as IFontDisp);
    end;
end;

function TsfOleControl.GetOleBoolProp(Index: Integer): TOleBool;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VBoolean;
end;

function TsfOleControl.GetOleDateProp(Index: Integer): TOleDate;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VDate;
end;

function TsfOleControl.GetOleEnumProp(Index: Integer): TOleEnum;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetTOleEnumProp(Index: Integer): TOleEnum;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetOleObject: Variant;
begin
  CreateControl;
  Result := Variant(FOleObject as IDispatch);
end;

function TsfOleControl.GetDefaultDispatch: IDispatch;
begin
  CreateControl;
  Result := FOleObject as IDispatch;
end;

function TsfOleControl.GetOleVariantProp(Index: Integer): OleVariant;
begin
  VarClear(Result);
  GetProperty(Index, TVarData(Result));
end;

function TsfOleControl.GetTPictureProp(Index: Integer): TPicture;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FPictures.Count-1 do
    if FControlData^.PictureIDs^[I] = Index then
    begin
      Result := TPicture(FPictures[I]);
      if Result.PictureAdapter = nil then
        SetOlePicture(Result, GetIDispatchProp(Index) as IPictureDisp);
    end;
end;


function TsfOleControl.GetPropDisplayString(DispID: Integer): string;
var
  S: WideString;
begin
  CreateControl;
  if (FPropBrowsing <> nil) and
    (FPropBrowsing.GetDisplayString(DispID, S) = 0) then
    Result := S else
    Result := GetStringProp(DispID);
end;

procedure TsfOleControl.GetPropDisplayStrings(DispID: Integer; List: TStrings);
var
  Strings: TCAPOleStr;
  Cookies: TCALongint;
  I: Integer;
begin
  CreateControl;
  List.Clear;
  if (FPropBrowsing <> nil) and
    (FPropBrowsing.GetPredefinedStrings(DispID, Strings, Cookies) = 0) then
    try
      for I := 0 to Strings.cElems - 1 do
        List.AddObject(Strings.pElems^[I], TObject(Cookies.pElems^[I]));
    finally
      for I := 0 to Strings.cElems - 1 do
        CoTaskMemFree(Strings.pElems^[I]);
      CoTaskMemFree(Strings.pElems);
      CoTaskMemFree(Cookies.pElems);
    end;
end;

var  // init to zero, never written to
  DispParams: TDispParams = ();

procedure TsfOleControl.GetProperty(Index: Integer; var Value: TVarData);
var
  Status: HResult;
  ExcepInfo: TExcepInfo;
begin
  CreateControl;
  Value.VType := varEmpty;
  Status := FControlDispatch.Invoke(Index, GUID_NULL, 0,
    DISPATCH_PROPERTYGET, DispParams, @Value, @ExcepInfo, nil);
  if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
end;

function TsfOleControl.GetShortIntProp(Index: Integer): ShortInt;
begin
  Result := GetIntegerProp(Index);
end;

function TsfOleControl.GetSingleProp(Index: Integer): Single;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VSingle;
end;

function TsfOleControl.GetSmallintProp(Index: Integer): Smallint;
var
  Temp: TVarData;
begin
  GetProperty(Index, Temp);
  Result := Temp.VSmallint;
end;

function TsfOleControl.GetStringProp(Index: Integer): string;
begin
  Result := GetVariantProp(Index);
end;

function TsfOleControl.GetVariantProp(Index: Integer): Variant;
begin
  Result := GetOleVariantProp(Index);
end;

function TsfOleControl.GetWideStringProp(Index: Integer): WideString;
var
  Temp: TVarData;
begin
  Result := '';
  GetProperty(Index, Temp);
  Pointer(Result) := Temp.VOleStr;
end;

function TsfOleControl.GetWordProp(Index: Integer): Word;
begin
  Result := GetIntegerProp(Index);
end;

procedure TsfOleControl.HookControlWndProc;
var
  WndHandle: HWnd;
begin
{  if (FOleInPlaceObject <> nil) and (WindowHandle = 0) then
  begin
    WndHandle := 0;
    FOleInPlaceObject.GetWindow(WndHandle);
    if WndHandle = 0 then raise EOleError.CreateRes(@SNoWindowHandle);
    WindowHandle := WndHandle;
    DefWndProc := Pointer(GetWindowLong(WindowHandle, GWL_WNDPROC));
    CreationControl := Self;
    SetWindowLong(WindowHandle, GWL_WNDPROC, Longint(@InitWndProc));
    SendMessage(WindowHandle, WM_NULL, 0, 0);
  end;}
end;

procedure CallEventMethod(const EventInfo: TEventInfo);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EBP
        MOV     EBP,ESP
        MOV     EBX,EAX
        MOV     EDX,[EBX].TEventInfo.ArgCount
        TEST    EDX,EDX
        JE      @@5
        XOR     EAX,EAX
        LEA     ESI,[EBX].TEventInfo.Args
@@1:    MOV     AL,[ESI].TEventArg.Kind
        CMP     AL,1
        JA      @@2
        JE      @@3
        TEST    AH,AH
        JNE     @@3
        MOV     ECX,[ESI].Integer[4]
        MOV     AH,1
        JMP     @@4
@@2:    PUSH    [ESI].Integer[8]
@@3:    PUSH    [ESI].Integer[4]
@@4:    ADD     ESI,12
        DEC     EDX
        JNE     @@1
@@5:    MOV     EDX,[EBX].TEventInfo.Sender
        MOV     EAX,[EBX].TEventInfo.Method.Data
        CALL    [EBX].TEventInfo.Method.Code
        MOV     ESP,EBP
        POP     EBP
        POP     ESI
        POP     EBX
end;

type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;

procedure TsfOleControl.D2InvokeEvent(DispID: TDispID; var Params: TDispParams);
type
  TStringDesc = record
    PStr: Pointer;
    BStr: PBStr;
  end;
var
  I, J, K, ArgType, ArgCount, StrCount: Integer;
  ArgPtr: PEventArg;
  ParamPtr: PVarArg;
  Strings: array[0..MaxDispArgs - 1] of TStringDesc;
  EventInfo: TEventInfo;
begin
  GetEventMethod(DispID, EventInfo.Method);
  if Integer(EventInfo.Method.Code) >= $10000 then
  begin
    StrCount := 0;
    try
      ArgCount := Params.cArgs;
      EventInfo.Sender := Self;
      EventInfo.ArgCount := ArgCount;
      if ArgCount <> 0 then
      begin
        ParamPtr := @Params.rgvarg^[EventInfo.ArgCount];
        ArgPtr := @EventInfo.Args;
        I := 0;
        repeat
          Dec(Integer(ParamPtr), SizeOf(TVarArg));
          ArgType := ParamPtr^[0] and $0000FFFF;
          if ArgType and varTypeMask = varOleStr then
          begin
            ArgPtr^.Kind := akDWord;
            with Strings[StrCount] do
            begin
              PStr := nil;
              if ArgType and varByRef <> 0 then
              begin
                OleStrToStrVar(PBStr(ParamPtr^[2])^, string(PStr));
                BStr := PBStr(ParamPtr^[2]);
                ArgPtr^.Data[0] := Integer(@PStr);
              end else
              begin
                OleStrToStrVar(TBStr(ParamPtr^[2]), string(PStr));
                BStr := nil;
                ArgPtr^.Data[0] := Integer(PStr);
              end;
            end;
            Inc(StrCount);
          end else
          begin
            case ArgType of
              varSingle:
                begin
                  ArgPtr^.Kind := akSingle;
                  ArgPtr^.Data[0] := ParamPtr^[2];
                end;
              varDouble..varDate:
                begin
                  ArgPtr^.Kind := akDouble;
                  ArgPtr^.Data[0] := ParamPtr^[2];
                  ArgPtr^.Data[1] := ParamPtr^[3];
                end;
              varDispatch:
                begin
                  ArgPtr^.Kind := akDWord;
                  ArgPtr^.Data[0] := Integer(ParamPtr)
                end;
            else
              ArgPtr^.Kind := akDWord;
              if (ArgType and varArray) <> 0 then
                ArgPtr^.Data[0] := Integer(ParamPtr)
              else
                ArgPtr^.Data[0] := ParamPtr^[2];
            end;
          end;
          Inc(Integer(ArgPtr), SizeOf(TEventArg));
          Inc(I);
        until I = EventInfo.ArgCount;
      end;
      CallEventMethod(EventInfo);
      J := StrCount;
      while J <> 0 do
      begin
        Dec(J);
        with Strings[J] do
          if BStr <> nil then BStr^ := StringToOleStr(string(PStr));
      end;
    except
      Application.HandleException(Self);
    end;
    K := StrCount;
    while K <> 0 do
    begin
      Dec(K);
      string(Strings[K].PStr) := '';
    end;
  end;
end;

procedure TsfOleControl.InvokeEvent(DispID: TDispID; var Params: TDispParams);
var
  EventMethod: TMethod;
begin
  if ControlData.Version < 300 then
    D2InvokeEvent(DispID, Params)
  else
  begin
    GetEventMethod(DispID, EventMethod);
    if Integer(EventMethod.Code) < $10000 then Exit;

    try
      asm
                PUSH    EBX
                PUSH    ESI
                MOV     ESI, Params
                MOV     EBX, [ESI].TDispParams.cArgs
                TEST    EBX, EBX
                JZ      @@7
                MOV     ESI, [ESI].TDispParams.rgvarg
                MOV     EAX, EBX
                SHL     EAX, 4                         // count * sizeof(TVarArg)
                XOR     EDX, EDX
                ADD     ESI, EAX                       // EDI = Params.rgvarg^[ArgCount]
        @@1:    SUB     ESI, 16                        // Sizeof(TVarArg)
                MOV     EAX, dword ptr [ESI]
                CMP     AX, varSingle                  // 4 bytes to push
                JA      @@3
                JE      @@5                            
        @@2:    TEST    DL,DL
                JNE     @@2a
                MOV     ECX, ESI
                INC     DL
                TEST    EAX, varArray
                JNZ     @@6
                MOV     ECX, dword ptr [ESI+8]
                JMP     @@6
        @@2a:   TEST    EAX, varArray
                JZ      @@5
                PUSH    ESI
                JMP     @@6
        @@3:    CMP     AX, varDate                    // 8 bytes to push
                JA      @@2
        @@4:    PUSH    dword ptr [ESI+12]
        @@5:    PUSH    dword ptr [ESI+8]
        @@6:    DEC     EBX
                JNE     @@1
        @@7:    MOV     EDX, Self
                MOV     EAX, EventMethod.Data
                CALL    EventMethod.Code
                POP     ESI
                POP     EBX
      end;
    except
      Application.HandleException(Self);
    end;
  end;
end;

procedure GetStringResult(BStr: TBStr; var Result: string);
begin
  try
    OleStrToStrVar(BStr, Result);
  finally
    SysFreeString(BStr);
  end;
end;

procedure TsfOleControl.InitControlInterface;
begin
end;

procedure TsfOleControl.InvokeMethod(const DispInfo; Result: Pointer); assembler;
{$IFNDEF AL_COMPILER7_UP}
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX
        CALL    TsfOleControl.CreateControl
        PUSH    [ESI].TDispInfo.DispID
        MOV     ECX,ESP
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    EAX
        PUSH    EAX
        PUSH    EAX
        MOV     EDX,ESP
        LEA     EAX,[EBP+16]
        CMP     [ESI].TDispInfo.ResType,varOleStr
        JE      @@1
        CMP     [ESI].TDispInfo.ResType,varVariant
        JE      @@1
        LEA     EAX,[EBP+12]
@@1:    PUSH    EAX
        PUSH    EDX
        LEA     EDX,[ESI].TDispInfo.CallDesc
        MOV     EAX,[EBX].TsfOleControl.FControlDispatch
        CALL    DispatchInvoke
        XOR     EAX,EAX
        MOV     AL,[ESI].TDispInfo.ResType
        JMP     @ResultTable.Pointer[EAX*4]

@ResultTable:
        DD      @ResEmpty
        DD      @ResNull
        DD      @ResSmallint
        DD      @ResInteger
        DD      @ResSingle
        DD      @ResDouble
        DD      @ResCurrency
        DD      @ResDate
        DD      @ResString
        DD      @ResDispatch
        DD      @ResError
        DD      @ResBoolean
        DD      @ResVariant

@ResSmallint:
@ResBoolean:
        MOV     AX,[ESP+8]
        MOV     [EDI],AX
        JMP     @ResDone

@ResString:
        MOV     EAX,[ESP+8]
        MOV     EDX,EDI
        CALL    GetStringResult
        JMP     @ResDone

@ResVariant:
        MOV     EAX,EDI
        CALL    System.@VarClear
        MOV     ESI,ESP
        MOV     ECX,4
        REP     MOVSD
        JMP     @ResDone

@ResDouble:
@ResCurrency:
@ResDate:
        MOV     EAX,[ESP+12]
        MOV     [EDI+4],EAX

@ResInteger:
@ResSingle:
        MOV     EAX,[ESP+8]
        MOV     [EDI],EAX

@ResEmpty:
@ResNull:
@ResDispatch:
@ResError:
@ResDone:
        ADD     ESP,20
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ELSE}
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX
        CALL    TOleControl.CreateControl
        PUSH    [ESI].TDispInfo.DispID
        MOV     ECX,ESP
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    EAX
        PUSH    EAX
        PUSH    EAX
        MOV     EDX,ESP
        LEA     EAX,[EBP+16]
        CMP     [ESI].TDispInfo.ResType,varOleStr
        JE      @@1
        CMP     [ESI].TDispInfo.ResType,varVariant
        JE      @@1
        LEA     EAX,[EBP+12]
@@1:    PUSH    EAX
        PUSH    EDX
        LEA     EDX,[ESI].TDispInfo.CallDesc
        MOV     EAX,[EBX].TOleControl.FControlDispatch
        CALL    DispatchInvoke
        XOR     EAX,EAX
        MOV     AL,[ESI].TDispInfo.ResType
        JMP     @ResultTable.Pointer[EAX*4]

@ResultTable:
        DD      @ResEmpty
        DD      @ResNull
        DD      @ResSmallint
        DD      @ResInteger
        DD      @ResSingle
        DD      @ResDouble
        DD      @ResCurrency
        DD      @ResDate
        DD      @ResString
        DD      @ResDispatch
        DD      @ResError
        DD      @ResBoolean
        DD      @ResVariant

@ResSmallint:
@ResBoolean:
        MOV     AX,[ESP+8]
        MOV     [EDI],AX
        JMP     @ResDone

@ResString:
        MOV     EAX,[ESP+8]
        MOV     EDX,EDI
        CALL    GetStringResult
        JMP     @ResDone

@ResVariant:
        MOV     EAX,EDI
        CALL    System.@VarClear
        MOV     ESI,ESP
        MOV     ECX,4
        REP     MOVSD
        JMP     @ResDone

@ResDouble:
@ResCurrency:
@ResDate:
        MOV     EAX,[ESP+12]
        MOV     [EDI+4],EAX

@ResInteger:
@ResSingle:
        MOV     EAX,[ESP+8]
        MOV     [EDI],EAX

@ResEmpty:
@ResNull:
@ResDispatch:
@ResError:
@ResDone:
        ADD     ESP,20
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ENDIF}

function TsfOleControl.IsCustomProperty(DispID: Integer): Boolean;
var
  W: WideString;
begin
  Result := (FPropBrowsing <> nil) and
    (FPropBrowsing.GetDisplayString(DispID, W) = 0);
end;

function TsfOleControl.IsPropPageProperty(DispID: Integer): Boolean;
var
  PPID: TCLSID;
begin
  Result := (FPropBrowsing <> nil) and
    (FPropBrowsing.MapPropertyToPage(DispID, PPID) = S_FALSE) and not
    IsEqualCLSID(PPID, GUID_NULL);
end;

function TsfOleControl.PaletteChanged(Foreground: Boolean): Boolean;
begin
  Result := False;
{  if HandleAllocated and Foreground then
    Result := CallWindowProc(DefWndProc, Handle, WM_QUERYNEWPALETTE, 0, 0) <> 0;
  if not Result then}
    Result := inherited PaletteChanged(Foreground);
end;

procedure TsfOleControl.PictureChanged(Sender: TObject);
var
  I: Integer;
begin
  if (FPictures = nil) or not (Sender is TPicture) then Exit;
  for I := 0 to FPictures.Count - 1 do
    if FPictures[I] = Sender then
    begin
      if (TPicture(Sender).PictureAdapter <> nil) then
        SetTPictureProp(FControlData.PictureIDs^[I], TPicture(Sender));
      Exit;
    end;
end;

procedure TsfOleControl.ReadData(Stream: TStream);
var
  Buffer: Pointer;
begin
  DestroyStorage;
  try
    FObjectData := GlobalAlloc(GMEM_MOVEABLE, Stream.Size);
    if FObjectData = 0 then OutOfMemoryError;
    Buffer := GlobalLock(FObjectData);
    try
      Stream.Read(Buffer^, Stream.Size);
    finally
      GlobalUnlock(FObjectData);
    end;
  except
    DestroyStorage;
  end;
end;

procedure TsfOleControl.AdjustSize;
begin
  inherited;
end;

procedure TsfOleControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  R: TRect;
begin
  if FFlashNotExists then
  begin
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  end
  else
  begin
    if not FResizing then
    begin
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
      FResizing := true;
      try
        { Update ole object }
        R := Rect(0, 0, AWidth, AHeight);
        if (FOleInPlaceObject <> nil) then
          FOleInPlaceObject.SetObjectRects(R, R);
        if (FOleInPlaceObjectWindowless <> nil) then
          FOleInPlaceObjectWindowless.SetObjectRects(R, R);
        { Create / resize buffer }
        if FBackBuffer = nil then
          FBackBuffer := TsfBitmap.Create;
        FBackBuffer.SetSize(AWidth, AHeight);
        if FBuffer = nil then
          FBuffer := TsfBitmap.Create;
        if FBuffer2 = nil then
          FBuffer2 := TsfBitmap.Create;
        FBuffer.SetSize(AWidth, AHeight);
        FBuffer2.SetSize(AWidth, AHeight);

        if FGrabProcess then
        begin
          FBuffer.Clear(0);
          FBuffer2.Clear(0);
          FBackBuffer.Clear(0);
        end;

        PaintBackground;
        FNeedUpdate := true;
      finally
        FResizing := false;
      end;
    end
    else
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  end;
end;

procedure TsfOleControl.SetByteProp(Index: Integer; Value: Byte);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetColorProp(Index: Integer; Value: TColor);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetTColorProp(Index: Integer; Value: TColor);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetCompProp(Index: Integer; const Value: Comp);
var
  Temp: TVarData;
begin
  Temp.VType := VT_I8;
  Temp.VDouble := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetCurrencyProp(Index: Integer; const Value: Currency);
var
  Temp: TVarData;
begin
  Temp.VType := varCurrency;
  Temp.VCurrency := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetDoubleProp(Index: Integer; const Value: Double);
var
  Temp: TVarData;
begin
  Temp.VType := varDouble;
  Temp.VDouble := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetIDispatchProp(Index: Integer; const Value: IDispatch);
var
  Temp: TVarData;
begin
  Temp.VType := varDispatch;
  Temp.VDispatch := Pointer(Value);
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetIntegerProp(Index: Integer; Value: Integer);
var
  Temp: TVarData;
begin
  Temp.VType := varInteger;
  Temp.VInteger := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetIUnknownProp(Index: Integer; const Value: IUnknown);
var
  Temp: TVarData;
begin
  Temp.VType := VT_UNKNOWN;
  Temp.VUnknown := Pointer(Value);
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetName(const Value: TComponentName);
var
  OldName: string;
  DispID: Integer;
begin
  OldName := Name;
  inherited SetName(Value);
  if FOleControl <> nil then
  begin
    FOleControl.OnAmbientPropertyChange(DISPID_AMBIENT_DISPLAYNAME);
    if FControlData^.Flags and (cfCaption or cfText) <> 0 then
    begin
      if FControlData^.Flags and cfCaption <> 0 then
        DispID := DISPID_CAPTION else
        DispID := DISPID_TEXT;
      if OldName = GetStringProp(DispID) then SetStringProp(DispID, Value);
    end;
  end;
end;

procedure TsfOleControl.SetWordBoolProp(Index: Integer; Value: WordBool);
var
  Temp: TVarData;
begin
  Temp.VType := varBoolean;
  if Value then
    Temp.VBoolean := WordBool(-1) else
    Temp.VBoolean := WordBool(0);
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetTDateTimeProp(Index: Integer; const Value: TDateTime);
var
  Temp: TVarData;
begin
  Temp.VType := varDate;
  Temp.VDate := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetTFontProp(Index: Integer; Value: TFont);
var
  I: Integer;
  F: TFont;
  Temp: IFontDisp;
begin
  for I := 0 to FFonts.Count-1 do
    if FControlData^.FontIDs^[I] = Index then
    begin
      F := TFont(FFonts[I]);
      F.Assign(Value);
      if F.FontAdapter = nil then
      begin
        GetOleFont(F, Temp);
        SetIDispatchProp(Index, Temp);
      end;
    end;
end;

procedure TsfOleControl.SetOleBoolProp(Index: Integer; Value: TOleBool);
var
  Temp: TVarData;
begin
  Temp.VType := varBoolean;
  if Value then
    Temp.VBoolean := WordBool(-1) else
    Temp.VBoolean := WordBool(0);
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetOleDateProp(Index: Integer; const Value: TOleDate);
var
  Temp: TVarData;
begin
  Temp.VType := varDate;
  Temp.VDate := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetOleEnumProp(Index: Integer; Value: TOleEnum);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetTOleEnumProp(Index: Integer; Value: TOleEnum);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetOleVariantProp(Index: Integer; const Value: OleVariant);
begin
  SetProperty(Index, TVarData(Value));
end;

procedure TsfOleControl.SetParent(AParent: TWinControl);
var
  CS: IOleClientSite_Flash;
  X: Integer;
begin
  inherited SetParent(AParent);
  if FFlashNotExists then Exit;
  if (AParent <> nil) then
  begin
    try  // work around ATL bug
      X := FOleObject.GetClientSite(CS);
    except
      X := -1;
    end;
    if (X <> 0) or (CS = nil) then
      OleCheck(FOleObject.SetClientSite(Self));
    if FOleControl <> nil then
      FOleControl.OnAmbientPropertyChange(DISPID_UNKNOWN);
  end
  else
  begin
      X := -1;
  end;
end;

procedure TsfOleControl.SetTPictureProp(Index: Integer; Value: TPicture);
var
  I: Integer;
  P: TPicture;
  Temp: IPictureDisp;
begin
  if FUpdatingPictures then Exit;
  FUpdatingPictures := True;
  try
    for I := 0 to FPictures.Count-1 do
      if FControlData^.PictureIDs^[I] = Index then
      begin
        P := TPicture(FPictures[I]);
        P.Assign(Value);
        GetOlePicture(P, Temp);
        SetIDispatchProp(Index, Temp);
      end;
  finally
    FUpdatingPictures := False;
  end;
end;

procedure TsfOleControl.SetPropDisplayString(DispID: Integer;
  const Value: string);
var
  I: Integer;
  Values: TStringList;
  V: OleVariant;
begin
  Values := TStringList.Create;
  try
    GetPropDisplayStrings(DispID, Values);
    for I := 0 to Values.Count - 1 do
      if AnsiCompareText(Value, Values[I]) = 0 then
      begin
        OleCheck(FPropBrowsing.GetPredefinedValue(DispID,
          Integer(Values.Objects[I]), V));
        SetProperty(DispID, TVarData(V));
        Exit;
      end;
  finally
    Values.Free;
  end;
  SetStringProp(DispID, Value);
end;

procedure TsfOleControl.SetProperty(Index: Integer; const Value: TVarData);
const
  DispIDArgs: Longint = DISPID_PROPERTYPUT;
var
  Status, InvKind: Integer;
  DispParams: TDispParams;
  ExcepInfo: TExcepInfo;
begin
  if FFlashNotExists then Exit;

  CreateControl;
  DispParams.rgvarg := @Value;
  DispParams.rgdispidNamedArgs := @DispIDArgs;
  DispParams.cArgs := 1;
  DispParams.cNamedArgs := 1;
  if Value.VType <> varDispatch then
    InvKind := DISPATCH_PROPERTYPUT else
    InvKind := DISPATCH_PROPERTYPUTREF;
  Status := FControlDispatch.Invoke(Index, GUID_NULL, 0,
    InvKind, DispParams, nil, @ExcepInfo, nil);
  if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
end;

procedure TsfOleControl.SetShortintProp(Index: Integer; Value: ShortInt);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl.SetSingleProp(Index: Integer; const Value: Single);
var
  Temp: TVarData;
begin
  Temp.VType := varSingle;
  Temp.VSingle := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetSmallintProp(Index: Integer; Value: Smallint);
var
  Temp: TVarData;
begin
  Temp.VType := varSmallint;
  Temp.VSmallint := Value;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetStringProp(Index: Integer; const Value: string);
var
  Temp: TVarData;
begin
  Temp.VType := varOleStr;
  Temp.VOleStr := StringToOleStr(Value);
  try
    SetProperty(Index, Temp);
  finally
    SysFreeString(Temp.VOleStr);
  end;
end;

procedure TsfOleControl.SetUIActive(Active: Boolean);
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
{  if Form <> nil then
    if Active then
    begin
      if (Form.ActiveOleControl <> nil) and
        (Form.ActiveOleControl <> Self) then
        Form.ActiveOleControl.Perform(CM_UIDEACTIVATE, 0, 0);
      Form.ActiveOleControl := Self;
    end else
      if Form.ActiveOleControl = Self then Form.ActiveOleControl := nil; }
end;

procedure TsfOleControl.SetVariantProp(Index: Integer; const Value: Variant);
begin
  SetOleVariantProp(Index, Value);
end;

procedure TsfOleControl.SetWideStringProp(Index: Integer; const Value: WideString);
var
  Temp: TVarData;
begin
  Temp.VType := varOleStr;
  if Value <> '' then
    Temp.VOleStr := PWideChar(Value)
  else
    Temp.VOleStr := nil;
  SetProperty(Index, Temp);
end;

procedure TsfOleControl.SetWordProp(Index: Integer; Value: Word);
begin
  SetIntegerProp(Index, Value);
end;

procedure TsfOleControl._SetColorProp(Index: Integer; Value: TColor);
begin
  SetColorProp(Index, Value);
end;

procedure TsfOleControl._SetTColorProp(Index: Integer; Value: TColor);
begin
  SetTColorProp(Index, Value);
end;

procedure TsfOleControl._SetTOleEnumProp(Index: Integer; Value: TOleEnum);
begin
  SetTOleEnumProp(Index, Value);
end;

procedure TsfOleControl._SetTFontProp(Index: Integer; Value: TFont);
begin
  SetTFontProp(Index, Value);
end;

procedure TsfOleControl._SetTPictureProp(Index: Integer; Value: TPicture);
begin
  SetTPictureProp(Index, Value);
end;


procedure TsfOleControl.ShowAboutBox;
const
  DispInfo: array[0..7] of Byte = ($D8,$FD,$FF,$FF,$00,$01,$00,$00);
begin
  InvokeMethod(DispInfo, nil);
end;

procedure TsfOleControl.StandardEvent(DispID: TDispID; var Params: TDispParams);
type
  PVarDataList = ^TVarDataList;
  TVarDataList = array[0..3] of TVarData;
const
  ShiftMap: array[0..7] of TShiftState = (
    [],
    [ssShift],
    [ssCtrl],
    [ssShift, ssCtrl],
    [ssAlt],
    [ssShift, ssAlt],
    [ssCtrl, ssAlt],
    [ssShift, ssCtrl, ssAlt]);
  MouseMap: array[0..7] of TShiftState = (
    [],
    [ssLeft],
    [ssRight],
    [ssLeft, ssRight],
    [ssMiddle],
    [ssLeft, ssMiddle],
    [ssRight, ssMiddle],
    [ssLeft, ssRight, ssMiddle]);
  ButtonMap: array[0..7] of TMouseButton = (
    mbLeft, mbLeft, mbRight, mbLeft, mbMiddle, mbLeft, mbRight, mbLeft);
var
  Args: PVarDataList;
  Shift: TShiftState;
  Button: TMouseButton;
  X, Y: Integer;
  Key: Word;
  Ch: AnsiChar;
begin
  Args := PVarDataList(Params.rgvarg);
  try
    case DispID of
      DISPID_CLICK:
        Click;
      DISPID_DBLCLICK:
        DblClick;
      DISPID_KEYDOWN, DISPID_KEYUP:
        if Params.cArgs >= 2 then
        begin
          Key := Variant(Args^[1]);
          X := Variant(Args^[0]);
{          case DispID of
            DISPID_KEYDOWN: KeyDown(Key, ShiftMap[X and 7]);
            DISPID_KEYUP:   KeyUp(Key, ShiftMap[X and 7]);
          end;}
          if ((Args^[1].vType and varByRef) <> 0) then
            Word(Args^[1].VPointer^) := Key;
        end;
      DISPID_KEYPRESS:
        if Params.cArgs > 0 then
        begin
          Ch := AnsiChar(Integer(Variant(Args^[0])));
//          KeyPress(Ch);
          if ((Args^[0].vType and varByRef) <> 0) then
            AnsiChar(Args^[0].VPointer^) := Ch;
        end;
      DISPID_MOUSEDOWN, DISPID_MOUSEMOVE, DISPID_MOUSEUP:
        if Params.cArgs >= 4 then
        begin
          X := Integer(Variant(Args^[3])) and 7;
          Y := Integer(Variant(Args^[2])) and 7;
          Button := ButtonMap[X];
          Shift := ShiftMap[Y] + MouseMap[X];
          X := Variant(Args^[1]);
          Y := Variant(Args^[0]);
          case DispID of
            DISPID_MOUSEDOWN:
              MouseDown(Button, Shift, X, Y);
            DISPID_MOUSEMOVE:
              MouseMove(Shift, X, Y);
            DISPID_MOUSEUP:
              MouseUp(Button, Shift, X, Y);
          end;
        end;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TsfOleControl.WndProc(var Message: TMessage);
var
  P: TPoint;
  R: LRESULT;
begin
  if FFlashNotExists or (csDesigning in ComponentState) then
  begin
    inherited WndProc(Message);
    Exit;
  end;

  if (Message.Msg <> WM_PAINT) or (Message.Msg >= CN_BASE) or (Message.Msg >= CM_BASE) then
  begin
    if (Message.Msg = WM_RBUTTONDOWN) then
    begin
      { Skip right button }
      if not FDisableFlashPopup then
        FNeedHandle := true
      else
      begin
        inherited ;
        Exit;
      end;
    end;

    if (FOleInPlaceObjectWindowless <> nil) then
    begin
      if (FOleInPlaceObjectWindowless.OnWindowMessage(Message.Msg, Message.wParam, Message.lParam, Message.Result) = S_OK) then
      begin
        { Reset cursor }
        if (Message.Msg >= WM_MOUSEFIRST) and (Message.Msg <= WM_MOUSELAST) then
        begin
          R := 0;
          if DisableFlashCursor then
            SetCursor(Screen.Cursors[Cursor])
          else
            FOleInPlaceObjectWindowless.OnWindowMessage(WM_SETCURSOR, 0, Cardinal(SmallPoint(HTCLIENT, WM_MOUSEMOVE)), R);
        end;
        { Skip def WndProc }
        inherited WndProc(Message); // OnClick event handle
        Exit;
      end;
    end;
  end;
  inherited WndProc(Message);
end;

procedure TsfOleControl.WriteData(Stream: TStream);
var
  StorageExists: Boolean;
  Buffer: Pointer;
begin
  StorageExists := FObjectData <> 0;
  try
    try
      if not StorageExists then CreateStorage;
      Buffer := GlobalLock(FObjectData);
      try
        Stream.Write(Buffer^, GlobalSize(FObjectData));
      finally
        GlobalUnlock(FObjectData);
      end;
    finally
      if not StorageExists then DestroyStorage;
    end;
  except
    on E: Exception do
      if not SuppressException(E)
       then raise;
  end;
end;

procedure TsfOleControl.CMDocWindowActivate(var Message: TMessage);
var
  Form: TCustomForm;
  F: TForm;
begin
  Form := GetParentForm(Self);
  F := nil;
  if Form is TForm then F := TForm(Form);
  if (F <> nil) and (F.FormStyle = fsMDIChild) then
  begin
    FOleInPlaceActiveObject.OnDocWindowActivate(LongBool(Message.WParam));
    if Message.WParam = 0 then SetMenu(0, 0, 0);
  end;
end;

procedure TsfOleControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
{  if (FControlData^.Flags and cfBackColor <> 0) and not FUpdatingColor and
    HandleAllocated then
  begin
    FUpdatingColor := True;
    try
      SetColorProp(DISPID_BACKCOLOR, Color);
    finally
      FUpdatingColor := False;
    end;
  end;}
end;

procedure TsfOleControl.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
{  if (FControlData^.Flags and cfEnabled <> 0) and not FUpdatingEnabled and
    HandleAllocated then
  begin
    FUpdatingEnabled := True;
    try
      SetWordBoolProp(DISPID_ENABLED, Enabled);
    finally
      FUpdatingEnabled := False;
    end;
  end;}
end;

procedure TsfOleControl.CMFontChanged(var Message: TMessage);
begin
  inherited;
{  if (FControlData^.Flags and (cfForeColor or cfFont) <> 0) and
    not FUpdatingFont and HandleAllocated then
  begin
    FUpdatingFont := True;
    try
      if FControlData^.Flags and cfForeColor <> 0 then
        SetIntegerProp(DISPID_FORECOLOR, Font.Color);
      if FControlData^.Flags and cfFont <> 0 then
        SetVariantProp(DISPID_FONT, FontToOleFont(Font));
    finally
      FUpdatingFont := False;
    end;
  end;}
end;

procedure TsfOleControl.CMDialogKey(var Message: TMessage);
var
  Info: TControlInfo;
  Msg: TMsg;
  Cmd: Word;
begin
{  if CanFocus then
  begin
    Info.cb := SizeOf(Info);
    if (FOleControl.GetControlInfo(Info) = S_OK) and (Info.cAccel <> 0) then
    begin
      FillChar(Msg, SizeOf(Msg), 0);
      Msg.hwnd := Handle;
      Msg.message := WM_KEYDOWN;
      Msg.wParam := Message.WParam;
      Msg.lParam := Message.LParam;
      if IsAccelerator(Info.hAccel, Info.cAccel, @Msg, Cmd) then
      begin
        FOleControl.OnMnemonic(@Msg);
        Message.Result := 1;
        Exit;
      end;
    end;
  end;      }
  inherited;
end;

procedure TsfOleControl.CMUIActivate(var Message: TMessage);
var
  F: TCustomForm;
begin
{  F := GetParentForm(Self);
  if (F = nil) or (F.ActiveOleControl <> Self) then
    FOleObject.DoVerb(OLEIVERB_UIACTIVATE, nil, Self, 0,
      GetParentHandle, BoundsRect);}
end;

procedure TsfOleControl.CMUIDeactivate(var Message: TMessage);
var
  F: TCustomForm;
begin
{  F := GetParentForm(Self);
  if (F = nil) or (F.ActiveOleControl = Self) then
  begin
    if FOleInPlaceObject <> nil then FOleInPlaceObject.UIDeactivate;
    if (F <> nil) and (F.ActiveControl = Self) then OnUIDeactivate(False);
  end;}
end;

{ TsfOleControl.IUnknown }

function TsfOleControl.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TsfOleControl._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TsfOleControl._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

{ TsfOleControl.IOleClientSite_Flash}

function TsfOleControl.SaveObject: HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
  out mk: IMoniker_Flash): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetContainer(out container: IOleContainer_Flash): HResult;
begin
  Result := E_NOINTERFACE;
end;

function TsfOleControl.ShowObject: HResult;
begin
  HookControlWndProc;
  Result := S_OK;
end;

function TsfOleControl.OnShowWindow(fShow: BOOL): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.RequestNewObjectLayout: HResult;
var
  Extent: TPoint;
  W, H: Integer;
begin
  Result := FOleObject.GetExtent(DVASPECT_CONTENT, Extent);
  if Result <> S_OK then Exit;
  W := MulDiv(Extent.X, Screen.PixelsPerInch, 2540);
  H := MulDiv(Extent.Y, Screen.PixelsPerInch, 2540);
  if (FMiscStatus and OLEMISC_INVISIBLEATRUNTIME <> 0) and (FOleControl = nil) then
  begin
    if W > 32 then W := 32;
    if H > 32 then H := 32;
  end;
  SetBounds(Left, Top, W, H);
end;

{ TsfOleControl.IOleControlSite }

function TsfOleControl.OnControlInfoChanged: HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.LockInPlaceActive(fLock: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetExtendedControl(out disp: IDispatch): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.TransformCoords(var ptlHimetric: TPoint;
  var ptfContainer: TPointF; flags: Longint): HResult;
begin
  if flags and XFORMCOORDS_HIMETRICTOCONTAINER <> 0 then
  begin
    ptfContainer.X := MulDiv(ptlHimetric.X, Screen.PixelsPerInch, 2540);
    ptfContainer.Y := MulDiv(ptlHimetric.Y, Screen.PixelsPerInch, 2540);
  end else
  begin
    ptlHimetric.X := Integer(Round(ptfContainer.X * 2540 / Screen.PixelsPerInch));
    ptlHimetric.Y := Integer(Round(ptfContainer.Y * 2540 / Screen.PixelsPerInch));
  end;
  Result := S_OK;
end;

function TsfOleControl.OleControlSite_TranslateAccelerator(
  msg: PMsg; grfModifiers: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.OnFocus(fGotFocus: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.ShowPropertyFrame: HResult;
begin
  Result := E_NOTIMPL;
end;

{ TsfOleControl.IOleInPlaceFrame }

function TsfOleControl.OleInPlaceFrame_GetWindow(out wnd: HWnd): HResult;
begin
//  wnd := GetTopParentHandle;
  Result := S_OK;
end;

function TsfOleControl.InsertMenus(hmenuShared: HMenu;
  var menuWidths: TOleMenuGroupWidths): HResult;
var
  Menu: TMainMenu;
begin
  Menu := GetMainMenu;
  if Menu <> nil then
    Menu.PopulateOle2Menu(hmenuShared, [0, 2, 4], menuWidths.width);
  Result := S_OK;
end;

function TsfOleControl.SetMenu(hmenuShared: HMenu; holemenu: HMenu;
  hwndActiveObject: HWnd): HResult;
var
  Menu: TMainMenu;
begin
  Menu := GetMainMenu;
  Result := S_OK;
  if Menu <> nil then
  begin
    Menu.SetOle2MenuHandle(hmenuShared);
    Result := OleSetMenuDescriptor(holemenu, Menu.WindowHandle,
      hwndActiveObject, nil, nil);
  end;
end;

function TsfOleControl.RemoveMenus(hmenuShared: HMenu): HResult;
begin
  while GetMenuItemCount(hmenuShared) > 0 do
    RemoveMenu(hmenuShared, 0, MF_BYPOSITION);
  Result := S_OK;
end;

function TsfOleControl.SetStatusText(pszStatusText: POleStr): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.EnableModeless(fEnable: BOOL): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.OleInPlaceFrame_TranslateAccelerator(
  var msg: TMsg; wID: Word): HResult;
begin
  Result := S_FALSE;
end;

{ TsfOleControl.IDispatch }

function TsfOleControl.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;

function TsfOleControl.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params;
  VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var
  F: TFont;
begin
  if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil) then
  begin
    Result := S_OK;
    case DispID of
      DISPID_AMBIENT_BACKCOLOR:
        PVariant(VarResult)^ := Color;
      DISPID_AMBIENT_DISPLAYNAME:
        PVariant(VarResult)^ := StringToVarOleStr(Name);
      DISPID_AMBIENT_FONT:
      begin
        if (Parent <> nil) and ParentFont then
          F := TsfOleControl(Parent).Font
        else
          F := Font;
        PVariant(VarResult)^ := FontToOleFont(F);
      end;
      DISPID_AMBIENT_FORECOLOR:
        PVariant(VarResult)^ := Font.Color;
      DISPID_AMBIENT_LOCALEID:
        PVariant(VarResult)^ := Integer(GetUserDefaultLCID);
      DISPID_AMBIENT_MESSAGEREFLECT:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_USERMODE:
        PVariant(VarResult)^ := not (csDesigning in ComponentState);
      DISPID_AMBIENT_UIDEAD:
        PVariant(VarResult)^ := csDesigning in ComponentState;
      DISPID_AMBIENT_SHOWGRABHANDLES:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SHOWHATCHING:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SUPPORTSMNEMONICS:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_AUTOCLIP:
        PVariant(VarResult)^ := True;
    else
      Result := DISP_E_MEMBERNOTFOUND;
    end;
  end else
    Result := DISP_E_MEMBERNOTFOUND;
end;

{ TsfOleControl.IPropertyNotifySink }

function TsfOleControl.OnChanged(dispid: TDispID): HResult;
begin
  try
    case dispid of
      DISPID_BACKCOLOR:
        if not FUpdatingColor then
        begin
          FUpdatingColor := True;
          try
            Color := GetIntegerProp(DISPID_BACKCOLOR);
          finally
            FUpdatingColor := False;
          end;
        end;
      DISPID_ENABLED:
        if not FUpdatingEnabled then
        begin
          FUpdatingEnabled := True;
          try
            Enabled := GetWordBoolProp(DISPID_ENABLED);
          finally
            FUpdatingEnabled := False;
          end;
        end;
      DISPID_FONT:
        if not FUpdatingFont then
        begin
          FUpdatingFont := True;
          try
            OleFontToFont(GetVariantProp(DISPID_FONT), Font);
          finally
            FUpdatingFont := False;
          end;
        end;
      DISPID_FORECOLOR:
        if not FUpdatingFont then
        begin
          FUpdatingFont := True;
          try
            Font.Color := GetIntegerProp(DISPID_FORECOLOR);
          finally
            FUpdatingFont := False;
          end;
        end;
    end;
  except  // control sent us a notification for a dispid it doesn't have.
    on EOleError do ;
  end;
  Result := S_OK;
end;

function TsfOleControl.OnRequestEdit(dispid: TDispID): HResult;
begin
  Result := S_OK;
end;

{ TsfOleControl.ISimpleFrameSite }

function TsfOleControl.PreMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
  out res: Integer; out Cookie: Longint): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.PostMessageFilter(wnd: HWnd; msg, wp, lp: Integer;
  out res: Integer; Cookie: Longint): HResult;
begin
  Result := S_OK;
end;

{ TsfOleControl.IOleWindow }

function TsfOleControl.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := S_OK;
end;

{ TOleControl.IOleInPlaceSite }

function TsfOleControl.OleInPlaceSite_GetWindow(out wnd: HWnd): HResult;
begin
  Result := S_OK;
  if FNeedHandle then
  begin
    if (Parent <> nil) then
      wnd := Parent.Handle
    else
      wnd := 0;
    FNeedHandle := false;
  end
  else
    wnd := GetParentHandle;
  if wnd = 0 then Result := E_FAIL;
end;

function TsfOleControl.CanInPlaceActivate: HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.OnInPlaceActivate: HResult;
begin
  FOleObject.QueryInterface(IOleInPlaceObject, FOleInPlaceObject);
  FOleObject.QueryInterface(IOleInPlaceActiveObject, FOleInPlaceActiveObject);
  FOleObject.QueryInterface(IOleInPlaceObjectWindowless, FOleInPlaceObjectWindowless);
  FOleObject.QueryInterface(IViewObject, FViewObject);

  Result := S_OK;
end;

function TsfOleControl.OnUIActivate: HResult;
begin
  SetUIActive(True);
  Result := S_OK;
end;

function TsfOleControl.GetWindowContext(out frame: IOleInPlaceFrame;
  out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
  out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
begin
  frame := Self;
  doc := nil;
  rcPosRect := BoundsRect;
  SetRect(rcClipRect, 0, 0, 32767, 32767);
  with frameInfo do
  begin
    fMDIApp := False;
//    hWndFrame := GetTopParentHandle;
    hWndFrame := GetParentHandle;
    hAccel := 0;
    cAccelEntries := 0;
  end;
  Result := S_OK;
end;

function TsfOleControl.Scroll(scrollExtent: TPoint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.OnUIDeactivate(fUndoable: BOOL): HResult;
begin
  SetMenu(0, 0, 0);
  SetUIActive(False);
  Result := S_OK;
end;

function TsfOleControl.OnInPlaceDeactivate: HResult;
begin
  FOleInPlaceActiveObject := nil;
  FOleInPlaceObject := nil;
  FOleInPlaceObjectWindowless := nil;
  FViewObject := nil;
  Result := S_OK;
end;

function TsfOleControl.DiscardUndoState: HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.DeactivateAndUndo: HResult;
begin
  FOleInPlaceObject.UIDeactivate;
  Result := S_OK;
end;

function TsfOleControl.OnPosRectChange(const rcPosRect: TRect): HResult;
begin
  FOleInPlaceObject.SetObjectRects(rcPosRect, Rect(0, 0, 32767, 32767));
  Result := S_OK;
end;

{ TsfOleControl.IOleInPlaceUIWindow }

function TsfOleControl.GetBorder(out rectBorder: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TsfOleControl.RequestBorderSpace(const borderwidths: TRect): HResult;
begin
  Result := INPLACE_E_NOTOOLSPACE;
end;

function TsfOleControl.SetBorderSpace(pborderwidths: PRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.SetActiveObject(const activeObject: IOleInPlaceActiveObject;
  pszObjName: POleStr): HResult;
begin
  FOleInPlaceActiveObject := activeObject;
  Result := S_OK;
end;

{ IOleInPlaceSiteWindowless }

function TsfOleControl.AdjustRect(var rc: TRect): HResult;
begin
  rc := ClientRect;
  Result := S_OK;
end;

function TsfOleControl.CanWindowlessActivate: HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.GetCapture: HResult;
begin
  if FCaptured then
    Result := S_OK
  else
    Result := S_FALSE;
end;

function TsfOleControl.GetDC(var rc: TRect; qrfFlags: DWORD;
  var hDC: HDC): HResult;
begin
  hDC := Canvas.Handle;
  Result := S_OK;
end;

function TsfOleControl.GetFocus: HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.InvalidateRect(Rect: PRect;
  fErase: BOOL): HResult;
begin
  if (Parent <> nil) then
  begin
    FPaintRect := Rect;
    if FNeedUpdate then
    begin
      FNeedUpdate := false;
      FPaintRect := nil;
    end;
    Paint;
  end;
  Result := S_OK;
end;

function TsfOleControl.InvalidateRgn(hRGN: HRGN; fErase: BOOL): HResult;
begin
  if Parent <> nil then Paint;
  Result := S_OK;
end;

function TsfOleControl.OnDefWindowMessage(msg: LongWord; wParam: WPARAM;
  lParam: LPARAM; var LResult: LRESULT): HResult;
begin
  Result := S_OK;
  LResult := Perform(msg, wParam, lParam);
end;

function TsfOleControl.ReleaseDC(hDC: HDC): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.ScrollRect(dx, dy: Integer; var RectScroll,
  RectClip: TRect): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.SetCapture(ACapture: BOOL): HResult;
begin
  if (Parent <> nil) and (Parent.Handle <> 0) then
  begin
    FCaptured := ACapture;
    if ACapture then
    begin
//      Windows.SetCapture(Parent.Handle)
    end
    else
    begin
{      if FCaptured then
        Windows.ReleaseCapture;}
    end;
  end;
  Result := S_OK;
end;

function TsfOleControl.SetFocus(fFocus: BOOL): HResult;
begin
  Result := S_OK;
end;

{ IOleInPlaceSiteEx }

function TsfOleControl.OnInPlaceActivateEx(fNoRedraw: PBOOL;
  dwFlags: DWORD): HResult;
begin
  FOleObject.QueryInterface(IOleInPlaceObject, FOleInPlaceObject);
  FOleObject.QueryInterface(IOleInPlaceActiveObject, FOleInPlaceActiveObject);
  FOleObject.QueryInterface(IOleInPlaceObjectWindowless, FOleInPlaceObjectWindowless);
  FOleObject.QueryInterface(IViewObject, FViewObject);

  Result := S_OK;
end;

function TsfOleControl.OnInPlaceDeActivateEx(fNoRedraw: BOOL): HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.RequestUIActivate: HResult;
begin
  Result := S_OK;
end;

function TsfOleControl.GetWindow(out WindowHandle: HWnd): HResult;
begin
  Result := S_OK;
  WindowHandle := GetParentHandle;
  if WindowHandle = 0 then Result := E_FAIL;
end;

{ IServiceProvider }

function TsfOleControl.QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then
  begin
    Result := S_OK;
  end
  else
    Result := E_NOINTERFACE;
end;

{ IPErsiist }

function TsfOleControl.GetClassID(out classID: TCLSID): HResult; stdcall;
begin
end;

{ IPersistentStream }

function TsfOleControl.IsDirty: HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Load(const stm: IStream): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetSizeMax(out cbSize: Largeint): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

{ IMoniker }

function TsfOleControl.BindToObject(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
    const iidResult: TIID; out vResult): HResult; stdcall;
begin
end;

procedure ReplaceString(var S: ansistring; const OldPattern, NewPattern: ansistring);
var
  LW : integer;
  P : PAnsiChar;
  Sm : integer;
begin
  if OldPattern = NewPattern then Exit;

  LW := Length(OldPattern);
  P := StrPos(PAnsiChar(S), PAnsiChar(OldPattern));
  while P <> nil do begin
    Sm := P-PAnsiChar(S);
    S := Copy(S, 1, Sm)+NewPattern+Copy(S, Sm+LW+1, Length(S));
    P := StrPos(PAnsiChar(S)+Sm+Length(NewPattern), PAnsiChar(OldPattern));
  end;
end;

procedure ReplaceStringW(var W: widestring; const OldPattern, NewPattern: ansistring);
var
  S: ansistring;
begin
  S := W;
  ReplaceString(S, OldPattern, NewPattern);
  W := S;
end;

function FileNameWithOutExt(const S: ansistring): ansistring;
var
  I: Integer;
begin
  Result := S;
  if Pos('.', Result) > 0 then
  begin
    I := LastDelimiter('.', Result);
    Result := Copy(Result, 1, I - 1);
  end;
end;

function FileExistWin(S: ansistring): boolean;
var
  I: Integer;
begin
  S := LowerCase(S);
  ReplaceString(S, '%3f', '?');
  ReplaceString(S, '%3d', '=');
  ReplaceString(S, '%26', '&');
  ReplaceString(S, '%20', ' ');
  ReplaceString(S, '%2d', '-');
  ReplaceString(S, '%2f', '/');

  if (Pos('file://', S) = 1) then
    Delete(S, 1, 7);
  if (Pos('/', S) = 1) then
    Delete(S, 1, 1);

  for i := 1 to Length(S) do
  begin
    if S[i] = '/' then S[i] := '\';
    if S[i] = '|' then S[i] := ':';
  end;

  for i := 1 to Length(S) do
    if S[i] in ['?','&'] then
      Break;
  S := Copy(S, 1, I - 1);

  Result := FileExists(S);
end;

function GetFileName(S: ansistring): ansistring;
var
  I: Integer;
begin
  S := LowerCase(S);
  ReplaceString(S, '%3f', '?');
  ReplaceString(S, '%3d', '=');
  ReplaceString(S, '%26', '&');
  ReplaceString(S, '%20', ' ');
  ReplaceString(S, '%2d', '-');
  ReplaceString(S, '%2f', '/');

  for i := 1 to Length(S) do
    if S[i] in ['?','&'] then
      Break;
  S := Copy(S, 1, I - 1);

  I := LastDelimiter('/:|\', S);
  Result := Copy(S, I + 1, MaxInt);
end;

function CorrectFileName(S: ansistring): ansistring;
var
  i: integer;
begin
  for i := 1 to Length(S) do
  begin
    if S[i] = '\' then S[i] := '/';
    if S[i] = ':' then S[i] := '|';
  end;
  Result := S;
end;

function TsfOleControl.BindToStorage(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
  const iid: TIID; out vObj): HResult; stdcall;
var
  BindCallbackGet: IUnknown;
  BindCallback: urlmon.IBindStatusCallback;
  BindCallback2: IBindStatusCallback;
  StmInterface: TStreamAdapter;
  Stream: TStream;
  Stm: TStgMedium;
  S: ansistring;
  FileName: array [0..1000] of ansichar;
  Res: HResult;
begin
  if Assigned(bc) then
  begin
    bc.GetObjectParam('_BSCB_Holder_', BindCallbackGet);
    if Assigned(BindCallbackGet) then
    begin
      BindCallbackGet.QueryInterface(IBindStatusCallback, BindCallback);
      BindCallbackGet.QueryInterface(IBindStatusCallback, BindCallback2);
      if Assigned(BindCallback) then
      begin
        S := Furl;
        if Pos('<res>', S) = 1 then
        begin
          Delete(Furl, 1, 5);
          Stream := TResourceStream.Create(HInstance, PAnsiChar(FileNameWithOutExt(Furl)), RT_RCDATA);
          StmInterface := TStreamAdapter.Create(Stream, soReference);
          FillChar(Stm, SizeOf(Stm), 0);
          Stm.tymed := TYMED_ISTREAM;
          Stm.stm := Pointer(IStream(StmInterface));

          Furl := '';
          Result := BindCallback2.OnStartBinding(0, nil);
          Result := BindCallback2.OnProgress(100, 100, BINDSTATUS_ENDDOWNLOADDATA, '');
          Result := BindCallback2.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION, Stream.Size, nil, Stm);
          Result := BindCallback2.OnStopBinding(S_OK, '');
          Result := S_OK;
          Stream.Free;
        end
        else
        if Pos('<list>', S) = 1 then
        begin
          Delete(Furl, 1, 6);
          if (FFlashList <> nil) and (FFlashList.FindFlash(Furl) <> nil) then
          begin
            Stream := TMemoryStream.Create;
            with FFlashList.FindFlash(Furl) do
            begin
              Flash.Position := 0;
              Stream.CopyFrom(Flash, Flash.Size);
            end;
            Stream.Position := 0;

            StmInterface := TStreamAdapter.Create(Stream, soReference);
            FillChar(Stm, SizeOf(Stm), 0);
            Stm.tymed := TYMED_ISTREAM;
            Stm.stm := Pointer(IStream(StmInterface));

            Furl := '';
            Result := BindCallback2.OnStartBinding(0, nil);
            Result := BindCallback2.OnProgress(100, 100, BINDSTATUS_ENDDOWNLOADDATA, '');
            Result := BindCallback2.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION, Stream.Size, nil, Stm);
            Result := BindCallback2.OnStopBinding(S_OK, '');
            Result := S_OK;

            Stream.Free;
          end;
        end
        else
        if Pos('<stream>', S) = 1 then
        begin
          TStream(Pointer(StrToInt('$' + Copy(Furl, 9, 8)))).Position := 0;
          Stream := TMemoryStream.Create;
          Stream.CopyFrom(TStream(Pointer(StrToInt('$' + Copy(Furl, 9, 8)))), TStream(Pointer(StrToInt('$' + Copy(Furl, 9, 8)))).Size);
          Stream.Position := 0;
          StmInterface := TStreamAdapter.Create(Stream, soReference);
          FillChar(Stm, SizeOf(Stm), 0);
          Stm.tymed := TYMED_ISTREAM;
          Stm.stm := Pointer(IStream(StmInterface));

          Furl := '';
          Result := BindCallback2.OnStartBinding(0, nil);
          Result := BindCallback2.OnProgress(100, 100, BINDSTATUS_ENDDOWNLOADDATA, '');
          Result := BindCallback2.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION, Stream.Size, nil, Stm);
          Result := BindCallback2.OnStopBinding(S_OK, '');
          Result := S_OK;
          Stream.Free;
        end
        else
        if Pos('<astream>', S) = 1 then
        begin
          Stream := TStream(Pointer(StrToInt('$' + Copy(Furl, 10, 8))));
          Stream.Position := 0;
          StmInterface := TStreamAdapter.Create(Stream, soReference);
          FillChar(Stm, SizeOf(Stm), 0);
          Stm.tymed := TYMED_ISTREAM;
          Stm.stm := Pointer(IStream(StmInterface));
          Furl := '';
          Result := BindCallback2.OnStartBinding(0, nil);
          Result := BindCallback2.OnProgress(100, 100, BINDSTATUS_ENDDOWNLOADDATA, '');
          Result := BindCallback2.OnDataAvailable(BSCF_FIRSTDATANOTIFICATION or BSCF_LASTDATANOTIFICATION, Stream.Size, nil, Stm);
          Result := BindCallback2.OnStopBinding(S_OK, '');
          Result := S_OK;
        end
        else
        begin
          S := Furl;
          Furl := '';
          if Pos(':', S) = 0 then
          if FFlashPath = ''
          then
            S := ExtractFilePath(ParamStr(0)) + S
          else
            S := FFlashPath + S;
          FillChar(FileName, SizeOf(FileName), 0);
          Move(PAnsiChar(S)^, FileName[0], Length(S));
          Res := URLOpenPullStreamA(nil, PAnsiChar(S), 0, BindCallback);
          if Res = S_OK then
          begin
            S := FileName;
            Result := S_OK;
          end;
        end;
      end
      else
        Result := E_FAIL;
    end
    else
      Result := E_FAIL;
  end
  else
    Result := E_FAIL;
end;

function TsfOleControl.Reduce(const bc: IBindCtx; dwReduceHowFar: Longint;
  mkToLeft: PIMoniker_flash; out mkReduced: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.ComposeWith(const mkRight: IMoniker_flash; fOnlyIfNotGeneric: BOOL;
  out mkComposite: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Enum(fForward: BOOL; out enumMoniker: IEnumMoniker): HResult;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.IsEqual(const mkOtherMoniker: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Hash(out dwHash: Longint): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.IsRunning(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
  const mkNewlyRunning: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetTimeOfLastChange(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
  out filetime: TFileTime): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.Inverse(out mk: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.CommonPrefixWith(const mkOther: IMoniker_flash;
  out mkPrefix: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.RelativePathTo(const mkOther: IMoniker_flash;
  out mkRelPath: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.GetDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
  out pszDisplayName: POleStr): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.IMonikerParseDisplayName(const bc: IBindCtx; const mkToLeft: IMoniker_flash;
  pszDisplayName: POleStr; out chEaten: Longint;
  out mkOut: IMoniker_flash): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TsfOleControl.IsSystemMoniker(out dwMksys: Longint): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

{ TControl }

procedure TsfOleControl.PaintBackground;
var
  I, EdgeFlags, BorderFlags, SaveIndex: Integer;
  R: TRect;
begin
  if FGrabProcess then Exit;
  if Parent = nil then Exit;
  if Parent.Handle = 0 then Exit;
  if csLoading in ComponentState then Exit;

  if not FTransparent then
  begin
    if (Parent <> nil) and (FBackBuffer <> nil) and (FBuffer2 <> nil) and (FBuffer2.DC <> 0) then
    begin
      FBackBuffer.Clear(sfColor(ColorToRGB(Color)));
    end;
  end
  else
  begin
    FPaintBackground := true;
    try
      if (Parent <> nil) and (FBackBuffer <> nil) and (FBuffer2 <> nil) and (FBuffer2.DC <> 0) then
      begin
        BorderFlags := 0;
        EdgeFlags := 0;
        R := Rect(0, 0, Width, Height);
        if GetWindowLong(Parent.Handle, GWL_EXSTYLE) and WS_EX_CLIENTEDGE <> 0 then
        begin
          EdgeFlags := EDGE_SUNKEN;
          BorderFlags := BF_RECT or BF_ADJUST
        end else
        if GetWindowLong(Parent.Handle, GWL_STYLE) and WS_BORDER <> 0 then
        begin
          EdgeFlags := BDR_OUTER;
          BorderFlags := BF_RECT or BF_ADJUST or BF_MONO;
        end;
        if BorderFlags <> 0 then
        begin
          SetRect(R, 0, 0, Width, Height);
          Windows.DrawEdge(FBackBuffer.DC, R, EdgeFlags, BorderFlags);
        end;

        Parent.PaintTo(FBackBuffer.DC, -Left - R.Left, -Top - R.Top);
      end;
    finally
      FPaintBackground := false;
    end;
  end;
end;

procedure TsfOleControl.Loaded;
begin
  inherited;
  FInLoading := True;
end;

procedure TsfOleControl.Paint;
const
  DVASPECT_OPAQUE         = 16;
  DVASPECT_TRANSPARENT    = 32;
var
  R: TRect;
  x, y: integer;
  A, S, T: byte;
  Color, BlackColor: PsfColor;
begin

  if FPaintBackground then Exit;
  if Parent = nil then Exit;
  if Parent.Handle = 0 then Exit;

  if FInLoading
  then
    begin
      FInLoading := False;
      PaintBackground;
    end;

  if Assigned(FOnPaint) then
  begin
    FOnPaint(Self);
  end;

  if (Width > 0) and (Height > 0) then
  begin
    if FViewObject <> nil then
    begin
      R := ClientRect;
      if not FGrabProcess then
      begin
        { default paint }
        FBuffer2.AlphaBlend := false;
        FBuffer2.Transparent := false;
        { draw }
        if FPaintRect <> nil then
        begin
          R := FPaintRect^;
          R.Left := 0;
          R.Top := 0;
          { 1 - copy from back image to Buffer }
          FBackBuffer.Draw(FBuffer, 0, 0, FPaintRect^);
          { 2 - paint flash to buffer }
          MoveWindowOrg(FBuffer.DC, -FPaintRect^.Left, -FPaintRect^.Top);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBuffer.DC, @R, nil, nil, 0);
          MoveWindowOrg(FBuffer.DC, FPaintRect^.Left, FPaintRect^.Top);
          { 3 - Copy from Buffer to Buffer2 }
          FBuffer.Draw(FBuffer2, FPaintRect^.Left, FPaintRect^.Top,
            Rect(0, 0, FPaintRect^.Right - FPaintRect^.Left, FPaintRect^.Bottom - FPaintRect^.Top));
        end
        else
        begin
          FBackBuffer.Draw(FBuffer2, 0, 0);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBuffer2.DC, nil, nil, nil, 0);
        end;
        { Draw buffer }
        FBuffer2.Draw(Canvas, 0, 0);
      end
      else
      begin
        { only grabbing - for layer }
        { default paint }
        FBuffer2.AlphaBlend := false;
        FBuffer2.Transparent := false;
        { draw }
        if (FPaintRect <> nil) and (FPaintRect.Right <= FBuffer.Width) and (FPaintRect.Bottom <= FBuffer.Height) then
        begin
          R := FPaintRect^;
          R.Left := 0;
          R.Top := 0;
          FBuffer.AlphaBlend := false;
          FBuffer.Transparent := false;
          { white image - on BackBuffer }
          { 1 - copy from back image to Buffer }
          FBuffer.FillRect(Rect(0, 0, FPaintRect^.Right - FPaintRect^.Left, FPaintRect^.Bottom - FPaintRect^.Top) , $FF000000);
          { 2 - paint flash to buffer }
          MoveWindowOrg(FBuffer.DC, -FPaintRect^.Left, -FPaintRect^.Top);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBuffer.DC, @R, nil, nil, 0);
          MoveWindowOrg(FBuffer.DC, FPaintRect^.Left, FPaintRect^.Top);
          { 3 - Copy from Buffer to Buffer2 }
          FBuffer.Draw(FBackBuffer, FPaintRect^.Left, FPaintRect^.Top,
            Rect(0, 0, FPaintRect^.Right - FPaintRect^.Left, FPaintRect^.Bottom - FPaintRect^.Top));
          { black image - on Buffer2 }
          FBuffer.FillRect(Rect(0, 0, FPaintRect^.Right - FPaintRect^.Left, FPaintRect^.Bottom - FPaintRect^.Top), $FFFFFFFF);
          { 2 - paint flash to buffer }
          MoveWindowOrg(FBuffer.DC, -FPaintRect^.Left, -FPaintRect^.Top);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBuffer.DC, @R, nil, nil, 0);
          MoveWindowOrg(FBuffer.DC, FPaintRect^.Left, FPaintRect^.Top);
          { 3 - Copy from Buffer to Buffer2 }
          FBuffer.Draw(FBuffer2, FPaintRect^.Left, FPaintRect^.Top,
            Rect(0, 0, FPaintRect^.Right - FPaintRect^.Left, FPaintRect^.Bottom - FPaintRect^.Top));
          { Restore alpha on Buffer2 }
          for y := FPaintRect^.Top to FPaintRect^.Bottom - 1 do
          begin
            Color := PsfColor(@FBuffer2.Bits[y * FBuffer2.Width + FPaintRect^.Left]);
            BlackColor := PsfColor(@FBackBuffer.Bits[y * FBuffer2.Width + FPaintRect^.Left]);
            for x := FPaintRect^.Left to FPaintRect^.Right - 1 do
            begin
              { Set vars }
              S := BlackColor^ and $FF;
              T := Color^ and $FF;
              { Restore alpha }
              A := ($FF - (T - S));
              { Restore RGB }
              if A > 0 then
              begin
                PsfColorRec(Color).A := A;
                PsfColorRec(Color).R := MulDiv(PsfColorRec(BlackColor).R, A, $FF);
                PsfColorRec(Color).G := MulDiv(PsfColorRec(BlackColor).G, A, $FF);
                PsfColorRec(Color).B := MulDiv(PsfColorRec(BlackColor).B, A, $FF);
              end
              else
              begin
                Color^ := 0;
              end;

              Inc(Color);
              Inc(BlackColor);
            end;
          end;
        end
        else
        begin
          { white image - on BackBuffer }
          FBackBuffer.Clear($FF000000);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBackBuffer.DC, nil, nil, nil, 0);
          { black image - on Buffer2 }
          FBuffer2.Clear($FFFFFFFF);
          FViewObject.Draw(DVASPECT_TRANSPARENT, -1, nil, nil, 0, FBuffer2.DC, nil, nil, nil, 0);
          { Restore alpha on Buffer2 }
          for y := 0 to FBuffer.Height - 1 do
          begin
            Color := PsfColor(@FBuffer2.Bits[y * FBuffer2.Width]);
            BlackColor := PsfColor(@FBackBuffer.Bits[y * FBuffer2.Width]);
            for x := 0 to FBuffer.Width - 1 do
            begin
              { Set vars }
              S := BlackColor^ and $FF;
              T := Color^ and $FF;
              { Restore alpha }
              A := ($FF - (T - S));
              { Restore RGB }
              if A > 0 then
              begin
                PsfColorRec(Color).A := A;
                PsfColorRec(Color).R := MulDiv(PsfColorRec(BlackColor).R, A, $FF);
                PsfColorRec(Color).G := MulDiv(PsfColorRec(BlackColor).G, A, $FF);
                PsfColorRec(Color).B := MulDiv(PsfColorRec(BlackColor).B, A, $FF);
              end
              else
              begin
                Color^ := 0;
              end;
              Inc(Color);
              Inc(BlackColor);
            end;
          end;
        end;
      end;
      {$IFDEF FlashTrial}
      Canvas.Font.Name := 'Tahoma';
      Canvas.Font.Size := 8;
      Canvas.Font.Color := clRed;
      Canvas.Brush.Style := bsClear;
      Canvas.TextOut(0, 0, 'Demo Version');
      {$ENDIF}
    end;

    if csDesigning in ComponentState then
      with inherited Canvas do
      begin
        Pen.Style := psDot;
        Brush.Style := bsClear;
        Rectangle(0, 0, Width, Height);
      end;
  end;
  FPaintRect := nil;
end;

function TsfOleControl.GetParentHandle: HWnd;
begin
  Result := 0;
end;

procedure TsfOleControl.GrabFrame(ACanvas: TCanvas);
begin
  if FBuffer2 <> nil then
  begin
    FBuffer2.Draw(ACanvas, 0, 0);
  end;
end;

function TsfOleControl.GrabCurrentFrame2: TsfBitmap;
begin
  Result := FBuffer2;
end;

function TsfOleControl.GrabCurrentFrameToJPG: TJpegImage;
var
  Bmp: TBitmap;
  JI: TJpegImage;
begin
  Bmp := GrabCurrentFrame;
  JI := TJpegImage.Create;
  JI.PixelFormat := jf24Bit;
  JI.Assign(Bmp);
  Result := JI;
  Bmp.Free;
end;

function TsfOleControl.GrabCurrentFrame: TBitmap;
var
  R: TRect;
  x, y: integer;
  A, S, T: byte;
  Color, BlackColor: PsfColorRec;
  Bmp: TBitmap;
begin
  if (FBuffer.Width > 0) and (FBuffer.Height > 0) and (FViewObject <> nil) then
  begin
    Bmp := TBitmap.Create;
    Bmp.Width := FBuffer.Width;
    Bmp.Height := FBuffer.Height;
    Bmp.PixelFormat := pf32bit;
    Bmp.HandleType := bmDIB;

    R := ClientRect;
    { Black }
    FBuffer.AlphaBlend := false;
    FBuffer.Transparent := false;
    FBuffer.FillRect(Rect(0, 0, FBuffer.Width, FBuffer.Height), 0);
    FViewObject.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, FBuffer.DC,
      @R, nil, nil, 0);
    { White }
    Bmp.Canvas.Brush.Color := $FFFFFFFF;
    Bmp.Canvas.FillRect(R);
    FViewObject.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, Bmp.Canvas.Handle,
      @R, nil, nil, 0);
    { Restore alpha }
    for y := 0 to FBuffer.Height - 1 do
    begin
      Color := PsfColorRec(Bmp.Scanline[y]);
      for x := 0 to FBuffer.Width - 1 do
      begin
        BlackColor := PsfColorRec(@FBuffer.Bits[x + y * FBuffer2.Width]);
        { Set vars }
        S := BlackColor.R;
        T := Color.R;
        { Restore alpha }
        A := ($FF - (T - S));
        Color.A :=  A;
        { Restore RGB }
        if A > 0 then
        begin
          Color.R := Trunc((BlackColor.R / A) * $FF);
          Color.G := Trunc((BlackColor.G / A) * $FF);
          Color.B := Trunc((BlackColor.B / A) * $FF);
        end;
        Inc(Color);
      end;
    end;

    { copy }
    for y := 0 to FBuffer.Height - 1 do
      Move(FBuffer.Bits[y * FBuffer.Width], Bmp.Scanline[y]^, FBuffer.Width * 4);

    Result := Bmp;
  end
  else
    Result := nil;
end;

function TsfOleControl.ParseDisplayName(const bc: IBindCtx;
  pszDisplayName: POleStr; out chEaten: Integer;
  out mkOut: IMoniker_Flash): HResult;
begin
  Result := E_NOTIMPL;
end;

procedure TsfOleControl.SetTransparent(const Value: boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    PaintBackground;
    Paint;
  end;
end;

procedure TsfOleControl.SetDisableFlashPopup(const Value: boolean);
begin
  FDisableFlashPopup := Value;
end;

{ TsfFlashStream ===============================================================}

constructor TsfFlashStream.Create(Collection: TCollection);
begin
  inherited;
  FFlash := TMemoryStream.Create;
  FFlashStore := '(empty)';
end;

destructor TsfFlashStream.Destroy;
begin
  FFlash.Free;
  inherited;
end;

procedure TsfFlashStream.Assign(Source: TPersistent);
begin
  if Source is TsfFlashStream then
  begin
    inherited ;
  end
  else
    inherited;
end;

procedure TsfFlashStream.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('FlashStream', ReadData, WriteData, true);
end;

procedure TsfFlashStream.ReadData(Stream: TStream);
var
  IsStore: byte;
  Size: cardinal;
begin
  Stream.Read(IsStore, SizeOf(IsStore));
  if IsStore = 2 then
  begin
    FFlashStore := ReadString(Stream);
    Stream.Read(Size, SizeOf(FFlash.Size));
    FFlash.SetSize(Size);
    Stream.Read(FFlash.Memory^ , FFlash.Size);
  end;
  if IsStore = 3 then
  begin
    FFlashStore := ReadString(Stream);
    Stream.Read(Size, SizeOf(Size)); // always 4 byte
    FFlash.SetSize(Size);
    Stream.Read(FFlash.Memory^ , FFlash.Size);
  end;
end;

procedure TsfFlashStream.WriteData(Stream: TStream);
var
  IsStore: byte;
  Size: cardinal;
begin
  if (FFlash.Size > 0) then
    IsStore := 3
  else
    IsStore := 0;

  { Store flags }
  Stream.Write(IsStore, SizeOf(IsStore));

  { Store Flash in DFM }
  if IsStore = 3 then
  begin
    Size := FFlash.Size;
    WriteString(Stream, FFlashStore); 
    Stream.Write(Size, SizeOf(Size));  // always 4 byte
    Stream.Write(FFlash.Memory^ , FFlash.Size);
  end;
end;

function TsfFlashStream.GetDisplayName: string;
begin
  Result := FFlashStore;
end;

function TsfFlashStream.GetFlashStore: string;
begin
  if FFlash.Size = 0 then
    Result := '(empty)'
  else
    Result := FFlashStore;
end;

procedure TsfFlashStream.SetFlashStore(const Value: string);
begin
end;

{ TsfFlashCollection ============================================================}

constructor TsfFlashCollection.Create(AOwner: TsfFlashList);
begin
  inherited Create(TsfFlashStream);
  FFlashList := AOwner;
end;

destructor TsfFlashCollection.Destroy;
begin
  inherited Destroy;
end;

function TsfFlashCollection.Add: TsfFlashStream;
begin
  Result := TsfFlashStream(inherited Add);
end;

function TsfFlashCollection.GetOwner: TPersistent;
begin
  Result := FFlashList;
end;

procedure TsfFlashCollection.SetItem(Index: Integer; Value: TsfFlashStream);
begin
  inherited SetItem(Index, Value);
end;

function TsfFlashCollection.GetItem(Index: Integer): TsfFlashStream;
begin
  Result := TsfFlashStream(inherited GetItem(Index));
end;

{ TsfFlashList }

constructor TsfFlashList.Create(AOwner: TComponent);
begin
  inherited;
  FFlashs := TsfFlashCollection.Create(Self);
end;

destructor TsfFlashList.Destroy;
begin
  FFlashs.Free;
  inherited;
end;

procedure TsfFlashList.Loaded;
begin
  inherited;
end;

function TsfFlashList.FindFlash(const AName: string): TsfFlashStream;
var
  i: integer;
begin
  for i := 0 to FFlashs.Count - 1 do
    if CompareText(FFlashs[i].FlashStore, AName) = 0 then
    begin
      Result := FFlashs[i];
      Exit;
    end;
  Result := nil;
end;

{ TsfCommandHandler }

function RandomName: string;
const
  StrTable: string = 'abcdefghijklm0123456789nopqrstuvwxyz';
  NameLenght = 10;
var
  I, X, Y: integer;
begin
  SetLength(Result, NameLenght);
  Y := Length(StrTable);
  for I := 1 to NameLenght do
  begin
    X := Random(Y) + 1;
    Result[I] := StrTable[X];
  end;
  Result := 'sf20_' + Result;
end;

const

  WM_COMMANDEVENT = WM_USER + 1220;
 
type

  TsfCommandHandler = class
  private
    FHandle: Cardinal;
    procedure WMCommandEvent(var Msg: TMessage); message WM_COMMANDEVENT;
    procedure WndProc(var Msg: TMessage);
  public
    constructor CreateHandler;
    destructor Destroy; override;
  end;

var
  CommandHandler: TsfCommandHandler;

{ TsfCommandHandler }

constructor TsfCommandHandler.CreateHandler;
begin
  inherited Create;
  FHandle := AllocatehWnd(WndProc);
end;

destructor TsfCommandHandler.Destroy;
begin
  DeallocatehWnd(FHandle);
  inherited;
end;

procedure TsfCommandHandler.WndProc(var Msg: TMessage);
begin
  if Msg.Msg = WM_COMMANDEVENT then
    WMCommandEvent(Msg)
  else
    with Msg do
      Result := DefWindowProc(FHandle, Msg, wParam, lParam);
end;

procedure TsfCommandHandler.WMCommandEvent(var Msg: TMessage);
begin
  if Msg.wParam = 0 then Exit;
  if Pointer(Msg.wParam) = nil then Exit;
  if not (TObject(Msg.wParam) is TsfFlashPlayer) then Exit;
  if TObject(Msg.wParam) is TsfFlashPlayer
  then
  with TsfFlashPlayer(Msg.wParam) do
  begin
    if Assigned(OnHandleFSCommand) then
      OnHandleFSCommand(TsfFlashPlayer(Msg.wParam), FFScommand, FFSargs);
    FFScommand := '';
    FFSargs := '';
  end;
end;



{ TsfFlashPlayer ==============================================================}

constructor TsfFlashPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFlv := False;
  FVolume := 100;
  FVolumeControl := False;
  FFLVPlaybackSkin := flvclearskin;
  FFlashIndex := -1;
  WMode := 'Transparent';
  OnFSCommand := DoFSCommand;
  CreateWnd;
end;

destructor TsfFlashPlayer.Destroy;
begin
  inherited;
end;

procedure TsfFlashPlayer.SetReturnValue(const returnValue: WideString);
begin
  if (not FFlashNotExists) and (HiWord(DefaultInterface.FlashVersion) >= 8) then
    DefaultInterface.SetReturnValue(returnValue);
end;

procedure TsfFlashPlayer.SetFlvPlaybackSkin;
begin
  if FFLVPlaybackSkin <> Value
  then
    begin
      FFLVPlaybackSkin := Value;
      case FFLVPlaybackSkin of
        flvclearskin: SetVariable('flv.skin', 'clearoverall.swf');
        flvsteelskin: SetVariable('flv.skin', 'steel.swf');
        flvmojaveskin: SetVariable('flv.skin', 'mojave.swf');
        flvnoneskin: SetVariable('flv.skin', '');
      end;
    end;   
end;

{ IBindHost }

function TsfFlashPlayer.CreateMoniker(pszName: POLEStr; BC: IBindCtx; out mk: IMoniker_flash; dwReserved: DWORD): HResult; stdcall;
var
  i: integer;
  S: ansistring;
  szName: ansistring;
begin
  mk := Self;
  Result := S_OK;

  szName := pszName;
  if Pos('./', szName) = 1 then
    Delete(szName, 1, 2);

  if szName = 'file://' then
  begin
    Exit;
  end;

  if (Pos('.swf', szName) = 0) and (Pos('.flv', szName) = 0) and (Pos('.xml', szName) = 0) and (Pos('.jpg', szName) = 0) and
     (Pos('.png', szName) = 0) and (Pos('.mp3', szName) = 0) and (Pos('.ogg', szName) = 0) and (Pos('.txt', szName) = 0) and
     (Pos('.adf', szName) = 0) and  (Pos('.ADF', szName) = 0) and (Pos('youtube.com', szName) = 0)
  then
  begin
    mk := nil;
    Result := E_NOTIMPL;
    Exit;
  end
  else
  if szName = '' then
  begin
    mk := nil;
    Result := E_NOTIMPL;
  end
  else
  if (FFlashList <> nil) and (FFlashList.FindFlash(GetFileName(szName)) <> nil) then
  begin
    // Try to load from list
    Furl := '<list>' + GetFileName(szName);
  end
  else
  if FindResourceA(HInstance, PAnsiChar(FileNameWithOutExt(szName)), PAnsiChar(10)) <> 0 then
  begin
    // try to load from Resource
    Furl := '<res>' + szName;
  end
  else
  if (Pos('http://zzz/', szName) = 1) and (FileExistWin(ExtractFilePath(ParamStr(0)) + Copy(szName, 12, MaxInt))) then
  begin
    // try to find in app dir
    Furl := ExtractFilePath(ParamStr(0)) + Copy(szName, 12, MaxInt);
  end
  else
  if FileExistWin(ExtractFilePath(ParamStr(0)) + szName) then
  begin
    // try to find in app dir
    Furl := ExtractFilePath(ParamStr(0)) + szName;
  end
  else
  if (Pos('http://zzz/', szName) = 1) then
  begin
    S := szName;
    Delete(S, 1, 11);
    if Pos('./', S) = 1 then
      Delete(S, 1, 2);
    if (Length(S) > 2) and (S[2] = ':') and not FileExistWin(S) then
    begin
    end
    else
      Furl := S;
  end
  else
  if (Pos('file://', szName) = 1) and not FileExistWin(szName) then
  begin
  end
  else
  begin
    Furl := szName;
  end;

  for i := 1 to Length(Furl) do
    if Furl[i] = '\' then
       Furl[i] := '/';
end;

function TsfFlashPlayer.MonikerBindToStorage(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
  const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
begin
  Result := S_OK;
end;

function TsfFlashPlayer.MonikerBindToObject(Mk: IMoniker_flash; BC: IBindCtx; BSC: IBindStatusCallback;
  const iid: TGUID; out pvObj: Pointer): HResult; stdcall;
begin
  Result := S_OK;
end;

procedure TsfFlashPlayer.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFlashList)
  then  FFlashList := nil;
end;



procedure TsfFlashPlayer.DisableFlashSounds;
begin
  if FVolumeControl
  then
    begin
      if Value
      then
        SoundSetVolume(0)
      else
        SoundSetVolume(FVolume);
    end;
end;

procedure TsfFlashPlayer.SoundSetVolume(Value: Integer);
var
  ResStrm: TStream;
  S: TMemoryStream;
begin
  if FFlv
  then
    SetVariable('flv.volume', IntToStr(FVolume))
  else
    begin
      ResStrm := TResourceStream.Create(HInstance, 'SETVOLUME', RT_RCDATA);
      S := TMemoryStream.Create;
      S.CopyFrom(ResStrm, ResStrm.Size);
      PByteArray(S.Memory)[$63] := Value;
      S.Position := 0;
      LoadMovieFromStream(1, S);
      S.Free;
      ResStrm.Free;
   end;   
end;

procedure TsfFlashPlayer.SetVolume(Value: Integer);
begin
  if (Value >= 0) and (Value <= 100) and (Value <> FVolume)
  then
    begin
      FVolume := Value;
      SoundSetVolume(FVolume);
    end;
end;


procedure TsfFlashPlayer.SetVolumeControl(Value: Boolean);
begin
  FVolumeControl := Value;
end;

function TsfFlashPlayer.IsFlashAviable: Boolean;
begin
  Result := not FFlashNotExists;
end;

procedure TsfFlashPlayer.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $FFFFFD9F, $000007A6, $00000096, $000000C5);
  CControlData: TControlData2 = (
    ClassID: '{D27CDB6E-AE6D-11CF-96B8-444553540000}';
    EventIID: '{D27CDB6D-AE6D-11CF-96B8-444553540000}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnReadyStateChange) - Cardinal(Self);
end;


function TsfFlashPlayer.GrabToBmp: TBitmap;
var
  Bmp: TBitMap;
begin
  Bmp := TBitMap.Create;
  Bmp.Assign(GrabcurrentFrame);
  Result := Bmp;
end;


function TsfFlashPlayer.GrabToBmpAlpha: TsfBitmap;
var
  Bmp, Bmp2: TsfBitMap;
begin
  Bmp := TsfBitMap.Create;
  GrabProcess := True;
  Paint;
  Bmp2 := GrabCurrentFrame2;
  Bmp.Assign(Bmp2);
  Bmp.AlphaBlend := True;
  GrabProcess := False;
  SetBounds(Left, Top, Width, Height);
  Paint;
  Result := Bmp;
end;


{$IFDEF FLASHTOPNG}
function TsfFlashPlayer.GrabToPng: TsfPngImage;
var
  B: TsfBitMap;
  P: TsfPngImage;
  X, Y: Integer;
  {$IFNDEF VER200}
  Line: sf_PngImage.PByteArray;
  {$ELSE}
  Line: PByteArray;
  {$ENDIF}
begin
  B := GrabToBmpAlpha;
  P := TsfPngImage.CreateBlank(COLOR_RGB, 16, B.Width, B.Height);
  P.CreateAlpha;
  for Y := 0 to P.Height - 1 do
   begin
     Line := P.AlphaScanline[Y];
     for X := 0 to P.Width - 1 do
     begin
       P.Pixels[X, Y] := sfColorToColor(B.Pixels[X, Y]);
       Line^[X] := (B.Pixels[X, Y] and $FF000000) shr 24;
     end;
   end;
  B.Free; 
  Result := P; 
end;
{$ENDIF}


function TsfFlashPlayer.GrabToJpg: TJpegImage;
begin
  Result := GrabCurrentFrameToJPG;
end;

procedure TsfFlashPlayer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IShockwaveFlash;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TsfFlashPlayer.GetControlInterface: IShockwaveFlash;
begin
  CreateControl;
  Result := FIntf;
end;

function TsfFlashPlayer.Get_InlineData: IUnknown;
begin
  Result := DefaultInterface.InlineData;
end;

procedure TsfFlashPlayer.Set_InlineData(const ppIUnknown: IUnknown);
begin
  if not FFlashNotExists  then DefaultInterface.Set_InlineData(ppIUnknown);
end;

procedure TsfFlashPlayer.SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer);
begin
  if not FFlashNotExists  then DefaultInterface.SetZoomRect(left, top, right, bottom);
end;

procedure TsfFlashPlayer.Zoom(factor: SYSINT);
begin
  if not FFlashNotExists  then DefaultInterface.Zoom(factor);
end;

procedure TsfFlashPlayer.Pan(x: Integer; y: Integer; mode: SYSINT);
begin
  if not FFlashNotExists  then DefaultInterface.Pan(x, y, mode);
end;

procedure TsfFlashPlayer.Play;
begin
  if not FFlashNotExists then
  begin
    DefaultInterface.Play;
    if FFlv then
      CallFunction('<invoke name="playflv" returntype="xml"></invoke>');
  end;
end;

procedure TsfFlashPlayer.Stop;
begin
  if not FFlashNotExists  then
  begin
    DefaultInterface.Stop;
    if FFlv then
      CallFunction('<invoke name="stopflv" returntype="xml"></invoke>');
  end;
end;

procedure TsfFlashPlayer.Back;
begin
  if not FFlashNotExists  then DefaultInterface.Back;
end;

procedure TsfFlashPlayer.Forward;
begin
  if not FFlashNotExists  then DefaultInterface.Forward;
end;

procedure TsfFlashPlayer.Rewind;
begin
  if not FFlashNotExists  then DefaultInterface.Rewind;
end;

procedure TsfFlashPlayer.StopPlay;
begin
  if not FFlashNotExists  then DefaultInterface.StopPlay;
end;

procedure TsfFlashPlayer.GotoFrame(FrameNum: Integer);
begin
  if not FFlashNotExists  then DefaultInterface.GotoFrame(FrameNum);
end;

function TsfFlashPlayer.CurrentFrame: Integer;
begin
  Result := DefaultInterface.CurrentFrame;
end;

function TsfFlashPlayer.IsPlaying: WordBool;
begin
  Result := DefaultInterface.IsPlaying;
end;

function TsfFlashPlayer.PercentLoaded: Integer;
begin
  Result := DefaultInterface.PercentLoaded;
end;

function TsfFlashPlayer.FrameLoaded(FrameNum: Integer): WordBool;
begin
  Result := DefaultInterface.FrameLoaded(FrameNum);
end;

function TsfFlashPlayer.FlashVersion: Integer;
begin
  Result := DefaultInterface.FlashVersion;
end;

procedure TsfFlashPlayer.DoFSCommand(ASender: TObject; const command, args: WideString);
begin
  FFScommand := command;
  FFSargs := args;
  PostMessage(CommandHandler.FHandle, WM_COMMANDEVENT, Cardinal(Self), 0);
end;

function TsfFlashPlayer.GetMovie: WideString;
begin
  Result := FMovie;
end;

procedure TsfFlashPlayer.SetMovie(const Value: WideString);
begin
  if FMovie <> Value then
  begin
    FFlashIndex := -1;
    FMovie := Value;
    if not (csLoading in ComponentState) then
      LoadMovie(0, FMovie);
  end;
end;

function  TsfFlashPlayer.CallFunction(const request: WideString): WideString;
begin
  if IsFlashAviable and (HiWord(DefaultInterface.FlashVersion) >= 8) then
    Result := DefaultInterface.CallFunction(request)
  else
    Result := '';
end;

procedure TsfFlashPlayer.LoadMovie(layer: SYSINT; const url: WideString);
var
  S: TStream;
  playFileName: widestring;
  i, fver: integer;
  S1: String;
begin
  if FFlashNotExists then Exit;
  fver := HiWord(DefaultInterface.FlashVersion);
  FFlashPath := ExtractFilePath(url);
  if (Pos(wideString('.flv'), url) > 0) then
  begin
    playFileName := url;
    for i := 1 to Length(playFileName) do
      if playFileName[i] = '\' then
          playFileName[i] := '/';
    { load }
    DefaultInterface.LoadMovie(layer, 'flvplayback.swf');
    if (Pos(wideString(':/'), playFileName) <> 0) and (fver < 10)
    then
      SetVariable('flv.contentPath', playFileName)
    else
      SetVariable('flv.contentPath', 'http://zzz/' + playFileName);
    case FFLVPlaybackSkin of
      flvclearskin: SetVariable('flv.skin', 'clearoverall.swf');
      flvsteelskin: SetVariable('flv.skin', 'steel.swf');
      flvmojaveskin: SetVariable('flv.skin', 'mojave.swf');
      flvnoneskin: SetVariable('flv.skin', '');
    end;
    SetVariable('flv.volume', IntToStr(FVolume));
    FMovie := playFileName;
    FFlv := true;
  end
  else
  begin
    if (Pos(wideString(':/'), url) <> 0)  and (fver < 10)
    then
      DefaultInterface.LoadMovie(layer, url)
    else
      DefaultInterface.LoadMovie(layer, 'http://zzz/' + url);
    FMovie := url;
    FFlv := false;
  end;
  SetBounds(Left, Top, Width, Height);
end;

procedure TsfFlashPlayer.LoadMovieFromStream(layer: SYSINT; const Stream: TStream);
var
  S: TStream;
  Sign: array [1..3] of byte;
begin
  if FFlashNotExists then Exit;

  Stream.Position := 0;
  Stream.Read(Sign, 3);
  Stream.Position := 0;
  if (Sign[1] = ord('F')) and (Sign[2] = ord('L')) and (Sign[3] = ord('V')) then
  begin
    { flv stream loading not supported }
    { load }
    DefaultInterface.LoadMovie(layer, 'flvplayback.swf');
    SetVariable('flv.contentPath', 'http://zzz/<stream>' + IntToHex(Integer(Stream), 8) + '.flv');
    case FFLVPlaybackSkin of
      flvclearskin: SetVariable('flv.skin', 'clearoverall.swf');
      flvsteelskin: SetVariable('flv.skin', 'steel.swf');
      flvmojaveskin: SetVariable('flv.skin', 'mojave.swf');
      flvnoneskin: SetVariable('flv.skin', '');
    end;
    SetVariable('flv.volume', IntToStr(FVolume));
    FMovie := '';
    FFlv := true;
  end
  else
  begin
    try
      DefaultInterface.LoadMovie(layer, 'http://zzz/<stream>' + IntToHex(Integer(Stream), 8) + '.swf');
      FMovie := '';
      FFlv := false;
    finally
    end;
  end;
end;

procedure TsfFlashPlayer.LoadMovieFromStreamAsync(layer: SYSINT; const Stream: TStream);
var
  S: TStream;
  Sign: array [1..3] of byte;
begin
  if FFlashNotExists then Exit;

  Stream.Position := 0;
  Stream.Read(Sign, 3);
  Stream.Position := 0;
  if (Sign[1] = ord('F')) and (Sign[2] = ord('L')) and (Sign[3] = ord('V')) then
  begin
    { flv stream loading not supported }
    { load }
    DefaultInterface.LoadMovie(layer, 'flvplayback.swf');
    SetVariable('flv.contentPath', 'http://zzz/<astream>' + IntToHex(Integer(Stream), 8) + '.flv');
    case FFLVPlaybackSkin of
      flvclearskin: SetVariable('flv.skin', 'clearoverall.swf');
      flvsteelskin: SetVariable('flv.skin', 'steel.swf');
      flvmojaveskin: SetVariable('flv.skin', 'mojave.swf');
      flvnoneskin: SetVariable('flv.skin', '');
    end;
    SetVariable('flv.volume', IntToStr(FVolume));
    FMovie := '';
    FFlv := true;
  end
  else
  begin
    try
      DefaultInterface.LoadMovie(layer, 'http://zzz/<astream>' + IntToHex(Integer(Stream), 8) + '.swf');
      FMovie := '';
      FFlv := false;
    finally
    end;
  end;
end;

procedure TsfFlashPlayer.LoadMovieFromResource(layer: SYSINT; const ResName: WideString);
var
  R: TResourceStream;
begin
  R := TResourceStream.Create(0, ResName, RT_RCDATA);
  if R <> nil then
    LoadMovieFromStream(layer, R);
  R.Free;
end;

procedure TsfFlashPlayer.SetFlashList(const Value: TsfFlashList);
begin
  FFlashList := Value;
  if FFlashList = nil then FFlashIndex := -1;
end;

procedure TsfFlashPlayer.SetFlashIndex(const Value: integer);
var
  Flash: TMemoryStream;
begin
  FFlashIndex := Value;
  if (FFlashList <> nil) and (FFlashList.Flashs.Count > 0) and (FFlashIndex >= 0)
  then
    begin
     if FFlashIndex < 0 then FFlashIndex := 0;
     if FFlashIndex >= FFlashList.Flashs.Count - 1 then
       FFlashIndex := FFlashList.Flashs.Count - 1;

     if FFlashList.Flashs.Items[FFlashIndex].Flash <> nil
     then
       begin
         Flash := FFlashList.Flashs.Items[FFlashIndex].Flash;
         if Flash <> nil then
         begin
           LoadMovieFromStream(0, Flash);
        end;
     end;
  end
end;

procedure TsfFlashPlayer.TGotoFrame(const target: WideString; FrameNum: Integer);
begin
  if not FFlashNotExists  then DefaultInterface.TGotoFrame(target, FrameNum);
end;

procedure TsfFlashPlayer.TGotoLabel(const target: WideString; const label_: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.TGotoLabel(target, label_);
end;

function TsfFlashPlayer.TCurrentFrame(const target: WideString): Integer;
begin
  Result := DefaultInterface.TCurrentFrame(target);
end;

function TsfFlashPlayer.TCurrentLabel(const target: WideString): WideString;
begin
  Result := DefaultInterface.TCurrentLabel(target);
end;

procedure TsfFlashPlayer.TPlay(const target: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.TPlay(target);
end;

procedure TsfFlashPlayer.TStopPlay(const target: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.TStopPlay(target);
end;

procedure TsfFlashPlayer.SetVariable(const name: WideString; const value: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.SetVariable(name, value);
end;

function TsfFlashPlayer.GetVariable(const name: WideString): WideString;
begin
  Result := DefaultInterface.GetVariable(name);
end;

procedure TsfFlashPlayer.TSetProperty(const target: WideString; property_: SYSINT;
                                       const value: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.TSetProperty(target, property_, value);
end;

function TsfFlashPlayer.TGetProperty(const target: WideString; property_: SYSINT): WideString;
begin
  Result := DefaultInterface.TGetProperty(target, property_);
end;

procedure TsfFlashPlayer.TCallFrame(const target: WideString; FrameNum: SYSINT);
begin
  if not FFlashNotExists  then DefaultInterface.TCallFrame(target, FrameNum);
end;

procedure TsfFlashPlayer.TCallLabel(const target: WideString; const label_: WideString);
begin
  if not FFlashNotExists  then DefaultInterface.TCallLabel(target, label_);
end;

procedure TsfFlashPlayer.TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
begin
  if not FFlashNotExists  then DefaultInterface.TSetPropertyNum(target, property_, value);
end;

function TsfFlashPlayer.TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
begin
  Result := DefaultInterface.TGetPropertyNum(target, property_);
end;

function TsfFlashPlayer.TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
begin
  Result := DefaultInterface.TGetPropertyAsNumber(target, property_);
end;

{ }

class function CoFlashProp.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_FlashProp) as IUnknown;
end;

class function CoFlashProp.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FlashProp) as IUnknown;
end;

class function CoFlashObjectInterface.Create: IFlashObjectInterface;
begin
  Result := CreateComObject(CLASS_FlashObjectInterface) as IFlashObjectInterface;
end;

class function CoFlashObjectInterface.CreateRemote(const MachineName: string): IFlashObjectInterface;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FlashObjectInterface) as IFlashObjectInterface;
end;

type
  TParentForm = class(TForm);

constructor TsfLayeredFlashForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRegionsAlphaBlend := False;
  FApplyRegions := False;
  FMouseDown := False;
  FIsDragging := False;
  FDragable := True;
  FFirstShow := True;
  FAlphaBlendValue := 200;
  FFlashPlayer := nil;
  FForm := nil;
  try
   FForm := (Owner as TForm);
  except
   if Owner is TCustomForm then FForm := TForm(Owner) else raise;
  end;
  if FForm <> nil
  then
    with FForm do
    begin
      AutoSize := False;
      AutoScroll := False;
      BorderStyle := bsNone;
      if not (csDesigning in ComponentState)
      then
        begin
          OldWindowProc := WindowProc;
          WindowProc := NewWndProc;
        end;
    end;
end;

destructor TsfLayeredFlashForm.Destroy;
begin
  inherited;
  if not (csDesigning in ComponentState) and (FForm <> nil)
  then
    FForm.WindowProc := OldWindowProc;
end;

procedure TsfLayeredFlashForm.Loaded;
begin
  inherited;
end;

procedure TsfLayeredFlashForm.SetAlphaBlendValue(Value: Integer);
begin
  FAlphaBlendValue := Value;
  if FApplyRegions and FRegionsAlphaBlend and
     (@SetLayeredWindowAttributes <> nil) and
     not (csDesigning in ComponentState)
  then
    begin
      SetLayeredWindowAttributes(FForm.Handle, 0, FAlphaBlendValue, LWA_ALPHA);
    end;  
end;

procedure TsfLayeredFlashForm.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFlashPlayer)
  then  FFlashPlayer := nil;
end;

procedure TsfLayeredFlashForm.NewWndProc(var Message: TMessage);
var
  FCallOldWndProc: Boolean;
  P, CPos: TPoint;
  DC: Cardinal;
  Bmp: TsfBitmap;
  I, J: Integer;
begin
  FCallOldWndProc := True;
  with Message do
  begin
    case Msg of

      WM_SIZE:
        begin
          OldWindowProc(Message);
          FCallOldWndProc := False;
          if FFlashPlayer <> nil
          then
            FFlashPlayer.SetBounds(0, 0, FForm.Width, FForm.Height);
        end;

      WM_RBUTTONUP:
        begin
          P.X := Short(LoWord(lParam));
          P.Y := HiWord(lParam);
          if (FFlashPlayer <> nil) and not FFlashPlayer.DisableFlashPopup
          then
            FFlashPlayer.Perform(WM_RBUTTONUP, 0, lParam);
        end;
      WM_RBUTTONDOWN:
        begin
          P.X := Short(LoWord(lParam));
          P.Y := HiWord(lParam);
          if (FFlashPlayer <> nil) and not FFlashPlayer.DisableFlashPopup
          then
            FFlashPlayer.Perform(WM_RBUTTONDOWN, 0, lParam);
        end;
      WM_LBUTTONUP:
        begin
          FMouseDown := False;
          P.X := Short(LoWord(lParam));
          P.Y := HiWord(lParam);
          if FFlashPlayer <> nil
          then
            FFlashPlayer.Perform(WM_LBUTTONUP, 0, lParam);
          if FDragable
          then
            begin
              FIsDragging := False;
              FDragX := 0;
              FDragY := 0;
            end;
        end;
      WM_LBUTTONDOWN:
        begin
          FMouseDown := True;
          P.X := Short(LoWord(lParam));
          P.Y := HiWord(lParam);
          if FFlashPlayer <> nil
          then
            FFlashPlayer.Perform(WM_LBUTTONDOWN, 0, lParam);
          //
          if FDragable
          then
            begin
              GetCursorPos(CPos);
              FDragX := CPos.X;
              FDragY := CPos.Y;
              FIsDragging := True;
            end;
          //
        end;
      WM_MOUSEMOVE:
        begin
          P.X := Short(LoWord(lParam));
          P.Y := HiWord(lParam);
          if not FMouseDown and (FFlashPlayer <> nil)
          then
            FFlashPlayer.Perform(WM_MOUSEMOVE, 0, Cardinal(SmallPoint(P.X, P.Y)));

          if FIsDragging
          then
            begin
              GetCursorPos(CPos);
              FForm.SetBounds(FForm.Left + CPos.X - FDragX, FForm.Top + CPos.Y - FDragY,
                FForm.Width, FForm.Height);
              FDragX := CPos.X;
              FDragY := CPos.Y;
            end;
        end;
      WM_SHOWWINDOW:
       begin
          if FFirstShow and FApplyRegions and FRegionsAlphaBlend and
            (@SetLayeredWindowAttributes <> nil)
         then
           begin
             SetWindowLong(FForm.Handle,
               GWL_EXSTYLE,
               GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
             SetLayeredWindowAttributes(FForm.Handle, 0, FAlphaBlendValue, LWA_ALPHA);
           end
         else
         if FFirstShow and not FApplyRegions
         then
           begin
             SetWindowLong(FForm.Handle,
               GWL_EXSTYLE,
               GetWindowLong(FForm.Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
           end;
         if (FFlashPlayer <> nil) and FFirstShow
         then
           begin
             FFlashPlayer.SetBounds(0, 0, FForm.Width, FForm.Height);
             FFlashPlayer.Paint;
             FFlashPlayer.Paint;
           end;
         FFirstShow := False;
       end;
      WM_ERASEBKGND:
        begin
          if FApplyRegions and (FFlashPlayer <> nil)
          then
            begin
              Bmp := FFlashPlayer.GrabCurrentFrame2;
              if Bmp <> nil
              then
                begin
                  DC := GetDC(FForm.Handle);
                  Bmp.Draw(DC, 0, 0);
                  ReleaseDC(FForm.Handle, DC);
                  Message.Result := 1;
               end;
            end;
          FCallOldWndProc := False;
        end;
     end;
   end;
  if FCallOldWndProc then OldWindowProc(Message);
end;

type
  TsfParentPlayer = class(TsfFlashPlayer);

procedure TsfLayeredFlashForm.SetFlashPlayer(Value: TsfFlashPlayer);
begin
  FFlashPlayer := Value;
  if FFlashPlayer <> nil
  then
    begin
      FFlashPlayer.OnPaint := DoPaint;
      FFlashPlayer.Visible := False;
      FFlashPlayer.GrabProcess := True;
      FFlashPlayer.SetBounds(FFlashPlayer.Left, FFlashPlayer.Top,
        FFlashPlayer.Width, FFlashPlayer.Height);
      TsfParentPlayer(FFlashPlayer).Paint;
    end;
end;

procedure TsfLayeredFlashForm.DoPaint(Sender: TObject);
var
  Blend: TBLENDFUNCTION;
  Origin, Size, BitmapOrigin: Windows.TPoint;
  Bmp: TsfBitmap;
  OldRgn, Rgn: Cardinal;
begin
  if (csDesigning in ComponentState) then Exit;
  if (FFlashPlayer = nil) then Exit;
  if FForm = nil then Exit;

  Bmp := nil;

  if FFlashPlayer <> nil
  then
    Bmp := FFlashPlayer.GrabCurrentFrame2;

  if Bmp = nil then exit;

  if not FApplyRegions
  then
    begin
      Origin := Point(TWinControl(Owner).Left, TWinControl(Owner).Top);
      Size := Point(Bmp.Width, Bmp.Height);
      with Blend do
      begin
        BlendOp := AC_SRC_OVER;
        AlphaFormat := $01;
        BlendFlags := 0;
        SourceConstantAlpha := FAlphaBlendValue;
      end;
      BitmapOrigin := Point(0, 0);
       UpdateLayeredWindow(FForm.Handle, 0, @Origin, @Size, Bmp.DC,
         @BitmapOrigin, $00000000, @Blend, ULW_ALPHA);
    end
  else
    begin
      Rgn := CreateRegionFromBitmap_Flash(Bmp, 0, 0);
      OldRgn := SetWindowRgn(FForm.Handle, Rgn, true);
      DeleteObject(Rgn);
      if OldRgn <> 0
      then
        begin
          InvalidateRect(FForm.Handle, nil, true);
          DeleteObject(OldRgn);
        end;
    end;   
end;


procedure TsfFlashImageItem.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
  if (Dest is TsfFlashImageItem)
  then
    TsfFlashImageItem(Dest).FlashImage := FlashImage;
end;

constructor TsfFlashImageItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFlashImage := TsfBitMap.Create;
  FName := Format('FlashImage%d', [Index]);
  TsfFlashImageItems(Self.Collection).FFlashImageList.InsertBitmap(Index);
end;

destructor TsfFlashImageItem.Destroy;
begin
  FFlashImage.Free;
  if TsfFlashImageItems(Self.Collection).FFlashImageList.Count > Index
  then
    TsfFlashImageItems(Self.Collection).FFlashImageList.DeleteBitmap(Index);
  inherited Destroy;
end;

procedure TsfFlashImageItem.Assign(Source: TPersistent);
begin
  if Source is TsfFlashImageItem
  then
    begin
      FlashImage.Assign(TsfFlashImageItem(Source).FlashImage);
      Name := TsfFlashImageItem(Source).Name;
   end
  else
    inherited Assign(Source);
end;

function TsfFlashImageItem.GetDisplayName: string;
begin
  if Length(FName) = 0
  then Result := inherited GetDisplayName
  else Result := FName;
end;                  

procedure TsfFlashImageItem.SetFlashImage(const Value: TsfBitmap);
begin
  FFlashImage.Assign(Value);
  Changed(False);
end;

procedure TsfFlashImageItem.SetFlashImageFile(Value: String);
begin;
  if (csDesigning in TsfFlashImageItems(Collection).FFlashImageList.ComponentState) and not
     (csLoading in TsfFlashImageItems(Collection).FFlashImageList.ComponentState)
  then
    begin
      FFlashImage.LoadFromFile(Value);
      FFlashImage.AlphaBlend := True;
      FFlashImageFile := ExtractFileName(Value);
      Changed(False);
    end
  else
    FFlashImageFile := Value;
end;


procedure TsfFlashImageItem.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('FlashImage', ReadData, WriteData, true);
end;

procedure TsfFlashImageItem.ReadData(Stream: TStream);
begin
  FFlashImage.LoadFromStream(Stream);
  FFlashImage.AlphaBlend := True;
end;

procedure TsfFlashImageItem.WriteData(Stream: TStream);
begin
  FFlashImage.SaveToStream(Stream);
end;

constructor TsfFlashImageItems.Create;
begin
  inherited Create(TsfFlashImageItem);
  FFlashImageList := AFlashImageList;
end;


function TsfFlashImageItems.GetOwner: TPersistent;
begin
  Result := FFlashImageList;
end;

function TsfFlashImageItems.GetItem(Index: Integer): TsfFlashImageItem;
begin
  Result := TsfFlashImageItem(inherited GetItem(Index));
end;

procedure TsfFlashImageItems.SetItem;
begin
  inherited SetItem(Index, Value);
end;

var
  GlobParentControl: TWinControl;

constructor TsfFlashImageList.Create(AOwner: TComponent);
begin
  inherited;
  FFlashImages := TsfFlashImageItems.Create(Self);
  FFlashList := nil;
  if GlobParentControl = nil then
  begin
    GlobParentControl := TWinControl.CreateParented(Application.Handle);
  end;
end;

destructor TsfFlashImageList.Destroy;
begin
  FFlashImages.Free;
  FFlashImages := nil;
  inherited;
end;

procedure TsfFlashImageList.Notification(AComponent: TComponent;
            Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFlashList)
  then  FFlashList := nil;
end;

procedure TsfFlashImageList.LoadFromFlashList;
var
  I: Integer;
  FI: TsfFlashImageItem;
begin
  if FFlashList = nil then Exit;
  if FFlashList.Flashs.Count = 0 then Exit;
  FFlashImages.Clear;
  SF := TsfFlashPlayer.Create(Self);
  SF.Width := Self.FlashWidth;
  SF.Height := Self.FlashHeight;
  SF.FlashList := FFlashList;
  SF.Visible := False;
  SF.Parent := GlobParentControl;
  for I := 0 to FFlashList.Flashs.Count - 1 do
  begin
    SF.FlashIndex := I;
    SF.GotoFrame(0);
    SF.GrabProcess := True;
    SF.Paint;
    FTempBmp := SF.GrabCurrentFrame2;
    FI := TsfFlashImageItem(FFlashImages.Add);
    if FTempBmp <> nil then
    begin
      FI.FFlashImage.Assign(FTempBmp);
      FI.FFlashImage.AlphaBlend := true;
    end;
  end;
  SF.Free;
end;

procedure TsfFlashImageList.SetFlashList(Value: TsfFlashList);
begin
  FFlashList := Value;
  if not (csDesigning in ComponentState)
  then
    LoadFromFlashList;
end;

function TsfFlashImageList.GetFlashWidth: Integer;
begin
  Result := Width;
end;

function TsfFlashImageList.GetFlashHeight: Integer;
begin
  Result := Height;
end;

procedure TsfFlashImageList.SetFlashWidth(Value: Integer);
begin
  if Width <> Value
  then
    begin
      Width := Value;
      if not (csLoading in ComponentState)
      then
        FFlashImages.Clear;
    end;
end;

procedure TsfFlashImageList.SetFlashHeight(Value: Integer);
begin
  if Height <> Value
  then
    begin
      Height := Value;
      if not (csLoading in ComponentState)
      then
        FFlashImages.Clear;
    end;
end;


procedure TsfFlashImageList.SetFlashImages(Value: TsfFlashImageItems);
begin
  FFlashImages.Assign(Value);
end;

procedure TsfFlashImageList.DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean);
begin
  if (Index >= 0) and (Index < FlashImages.Count)
     and not FlashImages[Index].FFlashImage.Empty
  then
    FlashImages[Index].FFlashImage.Draw(Canvas.Handle, X, Y);
end;

procedure TsfFlashImageList.InsertBitMap(Index: Integer);
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Monochrome := True;
  B.Width := Width;
  B.height := Height;
  Insert(Index, B, nil);
  B.Free;
end;

procedure TsfFlashImageList.DeleteBitMap(Index: Integer);
begin
  Delete(Index);
end;

constructor TsfFlashImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque] + [csReplicatable];
  Width := 50;
  Height := 50;
  FFlashImageList := nil;
  FAutoSize := True;
  FImageIndex := -1;
end;

procedure TsfFlashImage.Paint;
begin
  if (FFlashImageList <> nil) and
     (FFlashImageList.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FFlashImageList.Count)
  then
    FFlashImageList.Draw(Canvas, 0, 0, FImageIndex, Enabled);

  if csDesigning in ComponentState
  then
    with Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TsfFlashImage.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TsfFlashImage.AdjustBounds;
begin
  if FAutoSize and (FFlashImageList <> nil)
  then
    begin
      Width := FFlashImageList.FlashWidth;
      Height := FFlashImageList.FlashHeight;
    end;
end;

procedure TsfFlashImage.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TsfFlashImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFlashImageList) then
    FFlashImageList := nil;
end;

procedure TsfFlashImage.SetImageIndex(Value: Integer);
begin
  if Value >= -1
  then
    FImageIndex := Value;
  RePaint;
end;

var
  L: cardinal;
  
initialization
  L := LoadLibrary('urlmon.dll');
  if L <> 0 then @URLOpenPullStreamA := GetProcAddress(L, 'URLOpenPullStreamA');
  CommandHandler := TsfCommandHandler.CreateHandler;
finalization
  if L <> 0 then FreeLibrary(L);
  CommandHandler.Free;
  
end.
