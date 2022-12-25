unit skinbuild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, Buttons, Menus, bsSkinData,
  bsPropertyEditor, ComCtrls, ToolWin,
  StdCtrls, ExtDlgs, ImageEditor,
  AddPicDlg, TestFrmEmpty,  TestFrmCtrls, BusinessSkinForm, ImgList,
  bsSkinHint;

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
    CD: TOpenDialog;
    Panel2: TPanel;
    Label4: TLabel;
    PE: TbsPropertyEditor;
    SkinData: TbsSkinData;
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
    ToolButton1: TToolButton;
    bsSkinHint1: TbsSkinHint;
    procedure SectionListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NamesClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure PEEditProperty(P: TbsProperty);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewSkinButtonClick(Sender: TObject);
    procedure OpenSkinButtonClick(Sender: TObject);
    procedure SaveSkinButtonClick(Sender: TObject);
    procedure SaveSkinAsButtonClick(Sender: TObject);
    procedure TestFormButtonClick(Sender: TObject);
    procedure TestCtrlsButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ApplyChanges;
    procedure AddPicture;
    procedure DeletePicture;
    procedure LoadVersionSection;
    procedure LoadPicturesSection;
    procedure LoadFormInfoSection;
    procedure SaveVersionSection;
    procedure SavePicturesSection;
    procedure SaveFormInfoSection;
    procedure LoadLFSection;
    procedure LoadPWSection;
    procedure LoadColorsSection;
    procedure SavePWSection;
    procedure SaveLFSection;
    procedure SaveColorsSection;
    procedure LoadHWSection;
    procedure SaveHWSection;
    procedure LoadSkin;
    procedure NewSkin;
    procedure SaveSkin;
    procedure PointDialog(P: TbsProperty);
    procedure PointDialog1(Index: Integer; P: TbsProperty);
    procedure PointDialog2(Index: Integer; R: TRect; P: TbsProperty);
    procedure PointDialog21(R: TRect; P: TbsProperty);
    procedure RectDialog(P: TbsProperty);
    procedure RectDialog1(Index: Integer; P: TbsProperty);
    procedure RectDialog2(Index: Integer; R: TRect; P: TbsProperty);
    procedure RectDialog21(R: TRect; P: TbsProperty);
    procedure IndexDialog(P: TbsProperty);
    procedure FSDialog(P: TbsProperty);
    procedure LoadCtrlList;
    procedure LoadControl(Index: Integer);
    procedure DefLoadControl(Index: Integer);
    procedure DefLoadResizeControl(Index: Integer);
    procedure LoadPanelControl(Index: Integer);
    procedure LoadExPanelControl(Index: Integer);
    procedure LoadLabelControl(Index: Integer);
    procedure LoadStdLabelControl(Index: Integer);
    procedure LoadButtonControl(Index: Integer);
    procedure LoadMenuButtonControl(Index: Integer);
    procedure LoadCheckRadioControl(Index: Integer);
    procedure LoadGaugeControl(Index: Integer);
    procedure LoadSplitterControl(Index: Integer); 
    procedure LoadTrackBarControl(Index: Integer);
    procedure LoadUpDownControl(Index: Integer);
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
    procedure SaveStdLabelControl(Index: Integer);
    procedure SaveButtonControl(Index: Integer);
    procedure SaveMenuButtonControl(Index: Integer);
    procedure SaveCheckRadioControl(Index: Integer);
    procedure SaveGaugeControl(Index: Integer);
    procedure SaveSplitterControl(Index: Integer);
    procedure SaveTrackBarControl(Index: Integer);
    procedure SaveUpDownControl(Index: Integer);
    procedure SaveGridControl(Index: Integer);
    procedure SaveTabControl(Index: Integer);
    procedure SaveSliderControl(Index: Integer);
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
    procedure LoadAnimate(Index: Integer);
    procedure SaveAnimate(Index: Integer);
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

uses IndexEditor, FSDlg,  AddObjDlg, addctrldlg, bsUtils, SelectColor;

{$R *.DFM}

function GetInActiveEffect(S: String): TbsInActiveEffect;
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

function GetMorphKind(S: String): TbsMorphKind;
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

function GetStretchType(S: String): TbsStretchType;
begin
  if S = 'stfull'
  then Result := bsstFull
  else
  if S = 'stvert'
  then Result := bsstVert
  else
    Result := bsstHorz;
end;

function SetStretchType(ST: TbsStretchType): String;
begin
  case ST of
    bsstFull: Result := 'stfull';
    bsstHorz: Result := 'sthorz';
    bsstVert: Result := 'stvert';
  end;
end;

function SetInActiveEffect(IE: TbsInActiveEffect): String;
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

function SetMorphKind(MK: TbsMorphKind): String;
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

function GetStdCommand(S: String): TbsStdCommand;
begin
  if S = 'cmdefault' then Result := cmDefault else
  if S = 'cmminimize' then Result := cmMinimize else
  if S = 'cmmaximize' then Result := cmMaximize else
  if S = 'cmclose' then Result := cmClose else
  if S = 'cmsysmenu' then Result := cmSysMenu else
  if S = 'cmrollup' then Result := cmRollUp else
  Result := cmMinimizeToTray;
end;

