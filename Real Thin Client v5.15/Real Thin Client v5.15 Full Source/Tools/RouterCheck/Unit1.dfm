object RtcRouterCheckForm: TRtcRouterCheckForm
  Left = 203
  Top = 126
  Width = 315
  Height = 427
  Caption = 'RTC Router "Proxy" LOG Check'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    299
    391)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 16
    Width = 20
    Height = 13
    Caption = 'from'
  end
  object Label2: TLabel
    Left = 104
    Top = 16
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object Button1: TButton
    Left = 208
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = Button1Click
  end
  object eEnd: TEdit
    Left = 124
    Top = 12
    Width = 65
    Height = 21
    TabOrder = 1
    Text = '50000'
  end
  object Memo1: TMemo
    Left = 12
    Top = 48
    Width = 276
    Height = 332
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Click "Load" to open and check a ".proxy.log" file ...')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object eStart: TEdit
    Left = 44
    Top = 12
    Width = 53
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.proxy.log'
    Filter = 'RTC "proxy" LOG|*.proxy.log'
    Left = 168
    Top = 40
  end
end
