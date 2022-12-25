unit FSDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, bsPropertyEditor;

type
  TFSForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    fsBoldCheck: TCheckBox;
    fsUnderLineCheck: TCheckBox;
    fsItalicCheck: TCheckBox;
    fsStrikeOutCheck: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    FProperty: TbsProperty;
  public
    { Public declarations }
    procedure Execute(P: TbsProperty);
  end;

var
  FSForm: TFSForm;

implementation

{$R *.DFM}

procedure TFSForm.Execute(P: TbsProperty);
var
  FS: TFontStyles;
begin
  FProperty := P;
  FS := GetFontStyle(FProperty.Value);
  fsBoldCheck.Checked := fsBold in FS;
  fsUnderLineCheck.Checked := fsUnderLine in FS;
  fsItalicCheck.Checked := fsItalic in FS;
  fsStrikeOutCheck.Checked := fsStrikeOut in FS;
  ShowModal;
end;

procedure TFSForm.BitBtn1Click(Sender: TObject);
var
  FS: TFontStyles;
begin
  FS := [];
  if fsBoldCheck.Checked then FS := FS + [fsBold];
  if fsUnderLineCheck.Checked then FS := FS + [fsUnderLine];
  if fsItalicCheck.Checked then FS := FS + [fsItalic];
  if fsStrikeOutCheck.Checked then FS := FS + [fsStrikeOut];
  FProperty.Value := SetFontStyle(FS);
  Close;
end;

procedure TFSForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
