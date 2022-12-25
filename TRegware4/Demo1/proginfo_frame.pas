unit proginfo_frame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, inifiles, comobj;

type
  TProgData = class(TObject)
  public
    ProgName: string[50];
    ProgGUID: string[38];
    Seed1, Seed2, Seed3: integer;
  end;

  TProgInfoFrame = class(TFrame)
    ProgInfoGroup: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label19: TLabel;
    ProgNameCombo: TComboBox;
    ProgGUIDBox: TEdit;
    Seed1Box: TEdit;
    TimeLimit: TEdit;
    CodeSizeBox: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Seed2Box: TEdit;
    Seed3Box: TEdit;
    FillProgInfoBtn: TBitBtn;
    NewProgBtn: TBitBtn;
    RenameBtn: TBitBtn;
    procedure NewProgBtnClick(Sender: TObject);
    procedure ProgNameComboKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FillProgInfoBtnClick(Sender: TObject);
    procedure ProgNameComboChange(Sender: TObject);
    procedure RenameBtnClick(Sender: TObject);
    procedure ProgNameComboExit(Sender: TObject);
    procedure ProgGUIDBoxKeyPress(Sender: TObject; var Key: Char);
  private
  public
    procedure RenameItem(Index: integer);
    procedure FillProgData(Number: integer);  // Displays selected information on the form
    procedure LoadProgData;
    procedure SaveProgData;
    procedure UpdateProgData;
  end;

const
  NEWPROG_TEXT='<New Program>';

implementation

{$R *.DFM}

procedure TProgInfoFrame.RenameItem(Index: integer);
var
  S: string;
  ProgInfo: TProgData;
begin
  if Index < 0 then Exit;
  ProgInfo := TProgData(ProgNameCombo.Items.Objects[Index]);
  S := ProgInfo.ProgName;
  if S = '' then S := NEWPROG_TEXT;
  S := InputBox('Set Program Name', 'Enter a program name', ProgInfo.ProgName);
  if S <> '' then
  begin
    ProgInfo.ProgName := S;
    ProgNameCombo.Items.Strings[Index] := S;
  end;
end;

procedure TProgInfoFrame.FillProgData(Number: integer);
begin
  if Number >= 0 then
  begin
    ProgNameCombo.Text := TProgData(ProgNameCombo.Items.Objects[Number]).ProgName;
    ProgGUIDBox.Text := TProgData(ProgNameCombo.Items.Objects[Number]).ProgGUID;
    Seed1Box.Text := IntToStr(TProgData(ProgNameCombo.Items.Objects[Number]).Seed1);
    Seed2Box.Text := IntToStr(TProgData(ProgNameCombo.Items.Objects[Number]).Seed2);
    Seed3Box.Text := IntToStr(TProgData(ProgNameCombo.Items.Objects[Number]).Seed3);
    ProgNameCombo.Tag := Number;
  end;
end;

procedure TProgInfoFrame.LoadProgData;
var
  Ini: TIniFile;
  Sections: TStringList;
  i: integer;
  ProgData: TProgData;
begin
  ProgNameCombo.Items.Clear;
  Sections := TStringList.Create;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'progdata.ini');
  try
    Ini.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
    begin
      ProgData := TProgData.Create;
      ProgData.ProgName := Sections[i];
      ProgData.ProgGUID := Ini.ReadString(Sections[i], 'ProgGUID', '');
      ProgData.Seed1 := Ini.ReadInteger(Sections[i], 'Seed1', 0);
      ProgData.Seed2 := Ini.ReadInteger(Sections[i], 'Seed2', 0);
      ProgData.Seed3 := Ini.ReadInteger(Sections[i], 'Seed3', 0);
      ProgNameCombo.Items.AddObject(ProgData.ProgName, ProgData);
    end;
  finally
    Sections.Free;
    Ini.Free;
  end;
end;

procedure TProgInfoFrame.SaveProgData;
var
  Ini: TIniFile;
  i: integer;
  ProgData: TProgData;
  Sections: TStringList;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'progdata.ini');
  Sections := TStringList.Create;
  try
    // Clear out the file, first
    Ini.ReadSections(Sections);
    for i := 0 to Sections.Count - 1 do
    begin
      Ini.EraseSection(Sections[i]);
    end;
    for i := 0 to ProgNameCombo.Items.Count - 1 do
    begin
      if CompareText(ProgNameCombo.Items.Strings[i], NEWPROG_TEXT) <> 0 then
      begin
        ProgData := TProgData(ProgNameCombo.Items.Objects[i]);
        Ini.WriteString(ProgNameCombo.Items.Strings[i], 'ProgGUID', ProgData.ProgGUID);
        Ini.WriteInteger(ProgNameCombo.Items.Strings[i], 'Seed1', ProgData.Seed1);
        Ini.WriteInteger(ProgNameCombo.Items.Strings[i], 'Seed2', ProgData.Seed2);
        Ini.WriteInteger(ProgNameCombo.Items.Strings[i], 'Seed3', ProgData.Seed3);
      end;
    end;
  finally
    Sections.Free;
    Ini.Free;
  end;
end;

procedure TProgInfoFrame.UpdateProgData;
var
  ProgData: TProgData;
begin
  ProgData := TProgData(ProgNameCombo.Items.Objects[ProgNameCombo.Tag]);
  ProgData.ProgGUID := ProgGUIDBox.Text;
  ProgData.Seed1 := StrToInt(Seed1Box.Text);
  ProgData.Seed2 := StrToInt(Seed2Box.Text);
  ProgData.Seed3 := StrToInt(Seed3Box.Text);
end;

procedure TProgInfoFrame.NewProgBtnClick(Sender: TObject);
var
  Index: integer;
begin
  Index := ProgNameCombo.Items.AddObject(NEWPROG_TEXT, TProgData.Create);
  RenameItem(Index);
  ProgNameCombo.ItemIndex := Index;
  FillProgData(Index);
  SaveProgData;
end;

procedure TProgInfoFrame.ProgNameComboKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  Index: integer;
begin
  with ProgNameCombo do
  begin
    if (Key = VK_DELETE) then
    begin
      Index := ItemIndex;
      Items.Delete(Index);
      if Items.Count - 1 < Index then Index := Items.Count - 1;
      ItemIndex := Index;
      SaveProgData;
      FillProgData(Index);
    end;
  end;
end;

procedure TProgInfoFrame.FillProgInfoBtnClick(Sender: TObject);

  function MakeRnd: integer;
  begin
    repeat
      Result := Random($0FFFFFFF);
    until Result > 10000;
  end;

begin
  Randomize;
  ProgGUIDBox.Text := CreateClassID;
  Seed1Box.Text := IntToStr(MakeRnd);
  Seed2Box.Text := IntToStr(MakeRnd);
  Seed3Box.Text := IntToStr(MakeRnd);
  UpdateProgData;
  SaveProgData;
end;

procedure TProgInfoFrame.ProgNameComboChange(Sender: TObject);
begin
  if ProgNameCombo.ItemIndex >= 0 then FillProgData(ProgNameCombo.ItemIndex);
end;

procedure TProgInfoFrame.RenameBtnClick(Sender: TObject);
var
  Index: integer;
begin
  Index := ProgNameCombo.ItemIndex;
  RenameItem(ProgNameCombo.ItemIndex);
  ProgNameCombo.ItemIndex := Index;
end;

procedure TProgInfoFrame.ProgNameComboExit(Sender: TObject);
begin
  UpdateProgData;
  SaveProgData;
end;

procedure TProgInfoFrame.ProgGUIDBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  UpdateProgData;
  SaveProgData;
end;

end.
