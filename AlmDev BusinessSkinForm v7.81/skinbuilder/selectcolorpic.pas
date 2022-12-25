unit selectcolorpic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TSelColorPicForm = class(TForm)
    Panel1: TPanel;
    ShowPicShape: TShape;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ScrollBox1: TScrollBox;
    PBox: TPaintBox;
    Shape: TShape;
    procedure BitBtn1Click(Sender: TObject);
    procedure PBoxPaint(Sender: TObject);
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Pic: TBitMap;
  end;

var
  SelColorPicForm: TSelColorPicForm;

  procedure ExecuteColorPicDialog(Apic: TBitMap);

implementation

uses selectcolor;

{$R *.DFM}

procedure ExecuteColorPicDialog(Apic: TBitMap);
begin
  SelColorPicForm.Pic := Apic;
  SelColorPicForm.ShowModal;
end;


procedure TSelColorPicForm.BitBtn1Click(Sender: TObject);
begin
  SelectColorForm.ShowShape.Brush.Color := ShowPicShape.Brush.Color;
end;

procedure TSelColorPicForm.PBoxPaint(Sender: TObject);
begin
  PBox.Width := Pic.Width;
  PBox.Height := Pic.Height;
  PBox.Canvas.Draw(0, 0, Pic);
end;

procedure TSelColorPicForm.PBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowPicShape.Brush.Color := PBox.Canvas.Pixels[X, Y];
end;

procedure TSelColorPicForm.PBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Shape.Brush.Color := PBox.Canvas.Pixels[X, Y];
end;

end.
