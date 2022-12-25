object Form2: TForm2
  Left = 310
  Top = 191
  Width = 269
  Height = 207
  Caption = 'Nag Screen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 251
    Height = 29
    Caption = 'BUY MY SOFTWARE!!!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 48
    Top = 72
    Width = 186
    Height = 29
    Cursor = crHandPoint
    Caption = 'http://wak.cjb.net/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Label2Click
  end
  object Button1: TButton
    Left = 8
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
end
