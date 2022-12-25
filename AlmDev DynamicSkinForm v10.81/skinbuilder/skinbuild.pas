unit skinbuild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, spPropertyEditor, ExtCtrls, Buttons, Menus,
  StdCtrls, SkinData, ComCtrls, ToolWin, ExtDlgs, SPImageEditor,
  TestFrm, TestFrmNC, AddPicDlg, TestFrmNCEmpty, ImgList;

type
  TSBForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    SectionList: TListBox;
    Names: TListBox;
    Splitter1: TSplitter;
    OD: TOpenDialog;
    Panel4: TPanel;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SD: TSaveDialog;
    Panel2: TPanel;
    Label4: TLabel;
    PE: TspPropertyEditor;
    SkinData: TspSkinData;
    ToolBar2: TToolBar;
    NewSkinButton: TToolButton;
    OpenSkinButton: TToolButton;
    D1: TToolButton;
    SaveSkinButton: TToolButton;
    SaveSkinAsButton: TToolButton;
    D2: TToolButton;
    TestFormButton: TToolButton;
    TestCtrlsButton: TToolButton;
    D4: TToolButton;
    ExitButton: TToolButton;
    ImageList1: TImageList;
    TestCustomFormButton: TToolButton;
    CD: TOpenDialog;
    ToolButton1: TToolButton;
    procedure SectionListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PEEditProperty(P: TspProperty);
    procedure NamesClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure NewSkinButtonClick(Sender: TObject);
    procedure OpenSkinButtonClick(Sender: TObject);
    procedure SaveSkinButtonClick(Sender: TObject);
    procedure SaveSkinAsButtonClick(Sender: TObject);
    procedure TestCustomFormButtonClick(Sender: TObject);
    procedure TestFormButtonClick(Sender: TObject);
    procedure TestCtrlsButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ApplyChanges;
    procedure AddPicture;
    procedure DeletePicture;
    procedure AddCursor;
    procedure DeleteCursor;
    procedure LoadVersionSection;
    procedure LoadCursorsSection;
    procedure LoadPicturesSection;
    procedure LoadFormInfoSection;
    procedure SaveVersionSection;
    procedure SavePicturesSection;
    procedure SaveCursorsSection;
    procedure SaveFormInfoSection;
    procedure LoadAreas;
    procedure AddArea;
    procedure LoadArea(Index: Integer);
    procedure SaveArea(Index: Integer);
    procedure LoadPWSection;
    procedure LoadLFSection;
    procedure SaveLFSection;
    procedure SavePWSection;
    procedure LoadHWSection;
    procedure SaveHWSection;
    procedure LoadColorsSection;
    procedure SaveColorsSection;
    procedure LoadSkin;
    procedure NewSkin;
    procedure SaveSkin;
    procedure StrsDialog1;
    procedure StrsDialog2;
    procedure PointDialog(P: TspProperty; RUp: Boolean);
    procedure PointDialog1(Index: Integer; P: TspProperty);
    procedure PointDialog2(Index: Integer; R: TRect; P: TspProperty);
    procedure PointDialog21(R: TRect; P: TspProperty; RUp: Boolean);
    procedure RectDialog(P: TspProperty; RUp: Boolean);
    procedure RectDialog1(Index: Integer; P: TspProperty);
    procedure RectDialog2(Index: Integer; R: TRect; P: TspProperty);
    procedure RectDialog21(R: TRect; P: TspProperty; RUp: Boolean);
    procedure IndexDialog(P: TspProperty);
    procedure CIndexDialog(P: TspProperty);
    procedure FSDialog(P: TspProperty);
    procedure LoadCtrlList;
    procedure LoadControl(Index: Integer);
    procedure DefLoadControl(Index: Integer);
    procedure DefLoadResizeControl(Index: Integer);
    procedure LoadPanelControl(Index: Integer);
    procedure LoadExPanelControl(Index: Integer);
    procedure LoadLabelControl(Index: Integer);
    procedure LoadBitLabelControl(Index: Integer);
    procedure LoadStdLabelControl(Index: Integer);
    procedure LoadButtonControl(Index: Integer);
    procedure LoadMenuButtonControl(Index: Integer);
    procedure LoadCheckRadioControl(Index: Integer);
    procedure LoadGaugeControl(Index: Integer);
    procedure LoadSplitterControl(Index: Integer); 
    procedure LoadTrackBarControl(Index: Integer);
    procedure LoadRegulatorControl(Index: Integer);
    procedure LoadFGaugeControl(Index: Integer);
    procedure LoadAnimateControl(Index: Integer);
    procedure LoadUpDownControl(Index: Integer);
    procedure LoadSwitchControl(Index: Integer);
    procedure LoadGridControl(Index: Integer);
    procedure LoadTabControl(Index: Integer);
    procedure LoadSliderControl(Index: Integer);

    procedure LoadControlBar(Index: Integer);
    procedure LoadMainMenuBar(Index: Integer);
    procedure LoadListBoxControl(Index: Integer);
    procedure LoadCheckListBoxControl(Index: Integer); 
    procedure LoadComboBoxControl(Index: Integer);
    procedure LoadEditControl(Index: Integer);
    procedure LoadMemoControl(Index: Integer);
    procedure LoadScrollBarControl(Index: Integer);
    procedure LoadSpinEditControl(Index: Integer);
    procedure LoadScrollBoxControl(Index: Integer);
    procedure LoadTreeViewControl(Index: Integer);
    procedure LoadListViewControl(Index: Integer);
    procedure LoadRichEditControl(Index: Integer);
    procedure LoadBevelControl(Index: Integer);

    procedure SaveControl(Index: Integer);
    procedure DefSaveControl(Index: Integer);
    procedure DefSaveResizeControl(Index: Integer);
    procedure SavePanelControl(Index: Integer);
    procedure SaveExPanelControl(Index: Integer);
    procedure SaveLabelControl(Index: Integer);
    procedure SaveBitLabelControl(Index: Integer);
    procedure SaveStdLabelControl(Index: Integer);
    procedure SaveButtonControl(Index: Integer);
    procedure SaveMenuButtonControl(Index: Integer);
    procedure SaveCheckRadioControl(Index: Integer);
    procedure SaveSliderControl(Index: Integer);
    procedure SaveGaugeControl(Index: Integer);
    procedure SaveSplitterControl(Index: Integer);
    procedure SaveTrackBarControl(Index: Integer);
    procedure SaveRegulatorControl(Index: Integer);
    procedure SaveFGaugeControl(Index: Integer);
    procedure SaveAnimateControl(Index: Integer);
    procedure SaveUpDownControl(Index: Integer);
    procedure SaveSwitchControl(Index: Integer);
    procedure SaveGridControl(Index: Integer);
    procedure SaveTabControl(Index: Integer);
    procedure SaveMainMenuBar(Index: Integer);
    procedure SaveControlBar(Index: Integer);
    procedure SaveListBoxControl(Index: Integer);
    procedure SaveCheckListBoxControl(Index: Integer);
    procedure SaveComboBoxControl(Index: Integer);
    procedure SaveEditControl(Index: Integer);
    procedure SaveMemoControl(Index: Integer);
    procedure SaveScrollBarControl(Index: Integer);
    procedure SaveSpinEditControl(Index: Integer);
    procedure SaveScrollBoxControl(Index: Integer);
    procedure SaveTreeViewControl(Index: Integer);
    procedure SaveListViewControl(Index: Integer);
    procedure SaveRichEditControl(Index: Integer);
    procedure SaveBevelControl(Index: Integer);

    procedure LoadObjectList;
    procedure LoadObject(Index: Integer);
    procedure SaveObject(Index: Integer);
    procedure DefLoadObject(Index: Integer);
    procedure DefSaveObject(Index: Integer);
    procedure LoadMainMenuItem(Index: Integer);
    procedure LoadMainMenuBarItem(Index: Integer);
    procedure SaveMainMenuItem(Index: Integer);
    procedure SaveMainMenuBarItem(Index: Integer);
    procedure LoadMenuItem(Index: Integer);
    procedure SaveMenuItem(Index: Integer);
    procedure LoadStdButton(Index: Integer);
    procedure LoadMainMenuBarButton(Index: Integer);
    procedure SaveStdButton(Index: Integer);
    procedure SaveMainMenuBarButton(Index: Integer);
    procedure LoadButton(Index: Integer);
    procedure SaveButton(Index: Integer);
    procedure LoadCaption(Index: Integer);
    procedure SaveCaption(Index: Integer);
    procedure LoadTrackBar(Index: Integer);
    procedure SaveTrackBar(Index: Integer);
    procedure LoadLabel(Index: Integer);
    procedure SaveLabel(Index: Integer);
    procedure LoadAnimate(Index: Integer);
    procedure SaveAnimate(Index: Integer);
    procedure LoadGauge(Index: Integer);
    procedure SaveGauge(Index: Integer);
    procedure LoadFrameRegulator(Index: Integer);
    procedure SaveFrameRegulator(Index: Integer);
    procedure LoadFrameGauge(Index: Integer);
    procedure SaveFrameGauge(Index: Integer);
    procedure LoadBitLabel(Index: Integer);
    procedure SaveBitLabel(Index: Integer);
  public
    { Public declarations }
    TempImage: TBitMap;
    Changing: Boolean;
    procedure AddObject(Index: Integer; AName: String);
    procedure AddControl(Index: Integer; AName: String);
  end;

var
  SBForm: TSBForm;

implementation

uses IndexEditor, FSDlg, StringsEditor, AddObjDlg, addctrldlg, CindexEditor,
     spUtils, selectcolor;

{$R *.DFM}


function GetStretchType(S: String): TspStretchType;
begin
  if S = 'stfull'
  then Result := spstFull
  else
  if S = 'stvert'
  then Result := spstVert
  else
    Result := spstHorz;
end;

function SetStretchType(ST: TspStretchType): String;
begin
  case ST of
    spstFull: Result := 'stfull';
    spstHorz: Result := 'sthorz';
    spstVert: Result := 'stvert';
  end;
end;

function GetFrPl(S: String): TFramesPlacement;
begin
  if S = 'fphorizontal'
  then Result := fpHorizontal
  else Result := fpVertical;
end;

function GetRegKind(S: String): TRegulatorKind;
begin
  if S = 'rkround'
  then Result := rkRound
  else
  if S = 'rkhorizontal'
  then Result := rkHorizontal
  else Result := rkVertical;
end;

function SetRegKind(Kind: TRegulatorKind): String;
begin
  if Kind = rkRound
  then Result := 'rkround'
  else
  if Kind = rkHorizontal
  then Result := 'rkhorizontal'
  else Result := 'rkvertical';
end;

function SetFrPl(FP: TFramesPlacement): String;
begin
  if FP = fpHorizontal
  then Result := 'fphorizontal'
  else Result := 'fpvertical';
end;

function GetStdCommand(S: String): TStdCommand;
begin
  if S = 'cmdefault' then Result := cmDefault else
  if S = 'cmminimize' then Result := cmMinimize else
  if S = 'cmmaximize' then Result := cmMaximize else
  if S = 'cmclose' then Result := cmClose else
  if S = 'cmsysmenu' then Result := cmSysMenu else
  if S = 'cmrollup' then Result := cmRollUp else
  Result := cmMinimizeToTray;
end;


function SetStdCommand(C: TStdCommand): String;
begin
  if C = cmdefault then Result := 'cmdefault' else
  if C = cmMinimize then Result := 'cmminimize' else
  if C = cmMaximize then Result := 'cmmaximize' else
  if C = cmClose then Result := 'cmclose' else
  if C = cmSysMenu then Result := 'cmsysmenu' else
  if C = cmRollUp then Result := 'cmrollup' else
  Result := 'minimizetotray';
end;

function GetFrameRegulatorKind(S: String): TRegulatorKind;
begin
  if S = 'rkround'
  then
    Result := rkRound
  else
  if S = 'rkvertical'
  then
    Result := rkVertical
  else
    Result := rkHorizontal;
end;

function SetGaugeKind(GK: TGaugeKind): String;
begin
  if GK = gkVertical
  then Result := 'gkvertical'
  else Result := 'gkhorizontal';
end;


function GetGaugeKind(S: String): TGaugeKind;
begin
  if S = 'gkvertical'
  then Result := gkVertical
  else Result := gkHorizontal;
end;

function SetFrameRegulatorKind(FRK: TRegulatorKind): String;
begin
  case FRk of
    rkRound: Result := 'rkround';
    rkVertical: Result := 'rkvertical';
    rkHorizontal: Result := 'rkhorizontal';
  end;
end;


function SetMorphKind(MK: TMorphKind): String;
begin
  case MK of
    mkDefault: Result := 'mkdefault';
    mkGradient: Result := 'mkgradient';
    mkLeftGradient: Result := 'mkleftgradient';
    mkRightGradient: Result := 'mkrightgradient';
    mkLeftSlide: Result := 'mkleftslide';
    mkRightSlide: Result := 'mkrightslide';
    mkPush: Result := 'mkpush';
  end;
end;

function GetMorphKind(S: String): TMorphKind;
begin
  if S = 'mkdefault'
  then Result := mkDefault
  else
  if S = 'mkgradient'
  then Result := mkGradient
  else
  if S = 'mkleftgradient'
  then Result := mkLeftGradient
  else
  if S = 'mkrightgradient'
  then Result := mkRightGradient
  else
  if S = 'mkleftslide'
  then Result := mkLeftSlide
  else
  if S = 'mkrightslide'
  then Result := mkRightSlide
  else
    Result := mkPush;
end;

function GetInActiveEffect(S: String): TspInActiveEffect;
begin
  if S = 'iebrightness'
  then Result := ieBrightness
  else
  if S = 'iedarkness'
  then Result := ieDarkness
  else
  if S = 'iegrayscale'
  then Result := ieGrayScale
  else
  if S = 'ienoise'
  then Result := ieNoise
  else
  if S = 'iesplitblur'
  then Result := ieSplitBlur
  else Result := ieInvert;
end;

function SetInActiveEffect(IE: TspInActiveEffect): String;
begin
  case IE of
    ieBrightness: Result := 'iebrightness';
    ieDarkness: Result := 'iedarkness';
    ieGrayScale: Result := 'iegrayscale';
    ieNoise: Result := 'ienoise';
    ieSplitBlur: Result := 'iesplitblur';
    ieInvert: Result := 'ieinvert';
  end;
end;

procedure TSBForm.ApplyChanges;
begin
  case SectionList.ItemIndex  of
    0: SaveVersionSection;
    1: SavePicturesSection;
    2: SaveCursorsSection;
    3: SaveFormInfoSection;
    4: SavePWSection;
    5: SaveHWSection;
    6: SaveArea(Names.ItemIndex);
    7: SaveObject(Names.ItemIndex);
    8: SaveControl(Names.ItemIndex);
    9: SaveColorsSection;
    10: SaveLFSection;
  end;
end;

procedure TSBForm.LoadAreas;
var
  i: Integer;
begin
  Names.Clear;
  with SkinData do
  begin
    for i := 0 to AreaList.Count - 1 do
      Names.Items.Add(TspDataSkinObject(AreaList.Items[i]).IDName);
    if AreaList.Count <> 0
    then
      begin
        LoadArea(0);
        Names.ItemIndex := 0;
      end
    else
      PE.DeleteProperties(True);
  end;
end;

