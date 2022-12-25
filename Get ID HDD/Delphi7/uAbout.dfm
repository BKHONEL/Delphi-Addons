object About: TAbout
  Left = 336
  Top = 250
  BorderStyle = bsDialog
  Caption = 'About TGetDiskSerial'
  ClientHeight = 175
  ClientWidth = 221
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 140
    Height = 23
    Caption = 'TGetDiskSerial'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 52
    Width = 40
    Height = 14
    Caption = 'Version'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 197
    Height = 14
    Caption = 'Copyright (c) 2002-2005 Devlib,Inc.'
  end
  object Bevel1: TBevel
    Left = 4
    Top = 123
    Width = 212
    Height = 10
    Shape = bsBottomLine
  end
  object Label4: TLabel
    Left = 43
    Top = 107
    Width = 126
    Height = 14
    Cursor = crHandPoint
    Caption = 'http://www.devlib.net'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
  end
  object Label5: TLabel
    Left = 8
    Top = 107
    Width = 30
    Height = 14
    Caption = 'Web:'
  end
  object Button1: TButton
    Left = 139
    Top = 143
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
end
