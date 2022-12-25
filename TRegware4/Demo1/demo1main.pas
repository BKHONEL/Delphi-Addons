{
TRegware 4.00 Demo
by WAK Productions
Programmed by Winston Kotzan

Demo for TRegware 4.00+ component for Delphi 5
}
unit demo1main;

interface
           
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, regware4, reggen4, proginfo_frame,
  Buttons, Spin, inifiles, comobj;

type
  TMainForm = class(TForm)
    Button1: TButton;
    PageControl: TPageControl;
    CodeTestSheet: TTabSheet;
    DoRegistrationBtn: TButton;
    GenSheet: TTabSheet;
    Button2: TButton;
    AboutSheet: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    UserInfoBox: TGroupBox;
    RegInfo: TGroupBox;
    LicenseIDBox: TEdit;
    Label4: TLabel;
    RegCodeBox: TEdit;
    Label5: TLabel;
    Reg: TRegware4;
    OrganizationBox: TEdit;
    EmailBox: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    StatusLabel: TLabel;
    DaysLabel: TLabel;
    Label3: TLabel;
    OrganizationLabel: TLabel;
    Label6: TLabel;
    LicenseLabel: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EmailLabel: TLabel;
    RegCodeLabel: TLabel;
    Label20: TLabel;
    CodeExpireSheet: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    ExpireCodeBox: TEdit;
    ExpireDateBox: TEdit;
    CheckExpirationBtn: TButton;
    Label25: TLabel;
    RegGen: TRegCodeGenerator4;
    VerifyProgInfoFrame: TProgInfoFrame;
    GenerateProgInfoFrame: TProgInfoFrame;
    GenExpireInfoGroup: TGroupBox;
    ExpireDateRadio: TRadioButton;
    ExpireDaysRadio: TRadioButton;
    LicenseIDGroup: TGroupBox;
    RegCodeGenBox: TEdit;
    LicenseIDGenBox: TEdit;
    GenerateLicenseIDBox: TBitBtn;
    Label2: TLabel;
    ExpireDatePicker: TDateTimePicker;
    ExpireDaysBox: TSpinEdit;
    NoExpireRadio: TRadioButton;
    Label14: TLabel;
    Label15: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoRegistrationBtnClick(Sender: TObject);
    procedure RegClockChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ExpireDateRadioClick(Sender: TObject);
    procedure ExpireDaysRadioClick(Sender: TObject);
    procedure GenerateLicenseIDBoxClick(Sender: TObject);
    procedure LicenseIDGenBoxChange(Sender: TObject);
    procedure VerifyProgInfoFrameProgNameComboChange(Sender: TObject);
    procedure VerifyProgInfoFrameFillProgInfoBtnClick(Sender: TObject);
    procedure GenerateProgInfoFrameProgNameComboChange(Sender: TObject);
    procedure CheckExpirationBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure FillVerifyInfo;
    procedure DisplayCode;
    function GenerateCode: string;
    function TestCode: boolean;
    procedure ShowRegInfo;
  end;

var
  MainForm: TMainForm;

implementation

uses demo1form2;

{$R *.DFM}

procedure TMainForm.DisplayCode;
begin
  if (Length(LicenseIDGenBox.Text) > RegGen.MinChars) and
     (Length(LicenseIDGenBox.Text) < RegGen.MaxChars) then
    RegCodeGenBox.Text := GenerateCode;
end;

function TMainForm.GenerateCode: string;
var
  ExpireDate: TDateTime;
begin
  try

  if GenerateProgInfoFrame.ProgNameCombo.Text = '' then Exit; 

  with GenerateProgInfoFrame do
  begin
    RegGen.Seed1 := StrToInt(Seed1Box.Text);
    RegGen.Seed2 := StrToInt(Seed2Box.Text);
    RegGen.Seed3 := StrToInt(Seed3Box.Text);
    RegGen.RegCodeSize := StrToInt(CodeSizeBox.Text);
  end;
  if ExpireDateRadio.Checked then
    ExpireDate :=  ExpireDatePicker.Date
  else if ExpireDaysRadio.Checked then
    ExpireDate := Date + ExpireDaysBox.Value
  else ExpireDate := 0;
  Result := RegGen.GenerateCode(LicenseIDGenBox.Text, ExpireDate);

  except
    Result := '';
  end;
