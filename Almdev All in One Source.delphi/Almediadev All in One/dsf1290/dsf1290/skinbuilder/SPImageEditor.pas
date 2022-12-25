unit SPImageEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, spPropertyEditor,
  SkinBoxCtrls, SkinCtrls, DynamicSkinForm, spUtils;


type
  TIEFrm = class(TForm)
    Panel1: TspSkinPanel;
    bsSkinSpeedButton2: TspSkinSpeedButton;
    spSkinPanel1: TspSkinPanel;
    spDynamicSkinForm1: TspDynamicSkinForm;
    LBX: TspSkinStdLabel;
    LbY: TspSkinStdLabel;
    spSkinSpeedButton1: TspSkinSpeedButton;
    spSkinSpeedButton3: TspSkinSpeedButton;
    Label1: TspSkinStdLabel;
    ZoomEdit: TspSkinSpinEdit;
    Y2Edit: TspSkinSpinEdit;
    X2Edit: TspSkinSpinEdit;
    Y1Edit: TspSkinSpinEdit;
    X1Edit: TspSkinSpinEdit;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    spSkinScrollBox1: TspSkinScrollBox;
    spSkinScrollBar1: TspSkinScrollBar;
    spSkinScrollBar2: TspSkinScrollBar;
    LBSize: TspSkinStdLabel;
    procedure PBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PBox1Paint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure X1EditChange(Sender: TObject);
    procedure Y1EditChange(Sender: TObject);
    procedure X2EditChange(Sender: TObject);
    procedure Y2EditChange(Sender: TObject);
    procedure PBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PBoxPaint(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
    procedure spSkinButton2Click(Sender: TObject);
    procedure spSkinSpeedButton1Click(Sender: TObject);
    procedure spSkinSpeedButton3Click(Sender: TObject);
    procedure ZoomEditChange(Sender: TObject);
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
    FScale: Integer;
    PBox: TspSkinViewer;
    procedure PaintRect(Cnvs: TCanvas; X1, Y1, X2, Y2: Integer);
    procedure PaintPoint(Cnvs: TCanvas; X, Y: Integer);
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

procedure TIEFrm.PBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  X1, Y1: Integer;
begin
  X1 := Trunc(X / FScale);
  Y1 := Trunc(Y / FScale);

  if IsGetRect
  then
    begin
      if Button = mbLeft
      then
        begin
          X1Edit.Value := X1;
          Y1Edit.Value := Y1;
          ResultRect.Left := X1;
          ResultRect.Top := Y1;
        end
      else
      if Button = mbRight
      then
        begin
          X2Edit.Value := X1 + 1;
          Y2Edit.Value := Y1 + 1;
          ResultRect.Right := X1 + 1;
          ResultRect.Bottom := Y1 + 1;
        end;
    end
  else
    begin
      X1Edit.Value := X1;
      Y1Edit.Value := Y1;
      ResultPoint.X := X1;
      ResultPoint.Y := Y1;
    end;

  PBox.Repaint;
  if IsGetRect
  then
    if (RectWidth(ResultRect) > 0) and (RectHeight(ResultRect) > 0)
    then
      LBSize.Caption := IntToStr(RectWidth(ResultRect)) + 'x' + IntToStr(RectHeight(ResultRect))
    else
      LBSize.Caption := '0x0';
end;

procedure TIEFrm.PBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LBX.Caption := 'X: ' + IntToStr(Trunc(X / FScale));
  LBY.Caption := 'Y: ' + IntToStr(Trunc(Y / FScale));
end;

procedure TIEFrm.PaintPoint(Cnvs: TCanvas; X, Y: Integer);
begin
  with Cnvs do
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
  with Cnvs do
  begin
    Brush.Style := bsClear;
    Pen.Color := clBlack;
    Pen.Style := psDot;
    Pen.Mode := pmNot;
    MoveTo(X1, Y1); LineTo(X1, PBox.Height);
    MoveTo(X1 + 1, Y1); LineTo(PBox.Width, Y1);
    MoveTo(X2, Y2); LineTo(X2, 0);
    MoveTo(X2 - 1, Y2); LineTo(0, Y2);
    Pen.Style := psSolid;
  end;
end;

procedure TIEFrm.PBox1Paint(Sender: TObject);
var
  DstRect: TRect;
  Buffer: TBitmap;
begin
  Buffer := TBitmap.Create;
  Buffer.Width := B.Width;
  Buffer.Height := B.Height;
  Buffer.Canvas.Draw(0, 0, B);
  PBox.Width := Buffer.Width * FScale;
  PBox.Height := Buffer.Height * FScale;
  DstRect := Rect(0, 0, PBox.Width, PBox.Height);
  if IsGetRect
  then
    begin
      PaintRect(Buffer.Canvas, ResultRect.Left, ResultRect.Top,
                  ResultRect.Right - 1, ResultRect.Bottom - 1)
    end            
  else
    PaintPoint(Buffer.Canvas, ResultPoint.X, ResultPoint.Y);
  PBox.Canvas.StretchDraw(DstRect, Buffer);
  Buffer.Free;
end;

procedure TIEFrm.FormShow(Sender: TObject);
begin
  X1 := -1; Y1 := -1;
  X2 := -1; Y2 := -1;
end;

procedure TIEFrm.ExecuteAsGetPoint;
var
  FReset: Boolean;
begin
  B := AB;
  FReset := (Trunc(PBox.Width / FScale) <> B.Width) or (Trunc(PBox.Height / FScale) <> B.Height);
  if FReset then
  begin
    PBox.Visible := False;
    spSkinScrollBox1.UpDateScrollRange;
  end;
  PBox.Width := B.Width * FScale;
  PBox.Height := B.Height * FScale;
  LBSize.Visible := False;
  IsGetRect := False;
  X2Edit.Visible := False;
  Y2Edit.Visible := False;
  FProperty := P;
  FPoint := GetPoint(FProperty.Value);
  X1Edit.Value := FPoint.X;
  Y1Edit.Value := FPoint.Y;
  ResultPoint := FPoint;
  if FReset then
  begin
    PBox.Visible := True;
    PBox.Left := 0;
    PBox.Top := 0;
  end;
end;

procedure TIEFrm.ExecuteAsGetRect;
var
  FReset: Boolean;
begin
  IsGetRect := True;
  B := AB;
  LBSize.Visible := True;
  FReset := (Trunc(PBox.Width / FScale) <> B.Width) or (Trunc(PBox.Height / FScale) <> B.Height);
  if FReset then
  begin
    PBox.Visible := False;
    spSkinScrollBox1.UpDateScrollRange;
  end;
  PBox.Width := B.Width * FScale;
  PBox.Height := B.Height * FScale;
  X2Edit.Visible := True;
  Y2Edit.Visible := True;
  FProperty := P;
  FRect := GetRect(FProperty.Value);
  X1Edit.Value := FRect.Left;
  Y1Edit.Value := FRect.Top;
  X2Edit.Value := FRect.Right;
  Y2Edit.Value := FRect.Bottom;
  ResultRect := FRect;
  LBSize.Caption := IntToStr(RectWidth(ResultRect)) + 'x' + IntToStr(RectHeight(ResultRect));
  if FReset then
  begin
    PBox.Visible := True;
    PBox.Left := 0;
    PBox.Top := 0;
  end;
end;

procedure TIEFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SBForm.TempImage <> nil
  then
    begin
      SBForm.TempImage.Free;
      SBForm.TempImage := nil;
    end;
end;

procedure TIEFrm.FormCreate(Sender: TObject);
begin
  FScale := 2;
  PBox := TspSkinViewer.Create(Self);
  PBox.Parent := spSkinScrollBox1;
  PBox.Left := 0;
  PBox.Top := 0;
  PBox.OnPaint := PBoxPaint;
  PBox.OnMouseMove := PBoxMouseMove;
  PBox.OnMouseDown := PBoxMouseDown;
  PBox.Cursor := crCross;
end;

procedure TIEFrm.FormResize(Sender: TObject);
begin
  PBox.RePaint;
end;

procedure TIEFrm.X1EditChange(Sender: TObject);
begin
  if not FStopChange then spSkinSpeedButton1Click(Self);
end;

procedure TIEFrm.Y1EditChange(Sender: TObject);
begin
  if not FStopChange then spSkinSpeedButton1Click(Self);
end;

procedure TIEFrm.X2EditChange(Sender: TObject);
begin
  if not FStopChange then spSkinSpeedButton1Click(Self);
end;

procedure TIEFrm.Y2EditChange(Sender: TObject);
begin
  if not FStopChange then spSkinSpeedButton1Click(Self);
end;

procedure TIEFrm.PBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  X1, Y1: Integer;
begin
  X1 := Trunc(X / FScale);
  Y1 := Trunc(Y / FScale);

  if IsGetRect
  then
    begin
      if Button = mbLeft
      then
        begin
          X1Edit.Value := X1;
          Y1Edit.Value := Y1;
          ResultRect.Left := X1;
          ResultRect.Top := Y1;
        end
      else
      if Button = mbRight
      then
        begin
          X2Edit.Value := X1 + 1;
          Y2Edit.Value := Y1 + 1;
          ResultRect.Right := X1 + 1;
          ResultRect.Bottom := Y1 + 1;
        end;
    end
  else
    begin
      X1Edit.Value := X1;
      Y1Edit.Value := Y1;
      ResultPoint.X := X1;
      ResultPoint.Y := Y1;
    end;

  PBox.Repaint;
  if IsGetRect
  then
    if (RectWidth(ResultRect) > 0) and (RectHeight(ResultRect) > 0)
    then
      LBSize.Caption := IntToStr(RectWidth(ResultRect)) + 'x' + IntToStr(RectHeight(ResultRect))
    else
      LBSize.Caption := '0x0'; 
end;

procedure TIEFrm.PBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  LBX.Caption := 'X: ' + IntToStr(Trunc(X / FScale));
  LBY.Caption := 'Y: ' + IntToStr(Trunc(Y / FScale));
end;

procedure TIEFrm.PBoxPaint(Sender: TObject);
var
  DstRect: TRect;
  Buffer: TBitmap;
begin
  Buffer := TBitmap.Create;
  Buffer.Width := B.Width;
  Buffer.Height := B.Height;
  Buffer.Canvas.Draw(0, 0, B);
  PBox.Width := Buffer.Width * FScale;
  PBox.Height := Buffer.Height * FScale;
  DstRect := Rect(0, 0, PBox.Width, PBox.Height);
  if IsGetRect
  then
    begin
      PaintRect(Buffer.Canvas, ResultRect.Left, ResultRect.Top,
                  ResultRect.Right - 1, ResultRect.Bottom - 1)
    end            
  else
    PaintPoint(Buffer.Canvas, ResultPoint.X, ResultPoint.Y);
  PBox.Canvas.StretchDraw(DstRect, Buffer);
  Buffer.Free;
end;

procedure TIEFrm.spSkinButton1Click(Sender: TObject);
begin
  if IsGetRect
  then
    begin
      FRect := Rect(Round(X1Edit.Value), Round(Y1Edit.Value),
       Round(X2Edit.Value), Round(Y2Edit.Value));
      FProperty.Value := SetRect(FRect);
    end
  else
    begin
      FPoint := Point(Round(X1Edit.Value), Round(Y1Edit.Value));
      FProperty.Value := SetPoint(FPoint);
    end;
  Close;
end;

procedure TIEFrm.spSkinButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TIEFrm.spSkinSpeedButton1Click(Sender: TObject);
begin
  X1 := Round(X1Edit.Value);
  Y1 := Round(Y1Edit.Value);
  if IsGetRect
  then
    begin
      X2 := Round(X2Edit.Value);
      Y2 := Round(Y2Edit.Value);
      ResultRect := Rect(X1, Y1, X2, Y2);
    end
  else
    ResultPoint := Point(X1, Y1);
  PBox.Repaint;
end;

procedure TIEFrm.spSkinSpeedButton3Click(Sender: TObject);
begin
  X1Edit.Value := 0;
  Y1Edit.Value := 0;
  X2Edit.Value := 0;
  Y2Edit.Value := 0;
end;

procedure TIEFrm.ZoomEditChange(Sender: TObject);
begin
  FScale := Round(ZoomEdit.Value);
  PBox.Repaint;
  spSkinScrollBox1.UpDateScrollRange;
end;

end.
