object SelColorPicForm: TSelColorPicForm
  Left = 348
  Top = 330
  BorderStyle = bsDialog
  Caption = 'Select color from picture'
  ClientHeight = 362
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 49
    Align = alTop
    TabOrder = 0
    object ShowPicShape: TShape
      Left = 8
      Top = 8
      Width = 33
      Height = 33
    end
    object Shape: TShape
      Left = 56
      Top = 8
      Width = 33
      Height = 33
    end
    object BitBtn1: TBitBtn
      Left = 120
      Top = 12
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 208
      Top = 12
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 49
    Width = 532
    Height = 313
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object PBox: TPaintBox
      Left = 0
      Top = 0
      Width = 189
      Height = 169
      Cursor = crHandPoint
      DragCursor = crDefault
      OnMouseDown = PBoxMouseDown
      OnMouseMove = PBoxMouseMove
      OnPaint = PBoxPaint
    end
  end
end
