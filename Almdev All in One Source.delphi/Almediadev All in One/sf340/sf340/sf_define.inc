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


{.$DEFINE AL_DEBUG}

{$IFDEF WIN32}
  {$DEFINE AL_WIN}
{$ELSE}
  {$DEFINE AL_LINUX}
{$ENDIF}

{$IFDEF MSWINDOWS}
  {$DEFINE AL_WIN}
{$ENDIF}

{$IFDEF LINUX}
  {$DEFINE AL_LINUX}
{$ENDIF}

{$IFDEF AL_LINUX} { ================= LINUX Target ============================}

  {$IFDEF VER140}
    {$DEFINE AL_COMPILER6}

    {$DEFINE AL_KYLIX}
    {$DEFINE AL_KYLIX1}
  {$ENDIF}

{$ELSE} { =========================== Windows Target ==========================}

  {$IFDEF VER250}
  {$DEFINE VER200}
  {$ENDIF}


  {$IFDEF VER240}
  {$DEFINE VER200}
  {$ENDIF}

  {$IFDEF VER230}
  {$DEFINE VER200}
  {$ENDIF}

  {$IFDEF VER220}
  {$DEFINE VER200}
  {$ENDIF}
  
  {$IFDEF VER210}
  {$DEFINE VER200}
  {$ENDIF}

  {$IFDEF VER200}
    {$DEFINE AL_COMPILER11}
    {$DEFINE AL_DELPHI11}
    {$DEFINE AL_DELPHI}
  {$ENDIF}

  {$IFDEF VER180}
    {$DEFINE AL_COMPILER10}
    {$DEFINE AL_DELPHI10}
    {$DEFINE AL_DELPHI}
  {$ENDIF}
  
  {$IFDEF VER170}
    {$DEFINE AL_COMPILER9}
    {$DEFINE AL_DELPHI9}
    {$DEFINE AL_DELPHI}
  {$ENDIF}
  
  {$IFDEF VER150}
    {$DEFINE AL_COMPILER7}
    {$IFDEF BCB}
      {$DEFINE AL_CBUILDER7}
      {$DEFINE AL_CBUILDER}
    {$ELSE}
      {$DEFINE AL_DELPHI7}
      {$DEFINE AL_DELPHI}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER140}
    {$DEFINE AL_COMPILER6}
    {$IFDEF BCB}
      {$DEFINE AL_CBUILDER6}
      {$DEFINE AL_CBUILDER}
    {$ELSE}
      {$DEFINE AL_DELPHI6}
      {$DEFINE AL_DELPHI}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER130}
    {$DEFINE AL_COMPILER5}
    {$IFDEF BCB}
      {$DEFINE AL_CBUILDER5}
      {$DEFINE AL_CBUILDER}
    {$ELSE}
      {$DEFINE AL_DELPHI5}
      {$DEFINE AL_DELPHI}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VER125}
    {$DEFINE AL_COMPILER4}
    {$DEFINE AL_CBUILDER4}
    {$DEFINE AL_CBUILDER}
  {$ENDIF}

  {$IFDEF VER120}
    {$DEFINE AL_COMPILER4}
    {$DEFINE AL_DELPHI4}
    {$DEFINE AL_DELPHI}
  {$ENDIF}

  {$IFDEF AL_DELPHI11}
    {$DEFINE AL_DELPHI11_UP}
    {$DEFINE AL_DELPHI10_UP}
    {$DEFINE AL_DELPHI9_UP}
    {$DEFINE AL_DELPHI7_UP}
    {$DEFINE AL_DELPHI6_UP}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI10}
    {$DEFINE AL_DELPHI10_UP}
    {$DEFINE AL_DELPHI9_UP}
    {$DEFINE AL_DELPHI7_UP}
    {$DEFINE AL_DELPHI6_UP}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI9}
    {$DEFINE AL_DELPHI9_UP}
    {$DEFINE AL_DELPHI7_UP}
    {$DEFINE AL_DELPHI6_UP}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI7}
    {$DEFINE AL_DELPHI7_UP}
    {$DEFINE AL_DELPHI6_UP}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI6}
    {$DEFINE AL_DELPHI6_UP}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI5}
    {$DEFINE AL_DELPHI5_UP}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_DELPHI4}
    {$DEFINE AL_DELPHI4_UP}
  {$ENDIF}

  {$IFDEF AL_CBUILDER6}
    {$DEFINE AL_CBUILDER6_UP}
    {$DEFINE AL_CBUILDER5_UP}
    {$DEFINE AL_CBUILDER4_UP}
  {$ENDIF}

  {$IFDEF AL_CBUILDER5}
    {$DEFINE AL_CBUILDER5_UP}
    {$DEFINE AL_CBUILDER4_UP}
  {$ENDIF}

  {$IFDEF AL_CBUILDER4}
    {$DEFINE AL_CBUILDER4_UP}
  {$ENDIF}
{$ENDIF}

{ ------------ !! COMPILER COMPATIBLE !! ------------ }

{$IFDEF AL_COMPILER11}
  {$DEFINE AL_COMPILER11_UP}
  {$DEFINE AL_COMPILER10_UP}
  {$DEFINE AL_COMPILER9_UP}
  {$DEFINE AL_COMPILER7_UP}
  {$DEFINE AL_COMPILER6_UP}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER10}
  {$DEFINE AL_COMPILER10_UP}
  {$DEFINE AL_COMPILER9_UP}
  {$DEFINE AL_COMPILER7_UP}
  {$DEFINE AL_COMPILER6_UP}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER9}
  {$DEFINE AL_COMPILER9_UP}
  {$DEFINE AL_COMPILER7_UP}
  {$DEFINE AL_COMPILER6_UP}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER7}
  {$DEFINE AL_COMPILER7_UP}
  {$DEFINE AL_COMPILER6_UP}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER6}
  {$DEFINE AL_COMPILER6_UP}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER5}
  {$DEFINE AL_COMPILER5_UP}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{$IFDEF AL_COMPILER4}
  {$DEFINE AL_COMPILER4_UP}
{$ENDIF}

{ ------------ !! DO NOT CHANGE DEFINES BELOW THIS LINE !! ------------ }

{$IFDEF AL_CBUILDER}
  {$ObjExportAll On}
{$ENDIF}

{$ALIGN ON}
{$BOOLEVAL OFF}
{$LONGSTRINGS ON}
{$WRITEABLECONST ON}

{ ------------ !! DO NOT CHANGE DEFINES BELOW THIS LINE !! ------------ }

{$IFNDEF AL_DEBUG}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$V-} {- Var-String Checking }
{$T-} {- Typed @ operator }
{$X+} {- Extended syntax }
{$P+} {- Open string params }
{$J+} {- Enable writeable const}

{$IFDEF AL_COMPILER7}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
