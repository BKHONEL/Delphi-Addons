{
  "RTC Types"
  - Copyright (c) 2010-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @exclude
}
unit rtcTypes;

{$INCLUDE rtcDefs.inc}

interface

const
  // Version of the RTC SDK components
  RTCSDK_VERSION='v5.15';

const
{$IFDEF WINDOWS}
  FOLDER_DELIMITER='\';
{$ELSE}
  FOLDER_DELIMITER='/';
{$ENDIF}

type
{$IFDEF RTC_noWideUString}
  UString = String;
  UChar = Char;
  {$IFDEF UNICODE}
    UWideChar = Char;
  {$ELSE}
    UWideChar = WideChar;
  {$ENDIF}
{$ELSE}
  {$IFDEF UNICODE}
    UString = String;
    UChar = Char;
    UWideChar = Char;
  {$ELSE}
    UString = WideString;
    UChar = WideChar;
    UWideChar = WideChar;
  {$ENDIF}
{$ENDIF}

{$IF Defined(CPUX64)}
  RtcIntPtr = NativeUInt; // uint64;
  {$IFDEF WINDOWS}
    RtcThrID = longword;
  {$ELSE}
    RtcThrID = TThreadID;
  {$ENDIF}
{$ELSEIF Defined(CPUX32)}
  RtcIntPtr = longword;
  RtcThrID = longword;
{$ELSEIF Defined(CPUARM)}
  RtcIntPtr = longword;
  RtcThrID = longword;
{$ELSEIF Defined(FPC)}
  RtcIntPtr = uint64;
  RtcThrID = TThreadID;
{$ELSE}
  {$message error 'rtcTypes: Unknown POINTER Type'}
{$IFEND}

implementation
end.