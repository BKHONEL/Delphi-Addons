unit testfrmNCEmpty;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SkinData, DynamicSkinForm, Menus, SkinMenus;

type
  TTestFormNCEmpty = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinPopupMenu1: TspSkinPopupMenu;
    Item11: TMenuItem;
    Item21: TMenuItem;
    Item31: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestFormNCEmpty: TTestFormNCEmpty;

implementation
       Uses SkinBUild;
{$R *.DFM}

end.
