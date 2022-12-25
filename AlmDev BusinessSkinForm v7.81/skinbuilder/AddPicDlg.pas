unit AddPicDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, bsPropertyEditor, ExtDlgs;

type
  TLoadPicForm = class(TForm)
    Panel1: TPanel;
    LoadButton: TButton;
    ClearButton: TButton;
    ScrollBox1: TScrollBox;
    PB: TPaintBox;
    PD: TOpenPictureDialog;
    BitBtn1: TBitBtn;
    procedure LoadButtonClick(Sender: TObject);
    procedure PBPaint(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    SelfB: TBitMap;
    B: TBitMap;
    P: TbsProperty;
    PictureName: String;
  end;

var
  LoadPicForm: TLoadPicForm;


  procedure Execute(AB: TBitMap; AP: TbsProperty; APictureName: String;
                    CBEnabled: Boolean);

implementation

{$R *.DFM}

  Uses bsUtils;

procedure Execute;
begin
  with LoadPicForm do
  begin
    B := AB;
    P := AP;
    ClearButton.Enabled := CBEnabled;
    PictureName := APictureName;
    ShowModal;
  end;
end;


procedure TLoadPicForm.LoadButtonClick(Sender: TObject);
begin
  if PD.Execute
  then
    begin
      PictureName := ExtractFileName(PD.FileName);
      if P <> nil then P.Value := PictureName;
      SelfB.LoadFromFile(PD.FileName);
      if B <> nil then B.Assign(SelfB);  
      PB.Width := SelfB.Width;
      PB.Height := SelfB.Height;
      PB.Repaint;
    end;
end;

procedure TLoadPicForm.PBPaint(Sender: TObject);
begin
  if (SelfB <> nil) and not SelfB.Empty
  then
    PB.Canvas.Draw(0, 0, SelfB);
end;

procedure TLoadPicForm.ClearButtonClick(Sender: TObject);
begin
  if B <> nil then B.Assign(nil);
  SelfB.Assign(nil);
  PictureName := '';
  if P <> nil then P.Value := '';
  PB.RePaint;
end;

procedure TLoadPicForm.FormShow(Sender: TObject);
begin
  SelfB := TBitMap.Create;
  SelfB.Assign(B);
  if SelfB.Empty
  then
    begin
      PB.Width := 0;
      PB.Height := 0;
    end
  else
    begin
      PB.Width := SelfB.Width;
      PB.Height := SelfB.Height;
    end;
end;

procedure TLoadPicForm.FormHide(Sender: TObject);
begin
  SelfB.Free;
end;

procedure TLoadPicForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.
