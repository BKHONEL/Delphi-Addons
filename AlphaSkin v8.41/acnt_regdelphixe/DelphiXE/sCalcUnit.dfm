object sCalcForm: TsCalcForm
  Tag = -98
  Left = 456
  Top = 384
  BorderStyle = bsNone
  Caption = 'Calculator'
  ClientHeight = 172
  ClientWidth = 214
  Color = clBtnFace
  KeyPreview = True
  Position = poMainFormCenter
  Scaled = False
  ShowHint = False
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  object FMainPanel: TsPanel
    Left = 0
    Top = 0
    Width = 214
    Height = 172
    Align = alClient
    BorderWidth = 2
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object FCalculatorPanel: TsPanel
      Left = 3
      Top = 25
      Width = 206
      Height = 142
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = ' '
      TabOrder = 0
      SkinData.SkinSection = 'PANEL'
      object sSpeedButton1: TsSpeedButton
        Left = 89
        Top = 29
        Width = 55
        Height = 20
        Cursor = crHandPoint
        Caption = '<-'
        Spacing = 0
        OnClick = sSpeedButton1Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton2: TsSpeedButton
        Left = 146
        Top = 29
        Width = 55
        Height = 20
        Cursor = crHandPoint
        Caption = 'C'
        Spacing = 3
        OnClick = sSpeedButton2Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton3: TsSpeedButton
        Left = 5
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = 'MC'
        Spacing = 3
        OnClick = sSpeedButton3Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton4: TsSpeedButton
        Tag = 7
        Left = 38
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '7'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton5: TsSpeedButton
        Tag = 8
        Left = 71
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '8'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton6: TsSpeedButton
        Tag = 9
        Left = 104
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '9'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton7: TsSpeedButton
        Left = 137
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '/'
        Spacing = 3
        OnClick = sSpeedButton7Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton8: TsSpeedButton
        Left = 170
        Top = 51
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = 'sqrt'
        Spacing = 3
        OnClick = sSpeedButton8Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton9: TsSpeedButton
        Left = 5
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = 'MR'
        Spacing = 3
        OnClick = sSpeedButton9Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton10: TsSpeedButton
        Tag = 4
        Left = 38
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '4'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton11: TsSpeedButton
        Tag = 5
        Left = 71
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '5'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton12: TsSpeedButton
        Tag = 6
        Left = 104
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '6'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton13: TsSpeedButton
        Left = 137
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '*'
        Spacing = 3
        OnClick = sSpeedButton13Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton14: TsSpeedButton
        Left = 170
        Top = 73
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '%'
        Spacing = 3
        OnClick = sSpeedButton14Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton15: TsSpeedButton
        Left = 5
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = 'MS'
        Spacing = 3
        OnClick = sSpeedButton15Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton16: TsSpeedButton
        Tag = 1
        Left = 38
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '1'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton17: TsSpeedButton
        Tag = 2
        Left = 71
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '2'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton18: TsSpeedButton
        Tag = 3
        Left = 104
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '3'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton19: TsSpeedButton
        Left = 137
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '-'
        Spacing = 3
        OnClick = sSpeedButton19Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton20: TsSpeedButton
        Left = 170
        Top = 95
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '1/%'
        Spacing = 3
        Visible = False
        OnClick = sSpeedButton20Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton21: TsSpeedButton
        Left = 5
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = 'MP'
        Spacing = 3
        OnClick = sSpeedButton21Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton22: TsSpeedButton
        Left = 38
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '0'
        Spacing = 3
        OnClick = sSpeedButton22Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton23: TsSpeedButton
        Left = 71
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = #177
        Spacing = 3
        OnClick = sSpeedButton23Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton24: TsSpeedButton
        Left = 104
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '.'
        Spacing = 3
        OnClick = sSpeedButton24Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton25: TsSpeedButton
        Left = 137
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '+'
        Spacing = 3
        OnClick = sSpeedButton25Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object sSpeedButton26: TsSpeedButton
        Left = 170
        Top = 117
        Width = 31
        Height = 20
        Cursor = crHandPoint
        Caption = '='
        Spacing = 3
        OnClick = sSpeedButton26Click
        SkinData.SkinSection = 'SPEEDBUTTON_SMALL'
        DisabledGlyphKind = []
      end
      object FCalcPanel: TsPanel
        Left = 5
        Top = 29
        Width = 81
        Height = 19
        BevelOuter = bvLowered
        Caption = ' '
        TabOrder = 0
        SkinData.SkinSection = 'PANEL'
      end
      object FDisplayPanel: TsPanel
        Left = 4
        Top = 4
        Width = 198
        Height = 20
        Align = alTop
        Alignment = taRightJustify
        Caption = '0 '
        Color = clWhite
        Ctl3D = True
        BorderStyle = bsSingle
        ParentCtl3D = False
        BevelOuter = bvNone
        BorderWidth = 3
        PopupMenu = PopupMenu1
        TabOrder = 1
        SkinData.SkinSection = 'EDIT'
      end
    end
    object sDragBar1: TsDragBar
      Left = 3
      Top = 3
      Width = 206
      Height = 20
      Cursor = crHandPoint
      Caption = 'Calculator'
      TabOrder = 1
      SkinData.SkinSection = 'DRAGBAR'
      DraggedControl = Owner
      object sToolButton3: TsSpeedButton
        Left = 172
        Top = 1
        Width = 16
        Height = 18
        Cursor = crHandPoint
        Align = alRight
        Caption = '_'
        Spacing = 3
        OnClick = sToolButton3Click
        SkinData.SkinSection = 'TOOLBUTTON'
        DisabledGlyphKind = []
      end
      object sToolButton1: TsSpeedButton
        Left = 188
        Top = 1
        Width = 17
        Height = 18
        Cursor = crHandPoint
        Align = alRight
        Caption = 'X'
        Spacing = 3
        OnClick = sToolButton1Click
        SkinData.SkinSection = 'TOOLBUTTON'
        DisabledGlyphKind = []
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 153
    Top = 24
    object N1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16429
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '&Paste'
      ShortCut = 8237
      OnClick = N2Click
    end
    object OK1: TMenuItem
      Caption = 'OK'
      ShortCut = 13
      Visible = False
      OnClick = OK1Click
    end
    object Cancel1: TMenuItem
      Caption = 'Cancel'
      ShortCut = 27
      Visible = False
      OnClick = Cancel1Click
    end
  end
end
