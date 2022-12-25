unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GetDiskSerial;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Button1: TButton;
    EDrive: TEdit;
    Button2: TButton;
    GetDiskSerial1: TGetDiskSerial;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EDriveKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ClearEdit;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
const
  RegCode = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX';   //Your Reg Code
begin
  ClearEdit;

  GetDiskSerial1.DriveID:= StrToInt(EDrive.Text);
  GetDiskSerial1.RegCode:= RegCode;
  Edit1.Text:= GetDiskSerial1.SerialNumber;           //Direct get SerialNumber
  Edit2.Text:= GetDiskSerial1.ModelNumber;            //Direct get ModalNumber
  Edit3.Text:= GetDiskSerial1.RevisionNo;             //Direct get RevisionNo
  Edit4.Text:= IntToStr(GetDiskSerial1.BufferSize);   //Direct get BufferSize
  Edit5.Text:= IntToStr(GetDiskSerial1.Cylinders);    //Direct get Cylinders
  Edit6.Text:= IntToStr(GetDiskSerial1.Heads);        //Direct get Heads
  Edit7.Text:= IntToStr(GetDiskSerial1.Sectors);      //Direct get Sectors
end;

procedure TForm1.ClearEdit;
//Clear edit box
begin
  Edit1.Text:= '';
  Edit2.Text:= '';
  Edit3.Text:= '';
  Edit4.Text:= '';
  Edit5.Text:= '';
  Edit6.Text:= '';
  Edit7.Text:= '';
end;

procedure TForm1.EDriveKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #8 then Exit;
  if not (Key in ['0'..'9']) then Key:= #0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;


end.
