unit IndexEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, SkinBuild, spPropertyEditor;

type
  TPIndexForm = class(TForm)
    NoneCheck: TCheckBox;
    BList: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BListClick(Sender: TObject);
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

procedure TPIndexForm.BitBtn1Click(Sender: TObject);
begin
  if NoneCheck.Checked
  then FProperty.Value := '-1'
  else FProperty.Value := SetInteger(BList.ItemIndex);
  Close; 
end;

procedure TPIndexForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TPIndexForm.BListClick(Sender: TObject);
begin
  if BList.ItemIndex <> -1
  then
    NoneCheck.Checked := False;
end;

end.
