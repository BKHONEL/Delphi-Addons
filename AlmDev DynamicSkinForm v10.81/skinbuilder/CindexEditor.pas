unit CindexEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, spPropertyEditor, Spin;

type
  TCIndexForm = class(TForm)
    CList: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CIEditor: TSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure CListClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
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
  CIEditor.Value := StrToInt(FProperty.Value);
  CList.ItemIndex := GetInteger(FProperty.Value);
  CList.SetFocus;
end;

procedure TCIndexForm.CListClick(Sender: TObject);
begin
  CIEditor.Value := CList.ItemIndex;
end;

procedure TCIndexForm.BitBtn1Click(Sender: TObject);
begin
  FProperty.Value := IntToStr(CIEditor.Value);
  Close;
end;

procedure TCIndexForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
