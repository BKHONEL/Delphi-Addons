{       WAK Productions Presents:                               }
{       TRegware    version 4.00                                }
{       Copyright ©2003 - WAK Productions                       }
{       ---------------------------------                       }
{       Programmed by Winston Kotzan                            }
{       Email: wak@wakproductions.com                           }
{       Website URL: http://www.wakproductions.com/             }
{
This program helps developers of shareware include a timebomb/registration for
their program.  The end-user will enter a License ID and a serial number
(like Winzip).  If their registration information is correct, then the
program becomes registered.  TRegware hides data in the Windows registry
to check if program was registered.

If you have any difficulties using this component, suggestions, or compliments
about this component, I would be glad to hear them!  Please send an Email to
wak@wakproductions.com.  The more user responses received, the more TRegware can
be improved to keep it the best shareware security component for Delphi
developers!

IF YOU HAVE A TECHNICAL QUESTION, PLEASE READ FAQ.TXT BEFORE SENDING AN EMAIL.
THANK YOU!
}
(*
Updates
-------
02-23-03 -- Version 4.00
- NOTE THAT THE TREGWARE 4.00 ALGORITHM IS INCOMPATIBLE WITH PREVIOUS VERSIONS
- New and revised demo programs included in distribution package
Major revisions:
- New feature allows an expiration date to be included in the registration code.
  This would help prevent the illegal spread of codes over a period of time.  If
  a user enters a registration code beyond the expieration date, TRegware will
  not accept the code.
- Now uses completely different, more secure algorithm.  The registration code
  now consists of a combination of several code generating algorithms to make it
  harder for crackers to create keygens.
- The TRegware class can no longer generate its own registration codes.  To
  create registration codes use the TRegCodeGenerator class.  (See demo program)
- Now has option to use an expiration date in code.  Check the documentation
  for more information.
- Class name has been changed from TRegwareII to TRegware4 because of
  incompatibilities with past versions.
- The TRegware class no longer has the ability to generate registration codes.
  The program now uses the function named E89CE8E0 to verify codes.

Minor revisions:
- Removed hard drive serial number related LicenseSource options.  It was
  unreliable under Windows XP.
- If the registry data is corrupted or unrecognized TRegware sets itself
  unregistered

09-26-02 -- Version 3.22
- Fixed a small error with the clock-tamper feature.  The registry data needed
  to be resaved after checking for a clock tampering.  A call to
  SaveRegistryData() has been added to the Loaded() function to correct this.
- Clock-tamper feature now also checks the file creation timestamp on the file
  for added security.  The clock will be considered "tampered" if the system
  time is before the creation time of the program.

09-15-02 -- Version 3.20
- A set of compiler-time options are now available in the unit reg_opts.pas
  It is suggested to configure this file for each of your programs for
  greater security.  Please read the comments in reg_opts.pas for further
  description.
- Added Email property to contain user's email address. See DoRegistration()
  function documentation for details.
- Licensing options (LicenseType, LicenseSource properties) have been moved
  to a special class, TLicenseOptions.  They will now appear under the
  LicenseOptions property. LicenseOptions are only available in the
  professional edition.


08-09-02 -- Version 3.02 beta
- Fixed bug in GetLicenseID(), changed lines reading:
  "Registry.OpenKey('\Soft..." to "Registry.OpenKeyReadOnly('\Soft..."


06-30-02  --  Version 3.0 beta
- FSeed is now encrypted to protect from hackers.  To turn this option off,
  remove the '$DEFINE HIDE_SEED' line from regware2.pas.  Having this option
  on may cause TRegware to not recognize already existing registrations from
  previous versions.
- Windows 2000 / XP registry is now supported.  Information is stored
  under HKEY_CLASSES_ROOT for 2000/XP systems.
- New ban-list features allows you to ban certain users from using
  the next version of your software
- Added 1 second-delay for registration attempts to prevent cracking by
  brute-force.  This option does not have a property to disable it so that
  it is a little more difficult to patch.
- Added spaghetti code in CalculateCode() for the purpose of confusing hackers
- Option to use system-generated license id  (uses Windows system ID or hard drive serial #)
- Option to set site-licenses and single-user licenses.


06-28-01  --  Version 2.1  (no backwards compatibility)
-Fixed bug that caused program to improperly cut down registration codes that
 were longer RegCodeSize, causing the last number in some codes to be incorrect.
-New feature that detects when user sets clock backwards.  If the user tries
 setting his computer's clock to an earlier time, program will consider itself
 'expired'.  When the user puts his clock back within the remaining x days
 of his evaluation, the program will continue to operate as normal.


Quick Reference
---------------
Here is a sumamary of the usage of the variables in TRegInfo:

License -  Name of the user who registered program
Organization - Organization or company of user who registered program
ExpireTime - TDateTime value of when the program will expire
  (decimal portion is ignored)
LastCountDown - Number of days left of evaluation time, recorded when the program
  was last shut down (used to make sure that user does not set clock backwards)
RegVersion - Version of TRegware used for registry (for future expansion)
RegCode - After the program has been registered, this value contains the serial
  number derived from the License value
Email - Contains email address of user (implemented in version 4.0)
LicenseType - Site license or single-user license (implemented in version 3.0)


ExpX - Not in use - provided for future expansion



End-User License Agreement
--------------------------
By using this software, you are agreeing to the following terms:

1. Although this program has many precautions to secure your software from
 "crackers" and illegal registrations, like any security device there is no
 guarantee that it is 100% fullproof.  USE AT YOUR OWN RISK.

2. WAK Productions or any employee will not be held responsible for any
 illegal registrations of your program.

3. If you would like additional security beyond what is provided in TRegware,
  I suggest customizing the source code by changing the algorithm or using
  different compiler directives.  If you do make changes, it would be
  appeciated if you Email them to wak@wakproductions.com.  Thank you.

*)


 { TODO : Check ProgVersion field and make Seed numbers higher }
unit regware4;

interface

uses WinTypes, WinProcs, Messages, SysUtils, Classes, Controls,
     Forms, Graphics, Registry, ComObj, Dialogs;


const
  TREGWARE_VERSION='4.00';

{$i reg400_opts.pas}

type
  TLicenseType=(ltSiteLicense, ltSingleUserLicense);
  TLicenseTypes=set of TLicenseType;

  { Used for specifying how the License value is derived                }
  {                                                                     }
  { lsUserDefined - user defined license name                           }
  { lsWindowsID - uses the ProductID number of the Windows OS           }
  { lsWindowsIDMod - a processed version of the Windows ProductID       }
  TLicenseSource=(lsUserDefined, lsWindowsID, lsWindowsIDMod);

  {$IFDEF PACKED_RECORDS}
  TRegInfo = packed record
    rLicense, rOrganization, rRegCode, rEmail, Exp1, Exp2: string[100];
    rRegVersion: string[10];
    rLastCountDown, rLicenseType, Exp3, Exp4: integer;
    rExpireTime, Exp5: TDateTime;
  end;
  {$ELSE}
  TRegInfo = record
    rLicense, rOrganization, rRegCode, rEmail, Exp1, Exp2: string[100];
    rRegVersion: string[10];
    rLastCountDown, rLicenseType, Exp3, Exp4: integer;
    rExpireTime, Exp5: TDateTime;
  end;
  {$ENDIF}

  {$IFDEF PRO_VERSION}

  {INDY1 - This comment is only here for WAK Productions reference}

  TLicenseOptions=class(TPersistent)
    private
      FLicenseSource: TLicenseSource;
      FLicenseType: TLicenseType;
    public
      constructor Create;
    published
      property LicenseSource: TLicenseSource read FLicenseSource write FLicenseSource;
      property LicenseType: TLicenseType read FLicenseType write FLicenseType;
  end;
  {$ENDIF}  // end PRO_VERSION

  TRegware4 = class(TComponent)
    private
        FBanList: TStringList;
        FCheckTamper: boolean;
        FComponentVersion: string;
        FDays : Integer;
        FLastCountDown: integer;
        FEmail: string;
        FExpireTime: TDateTime;
        FLicense : String;  // Contains the LicenseID (only if LicenseSource is lsUserDefined)
        FLicenseOptions: TLicenseOptions;
        FMaxChars: integer;
        FMinChars: integer;
        FOrganization : String;
        FProgGUID : String;
        FRegCode: string;
        FRegCodeSize: integer;
        FSeed1: integer;
        FSeed2: integer;
        FSeed3: integer;
        FTimebomb : Boolean;
        FOnClockChange: TNotifyEvent;
        FOnExpire: TNotifyEvent;
        FOnNagScreen: TNotifyEvent;
        FRegVersion: string;

        {INDY2 - This comment is here for WAK Productions reference only }

        procedure AutoInitialize;
        procedure AutoDestroy;
        function GetDaysLeft : Integer;
        function GetExpired: boolean;
        function GetLicenseID: string;
        function GetRegistered : Boolean;
        function GetSeed1: integer;
        function GetSeed2: integer;
        function GetSeed3: integer;
        function CheckClockTampered: boolean; // Checks if user set clock backwards
        procedure CheckVariablesSet;
        procedure ClearLicenseInfo;
        procedure LoadRegistryValues;
        procedure SaveRegistryValues;
        procedure SetMaxChars(MaxChars: integer);
        procedure SetMinChars(MinChars: integer);
        procedure SetRegCodeSize(Value: integer);
        procedure SetSeed1(Value: integer);
        procedure SetSeed2(Value: integer);
        procedure SetSeed3(Value: integer);

    protected
        function CheckCodeBanned(RegCode: string; IgnoreDate: boolean): boolean;   // Checks if a registration code was banned
        function CheckForWinNT: boolean;  // Returns true if Windows NT/2000/XP
        function E89CE8E0(dcUserID, dcRegCode: string): string;
        procedure Expire;
        procedure ShowNag;
        procedure Loaded; override;
        procedure ClockChange;
        procedure SetBanList(Value: TStringList);

        {$IFDEF PRO_VERSION}
        {INDY10 - This note is for WAK Productions use only }
        {$ENDIF}

        procedure WndProc(var Msg: TMessage);  // Receives Windows messages
    public
      function CalculateCode(LicenseName: string): string;
      function CheckExpired: boolean;
      function CheckRegistered: boolean;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function DoRegistration(drLicenseID, drOrganization, drRegCode, drEmail: string): boolean; overload;
      function DoRegistration(drLicenseID, drOrganization, drRegCode: string): boolean; overload;
      procedure Reload;
      procedure SetUnregistered;
      property DaysLeft: Integer read GetDaysLeft;
      property Email: string read FEmail;
      property Expired: boolean read GetExpired;
      property LicenseID: string read GetLicenseID;
      property Organization : String read FOrganization;
      property RegCode : string read FRegCode;
      property Registered : Boolean read GetRegistered;
      property RegVersion: string read FRegVersion;

    published
      property OnClockChange: TNotifyEvent read FOnClockChange write FOnClockChange;
      property OnExpire: TNotifyEvent read FOnExpire write FOnExpire;
      property OnNagScreen: TNotifyEvent read FOnNagScreen write FOnNagScreen;
      property BanList: TStringList read FBanList write SetBanList;
      property CheckTamper: boolean read FCheckTamper write FCheckTamper default true;
      property ComponentVersion: string read FComponentVersion;
      property Days : Integer read FDays write FDays default 30;
      property MaxChars: integer read FMaxChars write SetMaxChars default 50;
      property MinChars: integer read FMinChars write SetMinChars default 5;
      property ProgGUID : String read FProgGUID write FProgGUID;
      property Seed1 : integer read GetSeed1 write SetSeed1 default 0;
      property Seed2 : integer read GetSeed2 write SetSeed2 default 0;
      property Seed3 : integer read GetSeed3 write SetSeed3 default 0;
      property RegCodeSize: integer read FRegCodeSize write SetRegCodeSize default 20;
      property Timebomb : Boolean read FTimebomb write FTimebomb default True;

      {$IFDEF PRO_VERSION}

      property LicenseOptions: TLicenseOptions read FLicenseOptions write FLicenseOptions;

      {INDY3 - This comment is here for WAK Productions reference only }

      {$ENDIF}
  end;


implementation

{INDY4 - This comment is here for WAK Productions reference only }

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  ModifiedTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, ModifiedTime);
  FileTimeToSystemTime(ModifiedTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

{ Checks for a valid GUID string }

function ValidateGUID(GUIDStr: string): boolean;
  { Check for hex character }
  function IsHex(AlphaNumChar: char): boolean;
  begin
    if ((Ord(AlphaNumChar) >= 48) and (Ord(AlphaNumChar) <= 57)) or
       ((Ord(AlphaNumChar) >= 65) and (Ord(AlphaNumChar) <= 70)) then
       Result := true
    else
      Result := false;
  end;

var
  i: integer;
begin
  Result := false;
  if Length(GUIDStr) <> 38 then Exit; // Not proper length
  for i := 1 to Length(GUIDStr) do
  begin
    // Check for valid letters and numbers
    if (i <> 1) and (i <> 10) and (i <> 15) and (i <> 20) and (i <> 25) and (i <> 38) then
    begin
      if not IsHex(GUIDStr[i]) then Exit;
    end else
      // Check for valid brackets
      if (i = 1) and (GUIDStr[i] <> '{') then Exit
        else if (i = 38) and (GUIDStr[i] <> '}') then Exit
          // Hyphens
          else if (i = 10) or (i = 15) or (i = 20) or (i = 25) then
            if (GUIDStr[i] <> '-') then Exit;
  end;
  Result := true;  // Ok, if all the above conditions checked;
end;

{------------------ TLicenseOptions/TServerOptions methods ------------------}

{$IFDEF PRO_VERSION}

constructor TLicenseOptions.Create;
begin
  inherited Create;
  FLicenseSource := lsUserDefined;
  FLicenseType := ltSingleUserLicense;
end;

{INDY5 - This comment is here for WAK Productions reference only}

{$ENDIF}

{------------------ TRegware4 methods ------------------}


{$IFDEF PRO_VERSION}

{------------------ TRegware4 Pro-version only functions ------------------}

{INDY6 - This comment is here for WAK Productions reference only}

{$ENDIF}  // end pro version

{------------------ TRegware4 methods (standard version) ------------------}

{ Method to set variable and property values and create objects }
procedure TRegware4.AutoInitialize;
begin
     FCheckTamper := true;
     FDays := 30;
     FMaxChars := 50;
     FMinChars := 5;
     FTimebomb := True;
end; { of AutoInitialize }

{ Method to free any objects created by AutoInitialize }
procedure TRegware4.AutoDestroy;
begin
end;

function TRegware4.E89CE8E0(dcUserID, dcRegCode: string): string;
var
  S1, S2: string;
  V1, V2, V3, C1, I1, I2: integer;
begin
  // This function is the registration code decryptor for TRegware4
  //
  // If the UserID matches RegCode, and the RegCode is not expired,
  // then it will return OK_CODE.  Otherwise, if the UserID does not match
  // the RegCode or RegCode is expired, it will return FAIL_CODE

  Result := FAIL_CODE;

  if (Length(dcUserID) > FMaxChars) or (Length(dcUserID) < FMinChars) then Exit;


  //------------- Check segment 1 (chars #1,3,5) ----------------------------
  S1 := dcRegCode[1] + dcRegCode[3];
  S2 := dcRegCode[5];
  V3 := Length(dcUserID);
  V1 := Ord(dcUserID[1]) + Ord(dcUserID[2]) + Ord(dcUserID[Trunc(V3 / 2)]) +
        Ord(dcUserID[V3]) + Ord(dcUserID[V3 - 1]);
  C1 := StrToIntDef('$' + S1, $FFFF);
  if C1 = $FFFF then Exit;
  if C1 <> ((FSeed1 mod V1) and $00FF) then Exit;

  // Character 5 is the length of User ID... 0 if greater than 16 characters
  C1 := StrToIntDef('$' + S2, $FFFF);
  if C1 = $FFFF then Exit;
  if C1 <> Length(dcUserID) then
    if (Length(dcUserID) > 16) and (C1 <> 0) then Exit;

  //------------- Check segment 2 (chars #7,9,11) ---------------------------
  S1 := dcRegCode[7] + dcRegCode[9] + dcRegCode[11];
  V1 := StrToIntDef('$' + S1, $FFFF);
  if V1 = $FFFF then Exit;
  C1 := 0;
  for I1 := 1 to Length(dcUserID) do
    C1 := C1 + Ord(dcUserID[I1]);
  V2 := (C1 shl 4 xor FSeed2) and $0FFF;
  if V2 <> V1 then Exit;

  //------------- Check segment 3 (chars #13...) ----------------------------
  if Length(dcRegCode) > 12 then
  begin
    S2 := '';
    V2 := 0;
    for I1 := 1 to Length(dcUserID) do
      V2 := V2 + Ord(dcUserID[I1]);
    V2 := V2 * ($7FFFFFF div V2);
    V1 := Length(dcRegCode) - 12;  // Number of chars trailing
    S1 := Copy(dcRegCode, 13, V1);
    I2 := 31;
    for I1 := 1 to 32 do
    begin
      // Rotates the bits in FSeed3 through shifting,
      // but bits that fall off are moved to the other end
      V3 := (FSeed3 shl I1) or (FSeed3 shr I2);
      V3 := abs(V3);
      if V3 > V2 then
        C1 := V3 mod V2
      else
        C1 := V2 mod V3;
      S2 := S2 + IntToHex($00000FFF and C1, 3);
      Dec(I2);
    end;
    S2 := Copy(S2, 1, RegCodeSize - 12);
    if CompareText(S1, S2) <> 0 then Exit;
  end;

  Result := OK_CODE;
end;

function TRegware4.GetDaysLeft : Integer;
begin
  if CheckClockTampered then // User tampered with clock
    Result := 0   // Consider program as expired
  else if (not Registered) and (Timebomb = true) then
  begin
    Result := Trunc(FExpireTime - Date);
    if Result < 0 then Result := 0;
  end
  else  // Clock not tampered and program registered
    Result := -1;
end;

function TRegware4.GetLicenseID: string;

  function GetWindowsID: string;
  var
    Registry: TRegistry;
  begin
    Registry := TRegistry.Create(KEY_WRITE);
    try
      Registry.Lazywrite := false;
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      if CheckForWinNT = true then
        Registry.OpenKeyReadOnly('\Software\Microsoft\Windows NT\CurrentVersion')
      else
        Registry.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion');
      Result := Registry.ReadString('ProductID');
      Registry.CloseKey;
    finally
      Registry.Free;
    end; // try..finally
  end;

  function EncryptID(ID: string): string;
  const
    CRYPT='1AZQS2XWCDXXXXXXX3E4RFVTBG56HYNJU7MKI8O9L0P';
  var
    i: integer;
  begin
    for i := 1 to Length(ID) do
    begin
      if ID[i] = '-' then
        Result := Result + '-'
      else
        Result := Result + CRYPT[Ord(ID[i]) - 47];
    end;
  end;

  function GetWindowsIDMod: string;
  begin
    Result := EncryptID(GetWindowsID);
  end;

begin
  {$IFDEF SITE_LICENSES}
  if LicenseType = ltSiteLicense then
  begin
    Result := FLicense;
    Exit;
  end;
  {$ENDIF}
  try
    case LicenseOptions.LicenseSource of
      lsUserDefined: Result := FLicense;
      lsWindowsID: Result := GetWindowsID;
      lsWindowsIDMod: Result := GetWindowsIDMod;
    end;
    Result := Copy(Result, 1, MaxChars);
  except
    Result := 'Error';
  end;
end;

function TRegware4.GetRegistered : Boolean;
begin
  Result := CheckRegistered;
end;

function TRegware4.GetSeed1: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed1 xor SEED_STORAGE1;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed1;
  {$ENDIF}
end;

function TRegware4.GetSeed2: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed2 xor SEED_STORAGE2;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed2;
  {$ENDIF}
end;

function TRegware4.GetSeed3: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed3 xor SEED_STORAGE3;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed3;
  {$ENDIF}
end;

procedure TRegware4.Reload;
begin
  Loaded;
end;

function TRegware4.CalculateCode(LicenseName: string): string;
var
  i, Code: integer;
  CodeStr: string;
  Num, SeedValue: Int64;
begin
  { THIS FUNCTION GENERATES REGISTRATION CODES FOR THE OBSOLETE VERSIONS
    (Versions 2.0 - 3.2) OF TREGWARE.  DO NOT USE THIS FUNCTION.

    IT HAS BEEN LEFT HERE ONLY TO CONFUSE SOFTWARE "CRACKERS"
  }


  if (Length(LicenseName) > FMaxChars) or (Length(LicenseName) < FMinChars) then
  begin
    Result := '';  // LicenseName did not fit length requirements
    Exit;
  end;
  SeedValue := FSeed1;

  {$IFDEF PERL_SEED}
  // Make FSeed smaller than 1x10^12 for compatibility with Perl script
  while SeedValue > 1000000000000 do SeedValue := SeedValue shr 1;
  {$ENDIF}

  i := Length(LicenseName);
  // Takes the last 6 characters (going backwards), converting each
  // character to ASCII and taking the remainder of dividing it into Seed
  while (i >= Length(LicenseName) - 6) and (i > 0) do
  begin
    CodeStr := CodeStr + IntToStr(SeedValue mod Ord(LicenseName[i]));
    Dec(i);
  end;
  Val(CodeStr, Num, Code);
  if FRegCodeSize <= 0 then
    Result := IntToHex(Num, 0)
  else begin
    Result := IntToHex(Num, FRegCodeSize);
    Delete(Result, FRegCodeSize + 1, Length(Result) - FRegCodeSize);
  end;
end;

function TRegware4.CheckForWinNT: boolean;
var
  VersionInfo: TOsVersionInfo;
begin
  Result := false;
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  if VersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
    if VersionInfo.dwMajorVersion >= 5 then Result := true;  // This is Win NT/2K/XP
end;

function TRegware4.CheckCodeBanned(RegCode: string; IgnoreDate: boolean): boolean;

  function StripDateInfo(Code: string): string;
  var
    i: integer;
  begin
    i := 12;
    while i > 1 do
    begin
      Delete(Code, i, 1);
      i := i - 2;
    end;
    Result := Code;
  end;

var
  i: integer;
begin
  Result := false;
  if IgnoreDate then
  begin
    for i := 0 to FBanList.Count - 1 do
      if CompareText(StripDateInfo(RegCode), StripDateInfo(FBanList[i])) = 0 then
      begin
        Result := true;
        break;
      end;
  end else
  begin
    for i := 0 to FBanList.Count - 1 do
      if CompareText(RegCode, FBanList[i]) = 0 then
      begin
        Result := true;
        break;
      end;
  end;
end;

{ Checks if time has expired }
function TRegware4.CheckExpired: boolean;
begin
  if GetDaysLeft = 0 then Result := true else Result := false;
end;

{ Checks if program is registered }
function TRegware4.CheckRegistered: boolean;
begin
  if (RegCode <> '') and (LicenseID <> '') then
  begin
    if (CompareStr(E89CE8E0(LicenseId, RegCode), OK_CODE) = 0) and
       (CheckCodeBanned(RegCode, true) = false)  then  // Also check if code is on the ban list
    begin
      Result := true;  // Reg Values check... program registered
    end else
    begin
      Result := false;  // Reg Values invalid... program not registered
      ClearLicenseInfo;
    end;
  end else Result := false;  // Values not there... program not registered
end;

procedure TRegware4.SetMaxChars(MaxChars: integer);
begin
  if (MaxChars > 100) or (MaxChars < MinChars) then
    raise Exception.Create('Please enter a number between ' +
      IntToStr(FMinChars) + ' and 100')
  else
    FMaxChars := MaxChars;
end;

procedure TRegware4.SetRegCodeSize(Value: integer);
begin
  if (Value < 12) or (Value > 108) then
    raise Exception.Create('In version 4.00 of TRegware (and higher), the registration ' +
        'code MUST be between 12 and 108 characters.')
  else
    FRegCodeSize := Value;
end;

constructor TRegware4.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF PRO_VERSION}
  FLicenseOptions := TLicenseOptions.Create;
  {INDY7 - This comment is here for WAK Productions reference only}
  {$ENDIF}
  FBanList := TStringList.Create;

  { Set default values }
  AutoInitialize;
  Seed1 := 0;
  Seed2 := 0;
  Seed3 := 0;
  FRegCodeSize := 20;
  FRegVersion := TREGWARE_VERSION;
end;

destructor TRegware4.Destroy;
begin
  AutoDestroy;
  FBanList.Free;
  {$IFDEF PRO_VERSION}
  FLicenseOptions.Free;
  {INDY8 - This comment is here for WAK Productions reference only }
  {$ENDIF}
  inherited Destroy;
end;

function TRegware4.DoRegistration(drLicenseID, drOrganization, drRegCode: string): boolean;
begin
  // This function is here for backwards compatibility.  The old DoRegistration()
  // did not accept an Email field.
  Result := DoRegistration(drLicenseID, drOrganization, drRegCode, '');
end;

function TRegware4.DoRegistration(drLicenseID, drOrganization, drRegCode, drEmail: string): boolean;
var
  I1, I2, I3: integer;
  S1, S2, S3: string;
  Year, Month, Day: Word;
  ExpDate: TDateTime;
  Tick: Cardinal;
begin
  // Delay 2 seconds to prevent brute-force cracking
  // Tick acts as a double-check in case a cracker tries bypassing the
  // sleep function.
  repeat
    Tick := GetTickCount;
    Sleep(2000);

  // Get the system generated LicenseID for LicenseName if not registering
  // a site license, or not a user-defined LicenseID
  //
  {$IFDEF SITE_LICENSES}
  if (LicenseOptions.LicenseType <> ltSiteLicense) and (LicenseOptions.LicenseSource <> lsUserDefined) then
    drLicenseID := LicenseID;
  {$ELSE}
  if LicenseOptions.LicenseSource <> lsUserDefined then
    drLicenseID := LicenseID;
  {$ENDIF}

  until GetTickCount >= Tick + 1999;


  if (Length(drLicenseID) > FMaxChars) or (Length(drLicenseID) < FMinChars) or (Length(drRegCode) = 0) then
  begin  // LicenseID is the incorrect size
    Result := false;
    Exit;
  end;

  drRegCode := UpperCase(drRegCode);  // Registration codes are not case sensitive

  Result := false;

  if CheckCodeBanned(drRegCode, true) then Exit;

  {$IFDEF CHECK_EXPIRATION}
    // The expiration date is encoded in characters 2, 4, 6, 8, 10, and 12
    S1 := drRegCode[2];  // character #2 contains the month
    S2 := drRegCode[10] + drRegCode[8];  // characters #4 and #6 contain the day
    S3 := drRegCode[4] + drRegCode[6] + drRegCode[12];  // chars #8, 10, 12 contain the year

    I1 := StrToIntDef('$' + S1, $FFFF);
    I2 := StrToIntDef('$' + S2, $FFFF);
    I3 := StrToIntDef('$' + S3, $FFFF);
    if (I1 or I2 or I3) = $FFFF then Exit;  // Failed on conversion

    Month := Word(I1 xor SEED_D and $000F);
    Day :=   Word(I2 xor SEED_D and $00FF);
    Year :=  Word(I3 xor SEED_D and $0FFF);

    ExpDate := EncodeDate(Year, Month, Day);
    {$IFDEF ALLOW_NOEXPIRE}
      if (ExpDate < Date) and (ExpDate <> 0) then Exit;  
    {$ELSE}
      if ExpDate < Date then Exit;
    {$ENDIF}
  {$ENDIF}
  if CompareStr(E89CE8E0(drLicenseId, drRegCode), OK_CODE) = 0 then Result := true else Result := false;

  if Result = true then
  begin  // LicenseID is correct for the entered registration code
    FLicense := drLicenseID;
    FOrganization := drOrganization;
    FRegCode := drRegCode;
    FEmail := drEmail;
    SaveRegistryValues;
    Result := true;
  end;
end;

procedure TRegware4.SetUnregistered;
begin
  ClearLicenseInfo;
  if Timebomb then
  begin
    FExpireTime := Date + FDays;
    FLastCountDown := FDays;
  end else
  begin
    FExpireTime := 0;
    FLastCountDown := FDays;
  end;
  SaveRegistryValues;
end;

procedure TRegware4.Expire;
begin
  if Assigned(FOnExpire) then FOnExpire(Self);
end;

procedure TRegware4.ShowNag;
begin
  if Assigned(FOnNagScreen) then FOnNagScreen(Self);
end;

procedure TRegware4.Loaded;
begin
  inherited;
  CheckVariablesSet;
  LoadRegistryValues;
  if (not Registered) and (CheckClockTampered) then
    ClockChange   // Signal event that the user has tried to change the clock (GetDaysLeft will automatically report that the program has expired)
  else if not Registered then
  begin
    ShowNag;
    SaveRegistryValues;  // We need to resave for the clock-tamper feature
    if CheckExpired = true then
      Expire;
  end;
end;

procedure TRegware4.SetBanList(Value: TStringList);
begin
  FBanList.Assign(Value);
end;

procedure TRegware4.WndProc(var Msg: TMessage);
begin
  { It is necessary to save the registry values on the program's termination
    so that it can be determined later if the user set his clock backwards via
    the LastCountDown property

    This cannot be done in the deconstructor because Delphi will execute
    the deconstructor when the project closes.  This will cause the registry
    values to be erased with blank material. }
  if Msg.Msg = WM_QUIT then SaveRegistryValues;
end;

procedure TRegware4.ClockChange;
begin
  if Assigned(FOnClockChange) then FOnClockChange(Self);
end;

function TRegware4.CheckClockTampered: boolean;
var
  DateDifference: integer;  // Difference between expiration date and now
  FileCreateTime: integer;
begin
  {$DEFINE CHECK_CREATETIME_TAMPER}
  Result := false;
  if FCheckTamper = true then
  begin
    DateDifference := Trunc(FExpireTime - Date);
    if DateDifference > FLastCountDown then // User set clock backwards
      Result := true;

    {$IFDEF CHECK_CREATETIME_TAMPER}
    try
      // Also check the file's creation time to detect possible tampering
      FileCreateTime := FileAge(Application.ExeName);
      if FileCreateTime <> -1 then
      begin
        //GetFileTime(FileHandle, @FileCreateTime, nil, nil);
        if (Date - Trunc(FileDateToDateTime(FileCreateTime)) < 0) then
          // Current system time is before file creation time
          Result := true;
      end;
    except
      // Don't do anything
    end;
    {$ENDIF}
  end;
end;

function TRegware4.GetExpired: boolean;
begin
  Result := CheckExpired;
end;

procedure TRegware4.SetSeed1(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed1 := Value xor SEED_STORAGE1;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed1 := Value;
  {$ENDIF}
end;

procedure TRegware4.SetSeed2(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed2 := Value xor SEED_STORAGE2;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed2 := Value;
  {$ENDIF}
end;

procedure TRegware4.SetSeed3(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed3 := Value xor SEED_STORAGE3;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed3 := Value;
  {$ENDIF}
end;

procedure TRegware4.SaveRegistryValues;
var
  RegData: TRegInfo;
  Registry: TRegistry;
begin
  if ValidateGUID(FProgGUID) = false then Exit;

  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.Lazywrite := false;
    if CheckForWinNT = true then
    begin
      Registry.RootKey := HKEY_CLASSES_ROOT;
      Registry.OpenKey('\CLSID\' + FProgGUID + '\Info', true);
    end else
    begin
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKey('\Software\CLASSES\CLSID\' + FProgGUID + '\Info', true);
    end;
    with RegData do
    begin
      rLicense := FLicense;
      rOrganization := FOrganization;
      rRegCode := FRegCode;
      rEmail := FEmail;
      rRegVersion := TREGWARE_VERSION;

      if not Registered then
      begin
        rLicenseType := 0;  // Not registered, so do not specify site license or single-user

        rExpireTime := Trunc(FExpireTime);
        if CheckClockTampered = false then
          rLastCountDown := Trunc(rExpireTime - Date)
        else
          rLastCountDown := FLastCountDown;   // Only save this value if clock is correct
      end else
      begin
        // Set whether we are using a site license or single-user license
        if LicenseOptions.LicenseType = ltSiteLicense then
          rLicenseType := SITE_LICENSE
        else
          rLicenseType := SINGLE_USER_LICENSE;

        rExpireTime := 0;
        rLastCountDown := 0;
      end; // if..then..else

    end; // with RegData do
      Registry.WriteBinaryData('Data', RegData, SizeOf(RegData));
      Registry.CloseKey;
  finally
    Registry.Free;
  end; // try..finally
end;

procedure TRegware4.ClearLicenseInfo;
begin
  // Clear the false values
  FLicense := '';
  FOrganization := '';
  FRegCode := '';
  FEmail := '';
end;

procedure TRegware4.SetMinChars(MinChars: integer);
begin
  if (MinChars > FMaxChars) or (MinChars < 5) then
    raise Exception.Create('Please enter a number between 5 and ' +
      IntToStr(FMaxChars));
  FMinChars := MinChars;
end;

procedure TRegware4.LoadRegistryValues;
var
  RegData: TRegInfo;
  Registry: TRegistry;
begin
  if ValidateGUID(FProgGUID) = false then Exit;

  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.Lazywrite := false;
    if CheckForWinNT = true then
    begin
      Registry.RootKey := HKEY_CLASSES_ROOT;
      Registry.OpenKeyReadOnly('\CLSID\' + FProgGUID + '\Info');
    end else
    begin
      Registry.RootKey := HKEY_LOCAL_MACHINE;
      Registry.OpenKeyReadOnly('\Software\CLASSES\CLSID\' + FProgGUID + '\Info');
    end;
    if Registry.ValueExists('Data') then
    begin
      try
        Registry.ReadBinaryData('Data', RegData, SizeOf(RegData));
      except
        on ERegistryException do
        begin
          SetUnregistered;
          MessageDlg('Error reading registration information!', mtError, [mbOK], 0);
          //raise;  // Remove this line in next version
        end;
      end;
      with RegData do
      begin
        FLicense := rLicense;
        FOrganization := rOrganization;
        FRegCode := rRegCode;
        FEmail := rEmail;
        FExpireTime := rExpireTime;
        FRegVersion := rRegVersion;
        FLastCountDown := rLastCountDown;

        if rLicenseType = SITE_LICENSE then
          LicenseOptions.LicenseType := ltSiteLicense
        else if rLicenseType = SINGLE_USER_LICENSE then
          LicenseOptions.LicenseType := ltSingleUserLicense
        else
        begin
          LicenseOptions.LicenseType := ltSingleUserLicense;  // Since it is neither value, that may hint some tampering with the value
          ClearLicenseInfo;
        end;
      end;
    end else
    begin
      SetUnregistered;
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end; // try..finally
end;

procedure TRegware4.CheckVariablesSet;
begin
  if ValidateGUID(FProgGUID) = false then
    ShowMessage('Mr. Programmer forgot to set the ProgGUID property to a ' +
      'valid GUID string!  Tsk, Tsk...');
  if (FSeed1 = 0) or (FSeed2 = 0) or (FSeed3 = 0) then
    ShowMessage('Mr. Programmer... you did not set the Seed properties properly!  Tsk, Tsk...');
end;



end.


