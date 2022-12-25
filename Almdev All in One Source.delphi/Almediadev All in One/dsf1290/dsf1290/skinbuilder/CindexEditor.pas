unit CindexEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, spPropertyEditor, Spin, SkinCtrls, SkinBoxCtrls,
  DynamicSkinForm;

type
  TCIndexForm = class(TForm)
    CList: TspSkinListBox;
    NoneCheck: TspSkinCheckRadioBox;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    spDynamicSkinForm1: TspDynamicSkinForm;
    procedure FormShow(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
    procedure spSkinButton2Click(Sender: TObject);
    procedure CListListBoxClick(Sender: TObject);
  private
    { Private declarations }
    FProperty: TspProperty;
  public
    { Public declarations }
    procedure Execute(P: TspProperty);
  end;

var
  CIndexForm: TCIndexForm;

implementation

uses skinbuild;

{$R *.DFM}

procedure TCIndexForm.Execute;
begin
  FProperty := P;
  ShowModal;
end;

procedure TCIndexForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  CList.Clear;
  for i := 0 to SBForm.SkinData.FCursorsNames.Count - 1 do
    CList.Items.Add(SBForm.SkinData.FCursorsNames[i]);
  CList.ItemIndex := GetInteger(FProperty.Value);
  CList.SetFocus;
end;

procedure TCIndexForm.spSkinButton1Click(Sender: TObject);
begin
  if NoneCheck.Checked
  then
    FProperty.Value := '-1'
  else
    FProperty.Value := IntToStr(CList.ItemIndex);
  Close;
end;

procedure TCIndexForm.spSkinButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TCIndexForm.CListListBoxClick(Sender: TObject);
begin
  if CList.ItemIndex <> -1
  then
    NoneCheck.Checked := False;
end;

end.