function SetStdCommand(C: TbsStdCommand): String;
begin
  if C = cmdefault then Result := 'cmdefault' else
  if C = cmMinimize then Result := 'cmminimize' else
  if C = cmMaximize then Result := 'cmmaximize' else
  if C = cmClose then Result := 'cmclose' else
  if C = cmSysMenu then Result := 'cmsysmenu' else
  if C = cmRollUp then Result := 'cmrollup' else
  Result := 'minimizetotray';
end;

procedure TSBForm.ApplyChanges;
begin
  case SectionList.ItemIndex  of
    0: SaveVersionSection;
    1: SavePicturesSection;
    2: SaveFormInfoSection;
    3: SavePWSection;
    4: SaveHWSection;
    5: SaveObject(Names.ItemIndex);
    6: SaveControl(Names.ItemIndex);
    7: SaveColorsSection;
    8: SaveLFSection;
  end;
end;

procedure TSBForm.AddControl;
begin
  if (Index > 1) and (AName = '') then Exit;
  if Names.Items.IndexOf(AName) <> -1 then Exit;
  with SkinData.CtrlList do
    case Index of
      0: Add(TbsDataSkinMainMenuBar.Create(AName));
      1: Add(TbsDataSkinButtonControl.Create(AName));
      2: Add(TbsDataSkinCheckRadioControl.Create(AName));
      3: Add(TbsDataSkinGaugeControl.Create(AName));
      4: Add(TbsDataSkinTrackBarControl.Create(AName));
      5: Add(TbsDataSkinLabelControl.Create(AName));
      6: Add(TbsDataSkinGridControl.Create(AName));
      7: Add(TbsDataSkinTabControl.Create(AName));
      8: Add(TbsDataSkinEditControl.Create(AName));
      9: Add(TbsDataSkinMemoControl.Create(AName));
      10: Add(TbsDataSkinScrollBarControl.Create(AName));
      11: Add(TbsDataSkinListBox.Create(AName));
      12: Add(TbsDataSkinComboBox.Create(AName));
      13: Add(TbsDataSkinSpinEditControl.Create(AName));
      14: Add(TbsDataSkinCheckListBox.Create(AName));
      15: Add(TbsDataSkinStdLabelControl.Create(AName));
      16: Add(TbsDataSkinUpDownControl.Create(AName));
      17: Add(TbsDataSkinControlBar.Create(AName));
      18: Add(TbsDataSkinSplitterControl.Create(AName));
      19: Add(TbsDataSkinPanelControl.Create(AName));
      20: Add(TbsDataSkinMenuButtonControl.Create(AName));
      21: Add(TbsDataSkinScrollBoxControl.Create(AName));
      22: Add(TbsDataSkinTreeView.Create(AName));
      23: Add(TbsDataSkinListView.Create(AName));
      24: Add(TbsDataSkinRichEdit.Create(AName));
      25: Add(TbsDataSkinExPanelControl.Create(AName));
      26: Add(TbsDataSkinSlider.Create(AName));
      27: Add(TbsDataSkinBevel.Create(AName));
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
      0: Add(TbsDataSkinCaption.Create(AName));
      1: Add(TbsDataSkinStdButton.Create(AName));
      2: Add(TbsDataSkinButton.Create(AName));
      3: Add(TbsDataSkinMainMenuBarItem.Create(AName));
      4: Add(TbsDataSkinMainMenuBarButton.Create(AName));
      5: Add(TbsDataSkinMenuItem.Create(AName));
      6: Add(TbsDataSkinAnimate.Create(AName));
    end;
  Names.Items.Add(AName);
  Names.ItemIndex := Names.Items.Count - 1;
  LoadObject(Names.ItemIndex);
end;

