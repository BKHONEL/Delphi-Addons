object FormNewThirdClass: TFormNewThirdClass
  Left = 405
  Top = 430
  BorderStyle = bsDialog
  Caption = 'New third-party control'
  ClientHeight = 141
  ClientWidth = 334
  Color = clBtnFace
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sEdit1: TsEdit
    Left = 112
    Top = 24
    Width = 190
    Height = 21
    TabOrder = 0
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Class name :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object sComboBox1: TsComboBox
    Left = 112
    Top = 56
    Width = 190
    Height = 21
    Alignment = taLeftJustify
    BoundLabel.Active = True
    BoundLabel.Caption = 'Type of skin :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
    Style = csDropDownList
    ItemHeight = 15
    ItemIndex = -1
    TabOrder = 1
  end
  object sBitBtn1: TsBitBtn
    Left = 88
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
    ImageIndex = 1
    Images = sAlphaImageList1
  end
  object sBitBtn2: TsBitBtn
    Left = 168
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    SkinData.SkinSection = 'BUTTON'
    ImageIndex = 0
    Images = sAlphaImageList1
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 288
    Top = 8
  end
  object sAlphaImageList1: TsAlphaImageList
    Items = <
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000001B049444154789CCD913F485B5114C6BFF74C06F551FC5B1A88845A0C
          41E4265E4D17B1412838D8B445111DE22082D63583B3E02238DC495C3A143A04
          EED28A6241B268A62E4582B4E2607149AB627C28627C37F1389417EA7B3CC1CD
          6FBBF7DCEF77CEF92EF0A814063A04672A0C249C350368149CA9A4A64D7A9943
          8233A57637C909B1CD17DF57C913223853A5BD2DB2A663642D4E5421B6D9CC2C
          91F9B69DAE96D32438533B52763B274808CE94F5718E2E874374353F46823325
          3853E6A7052A0E06A9F83EE29A4E73426639CBCE8CC47C562E8B9AAE5E20D481
          EB2F19A0AE1E9F0BB5E5951FF9D7FBC0D67D41260467EA3C9DA493574FE9A8AF
          958E075FB83ADBD29D1705200F00D4FC0CE5EB0A2A56057A738B67C39AFF0F06
          D0B8C0D971EA5DAFAFB4F615BA61C01F08C03A38409C3FD7FD7892FAFDE768FB
          14387401AAE6A1A84F7D5B876ED423633694F36774D3136ED54B3F7FE16534A8
          FBB4061704C0BF6F2C2E4E5321DE447F07DAAA3BDB999C8E46A9106FA28B0F09
          129CA99C94913B80A4A64D0ACE9439D5EF0ACC8698E331CF3001006F8094D703
          1BE269B6B52365A7572D2765D78694FE7B010FD52D5D0AC7425E5F9824000000
          0049454E44AE426082}
      end
      item
        ImageFormat = ifPNG
        ImgData = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000019E49444154789C6360185220323994D1BA53FC5B527DA814C99A59F8
          1818B5AB597F9C7970E8BF7D8FCC1F5E2D06297405AC2A250C9F716866D5AE66
          FD71E2C9AEFF6BBF34FEBFF3FDDC7FBB1EC93F9B8EAD92608229D0CAE7FC52E4
          D3CCA552CCF00D5DB3461EFB9719996BD9AFF0AE61B8F5F32803030303C37F86
          FF1005EB76AC62D5ABE5FC79F3CD85FFD7FEECFFBFE5CA92FFAAC58CDF609A75
          6B397E1E7FB5F5FFB4F7B1FF9BDED8FFBFF3FDDC7F9B1E71B8175858F818D4FF
          31FF6163E6FEC770FBCF190676156E86AEA4D99C650C29DF38B83898A7E42E61
          3BC9329FE1C39FE70C313C93196227B9FEBDB2F0ADDCE76B0CCF181818181819
          18181878B5180C9D72F4CEF4262E603AF86716032FA30803C31371065E412E86
          4B2C6B19BEFE7BC710C7338D21A2DBF1CF95591F657E3C6178891150BC5A0C86
          DED334FFDEF97EEE7FFB5BD7FFFDEF82FFB7BE71FE5FF7DAE2FF9DEFE7FE1B37
          F1FF66E16310C41B55BC5A0C869ED354FFDEF97EEE7FDD6B0B24CD7C8435231B
          E23C59EEEF9DEFE748D78C6488BAFD04C9BF646986814DC756C9AFDBB18A3CCD
          7405008EE0B26A756A2DB40000000049454E44AE426082}
      end>
    Left = 272
    Top = 88
  end
end
