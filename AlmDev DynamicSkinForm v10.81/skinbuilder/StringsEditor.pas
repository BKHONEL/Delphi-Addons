unit StringsEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TStrsForm = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FStrs: TStrings;
  public
    { Public declarations }
    procedure Execute(Strs: TStrings);
  end;

var
  StrsForm: TStrsForm;

implementation

{$R *.DFM}

procedure TStrsForm.Execute(Strs: TStrings);
var
  i: Integer;
begin
  Memo1.Clear;
  for i := 0 to Strs.Count - 1 do
  Memo1.Lines.Add(Strs[i]);
  FStrs := Strs;
  ShowModal;
end;

procedure TStrsForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TStrsForm.BitBtn1Click(Sender: TObject);
var
  i: Integer;
begin
  FStrs.Clear;
  for i := 0 to Memo1.Lines.Count - 1 do
  FStrs.Add(Memo1.Lines[i]);
  Close;
end;

end.
