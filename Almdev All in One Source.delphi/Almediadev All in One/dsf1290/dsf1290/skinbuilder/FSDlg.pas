unit FSDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, spPropertyEditor, SkinCtrls, DynamicSkinForm;

type
  TFSForm = class(TForm)
    fsBoldCheck: TspSkinCheckRadioBox;
    fsUnderLineCheck: TspSkinCheckRadioBox;
    fsItalicCheck: TspSkinCheckRadioBox;
    fsStrikeOutCheck: TspSkinCheckRadioBox;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    spDynamicSkinForm1: TspDynamicSkinForm;
    procedure spSkinButton1Click(Sender: TObject);
    procedure spSkinButton2Click(Sender: TObject);
  private
    { Private declarations }
    FProperty: TspProperty;
  public
    { Public declarations }
    procedure Execute(P: TspProperty);
  end;

var
  FSForm: TFSForm;

implementation
  Uses SkinBuild;

{$R *.DFM}

procedure TFSForm.Execute(P: TspProperty);
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

procedure TFSForm.spSkinButton1Click(Sender: TObject);
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

procedure TFSForm.spSkinButton2Click(Sender: TObject);
begin
  Close;
end;

end.