procedure TSBForm.LoadArea;
begin
  with PE, TspDataSkinArea(SkinData.AreaList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddRectProperty('arearect', AreaRect, 'rect');
  end;
end;

procedure TSBForm.AddArea;
var
  FName: String;
begin
  FName := 'Area' + IntToStr(Names.Items.Count + 1);
  SkinData.AddSkinArea(FName, Rect(0, 0, 0, 0));
  Names.Items.Add(FName);
  Names.ItemIndex := Names.Items.Count - 1;
  LoadArea(Names.ItemIndex);
end;

procedure TSBForm.SaveArea;
begin
  with PE, TspDataSkinArea(SkinData.AreaList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    AreaRect := GetRectProperty('arearect');
    Names.Items[Index] := IDName;
  end;
end;

procedure TSBForm.AddControl;
begin
  if (Index > 1) and (AName = '') then Exit;
  if Names.Items.IndexOf(AName) <> -1 then Exit;
  with SkinData.CtrlList do
    case Index of
      0: Add(TspDataSkinMainMenuBar.Create(AName));
      1: Add(TspDataSkinButtonControl.Create(AName));
      2: Add(TspDataSkinCheckRadioControl.Create(AName));
      3: Add(TspDataSkinGaugeControl.Create(AName));
      4: Add(TspDataSkinTrackBarControl.Create(AName));
      5: Add(TspDataSkinLabelControl.Create(AName));
      6: Add(TspDataSkinFrameRegulator.Create(AName));
      7: Add(TspDataSkinFrameGauge.Create(AName));
      8: Add(TspDataSkinGridControl.Create(AName));
      9: Add(TspDataSkinTabControl.Create(AName));
      10: Add(TspDataSkinEditControl.Create(AName));
      11: Add(TspDataSkinMemoControl.Create(AName));
      12: Add(TspDataSkinScrollBarControl.Create(AName));
      13: Add(TspDataSkinListBox.Create(AName));
      14: Add(TspDataSkinComboBox.Create(AName));
      15: Add(TspDataSkinSpinEditControl.Create(AName));
      16: Add(TspDataSkinCheckListBox.Create(AName));
      17: Add(TspDataSkinStdLabelControl.Create(AName));
      18: Add(TspDataSkinBitLabelControl.Create(AName));
      19: Add(TspDataSkinAnimateControl.Create(AName));
      20: Add(TspDataSkinSwitchControl.Create(AName));
      21: Add(TspDataSkinUpDownControl.Create(AName));
      22: Add(TspDataSkinControlBar.Create(AName));
      23: Add(TspDataSkinSplitterControl.Create(AName));
      24: Add(TspDataSkinPanelControl.Create(AName));
      25: Add(TspDataSkinMenuButtonControl.Create(AName));
      26: Add(TspDataSkinScrollBoxControl.Create(AName));
      27: Add(TspDataSkinTreeView.Create(AName));
      28: Add(TspDataSkinListView.Create(AName));
      29: Add(TspDataSkinRichEdit.Create(AName));
      30: Add(TspDataSkinExPanelControl.Create(AName));
      31: Add(TspDataSkinSlider.Create(AName));
      32: Add(TspDataSkinBevel.Create(AName));
    end;
  Names.Items.Add(AName);
  Names.ItemIndex := Names.Items.Count - 1;
  LoadControl(Names.ItemIndex);
end;

procedure TSBForm.AddObject;
begin
  if (Index > 1) and (AName = '') then Exit;
  if Names.Items.IndexOf(AName) <> -1 then Exit;
  with SkinData.ObjectList do
    case Index of
      0: Add(TspDataSkinMainMenuBarItem.Create(AName));
      1: begin
           AName := 'MAINMENUITEM';
           Add(TspDataSkinMainMenuItem.Create(AName));
         end;
      2: begin
           AName := 'MENUITEM';
           Add(TspDataSkinMenuItem.Create(AName));
         end;
      3: Add(TspDataSkinStdButton.Create(AName));
      4: Add(TspDataSkinButton.Create(AName));
      5: Add(TspDataSkinCaption.Create(AName));
      6: Add(TspDataSkinSwitch.Create(AName));
      7: Add(TspDataSkinTrackBar.Create(AName));
      8: Add(TspDataSkinLabel.Create(AName));
      9: Add(TspDataSkinAnimate.Create(AName));
      10: Add(TspDataSkinGauge.Create(AName));
      11: Add(TspDataSkinBitLabel.Create(AName));
      12: Add(TspDataSkinFrameRegulatorObject.Create(AName));
      13: Add(TspDataSkinFrameGaugeObject.Create(AName));
      14: Add(TspDataSkinMainMenuBarButton.Create(AName));
    end;
  Names.Items.Add(AName);
  Names.ItemIndex := Names.Items.Count - 1;
  LoadObject(Names.ItemIndex);
end;

procedure TSBForm.StrsDialog1;
var
  Obj: TspDataSkinBitLabel;
begin
  Obj := TspDataSkinBitLabel(SkinData.ObjectList.Items[Names.ItemIndex]);
  StrsForm.Execute(Obj.Symbols);
end;

procedure TSBForm.StrsDialog2;
var
  Obj: TspDataSkinBitLabelControl;
begin
  Obj := TspDataSkinBitLabelControl(SkinData.CtrlList.Items[Names.ItemIndex]);
  StrsForm.Execute(Obj.Symbols);
end;

procedure TSBForm.LoadBitLabel(Index: Integer);
begin
  with PE, TspDataSkinBitLabel(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddBolProperty('rollup', RollUp, 'boolean');
    AddProperty('name', IDName, 'string');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddIntProperty('symbolwidth', SymbolWidth, 'int');
    AddIntProperty('symbolheight', SymbolHeight, 'int');
    AddProperty('symbols', '', 'blstrs');
    AddProperty('textvalue', TextValue, 'string');
    AddBolProperty('transparent', Transparent, 'boolean');
    AddIntProperty('transparentcolor', TransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< bitlabel >'
end;

procedure TSBForm.SaveBitLabel(Index: Integer);
begin
  with PE, TspDataSkinBitLabel(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    SymbolWidth := GetIntProperty('symbolwidth');
    SymbolHeight := GetIntProperty('symbolheight');
    TextValue := GetStrProperty('textvalue');
    Transparent := GetBolProperty('transparent');
    TransparentColor := GetIntProperty('transparentcolor');
    Names.Items[Index] := IDName;
  end;
end;

procedure TSBForm.LoadFrameGauge(Index: Integer);
begin
  with PE, TspDataSkinFrameGaugeObject(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddIntProperty('minvalue', MinValue, 'int');
    AddIntProperty('maxvalue', MaxValue, 'int');
    AddIntProperty('countframes', CountFrames, 'int');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
  end;
  PE.Cells[0, 0] := '< framegauge >';
end;

procedure TSBForm.SaveFrameGauge(Index: Integer);
begin
  with PE, TspDataSkinFrameGaugeObject(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    MinValue := GetIntProperty('minvalue');
    MaxValue := GetIntProperty('maxvalue');
    CountFrames := GetIntProperty('countframes');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
  end;
end;

procedure TSBForm.LoadFrameRegulator(Index: Integer);
begin
  with PE, TspDataSkinFrameRegulatorObject(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddIntProperty('minvalue', MinValue, 'int');
    AddIntProperty('maxvalue', MaxValue, 'int');
    AddIntProperty('countframes', CountFrames, 'int');
    AddProperty('kind', SetFrameRegulatorKind(Kind), 'regulatorkind');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
  end;
  PE.Cells[0, 0] := '< frameregulator >';
end;

procedure TSBForm.SaveFrameRegulator(Index: Integer);
begin
  with PE, TspDataSkinFrameRegulatorObject(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    MinValue := GetIntProperty('minvalue');
    MaxValue := GetIntProperty('maxvalue');
    CountFrames := GetIntProperty('countframes');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
    Kind := GetFrameRegulatorKind(GetPropertyValue('kind'));
  end;
end;

procedure TSBForm.LoadGauge(Index: Integer);
begin
  with PE, TspDataSkinGauge(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddIntProperty('minvalue', MinValue, 'int');
    AddIntProperty('maxvalue', MaxValue, 'int');
    AddProperty('kind', SetGaugeKind(Kind), 'gaugekind');
  end;
  PE.Cells[0, 0] := '< gauge >'
end;

procedure TSBForm.SaveGauge(Index: Integer);
begin
  with PE, TspDataSkinGauge(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    MinValue := GetIntProperty('minvalue');
    MaxValue := GetIntProperty('maxvalue');
    Kind := GetGaugeKind(GetPropertyValue('kind'));
    Names.Items[Index] := IDName;
  end;  
end;

procedure TSBForm.LoadAnimate(Index: Integer);
begin
  with PE, TspDataSkinAnimate(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddProperty('restorehint', RestoreHint, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddBolProperty('skinrectinapicture', SkinRectInApicture, 'boolean');
    AddRectProperty('skinrect', SkinRect, 'stdrect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddRectProperty('inactiveskinrect', InActiveSkinRect, 'arect');
    AddRectProperty('downskinrect', DownSkinRect, 'arect');
    AddIntProperty('countframes', CountFrames, 'int');
    AddBolProperty('buttonstyle', ButtonStyle, 'boolean');
    AddBolProperty('cycle', Cycle, 'boolean');
    AddIntProperty('timerinterval', TimerInterval, 'int');
    AddProperty('command', SetStdCommand(Command), 'stdcommand');
    AddRectProperty('restorerect', RestoreRect, 'arect');
    AddRectProperty('restoreactiverect', RestoreActiveRect, 'arect');
    AddRectProperty('restoredownrect', RestoreDownRect, 'arect');
    AddRectProperty('restoreinactiverect', RestoreInActiveRect, 'arect');
    //
    AddIntProperty('glowlayerpictureindex', GlowLayerPictureIndex, 'pindex');
    AddIntProperty('glowlayermaskpictureindex', GlowLayerMaskPictureIndex, 'pindex');
    AddIntProperty('glowlayeroffsetx', GlowLayerOffsetX, 'int');
    AddIntProperty('glowlayeroffsety', GlowLayerOffsetY, 'int');
    AddIntProperty('glowlayeralphablendvalue', GlowLayerAlphaBlendValue, 'int');
    //
  end;
  PE.Cells[0, 0] := '< animate >'
end;

procedure TSBForm.SaveAnimate(Index: Integer);
begin
  with PE, TspDataSkinAnimate(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    Hint := GetStrProperty('hint');
    RestoreHint :=  GetStrProperty('restorehint');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRectInApicture := GetBolProperty('skinrectinapicture');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    InActiveSkinRect := GetRectProperty('inactiveskinrect');
    CountFrames := GetIntProperty('countframes');
    ButtonStyle := GetBolProperty('buttonstyle');
    Cycle := GetBolProperty('cycle');
    TimerInterval := GetIntProperty('timerinterval');
    Command := GetStdCommand(GetPropertyValue('command'));
    Names.Items[Index] := IDName;
    RestoreRect := GetRectProperty('restorerect');
    RestoreActiveRect := GetRectProperty('restoreactiverect');
    RestoreDownRect := GetRectProperty('restoredownrect');
    RestoreInActiveRect := GetRectProperty('restoreinactiverect');
    //
    GlowLayerPictureIndex := GetIntProperty('glowlayerpictureindex');
    GlowLayerMaskPictureIndex := GetIntProperty('glowlayermaskpictureindex');
    GlowLayerOffsetX := GetIntProperty('glowlayeroffsetx');
    GlowLayerOffsetY := GetIntProperty('glowlayeroffsety');
    GlowLayerAlphaBlendValue := GetIntProperty('glowlayeralphablendvalue');
    //
  end;
  PE.Cells[0, 0] := '< animate >'
end;

procedure TSBForm.LoadLabel(Index: Integer);
begin
  DefLoadObject(Index);
  with PE, TspDataSkinLabel(SkinData.ObjectList.Items[Index]) do
  begin
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddAlignmentProperty('alignment', Alignment, 'alignment');
    AddProperty('textvalue', TextValue, 'string');
  end;
  PE.Cells[0, 0] := '< label >';
end;

procedure TSBForm.SaveLabel(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TspDataSkinLabel(SkinData.ObjectList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    Alignment := GetAlignmentProperty('alignment');
    TextValue := GetStrProperty('textvalue');
  end;
end;

procedure TSBForm.LoadTrackBar(Index: Integer);
begin
  with PE, TspDataSkinTrackBar(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddRectProperty('buttonrect', ButtonRect, 'arect');
    AddRectProperty('activebuttonrect', ActiveButtonRect, 'arect');
    AddPointProperty('beginpoint', BeginPoint, 'apoint12');
    AddPointProperty('endpoint', EndPoint, 'apoint12');
    AddIntProperty('minvalue', MinValue, 'int');
    AddIntProperty('maxvalue', MaxValue, 'int');
    AddBolProperty('mousedownchangevalue', MouseDownChangeValue, 'boolean');
    AddBolProperty('buttontransparent', ButtonTransparent, 'boolean');
    AddIntProperty('buttontransparentcolor', ButtonTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< trackbar >'
end;

procedure TSBForm.SaveTrackBar(Index: Integer);
begin
  with PE, TspDataSkinTrackBar(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    CursorIndex := GetIntProperty('cursorindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    ButtonRect := GetRectProperty('buttonrect');
    ActiveButtonRect := GetRectProperty('activebuttonrect');
    BeginPoint := GetPointProperty('beginpoint');
    EndPoint := GetPointProperty('endpoint');
    MinValue := GetIntProperty('minvalue');
    MaxValue := GetIntProperty('maxvalue');
    MouseDownChangeValue := GetBolProperty('mousedownchangevalue');
    Names.Items[Index] := IDName;
    ButtonTransparent := GetBolProperty('buttontransparent');
    ButtonTransparentColor := GetIntProperty('buttontransparentcolor');
  end;
end;

procedure TSBForm.LoadCaption(Index: Integer);
begin
  DefLoadObject(Index);
  with PE, TspDataSkinCaption(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('textrect', TextRct, 'arect12');
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddAlignmentProperty('alignment', Alignment, 'alignment');
    AddBolProperty('defaultcaption', DefaultCaption, 'boolean');
    AddBolProperty('shadow', Shadow, 'boolean');
    AddIntProperty('shadowcolor', ShadowColor, 'skincolor');
    AddIntProperty('activeshadowcolor', ActiveShadowColor, 'skincolor');
    AddBolProperty('light', Light, 'boolean');
    AddIntProperty('lightcolor', LightColor, 'skincolor');
    AddIntProperty('activelightcolor', ActiveLightColor, 'skincolor');
    AddRectProperty('framerect', FrameRect, 'arect');
    AddRectProperty('activeframerect', ActiveFrameRect, 'arect');
    AddRectProperty('frametextrect', FrameTextRect, 'frametextrect');
    AddIntProperty('frameleftoffset', FrameLeftOffset, 'int');
    AddIntProperty('framerightoffset', FrameRightOffset, 'int');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddRectProperty('animateskinrect', AnimateSkinRect, 'arect');
    AddIntProperty('framecount', FrameCount, 'int');
    AddIntProperty('animateinterval', AnimateInterval, 'int');
    AddBolProperty('fullframe', FullFrame, 'boolean');
    AddBolProperty('inactiveanimation', InActiveAnimation, 'boolean');
    //
    AddBolProperty('vistagloweffect', VistaGlowEffect, 'boolean');
    AddBolProperty('vistaglowinactiveeffect', VistaGlowInActiveEffect, 'boolean');
    AddBolProperty('gloweffect', GlowEffect, 'boolean');
    AddBolProperty('glowinactiveeffect', GlowInActiveEffect, 'boolean');
    AddIntProperty('glowsize', GlowSize, 'int');
    AddIntProperty('glowoffset', GlowOffset, 'int');
    AddIntProperty('glowcolor', GlowColor, 'skincolor');
    AddIntProperty('glowactivecolor', GlowActiveColor, 'skincolor');
    //
    AddBolProperty('reflectioneffect', ReflectionEffect, 'boolean');
    AddIntProperty('reflectionoffset', ReflectionOffset, 'int');
    AddIntProperty('reflectioncolor', ReflectionColor, 'skincolor');
    AddIntProperty('reflectionactivecolor', ReflectionActiveColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< caption >';
end;

procedure TSBForm.SaveCaption(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TspDataSkinCaption(SkinData.ObjectList.Items[Index]) do
  begin
    TextRct := GetRectProperty('textrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    Alignment := GetAlignmentProperty('alignment');
    DefaultCaption := GetBolProperty('defaultcaption');
    Shadow := GetBolProperty('shadow');
    ShadowColor := GetIntProperty('shadowcolor');
    Light := GetBolProperty('light');
    LightColor := GetIntProperty('lightcolor');
    ActiveLightColor := GetIntProperty('activelightcolor');
    ActiveShadowColor := GetIntProperty('activeshadowcolor');
    FrameRect := GetRectProperty('framerect');
    ActiveFrameRect := GetRectProperty('activeframerect');
    FrameTextRect := GetRectProperty('frametextrect');
    FrameLeftOffset := GetIntProperty('frameleftoffset');
    FrameRightOffset := GetIntProperty('framerightoffset');
    StretchEffect := GetBolProperty('stretcheffect');
    AnimateSkinRect := GetRectProperty('animateskinrect');
    FrameCount :=  GetIntProperty('framecount');
    AnimateInterval := GetIntProperty('animateinterval');
    FullFrame := GetBolProperty('fullframe');
    InActiveAnimation := GetBolProperty('inactiveanimation');
    //
    VistaGlowEffect := GetBolProperty('vistagloweffect');
    VistaGlowInActiveEffect := GetBolProperty('vistaglowinactiveeffect');
    GlowEffect := GetBolProperty('gloweffect');
    GlowInActiveEffect := GetBolProperty('glowinactiveeffect');
    GlowSize := GetIntProperty('glowsize');
    GlowOffset := GetIntProperty('glowoffset');
    GlowColor := GetIntProperty('glowcolor');
    GlowActiveColor := GetIntProperty('glowactivecolor');
    //
    ReflectionEffect := GetBolProperty('reflectioneffect');
    ReflectionOffset := GetIntProperty('reflectionoffset');
    ReflectionColor := GetIntProperty('reflectioncolor');
    ReflectionActiveColor := GetIntProperty('reflectionactivecolor');
  end;
end;

procedure TSBForm.LoadButton(Index: Integer);
begin
  DefLoadObject(Index);
  with PE, TspDataSkinButton(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('downrect', DownRect, 'arect');
    AddRectProperty('disableskinrect', DisableSkinRect, 'arect');
    AddIntProperty('groupindex', GroupIndex, 'int');
  end;
  PE.Cells[0, 0] := '< button >';
end;

procedure TSBForm.SaveButton(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TspDataSkinButton(SkinData.ObjectList.Items[Index]) do
  begin
    DownRect := GetRectProperty('downrect');
    DisableSkinRect := GetRectProperty('disableskinrect');
    GroupIndex := GetIntProperty('groupindex');
  end;
end;

procedure TSBForm.LoadStdButton(Index: Integer);
begin
  with PE, TspDataSkinStdButton(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddProperty('restorehint', RestoreHint, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddBolProperty('skinrectinapicture', SkinRectInApicture, 'boolean');
    AddRectProperty('skinrect', SkinRect, 'stdrect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddRectProperty('inactiveskinrect', InActiveSkinRect, 'arect');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
    //
    AddRectProperty('downrect', DownRect, 'arect');
    AddRectProperty('disableskinrect', DisableSkinRect, 'arect');
    AddRectProperty('restorerect', RestoreRect, 'arect');
    AddRectProperty('restoreactiverect', RestoreActiveRect, 'arect');
    AddRectProperty('restoredownrect', RestoreDownRect, 'arect');
    AddRectProperty('restoreinactiverect', RestoreInActiveRect, 'arect');
    AddProperty('command', SetStdCommand(Command), 'stdcommand');
    //
    AddIntProperty('glowlayerpictureindex', GlowLayerPictureIndex, 'pindex');
    AddIntProperty('glowlayermaskpictureindex', GlowLayerMaskPictureIndex, 'pindex');
    AddIntProperty('glowlayeroffsetx', GlowLayerOffsetX, 'int');
    AddIntProperty('glowlayeroffsety', GlowLayerOffsetY, 'int');
    AddIntProperty('glowlayeralphablendvalue', GlowLayerAlphaBlendValue, 'int');
  end;
  PE.Cells[0, 0] := '< stdbutton >';
end;

procedure TSBForm.LoadMainMenuBarButton(Index: Integer);
var
  P: TspProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  P.PropertyType := 'arect';
  with PE, TspDataSkinStdButton(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('downrect', DownRect, 'arect');
    AddRectProperty('restorerect', RestoreRect, 'arect');
    AddRectProperty('restoreactiverect', RestoreActiveRect, 'arect');
    AddRectProperty('restoredownrect', RestoreDownRect, 'arect');
    AddProperty('command', SetStdCommand(Command), 'stdcommand');
  end;
  PE.Cells[0, 0] := '< mainmenubarbutton >';
end;

procedure TSBForm.SaveStdButton(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TspDataSkinStdButton(SkinData.ObjectList.Items[Index]) do
  begin
    RestoreHint :=  GetStrProperty('restorehint');
    SkinRectInApicture := GetBolProperty('skinrectinapicture');
    Command := GetStdCommand(GetStrProperty('command'));
    DownRect := GetRectProperty('downrect');
    DisableSkinRect := GetRectProperty('disableskinrect');
    RestoreRect := GetRectProperty('restorerect');
    RestoreActiveRect := GetRectProperty('restoreactiverect');
    RestoreDownRect := GetRectProperty('restoredownrect');
    RestoreInActiveRect := GetRectProperty('restoreinactiverect');
  end;
end;

procedure TSBForm.SaveMainMenuBarButton(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TspDataSkinMainMenuBarButton(SkinData.ObjectList.Items[Index]) do
  begin
    Command := GetStdCommand(GetStrProperty('command'));
    DownRect := GetRectProperty('downrect');
    RestoreRect := GetRectProperty('restorerect');
    RestoreActiveRect := GetRectProperty('restoreactiverect');
    RestoreDownRect := GetRectProperty('restoredownrect');
  end;
end;

procedure TSBForm.DefLoadObject(Index: Integer);
begin
  with PE, TspDataSkinObject(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddBolProperty('rollup', RollUp, 'boolean');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddRectProperty('skinrect', SkinRect, 'rect');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'arect');
    AddRectProperty('inactiveskinrect', InActiveSkinRect, 'arect');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
    //
    AddIntProperty('glowlayerpictureindex', GlowLayerPictureIndex, 'pindex');
    AddIntProperty('glowlayermaskpictureindex', GlowLayerMaskPictureIndex, 'pindex');
    AddIntProperty('glowlayeroffsetx', GlowLayerOffsetX, 'int');
    AddIntProperty('glowlayeroffsety', GlowLayerOffsetY, 'int');
    AddIntProperty('glowlayeralphablendvalue', GlowLayerAlphaBlendValue, 'int');
    //
  end;
end;

procedure TSBForm.DefSaveObject(Index: Integer);
begin
  with PE, TspDataSkinObject(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    Hint := GetStrProperty('hint');
    RollUp := GetBolProperty('rollup');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    CursorIndex := GetIntProperty('cursorindex');
    SkinRect := GetRectProperty('skinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    InActiveSkinRect := GetRectProperty('inactiveskinrect');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
    //
    GlowLayerPictureIndex := GetIntProperty('glowlayerpictureindex');
    GlowLayerMaskPictureIndex := GetIntProperty('glowlayermaskpictureindex');
    GlowLayerOffsetX := GetIntProperty('glowlayeroffsetx');
    GlowLayerOffsetY := GetIntProperty('glowlayeroffsety');
    GlowLayerAlphaBlendValue := GetIntProperty('glowlayeralphablendvalue');
    //
    Names.Items[Index] := IDName;
  end;
end;

procedure TSBForm.LoadMenuItem(Index: Integer);
var
  P: TspProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  if P <> nil then P.PropertyType := 'arect';
  P := PE.GetProperty('name');
  if P <> nil then P.PropertyType := 'fixedstring';
  P := PE.GetProperty('cursorindex');
  if P <> nil then P.PropertyType := 'fixed';
  with PE, TspDataSkinMenuItem(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('dividerrect', DividerRect, 'arect');
    AddIntProperty('itemleftoffset', ItemLO, 'int');
    AddIntProperty('itemrightoffset', ItemRO, 'int');
    AddIntProperty('dividerleftoffset', DividerLO, 'int');
    AddIntProperty('dividerrightoffset', DividerRO, 'int');
    AddRectProperty('textrect', TextRct, 'arect1');
    AddRectProperty('imagerect', ImageRct, 'arect1');
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('unenabledfontcolor', UnEnabledFontColor, 'skincolor');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddBolProperty('inactivestretcheffect', InActiveStretchEffect, 'boolean');
    AddBolProperty('dividerstretcheffect', DividerStretchEffect, 'boolean');
    AddRectProperty('animateskinrect', AnimateSkinRect, 'arect');
    AddIntProperty('framecount', FrameCount, 'int');
    AddIntProperty('animateinterval', AnimateInterval, 'int');
    AddBolProperty('useimagecolor', UseImageColor, 'boolean');
    AddIntProperty('imagecolor', ImageColor, 'skincolor');
    AddIntProperty('activeimagecolor', ActiveImageColor, 'skincolor');
    AddBolProperty('inactivetransparent', InActiveTransparent, 'boolean');
    //
    AddRectProperty('checkimagerect', CheckImageRect, 'arect');
    AddRectProperty('activecheckimagerect', ActiveCheckImageRect, 'arect');
    AddRectProperty('radioimagerect', RadioImageRect, 'arect');
    AddRectProperty('activeradioimagerect', ActiveRadioImageRect, 'arect');
    AddRectProperty('arrowimagerect', ArrowImageRect, 'arect');
    AddRectProperty('activearrowimagerect', ActiveArrowImageRect, 'arect');
  end;
  PE.Cells[0, 0] := '< menuitem >';
end;

procedure TSBForm.SaveMenuItem(Index: Integer);
begin
  TspDataSkinMenuItem(SkinData.ObjectList.Items[Index]).RollUp := False;
  DefSaveObject(Index);
  with PE, TspDataSkinMenuItem(SkinData.ObjectList.Items[Index]) do
  begin
    DividerRect := GetRectProperty('dividerrect');
    ItemLO := GetIntProperty('itemleftoffset');
    ItemRO := GetIntProperty('itemrightoffset');
    DividerLO := GetIntProperty('dividerleftoffset');
    DividerRO := GetIntProperty('dividerrightoffset');
    TextRct := GetRectProperty('textrect');
    ImageRct := GetRectProperty('imagerect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    UnEnabledFontColor := GetIntProperty('unenabledfontcolor');
    StretchEffect := GetBolProperty('stretcheffect');
    InActiveStretchEffect := GetBolProperty('inactivestretcheffect');
    DividerStretchEffect := GetBolProperty('dividerstretcheffect');
    AnimateSkinRect := GetRectProperty('animateskinrect');
    FrameCount :=  GetIntProperty('framecount');
    AnimateInterval := GetIntProperty('animateinterval');
    UseImageColor := GetBolProperty('useimagecolor');
    ImageColor := GetIntProperty('imagecolor');
    ActiveImageColor := GetIntProperty('activeimagecolor');
    InActiveTransparent := GetBolProperty('inactivetransparent');
    //
    CheckImageRect := GetRectProperty('checkimagerect');
    ActiveCheckImageRect := GetRectProperty('activecheckimagerect');
    RadioImageRect := GetRectProperty('radioimagerect');
    ActiveRadioImageRect := GetRectProperty('activeradioimagerect');
    ArrowImageRect := GetRectProperty('arrowimagerect');
    ActiveArrowImageRect := GetRectProperty('activearrowimagerect');
  end;
end;

procedure TSBForm.LoadMainMenuBarItem(Index: Integer);
var
  P: TspProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  if P <> nil then P.PropertyType := 'arect';
  with PE, TspDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('downrect', DownRect, 'arect');
    AddIntProperty('itemleftoffset', ItemLO, 'int');
    AddIntProperty('itemrightoffset', ItemRO, 'int');
    AddRectProperty('textrect', TextRct, 'arect1');
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('downfontcolor', DownFontColor, 'skincolor');
    AddIntProperty('unenabledfontcolor', UnEnabledFontColor, 'skincolor');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddRectProperty('animateskinrect', AnimateSkinRect, 'arect');
    AddIntProperty('framecount', FrameCount, 'int');
    AddIntProperty('animateinterval', AnimateInterval, 'int');
  end;
  PE.Cells[0, 0] := '< mainmenubaritem >';
end;

procedure TSBForm.LoadMainMenuItem(Index: Integer);
var
  P: TspProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  if P <> nil then P.PropertyType := 'arect';
  P := PE.GetProperty('name');
  if P <> nil then P.PropertyType := 'fixedstring';
  with PE, TspDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('downrect', DownRect, 'arect');
    AddIntProperty('itemleftoffset', ItemLO, 'int');
    AddIntProperty('itemrightoffset', ItemRO, 'int');
    AddRectProperty('textrect', TextRct, 'arect1');
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('downfontcolor', DownFontColor, 'skincolor');
    AddIntProperty('unenabledfontcolor', UnEnabledFontColor, 'skincolor');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
  end;
  PE.Cells[0, 0] := '< mainmenuitem >';
end;            

procedure TSBForm.SaveMainMenuItem(Index: Integer);
begin
  TspDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]).RollUp := False;
  DefSaveObject(Index);
  with PE, TspDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
  begin
    DownRect := GetRectProperty('downrect');
    ItemLO := GetIntProperty('itemleftoffset');
    ItemRO := GetIntProperty('itemrightoffset');
    TextRct := GetRectProperty('textrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DownFontColor := GetIntProperty('downfontcolor');
    UnEnabledFontColor := GetIntProperty('unenabledfontcolor');
    StretchEffect := GetBolProperty('stretcheffect');
    AnimateSkinRect := GetRectProperty('animateskinrect');
    FrameCount :=  GetIntProperty('framecount');
    AnimateInterval := GetIntProperty('animateinterval');
  end;
end;

procedure TSBForm.SaveMainMenuBarItem(Index: Integer);
begin
  SaveMainMenuItem(Index);
end;

procedure TSBForm.LoadControl;
begin
  DefLoadControl(Index);
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinPanelControl
  then
    LoadPanelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinExPanelControl
  then
    LoadExPanelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMenuButtonControl
  then
    LoadMenuButtonControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinButtonControl
  then
    LoadButtonControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinCheckRadioControl
  then
    LoadCheckRadioControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinGaugeControl
  then
    LoadGaugeControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
    TspDataSkinSplitterControl
  then
    LoadSplitterControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTrackBarControl
  then
    LoadTrackBarControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinLabelControl
  then
    LoadLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinBitLabelControl
  then
    LoadBitLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinStdLabelControl
  then
    LoadStdLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinFrameRegulator
  then
    LoadRegulatorControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinFrameGauge
  then
    LoadFGaugeControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinAnimateControl
  then
    LoadAnimateControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinUpDownControl
  then
    LoadUpDownControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSwitchControl
  then
    LoadSwitchControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinGridControl
  then
    LoadGridControl(Index)
 else
 if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTabControl
  then
    LoadTabControl(Index)
 else
 if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
    TspDataSkinSlider
 then
   LoadSliderControl(Index)
 else
 if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinControlBar
  then
    LoadControlBar(Index)
 else
 if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMainMenuBar
  then
    LoadMainMenuBar(Index)
 else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinCheckListBox
  then
    LoadCheckListBoxControl(Index)
 else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinListBox
  then
    LoadListBoxControl(Index)
  else  
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinComboBox
  then
    LoadComboBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMemoControl
  then
    LoadMemoControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinEditControl
  then
    LoadEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinScrollBarControl
  then
    LoadScrollBarControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSpinEditControl
  then
    LoadSpinEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinScrollBoxControl
  then
    LoadScrollBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTreeView
  then
    LoadTreeViewControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinListView
  then
    LoadListViewControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinRichEdit
  then
    LoadRichEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinBevel
  then
    LoadBevelControl(Index);
end;

procedure TSBForm.DefLoadControl;
begin
  with PE, TspDataSkinControl(SkinData.CtrlList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddIntProperty('pictureindex', PictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddRectProperty('skinrect', SkinRect, 'rectctrl1');
  end;
end;

procedure TSBForm.DefLoadResizeControl(Index: Integer);
begin
  with PE, TspDataSkinCustomControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddPointProperty('lefttoppoint', LTPoint, 'pointctrl2');
    AddPointProperty('righttoppoint', RTPoint, 'pointctrl2');
    AddPointProperty('leftbottompoint', LBPoint, 'pointctrl2');
    AddPointProperty('rightbottompoint', RBPoint, 'pointctrl2');
    AddRectProperty('clientrect', ClRect, 'rectctrl2');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
  end;
end;

procedure TSBForm.LoadSplitterControl(Index: Integer);
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinSplitterControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('clientrect');
    P.PropertyType := 'fixed';
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('cursorindex');
    P.PropertyType := 'fixed';
    AddRectProperty('gripperrect', GripperRect, 'rectctrl1');
    AddBolProperty('grippertransparent', GripperTransparent, 'boolean');
    AddIntProperty('grippertransparentcolor', GripperTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< splitter >';  
end;

procedure TSBForm.LoadGaugeControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinGaugeControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('progressarea', ProgressArea, 'rectctrl2');
    AddRectProperty('progressrect', ProgressRect, 'rectctrl1');
    AddIntProperty('beginoffset', BeginOffset, 'int');
    AddIntProperty('endoffset', EndOffset, 'int');
    AddBolProperty('vertical', Vertical, 'boolean');

    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddBolProperty('progresstransparent', ProgressTransparent, 'boolean');
    AddIntProperty('progresstransparentcolor', ProgressTransparentColor, 'skincolor');
    AddBolProperty('progressstretch', ProgressStretch, 'boolean');

    AddRectProperty('animationskinrect', AnimationSkinRect, 'rectctrl1');
    AddIntProperty('animationcountframes', AnimationCountFrames, 'int');
    AddIntProperty('animationtimerinterval', AnimationTimerInterval, 'int');
    AddIntProperty('animationbeginoffset', AnimationBeginOffset, 'int');
    AddIntProperty('animationendoffset', AnimationEndOffset, 'int');

    AddRectProperty('progressanimationskinrect', ProgressAnimationSkinRect, 'rectctrl1');
    AddIntProperty('progressanimationcountframes', ProgressAnimationCountFrames, 'int');
    AddIntProperty('progressanimationtimerinterval', ProgressAnimationTimerInterval, 'int');
  end;
  PE.Cells[0, 0] := '< gauge >';
end;

procedure TSBForm.LoadFGaugeControl;
begin
  with PE, TspDataSkinFrameGauge(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('framescount', FramesCount, 'int');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
  end;
  PE.Cells[0, 0] := '< framegauge >';
end;


procedure TSBForm.LoadUpDownControl;
begin
  with PE, TspDataSkinUpDownControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('upbuttonrect', UpButtonRect, 'rectctrl2');
    AddRectProperty('activeupbuttonrect', ActiveUpButtonRect, 'rectctrl1');
    AddRectProperty('downupbuttonrect', DownUpButtonRect, 'rectctrl1');
    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl2');
    AddRectProperty('activedownbuttonrect', ActiveDownButtonRect, 'rectctrl1');
    AddRectProperty('downdownbuttonrect', DownDownButtonRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< updown >';
end;

procedure TSBForm.LoadAnimateControl;
begin
  with PE, TspDataSkinAnimateControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('framescount', FramesCount, 'int');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
  end;
  PE.Cells[0, 0] := '< animate >';
end;

procedure TSBForm.LoadSwitchControl;
begin
  with PE, TspDataSkinSwitchControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('framescount', FramesCount, 'int');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
  end;
  PE.Cells[0, 0] := '< switch >';
end;

procedure TSBForm.LoadComboBoxControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinComboBox(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('itemrect', SItemRect, 'rectctrl1');
    AddRectProperty('activeitemrect', ActiveItemRect, 'rectctrl1');
    AddRectProperty('focusitemrect', FocusItemRect, 'rectctrl1');
    AddIntProperty('itemleftoffset', ItemLeftOffset, 'int');
    AddIntProperty('itemrightoffset', ItemRightOffset, 'int');
    AddRectProperty('itemtextrect', ItemTextRect, 'itemrect');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('focusfontcolor', FocusFontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    //
    AddRectProperty('buttonrect', ButtonRect, 'rectctrl2');
    AddRectProperty('activebuttonrect', ActiveButtonRect, 'rectctrl1');
    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl1');
    AddRectProperty('unenabledbuttonrect', UnEnabledButtonRect, 'rectctrl1');
    //
    AddBolProperty('itemstretcheffect', ItemStretchEffect, 'boolean');
    AddBolProperty('focusitemstretcheffect', FocusItemStretchEffect, 'boolean');
    //
    AddProperty('listboxname', ListBoxName, 'string');
    AddBolProperty('showfocus', ShowFocus, 'boolean');
  end;
  PE.Cells[0, 0] := '< combobox >';
end;

procedure TSBForm.LoadCheckListBoxControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinCheckListBox(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('itemrect', SItemRect, 'rectctrl1');
    AddRectProperty('activeitemrect', ActiveItemRect, 'rectctrl1');
    AddRectProperty('focusitemrect', FocusItemRect, 'rectctrl1');
    AddIntProperty('itemleftoffset', ItemLeftOffset, 'int');
    AddIntProperty('itemrightoffset', ItemRightOffset, 'int');
    AddRectProperty('itemtextrect', ItemTextRect, 'itemrect');
    AddRectProperty('itemcheckrect', ItemCheckRect, 'itemrect');

    AddRectProperty('checkimagerect', CheckImageRect, 'rectctrl1');
    AddRectProperty('uncheckimagerect', UnCheckImageRect, 'rectctrl1');

    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('focusfontcolor', FocusFontColor, 'skincolor');
    //
    AddRectProperty('captionrect', CaptionRect, 'rectctrl2');
    AddProperty('captionfontname', CaptionFontName, 'string');
    AddIntProperty('captionfontheight', CaptionFontHeight, 'int');
    AddFSProperty('captionfontstyle', CaptionFontStyle, 'fontstyle');
    AddIntProperty('captionfontcolor', CaptionFontColor, 'skincolor');
    //
    AddRectProperty('upbuttonrect', UpButtonRect, 'rectctrl2');
    AddRectProperty('activeupbuttonrect', ActiveUpButtonRect, 'rectctrl1');
    AddRectProperty('downupbuttonrect', DownUpButtonRect, 'rectctrl1');

    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl2');
    AddRectProperty('activedownbuttonrect', ActiveDownButtonRect, 'rectctrl1');
    AddRectProperty('downdownbuttonrect', DownDownButtonRect, 'rectctrl1');

    AddRectProperty('checkbuttonrect', CheckButtonRect, 'rectctrl2');
    AddRectProperty('activecheckbuttonrect', ActiveCheckButtonRect, 'rectctrl1');
    AddRectProperty('downcheckbuttonrect', DownCheckButtonRect, 'rectctrl1');
    //
    AddProperty('vscrollbarname', VScrollBarName, 'string');
    AddProperty('hscrollbarname', HScrollBarName, 'string');

    AddBolProperty('showfocus', ShowFocus, 'boolean');
    //
    AddRectProperty('buttonsarea', ButtonsArea, 'rectctrl2');
    AddRectProperty('disabledbuttonsrect', DisabledButtonsRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< checklistbox >';
end;

procedure TSBForm.SaveBevelControl(Index: Integer);
begin
  with PE, TspDataSkinBevel(SkinData.CtrlList.Items[Index]) do
  begin
    LightColor := GetIntProperty('lightcolor');
    DarkColor := GetIntProperty('darkcolor');
  end;
end;

procedure TSBForm.LoadBevelControl(Index: Integer);
var
  P: TspProperty;
begin
  with PE, TspDataSkinBevel(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    AddIntProperty('lightcolor', LightColor, 'skincolor');
    AddIntProperty('darkcolor', DarkColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< bevel >';
end;

procedure TSBForm.LoadTreeViewControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinTreeView(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< treeview >';
end;

procedure TSBForm.LoadListViewControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinListView(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< listview >';
end;

procedure TSBForm.LoadRichEditControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinRichEdit(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< richedit >';
end;

procedure TSBForm.LoadScrollBoxControl(Index: Integer);
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinScrollBoxControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
  end;
  PE.Cells[0, 0] := '< scrollbox >';
end;

procedure TSBForm.LoadListBoxControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinListBox(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('itemrect', SItemRect, 'rectctrl1');
    AddRectProperty('activeitemrect', ActiveItemRect, 'rectctrl1');
    AddRectProperty('focusitemrect', FocusItemRect, 'rectctrl1');
    AddIntProperty('itemleftoffset', ItemLeftOffset, 'int');
    AddIntProperty('itemrightoffset', ItemRightOffset, 'int');
    AddRectProperty('itemtextrect', ItemTextRect, 'itemrect');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('focusfontcolor', FocusFontColor, 'skincolor');
    //
    AddRectProperty('captionrect', CaptionRect, 'rectctrl2');
    AddProperty('captionfontname', CaptionFontName, 'string');
    AddIntProperty('captionfontheight', CaptionFontHeight, 'int');
    AddFSProperty('captionfontstyle', CaptionFontStyle, 'fontstyle');
    AddIntProperty('captionfontcolor', CaptionFontColor, 'skincolor');
    //
    AddRectProperty('upbuttonrect', UpButtonRect, 'rectctrl2');
    AddRectProperty('activeupbuttonrect', ActiveUpButtonRect, 'rectctrl1');
    AddRectProperty('downupbuttonrect', DownUpButtonRect, 'rectctrl1');

    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl2');
    AddRectProperty('activedownbuttonrect', ActiveDownButtonRect, 'rectctrl1');
    AddRectProperty('downdownbuttonrect', DownDownButtonRect, 'rectctrl1');

    AddRectProperty('checkbuttonrect', CheckButtonRect, 'rectctrl2');
    AddRectProperty('activecheckbuttonrect', ActiveCheckButtonRect, 'rectctrl1');
    AddRectProperty('downcheckbuttonrect', DownCheckButtonRect, 'rectctrl1');
    //
    AddProperty('hscrollbarname', HScrollBarName, 'string');
    AddProperty('vscrollbarname', VScrollBarName, 'string');

    AddBolProperty('showfocus', ShowFocus, 'boolean');
    //
    AddRectProperty('buttonsarea', ButtonsArea, 'rectctrl2');
    AddRectProperty('disabledbuttonsrect', DisabledButtonsRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< listbox >';
end;

procedure TSBForm.LoadMainMenuBar(Index: Integer);
begin
  with PE, TspDataSkinMainMenuBar(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('itemsrect', ItemsRect, 'rectctrl2');
    AddProperty('menubaritem', MenuBarItem, 'string');
    AddProperty('closebutton', CloseButton, 'string');
    AddProperty('maxbutton', MaxButton, 'string');
    AddProperty('minbutton', MinButton, 'string');
    AddProperty('sysmenubutton', SysMenuButton, 'string');
    AddIntProperty('trackmarkcolor', TrackMarkColor, 'skincolor');
    AddIntProperty('trackmarkactivecolor', TrackMarkActiveColor, 'skincolor');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddBolProperty('itemtransparent', ItemTransparent, 'boolean');
  end;
  PE.Cells[0, 0] := '< mainmenubar >';
end;

procedure TSBForm.LoadControlBar;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinControlBar(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    AddRectProperty('itemrect', ItemRect, 'rectctrl1');
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
    AddIntProperty('gripoffset1', GripOffset1, 'int');
    AddIntProperty('gripoffset2', GripOffset2, 'int');
    AddRectProperty('hgriprect', HGripRect, 'rectctrl1');
    AddRectProperty('vgriprect', VGripRect, 'rectctrl1');
    AddIntProperty('itemoffset1', ItemOffset1, 'int');
    AddIntProperty('itemoffset2', ItemOffset2, 'int');
    AddBolProperty('itemstretcheffect', ItemStretchEffect, 'boolean');
    AddBolProperty('griptransparent', GripTransparent, 'boolean');
    AddIntProperty('griptransparentcolor', GripTransparentColor, 'skincolor');
    AddBolProperty('itemtransparent', ItemTransparent, 'boolean');
    AddIntProperty('itemtransparentcolor', ItemTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< controlbar >';
end;

procedure TSBForm.LoadSliderControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinSlider(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('skinrect');
    P.PropertyType := 'fixed';
    AddRectProperty('hrulerrect', HRulerRect, 'rectctrl1');
    AddRectProperty('hthumbrect', HThumbRect, 'rectctrl1');
    AddRectProperty('vrulerrect', VRulerRect, 'rectctrl1');
    AddRectProperty('vthumbrect', VThumbRect, 'rectctrl1');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
    AddIntProperty('edgesize', EdgeSize, 'int');
    AddIntProperty('pointscolor', PointsColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< slider >';
end;

procedure TSBForm.SaveSliderControl;
begin
  with PE, TspDataSkinSlider(SkinData.CtrlList.Items[Index]) do
  begin
    HRulerRect := GetRectProperty('hrulerrect');
    HThumbRect := GetRectProperty('hthumbrect');
    VRulerRect := GetRectProperty('vrulerrect');
    VThumbRect := GetRectProperty('vthumbrect');
    BGColor := GetIntProperty('bgcolor');
    EdgeSize :=  GetIntProperty('edgesize');
    PointsColor := GetIntProperty('pointscolor');
  end;
end;

procedure TSBForm.LoadTabControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinTabControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    AddRectProperty('tabrect', TabRect, 'rectctrl1');
    AddRectProperty('activetabrect', ActiveTabRect, 'rectctrl1');
    AddRectProperty('focustabrect', FocusTabRect, 'rectctrl1');
    AddRectProperty('mouseintabrect', MouseInTabRect, 'rectctrl1');
    AddRectProperty('clientrect', ClRect, 'rectctrl2');
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
    //
    AddPointProperty('lefttoppoint', LTPoint, 'pointctrl2');
    AddPointProperty('righttoppoint', RTPoint, 'pointctrl2');
    AddPointProperty('leftbottompoint', LBPoint, 'pointctrl2');
    AddPointProperty('rightbottompoint', RBPoint, 'pointctrl2');

    AddIntProperty('tableftoffset', TabLeftOffset, 'int');
    AddIntProperty('tabrightoffset', TabRightOffset, 'int');
    AddRectProperty('tabsbgrect', TabsBGRect, 'rectctrl1');
    AddBolProperty('tabstretcheffect', TabStretchEffect, 'boolean');

    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
    //
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('focusfontcolor', FocusFontColor, 'skincolor');
    AddIntProperty('mouseinfontcolor', MouseInFontColor, 'skincolor');
    AddProperty('updown', UpDown, 'string');
    //
    AddBolProperty('showfocus', ShowFocus, 'boolean');
    AddIntProperty('focusoffsetx', FocusOffsetX, 'int');
    AddIntProperty('focusoffsety', FocusOffsetY, 'int');
    //
    AddRectProperty('closebuttonrect', CloseButtonRect, 'rectctrl1');
    AddRectProperty('closebuttonactiverect', CloseButtonActiveRect, 'rectctrl1');
    AddRectProperty('closebuttondownrect', CloseButtonDownRect, 'rectctrl1');
    //
    AddBolProperty('buttontransparent', ButtonTransparent, 'boolean');
    AddIntProperty('buttontransparentcolor', ButtonTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< tab >';
end;

procedure TSBForm.LoadGridControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinGridControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('skinrect');
    P.PropertyType := 'fixed';
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    AddRectProperty('fixedcellrect', FixedCellRect, 'rectctrl1');
    AddRectProperty('selectcellrect', SelectCellRect, 'rectctrl1');
    AddRectProperty('focuscellrect', FocusCellRect, 'rectctrl1');
    //
    AddIntProperty('fixedcellleftoffset', FixedCellLeftOffset, 'int');
    AddIntProperty('fixedcellrightoffset', FixedCellRightOffset, 'int');
    AddRectProperty('fixedcelltextrect', FixedCellTextRect, 'fcelltextrect');
    //
    AddIntProperty('cellleftoffset', CellLeftOffset, 'int');
    AddIntProperty('cellrightoffset', CellRightOffset, 'int');
    AddRectProperty('celltextrect', CellTextRect, 'celltextrect');
    //
    AddIntProperty('linescolor', LinesColor, 'skincolor');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
    //
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
    //
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('selectfontcolor', SelectFontColor, 'skincolor');
    AddIntProperty('focusfontcolor', FocusFontColor, 'skincolor');
    //
    AddProperty('fixedfontname', FixedFontName, 'string');
    AddIntProperty('fixedfontheight', FixedFontHeight, 'int');
    AddFSProperty('fixedfontstyle', FixedFontStyle, 'fontstyle');
    AddIntProperty('fixedfontcolor', FixedFontColor, 'skincolor');
     //
    AddBolProperty('cellstretcheffect', CellStretchEffect, 'boolean');
    AddBolProperty('fixedcellstretcheffect', FixedCellStretchEffect, 'boolean');
    AddBolProperty('showfocus', ShowFocus, 'boolean');
    //
  end;
  PE.Cells[0, 0] := '< grid >';
end;

procedure TSBForm.LoadRegulatorControl;
begin
  with PE, TspDataSkinFrameRegulator(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('framescount', FramesCount, 'int');
    AddProperty('framesplacement', SetFrPl(FramesPlacement), 'frpl');
    AddProperty('kind', SetRegKind(Kind), 'regkind');
  end;
  PE.Cells[0, 0] := '< frameregulator >';
end;

procedure TSBForm.SaveFGaugeControl;
begin
  with PE, TspDataSkinFrameGauge(SkinData.CtrlList.Items[Index]) do
  begin
    FramesCount := GetIntProperty('framescount');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
  end;
end;

procedure TSBForm.SaveUpDownControl;
begin
  with PE, TspDataSkinUpDownControl(SkinData.CtrlList.Items[Index]) do
  begin
    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');
  end;
end;

procedure TSBForm.SaveAnimateControl;
begin
  with PE, TspDataSkinAnimateControl(SkinData.CtrlList.Items[Index]) do
  begin
    FramesCount := GetIntProperty('framescount');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
  end;
end;

procedure TSBForm.SaveSwitchControl;
begin
  with PE, TspDataSkinSwitchControl(SkinData.CtrlList.Items[Index]) do
  begin
    FramesCount := GetIntProperty('framescount');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
  end;
end;

procedure TSBForm.SaveComboBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinComboBox(SkinData.CtrlList.Items[Index]) do
  begin
    //
    ActiveSkinRect := GetRectProperty('activeskinrect');
    SItemRect := GetRectProperty('itemrect');
    ActiveItemRect := GetRectProperty('activeitemrect');
    FocusItemRect := GetRectProperty('focusitemrect');
    ItemLeftOffset := GetIntProperty('itemleftoffset');
    ItemRightOffset := GetIntProperty('itemrightoffset');
    ItemTextRect := GetRectProperty('itemtextrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    FocusFontColor := GetIntProperty('focusfontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    //
    ButtonRect := GetRectProperty('buttonrect');
    ActiveButtonRect := GetRectProperty('activebuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    UnEnabledButtonRect := GetRectProperty('unenabledbuttonrect');
    //
    ItemStretchEffect := GetBolProperty('itemstretcheffect');
    FocusItemStretchEffect := GetBolProperty('focusitemstretcheffect');
    //
    ListBoxName := GetStrProperty('listboxname');
    ShowFocus := GetBolProperty('showfocus');
  end;
end;

procedure TSBForm.SaveCheckListBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinCheckListBox(SkinData.CtrlList.Items[Index]) do
  begin
    SItemRect := GetRectProperty('itemrect');
    ActiveItemRect := GetRectProperty('activeitemrect');
    FocusItemRect := GetRectProperty('focusitemrect');
    ItemLeftOffset := GetIntProperty('itemleftoffset');
    ItemRightOffset := GetIntProperty('itemrightoffset');
    ItemTextRect := GetRectProperty('itemtextrect');
    ItemCheckRect := GetRectProperty('itemcheckrect');

    CheckImageRect := GetRectProperty('checkimagerect');
    UnCheckImageRect := GetRectProperty('uncheckimagerect');

    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    FocusFontColor := GetIntProperty('focusfontcolor');
    //
    CaptionRect := GetRectProperty('captionrect');
    CaptionFontName := GetStrProperty('captionfontname');
    CaptionFontHeight := GetIntProperty('captionfontheight');
    CaptionFontStyle := GetFSProperty('captionfontstyle');
    CaptionFontColor := GetIntProperty('captionfontcolor');
    //
    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');

    CheckButtonRect := GetRectProperty('checkbuttonrect');
    ActiveCheckButtonRect := GetRectProperty('activecheckbuttonrect');
    DownCheckButtonRect := GetRectProperty('downcheckbuttonrect');
    //
    VScrollBarName := GetStrProperty('vscrollbarname');
    HScrollBarName := GetStrProperty('hscrollbarname');

    ShowFocus := GetBolProperty('showfocus');
    //
    ButtonsArea := GetRectProperty('buttonsarea');
    DisabledButtonsRect := GetRectProperty('disabledbuttonsrect');
  end;
end;

procedure TSBForm.SaveScrollBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinScrollBoxControl(SkinData.CtrlList.Items[Index]) do
  begin
    BGPictureIndex := GetIntProperty('bgpictureindex');
  end;
end;

procedure TSBForm.SaveListBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinListBox(SkinData.CtrlList.Items[Index]) do
  begin
    //
    SItemRect := GetRectProperty('itemrect');
    ActiveItemRect := GetRectProperty('activeitemrect');
    FocusItemRect := GetRectProperty('focusitemrect');
    ItemLeftOffset := GetIntProperty('itemleftoffset');
    ItemRightOffset := GetIntProperty('itemrightoffset');
    ItemTextRect := GetRectProperty('itemtextrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    FocusFontColor := GetIntProperty('focusfontcolor');
    //
    CaptionRect := GetRectProperty('captionrect');
    CaptionFontName := GetStrProperty('captionfontname');
    CaptionFontHeight := GetIntProperty('captionfontheight');
    CaptionFontStyle := GetFSProperty('captionfontstyle');
    CaptionFontColor := GetIntProperty('captionfontcolor');
    //
    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');

    CheckButtonRect := GetRectProperty('checkbuttonrect');
    ActiveCheckButtonRect := GetRectProperty('activecheckbuttonrect');
    DownCheckButtonRect := GetRectProperty('downcheckbuttonrect');
    //
    VScrollBarName := GetStrProperty('vscrollbarname');
    HScrollBarName := GetStrProperty('hscrollbarname');

    ShowFocus := GetBolProperty('showfocus');
    
    ButtonsArea := GetRectProperty('buttonsarea');
    DisabledButtonsRect := GetRectProperty('disabledbuttonsrect');
  end;
end;

procedure TSBForm.SaveControlBar;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinControlBar(SkinData.CtrlList.Items[Index]) do
  begin
    ItemRect := GetRectProperty('itemrect');
    BGPictureIndex := GetIntProperty('bgpictureindex');
    GripOffset1 := GetIntProperty('gripoffset1');
    GripOffset2 := GetIntProperty('gripoffset2');
    HGripRect := GetRectProperty('hgriprect');
    VGripRect := GetRectProperty('vgriprect');
    ItemStretchEffect := GetBolProperty('itemstretcheffect');
    ItemOffset1 := GetIntProperty('itemoffset1');
    ItemOffset2 := GetIntProperty('itemoffset2');
    GripTransparent := GetBolProperty('griptransparent');
    GripTransparentColor := GetIntProperty('griptransparentcolor');
    ItemTransparent := GetBolProperty('itemtransparent');
    ItemTransparentColor := GetIntProperty('itemtransparentcolor');
  end;
end;

procedure TSBForm.SaveMainMenuBar(Index: Integer);
begin
  with PE, TspDataSkinMainMenuBar(SkinData.CtrlList.Items[Index]) do
  begin
    ItemsRect := GetRectProperty('itemsrect');
    MenuBarItem := GetStrProperty('menubaritem');
    CloseButton := GetStrProperty('closebutton');
    MaxButton := GetStrProperty('maxbutton');
    MinButton := GetStrProperty('minbutton');
    SysMenuButton := GetStrProperty('sysmenubutton');
    TrackMarkColor := GetIntProperty('trackmarkcolor');
    TrackMarkActiveColor := GetIntProperty('trackmarkactivecolor');
    StretchEffect := GetBolProperty('stretcheffect');
    ItemTransparent := GetBolProperty('itemtransparent');
  end;
end;

procedure TSBForm.SaveTabControl;
begin
  with PE, TspDataSkinTabControl(SkinData.CtrlList.Items[Index]) do
  begin
    TabRect := GetRectProperty('tabrect');
    ActiveTabRect := GetRectProperty('activetabrect');
    FocusTabRect := GetRectProperty('focustabrect');
    MouseInTabRect := GetRectProperty('mouseintabrect');
    ClRect := GetRectProperty('clientrect');
    BGPictureIndex := GetIntProperty('bgpictureindex');
    //
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');

    TabLeftOffset := GetIntProperty('tableftoffset');
    TabRightOffset := GetIntProperty('tabrightoffset');
    TabsBGRect := GetRectProperty('tabsbgrect');
    TabStretchEffect := GetBolProperty('tabstretcheffect');

    LeftStretch := GetBolProperty('leftstretch');
    TopStretch := GetBolProperty('topstretch');
    RightStretch := GetBolProperty('rightstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchEffect := GetBolProperty('stretcheffect');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
    //
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    FocusFontColor := GetIntProperty('focusfontcolor');
    MouseInFontColor := GetIntProperty('mouseinfontcolor');
    UpDown := GetStrProperty('updown');
    ShowFocus := GetBolProperty('showfocus');
    FocusOffsetX := GetIntProperty('focusoffsetx');
    FocusOffsetY := GetIntProperty('focusoffsety');
    //
    CloseButtonRect := GetRectProperty('closebuttonrect');
    CloseButtonActiveRect := GetRectProperty('closebuttonactiverect');
    CloseButtonDownRect := GetRectProperty('closebuttondownrect');
    //
    ButtonTransparent := GetBolProperty('buttontransparent');
    ButtonTransparentColor := GetIntProperty('buttontransparentcolor');
  end;
end;

procedure TSBForm.SaveGridControl;
begin
  with PE, TspDataSkinGridControl(SkinData.CtrlList.Items[Index]) do
  begin
    FixedCellRect := GetRectProperty('fixedcellrect');
    SelectCellRect := GetRectProperty('selectcellrect');
    FocusCellRect := GetRectProperty('focuscellrect');
    //
    FixedCellLeftOffset := GetIntProperty('fixedcellleftoffset');
    FixedCellRightOffset := GetIntProperty('fixedcellrightoffset');
    FixedCellTextRect := GetRectProperty('fixedcelltextrect');
    //
    CellLeftOffset := GetIntProperty('cellleftoffset');
    CellRightOffset := GetIntProperty('cellrightoffset');
    CellTextRect := GetRectProperty('celltextrect');
    //
    LinesColor := GetIntProperty('linescolor');
    BGColor := GetIntProperty('bgcolor');
    //
    BGPictureIndex := GetIntProperty('bgpictureindex');
    //
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    SelectFontColor := GetIntProperty('selectfontcolor');
    FocusFontColor := GetIntProperty('focusfontcolor');
    //
    FixedFontName := GetStrProperty('fixedfontname');
    FixedFontHeight := GetIntProperty('fixedfontheight');
    FixedFontStyle := GetFSProperty('fixedfontstyle');
    FixedFontColor := GetIntProperty('fixedfontcolor');
    //
    CellStretchEffect := GetBolProperty('cellstretcheffect');
    FixedCellStretchEffect := GetBolProperty('fixedcellstretcheffect');
    ShowFocus := GetBolProperty('showfocus');
  end;
end;

procedure TSBForm.SaveRegulatorControl;
begin
  with PE, TspDataSkinFrameRegulator(SkinData.CtrlList.Items[Index]) do
  begin
    FramesCount := GetIntProperty('framescount');
    FramesPlacement := GetFrPl(GetPropertyValue('framesplacement'));
    Kind := GetRegKind(GetPropertyValue('kind'));
  end;
end;

procedure TSBForm.LoadTrackBarControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinTrackBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('trackarea', TrackArea, 'rectctrl2');
    AddRectProperty('buttonrect', ButtonRect, 'rectctrl1');
    AddRectProperty('activebuttonrect', ActiveButtonRect, 'rectctrl1');
    AddBolProperty('vertical', Vertical, 'boolean');
    AddBolProperty('buttontransparent', ButtonTransparent, 'boolean');
    AddIntProperty('buttontransparentcolor', ButtonTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< trackbar >';
end;

procedure TSBForm.LoadCheckRadioControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinCheckRadioControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('leftbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('checkimagearea', CheckImageArea, 'rectctrl2');
    AddRectProperty('textarea', TextArea, 'rectctrl2');
    AddRectProperty('checkimagerect', CheckImageRect, 'rectctrl1');
    AddRectProperty('uncheckimagerect', UnCheckImageRect, 'rectctrl1');
    AddRectProperty('activecheckimagerect', ActiveCheckImageRect, 'rectctrl1');
    AddRectProperty('activeuncheckimagerect', ActiveUnCheckImageRect, 'rectctrl1');

    AddRectProperty('grayedcheckimagerect', GrayedCheckImageRect, 'rectctrl1');
    AddRectProperty('activegrayedcheckimagerect', ActiveGrayedCheckImageRect, 'rectctrl1');

    AddRectProperty('unenabledcheckimagerect', UnEnabledCheckImageRect, 'rectctrl1');
    AddRectProperty('unenableduncheckimagerect', UnEnabledUnCheckImageRect, 'rectctrl1');



    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('framefontcolor', FrameFontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('unenabledfontcolor', UnEnabledFontColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< checkradio >';
end;

procedure TSBForm.LoadMenuButtonControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinMenuButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('downfontcolor', DownFontColor, 'skincolor');
    AddIntProperty('disabledfontcolor', DisabledFontColor, 'skincolor');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('downskinrect', DownSkinRect, 'rectctrl1');
    AddRectProperty('disabledskinrect', DisabledSkinRect, 'rectctrl1');
    AddRectProperty('trackbuttonrect', TrackButtonRect, 'rectctrl2');
    AddBolProperty('showfocus', ShowFocus, 'boolean');
     //
    AddRectProperty('menumarkerflatrect', MenuMarkerFlatRect, 'rectctrl1');
    AddIntProperty('menumarkertransparentcolor',  MenuMarkerTransparentColor, 'skincolor');
    //
  end;
  PE.Cells[0, 0] := '< menubutton >';
end;

procedure TSBForm.LoadButtonControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('downskinrect', DownSkinRect, 'rectctrl1');
    AddRectProperty('focusedskinrect', FocusedSkinRect, 'rectctrl1');
    AddRectProperty('disabledskinrect', DisabledSkinRect, 'rectctrl1');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('downfontcolor', DownFontColor, 'skincolor');
    AddIntProperty('disabledfontcolor', DisabledFontColor, 'skincolor');
    AddRectProperty('animateskinrect', AnimateSkinRect, 'rectctrl1');
    AddIntProperty('framecount', FrameCount, 'int');
    AddIntProperty('animateinterval', AnimateInterval, 'int');
    AddBolProperty('showfocus', ShowFocus, 'boolean');
     //
    AddRectProperty('menumarkerrect', MenuMarkerRect, 'rectctrl1');
    AddRectProperty('menumarkeractiverect', MenuMarkerActiveRect, 'rectctrl1');
    AddRectProperty('menumarkerdownrect', MenuMarkerDownRect, 'rectctrl1');
    AddRectProperty('menumarkerflatrect', MenuMarkerFlatRect, 'rectctrl1');
    AddIntProperty('menumarkertransparentcolor',  MenuMarkerTransparentColor, 'skincolor');
    //
    AddIntProperty('glowlayerpictureindex', GlowLayerPictureIndex, 'pindex');
    AddIntProperty('glowlayermaskpictureindex', GlowLayerMaskPictureIndex, 'pindex');
    AddIntProperty('glowlayeroffsetleft', GlowLayerOffsetLeft, 'int');
    AddIntProperty('glowlayeroffsetright', GlowLayerOffsetRight, 'int');
    AddIntProperty('glowlayeroffsettop', GlowLayerOffsetTop, 'int');
    AddIntProperty('glowlayeroffsetbottom', GlowLayerOffsetBottom, 'int');
    AddIntProperty('glowlayershowoffsetx', GlowLayerShowOffsetX, 'int');
    AddIntProperty('glowlayershowoffsety', GlowLayerShowOffsetY, 'int');
    AddIntProperty('glowlayeralphablendvalue', GlowLayerAlphaBlendValue, 'int');
    //
  end;
  PE.Cells[0, 0] := '< button >';
end;

procedure TSBForm.LoadExPanelControl(Index: Integer);
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinExPanelControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('captionrect', CaptionRect, 'rectctrl2');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    //
    AddRectProperty('rollhskinrect', RollHSkinRect, 'rectctrl1');
    AddRectProperty('rollvskinrect', RollVSkinRect, 'rectctrl1');
    AddIntProperty('rollleftoffset', RollLeftOffset, 'int');
    AddIntProperty('rollrightoffset', RollRightOffset, 'int');
    AddIntProperty('rolltopoffset', RollTopOffset, 'int');
    AddIntProperty('rollbottomoffset', RollBottomOffset, 'int');
    AddRectProperty('rollhcaptionrect', RollHCaptionRect, 'rhcrect');
    AddRectProperty('rollvcaptionrect', RollVCaptionRect, 'rvcrect');
    //
    AddRectProperty('closebuttonrect', CloseButtonRect, 'rectctrl1');
    AddRectProperty('closebuttonactiverect', CloseButtonActiveRect, 'rectctrl1');
    AddRectProperty('closebuttondownrect', CloseButtonDownRect, 'rectctrl1');
    AddRectProperty('hrollbuttonrect', HRollButtonRect, 'rectctrl1');
    AddRectProperty('hrollbuttonactiverect', HRollButtonActiveRect, 'rectctrl1');
    AddRectProperty('hrollbuttondownrect', HRollButtonDownRect, 'rectctrl1');

    AddRectProperty('hrestorebuttonrect', HRestoreButtonRect, 'rectctrl1');
    AddRectProperty('hrestorebuttonactiverect', HRestoreButtonActiveRect, 'rectctrl1');
    AddRectProperty('hrestorebuttondownrect', HRestoreButtonDownRect, 'rectctrl1');

    AddRectProperty('vrollbuttonrect', VRollButtonRect, 'rectctrl1');
    AddRectProperty('vrollbuttonactiverect', VRollButtonActiveRect, 'rectctrl1');
    AddRectProperty('vrollbuttondownrect', VRollButtonDownRect, 'rectctrl1');

    AddRectProperty('vrestorebuttonrect', VRestoreButtonRect, 'rectctrl1');
    AddRectProperty('vrestorebuttonactiverect', VRestoreButtonActiveRect, 'rectctrl1');
    AddRectProperty('vrestorebuttondownrect', VRestoreButtonDownRect, 'rectctrl1');
    //
    AddBolProperty('buttonstransparent', ButtonsTransparent, 'boolean');
    AddIntProperty('buttonstransparentcolor', ButtonsTransparentColor, 'skincolor');
    //
  end;
  PE.Cells[0, 0] := '< expanel >';
end;

procedure TSBForm.LoadPanelControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinPanelControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
    AddRectProperty('captionrect', CaptionRect, 'rectctrl2');
    AddAlignmentProperty('alignment', Alignment, 'alignment');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddRectProperty('checkimagerect', CheckImageRect, 'rectctrl1');
    AddRectProperty('uncheckimagerect', UnCheckImageRect, 'rectctrl1');
    //
    AddRectProperty('markframerect', MarkFrameRect, 'rectctrl1');
    AddRectProperty('framerect', FrameRect, 'rectctrl1');
    AddRectProperty('frametextrect', FrameTextRect, 'panelframetextrect');
    AddIntProperty('frameleftoffset', FrameLeftOffset, 'int');
    AddIntProperty('framerightoffset', FrameRightOffset, 'int');
    //
    AddRectProperty('gripperrect', GripperRect, 'rectctrl1');
    AddBolProperty('grippertransparent', GripperTransparent, 'boolean');
    AddIntProperty('grippertransparentcolor', GripperTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< panel >';
end;

procedure TSBForm.LoadStdLabelControl;
var
  P: TspProperty;
begin
  with PE, TspDataSkinStdLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('skinrect');
    P.PropertyType := 'fixed';
    P := GetProperty('cursorindex');
    P.PropertyType := 'fixed';
    //
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< stdlabel >';
end;

procedure TSBForm.LoadLabelControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('leftbottompoint');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< label >';
end;

procedure TSBForm.LoadBitLabelControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinBitLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('leftbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('skintextrect', SkinTextRect, 'rectctrl1');
    AddIntProperty('symbolwidth', SymbolWidth, 'int');
    AddIntProperty('symbolheight', SymbolHeight, 'int');
    AddProperty('symbols', '', 'blcstrs');
  end;
  PE.Cells[0, 0] := '< bitlabel >';
end;


procedure TSBForm.LoadMemoControl;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinMemoControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('bgcolor', BGColor, 'skincolor');
    AddIntProperty('activebgcolor', ActiveBGColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< memo >';
end;

procedure TSBForm.LoadSpinEditControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinSpinEditControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('leftbottompoint');
    P.PropertyType := 'fixed';
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('disabledfontcolor', DisabledFontColor, 'skincolor');

    AddRectProperty('upbuttonrect', UpButtonRect, 'rectctrl2');
    AddRectProperty('activeupbuttonrect', ActiveUpButtonRect, 'rectctrl1');
    AddRectProperty('downupbuttonrect', DownUpButtonRect, 'rectctrl1');

    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl2');
    AddRectProperty('activedownbuttonrect', ActiveDownButtonRect, 'rectctrl1');
    AddRectProperty('downdownbuttonrect', DownDownButtonRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< spinedit >';
end;

procedure TSBForm.LoadEditControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinEditControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('leftbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('disabledfontcolor', DisabledFontColor, 'skincolor');
    AddRectProperty('buttonrect', ButtonRect, 'rectctrl2');
    AddRectProperty('activebuttonrect', ActiveButtonRect, 'rectctrl1');
    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl1');
    AddRectProperty('unenabledbuttonrect', UnEnabledButtonRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< edit >';
end;

procedure TSBForm.LoadScrollBarControl;
var
  P: TspProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TspDataSkinScrollBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';

    AddRectProperty('trackarea', TrackArea, 'rectctrl2');

    AddRectProperty('upbuttonrect', UpButtonRect, 'rectctrl2');
    AddRectProperty('activeupbuttonrect', ActiveUpButtonRect, 'rectctrl1');
    AddRectProperty('downupbuttonrect', DownUpButtonRect, 'rectctrl1');

    AddRectProperty('downbuttonrect', DownButtonRect, 'rectctrl2');
    AddRectProperty('activedownbuttonrect', ActiveDownButtonRect, 'rectctrl1');
    AddRectProperty('downdownbuttonrect', DownDownButtonRect, 'rectctrl1');

    AddRectProperty('thumbrect', ThumbRect, 'rectctrl1');
    AddRectProperty('activethumbrect', ActiveThumbRect, 'rectctrl1');
    AddRectProperty('downthumbrect', DownThumbRect, 'rectctrl1');

    AddIntProperty('thumboffset1', ThumbOffset1, 'int');
    AddIntProperty('thumboffset2', ThumbOffset2, 'int');

    AddBolProperty('thumbtransparent', ThumbTransparent, 'boolean');
    AddIntProperty('thumbtransparentcolor', ThumbTransparentColor, 'skincolor');

    AddBolProperty('thumbstretcheffect', ThumbStretchEffect, 'boolean');
    AddIntProperty('thumbminsize',  ThumbMinSize, 'int');
    AddIntProperty('thumbminpagesize',  ThumbMinPageSize, 'int');

    AddRectProperty('glyphrect', GlyphRect, 'rectctrl1');
    AddRectProperty('activeglyphrect', ActiveGlyphRect, 'rectctrl1');
    AddRectProperty('downglyphrect', DownGlyphRect, 'rectctrl1');

    AddBolProperty('glyphtransparent', GlyphTransparent, 'boolean');
    AddIntProperty('glyphtransparentcolor', GlyphTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< scrollbar >';
end;


procedure TSBForm.LoadObject;
begin
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuBarItem
  then
    LoadMainMenuBarItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuItem
  then
    LoadMainMenuItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMenuItem
  then
    LoadMenuItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuBarButton
  then
    LoadMainMenuBarButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinStdButton
  then
    LoadStdButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinButton
  then
    LoadButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinCaption
  then
    LoadCaption(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinSwitch
  then
    begin
      DefLoadObject(Index);
      PE.Cells[0, 0] := '< switch >';
    end
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinTrackBar
  then
    LoadTrackBar(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinLabel
  then
    LoadLabel(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinAnimate
  then
    LoadAnimate(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinGauge
  then
    LoadGauge(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinFrameRegulatorObject
  then
    LoadFrameRegulator(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinFrameGaugeObject
  then
    LoadFrameGauge(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinBitLabel
  then
    LoadBitLabel(Index);
end;

procedure TSBForm.SaveControl(Index: Integer);
begin
  DefSaveControl(Index);
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinPanelControl
  then
    SavePanelControl(Index)
  else  
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinExPanelControl
  then
    SaveExPanelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMenuButtonControl
  then
    SaveMenuButtonControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinButtonControl
  then
    SaveButtonControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinCheckRadioControl
  then
    SaveCheckRadioControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinGaugeControl
  then
    SaveGaugeControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSplitterControl
  then
    SaveSplitterControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTrackBarControl
  then
    SaveTrackBarControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinLabelControl
  then
    SaveLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinBitLabelControl
  then
    SaveBitLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinStdLabelControl
  then
    SaveStdLabelControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinFrameRegulator
  then
    SaveRegulatorControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinFrameGauge
  then
    SaveFGaugeControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinAnimateControl
  then
    SaveAnimateControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinUpDownControl
  then
    SaveUpDownControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSwitchControl
  then
    SaveSwitchControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinGridControl
  then
    SaveGridControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTabControl
  then
    SaveTabControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSlider
  then
    SaveSliderControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMainMenuBar
  then
    SaveMainMenuBar(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinControlBar
  then
    SaveControlBar(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinCheckListBox
  then
    SaveCheckListBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinListBox
  then
    SaveListBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinComboBox
  then
    SaveComboBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinMemoControl
  then
    SaveMemoControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinEditControl
  then
    SaveEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinScrollBarControl
  then
    SaveScrollBarControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinSpinEditControl
  then
    SaveSpinEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinScrollBoxControl
  then
    SaveScrollBoxControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinTreeView
  then
    SaveTreeViewControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinListView
  then
    SaveListViewControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinRichEdit
  then
    SaveRichEditControl(Index)
  else
  if TspDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TspDataSkinBevel
  then
    SaveBevelControl(Index);
end;

procedure TSBForm.DefSaveControl(Index: Integer);
begin
  with PE, TspDataSkinControl(SkinData.CtrlList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    PictureIndex := GetIntProperty('pictureindex');
    MaskPictureIndex := GetIntProperty('maskpictureindex');
    CursorIndex := GetIntProperty('cursorindex');
    SkinRect := GetRectProperty('skinrect');
    Names.Items[Index] := IDName;
  end;
end;

procedure TSBForm.DefSaveResizeControl(Index: Integer);
begin
  with PE, TspDataSkinCustomControl(SkinData.CtrlList.Items[Index]) do
  begin
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ClRect :=  GetRectProperty('clientrect');
    StretchEffect := GetBolProperty('stretcheffect');
    LeftStretch := GetBolProperty('leftstretch');
    TopStretch := GetBolProperty('topstretch');
    RightStretch := GetBolProperty('rightstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
  end;
end;

procedure TSBForm.SaveSplitterControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinSplitterControl(SkinData.CtrlList.Items[Index]) do
  begin
    GripperRect := GetRectProperty('gripperrect');
    GripperTransparent := GetBolProperty('grippertransparent');
    GripperTransparentColor := GetIntProperty('grippertransparentcolor');
  end;
end;

procedure TSBForm.SaveGaugeControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinGaugeControl(SkinData.CtrlList.Items[Index]) do
  begin
    ProgressArea := GetRectProperty('progressarea');
    ProgressRect := GetRectProperty('progressrect');
    BeginOffset := GetIntProperty('beginoffset');
    EndOffset := GetIntProperty('endoffset');
    Vertical := GetBolProperty('vertical');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ProgressTransparent := GetBolProperty('progresstransparent');
    ProgressTransparentColor := GetIntProperty('progresstransparentcolor');
    ProgressStretch := GetBolProperty('progressstretch');

    AnimationSkinRect := GetRectProperty('animationskinrect');
    AnimationCountFrames := GetIntProperty('animationcountframes');
    AnimationTimerInterval := GetIntProperty('animationtimerinterval');

    ProgressAnimationSkinRect := GetRectProperty('progressanimationskinrect');
    ProgressAnimationCountFrames := GetIntProperty('progressanimationcountframes');
    ProgressAnimationTimerInterval := GetIntProperty('progressanimationtimerinterval');

    AnimationBeginOffset := GetIntProperty('animationbeginoffset');
    AnimationEndOffset := GetIntProperty('animationendoffset');
  end;  
end;

procedure TSBForm.SaveTrackBarControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinTrackBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    TrackArea := GetRectProperty('trackarea');
    ButtonRect := GetRectProperty('buttonrect');
    ActiveButtonRect := GetRectProperty('activebuttonrect');
    Vertical := GetBolProperty('vertical');
    ButtonTransparent := GetBolProperty('buttontransparent');
    ButtonTransparentColor := GetIntProperty('buttontransparentcolor');
  end;
end;

procedure TSBForm.SaveCheckRadioControl;
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinCheckRadioControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    CheckImageArea := GetRectProperty('checkimagearea');
    TextArea := GetRectProperty('textarea');
    CheckImageRect := GetRectProperty('checkimagerect');
    UnCheckImageRect := GetRectProperty('uncheckimagerect');
    ActiveCheckImageRect := GetRectProperty('activecheckimagerect');
    ActiveUnCheckImageRect := GetRectProperty('activeuncheckimagerect');
    UnEnabledCheckImageRect := GetRectProperty('unenabledcheckimagerect');
    UnEnabledUnCheckImageRect := GetRectProperty('unenableduncheckimagerect');

    GrayedCheckImageRect := GetRectProperty('grayedcheckimagerect');
    ActiveGrayedCheckImageRect := GetRectProperty('activegrayedcheckimagerect');

    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));;
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    FrameFontColor := GetIntProperty('framefontcolor');
    UnEnabledFontColor := GetIntProperty('unenabledfontcolor');
  end;
end;

procedure TSBForm.SaveMenuButtonControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinMenuButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DownFontColor := GetIntProperty('downfontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
    ActiveSkinRect := GetRectProperty('activeskinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    TrackButtonRect := GetRectProperty('trackbuttonrect');
    DisabledSkinRect := GetRectProperty('disabledskinrect');
    ShowFocus := GetBolProperty('showfocus');
    //
    MenuMarkerFlatRect := GetRectProperty('menumarkerflatrect');
    MenuMarkerTransparentColor := GetIntProperty('menumarkertransparentcolor');
  end;
end;

procedure TSBForm.SaveButtonControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    FocusedSkinRect := GetRectProperty('focusedskinrect');
    DisabledSkinRect := GetRectProperty('disabledskinrect');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DownFontColor := GetIntProperty('downfontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    AnimateSkinRect := GetRectProperty('animateskinrect');
    FrameCount := GetIntProperty('framecount');
    AnimateInterval := GetIntProperty('animateinterval');
    ShowFocus := GetBolProperty('showfocus');
    //
    MenuMarkerRect := GetRectProperty('menumarkerrect');
    MenuMarkerActiveRect := GetRectProperty('menumarkeractiverect');
    MenuMarkerDownRect := GetRectProperty('menumarkerdownrect');
    MenuMarkerFlatRect := GetRectProperty('menumarkerflatrect');
    MenuMarkerTransparentColor := GetIntProperty('menumarkertransparentcolor');
    //
    GlowLayerPictureIndex := GetIntProperty('glowlayerpictureindex');
    GlowLayerMaskPictureIndex := GetIntProperty('glowlayermaskpictureindex');
    GlowLayerOffsetLeft := GetIntProperty('glowlayeroffsetleft');
    GlowLayerOffsetTop := GetIntProperty('glowlayeroffsettop');
    GlowLayerOffsetRight := GetIntProperty('glowlayeroffsetright');
    GlowLayerOffsetBottom := GetIntProperty('glowlayeroffsetbottom');
    GlowLayerShowOffsetX := GetIntProperty('glowlayershowoffsetx');
    GlowLayerShowOffsetY := GetIntProperty('glowlayershowoffsety');
    GlowLayerAlphaBlendValue := GetIntProperty('glowlayeralphablendvalue');
  end;
end;

procedure TSBForm.SaveStdLabelControl(Index: Integer);
begin
  with PE, TspDataSkinStdLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
  end;
end;

procedure TSBForm.SaveBitLabelControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinBitLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    SkinTextRect := GetRectProperty('skintextrect');
    SymbolWidth := GetIntProperty('symbolwidth');
    SymbolHeight := GetIntProperty('symbolheight');
  end;
end;

procedure TSBForm.SaveLabelControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
  end;
end;

procedure TSBForm.SaveMemoControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinMemoControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    BGColor := GetIntProperty('bgcolor');
    ActiveBGColor := GetIntProperty('activebgcolor');
  end;
end;

procedure TSBForm.SaveSpinEditControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinSpinEditControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');
  end;
end;

procedure TSBForm.SaveEditControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinEditControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    ButtonRect := GetRectProperty('buttonrect');
    ActiveButtonRect := GetRectProperty('activebuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    UnEnabledButtonRect := GetRectProperty('unenabledbuttonrect');
  end;
end;

procedure TSBForm.SaveTreeViewControl;
begin
  with PE, TspDataSkinTreeView(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    BGColor := GetIntProperty('bgcolor');
  end;
end;

procedure TSBForm.SaveListViewControl;
begin
  with PE, TspDataSkinListView(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    BGColor := GetIntProperty('bgcolor');
  end;
end;

procedure TSBForm.SaveRichEditControl;
begin
  with PE, TspDataSkinRichEdit(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    BGColor := GetIntProperty('bgcolor');
  end;
end;

procedure TSBForm.SaveScrollBarControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinScrollBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    TrackArea := GetRectProperty('trackarea');

    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');

    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');

    ThumbRect := GetRectProperty('thumbrect');
    ActiveThumbRect := GetRectProperty('activethumbrect');
    DownThumbRect := GetRectProperty('downthumbrect');

    ThumbOffset1 := GetIntProperty('thumboffset1');
    ThumbOffset2 := GetIntProperty('thumboffset2');

    ThumbTransparent := GetBolProperty('thumbtransparent');
    ThumbTransparentColor := GetIntProperty('thumbtransparentcolor');

    ThumbStretchEffect := GetBolProperty('thumbstretcheffect');
    ThumbMinSize := GetIntProperty('thumbminsize');
    ThumbMinPageSize := GetIntProperty('thumbminpagesize');

    GlyphRect := GetRectProperty('glyphrect');
    ActiveGlyphRect := GetRectProperty('activeglyphrect');
    DownGlyphRect := GetRectProperty('downglyphrect');

    GlyphTransparent := GetBolProperty('glyphtransparent');
    GlyphTransparentColor := GetIntProperty('glyphtransparentcolor');
  end;
end;

procedure TSBForm.SaveExPanelControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinExPanelControl(SkinData.CtrlList.Items[Index]) do
  begin
    CaptionRect := GetRectProperty('captionrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    //
    RollHSkinRect := GetRectProperty('rollhskinrect');
    RollVSkinRect := GetRectProperty('rollvskinrect');
    RollLeftOffset := GetIntProperty('rollleftoffset');
    RollRightOffset := GetIntProperty('rollrightoffset');
    RollTopOffset := GetIntProperty('rolltopoffset');
    RollBottomOffset := GetIntProperty('rollbottomoffset');
    RollHCaptionRect :=  GetRectProperty('rollhcaptionrect');
    RollVCaptionRect := GetRectProperty('rollvcaptionrect');
    //
    CloseButtonRect := GetRectProperty('closebuttonrect');
    CloseButtonActiveRect := GetRectProperty('closebuttonactiverect');
    CloseButtonDownRect := GetRectProperty('closebuttondownrect');
    HRollButtonRect := GetRectProperty('hrollbuttonrect');
    HRollButtonActiveRect := GetRectProperty('hrollbuttonactiverect');
    HRollButtonDownRect := GetRectProperty('hrollbuttondownrect');
    HRestoreButtonRect := GetRectProperty('hrestorebuttonrect');
    HRestoreButtonActiveRect := GetRectProperty('hrestorebuttonactiverect');
    HRestoreButtonDownRect := GetRectProperty('hrestorebuttondownrect');
    VRollButtonRect := GetRectProperty('vrollbuttonrect');
    VRollButtonActiveRect := GetRectProperty('vrollbuttonactiverect');
    VRollButtonDownRect := GetRectProperty('vrollbuttondownrect');
    VRestoreButtonRect := GetRectProperty('vrestorebuttonrect');
    VRestoreButtonActiveRect := GetRectProperty('vrestorebuttonactiverect');
    VRestoreButtonDownRect := GetRectProperty('vrestorebuttondownrect');
    //
    ButtonsTransparent := GetBolProperty('buttonstransparent');
    ButtonsTransparentColor := GetIntProperty('buttonstransparentcolor');
  end;
end;

procedure TSBForm.SavePanelControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TspDataSkinPanelControl(SkinData.CtrlList.Items[Index]) do
  begin
    BGPictureIndex := GetIntProperty('bgpictureindex');
    CaptionRect := GetRectProperty('captionrect');
    Alignment := GetAlignmentProperty('alignment');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    CheckImageRect := GetRectProperty('checkimagerect');
    UnCheckImageRect := GetRectProperty('uncheckimagerect');
    //
    MarkFrameRect := GetRectProperty('markframerect');
    FrameRect := GetRectProperty('framerect');
    FrameTextRect := GetRectProperty('frametextrect');
    FrameLeftOffset := GetIntProperty('frameleftoffset');
    FrameRightOffset := GetIntProperty('framerightoffset');
    //
    GripperRect := GetRectProperty('gripperrect');
    GripperTransparent := GetBolProperty('grippertransparent');
    GripperTransparentColor := GetIntProperty('grippertransparentcolor');
  end;
end;

procedure TSBForm.SaveObject(Index: Integer);
begin
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuBarItem
  then
    SaveMainMenuBarItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuItem
  then
    SaveMainMenuItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMenuItem
  then
    SaveMenuItem(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinMainMenuBarButton
  then
    SaveMainMenuBarButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinStdButton
  then
    SaveStdButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinButton
  then
    SaveButton(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinCaption
  then
    SaveCaption(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinSwitch
  then
    DefSaveObject(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinTrackBar
  then
    SaveTrackBar(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinLabel
  then
    SaveLabel(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinAnimate
  then
    SaveAnimate(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinGauge
  then
    SaveGauge(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinFrameRegulatorObject
  then
    SaveFrameRegulator(Index)
  else
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinFrameGaugeObject
  then
    SaveFrameGauge(Index)
  else  
  if TspDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TspDataSkinBitLabel
  then
    SaveBitLabel(Index);
end;

procedure TSBForm.LoadCtrlList;
var
  i: Integer;
begin
  Names.Clear;
  for i := 0 to SkinData.CtrlList.Count - 1 do
    Names.Items.Add(TspDataSkinControl(SkinData.CtrlList.Items[i]).IDName);
  if SkinData.CtrlList.Count <> 0
  then
    begin
      LoadControl(0);
      Names.ItemIndex := 0;
    end
  else
    PE.DeleteProperties(True);
end;

procedure TSBForm.LoadObjectList;
var
  i: Integer;
begin
  Names.Clear;
  for i := 0 to SkinData.ObjectList.Count - 1 do
    Names.Items.Add(TspDataSkinObject(SkinData.ObjectList.Items[i]).IDName);
  if SkinData.ObjectList.Count <> 0
  then
    begin
      LoadObject(0);
      Names.ItemIndex := 0;
    end
  else
    PE.DeleteProperties(True);
end;

procedure TSBForm.CIndexDialog(P: TspProperty);
begin
  CIndexForm.Execute(P);
end;

procedure TSBForm.IndexDialog(P: TspProperty);
begin
  PIndexForm.Execute(P);
end;

procedure TSBForm.FSDialog(P: TspProperty);
begin
  FSForm.Execute(P);
end;

procedure TSBForm.RectDialog21;
var
  B: TBitMap;
begin
  if Rup
  then B := SkinData.FRollUpPicture
  else B := SkinData.FPicture;
  if not B.Empty
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        B.Canvas, R);
      SPImageEditor.ExecuteAsGetRect(TempImage, P);
    end
  else
    SPImageEditor.ExecuteAsGetRect(nil, P);
end;

procedure TSBForm.RectDialog2;
begin
  if Index <> -1
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        TBitMap(SkinData.FActivePictures.Items[Index]).Canvas, R);
      SPImageEditor.ExecuteAsGetRect(TempImage, P);
    end
  else
    SPImageEditor.ExecuteAsGetRect(nil, P);
end;

procedure TSBForm.RectDialog1(Index: Integer; P: TspProperty);
begin
  if Index <> -1
  then
    SPImageEditor.ExecuteAsGetRect(SkinData.FActivePictures.Items[Index], P)
  else
    SPImageEditor.ExecuteAsGetRect(nil, P);
end;

procedure TSBForm.RectDialog;
begin
  if ((P.PropertyType = 'rect') or (P.PropertyType = 'rurect')) and not SkinData.FRollUpPicture.Empty and RUp
  then
    SPImageEditor.ExecuteAsGetRect(SkinData.FRollUpPicture, P)
  else
  if ((P.PropertyType = 'rect') or (P.PropertyType = 'stdrect')) and not SkinData.FPicture.Empty and not RUp
  then
    SPImageEditor.ExecuteAsGetRect(SkinData.FPicture, P)
  else
  if (P.PropertyType = 'maskrect') and not SkinData.FMask.Empty
  then
    SPImageEditor.ExecuteAsGetRect(SkinData.FMask, P);
end;

procedure TSBForm.PointDialog21;
var
  B: TBitMap;
begin
  if Rup
  then B := SkinData.FRollUpPicture
  else B := SkinData.FPicture;
  if not B.Empty
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        B.Canvas, R);
      SPImageEditor.ExecuteAsGetPoint(TempImage, P);
    end
  else
    SPImageEditor.ExecuteAsGetPoint(nil, P);
end;

procedure TSBForm.PointDialog2;
begin
  if Index <> -1
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        TBitMap(SkinData.FActivePictures.Items[Index]).Canvas, R);
      SPImageEditor.ExecuteAsGetPoint(TempImage, P);
    end
  else
    SPImageEditor.ExecuteAsGetPoint(nil, P);
end;

procedure TSBForm.PointDialog1(Index: Integer; P: TspProperty);
begin
  if Index <> -1
  then
    SPImageEditor.ExecuteAsGetPoint(SkinData.FActivePictures.Items[Index], P)
  else
    SPImageEditor.ExecuteAsGetPoint(nil, P);
end;

procedure TSBForm.PointDialog;
begin
  if (P.PropertyType = 'point') and not SkinData.FPicture.Empty and
     not RUp
  then
    SPImageEditor.ExecuteAsGetPoint(SkinData.FPicture, P)
  else
  if ((P.PropertyType = 'point') or (P.PropertyType = 'rupoint')) and not SkinData.FRollUpPicture.Empty and
      RUp
  then
    SPImageEditor.ExecuteAsGetPoint(SkinData.FRollUpPicture, P)
  else
  if (P.PropertyType = 'maskpoint') and not SkinData.FMask.Empty
  then
    SPImageEditor.ExecuteAsGetPoint(SkinData.FMask, P);
end;

procedure TSBForm.SaveSkin;
begin
  with SkinData do
  begin
    if OD.FileName <> ''
    then
      begin
        if OD.FilterIndex = 1
        then
          SaveToFile(OD.FileName)
        else
          SaveToCompressedFile(OD.FileName);
        Changing := False;
      end
    else
      if SD.Execute
      then
        begin
          if SD.FilterIndex = 1
          then
            SaveToFile(SD.FileName)
          else
            SaveToCompressedFile(SD.FileName);
          OD.FileName := SD.FileName;
          OD.FilterIndex := SD.FilterIndex;
          Changing := False;
        end
  end;
end;

procedure TSBForm.NewSkin;
begin
  Names.Clear;
  OD.FileName := '';
  SkinData.ClearAll;
  SkinData.Empty := True;
  PE.DeleteProperties(True);
  SkinData.ClearSkin;
end;

procedure TSBForm.LoadSkin;
begin
  Names.Clear;
  PE.DeleteProperties(True);
  SectionList.ItemIndex := 0;
  LoadVersionSection;
end;

procedure TSBForm.LoadHWSection;
begin
  with PE, SkinData.HintWindow do
  begin
    DeleteProperties(True);
    AddIntProperty('windowpictureindex', WindowPictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
    AddPointProperty('lefttoppoint', LTPoint, 'pointpw');
    AddPointProperty('righttoppoint', RTPoint, 'pointpw');
    AddPointProperty('leftbottompoint', LBPoint, 'pointpw');
    AddPointProperty('rightbottompoint', RBPoint, 'pointpw');
    AddRectProperty('clientrect', ClRect, 'rectpw');
    if FontName = '' then FontName := 'Arial';
    AddProperty('fontname', FontName, 'string');
    if FontHeight = 0 then FontHeight := 14;
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
  end;
  PE.Cells[0, 0] := '< HINTWINDOW >';
end;


procedure TSBForm.SaveColorsSection;
begin
  with PE, SkinData.SkinColors do
  begin
    cBtnFace := GetIntProperty('cbtnface');
    cBtnText := GetIntProperty('cbtntext');
    cWindow := GetIntProperty('cwindow');
    cWindowText := GetIntProperty('cwindowtext');
    cHighLight := GetIntProperty('chighlight');
    cHighLightText := GetIntProperty('chighlighttext');
    cBtnHighLight := GetIntProperty('cbtnhighlight');
    cBtnShadow := GetIntProperty('cbtnshadow');
  end;
  PE.Cells[0, 0] := '< SKINCOLORS >';
end;

procedure TSBForm.LoadColorsSection;
begin
  with PE, SkinData.SkinColors do
  begin
    DeleteProperties(True);
    AddIntProperty('cbtnface', cBtnFace, 'skincolor');
    AddIntProperty('cbtntext', cBtnText, 'skincolor');
    AddIntProperty('cwindow', cWindow, 'skincolor');
    AddIntProperty('cwindowtext', cWindowText, 'skincolor');
    AddIntProperty('chighlight', cHighLight, 'skincolor');
    AddIntProperty('chighlighttext', cHighLightText, 'skincolor');
    AddIntProperty('cbtnhighlight', cBtnHighLight, 'skincolor');
    AddIntProperty('cbtnshadow', cBtnShadow, 'skincolor');
  end;
  PE.Cells[0, 0] := '< SKINCOLORS >';
end;

procedure TSBForm.LoadLFSection;
begin
  with PE, SkinData.LayerFrame do
  begin
    DeleteProperties(True);
    AddIntProperty('pictureindex', PictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
    AddIntProperty('inactivepictureindex', InActivePictureIndex, 'pindex');
    AddIntProperty('inactivemaskpictureindex', InActiveMaskPictureIndex, 'pindex');
    AddPointProperty('lefttoppoint', LTPoint, 'pointlf');
    AddPointProperty('righttoppoint', RTPoint, 'pointlf');
    AddPointProperty('leftbottompoint', LBPoint, 'pointlf');
    AddPointProperty('rightbottompoint', RBPoint, 'pointlf');
    AddRectProperty('clientrect', ClRect, 'rectlf');
    AddRectProperty('borderrect', BorderRect, 'rectlf');
    AddBolProperty('hittestenable', HitTestEnable, 'boolean');
    AddIntProperty('alphablendvalue', AlphaBlendValue, 'int');
    AddIntProperty('inactivealphablendvalue', InActiveAlphaBlendValue, 'int');
  end;
  PE.Cells[0, 0] := '< LAYERFRAME >';
end;

procedure TSBForm.SaveLFSection;
begin
  with PE, SkinData.LayerFrame do
  begin
    PictureIndex := GetIntProperty('pictureindex');
    MaskPictureIndex :=  GetIntProperty('maskpictureindex');
    InActivePictureIndex := GetIntProperty('inactivepictureindex');
    InActiveMaskPictureIndex :=  GetIntProperty('inactivemaskpictureindex');
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ClRect := GetRectProperty('clientrect');
    BorderRect := GetRectProperty('borderrect');
    AlphaBlendValue := GetIntProperty('alphablendvalue');
    InActiveAlphaBlendValue := GetIntProperty('inactivealphablendvalue');
    HitTestEnable := GetBolProperty('hittestenable');
  end;
end;

procedure TSBForm.LoadPWSection;
begin
  with PE, SkinData.PopupWindow do
  begin
    DeleteProperties(True);
    AddIntProperty('windowpictureindex', WindowPictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddPointProperty('lefttoppoint', LTPoint, 'pointpw');
    AddPointProperty('righttoppoint', RTPoint, 'pointpw');
    AddPointProperty('leftbottompoint', LBPoint, 'pointpw');
    AddPointProperty('rightbottompoint', RBPoint, 'pointpw');
    AddRectProperty('itemsrect', ItemsRect, 'rectpw');
    AddIntProperty('scrollmarkercolor', ScrollMarkerColor, 'skincolor');
    AddIntProperty('scrollmarkeractivecolor', ScrollMarkerActiveColor, 'skincolor');
    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
  end;
  PE.Cells[0, 0] := '< POPUPWINDOW >';
end;

procedure TSBForm.SaveHWSection;
begin
  with PE, SkinData.HintWindow do
  begin
    WindowPictureIndex := GetIntProperty('windowpictureindex');
    MaskPictureIndex := GetIntProperty('maskpictureindex');
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ClRect := GetRectProperty('clientrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    LeftStretch := GetBolProperty('leftstretch');
    RightStretch := GetBolProperty('rightstretch');
    TopStretch := GetBolProperty('topstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchEffect := GetBolProperty('stretcheffect');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
  end;
end;

procedure TSBForm.SavePWSection;
begin
  with PE, SkinData.PopupWindow do
  begin
    WindowPictureIndex := GetIntProperty('windowpictureindex');
    MaskPictureIndex :=  GetIntProperty('maskpictureindex');
    CursorIndex := GetIntProperty('cursorindex');
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ItemsRect := GetRectProperty('itemsrect');
    ScrollMarkerColor := GetIntProperty('scrollmarkercolor');
    ScrollMarkerActiveColor := GetIntProperty('scrollmarkeractivecolor');
    LeftStretch := GetBolProperty('leftstretch');
    RightStretch := GetBolProperty('rightstretch');
    TopStretch := GetBolProperty('topstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchEffect := GetBolProperty('stretcheffect');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
  end;
end;

procedure TSBForm.LoadVersionSection;
begin
  with PE, SkinData do
  begin
    DeleteProperties(True);
    AddProperty('skinname', SkinName, 'string');
    AddProperty('skinauthor', SkinAuthor, 'string');
    AddProperty('authoremail', AuthorEmail, 'string');
    AddProperty('authorurl', AuthorURL, 'string');
    AddProperty('skincomments', SkinComments, 'string');
  end;
  PE.Cells[0, 0] := '< VERSION >';
end;

procedure TSBForm.LoadPicturesSection;
var
  i: Integer;
begin
  with PE, SkinData do
  begin
    DeleteProperties(True);
    AddProperty('picture', FPictureName, 'picture');
    AddProperty('inactivepicture', FInActivePictureName, 'inactivepicture');
    AddProperty('mask', FMaskName, 'mask');
    AddProperty('rolluppicture', FRollUpPictureName, 'rolluppicture');
    AddProperty('rollupmask', FRollUpMaskName, 'rollupmask');
  end;
  Names.Clear;
  with SkinData do
    for i := 0 to FActivePicturesNames.Count - 1 do
      Names.Items.Add(FActivePicturesNames[i]);
  PE.Cells[0, 0] := '< PICTURES >';
end;

procedure TSBForm.LoadCursorsSection;
var
  i: Integer;
begin
  with PE, SkinData do
  begin
    DeleteProperties(True);
    AddIntProperty('startcursorindex', StartCursorIndex, 'int');
  end;
  Names.Clear;
  with SkinData do
    for i := 0 to FCursorsNames.Count - 1 do
      Names.Items.Add(FCursorsNames[i]);
  PE.Cells[0, 0] := '< CURSORS >';
end;

procedure TSBForm.LoadFormInfoSection;
begin
  with PE, SkinData do
  begin
    DeleteProperties(True);
    AddPointProperty('lefttoppoint', LTPoint, 'point');
    AddPointProperty('righttoppoint', RTPoint, 'point');
    AddPointProperty('leftbottompoint', LBPoint, 'point');
    AddPointProperty('rightbottompoint', RBPoint, 'point');
    AddRectProperty('clientrect', ClRect, 'rect');
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
    AddIntProperty('mdibgpictureindex', MDIBGPictureIndex, 'pindex');
    //
    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
    AddBolProperty('mdibgstretcheffect', MDIBGStretchEffect, 'boolean');
    AddProperty('mdibgstretchtype', SetStretchType(MDIBGStretchType), 'stretchtype');
    //
    AddRectProperty('captionrect', CaptionRect, 'rect');
    AddRectProperty('buttonsrect', ButtonsRect, 'rect');
    AddIntProperty('buttonsoffset', ButtonsOffset, 'int');
    AddBolProperty('buttonsinleft', CapButtonsInLeft, 'boolean');
    //
    AddRectProperty('maskrectarea', MaskRectArea, 'maskrect');
    //
    AddPointProperty('hittestlefttoppoint', HitTestLTPoint, 'point');
    AddPointProperty('hittestrighttoppoint', HitTestRTPoint, 'point');
    AddPointProperty('hittestleftbottompoint', HitTestLBPoint, 'point');
    AddPointProperty('hittestrightbottompoint', HitTestRBPoint, 'point');
    //
    AddPointProperty('rollupleftpoint', RollUpLeftPoint, 'rupoint');
    AddPointProperty('rolluprightpoint', RollUpRightPoint, 'rupoint');
    //
    AddRectProperty('iconrect', IconRect, 'rect');
    AddRectProperty('mainmenurect', MainMenuRect, 'rect');
    AddBolProperty('mainmenupopupup', MainMenuPopupUp, 'boolean');
    AddIntProperty('borderwidth', BorderW, 'int');
    AddIntProperty('cursorindex', CursorIndex, 'cindex');
    AddBolProperty('autorenderinginactiveimage', Autorenderinginactiveimage, 'boolean');
    AddProperty('inactiveeffect', SetInActiveEffect(InActiveEffect), 'inactiveeffect');
    AddIntProperty('formminwidth', FormMinWidth, 'int');
    AddRectProperty('sizegriparea', SizeGripArea, 'rect');
    AddProperty('statusbarname', StatusBarName, 'string');
    AddBolProperty('mditabstransparent', MDITabsTransparent, 'boolean');
    AddBolProperty('mainmenubartransparent', MainMenuBarTransparent, 'boolean');
  end;
  PE.Cells[0, 0] := '< FORMINFO >';
end;

procedure TSBForm.SaveVersionSection;
begin
  with PE, SkinData do
  begin
    SkinName := GetStrProperty('skinname');
    SkinAuthor := GetStrProperty('skinauthor');
    AuthorEmail := GetStrProperty('authoremail');
    AuthorURL := GetStrProperty('authorurl');
    SkinComments := GetStrProperty('skincomments');
  end;
end;

procedure TSBForm.SavePicturesSection;
begin
end;

procedure TSBForm.SaveCursorsSection;
begin
  with PE, SkinData do
  begin
    StartCursorIndex := GetIntProperty('startcursorindex');
  end;
end;

procedure TSBForm.SaveFormInfoSection;
begin
  with PE, SkinData do
  begin
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ClRect := GetRectProperty('clientrect');
    BGPictureIndex := GetIntProperty('bgpictureindex');
    MDIBGPictureIndex := GetIntProperty('bgpictureindex');
    //
    LeftStretch := GetBolProperty('leftstretch');
    RightStretch := GetBolProperty('rightstretch');
    TopStretch := GetBolProperty('topstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchEffect := GetBolProperty('stretcheffect');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
    MDIBGStretchEffect := GetBolProperty('mdibgstretcheffect');
    MDIBGStretchType := GetStretchType(GetStrProperty('mdibgstretchtype'));
    //
    CaptionRect := GetRectProperty('captionrect');
    ButtonsRect := GetRectProperty('buttonsrect');
    ButtonsOffset := GetIntProperty('buttonsoffset');
    CapButtonsInLeft := GetBolProperty('buttonsinleft');
    //
    MaskRectArea := GetRectProperty('maskrectarea');
    HitTestLTPoint := GetPointProperty('hittestlefttoppoint');
    HitTestRTPoint := GetPointProperty('hittestrighttoppoint');
    HitTestLBPoint := GetPointProperty('hittestleftbottompoint');
    HitTestRBPoint := GEtPointProperty('hittestrightbottompoint');
    //
    RollUpLeftPoint := GetPointProperty('rollupleftpoint');
    RollUpRightPoint := GetPointProperty('rolluprightpoint');
    //
    IconRect := GetRectProperty('iconrect');
    MainMenuRect := GetRectProperty('mainmenurect');
    MainMenuPopupUp := GetBolProperty('mainmenupopupup');
    BorderW := GetIntProperty('borderwidth');
    CursorIndex := GetIntProperty('cursorindex');
    Autorenderinginactiveimage :=  GetBolProperty('autorenderinginactiveimage');
    InActiveEffect := GetInActiveEffect(GetStrProperty('inactiveeffect'));
    FormMinWidth := GetIntProperty('formminwidth');
    SizeGripArea :=  GetRectProperty('sizegriparea');
    StatusBarName := GetStrProperty('statusbarname');
    MDITabsTransparent := GetBolProperty('mditabstransparent');
    MainMenuBarTransparent := GetBolProperty('mainmenubartransparent');
  end;
end;

procedure TSBForm.SectionListClick(Sender: TObject);
begin
  PE.Options := PE.Options - [goEditing];
  Names.Clear;
  case SectionList.ItemIndex  of
    0: LoadVersionSection;
    1: LoadPicturesSection;
    2: LoadCursorsSection;
    3: LoadFormInfoSection;
    4: LoadPWSection;
    5: LoadHWSection;
    6: LoadAreas;
    7: LoadObjectList;
    8: LoadCtrlList;
    9: LoadColorsSection;
    10: LoadLFSection;
  end;
end;

procedure TSBForm.AddPicture;
begin
  AddPicDlg.Execute(nil, nil, '', False);
  if LoadPicForm.PictureName <> ''
  then
    begin
      SkinData.AddBitMap(LoadPicForm.PictureName);
      Names.Items.Add(ExtractFileName( LoadPicForm.PictureName));
    end;
end;

procedure TSBForm.DeletePicture;
begin
  if Names.ItemIndex < 0 then Exit;
  SkinData.DeleteBitMap(Names.ItemIndex);
  Names.Items.Delete(Names.ItemIndex);
end;

procedure TSBForm.AddCursor;
begin
  if CD.Execute
  then
    begin
      SkinData.FCursorsNames.Add(ExtractFileName(CD.FileName));
      Names.Items.Add(ExtractFileName(CD.FileName));
    end;
end;

procedure TSBForm.DeleteCursor;
begin
  if Names.ItemIndex < 0 then Exit;
  SkinData.FCursorsNames.Delete(Names.ItemIndex);
  Names.Items.Delete(Names.ItemIndex);
end;

procedure TSBForm.FormCreate(Sender: TObject);
begin
  SectionList.ItemIndex := 0;
  LoadVersionSection;
  PE.ColWidths[1] := 200;
  SkinData.BuildMode := True;
  Changing := False;
end;

procedure TSBForm.PEEditProperty(P: TspProperty);
var
  i: Integer;
  R: TRect;
  B: Boolean;
  P1: TspProperty;
begin
  if P.PropertyType = 'skincolor'
  then
    begin
      ExecuteColorDialog(P);
    end
  else
  if P.PropertyType = 'stretchtype'
  then
    begin
      if P.Value = 'stfull'
      then P.Value := 'stvert'
      else
      if P.Value = 'stvert'
      then P.Value := 'sthorz'
      else
      if P.Value = 'sthorz'
      then P.Value := 'stfull';
    end
  else
  if P.PropertyType = 'stdrect'
  then
    begin
      P1 := PE.GetProperty('skinrectinapicture');
      if (P1 <> nil) and (P1.Value = '1')
      then
        begin
          I := PE.GetIntProperty('activepictureindex');
          RectDialog1(I, P);
        end
      else
        begin
          B := PE.GetBolProperty('rollup');
          RectDialog(P, B);
        end;
    end
  else
  if P.PropertyType = 'panelframetextrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('framerect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'frametextrect'
  then
    begin
      I := PE.GetIntProperty('activepictureindex');
      R := GetRect(PE.GetPropertyValue('framerect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'frpl'
  then
    begin
      if P.Value = 'fphorizontal'
      then P.Value := 'fpvertical'
      else P.Value := 'fphorizontal';
    end
  else
    if P.PropertyType = 'regkind'
    then
      begin
        if P.Value = 'rkround'
        then P.Value := 'rkhorizontal'
        else
        if P.Value = 'rkhorizontal'
        then P.Value := 'rkvertical'
        else
        if P.Value = 'rkvertical'
        then P.Value := 'rkround'
      end
  else
  if P.PropertyType = 'stdcommand'
  then
    begin
      if P.Value = 'cmminimizetotray'
      then P.Value := 'cmclose' else
      if P.Value = 'cmclose'
      then P.Value := 'cmminimize' else
      if P.Value = 'cmminimize'
      then P.Value := 'cmmaximize' else
      if P.Value = 'cmmaximize'
      then P.Value := 'cmsysmenu' else
      if P.Value = 'cmsysmenu'
      then P.Value := 'cmdefault' else
      if P.Value = 'cmdefault'
      then P.Value := 'cmrollup' else
      if P.Value = 'cmrollup'
      then P.Value := 'cmminimizetotray';
    end
  else
  if P.PropertyType = 'gaugekind'
  then
    begin
      if P.Value = 'gkhorizontal'
      then P.Value := 'gkvertical'
      else P.Value := 'gkhorizontal';
     end
   else
   if P.PropertyType = 'regulatorkind'
   then
     begin
       if P.Value = 'rkround'
       then P.Value := 'rkvertical'
       else
       if P.Value = 'rkvertical'
       then P.Value := 'rkhorizontal'
       else
       if P.Value = 'rkhorizontal'
       then P.Value := 'rkround';
      end
   else
   if P.PropertyType = 'morphkind'
   then
     begin
      if P.Value = 'mkdefault'
      then P.Value := 'mkgradient'
      else
      if P.Value = 'mkgradient'
      then P.Value := 'mkleftgradient'
      else
      if P.Value = 'mkleftgradient'
      then P.Value := 'mkrightgradient'
      else
      if P.Value = 'mkrightgradient'
      then P.Value := 'mkleftslide'
      else
      if P.Value = 'mkleftslide'
      then P.Value := 'mkrightslide'
      else
      if P.Value = 'mkrightslide'
      then P.Value := 'mkpush'
      else
      if P.Value = 'mkpush'
      then P.Value := 'mkdefault';
    end
  else
  if P.PropertyType = 'inactiveeffect'
  then
    begin
      if P.Value = 'iebrightness'
      then P.Value := 'iedarkness'
      else
      if P.Value = 'iedarkness'
      then P.Value := 'iegrayscale'
      else
      if P.Value = 'iegrayscale'
      then P.Value := 'ienoise'
      else
      if P.Value = 'ienoise'
      then P.Value := 'iesplitblur'
      else
      if P.Value = 'iesplitblur'
      then P.Value := 'ieinvert'
      else
      if P.Value = 'ieinvert'
      then P.Value := 'iebrightness';
    end
  else
  if P.PropertyType = 'rhcrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('rollhskinrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'rvcrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('rollvskinrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'picture'
  then
    begin
      AddPicDlg.Execute(SkinData.FPicture, P, P.Value, True);
      SkinData.FPictureName := P.Value;
    end
  else
  if P.PropertyType = 'inactivepicture'
  then
    begin
      AddPicDlg.Execute(SkinData.FInActivePicture, P, P.Value, True);
      SkinData.FInActivePictureName := P.Value;
    end
  else
  if P.PropertyType = 'mask'
  then
    begin
      AddPicDlg.Execute(SkinData.FMask, P, P.Value, True);
      SkinData.FMaskName := P.Value;
    end
  else
  if P.PropertyType = 'rolluppicture'
  then
    begin
      AddPicDlg.Execute(SkinData.FRollUpPicture, P, P.Value, True);
      SkinData.FRollUpPictureName := P.Value;
    end
  else
  if P.PropertyType = 'rollupmask'
  then
    begin
      AddPicDlg.Execute(SkinData.FRollUpMask, P, P.Value, True);
      SkinData.FRollUpMaskName := P.Value;
    end
  else
  if (P.PropertyType = 'rupoint')
  then
    begin
      PointDialog(P, True)
    end
  else
  if (P.PropertyType = 'rurect')
  then
    begin
      RectDialog(P, True)
    end
  else
  if P.PropertyType = 'fontstyle'
  then
    FSDialog(P)
  else
  if P.PropertyType = 'pindex'
  then
    IndexDialog(P)
  else
  if P.PropertyType = 'cindex'
  then
    CIndexDialog(P)
  else
  if (P.PropertyType = 'rect') or (P.PropertyType = 'maskrect')
  then
    begin
      B := PE.GetBolProperty('rollup');
      RectDialog(P, B);
    end
  else
  if (P.PropertyType = 'point') or (P.PropertyType = 'maskpoint')
  then
    begin
      B := PE.GetBolProperty('rollup');
      PointDialog(P, B);
    end
  else
  if P.PropertyType = 'pointpw'
  then
    begin
      I := PE.GetIntProperty('windowpictureindex');
      PointDialog1(I, P);
    end
  else
  if P.PropertyType = 'pointlf'
  then
    begin
      I := PE.GetIntProperty('maskpictureindex');
      PointDialog1(I, P);
    end
  else
  if P.PropertyType = 'rectpw'
  then
    begin
      I := PE.GetIntProperty('windowpictureindex');
      RectDialog1(I, P);
    end
  else
  if P.PropertyType = 'rectlf'
  then
    begin
      I := PE.GetIntProperty('maskpictureindex');
      RectDialog1(I, P);
    end
  else
  if P.PropertyType = 'pointctrl1'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      PointDialog1(I, P);
    end
  else
  if P.PropertyType = 'rectctrl1'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      RectDialog1(I, P);
    end
  else
  if P.PropertyType = 'pointctrl2'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('skinrect'));
      PointDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'rectctrl2'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('skinrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'fcelltextrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('fixedcellrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'celltextrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('selectcellrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'arect12'
  then
    begin
      R := GetRect(PE.GetPropertyValue('skinrect'));
      B := PE.GetBolProperty('rollup');
      RectDialog21(R, P, B);
    end
  else
  if P.PropertyType = 'apoint12'
  then
    begin
      R := GetRect(PE.GetPropertyValue('skinrect'));
      B := PE.GetBolProperty('rollup');
      PointDialog21(R, P, B);
    end
  else
  if P.PropertyType = 'arect'
  then
    begin
      I := PE.GetIntProperty('activepictureindex');
      RectDialog1(I, P);
    end
  else
  if P.PropertyType = 'arect1'
  then
    begin
      I := PE.GetIntProperty('activepictureindex');
      R := GetRect(PE.GetPropertyValue('skinrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'apoint1'
  then
    begin
      I := PE.GetIntProperty('activepictureindex');
      R := GetRect(PE.GetPropertyValue('skinrect'));
      PointDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'itemrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('itemrect'));
      if IsNullRect(R)
      then
        R := GetRect(PE.GetPropertyValue('focusitemrect'));
      RectDialog2(I, R, P);
    end
  else
  if P.PropertyType = 'blstrs'
  then
    begin
      StrsDialog1;
    end
  else
  if P.PropertyType = 'blcstrs'
  then
    begin
      StrsDialog2;
    end;
  if SkinData.Empty then SkinData.Empty := False;
  ApplyChanges;
  Changing := True;
end;

procedure TSBForm.NamesClick(Sender: TObject);
var
  i: Integer;
begin
  if Names.Items.Count = 0 then Exit;
  case SectionList.ItemIndex of
   6: LoadArea(Names.ItemIndex);
   7: LoadObject(Names.ItemIndex);
   8: LoadControl(Names.ItemIndex);
   1: begin
        i := Names.ItemIndex;
        if (i > -1) and (i < SkinData.FActivePictures.Count)
        then
          begin
            AddPicDlg.Execute(TBitMap(SkinData.FActivePictures.Items[i]),
            nil, SkinData.FActivePicturesNames[i], False);
            SkinData.FActivePicturesNames[i] := LoadPicForm.PictureName;
            Names.Items[i] := LoadPicForm.PictureName;
          end;
      end;
  end; 
end;

procedure TSBForm.SpeedButton10Click(Sender: TObject);
var
  j: Integer;
begin
  if (Names.ItemIndex <> - 1) and (Names.Items.Count <> 0) then
  case SectionList.ItemIndex of
   1:
      DeletePicture;
   2:
      DeleteCursor;
   7:
    begin
      j := Names.ItemIndex;
      TspDataSkinObject(SkinData.ObjectList.Items[j]).Free;
      SkinData.ObjectList.Delete(j);
      Names.Items.Delete(j);
      if SkinData.ObjectList.Count <> 0
      then
        begin
          if j - 1 < 0 then j := 0 else j := j - 1;
          Names.ItemIndex := j;
          LoadObject(j);
        end;
    end;
  6:
    begin
      j := Names.ItemIndex;
      TspDataSkinArea(SkinData.AreaList.Items[j]).Free;
      SkinData.AreaList.Delete(j);
      Names.Items.Delete(j);
      if SkinData.AreaList.Count <> 0
      then
        begin
          if j - 1 < 0 then j := 0 else j := j - 1;
          Names.ItemIndex := j;
          LoadArea(j);
        end;
    end;
   8:
    begin
      j := Names.ItemIndex;
      TspDataSkinControl(SkinData.CtrlList.Items[j]).Free;
      SkinData.CtrlList.Delete(j);
      Names.Items.Delete(j);
      if SkinData.CtrlList.Count <> 0
      then
        begin
          if j - 1 < 0 then j := 0 else j := j - 1;
          Names.ItemIndex := j;
          LoadControl(j);
        end;
    end;
  end;
end;        

procedure TSBForm.SpeedButton9Click(Sender: TObject);
begin
  case SectionList.ItemIndex of
    1: AddPicture;
    2: AddCursor;
    6: AddArea;
    7: AddObjFrm.ShowModal;
    8: AddCtrlFrm.ShowModal;
  end;
end;

procedure TSBForm.NewSkinButtonClick(Sender: TObject);
begin
 if Changing
  then
    if MessageDlg('Save current skin?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      SaveSkin;
  NewSkin;
  Changing := False;
end;

procedure TSBForm.OpenSkinButtonClick(Sender: TObject);
begin
  if Changing
  then
    if MessageDlg('Save current skin?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      SaveSkin
    else
      Changing := False;

 if OD.Execute
 then
   begin
     if OD.FilterIndex = 1
     then
       begin
         SkinData.LoadFromFile(OD.FileName);
       end
     else
       begin
         SkinData.LoadFromCompressedFile(OD.FileName);
       end;
     LoadSkin;
     Changing := False;
   end;
end;

procedure TSBForm.SaveSkinButtonClick(Sender: TObject);
begin
  SaveSkin;
end;

procedure TSBForm.SaveSkinAsButtonClick(Sender: TObject);
begin
  if SD.Execute
  then
    begin
      if SD.FilterIndex = 1
      then
        begin
          if OD.FilterIndex = 1
          then
            SkinData.SaveToFile(SD.FileName)
          else
            SkinData.StoreToDisk(SD.FileName);
        end
      else
        SkinData.SaveToCompressedFile(SD.FileName);
      OD.FileName := SD.FileName;
      OD.FilterIndex := SD.FilterIndex;
      Changing := False;
    end;
end;

procedure TSBForm.TestCustomFormButtonClick(Sender: TObject);
begin
  TestForm := TTestForm.Create(Self);
  {with TestForm.DSFTest do
  begin
    SizeAble := False;
  end;}
  TestForm.ShowModal;
  TestForm.Free;
end;

procedure TSBForm.TestFormButtonClick(Sender: TObject);
begin
  TestFormNCEmpty := TTestFormNCEmpty.Create(Self);
  TestFormNCEmpty.ShowModal;
  TestFormNCEmpty.Free;
end;

procedure TSBForm.TestCtrlsButtonClick(Sender: TObject);
begin
  TestFormNC := TTestFormNC.Create(Self);
  TestFormNC.ShowModal;
  TestFormNC.Free;
end;

procedure TSBForm.ExitButtonClick(Sender: TObject);
begin
  if Changing
  then
    if MessageDlg('Save current skin?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      SaveSkin;
  Close;
end;

procedure TSBForm.ToolButton1Click(Sender: TObject);
begin
  if Changing
  then
    if MessageDlg('Save current skin?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      SaveSkin
    else
      Changing := False;
   if OD.FileName <> ''
   then
     if OD.FilterIndex = 1
     then
       begin
         SkinData.LoadFromFile(OD.FileName);
       end
     else
       begin
         SkinData.LoadFromCompressedFile(OD.FileName);
       end;
end;

end.
