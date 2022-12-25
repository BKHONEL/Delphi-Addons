unit testfrmNCEmpty;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SkinData, DynamicSkinForm;

type
  TTestFormNCEmpty = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
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
