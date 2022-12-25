object Form1: TForm1
  Left = 371
  Top = 238
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 275
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = '‚l‚r ‚oƒSƒVƒbƒN'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object SkinForm1: TSkinForm
    Left = 0
    Top = 0
    Width = 275
    Height = 275
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    KeyColor = clWhite
    Tolerance = clBlack
    OnMouseUpNotify = SkinForm1MouseUpNotify
    OnTrackBarNotify = SkinForm1TrackBarNotify
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 8
    object cmSkin: TMenuItem
      Caption = 'Load &Skins ...'
      OnClick = cmSkinClick
    end
    object cmDefaultSkin: TMenuItem
      Caption = '&Default Skin'
      OnClick = cmDefaultSkinClick
    end
    object cmExit: TMenuItem
      Caption = 'E&xit'
      OnClick = cmExitClick
    end
  end
end
