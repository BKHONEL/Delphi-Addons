object TestForm: TTestForm
  Left = 266
  Top = 152
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Custom form'
  ClientHeight = 261
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = spSkinPopupMenu1
  PixelsPerInch = 96
  TextHeight = 13
  object DsfTest: TspDynamicSkinForm
    QuickButtons = <>
    QuickButtonsShowHint = False
    ClientInActiveEffect = False
    ClientInActiveEffectType = spieSemiTransparent
    DisableSystemMenu = False
    PositionInMonitor = sppDesktopCenter
    UseFormCursorInNCArea = False
    MaxMenuItemsInWindow = 0
    ClientWidth = 0
    ClientHeight = 0
    HideCaptionButtons = False
    AlwaysShowInTray = False
    LogoBitMapTransparent = False
    AlwaysMinimizeToTray = False
    UseSkinFontInMenu = True
    ShowIcon = False
    MaximizeOnFullScreen = False
    ShowObjectHint = False
    UseDefaultObjectHint = True
    UseSkinCursors = False
    DefCaptionFont.Charset = DEFAULT_CHARSET
    DefCaptionFont.Color = clBtnText
    DefCaptionFont.Height = 14
    DefCaptionFont.Name = 'Arial'
    DefCaptionFont.Style = [fsBold]
    DefInActiveCaptionFont.Charset = DEFAULT_CHARSET
    DefInActiveCaptionFont.Color = clBtnShadow
    DefInActiveCaptionFont.Height = 14
    DefInActiveCaptionFont.Name = 'Arial'
    DefInActiveCaptionFont.Style = [fsBold]
    DefMenuItemHeight = 20
    DefMenuItemFont.Charset = DEFAULT_CHARSET
    DefMenuItemFont.Color = clWindowText
    DefMenuItemFont.Height = 14
    DefMenuItemFont.Name = 'Arial'
    DefMenuItemFont.Style = []
    UseDefaultSysMenu = True
    SupportNCArea = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 0
    AlphaBlend = False
    MenusAlphaBlend = False
    MenusAlphaBlendAnimation = False
    MenusAlphaBlendValue = 200
    MainMenu = spSkinMainMenu1
    SkinData = SBForm.SkinData
    MinHeight = 0
    MinWidth = 0
    MaxHeight = 0
    MaxWidth = 0
    Sizeable = True
    DraggAble = True
    Magnetic = True
    MagneticSize = 10
    BorderIcons = [biSystemMenu, biMinimize, biMaximize, biRollUp]
    Left = 32
    Top = 20
  end
  object spSkinPopupMenu1: TspSkinPopupMenu
    Left = 104
    Top = 20
    object item11: TMenuItem
      Caption = 'item1'
    end
    object item21: TMenuItem
      Caption = 'item2'
    end
    object item31: TMenuItem
      Caption = 'item3'
    end
  end
  object spSkinMainMenu1: TspSkinMainMenu
    Left = 140
    Top = 20
    object item12: TMenuItem
      Caption = 'item1'
      object item13: TMenuItem
        Caption = 'item1'
      end
      object item22: TMenuItem
        Caption = 'item2'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object item32: TMenuItem
        Caption = 'item3'
      end
    end
    object item23: TMenuItem
      Caption = 'item2'
      object item14: TMenuItem
        Caption = 'item1'
      end
      object item24: TMenuItem
        Caption = 'item2'
      end
      object item33: TMenuItem
        Caption = 'item3'
      end
    end
  end
end
