unit testfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DynamicSkinForm, SkinData, Menus, SkinMenus;

type
  TTestForm = class(TForm)
    DsfTest: TspDynamicSkinForm;
    spSkinPopupMenu1: TspSkinPopupMenu;
    item11: TMenuItem;
    item21: TMenuItem;
    item31: TMenuItem;
    spSkinMainMenu1: TspSkinMainMenu;
    item12: TMenuItem;
    item13: TMenuItem;
    item22: TMenuItem;
    item32: TMenuItem;
    item23: TMenuItem;
    item14: TMenuItem;
    item24: TMenuItem;
    item33: TMenuItem;
    N1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestForm: TTestForm;

implementation
  Uses SkinBuild;
{$R *.DFM}

end.
