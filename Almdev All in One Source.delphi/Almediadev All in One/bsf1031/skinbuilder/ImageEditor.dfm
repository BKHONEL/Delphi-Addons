object IEFrm: TIEFrm
  Left = 297
  Top = 196
  AutoScroll = False
  BorderIcons = []
  ClientHeight = 447
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object bsSkinSpeedButton2: TbsSkinSpeedButton
    Left = 9
    Top = 35
    Width = 25
    Height = 25
    HintImageIndex = 0
    SkinDataName = 'toolbutton'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    CheckedMode = False
    UseSkinSize = True
    UseSkinFontColor = True
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    ImageIndex = 0
    RepeatMode = False
    RepeatInterval = 100
    Transparent = False
    Flat = False
    AllowAllUp = False
    Down = False
    GroupIndex = 0
    ShowCaption = True
    NumGlyphs = 1
    Spacing = 1
    OnClick = bsSkinSpeedButton1Click
  end
  object Panel1: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 121
    HintImageIndex = 0
    TabOrder = 0
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'panel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    EmptyDrawing = False
    RibbonStyle = False
    ImagePosition = bsipDefault
    TransparentMode = False
    CaptionImageIndex = -1
    RealHeight = -1
    AutoEnabledControls = True
    CheckedMode = False
    Checked = False
    DefaultAlignment = taLeftJustify
    DefaultCaptionHeight = 22
    BorderStyle = bvNone
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Align = alTop
    object LBX: TbsSkinStdLabel
      Left = 16
      Top = 4
      Width = 10
      Height = 13
      EllipsType = bsetNone
      UseSkinFont = True
      UseSkinColor = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'X:'
    end
    object bsSkinSpeedButton1: TbsSkinSpeedButton
      Left = 9
      Top = 35
      Width = 25
      Height = 25
      HintImageIndex = 0
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'toolbutton'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      CheckedMode = False
      ImageList = SBForm.bsPngImageList5
      UseSkinSize = True
      UseSkinFontColor = True
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      ImageIndex = 5
      RepeatMode = False
      RepeatInterval = 100
      Transparent = False
      Flat = False
      AllowAllUp = False
      Down = False
      GroupIndex = 0
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = bsSkinSpeedButton1Click
    end
    object bsSkinSpeedButton3: TbsSkinSpeedButton
      Left = 41
      Top = 35
      Width = 25
      Height = 25
      HintImageIndex = 0
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'toolbutton'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      CheckedMode = False
      ImageList = SBForm.bsPngImageList5
      UseSkinSize = True
      UseSkinFontColor = True
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      ImageIndex = 6
      RepeatMode = False
      RepeatInterval = 100
      Transparent = False
      Flat = False
      AllowAllUp = False
      Down = False
      GroupIndex = 0
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = bsSkinSpeedButton3Click
    end
    object Label1: TbsSkinStdLabel
      Left = 416
      Top = 16
      Width = 55
      Height = 13
      EllipsType = bsetNone
      UseSkinFont = True
      UseSkinColor = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'Zoom level:'
    end
    object LbY: TbsSkinStdLabel
      Left = 16
      Top = 20
      Width = 10
      Height = 13
      EllipsType = bsetNone
      UseSkinFont = True
      UseSkinColor = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'Y:'
    end
    object LbSize: TbsSkinStdLabel
      Left = 88
      Top = 4
      Width = 16
      Height = 13
      EllipsType = bsetNone
      UseSkinFont = True
      UseSkinColor = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = '0:0'
    end
    object ZoomEdit: TbsSkinSpinEdit
      Left = 416
      Top = 35
      Width = 57
      Height = 22
      HintImageIndex = 0
      TabOrder = 0
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'spinedit'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      DefaultColor = clWindow
      UseSkinSize = True
      ValueType = vtInteger
      MinValue = 1.000000000000000000
      MaxValue = 4.000000000000000000
      Value = 2.000000000000000000
      Increment = 1.000000000000000000
      EditorEnabled = True
      MaxLength = 0
      OnChange = ZoomEditChange
    end
    object Y2Edit: TbsSkinSpinEdit
      Left = 256
      Top = 38
      Width = 57
      Height = 22
      HintImageIndex = 0
      TabOrder = 1
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'spinedit'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      DefaultColor = clWindow
      UseSkinSize = True
      ValueType = vtInteger
      Increment = 1.000000000000000000
      EditorEnabled = True
      MaxLength = 0
      OnChange = Y2EditChange
    end
    object X2Edit: TbsSkinSpinEdit
      Left = 200
      Top = 38
      Width = 49
      Height = 22
      HintImageIndex = 0
      TabOrder = 2
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'spinedit'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      DefaultColor = clWindow
      UseSkinSize = True
      ValueType = vtInteger
      Increment = 1.000000000000000000
      EditorEnabled = True
      MaxLength = 0
      OnChange = X2EditChange
    end
    object Y1Edit: TbsSkinSpinEdit
      Left = 144
      Top = 38
      Width = 49
      Height = 22
      HintImageIndex = 0
      TabOrder = 3
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'spinedit'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      DefaultColor = clWindow
      UseSkinSize = True
      ValueType = vtInteger
      Increment = 1.000000000000000000
      EditorEnabled = True
      MaxLength = 0
      OnChange = Y1EditChange
    end
    object X1Edit: TbsSkinSpinEdit
      Left = 88
      Top = 38
      Width = 49
      Height = 22
      HintImageIndex = 0
      TabOrder = 4
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'spinedit'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      DefaultColor = clWindow
      UseSkinSize = True
      ValueType = vtInteger
      Increment = 1.000000000000000000
      EditorEnabled = True
      MaxLength = 0
      OnChange = X1EditChange
    end
    object bsSkinButton1: TbsSkinButton
      Left = 8
      Top = 80
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
      Default = True
      OnClick = bsSkinButton1Click
    end
    object bsSkinButton2: TbsSkinButton
      Left = 96
      Top = 80
      Width = 75
      Height = 25
      HintImageIndex = 0
      TabOrder = 6
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
  end
  object bsSkinPanel1: TbsSkinPanel
    Left = 0
    Top = 121
    Width = 505
    Height = 326
    HintImageIndex = 0
    TabOrder = 1
    SkinData = SBForm.bsSkinData1
    SkinDataName = 'panel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    EmptyDrawing = False
    RibbonStyle = False
    ImagePosition = bsipDefault
    TransparentMode = False
    CaptionImageIndex = -1
    RealHeight = -1
    AutoEnabledControls = True
    CheckedMode = False
    Checked = False
    DefaultAlignment = taLeftJustify
    DefaultCaptionHeight = 22
    BorderStyle = bvFrame
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'bsSkinPanel1'
    Align = alClient
    object bsSkinScrollBox1: TbsSkinScrollBox
      Left = 1
      Top = 1
      Width = 484
      Height = 305
      HintImageIndex = 0
      TabOrder = 0
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'scrollbox'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      HScrollBar = bsSkinScrollBar1
      VScrollBar = bsSkinScrollBar2
      BorderStyle = bvNone
      CanFocused = False
      Align = alClient
    end
    object bsSkinScrollBar1: TbsSkinScrollBar
      Left = 1
      Top = 306
      Width = 503
      Height = 19
      HintImageIndex = 0
      TabOrder = 1
      Visible = False
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'hscrollbar'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 19
      UseSkinFont = True
      Both = False
      BothMarkerWidth = 19
      BothSkinDataName = 'bothhscrollbar'
      CanFocused = False
      Align = alBottom
      Kind = sbHorizontal
      PageSize = 0
      Min = 0
      Max = 0
      Position = 0
      SmallChange = 1
      LargeChange = 1
    end
    object bsSkinScrollBar2: TbsSkinScrollBar
      Left = 485
      Top = 1
      Width = 19
      Height = 305
      HintImageIndex = 0
      TabOrder = 2
      Visible = False
      SkinData = SBForm.bsSkinData1
      SkinDataName = 'vscrollbar'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 13
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      Both = False
      BothMarkerWidth = 19
      BothSkinDataName = 'bothhscrollbar'
      CanFocused = False
      Align = alRight
      Kind = sbVertical
      PageSize = 0
      Min = 0
      Max = 0
      Position = 0
      SmallChange = 1
      LargeChange = 1
    end
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
    PositionInMonitor = bspDesktopCenter
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
    BorderIcons = [biMaximize]
    Left = 264
    Top = 16
  end
end
