unit StringsEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, SkinCtrls, SkinBoxCtrls, DynamicSkinForm;

type
  TStrsForm = class(TForm)
    Panel1: TspSkinPanel;
    Memo1: TspSkinMemo2;
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    procedure BitBtn2Click(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
    procedure spSkinButton2Click(Sender: TObject);
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
    Uses  SkinBuild;
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

procedure TStrsForm.spSkinButton1Click(Sender: TObject);
var
  i: Integer;
begin
  FStrs.Clear;
  for i := 0 to Memo1.Lines.Count - 1 do
  FStrs.Add(Memo1.Lines[i]);
  Close;
end;

procedure TStrsForm.spSkinButton2Click(Sender: TObject);
begin
 Close;
end;

end.
