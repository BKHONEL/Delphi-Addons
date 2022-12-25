unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SkinForm, Menus, MPlayer, StdCtrls;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    cmSkin: TMenuItem;
    cmExit: TMenuItem;
    cmDefaultSkin: TMenuItem;
    SkinForm1: TSkinForm;
    procedure FormCreate(Sender: TObject);
    procedure SkinForm1MouseUpNotify(ID: String; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmExitClick(Sender: TObject);
    procedure cmSkinClick(Sender: TObject);
    procedure SkinForm1TrackBarNotify(ID: String; Position: Integer);
    procedure cmDefaultSkinClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Count: integer;
implementation

{$R *.DFM}
{$R default.res}

procedure TForm1.FormCreate(Sender: TObject);
begin
     //Load a skin file
     SkinForm1.LoadDefaultSkin;
     SkinForm1.SetDisplayText('VOLUME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_VOLUME')));
     SkinForm1.SetDisplayText('TIME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_POS')));
     SkinForm1.SetTrackBarMinMax('TRACKBAR_VOLUME', 20, 80);
end;

procedure TForm1.SkinForm1MouseUpNotify(ID: String; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   pos : TPoint;
begin
     if (Button = mbLeft) then
     begin
          if ID = 'BUTTON_EXIT' then
               Close;
          if ID = 'BUTTON_MINIMIZE' then
               Form1.Perform(WM_SYSCOMMAND, SC_MINIMIZE, 0);

          if ID = 'BUTTON_MENU' then
          begin
               pos := ClientToScreen(Point(X, Y));
               PopupMenu1.Popup(pos.x, pos.y);
          end;

     end;

     if (Button = mbRight) then
     begin
          pos := ClientToScreen(Point(X, Y));
          PopupMenu1.Popup(pos.x, pos.y);
     end;

end;

procedure TForm1.cmExitClick(Sender: TObject);
begin
     Close;
end;

procedure TForm1.cmSkinClick(Sender: TObject);
var
   SkinsDlg : TOpenDialog;
begin
     SkinsDlg := TOpenDialog.Create(self);
     SkinsDlg.InitialDir := ExtractFilePath(Application.ExeName);
     SkinsDlg.Filter := 'Skin files (*.ini)|*.ini';
     if SkinsDlg.Execute then
     begin
          SkinForm1.LoadSkinFile(SkinsDlg.FileName);  //Change the skin
          SkinForm1.SetDisplayText('VOLUME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_VOLUME')));
          SkinForm1.SetDisplayText('TIME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_POS')));
          SkinForm1.SetTrackBarMinMax('TRACKBAR_VOLUME', 20, 80);
     end;
     SkinsDlg.Free;
end;

procedure TForm1.SkinForm1TrackBarNotify(ID: String; Position: Integer);
begin
     if ID = 'TRACKBAR_VOLUME' then
        SkinForm1.SetDisplayText('VOLUME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_VOLUME')));

     if ID = 'TRACKBAR_POS' then
        SkinForm1.SetDisplayText('TIME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_POS')));
end;

procedure TForm1.cmDefaultSkinClick(Sender: TObject);
begin
     SkinForm1.LoadDefaultSkin;
     SkinForm1.SetDisplayText('VOLUME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_VOLUME')));
     SkinForm1.SetDisplayText('TIME', IntToStr(SkinForm1.GetTrackBarPos('TRACKBAR_POS')));
     SkinForm1.SetTrackBarMinMax('TRACKBAR_VOLUME', 20, 80);
end;

end.
