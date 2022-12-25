program skinbuilder;

uses
  Forms,
  skinbuild in 'skinbuild.pas' {SBForm},
  ImageEditor in 'ImageEditor.pas' {IEFrm},
  IndexEditor in 'IndexEditor.pas' {PIndexForm},
  FSDlg in 'FSDlg.pas' {FSForm},
  AddObjDlg in 'AddObjDlg.pas' {AddObjFrm},
  addctrldlg in 'addctrldlg.pas' {AddCtrlFrm},
  AddPicDlg in 'AddPicDlg.pas' {LoadPicForm},
  testfrmEmpty in 'testfrmEmpty.pas' {TestFormEmpty},
  testfrmctrls in 'testfrmctrls.pas' {TestFormCtrls},
  selectcolor in 'selectcolor.pas' {SelectColorForm},
  selectcolorpic in 'selectcolorpic.pas' {SelColorPicForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SkinBuilder';
  Application.CreateForm(TSBForm, SBForm);
  Application.CreateForm(TIEFrm, IEFrm);
  Application.CreateForm(TPIndexForm, PIndexForm);
  Application.CreateForm(TFSForm, FSForm);
  Application.CreateForm(TAddObjFrm, AddObjFrm);
  Application.CreateForm(TAddCtrlFrm, AddCtrlFrm);
  Application.CreateForm(TLoadPicForm, LoadPicForm);
  Application.CreateForm(TSelectColorForm, SelectColorForm);
  Application.CreateForm(TSelColorPicForm, SelColorPicForm);
  Application.Run;
end.
