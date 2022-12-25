{
TRegware 3.22 Demo
by WAK Productions
Programmed by Winston Kotzan

Demo for TRegware component for Delphi 5
}
unit demo1main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, regware2, regware4;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ExitBtn: TButton;
    Label2: TLabel;
    SetUnregisteredBtn: TButton;
    StatusLabel: TLabel;
    Label3: TLabel;
    DaysLeftLabel: TLabel;
    Label4: TLabel;
    LicenseIDBox: TEdit;
    DoRegistrationBtn: TButton;
    Label5: TLabel;
    RegCodeBox: TEdit;
    Reg: TRegware4;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EmailBox: TEdit;
    OrganizationBox: TEdit;
    Label13: TLabel;
    TimeLimitLabel: TLabel;
    Label6: TLabel;
    procedure ExitBtnClick(Sender: TObject);
    procedure SetUnregisteredBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoRegistrationBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    procedure ShowStatus;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ShowStatus;
begin
  TimeLimitLabel.Caption := IntToStr(Reg.Days);
  DaysLeftLabel.Caption := IntToStr(Reg.DaysLeft);
  if Reg.Registered then
  begin
    StatusLabel.Caption := 'Registered';
    LicenseIDBox.Text := Reg.LicenseID;
    OrganizationBox.Text := Reg.Organization;
    EmailBox.Text := Reg.Email;
    RegCodeBox.Text := Reg.RegCode;
  end else
  begin
    if Reg.Expired then StatusLabel.Caption := 'Expired' else
      StatusLabel.Caption := 'Unregistered';
    LicenseIDBox.Text := '';
    OrganizationBox.Text := '';
    EmailBox.Text := '';
    RegCodeBox.Text := '';
  end;
end;

procedure TForm1.ExitBtnClick(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.SetUnregisteredBtnClick(Sender: TObject);
begin
  Reg.SetUnregistered;
  ShowStatus;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if not Reg.Registered then
  begin
    if Reg.Expired then
      ShowMessage('Program has expired, you can insert to code exit the program here')
    else
      ShowMessage('Program is not registered, you may show a reminder screen to register here.');
  end;
  ShowStatus;
end;

procedure TForm1.DoRegistrationBtnClick(Sender: TObject);
begin
  if Reg.DoRegistration(LicenseIDBox.Text, OrganizationBox.Text, RegCodeBox.Text, EmailBox.Text) = false then
    ShowMessage('Unable to register program!')
  else
    ShowMessage('Successfully Registered');
  ShowStatus;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Reg.Registered then
    ShowMessage('Program is not registered, you may show a reminder screen to register here.');
end;

end.