procedure TSBForm.LoadCaption(Index: Integer);
begin
  DefLoadObject(Index);
  with PE, TbsDataSkinCaption(SkinData.ObjectList.Items[Index]) do
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
    AddBolProperty('shadow', Shadow, 'boolean');
    AddIntProperty('shadowcolor', ShadowColor, 'skincolor');
    AddBolProperty('light', Light, 'boolean');
    AddIntProperty('lightcolor', LightColor, 'skincolor');
    AddIntProperty('activelightcolor', ActiveLightColor, 'skincolor');
    AddIntProperty('activeshadowcolor', ActiveShadowColor, 'skincolor');
    AddRectProperty('framerect', FrameRect, 'arect');
    AddRectProperty('activeframerect', ActiveFrameRect, 'arect');
    AddRectProperty('frametextrect', FrameTextRect, 'frametextrect');
    AddIntProperty('frameleftoffset', FrameLeftOffset, 'int');
    AddIntProperty('framerightoffset', FrameRightOffset, 'int');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddRectProperty('animateskinrect', AnimateSkinRect, 'arect');
    AddIntProperty('framecount', FrameCount, 'int');
    AddIntProperty('animateinterval', AnimateInterval, 'int');
    AddBolProperty('inactiveanimation', InActiveAnimation, 'boolean');
    AddBolProperty('fullframe', FullFrame, 'boolean');
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
  with PE, TbsDataSkinCaption(SkinData.ObjectList.Items[Index]) do
  begin
    TextRct := GetRectProperty('textrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    Alignment := GetAlignmentProperty('alignment');
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
    InActiveAnimation := GetBolProperty('inactiveanimation');
    FullFrame := GetBolProperty('fullframe');
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
  with PE, TbsDataSkinButton(SkinData.ObjectList.Items[Index]) do
  begin
    AddRectProperty('downrect', DownRect, 'arect');
    AddRectProperty('disableskinrect', DisableSkinRect, 'arect');
  end;
  PE.Cells[0, 0] := '< button >';
end;

procedure TSBForm.SaveButton(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TbsDataSkinButton(SkinData.ObjectList.Items[Index]) do
  begin
    DownRect := GetRectProperty('downrect');
    DisableSkinRect := GetRectProperty('disableskinrect');
  end;
end;

procedure TSBForm.LoadAnimate(Index: Integer);
begin
  with PE, TbsDataSkinAnimate(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddProperty('restorehint', RestoreHint, 'string');
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
  end;
  PE.Cells[0, 0] := '< animate >'
end;

procedure TSBForm.SaveAnimate(Index: Integer);
begin
  with PE, TbsDataSkinAnimate(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    Hint := GetStrProperty('hint');
    RestoreHint :=  GetStrProperty('restorehint');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
    SkinRectInApicture := GetBolProperty('skinrectinapicture');
    SkinRect := GetRectProperty('skinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    InActiveSkinRect := GetRectProperty('inactiveskinrect');
    ActiveSkinRect := GetRectProperty('activeskinrect');
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
  end;
  PE.Cells[0, 0] := '< animate >'
end;

procedure TSBForm.LoadStdButton(Index: Integer);
begin
  with PE, TbsDataSkinStdButton(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddProperty('restorehint', RestoreHint, 'string');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
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
  P: TbsProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  P.PropertyType := 'arect';
  with PE, TbsDataSkinMainMenuBarButton(SkinData.ObjectList.Items[Index]) do
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
  with PE, TbsDataSkinStdButton(SkinData.ObjectList.Items[Index]) do
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
  with PE, TbsDataSkinMainMenuBarButton(SkinData.ObjectList.Items[Index]) do
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
  with PE, TbsDataSkinObject(SkinData.ObjectList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddProperty('hint', Hint, 'string');
    AddIntProperty('activepictureindex', ActivePictureIndex, 'pindex');
    AddIntProperty('activemaskpictureindex', ActiveMaskPictureIndex, 'pindex');
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
  with PE, TbsDataSkinObject(SkinData.ObjectList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    Hint := GetStrProperty('hint');
    ActivePictureIndex := GetIntProperty('activepictureindex');
    ActiveMaskPictureIndex := GetIntProperty('activemaskpictureindex');
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
  P: TbsProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  P.PropertyType := 'arect';
  with PE, TbsDataSkinMenuItem(SkinData.ObjectList.Items[Index]) do
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
    AddBolProperty('inactiveanimation', InActiveAnimation, 'boolean');
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
  DefSaveObject(Index);
  with PE, TbsDataSkinMenuItem(SkinData.ObjectList.Items[Index]) do
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
    InActiveAnimation := GetBolProperty('inactiveanimation');
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
  P: TbsProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  if P <> nil then P.PropertyType := 'arect';
  with PE, TbsDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
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
    AddBolProperty('inactiveanimation', InActiveAnimation, 'boolean');
  end;
  PE.Cells[0, 0] := '< mainmenubaritem >';
end;

procedure TSBForm.LoadMainMenuItem(Index: Integer);
var
  P: TbsProperty;
begin
  DefLoadObject(Index);
  P := PE.GetProperty('skinrect');
  if P <> nil then P.PropertyType := 'arect';
  P := PE.GetProperty('name');
  if P <> nil then P.PropertyType := 'fixedstring';
  with PE, TbsDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
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
    AddBolProperty('inactiveanimation', InActiveAnimation, 'boolean');
  end;
  PE.Cells[0, 0] := '< mainmenuitem >';
end;

procedure TSBForm.SaveMainMenuItem(Index: Integer);
begin
  DefSaveObject(Index);
  with PE, TbsDataSkinMainMenuItem(SkinData.ObjectList.Items[Index]) do
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
    InActiveAnimation := GetBolProperty('inactiveanimation');
  end;
end;

procedure TSBForm.SaveMainMenuBarItem(Index: Integer);
begin
  SaveMainMenuItem(Index);
end;

procedure TSBForm.LoadControl;
begin
  DefLoadControl(Index);
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinPanelControl
  then
    LoadPanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinExPanelControl
  then
    LoadExPanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinExPanelControl
  then
    LoadExPanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMenuButtonControl
  then
    LoadMenuButtonControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinButtonControl
  then
    LoadButtonControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinCheckRadioControl
  then
    LoadCheckRadioControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinGaugeControl
  then
    LoadGaugeControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
    TbsDataSkinSplitterControl
  then
    LoadSplitterControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTrackBarControl
  then
    LoadTrackBarControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinLabelControl
  then
    LoadLabelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinStdLabelControl
  then
    LoadStdLabelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinUpDownControl
  then
    LoadUpDownControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinGridControl
  then
    LoadGridControl(Index)
 else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTabControl
  then
    LoadTabControl(Index)
 else
 if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
    TbsDataSkinSlider
 then
   LoadSliderControl(Index)
 else
 if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinControlBar
  then
    LoadControlBar(Index)
 else
 if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMainMenuBar
  then
    LoadMainMenuBar(Index)
 else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinCheckListBox
  then
    LoadCheckListBoxControl(Index)
 else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinListBox
  then
    LoadListBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinComboBox
  then
    LoadComboBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMemoControl
  then
    LoadMemoControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinEditControl
  then
    LoadEditControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinScrollBarControl
  then
    LoadScrollBarControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinSpinEditControl
  then
    LoadSpinEditControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinScrollBoxControl
  then
    LoadScrollBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTreeView
  then
    LoadTreeViewControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinBevel
  then
    LoadBevelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinListView
  then
    LoadListViewControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinRichEdit
  then
    LoadRichEditControl(Index);
end;

procedure TSBForm.DefLoadControl;
begin
  with PE, TbsDataSkinControl(SkinData.CtrlList.Items[Index]) do
  begin
    DeleteProperties(True);
    AddProperty('name', IDName, 'string');
    AddIntProperty('pictureindex', PictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
    AddRectProperty('skinrect', SkinRect, 'rectctrl1');
  end;
end;

procedure TSBForm.DefLoadResizeControl(Index: Integer);
begin
  with PE, TbsDataSkinCustomControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddPointProperty('lefttoppoint', LTPoint, 'pointctrl2');
    AddPointProperty('righttoppoint', RTPoint, 'pointctrl2');
    AddPointProperty('leftbottompoint', LBPoint, 'pointctrl2');
    AddPointProperty('rightbottompoint', RBPoint, 'pointctrl2');
    AddRectProperty('clientrect', ClRect, 'rectctrl2');
    AddBolProperty('leftstretch', LeftStretch, 'boolean');
    AddBolProperty('topstretch', TopStretch, 'boolean');
    AddBolProperty('rightstretch', RightStretch, 'boolean');
    AddBolProperty('bottomstretch', BottomStretch, 'boolean');
    AddBolProperty('stretcheffect', StretchEffect, 'boolean');
    AddProperty('stretchtype', SetStretchType(StretchType), 'stretchtype');
  end;
end;

procedure TSBForm.LoadSplitterControl(Index: Integer);
var
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinSplitterControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    P := GetProperty('clientrect');
    P.PropertyType := 'fixed';
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    AddRectProperty('gripperrect', GripperRect, 'rectctrl1');
    AddBolProperty('grippertransparent', GripperTransparent, 'boolean');
    AddIntProperty('grippertransparentcolor', GripperTransparentColor, 'skincolor');
  end;
  PE.Cells[0, 0] := '< splitter >';  
end;

procedure TSBForm.LoadGaugeControl;
var
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinGaugeControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadUpDownControl;
begin
  with PE, TbsDataSkinUpDownControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadComboBoxControl;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinComboBox(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinCheckListBox(SkinData.CtrlList.Items[Index]) do
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
    AddProperty('bothhscrollbarname', BothScrollBarName, 'string');
    AddBolProperty('showfocus', ShowFocus, 'boolean');
    //
    AddRectProperty('buttonsarea', ButtonsArea, 'rectctrl2');
    AddRectProperty('disabledbuttonsrect', DisabledButtonsRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< checklistbox >';
end;

procedure TSBForm.LoadScrollBoxControl(Index: Integer);
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinScrollBoxControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddIntProperty('bgpictureindex', BGPictureIndex, 'pindex');
  end;
  PE.Cells[0, 0] := '< scrollbox >';
end;

procedure TSBForm.LoadListBoxControl;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinListBox(SkinData.CtrlList.Items[Index]) do
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
    AddProperty('vscrollbarname', VScrollBarName, 'string');
    AddProperty('hscrollbarname', HScrollBarName, 'string');
    AddProperty('bothhscrollbarname', BothScrollBarName, 'string');

    AddBolProperty('showfocus', ShowFocus, 'boolean');
    //
    AddRectProperty('buttonsarea', ButtonsArea, 'rectctrl2');
    AddRectProperty('disabledbuttonsrect', DisabledButtonsRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< listbox >';
end;

procedure TSBForm.LoadMainMenuBar(Index: Integer);
begin
  with PE, TbsDataSkinMainMenuBar(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinControlBar(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadBevelControl(Index: Integer);
var
  P: TbsProperty;
begin
  with PE, TbsDataSkinBevel(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  with PE, TbsDataSkinTreeView(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  with PE, TbsDataSkinListView(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  with PE, TbsDataSkinRichEdit(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadTabControl;
var
  P: TbsProperty;
begin
  with PE, TbsDataSkinTabControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadSliderControl;
var
  P: TbsProperty;
begin
  with PE, TbsDataSkinSlider(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinSlider(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadGridControl;
var
  P: TbsProperty;
begin
  with PE, TbsDataSkinGridControl(SkinData.CtrlList.Items[Index]) do
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
  end;
  PE.Cells[0, 0] := '< grid >';
end;

procedure TSBForm.SaveUpDownControl;
begin
  with PE, TbsDataSkinUpDownControl(SkinData.CtrlList.Items[Index]) do
  begin
    UpButtonRect := GetRectProperty('upbuttonrect');
    ActiveUpButtonRect := GetRectProperty('activeupbuttonrect');
    DownUpButtonRect := GetRectProperty('downupbuttonrect');
    DownButtonRect := GetRectProperty('downbuttonrect');
    ActiveDownButtonRect := GetRectProperty('activedownbuttonrect');
    DownDownButtonRect := GetRectProperty('downdownbuttonrect');
  end;
end;

procedure TSBForm.SaveComboBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinComboBox(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinCheckListBox(SkinData.CtrlList.Items[Index]) do
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
    BothScrollBarName := GetStrProperty('bothhscrollbarname');
    ShowFocus := GetBolProperty('showfocus');
    //
    ButtonsArea := GetRectProperty('buttonsarea');
    DisabledButtonsRect := GetRectProperty('disabledbuttonsrect');
  end;
end;

procedure TSBForm.SaveScrollBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinScrollBoxControl(SkinData.CtrlList.Items[Index]) do
  begin
    BGPictureIndex := GetIntProperty('bgpictureindex');
  end;
end;

procedure TSBForm.SaveListBoxControl;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinListBox(SkinData.CtrlList.Items[Index]) do
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
    BothScrollBarName := GetStrProperty('bothhscrollbarname');
    ShowFocus := GetBolProperty('showfocus');
    //
    ButtonsArea := GetRectProperty('buttonsarea');
    DisabledButtonsRect := GetRectProperty('disabledbuttonsrect');
  end;
end;

procedure TSBForm.SaveControlBar;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinControlBar(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinMainMenuBar(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.SaveBevelControl(Index: Integer);
begin
  with PE, TbsDataSkinBevel(SkinData.CtrlList.Items[Index]) do
  begin
    LightColor := GetIntProperty('lightcolor');
    DarkColor := GetIntProperty('darkcolor');
  end;
end;

procedure TSBForm.SaveTreeViewControl;
begin
  with PE, TbsDataSkinTreeView(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinListView(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinRichEdit(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    BGColor := GetIntProperty('bgcolor');
  end;
end;


procedure TSBForm.SaveTabControl;
begin
  with PE, TbsDataSkinTabControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinGridControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadTrackBarControl;
var
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinTrackBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('rightbottompoint');
    P.PropertyType := 'fixed';
    AddRectProperty('trackarea', TrackArea, 'rectctrl2');
    AddRectProperty('buttonrect', ButtonRect, 'rectctrl1');
    AddRectProperty('activebuttonrect', ActiveButtonRect, 'rectctrl1');
    AddBolProperty('vertical', Vertical, 'boolean');
    AddBolProperty('buttontransparent', ButtonTransparent, 'boolean');
    AddIntProperty('buttontransparentcolor', ButtonTransparentColor, 'skincolor');
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
  end;
  PE.Cells[0, 0] := '< trackbar >';
end;

procedure TSBForm.LoadCheckRadioControl;
var
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinCheckRadioControl(SkinData.CtrlList.Items[Index]) do
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
    AddRectProperty('unenabledcheckimagerect', UnEnabledCheckImageRect, 'rectctrl1');
    AddRectProperty('unenableduncheckimagerect', UnEnabledUnCheckImageRect, 'rectctrl1');
    AddRectProperty('grayedcheckimagerect', GrayedCheckImageRect, 'rectctrl1');
    AddRectProperty('activegrayedcheckimagerect', ActiveGrayedCheckImageRect, 'rectctrl1');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('framefontcolor', FrameFontColor, 'skincolor');
    AddIntProperty('unenabledfontcolor', UnEnabledFontColor, 'skincolor');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
  end;
  PE.Cells[0, 0] := '< checkradio >';
end;

procedure TSBForm.LoadMenuButtonControl;
var
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinMenuButtonControl(SkinData.CtrlList.Items[Index]) do
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
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('downskinrect', DownSkinRect, 'rectctrl1');
    AddRectProperty('disabledskinrect', DisabledSkinRect, 'rectctrl1');
    AddRectProperty('trackbuttonrect', TrackButtonRect, 'rectctrl2');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
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
  with PE, TbsDataSkinButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    AddRectProperty('activeskinrect', ActiveSkinRect, 'rectctrl1');
    AddRectProperty('downskinrect', DownSkinRect, 'rectctrl1');
    AddRectProperty('disabledskinrect', DisabledSkinRect, 'rectctrl1');
    AddRectProperty('focusedskinrect', FocusedSkinRect, 'rectctrl1');
    AddProperty('fontname', FontName, 'string');
    AddIntProperty('fontheight', FontHeight, 'int');
    AddFSProperty('fontstyle', FontStyle, 'fontstyle');
    AddIntProperty('fontcolor', FontColor, 'skincolor');
    AddIntProperty('activefontcolor', ActiveFontColor, 'skincolor');
    AddIntProperty('downfontcolor', DownFontColor, 'skincolor');
    AddIntProperty('disabledfontcolor', DisabledFontColor, 'skincolor');
    AddBolProperty('morphing', Morphing, 'boolean');
    AddProperty('morphkind', SetMorphKind(MorphKind), 'morphkind');
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
  end;
  PE.Cells[0, 0] := '< button >';
end;

procedure TSBForm.LoadExPanelControl(Index: Integer);
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinExPanelControl(SkinData.CtrlList.Items[Index]) do
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
  end;
  PE.Cells[0, 0] := '< expanel >';
end;

procedure TSBForm.LoadPanelControl;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinPanelControl(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  with PE, TbsDataSkinStdLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    P := GetProperty('pictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('maskpictureindex');
    P.PropertyType := 'fixed';
    P := GetProperty('skinrect');
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
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinLabelControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.LoadMemoControl;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinMemoControl(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinSpinEditControl(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinEditControl(SkinData.CtrlList.Items[Index]) do
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
  P: TbsProperty;
begin
  DefLoadResizeControl(Index);
  with PE, TbsDataSkinScrollBarControl(SkinData.CtrlList.Items[Index]) do
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
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinAnimate
  then
    LoadAnimate(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuBarItem
  then
    LoadMainMenuBarItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuItem
  then
    LoadMainMenuItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMenuItem
  then
    LoadMenuItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuBarButton
  then
    LoadMainMenuBarButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinStdButton
  then
    LoadStdButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinButton
  then
    LoadButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinCaption
  then
    LoadCaption(Index);
end;

procedure TSBForm.SaveControl(Index: Integer);
begin
  DefSaveControl(Index);
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinPanelControl
  then
    SavePanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinExPanelControl
  then
    SaveExPanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinExPanelControl
  then
    SaveExPanelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMenuButtonControl
  then
    SaveMenuButtonControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinButtonControl
  then
    SaveButtonControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinCheckRadioControl
  then
    SaveCheckRadioControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinGaugeControl
  then
    SaveGaugeControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinSplitterControl
  then
    SaveSplitterControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTrackBarControl
  then
    SaveTrackBarControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinLabelControl
  then
    SaveLabelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinStdLabelControl
  then
    SaveStdLabelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinUpDownControl
  then
    SaveUpDownControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinGridControl
  then
    SaveGridControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTabControl
  then
    SaveTabControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinSlider
  then
    SaveSliderControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMainMenuBar
  then
    SaveMainMenuBar(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinControlBar
  then
    SaveControlBar(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinCheckListBox
  then
    SaveCheckListBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinListBox
  then
    SaveListBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinComboBox
  then
    SaveComboBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinMemoControl
  then
    SaveMemoControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinEditControl
  then
    SaveEditControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinScrollBarControl
  then
    SaveScrollBarControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinSpinEditControl
  then
    SaveSpinEditControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinScrollBoxControl
  then
    SaveScrollBoxControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinTreeView
  then
    SaveTreeViewControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinBevel
  then
    SaveBevelControl(Index)
  else
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinListView
  then
    SaveListViewControl(Index)
  else  
  if TbsDataSkinControl(SkinData.CtrlList.Items[Index]) is
     TbsDataSkinRichEdit
  then
    SaveRichEditControl(Index);
end;

procedure TSBForm.DefSaveControl(Index: Integer);
begin
  with PE, TbsDataSkinControl(SkinData.CtrlList.Items[Index]) do
  begin
    IDName := GetStrProperty('name');
    PictureIndex := GetIntProperty('pictureindex');
    MaskPictureIndex := GetIntProperty('maskpictureindex');
    SkinRect := GetRectProperty('skinrect');
    Names.Items[Index] := IDName;
  end;
end;

procedure TSBForm.DefSaveResizeControl(Index: Integer);
begin
  with PE, TbsDataSkinCustomControl(SkinData.CtrlList.Items[Index]) do
  begin
    LTPoint := GetPointProperty('lefttoppoint');
    RTPoint := GetPointProperty('righttoppoint');
    LBPoint := GetPointProperty('leftbottompoint');
    RBPoint := GetPointProperty('rightbottompoint');
    ClRect :=  GetRectProperty('clientrect');
    LeftStretch := GetBolProperty('leftstretch');
    TopStretch := GetBolProperty('topstretch');
    RightStretch := GetBolProperty('rightstretch');
    BottomStretch := GetBolProperty('bottomstretch');
    StretchEffect := GetBolProperty('stretcheffect');
    StretchType := GetStretchType(GetStrProperty('stretchtype'));
  end;
end;

procedure TSBForm.SaveSplitterControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinSplitterControl(SkinData.CtrlList.Items[Index]) do
  begin
    GripperRect := GetRectProperty('gripperrect');
    GripperTransparent := GetBolProperty('grippertransparent');
    GripperTransparentColor := GetIntProperty('grippertransparentcolor');
  end;
end;

procedure TSBForm.SaveGaugeControl;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinGaugeControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinTrackBarControl(SkinData.CtrlList.Items[Index]) do
  begin
    TrackArea := GetRectProperty('trackarea');
    ButtonRect := GetRectProperty('buttonrect');
    ActiveButtonRect := GetRectProperty('activebuttonrect');
    Vertical := GetBolProperty('vertical');
    ButtonTransparent := GetBolProperty('buttontransparent');
    ButtonTransparentColor := GetIntProperty('buttontransparentcolor');
    ActiveSkinRect := GetRectProperty('activeskinrect');
  end;
end;

procedure TSBForm.SaveCheckRadioControl;
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinCheckRadioControl(SkinData.CtrlList.Items[Index]) do
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
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    FrameFontColor := GetIntProperty('framefontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    UnEnabledFontColor := GetIntProperty('unenabledfontcolor');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
  end;
end;

procedure TSBForm.SaveMenuButtonControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinMenuButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DownFontColor := GetIntProperty('downfontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    ActiveSkinRect := GetRectProperty('activeskinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    DisabledSkinRect := GetRectProperty('disabledskinrect');
    TrackButtonRect := GetRectProperty('trackbuttonrect');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
    ShowFocus := GetBolProperty('showfocus');
    MenuMarkerFlatRect := GetRectProperty('menumarkerflatrect');
    MenuMarkerTransparentColor := GetIntProperty('menumarkertransparentcolor');
  end;
end;

procedure TSBForm.SaveButtonControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinButtonControl(SkinData.CtrlList.Items[Index]) do
  begin
    ActiveSkinRect := GetRectProperty('activeskinrect');
    DownSkinRect := GetRectProperty('downskinrect');
    DisabledSkinRect := GetRectProperty('disabledskinrect');
    FocusedSkinRect := GetRectProperty('focusedskinrect');
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
    DownFontColor := GetIntProperty('downfontcolor');
    DisabledFontColor := GetIntProperty('disabledfontcolor');
    Morphing := GetBolProperty('morphing');
    MorphKind := GetMorphKind(GetStrProperty('morphkind'));
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
  with PE, TbsDataSkinStdLabelControl(SkinData.CtrlList.Items[Index]) do
  begin
    FontName := GetStrProperty('fontname');
    FontHeight := GetIntProperty('fontheight');
    FontStyle := GetFSProperty('fontstyle');
    FontColor := GetIntProperty('fontcolor');
    ActiveFontColor := GetIntProperty('activefontcolor');
  end;
end;

procedure TSBForm.SaveLabelControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinLabelControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinMemoControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinSpinEditControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinEditControl(SkinData.CtrlList.Items[Index]) do
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

procedure TSBForm.SaveScrollBarControl(Index: Integer);
begin
  DefSaveResizeControl(Index);
  with PE, TbsDataSkinScrollBarControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinExPanelControl(SkinData.CtrlList.Items[Index]) do
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
  with PE, TbsDataSkinPanelControl(SkinData.CtrlList.Items[Index]) do
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
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinAnimate
  then
    SaveAnimate(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuBarItem
  then
    SaveMainMenuBarItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuItem
  then
    SaveMainMenuItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMenuItem
  then
    SaveMenuItem(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinMainMenuBarButton
  then
    SaveMainMenuBarButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinStdButton
  then
    SaveStdButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinButton
  then
    SaveButton(Index)
  else
  if TbsDataSkinObject(SkinData.ObjectList.Items[Index]) is
     TbsDataSkinCaption
  then
    SaveCaption(Index);
end;

procedure TSBForm.LoadCtrlList;
var
  i: Integer;
begin
  Names.Clear;
  for i := 0 to SkinData.CtrlList.Count - 1 do
    Names.Items.Add(TbsDataSkinControl(SkinData.CtrlList.Items[i]).IDName);
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
    Names.Items.Add(TbsDataSkinObject(SkinData.ObjectList.Items[i]).IDName);
  if SkinData.ObjectList.Count <> 0
  then
    begin
      LoadObject(0);
      Names.ItemIndex := 0;
    end
  else
    PE.DeleteProperties(True);
end;

procedure TSBForm.IndexDialog(P: TbsProperty);
begin
  PIndexForm.Execute(P);
end;

procedure TSBForm.FSDialog(P: TbsProperty);
begin
  FSForm.Execute(P);
end;

procedure TSBForm.RectDialog21;
var
  B: TBitMap;
begin
  B := SkinData.FPicture;
  if not B.Empty
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        B.Canvas, R);
      ImageEditor.ExecuteAsGetRect(TempImage, P);
    end
  else
    ImageEditor.ExecuteAsGetRect(nil, P);
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
      ImageEditor.ExecuteAsGetRect(TempImage, P);
    end
  else
    ImageEditor.ExecuteAsGetRect(nil, P);
end;

procedure TSBForm.RectDialog1(Index: Integer; P: TbsProperty);
begin
  if Index <> -1
  then
    ImageEditor.ExecuteAsGetRect(SkinData.FActivePictures.Items[Index], P)
  else
    ImageEditor.ExecuteAsGetRect(nil, P);
end;

procedure TSBForm.RectDialog;
begin
  if ((P.PropertyType = 'rect') or (P.PropertyType = 'stdrect')) and not SkinData.FPicture.Empty
  then
    ImageEditor.ExecuteAsGetRect(SkinData.FPicture, P)
  else
  if (P.PropertyType = 'maskrect') and not SkinData.FMask.Empty
  then
    ImageEditor.ExecuteAsGetRect(SkinData.FMask, P);
end;

procedure TSBForm.PointDialog21;
var
  B: TBitMap;
begin
  B := SkinData.FPicture;
  if not B.Empty
  then
    begin
      TempImage := TBitMap.Create;
      TempImage.Width := R.Right - R.Left;
      TempImage.Height := R.Bottom - R.Top;
      TempImage.Canvas.CopyRect(Rect(0, 0, TempImage.Width, TempImage.Height),
        B.Canvas, R);
      ImageEditor.ExecuteAsGetPoint(TempImage, P);
    end
  else
    ImageEditor.ExecuteAsGetPoint(nil, P);
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
      ImageEditor.ExecuteAsGetPoint(TempImage, P);
    end
  else
    ImageEditor.ExecuteAsGetPoint(nil, P);
end;

procedure TSBForm.PointDialog1(Index: Integer; P: TbsProperty);
begin
  if Index <> -1
  then
    ImageEditor.ExecuteAsGetPoint(SkinData.FActivePictures.Items[Index], P)
  else
    ImageEditor.ExecuteAsGetPoint(nil, P);
end;

procedure TSBForm.PointDialog;
begin
  if (P.PropertyType = 'point') and not SkinData.FPicture.Empty
  then
    ImageEditor.ExecuteAsGetPoint(SkinData.FPicture, P)
  else
  if (P.PropertyType = 'maskpoint') and not SkinData.FMask.Empty
  then
    ImageEditor.ExecuteAsGetPoint(SkinData.FMask, P);
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

procedure TSBForm.LoadPWSection;
begin
  with PE, SkinData.PopupWindow do
  begin
    DeleteProperties(True);
    AddIntProperty('windowpictureindex', WindowPictureIndex, 'pindex');
    AddIntProperty('maskpictureindex', MaskPictureIndex, 'pindex');
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

procedure TSBForm.SavePWSection;
begin
  with PE, SkinData.PopupWindow do
  begin
    WindowPictureIndex := GetIntProperty('windowpictureindex');
    MaskPictureIndex :=  GetIntProperty('maskpictureindex');
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
  end;
  Names.Clear;
  with SkinData do
    for i := 0 to FActivePicturesNames.Count - 1 do
      Names.Items.Add(FActivePicturesNames[i]);
  PE.Cells[0, 0] := '< PICTURES >';
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
    AddIntProperty('borderwidth', BorderW, 'int');
    AddBolProperty('autorenderinginactiveimage', AutoRenderingInActiveImage, 'boolean');
    AddProperty('inactiveeffect', SetInActiveEffect(InActiveEffect), 'inactiveeffect');
    AddIntProperty('formminwidth', FormMinWidth, 'int');
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
    MDIBGPictureIndex := GetIntProperty('mdibgpictureindex');
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
    BorderW := GetIntProperty('borderwidth');
    FormMinWidth := GetIntProperty('formminwidth');
    AutoRenderingInActiveImage := GetBolProperty('autorenderinginactiveimage');
    InActiveEffect := GetInActiveEffect(GetStrProperty('inactiveeffect'));

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
    2: LoadFormInfoSection;
    3: LoadPWSection;
    4: LoadHWSection;
    5: LoadObjectList;
    6: LoadCtrlList;
    7: LoadColorsSection;
    8: LoadLFSection;
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

procedure TSBForm.FormCreate(Sender: TObject);
begin
  Changing := False;
  SectionList.ItemIndex := 0;
  LoadVersionSection;
  PE.ColWidths[1] := 200;
end;

procedure TSBForm.NamesClick(Sender: TObject);
var
  i: Integer;
begin
  if Names.Items.Count = 0 then Exit;
  case SectionList.ItemIndex of
   5: LoadObject(Names.ItemIndex);
   6: LoadControl(Names.ItemIndex);
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
   5:
    begin
      j := Names.ItemIndex;
      TbsDataSkinObject(SkinData.ObjectList.Items[j]).Free;
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
      TbsDataSkinControl(SkinData.CtrlList.Items[j]).Free;
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
    5: AddObjFrm.ShowModal;
    6: AddCtrlFrm.ShowModal;
  end;
end;

procedure TSBForm.PEEditProperty(P: TbsProperty);
var
  i: Integer;
  R: TRect;
  P1: TbsProperty;
begin
  if P.PropertyType = 'skincolor'
  then
    begin
      ExecuteColorDialog(P);
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
        RectDialog(P);
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
 if P.PropertyType = 'panelframetextrect'
  then
    begin
      I := PE.GetIntProperty('pictureindex');
      R := GetRect(PE.GetPropertyValue('framerect'));
      RectDialog2(I, R, P);
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
  if P.PropertyType = 'mask'
  then
    begin
      AddPicDlg.Execute(SkinData.FMask, P, P.Value, True);
      SkinData.FMaskName := P.Value;
    end
  else
  if P.PropertyType = 'inactivepicture'
  then
    begin
      AddPicDlg.Execute(SkinData.FInActivePicture, P, P.Value, True);
      SkinData.FInActivePictureName := P.Value;
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
  if (P.PropertyType = 'rect') or (P.PropertyType = 'maskrect')
  then
    begin
      RectDialog(P);
    end
  else
  if (P.PropertyType = 'point') or (P.PropertyType = 'maskpoint')
  then
    begin
      PointDialog(P)
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
      RectDialog21(R, P);
    end
  else
  if P.PropertyType = 'apoint12'
  then
    begin
      R := GetRect(PE.GetPropertyValue('skinrect'));
      PointDialog21(R, P);
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
     end;
  if SkinData.Empty and not SkinData.FPicture.Empty then SkinData.Empty := False;
  ApplyChanges;
  Changing := True;
end;

procedure TSBForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Changing
  then
    if MessageDlg('Save current skin?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      SaveSkin;
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

procedure TSBForm.TestFormButtonClick(Sender: TObject);
begin
  bsSkinHint1.SkinData := SkinData;
  TestFormEmpty := TTestFormEmpty.Create(Self);
  TestFormEmpty.ShowModal;
  TestFormEmpty.Free;
end;

procedure TSBForm.TestCtrlsButtonClick(Sender: TObject);
begin
  bsSkinHint1.SkinData := SkinData;
  TestFormCtrls := TTestFormCtrls.Create(Self);
  TestFormCtrls.ShowModal;
  TestFormCtrls.Free;
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
