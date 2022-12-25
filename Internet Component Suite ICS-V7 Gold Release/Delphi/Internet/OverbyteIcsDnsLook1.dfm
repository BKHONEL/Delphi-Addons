object DnsLookupForm: TDnsLookupForm
  Left = 135
  Top = 152
  BorderStyle = bsSingle
  Caption = 'DnsLookup - http://www.overbyte.be'
  ClientHeight = 169
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 50
    Height = 13
    Caption = 'HostName'
  end
  object IPLabel: TLabel
    Left = 8
    Top = 56
    Width = 36
    Height = 13
    Caption = 'IPLabel'
  end
  object HostEdit: TEdit
    Left = 72
    Top = 16
    Width = 161
    Height = 21
    TabOrder = 0
    Text = 'HostEdit'
  end
  object LookupButton: TButton
    Left = 240
    Top = 16
    Width = 89
    Height = 25
    Caption = '&Lookup'
    Default = True
    TabOrder = 1
    OnClick = LookupButtonClick
  end
  object CancelButton: TButton
    Left = 336
    Top = 16
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = CancelButtonClick
  end
  object IPListMemo: TMemo
    Left = 8
    Top = 80
    Width = 401
    Height = 81
    Lines.Strings = (
      'IPListMemo')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ReverseLookupButton: TButton
    Left = 240
    Top = 48
    Width = 89
    Height = 25
    Caption = '&Reverse Lookup'
    TabOrder = 4
    OnClick = ReverseLookupButtonClick
  end
  object LocalIPButton: TButton
    Left = 336
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Local&IP'
    TabOrder = 5
    OnClick = LocalIPButtonClick
  end
  object WSocket1: TWSocket
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    KeepAliveOnOff = wsKeepAliveOff
    KeepAliveTime = 0
    KeepAliveInterval = 0
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    LastError = 0
    ReuseAddr = False
    ComponentOptions = []
    ListenBacklog = 5
    ReqVerLow = 1
    ReqVerHigh = 1
    OnDnsLookupDone = WSocket1DnsLookupDone
    Left = 208
    Top = 104
  end
end
