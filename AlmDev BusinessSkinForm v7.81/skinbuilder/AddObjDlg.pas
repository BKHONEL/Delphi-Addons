unit AddObjDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TAddObjFrm = class(TForm)
    ObjType: TComboBox;
    Label1: TLabel;
    ObjNameEdit: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ObjTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddObjFrm: TAddObjFrm;

implementation

uses skinbuild;

{$R *.DFM}

procedure TAddObjFrm.BitBtn1Click(Sender: TObject);
begin
  SBForm.AddObject(ObjType.ItemIndex, ObjNameEdit.Text);
  Close;
end;

procedure TAddObjFrm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TAddObjFrm.ObjTypeChange(Sender: TObject);
begin
  ObjNameEdit.Text :=  ObjType.Text;
end;

end.
