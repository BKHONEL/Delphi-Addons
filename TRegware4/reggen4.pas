{       WAK Productions Presents:                               }
{       TRegware    version 4.00                                }
{       Copyright ©2003 - WAK Productions                       }
{       ---------------------------------                       }
{       Programmed by Winston Kotzan                            }
{       Email: wak@wakproductions.com                           }
{       Website URL: http://www.wakproductions.com/             }
{
This unit contains the serial number generating code
in a class named TRegCodeGenerator4.
}
unit reggen4;

interface

uses WinTypes, WinProcs, Messages, SysUtils, Classes, Controls,
     Forms, Graphics, Registry, ComObj, Dialogs;

{$i reg400_opts.pas}

type
  TRegCodeGenerator4 = class(TComponent)
    private
        FMaxChars: integer;
        FMinChars: integer;
        FRegCodeSize: integer;
        FSeed1: integer;
        FSeed2: integer;
        FSeed3: integer;

        function GetSeed1: integer;
        function GetSeed2: integer;
        function GetSeed3: integer;
        procedure SetMaxChars(MaxChars: integer);
        procedure SetMinChars(MinChars: integer);
        procedure SetRegCodeSize(Value: integer);
        procedure SetSeed1(Value: integer);
        procedure SetSeed2(Value: integer);
        procedure SetSeed3(Value: integer);

    protected
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function GenerateCode(LicenseID: string; ExpireDate: TDate): string;

    published
      property MaxChars: integer read FMaxChars write SetMaxChars default 50;
      property MinChars: integer read FMinChars write SetMinChars default 5;
      property Seed1 : integer read GetSeed1 write SetSeed1 default 0;
      property Seed2 : integer read GetSeed2 write SetSeed2 default 0;
      property Seed3 : integer read GetSeed3 write SetSeed3 default 0;
      property RegCodeSize: integer read FRegCodeSize write SetRegCodeSize default 20;
  end;

function CheckCodeExpiration(RegCode: string): TDate;

implementation

function CheckCodeExpiration(RegCode: string): TDate;
var
  S1, S2, S3: string;
  I1, I2, I3: integer;
  Month, Day, Year: Word;
begin
    Result := 0;
    // The expiration date is encoded in characters 2, 4, 6, 8, 10, and 12
    S1 := RegCode[2];  // character #2 contains the month
    S2 := RegCode[10] + RegCode[8];  // characters #10 and #8 contain the day
    S3 := RegCode[4] + RegCode[6] + RegCode[12];  // chars #4, 6, 12 contain the year

    I1 := StrToIntDef('$' + S1, $FFFF);
    I2 := StrToIntDef('$' + S2, $FFFF);
    I3 := StrToIntDef('$' + S3, $FFFF);
    if (I1 or I2 or I3) = $FFFF then Exit;  // Failed on conversion

    Month :=   Word(I1 xor SEED_D and $000F);
    Day   :=   Word(I2 xor SEED_D and $00FF);
    Year  :=   Word(I3 xor SEED_D and $0FFF);

    Result := EncodeDate(Year, Month, Day);
end;

function TRegCodeGenerator4.GenerateCode(LicenseID: string; ExpireDate: TDate): string;
var
  S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, STMP: string;
  V1, V2, V3, I1, I2: integer;
  Month, Day, Year: Word;
begin
  Result := '';
  if (Length(LicenseID) > FMaxChars) or (Length(LicenseID) < FMinChars) then Exit;

  //---- Encode Expiration Date ------------------------------------------
  if ExpireDate > 0 then
  begin
    DecodeDate(ExpireDate, Year, Month, Day);
  end else
  begin
    // Make expiration date of 0/00/0000 (no expiration)
    DecodeDate(0, Year, Month, Day);
  end;

  V1 := integer(Month) xor SEED_D and $000F;
  V2 := integer(Day)   xor SEED_D and $00FF;
  V3 := integer(Year)  xor SEED_D and $0FFF;

  S2 := IntToHex(V1, 1);  // Encoded month

  STMP := IntToHex(V2, 4);  // Encoded day
  S10 := STMP[3];
  S8 := STMP[4];

  STMP := IntToHex(V3, 4);  // Encoded year
  S4 := STMP[2];
  S6 := STMP[3];
  S12 := STMP[4];

  //---- Encode Segment 1 (chars #1,3,5) ---------------------------------
  V3 := Length(LicenseID);
  V1 := Ord(LicenseID[1]) + Ord(LicenseID[2]) + Ord(LicenseID[Trunc(V3 / 2)]) +
        Ord(LicenseID[V3]) + Ord(LicenseID[V3 - 1]);
  //V1 := V1 div 4;
  V2 := (FSeed1 mod V1) and $00FF;
  STMP := IntToHex(V2, 4);
  S1 := STMP[3];
  S3 := STMP[4];

  V1 := Length(LicenseID);
  if V1 > 16 then STMP := '0000' else STMP := IntToHex(V1, 4);
  S5 := STMP[4];

  //---- Encode Segment 2 (chars #7,9,11) --------------------------------
  V1 := 0;
  for I1 := 1 to Length(LicenseID) do
    V1 := V1 + Ord(LicenseID[I1]);
  V1 := ((V1 shl 4 xor FSeed2) and $0FFF);
  STMP := IntToHex(V1, 4);
  S7 := STMP[2];
  S9 := STMP[3];
  S11 := STMP[4];

  //------------- Check segment 3 (chars #13...) ----------------------------
  V2 := 0;
  STMP := '';
  for I1 := 1 to Length(LicenseID) do
    V2 := V2 + Ord(LicenseID[I1]);
  V2 := V2 * ($7FFFFFF div V2);
  I2 := 31;
  for I1 := 1 to 32 do
  begin
    // Rotates the bits in FSeed3 through shifting,
    // but bits that fall off are moved to the other end
    V3 := (FSeed3 shl I1) or (FSeed3 shr I2) and $7FFFFFFF;
    V3 := abs(V3);
    if V3 > V2 then
      V1 := V3 mod V2
    else
      V1 := V2 mod V3;
    STMP := STMP + IntToHex($00000FFF and V1, 3);
    Dec(I2);
  end;
  // Take only the characters needed
  //Delete(STMP, RegCodeSize - 11, Length(STMP) - RegCodeSize - 11);
  S13 := Copy(STMP, 1, RegCodeSize - 12);

  Result := S1+S2+S3+S4+S5+S6+S7+S8+S9+S10+S11+S12+S13;
end;

function TRegCodeGenerator4.GetSeed1: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed1 xor SEED_STORAGE1;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed1;
  {$ENDIF}
end;

function TRegCodeGenerator4.GetSeed2: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed2 xor SEED_STORAGE2;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed2;
  {$ENDIF}
end;

function TRegCodeGenerator4.GetSeed3: integer;
begin
  {$IFDEF HIDE_SEED}
    Result := FSeed3 xor SEED_STORAGE3;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
    Result := FSeed3;
  {$ENDIF}
end;

procedure TRegCodeGenerator4.SetMaxChars(MaxChars: integer);
begin
  if (MaxChars > 100) or (MaxChars < MinChars) then
    raise Exception.Create('Please enter a number between ' +
      IntToStr(FMinChars) + ' and 100')
  else
    FMaxChars := MaxChars;
end;

procedure TRegCodeGenerator4.SetRegCodeSize(Value: integer);
begin
  if (Value < 12) or (Value > 108) then
    raise Exception.Create('In version 4.00 of TRegware (and higher), the registration ' +
        'code MUST be between 12 and 108 characters.')
  else
    FRegCodeSize := Value;
end;

constructor TRegCodeGenerator4.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { Set default values }
  FMaxChars := 50;
  FMinChars := 5;
  Seed1 := 0;
  Seed2 := 0;
  Seed3 := 0;
  FRegCodeSize := 20;
end;

destructor TRegCodeGenerator4.Destroy;
begin
  inherited Destroy;
end;

procedure TRegCodeGenerator4.SetSeed1(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed1 := Value xor SEED_STORAGE1;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed1 := Value;
  {$ENDIF}
end;

procedure TRegCodeGenerator4.SetSeed2(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed2 := Value xor SEED_STORAGE2;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed2 := Value;
  {$ENDIF}
end;

procedure TRegCodeGenerator4.SetSeed3(Value: integer);
begin
  {$IFDEF HIDE_SEED}
  if (Value > 1000) then
    FSeed3 := Value xor SEED_STORAGE3;  // This is to encrypt FSeed to hide from hackers
  {$ELSE}
  if (Value > 1000) then
    FSeed3 := Value;
  {$ENDIF}
end;

procedure TRegCodeGenerator4.SetMinChars(MinChars: integer);
begin
  if (MinChars > FMaxChars) or (MinChars < 5) then
    raise Exception.Create('Please enter a number between 5 and ' +
      IntToStr(FMaxChars));
  FMinChars := MinChars;
end;


end.


