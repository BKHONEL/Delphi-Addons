object FSForm: TFSForm
  Left = 461
  Top = 256
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Font style'
  ClientHeight = 155
  ClientWidth = 200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object fsBoldCheck: TbsSkinCheckRadioBox
    Left = 24
    Top = 8
    Width = 120
    Height = 17
    HintImageIndex = 0
    TabOrder = 0
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'checkbox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    WordWrap = False
    AllowGrayed = False
    State = cbChecked
    ImageIndex = 0
    Flat = True
    UseSkinFontColor = True
    TabStop = True
    CanFocused = True
    Radio = False
    Checked = True
    GroupIndex = 0
    Caption = 'fsBold'
  end
  object fsUnderLineCheck: TbsSkinCheckRadioBox
    Left = 24
    Top = 32
    Width = 120
    Height = 17
    HintImageIndex = 0
    TabOrder = 1
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'checkbox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    WordWrap = False
    AllowGrayed = False
    State = cbUnchecked
    ImageIndex = 0
    Flat = True
    UseSkinFontColor = True
    TabStop = True
    CanFocused = True
    Radio = False
    Checked = False
    GroupIndex = 0
    Caption = 'fsUnderLine'
  end
  object fsItalicCheck: TbsSkinCheckRadioBox
    Left = 24
    Top = 56
    Width = 120
    Height = 17
    HintImageIndex = 0
    TabOrder = 2
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'checkbox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    WordWrap = False
    AllowGrayed = False
    State = cbUnchecked
    ImageIndex = 0
    Flat = True
    UseSkinFontColor = True
    TabStop = True
    CanFocused = True
    Radio = False
    Checked = False
    GroupIndex = 0
    Caption = 'fsItalic'
  end
  object fsStrikeOutCheck: TbsSkinCheckRadioBox
    Left = 24
    Top = 80
    Width = 120
    Height = 17
    HintImageIndex = 0
    TabOrder = 3
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'checkbox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    WordWrap = False
    AllowGrayed = False
    State = cbUnchecked
    ImageIndex = 0
    Flat = True
    UseSkinFontColor = True
    TabStop = True
    CanFocused = True
    Radio = False
    Checked = False
    GroupIndex = 0
    Caption = 'fsStrikeOut'
  end
  object bsSkinButton1: TbsSkinButton
    Left = 16
    Top = 120
    Width = 75
    Height = 25
    HintImageIndex = 0
    TabOrder = 4
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'button'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    Transparent = False
    CheckedMode = False
    ImageList = SBForm.bsPngImageList5
    ImageIndex = 7
    AlwaysShowLayeredFrame = False
    UseSkinSize = True
    UseSkinFontColor = True
    RepeatMode = False
    RepeatInterval = 100
    AllowAllUp = False
    TabStop = True
    CanFocused = True
    Down = False
    GroupIndex = 0
    Caption = 'Ok'
    NumGlyphs = 1
    Spacing = 5
    OnClick = bsSkinButton1Click
  end
  object bsSkinButton2: TbsSkinButton
    Left = 104
    Top = 120
    Width = 75
    Height = 25
    HintImageIndex = 0
    TabOrder = 5
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'button'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 13
    DefaultFont.Name = 'Tahoma'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    Transparent = False
    CheckedMode = False
    ImageList = SBForm.bsPngImageList5
    ImageIndex = 8
    AlwaysShowLayeredFrame = False
    UseSkinSize = True
    UseSkinFontColor = True
    RepeatMode = False
    RepeatInterval = 100
    AllowAllUp = False
    TabStop = True
    CanFocused = True
    Down = False
    GroupIndex = 0
    Caption = 'Cancel'
    NumGlyphs = 1
    Spacing = 5
    OnClick = bsSkinButton2Click
  end
  object bsBusinessSkinForm1: TbsBusinessSkinForm
    ShowMDIScrollBars = True
    WindowState = wsNormal
    QuickButtons = <>
    QuickButtonsShowHint = False
    QuickButtonsShowDivider = True
    ClientInActiveEffect = False
    ClientInActiveEffectType = bsieSemiTransparent
    DisableSystemMenu = False
    AlwaysResize = False
    PositionInMonitor = bspDefault
    UseFormCursorInNCArea = False
    MaxMenuItemsInWindow = 0
    ClientWidth = 200
    ClientHeight = 155
    HideCaptionButtons = False
    AlwaysShowInTray = False
    LogoBitMapTransparent = False
    AlwaysMinimizeToTray = False
    UseSkinFontInMenu = True
    UseSkinFontInCaption = True
    UseSkinSizeInMenu = True
    ShowIcon = False
    MaximizeOnFullScreen = False
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    ShowObjectHint = False
    MenusAlphaBlend = False
    MenusAlphaBlendAnimation = False
    MenusAlphaBlendValue = 200
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
    SkinData = SBForm.bsSkinData1
    MenusSkinData = SBForm.bsSkinData1
    MinHeight = 0
    MinWidth = 0
    MaxHeight = 0
    MaxWidth = 0
    Magnetic = False
    MagneticSize = 5
    BorderIcons = []
    Left = 152
    Top = 8
  end
end
