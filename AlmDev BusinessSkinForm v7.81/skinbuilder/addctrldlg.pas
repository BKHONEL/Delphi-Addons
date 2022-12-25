unit addctrldlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TAddCtrlFrm = class(TForm)
    Label1: TLabel;
    ObjType: TComboBox;
    ObjNameEdit: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure ObjTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddCtrlFrm: TAddCtrlFrm;

implementation

uses skinbuild;

{$R *.DFM}

procedure TAddCtrlFrm.BitBtn1Click(Sender: TObject);
begin
  SBForm.AddControl(ObjType.ItemIndex, ObjNameEdit.Text);
  Close;
end;

procedure TAddCtrlFrm.ObjTypeChange(Sender: TObject);
begin
  ObjNameEdit.Text :=  ObjType.Text;
end;

end.
