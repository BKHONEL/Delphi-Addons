unit IndexEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, spPropertyEditor, SkinBoxCtrls,
  SkinCtrls, DynamicSkinForm;

type
  TPIndexForm = class(TForm)
    NoneCheck: TspSkinCheckRadioBox;
    BList: TspSkinListBox;
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    procedure FormShow(Sender: TObject);
    procedure spSkinButton2Click(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
    procedure BListListBoxClick(Sender: TObject);
  private
    { Private declarations }
    FProperty: TspProperty;
  public
    { Public declarations }
    procedure Execute(P: TspProperty);
  end;

var
  PIndexForm: TPIndexForm;

implementation
   Uses SkinBuild;
{$R *.DFM}

procedure TPIndexForm.Execute;
begin
  FProperty := P;
  ShowModal;
end;

procedure TPIndexForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  BList.Clear;
  for i := 0 to SBForm.SkinData.FActivePicturesNames.Count - 1 do
    BList.Items.Add(SBForm.SkinData.FActivePicturesNames[i]);
  NoneCheck.Checked := FProperty.Value = '-1';
  BList.ItemIndex := GetInteger(FProperty.Value);
  BList.SetFocus;
end;

procedure TPIndexForm.spSkinButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TPIndexForm.spSkinButton1Click(Sender: TObject);
begin
  if NoneCheck.Checked
  then FProperty.Value := '-1'
  else FProperty.Value := SetInteger(BList.ItemIndex);
  Close;
end;

procedure TPIndexForm.BListListBoxClick(Sender: TObject);
begin
  if BList.ItemIndex <> -1
  then
    NoneCheck.Checked := False;
end;

end.
