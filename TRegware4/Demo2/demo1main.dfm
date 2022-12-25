object Form1: TForm1
  Left = 192
  Top = 123
  Width = 473
  Height = 345
  Caption = 'Regware 4.00 Demo #2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 120
    Width = 136
    Height = 22
    Caption = 'Program Status:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 150
    Width = 164
    Height = 22
    Caption = 'TimeLimit (in days):'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object StatusLabel: TLabel
    Left = 248
    Top = 120
    Width = 100
    Height = 22
    Caption = 'StatusLabel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 40
    Top = 180
    Width = 86
    Height = 22
    Caption = 'Days Left:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object DaysLeftLabel: TLabel
    Left = 248
    Top = 180
    Width = 123
    Height = 22
    Caption = 'DaysLeftLabel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 16
    Width = 68
    Height = 13
    Caption = 'LicenseName:'
  end
  object Label5: TLabel
    Left = 16
    Top = 90
    Width = 87
    Height = 13
    Caption = 'Registration Code:'
  end
  object Label9: TLabel
    Left = 16
    Top = 216
    Width = 114
    Height = 13
    Caption = 'Regware 4.00 Demo #2'
  end
  object Label10: TLabel
    Left = 16
    Top = 232
    Width = 289
    Height = 13
    Caption = 'An example of how to implement TRegware into your program'
  end
  object Label11: TLabel
    Left = 16
    Top = 264
    Width = 80
    Height = 13
    Caption = 'Copyright ©2003'
  end
  object Label12: TLabel
    Left = 16
    Top = 64
    Width = 28
    Height = 13
    Caption = 'Email:'
  end
  object Label13: TLabel
    Left = 16
    Top = 40
    Width = 62
    Height = 13
    Caption = 'Organization:'
  end
  object TimeLimitLabel: TLabel
    Left = 248
    Top = 150
    Width = 130
    Height = 22
    Caption = 'TimeLimitLabel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 248
    Width = 225
    Height = 13
    Caption = 'Use Demo #1 to generate the registration code!'
  end
  object ExitBtn: TButton
    Left = 8
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = ExitBtnClick
  end
  object SetUnregisteredBtn: TButton
    Left = 360
    Top = 40
    Width = 97
    Height = 25
    Caption = 'SetUnregistered()'
    TabOrder = 5
    OnClick = SetUnregisteredBtnClick
  end
  object LicenseIDBox: TEdit
    Left = 120
    Top = 8
    Width = 225
    Height = 21
    TabOrder = 0
  end
  object DoRegistrationBtn: TButton
    Left = 360
    Top = 8
    Width = 97
    Height = 25
    Caption = 'DoRegistration()'
    Default = True
    TabOrder = 4
    OnClick = DoRegistrationBtnClick
  end
  object RegCodeBox: TEdit
    Left = 120
    Top = 80
    Width = 225
    Height = 21
    TabOrder = 3
  end
  object EmailBox: TEdit
    Left = 120
    Top = 56
    Width = 225
    Height = 21
    TabOrder = 2
  end
  object OrganizationBox: TEdit
    Left = 120
    Top = 32
    Width = 225
    Height = 21
    TabOrder = 1
  end
  object Reg: TRegware4
    BanList.Strings = (
      'BB1C84BB793B5EEBDC7B')
    ProgGUID = '{002E86C0-412A-11D7-9A28-0040D005E5DC}'
    Seed1 = 82229366
    Seed2 = 148131088
    Seed3 = 141461335
    RegCodeSize = 20
    LicenseOptions.LicenseSource = lsUserDefined
    LicenseOptions.LicenseType = ltSingleUserLicense
    Left = 416
    Top = 280
  end
end
