object TestFormNCEmpty: TTestFormNCEmpty
  Left = 337
  Top = 202
  AutoScroll = False
  BorderIcons = []
  Caption = 'Test form'
  ClientHeight = 241
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object spDynamicSkinForm1: TspDynamicSkinForm
    MenuButtonVisible = True
    MenuButtonWidth = 70
    MenuButtonCaption = '&File'
    MenuButtonImageIndex = -1
    MenuButtonSpacing = 0
    MenuButtonMargin = -1
    MenuButtonPopupMenu = spSkinPopupMenu1
    WindowState = wsNormal
    ShowMDIScrollBars = True
    QuickButtons = <>
    CaptionTabs = <
      item
        Caption = 'Tab1'
        Visible = True
      end
      item
        Caption = 'Tab2'
        Visible = True
      end
      item
        Caption = 'Tab3'
        Visible = True
      end>
    CaptionTabIndex = 0
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
    UseSkinFontInCaption = True
    UseSkinSizeInMenu = True
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
    SupportNCArea = True
    AlphaBlendAnimation = False
    AlphaBlendValue = 0
    AlphaBlend = False
    MenusAlphaBlend = False
    MenusAlphaBlendAnimation = False
    MenusAlphaBlendValue = 200
    SkinData = SBForm.SkinData
    MenusSkinData = SBForm.SkinData
    MinHeight = 0
    MinWidth = 0
    MaxHeight = 0
    MaxWidth = 0
    Sizeable = True
    DraggAble = False
    NCDraggAble = True
    Magnetic = True
    MagneticSize = 10
    BorderIcons = [biSystemMenu, biMinimize, biMaximize, biRollUp, biMinimizeToTray]
    Left = 8
    Top = 8
  end
  object spSkinPopupMenu1: TspSkinPopupMenu
    SkinData = SBForm.SkinData
    Left = 48
    Top = 8
    object Item11: TMenuItem
      Caption = 'Item1'
    end
    object Item21: TMenuItem
      Caption = 'Item2'
    end
    object Item31: TMenuItem
      Caption = 'Item3'
    end
  end
end
