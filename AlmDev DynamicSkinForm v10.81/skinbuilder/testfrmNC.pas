unit testfrmNC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DynamicSkinForm, SkinData, Menus, SkinCtrls, ExtCtrls, SkinBoxCtrls,
  StdCtrls, ComCtrls, SkinTabs, SkinGrids, SkinMenus, SkinHint, Mask,
  ToolWin, SkinExCtrls;

type
  TTestFormNC = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    MainMenu1: TMainMenu;
    Item11: TMenuItem;
    item12: TMenuItem;
    item21: TMenuItem;
    N1: TMenuItem;
    item31: TMenuItem;
    Item22: TMenuItem;
    Item13: TMenuItem;
    Item23: TMenuItem;
    Item32: TMenuItem;
    item33: TMenuItem;
    item14: TMenuItem;
    item24: TMenuItem;
    item34: TMenuItem;
    item41: TMenuItem;
    item51: TMenuItem;
    item61: TMenuItem;
    item71: TMenuItem;
    item81: TMenuItem;
    item91: TMenuItem;
    item101: TMenuItem;
    item111: TMenuItem;
    item121: TMenuItem;
    item141: TMenuItem;
    item142: TMenuItem;
    item151: TMenuItem;
    item161: TMenuItem;
    item171: TMenuItem;
    item181: TMenuItem;
    item191: TMenuItem;
    item201: TMenuItem;
    item211: TMenuItem;
    item221: TMenuItem;
    item231: TMenuItem;
    item241: TMenuItem;
    item251: TMenuItem;
    item261: TMenuItem;
    item271: TMenuItem;
    item281: TMenuItem;
    item291: TMenuItem;
    item301: TMenuItem;
    item311: TMenuItem;
    item321: TMenuItem;
    item25: TMenuItem;
    item341: TMenuItem;
    item351: TMenuItem;
    item361: TMenuItem;
    item371: TMenuItem;
    item381: TMenuItem;
    item391: TMenuItem;
    item401: TMenuItem;
    item411: TMenuItem;
    item421: TMenuItem;
    item431: TMenuItem;
    item441: TMenuItem;
    item451: TMenuItem;
    item461: TMenuItem;
    item471: TMenuItem;
    item481: TMenuItem;
    item491: TMenuItem;
    item501: TMenuItem;
    spSkinControlBar1: TspSkinControlBar;
    spSkinPanel7: TspSkinPanel;
    Bevel2: TBevel;
    spSkinButton5: TspSkinButton;
    spSkinButton9: TspSkinButton;
    spSkinMenuButton1: TspSkinMenuButton;
    spSkinMenuButton2: TspSkinMenuButton;
    item42: TMenuItem;
    toolpanel: TspSkinPanel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    toolbutton3: TspSkinButton;
    spSkinButton3: TspSkinButton;
    spSkinButton4: TspSkinButton;
    spSkinMenuButton3: TspSkinMenuButton;
    spSkinMenuButton4: TspSkinMenuButton;
    spSkinPageControl1: TspSkinPageControl;
    Tab1: TspSkinTabSheet;
    spSkinStdLabel1: TspSkinStdLabel;
    spSkinButton1: TspSkinButton;
    spSkinCheckRadioBox2: TspSkinCheckRadioBox;
    spSkinCheckRadioBox3: TspSkinCheckRadioBox;
    spSkinTrackBar1: TspSkinTrackBar;
    spSkinTrackBar2: TspSkinTrackBar;
    spSkinLabel1: TspSkinLabel;
    spSkinScrollBar1: TspSkinScrollBar;
    spSkinScrollBar2: TspSkinScrollBar;
    spSkinCheckRadioBox1: TspSkinCheckRadioBox;
    spSkinUpDown1: TspSkinUpDown;
    spSkinUpDown2: TspSkinUpDown;
    spSkinGauge2: TspSkinGauge;
    spSkinGauge1: TspSkinGauge;
    spSkinButton2: TspSkinButton;
    spSkinTabSheet4: TspSkinTabSheet;
    spSkinComboBox1: TspSkinComboBox;
    spSkinListBox1: TspSkinListBox;
    spSkinComboBox2: TspSkinComboBox;
    spSkinCheckListBox1: TspSkinCheckListBox;
    spSkinListBox2: TspSkinListBox;
    spSkinCheckListBox2: TspSkinCheckListBox;
    spSkinComboBox3: TspSkinComboBox;
    spSkinTabSheet5: TspSkinTabSheet;
    spSkinPanel1: TspSkinPanel;
    spSkinPanel2: TspSkinPanel;
    spSkinTabControl1: TspSkinTabControl;
    spSkinButton7: TspSkinButton;
    spSkinRadioGroup1: TspSkinRadioGroup;
    spSkinPanel3: TspSkinPanel;
    spSkinTabSheet3: TspSkinTabSheet;
    spSkinMemo1: TspSkinMemo;
    MemoVScrollBar: TspSkinScrollBar;
    spSkinEdit1: TspSkinEdit;
    spSkinEdit2: TspSkinEdit;
    spSkinSpinEdit2: TspSkinSpinEdit;
    spSkinMemo2: TspSkinMemo;
    spSkinScrollBar3: TspSkinScrollBar;
    Tab2: TspSkinTabSheet;
    statusbar: TspSkinPanel;
    spSkinStatusPanel2: TspSkinStatusPanel;
    spSkinGauge3: TspSkinGauge;
    spSkinStringGrid1: TspSkinStringGrid;
    GridVScrollBar: TspSkinScrollBar;
    GridHScrollBar: TspSkinScrollBar;
    spSkinBevel1: TspSkinBevel;
    spSkinStatusBar1: TspSkinStatusBar;
    spSkinEdit3: TspSkinEdit;
    spSkinEdit4: TspSkinEdit;
    spSkinSpinEdit1: TspSkinSpinEdit;
    spSkinComboBox4: TspSkinComboBox;
    spSkinToolBar1: TspSkinToolBar;
    spSkinEdit5: TspSkinEdit;
    spSkinEdit6: TspSkinEdit;
    spSkinSpinEdit3: TspSkinSpinEdit;
    spSkinComboBox5: TspSkinComboBox;
    spSkinTabSheet1: TspSkinTabSheet;
    spSkinCoolBar1: TspSkinCoolBar;
    spSkinPanel4: TspSkinPanel;
    spSkinPanel5: TspSkinPanel;
    spSkinCoolBar2: TspSkinCoolBar;
    spSkinPanel6: TspSkinPanel;
    spSkinPanel8: TspSkinPanel;
    spSkinToolBar2: TspSkinToolBar;
    spSkinSpeedButton1: TspSkinSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    spSkinMainMenuBar1: TspSkinMainMenuBar;
    spSkinButton6: TspSkinButton;
    spSkinAnimateGauge1: TspSkinAnimateGauge;
    Header1: TMenuItem;
    Groupitem11: TMenuItem;
    Groupitem21: TMenuItem;
    Groupitem31: TMenuItem;
    Item312: TMenuItem;
    Item322: TMenuItem;
    Item35: TMenuItem;
    procedure spSkinButton6Click(Sender: TObject);
    procedure spSkinPageControl1Close(Sender: TObject;
      var CanClose: Boolean);
  private
    { Private declarations }
    FAnimation: Boolean;
  public
    { Public declarations }
  end;

var
  TestFormNC: TTestFormNC;

implementation
 Uses SkinBuild;

{$R *.DFM}

procedure TTestFormNC.spSkinButton6Click(Sender: TObject);
begin
  if not FAnimation
  then
    begin
      FAnimation := True;
      spSkinGauge1.StartProgressAnimation;
      spSkinGauge2.StartProgressAnimation;
      spSkinAnimateGauge1.StartAnimation;
    end
  else
    begin
      FAnimation := False;
      spSkinGauge1.StopProgressAnimation;
      spSkinGauge2.StopProgressAnimation;
      spSkinAnimateGauge1.StopAnimation;
    end;
end;

procedure TTestFormNC.spSkinPageControl1Close(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
end;

end.
