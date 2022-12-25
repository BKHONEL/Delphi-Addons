program skinbuilder;

uses
  Forms,
  skinbuild in 'skinbuild.pas' {SBForm},
  SPImageEditor in 'SPImageEditor.pas' {IEFrm},
  AddPicDlg in 'AddPicDlg.pas' {LoadPicForm},
  FSDlg in 'FSDlg.pas' {FSForm},
  StringsEditor in 'StringsEditor.pas' {StrsForm},
  CindexEditor in 'CindexEditor.pas' {CIndexForm},
  IndexEditor in 'IndexEditor.pas' {PIndexForm},
  selectcolor in 'selectcolor.pas' {SelectColorForm},
  selectcolorpic in 'selectcolorpic.pas' {SelColorPicForm},
  testfrm in 'testfrm.pas' {TestForm},
  testfrmNC in 'testfrmNC.pas' {TestFormNC},
  testfrmNCEmpty in 'testfrmNCEmpty.pas' {TestFormNCEmpty};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSBForm, SBForm);
  Application.CreateForm(TIEFrm, IEFrm);
  Application.CreateForm(TLoadPicForm, LoadPicForm);
  Application.CreateForm(TFSForm, FSForm);
  Application.CreateForm(TStrsForm, StrsForm);
  Application.CreateForm(TCIndexForm, CIndexForm);
  Application.CreateForm(TPIndexForm, PIndexForm);
  Application.CreateForm(TSelectColorForm, SelectColorForm);
  Application.CreateForm(TSelColorPicForm, SelColorPicForm);
  Application.Run;
end.
