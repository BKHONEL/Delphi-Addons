{*******************************************************************}
{                                                                   }
{       SkinAdapter                                                 }
{       DynamicSkinForm                                             }
{       Version 5.21                                                }
{                                                                   }
{       Copyright (c) 2005-2013 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit dsareg;

interface

uses
   Dialogs, Forms, Classes, SysUtils, Controls,
  {$IFNDEF  VER130} DesignEditors, DesignIntf {$ELSE} DsgnIntf {$ENDIF};

procedure Register;

implementation {===============================================================}

{$IFNDEF VER130}
{$IFNDEF VER185}
{$R *.dcr}
{$ENDIF}
{$ENDIF}

uses dsaadapter;

{ Register classes ============================================================}

type

  TdsSASkinDataNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TdsSAButtonSkinDataNameProperty = class(TdsSASkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TdsSAPanelSkinDataNameProperty = class(TdsSASkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  procedure TdsSASkinDataNameProperty.GetValueList(List: TStrings);
  begin
  end;

  procedure TdsSASkinDataNameProperty.GetValues(Proc: TGetStrProc);
  var
    I: Integer;
    Values: TStringList;
  begin
    Values := TStringList.Create;
    try
      GetValueList(Values);
      for I := 0 to Values.Count - 1 do Proc(Values[I]);
    finally
      Values.Free;
    end;
  end;

  function TdsSASkinDataNameProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paValueList, paMultiSelect];
  end;

  procedure TdsSAPanelSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('panel');
    List.Add('resizetoolpanel');
  end;


  procedure TdsSAButtonSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('resizebutton');
    List.Add('resizetoolbutton');
    List.Add('button');
  end;


procedure Register;
begin
  RegisterComponents('Skin Pack Tools', [TdsaSkinAdapter]);
  RegisterPropertyEditor(TypeInfo(string), TdsaSkinAdapter, 'ButtonSkinDataName', TdsSAButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdsaSkinAdapter, 'SpeedButtonSkinDataName', TdsSAButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdsaSkinAdapter, 'PanelSkinDataName', TdsSAPanelSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TdsaSkinAdapter, 'CoolBarSkinDataName', TdsSAPanelSkinDataNameProperty);
end;

end.

