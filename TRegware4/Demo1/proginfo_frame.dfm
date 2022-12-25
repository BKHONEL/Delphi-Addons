object ProgInfoFrame: TProgInfoFrame
  Left = 0
  Top = 0
  Width = 248
  Height = 280
  TabOrder = 0
  object ProgInfoGroup: TGroupBox
    Left = 8
    Top = 0
    Width = 233
    Height = 273
    Caption = 'Program Information'
    TabOrder = 0
    object Label14: TLabel
      Left = 16
      Top = 32
      Width = 42
      Height = 13
      Caption = 'Program:'
    end
    object Label15: TLabel
      Left = 8
      Top = 88
      Width = 52
      Height = 13
      Caption = 'ProgGUID:'
    end
    object Label16: TLabel
      Left = 24
      Top = 120
      Width = 34
      Height = 13
      Caption = 'Seed1:'
    end
    object Label2: TLabel
      Left = 11
      Top = 244
      Width = 89
      Height = 13
      Caption = 'TimeLimit (in days):'
    end
    object Label19: TLabel
      Left = 32
      Top = 216
      Width = 68
      Height = 13
      Caption = 'RegCodeSize:'
    end
    object Label1: TLabel
      Left = 24
      Top = 152
      Width = 34
      Height = 13
      Caption = 'Seed2:'
    end
    object Label3: TLabel
      Left = 24
      Top = 184
      Width = 34
      Height = 13
      Caption = 'Seed3:'
    end
    object ProgNameCombo: TComboBox
      Left = 64
      Top = 24
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ProgNameComboChange
      OnExit = ProgNameComboExit
      OnKeyDown = ProgNameComboKeyDown
    end
    object ProgGUIDBox: TEdit
      Left = 64
      Top = 80
      Width = 161
      Height = 21
      TabOrder = 1
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object Seed1Box: TEdit
      Left = 64
      Top = 112
      Width = 161
      Height = 21
      TabOrder = 2
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object TimeLimit: TEdit
      Left = 120
      Top = 236
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '30'
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object CodeSizeBox: TEdit
      Left = 120
      Top = 208
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '20'
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object Seed2Box: TEdit
      Left = 64
      Top = 144
      Width = 161
      Height = 21
      TabOrder = 5
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object Seed3Box: TEdit
      Left = 64
      Top = 176
      Width = 161
      Height = 21
      TabOrder = 6
      OnExit = ProgNameComboExit
      OnKeyPress = ProgGUIDBoxKeyPress
    end
    object FillProgInfoBtn: TBitBtn
      Left = 176
      Top = 216
      Width = 35
      Height = 33
      TabOrder = 7
      OnClick = FillProgInfoBtnClick
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
    object NewProgBtn: TBitBtn
      Left = 158
      Top = 50
      Width = 27
      Height = 25
      TabOrder = 8
      OnClick = NewProgBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
        0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
        33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
    object RenameBtn: TBitBtn
      Left = 192
      Top = 50
      Width = 27
      Height = 25
      TabOrder = 9
      OnClick = RenameBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF5F5557777777777505555777777777757F55555555555555
        055555555555FF5575F555555550055030555555555775F7F7F55555550FB000
        005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
        B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
        305555577F555557F7F5550E0BFBFB003055557575F55577F7F550EEE0BFB0B0
        305557FF575F5757F7F5000EEE0BFBF03055777FF575FFF7F7F50000EEE00000
        30557777FF577777F7F500000E05555BB05577777F75555777F5500000555550
        3055577777555557F7F555000555555999555577755555577755}
      NumGlyphs = 2
    end
  end
end
