object MainForm: TMainForm
  Left = 177
  Top = 45
  Width = 531
  Height = 459
  Caption = 'TRegware 4.00 Demo #1'
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
  object Button1: TButton
    Left = 8
    Top = 400
    Width = 89
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 521
    Height = 385
    ActivePage = CodeTestSheet
    TabOrder = 1
    OnChanging = PageControlChanging
    object CodeTestSheet: TTabSheet
      Caption = 'Test Registration Code'
      object DoRegistrationBtn: TButton
        Left = 8
        Top = 294
        Width = 113
        Height = 25
        Hint = 'Registers the program as if the user is trying to register it'
        Caption = 'DoRegistration()'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = DoRegistrationBtnClick
      end
      object Button2: TButton
        Left = 8
        Top = 324
        Width = 113
        Height = 25
        Caption = 'SetUnregistered()'
        TabOrder = 2
        OnClick = Button2Click
      end
      object UserInfoBox: TGroupBox
        Left = 256
        Top = 0
        Width = 249
        Height = 145
        Hint = 
          'The details entered by the user (Organization and Email are opti' +
          'onal)'
        Caption = 'User Information'
        TabOrder = 3
        object Label4: TLabel
          Left = 21
          Top = 28
          Width = 54
          Height = 13
          Caption = 'License ID:'
        end
        object Label5: TLabel
          Left = 21
          Top = 59
          Width = 54
          Height = 13
          Caption = 'Reg. Code:'
        end
        object Label17: TLabel
          Left = 47
          Top = 120
          Width = 28
          Height = 13
          Caption = 'Email:'
        end
        object Label18: TLabel
          Left = 13
          Top = 89
          Width = 62
          Height = 13
          Caption = 'Organization:'
        end
        object LicenseIDBox: TEdit
          Left = 80
          Top = 20
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object RegCodeBox: TEdit
          Left = 80
          Top = 51
          Width = 153
          Height = 21
          TabOrder = 1
        end
        object OrganizationBox: TEdit
          Left = 80
          Top = 81
          Width = 153
          Height = 21
          TabOrder = 2
        end
        object EmailBox: TEdit
          Left = 80
          Top = 112
          Width = 153
          Height = 21
          TabOrder = 3
        end
      end
      object RegInfo: TGroupBox
        Left = 256
        Top = 160
        Width = 249
        Height = 185
        Caption = 'Registration Information'
        TabOrder = 4
        object Label1: TLabel
          Left = 19
          Top = 20
          Width = 75
          Height = 13
          Caption = 'Program Status:'
        end
        object StatusLabel: TLabel
          Left = 112
          Top = 20
          Width = 56
          Height = 13
          Caption = 'StatusLabel'
        end
        object DaysLabel: TLabel
          Left = 112
          Top = 43
          Width = 50
          Height = 13
          Caption = 'DaysLabel'
        end
        object Label3: TLabel
          Left = 46
          Top = 43
          Width = 48
          Height = 13
          Caption = 'Days Left:'
        end
        object OrganizationLabel: TLabel
          Left = 112
          Top = 90
          Width = 85
          Height = 13
          Caption = 'OrganizationLabel'
        end
        object Label6: TLabel
          Left = 32
          Top = 90
          Width = 62
          Height = 13
          Caption = 'Organization:'
        end
        object LicenseLabel: TLabel
          Left = 112
          Top = 66
          Width = 63
          Height = 13
          Caption = 'LicenseLabel'
        end
        object Label7: TLabel
          Left = 11
          Top = 66
          Width = 83
          Height = 13
          Caption = 'License (user) ID:'
        end
        object Label8: TLabel
          Left = 66
          Top = 113
          Width = 28
          Height = 13
          Caption = 'Email:'
        end
        object EmailLabel: TLabel
          Left = 112
          Top = 113
          Width = 51
          Height = 13
          Caption = 'EmailLabel'
        end
        object RegCodeLabel: TLabel
          Left = 112
          Top = 136
          Width = 71
          Height = 13
          Caption = 'RegCodeLabel'
        end
        object Label20: TLabel
          Left = 40
          Top = 136
          Width = 54
          Height = 13
          Caption = 'Reg. Code:'
        end
      end
      inline VerifyProgInfoFrame: TProgInfoFrame
        Left = 8
        inherited ProgInfoGroup: TGroupBox
          Left = 0
          inherited ProgGUIDBox: TEdit [7]
            MaxLength = 38
          end
          inherited Seed1Box: TEdit [8]
            MaxLength = 20
          end
          inherited TimeLimit: TEdit [9]
          end
          inherited CodeSizeBox: TEdit [10]
          end
          inherited Seed2Box: TEdit [11]
            MaxLength = 20
          end
          inherited Seed3Box: TEdit [12]
            MaxLength = 20
          end
          inherited FillProgInfoBtn: TBitBtn [13]
            Hint = 'Fill program properties with random data'
            ParentShowHint = False
            ShowHint = True
            OnClick = VerifyProgInfoFrameFillProgInfoBtnClick
          end
          inherited ProgNameCombo: TComboBox [14]
            OnChange = VerifyProgInfoFrameProgNameComboChange
          end
        end
      end
    end
    object GenSheet: TTabSheet
      Caption = 'Generate Code'
      ImageIndex = 1
      object Label15: TLabel
        Left = 32
        Top = 313
        Width = 87
        Height = 13
        Caption = 'Registration Code:'
      end
      inline GenerateProgInfoFrame: TProgInfoFrame
        Top = 1
        inherited ProgInfoGroup: TGroupBox
          inherited ProgNameCombo: TComboBox
            OnChange = GenerateProgInfoFrameProgNameComboChange
          end
        end
      end
      object GenExpireInfoGroup: TGroupBox
        Left = 256
        Top = 0
        Width = 249
        Height = 193
        Caption = 'Expiration Information'
        TabOrder = 1
        object ExpireDateRadio: TRadioButton
          Left = 24
          Top = 24
          Width = 177
          Height = 17
          Caption = 'The code will expire on this date:'
          TabOrder = 0
          OnClick = ExpireDateRadioClick
        end
        object ExpireDaysRadio: TRadioButton
          Left = 24
          Top = 88
          Width = 201
          Height = 17
          Caption = 'The code will expire X days from now:'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = ExpireDaysRadioClick
        end
        object ExpireDatePicker: TDateTimePicker
          Left = 40
          Top = 48
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 37650.8253604167
          Time = 37650.8253604167
          Color = clInactiveBorder
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkDate
          ParseInput = False
          TabOrder = 2
          OnChange = LicenseIDGenBoxChange
        end
        object ExpireDaysBox: TSpinEdit
          Left = 64
          Top = 112
          Width = 121
          Height = 22
          MaxValue = 3650
          MinValue = 1
          TabOrder = 3
          Value = 15
          OnChange = LicenseIDGenBoxChange
        end
        object NoExpireRadio: TRadioButton
          Left = 24
          Top = 152
          Width = 209
          Height = 17
          Caption = 'This code does not have an expiration'
          TabOrder = 4
          OnClick = LicenseIDGenBoxChange
        end
      end
      object LicenseIDGroup: TGroupBox
        Left = 256
        Top = 200
        Width = 249
        Height = 89
        Caption = 'License ID'
        TabOrder = 2
        object Label2: TLabel
          Left = 32
          Top = 24
          Width = 120
          Height = 13
          Caption = 'License ID (aka User ID):'
        end
        object LicenseIDGenBox: TEdit
          Left = 16
          Top = 42
          Width = 185
          Height = 21
          TabOrder = 0
          OnChange = LicenseIDGenBoxChange
        end
        object GenerateLicenseIDBox: TBitBtn
          Left = 208
          Top = 40
          Width = 27
          Height = 25
          TabOrder = 1
          OnClick = GenerateLicenseIDBoxClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
            000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
            00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
            F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
            0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
            FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
            FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
            0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
            00333377737FFFFF773333303300000003333337337777777333}
          NumGlyphs = 2
        end
      end
      object RegCodeGenBox: TEdit
        Left = 128
        Top = 310
        Width = 337
        Height = 22
        Color = clInactiveBorder
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
    end
    object CodeExpireSheet: TTabSheet
      Caption = 'Check Expiration'
      ImageIndex = 3
      object Label23: TLabel
        Left = 80
        Top = 16
        Width = 307
        Height = 13
        Caption = 
          'This feature will tell you the expiration date on a registration' +
          ' code.'
      end
      object Label24: TLabel
        Left = 144
        Top = 80
        Width = 115
        Height = 13
        Caption = 'Enter Registration Code:'
      end
      object Label25: TLabel
        Left = 152
        Top = 216
        Width = 113
        Height = 13
        Caption = 'This code will expire on:'
      end
      object ExpireCodeBox: TEdit
        Left = 120
        Top = 104
        Width = 233
        Height = 21
        TabOrder = 0
      end
      object ExpireDateBox: TEdit
        Left = 120
        Top = 240
        Width = 233
        Height = 21
        Color = clInactiveBorder
        ReadOnly = True
        TabOrder = 1
      end
      object CheckExpirationBtn: TButton
        Left = 168
        Top = 128
        Width = 137
        Height = 25
        Caption = 'Calculate Expiration Date!'
        TabOrder = 2
        OnClick = CheckExpirationBtnClick
      end
    end
    object AboutSheet: TTabSheet
      Caption = 'About'
      ImageIndex = 2
      object Label9: TLabel
        Left = 88
        Top = 24
        Width = 300
        Height = 19
        Caption = 'TRegware 4.00 Demonstration Program'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 163
        Top = 67
        Width = 151
        Height = 13
        Caption = 'Programmed by Winston Kotzan'
      end
      object Label11: TLabel
        Left = 155
        Top = 211
        Width = 167
        Height = 13
        Caption = 'Copyright ©2003 WAK Productions'
      end
      object Label12: TLabel
        Left = 187
        Top = 227
        Width = 86
        Height = 13
        Caption = 'All rights reserved.'
      end
      object Label13: TLabel
        Left = 104
        Top = 110
        Width = 268
        Height = 39
        Caption = 
          'This program is meant to be used as a demonstration, as well as ' +
          'a registration code generator for use with your programs.  Have ' +
          'fun!'
        WordWrap = True
      end
      object Label14: TLabel
        Left = 208
        Top = 48
        Width = 59
        Height = 13
        Caption = 'Version 4.00'
      end
    end
  end
  object Reg: TRegware4
    ProgGUID = '{CD89B480-3169-11D7-9A27-0040D005E5DC}'
    Seed1 = 3153153
    Seed2 = 351351351
    Seed3 = 12315646
    RegCodeSize = 20
    LicenseOptions.LicenseSource = lsUserDefined
    LicenseOptions.LicenseType = ltSingleUserLicense
    Left = 416
    Top = 392
  end
  object RegGen: TRegCodeGenerator4
    MinChars = 5
    Seed1 = 9379
    Seed2 = 13635
    Seed3 = 5760
    RegCodeSize = 20
    Left = 448
    Top = 392
  end
end
