unit SPImageEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Spin, spPropertyEditor, spLoupe;

type
  TIEFrm = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Panel4: TPanel;
    spLoupe1: TspLoupe;
    Panel5: TPanel;
    LBX: TLabel;
    LbY: TLabel;
    X1Edit: TSpinEdit;
    Y1Edit: TSpinEdit;
    X2Edit: TSpinEdit;
    Y2Edit: TSpinEdit;
    Label1: TLabel;
    ZoomEdit: TSpinEdit;
    PBox: TPaintBox;
    SpeedButton1: TSpeedButton;
    OKBtn: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ZoomEditChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure X1EditChange(Sender: TObject);
    procedure Y1EditChange(Sender: TObject);
    procedure X2EditChange(Sender: TObject);
    procedure Y2EditChange(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    IsGetRect: Boolean;
    B: TBitMap;
    ResultRect: TRect;
    ResultPoint: TPoint;
    FProperty: TspProperty;
    FPoint: TPoint;
    FRect: TRect;
    FStopChange: Boolean;
    procedure PaintRect(X1, Y1, X2, Y2: Integer);
    procedure PaintCursor(X, Y: Integer);
    procedure ExecuteAsGetPoint(AB: TBitMap; P: TspProperty);
    procedure ExecuteAsGetRect(AB: TBitMap; P: TspProperty);
  public
    { Public declarations }
  end;


var
  IEFrm: TIEFrm;

  procedure ExecuteAsGetRect(AB: TBitMap; P: TspProperty);
  procedure ExecuteAsGetPoint(AB: TBitMap; P: TspProperty);

implementation

{$R *.DFM}
uses
  SkinBuild;
  
var
  Down: Boolean;
  X1, Y1, X2, Y2: Integer;

procedure ExecuteAsGetRect;
begin
  if AB = nil
  then
    begin
      P.Value := '0,0,0,0';
      Exit;
    end;
  IEFrm.Caption := 'Rect';
  IEFrm.ExecuteAsGetRect(AB, P);
  IEFrm.ShowModal;
end;

procedure ExecuteAsGetPoint;
begin
  if AB = nil
  then
    begin
      P.Value := '0,0';
      Exit;
    end;
  IEFrm.Caption := 'Point';
  IEFrm.ExecuteAsGetPoint(AB, P);
  IEFrm.ShowModal;
end;

procedure TIEFrm.PBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Down := True;
  FStopChange := True;
  X1 := X;
  Y1 := Y;
  X1Edit.Value := X;
  Y1Edit.Value := Y;
  if IsGetRect
  then
    begin
      X2Edit.Value := X;
      Y2Edit.Value := Y;
      PaintCursor(X1, Y1);
      X2 := X;
      Y2 := Y;
      PaintRect(ResultRect.Left, ResultRect.Top,
                ResultRect.Right, ResultRect.Bottom);
      ResultRect := Rect(X1, Y1, X2, Y2);
    end
  else
    begin
      PaintCursor(ResultPoint.X, ResultPoint.Y);
      ResultPoint.X := X1;
      ResultPoint.Y := Y1;
    end;
end;

procedure TIEFrm.PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LBX.Caption := 'X: ' + IntToStr(X);
  LBY.Caption := 'Y: ' + IntToStr(Y);
  if IsGetRect and Down
  then
    begin
      X2Edit.Value := X;
      Y2Edit.Value := Y;
      PaintRect(X1, Y1, X2, Y2);
      PaintRect(X1, Y1, X, Y);
      X2 := X;
      Y2 := Y;
      ResultRect := Rect(X1, Y1, X2, Y2);
    end
  else
    begin
      PaintCursor(X1, Y1);
      PaintCursor(X, Y);
      X1 := X;
      Y1 := Y;
    end;
end;

procedure TIEFrm.PBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Down := False;
  FStopChange := False;
  if IsGetRect
  then
    PaintCursor(X1, Y1)
  else
    PaintCursor(ResultPoint.X, ResultPoint.Y);
end;

procedure TIEFrm.PaintCursor(X, Y: Integer);
begin
  with PBox.Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := clBlack;
    Pen.Style := psDot;
    Pen.Mode := pmNot;
    MoveTo(0, Y); LineTo(X, Y);
    MoveTo(X, 0); LineTo(X, Y);
    MoveTo(PBox.Width, Y); LineTo(X, Y);
    MoveTo(X, PBox.Height); LineTo(X, Y);
    Pen.Style := psSolid;
  end;
end;

procedure TIEFrm.PaintRect;
begin
  with PBox.Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := clBlack;
    Pen.Style := psDot;
    Pen.Mode := pmNot;
    Rectangle(X1, Y1, X2, Y2);
    Pen.Style := psSolid;
  end;
end;

procedure TIEFrm.PBoxPaint(Sender: TObject);
begin
  PBox.Width := B.Width;
  PBox.Height := B.Height;
  PBox.Canvas.Draw(0, 0, B);
  if IsGetRect
  then
    PaintRect(ResultRect.Left, ResultRect.Top,
              ResultRect.Right, ResultRect.Bottom)
  else
    PaintCursor(ResultPoint.X, ResultPoint.Y);
  X1 := -1; Y1 := -1;  
end;

procedure TIEFrm.FormShow(Sender: TObject);
begin
  X1 := -1; Y1 := -1;
  X2 := -1; Y2 := -1;
  spLoupe1.Active := True;
end;

procedure TIEFrm.ExecuteAsGetPoint;
begin
  B := AB;
  PBox.Width := B.Width;
  PBox.Height := B.Height;
  IsGetRect := False;
  X2Edit.Visible := False;
  Y2Edit.Visible := False;
  FProperty := P;
  FPoint := GetPoint(FProperty.Value);
  X1Edit.Value := FPoint.X;
  Y1Edit.Value := FPoint.Y;
  ResultPoint := FPoint;
end;

procedure TIEFrm.ExecuteAsGetRect;
begin
  IsGetRect := True;
  B := AB;
  PBox.Width := B.Width;
  PBox.Height := B.Height;
  X2Edit.Visible := True;
  Y2Edit.Visible := True;
  FProperty := P;
  FRect := GetRect(FProperty.Value);
  X1Edit.Value := FRect.Left;
  Y1Edit.Value := FRect.Top;
  X2Edit.Value := FRect.Right;
  Y2Edit.Value := FRect.Bottom;
  ResultRect := FRect;
end;

procedure TIEFrm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TIEFrm.OKBtnClick(Sender: TObject);
begin
  if IsGetRect
  then
    begin
      FRect := Rect(X1Edit.Value, Y1Edit.Value,
       X2Edit.Value, Y2Edit.Value);
      FProperty.Value := SetRect(FRect);
    end
  else
    begin
      FPoint := Point(X1Edit.Value, Y1Edit.Value);
      FProperty.Value := SetPoint(FPoint);
    end;
  Close;
end;

procedure TIEFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SBForm.TempImage <> nil
  then
    begin
      SBForm.TempImage.Free;
      SBForm.TempImage := nil;
    end;
  spLoupe1.Active := False;  
end;

procedure TIEFrm.FormCreate(Sender: TObject);
begin
  PBox.Cursor := crNone;
end;

procedure TIEFrm.ZoomEditChange(Sender: TObject);
begin
  spLoupe1.ZoomLevel := ZoomEdit.Value;
end;

procedure TIEFrm.SpeedButton1Click(Sender: TObject);
begin
  X1 := X1Edit.Value;
  Y1 := Y1Edit.Value;
  if IsGetRect
  then
    begin
      X2 := X2Edit.Value;
      Y2 := Y2Edit.Value;
      ResultRect := Rect(X1, Y1, X2, Y2);
    end
  else
    ResultPoint := Point(X1, Y1);
  PBox.Repaint;
end;

procedure TIEFrm.FormResize(Sender: TObject);
begin
  PBox.RePaint;
end;

procedure TIEFrm.X1EditChange(Sender: TObject);
begin
  if not FStopChange then SpeedButton1Click(Self);
end;

procedure TIEFrm.Y1EditChange(Sender: TObject);
begin
 if not FStopChange then SpeedButton1Click(Self);
end;

procedure TIEFrm.X2EditChange(Sender: TObject);
begin
  if not FStopChange then SpeedButton1Click(Self);
end;

procedure TIEFrm.Y2EditChange(Sender: TObject);
begin
 if not FStopChange then SpeedButton1Click(Self);
end;

procedure TIEFrm.SpeedButton2Click(Sender: TObject);
begin
  X1Edit.Value := 0;
  Y1Edit.Value := 0;
  X2Edit.Value := 0;
  Y2Edit.Value := 0;
end;

end.
