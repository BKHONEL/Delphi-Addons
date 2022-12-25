program skinbuilder;

uses
  Forms,
  skinbuild in 'skinbuild.pas' {SBForm},
  SPImageEditor in 'SPImageEditor.pas' {IEFrm},
  IndexEditor in 'IndexEditor.pas' {PIndexForm},
  FSDlg in 'FSDlg.pas' {FSForm},
  StringsEditor in 'StringsEditor.pas' {StrsForm},
  AddObjDlg in 'AddObjDlg.pas' {AddObjFrm},
  addctrldlg in 'addctrldlg.pas' {AddCtrlFrm},
  CindexEditor in 'CindexEditor.pas' {CIndexForm},
  testfrm in 'testfrm.pas' {TestForm},
  AddPicDlg in 'AddPicDlg.pas' {LoadPicForm},
  testfrmNC in 'testfrmNC.pas' {TestFormNC},
  testfrmNCEmpty in 'testfrmNCEmpty.pas' {TestFormNCEmpty},
  selectcolorpic in 'selectcolorpic.pas' {SelColorPicForm},
  selectcolor in 'selectcolor.pas' {SelectColorForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SkinBuilder';
  Application.CreateForm(TSBForm, SBForm);
  Application.CreateForm(TIEFrm, IEFrm);
  Application.CreateForm(TPIndexForm, PIndexForm);
  Application.CreateForm(TFSForm, FSForm);
  Application.CreateForm(TStrsForm, StrsForm);
  Application.CreateForm(TAddObjFrm, AddObjFrm);
  Application.CreateForm(TAddCtrlFrm, AddCtrlFrm);
  Application.CreateForm(TCIndexForm, CIndexForm);
  Application.CreateForm(TLoadPicForm, LoadPicForm);
  Application.CreateForm(TSelColorPicForm, SelColorPicForm);
  Application.CreateForm(TSelectColorForm, SelectColorForm);
  Application.Run;
end.
