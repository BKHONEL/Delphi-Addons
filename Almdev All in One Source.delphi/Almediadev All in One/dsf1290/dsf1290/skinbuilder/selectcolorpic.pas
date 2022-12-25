unit selectcolorpic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, spPropertyEditor, SkinCtrls,
  DynamicSkinForm;

type
  TSelColorPicForm = class(TForm)
    Panel1: TspSkinPanel;
    ShowPicShape: TShape;
    Shape: TShape;
    bsSkinButton1: TspSkinButton;
    bsSkinButton2: TspSkinButton;
    bsDynamicSkinForm1: TspDynamicSkinForm;
    procedure bsSkinButton2Click(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PBox: TspSkinViewer;
    Pic: TBitMap;
    procedure PBoxPaint(Sender: TObject);
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  end;

var
  SelColorPicForm: TSelColorPicForm;

  procedure ExecuteColorPicDialog(Apic: TBitMap);

implementation

uses selectcolor, SkinBuild;

{$R *.DFM}

procedure ExecuteColorPicDialog(Apic: TBitMap);
begin
  SelColorPicForm.Pic := Apic;
  SelColorPicForm.ShowModal;
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

procedure TSelColorPicForm.bsSkinButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TSelColorPicForm.bsSkinButton1Click(Sender: TObject);
begin
  SelectColorForm.ShowShape.Brush.Color := ShowPicShape.Brush.Color;
  Close;
end;

procedure TSelColorPicForm.FormCreate(Sender: TObject);
begin
  PBox := TspSkinViewer.Create(Self);
  PBox.Parent := Self;
  PBox.SetBounds(0, Panel1.Top + Panel1.Height + 1, 100, 100);
  PBox.Cursor := crCross;
  Pic := nil;
  PBox.OnPaint := PBoxPaint;
  PBox.OnMouseMove := PBoxMouseMove;
  PBox.OnMouseDown := PBoxMouseDown;
end;

end.