end;

procedure TMainForm.FillVerifyInfo;
begin
  with VerifyProgInfoFrame do
  begin
    Reg.ProgGUID := ProgGUIDBox.Text;
    Reg.Seed1 := StrToInt(Seed1Box.Text);
    Reg.Seed2 := StrToInt(Seed2Box.Text);
    Reg.Seed3 := StrToInt(Seed3Box.Text);
    Reg.RegCodeSize := StrToInt(CodeSizeBox.Text);
  end;               
  Reg.Reload;
end;

function TMainForm.TestCode: boolean;
begin
  FillVerifyInfo;
  Result := Reg.DoRegistration(LicenseIDBox.Text, OrganizationBox.Text, RegCodeBox.Text, EmailBox.Text);
  if Result = true then
  begin
    ShowRegInfo;
  end;
end;

procedure TMainForm.ShowRegInfo;
begin
  if Reg.Registered then
  begin
    StatusLabel.Caption := 'Registered';
    LicenseIDBox.Text := Reg.LicenseID;
    RegCodeBox.Text := Reg.RegCode;
    OrganizationBox.Text := Reg.Organization;
    EmailBox.Text := Reg.Email;
  end else
  begin
    StatusLabel.Caption := 'Unregistered';
    LicenseIDBox.Text := '';
    RegCodeBox.Text := '';
    OrganizationBox.Text := '';
    EmailBox.Text := '';
  end;
  if Reg.Expired then
    StatusLabel.Caption := 'Expired';

  DaysLabel.Caption := IntToStr(Reg.DaysLeft);
  LicenseLabel.Caption := Reg.LicenseID;
  OrganizationLabel.Caption := Reg.Organization;
  EmailLabel.Caption := Reg.Email;
  RegCodeLabel.Caption := Reg.RegCode;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
MainForm.Close;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  Reg.Days := StrToInt(VerifyProgInfoFrame.TimeLimit.Text);
  Reg.RegCodeSize := StrToInt(VerifyProgInfoFrame.CodeSizeBox.Text);
  Reg.SetUnregistered;
  ShowRegInfo;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  VerifyProgInfoFrame.LoadProgData;

  // Clear the label names
  StatusLabel.Caption := '';
  DaysLabel.Caption := '';
  LicenseLabel.Caption := '';
  OrganizationLabel.Caption := '';
  EmailLabel.Caption := '';
  RegCodeLabel.Caption := '';

  // Set up the generate code page
  ExpireDatePicker.Date := Date + 15;
end;

procedure TMainForm.DoRegistrationBtnClick(Sender: TObject);
begin
  FillVerifyInfo;
  if Reg.DoRegistration(LicenseIDBox.Text, OrganizationBox.Text, RegCodeBox.Text, EmailBox.Text) = true then
  begin
    ShowMessage('Successfully Registered!');
    ShowRegInfo;
  end else
    ShowMessage('Incorrect Registration Code!');
end;

procedure TMainForm.RegClockChange(Sender: TObject);
begin
  ShowMessage('User has tampered with the system clock!');
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  VerifyProgInfoFrame.SaveProgData;
end;

