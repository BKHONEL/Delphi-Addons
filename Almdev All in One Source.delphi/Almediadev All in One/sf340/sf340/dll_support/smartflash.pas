{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       SmartFlash                                                  }
{       Version 3.35                                                }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit smartflash;

interface

uses ActiveX;

function LoadMovie(fileName: PChar; const Width, Height: integer): cardinal; stdcall;
procedure PlayMovie(const APlayer: cardinal); stdcall;
procedure StopMovie(const APlayer: cardinal); stdcall;
procedure GrabCurrentFrame(const APlayer: cardinal; var Bits: Pointer); stdcall;
procedure FreeMovie(var APlayer: cardinal); stdcall;

implementation

function LoadMovie(fileName: PChar; const Width, Height: integer): cardinal; stdcall; external 'smartflash.dll';
procedure PlayMovie(const APlayer: cardinal); stdcall; external 'smartflash.dll';
procedure StopMovie(const APlayer: cardinal); stdcall; external 'smartflash.dll';
procedure GrabCurrentFrame(const APlayer: cardinal; var Bits: Pointer); stdcall; external 'smartflash.dll';
procedure FreeMovie(var APlayer: cardinal); stdcall; external 'smartflash.dll';

initialization
  CoInitialize(nil);
end.
