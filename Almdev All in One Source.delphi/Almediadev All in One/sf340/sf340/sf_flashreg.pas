{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       SmartFlash                                                  }
{       Version 3.40                                                }
{                                                                   }
{       Copyright (c) 2000-2013 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit sf_flashreg;

{$I sf_define.inc}
{$T-,W-,X+,P+}

interface

uses
  SysUtils, Dialogs, Forms, Classes, Controls,
  {$IFDEF AL_COMPILER6_UP} DesignIntf, DesignEditors {$ELSE} DsgnIntf {$ENDIF};

procedure Register;

implementation {===============================================================}

{$IFNDEF AL_COMPILER5_UP}
{$R *.dcr}
{$ENDIF}

uses sf_Flash;

type

{ TsfFlashStreamProperty }

  TsfFlashStreamProperty = class(TPropertyEditor)
  private
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TsfFlashImageFileProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TsfFlashStreamProperty.Edit;
var
  OpenDialog: TOpenDialog;
begin
  { Execute editor }
  OpenDialog := TOpenDialog.Create(Application);
  OpenDialog.Filter := 'Flash file|*.swf|Flash video file|*.flv|Any data file|*.*';
  try
    if OpenDialog.Execute then
    begin
      TsfFlashStream(GetComponent(0)).Flash.LoadFromFile(OpenDialog.FileName);
      if TsfFlashStream(GetComponent(0)).Flash.Size > 0 then
        TsfFlashStream(GetComponent(0)).FFlashStore := ExtractFileName(OpenDialog.FileName);
    end;
    Modified;
  finally
    OpenDialog.Free;
  end;
end;

function TsfFlashStreamProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TsfFlashStreamProperty.GetValue: string;
begin
  Result := TsfFlashStream(GetComponent(0)).DisplayName;
end;


procedure TsfFlashImageFileProperty.Edit;
var
  FileOpen: TOpenDialog;
begin
  FileOpen := TOpenDialog.Create(Application);
  try
    FileOpen.Filename := '';
    FileOpen.InitialDir := ExtractFilePath(FileOpen.Filename);
    FileOpen.Filter := 'Flash bitmap with alpha channel|*.sfb';
    FileOpen.Options := FileOpen.Options + [ofHideReadOnly];
    if FileOpen.Execute then SetValue(FileOpen.Filename);
  finally
    FileOpen.Free;
  end;
end;

function TsfFlashImageFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog , paRevertable];
end;


{ Register classes ============================================================}

procedure Register;
begin
  RegisterComponents('SmartFlash', [TsfFlashPlayer, TsfFlashList,
                                    TsfLayeredFlashForm, TsfFlashImageList, TsfFlashImage]);
  RegisterPropertyEditor(TypeInfo(string), TsfFlashStream, 'FlashStore', TsfFlashStreamProperty);
  RegisterPropertyEditor(TypeInfo(string), TsfFlashImageItem, 'FlashImageFile', TsfFlashImageFileProperty);
end;

end.