procedure TMainForm.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if PageControl.ActivePageIndex = 0 then
  begin
    with VerifyProgInfoFrame do
    begin
      GenerateProgInfoFrame.ProgNameCombo.Items.Assign(ProgNameCombo.Items);
      GenerateProgInfoFrame.ProgNameCombo.ItemIndex := ProgNameCombo.ItemIndex;
      GenerateProgInfoFrame.ProgGUIDBox.Text := ProgGUIDBox.Text;
      GenerateProgInfoFrame.Seed1Box.Text := Seed1Box.Text;
      GenerateProgInfoFrame.Seed2Box.Text := Seed2Box.Text;
      GenerateProgInfoFrame.Seed3Box.Text := Seed3Box.Text;
      GenerateProgInfoFrame.CodeSizeBox.Text := CodeSizeBox.Text;
      GenerateProgInfoFrame.TimeLimit.Text := TimeLimit.Text;
    end;
  end else
  if PageControl.ActivePageIndex = 1 then
  begin
    with GenerateProgInfoFrame do
    begin
      VerifyProgInfoFrame.ProgNameCombo.Items.Assign(ProgNameCombo.Items);
      VerifyProgInfoFrame.ProgNameCombo.ItemIndex := ProgNameCombo.ItemIndex;
      VerifyProgInfoFrame.ProgGUIDBox.Text := ProgGUIDBox.Text;
      VerifyProgInfoFrame.Seed1Box.Text := Seed1Box.Text;
      VerifyProgInfoFrame.Seed2Box.Text := Seed2Box.Text;
      VerifyProgInfoFrame.Seed3Box.Text := Seed3Box.Text;
      VerifyProgInfoFrame.CodeSizeBox.Text := CodeSizeBox.Text;
      VerifyProgInfoFrame.TimeLimit.Text := TimeLimit.Text;
    end;
  {    GenerateProgInfoFrame.SaveProgData;
    VerifyProgInfoFrame.LoadProgData;
    VerifyProgInfoFrame.ProgNameCombo.ItemIndex := GenerateProgInfoFrame.ProgNameCombo.ItemIndex;
    VerifyProgInfoFrame.FillProgData(VerifyProgInfoFrame.ProgNameCombo.ItemIndex);}
  end;
end;

procedure TMainForm.ExpireDateRadioClick(Sender: TObject);
begin
  ExpireDaysBox.Enabled := false;
  ExpireDaysBox.Color := clInactiveBorder;
  ExpireDatePicker.Enabled := true;
  ExpireDatePicker.Color := clWindow;
  DisplayCode;
end;

procedure TMainForm.ExpireDaysRadioClick(Sender: TObject);
begin
  ExpireDatePicker.Enabled := false;
  ExpireDatePicker.Color := clInactiveBorder;
  ExpireDaysBox.Enabled := true;
  ExpireDaysBox.Color := clWindow;
  DisplayCode;
end;

procedure TMainForm.GenerateLicenseIDBoxClick(Sender: TObject);
var
  i: integer;
  Str: string;
begin
  if Reg.LicenseOptions.LicenseSource = lsUserDefined then
  begin
    Randomize;
    for i := 0 to 9 do
    begin
      Str := Str + IntToStr(Random(10));
    end;
    LicenseIDGenBox.Text := Str;
  end;
end;

procedure TMainForm.LicenseIDGenBoxChange(Sender: TObject);
begin
  DisplayCode;
end;

procedure TMainForm.VerifyProgInfoFrameProgNameComboChange(
  Sender: TObject);
begin
  VerifyProgInfoFrame.ProgNameComboChange(Sender);
  FillVerifyInfo;
  ShowRegInfo;
end;

procedure TMainForm.VerifyProgInfoFrameFillProgInfoBtnClick(
  Sender: TObject);
begin
  VerifyProgInfoFrame.FillProgInfoBtnClick(Sender);
  Reg.SetUnregistered;
  ShowRegInfo;
end;

procedure TMainForm.GenerateProgInfoFrameProgNameComboChange(
  Sender: TObject);
begin
  GenerateProgInfoFrame.ProgNameComboChange(Sender);
  try
    RegCodeGenBox.Text := GenerateCode;
  except

  end;
end;

procedure TMainForm.CheckExpirationBtnClick(Sender: TObject);
begin
  ExpireDateBox.Text := DateToStr(CheckCodeExpiration(ExpireCodeBox.Text));
end;

end.
