object SelectColorForm: TSelectColorForm
  Left = 329
  Top = 313
  BorderStyle = bsDialog
  Caption = 'SelectColor'
  ClientHeight = 241
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ShowShape: TShape
    Left = 136
    Top = 8
    Width = 105
    Height = 25
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 113
    Height = 25
    Caption = 'ColorDialog'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 40
    Width = 233
    Height = 161
    Caption = 'Select from picture'
    TabOrder = 1
    object Select: TButton
      Left = 8
      Top = 128
      Width = 217
      Height = 25
      Caption = 'Select'
      TabOrder = 0
      OnClick = SelectClick
    end
    object PicList: TListBox
      Left = 8
      Top = 16
      Width = 217
      Height = 105
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 208
    Width = 105
    Height = 25
    TabOrder = 2
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 136
    Top = 208
    Width = 105
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 152
    Top = 8
  end
end
