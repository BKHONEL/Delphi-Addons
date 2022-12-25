{
  "Fast Huge String manipulation and search classes"
   - Copyright (c) 2004-2012 by Danijel Tkalcec (http://www.realthinclient.com)
  @exclude
}

unit rtcFastStrings;

{$include rtcDefs.inc}

interface

uses
  rtcTypes,
  memStrIntList, memStringIntList,
  SysUtils, Classes;

const
  RTC_STROBJ_SHIFT = 4; // = 16
  RTC_STROBJ_PACK = 1 shl RTC_STROBJ_SHIFT;
  RTC_STROBJ_AND = RTC_STROBJ_PACK-1;

type
  tRtcStrRec=record
    str:AnsiString;
    siz:integer;
    end;
  tRtcStrArr=array[0..RTC_STROBJ_PACK-1] of tRtcStrRec;
  PRtcStrArr=^tRtcStrArr;
  tRtcStrArray=array of PRtcStrArr;

  TRtcHugeString=class
  private
    FData:tRtcStrArray;
    FPack:PRtcStrArr;

    FDataCnt,
    FPackCnt,
    FPackFree,
    FPackLoc:integer;

    FCount:integer;
    FSize:int64;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure Add(const s:AnsiString);
    function Get:AnsiString;

    property Size:int64 read FSize;
    end;

  tRtcStrObjRec=record
    str:AnsiString;
    obj:TObject;
    end;
  tRtcStrObjArr=array[0..RTC_STROBJ_PACK-1] of tRtcStrObjRec;
  PRtcStrObjArr=^tRtcStrObjArr;

  tRtcStrObjArray=array of PRtcStrObjArr;

  tRtcFastStrObjList=class
  private
    FData:tRtcStrObjArray; // array of PRtcStrObjArr;
    FPack:PRtcStrObjArr;
    Tree:TStrIntList;

    FDataCnt, 
    FPackCnt:integer;
    FCnt:integer;
    FOnChange: TNotifyEvent;

    function GetName(const index: integer): AnsiString;
    function GetValue(const index: integer): TObject;
    procedure SetName(const index: integer; const _Value: AnsiString);
    procedure SetValue(const index: integer; const _Value: TObject);
    function GetCount: integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure DestroyObjects;

    function Add(const Name:AnsiString; _Value:TObject=nil):integer;
    function Find(const Name:AnsiString):integer;
    function IndexOf(const Name:AnsiString):integer;

    // Case-sensitive Add, Find and IndexOf
    function AddCS(const Name:AnsiString; _Value:TObject=nil):integer;
    function FindCS(const Name:AnsiString):integer;
    function IndexOfCS(const Name:AnsiString):integer;

    property Objects[const index:integer]:TObject read GetValue write SetValue;
    property Strings[const index:integer]:AnsiString read GetName write SetName;

    property Count:integer read GetCount;

    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    end;

  tRtcStringObjRec=record
    str:UString;
    obj:TObject;
    end;
  tRtcStringObjArr=array[0..RTC_STROBJ_PACK-1] of tRtcStringObjRec;
  PRtcStringObjArr=^tRtcStringObjArr;

  tRtcStringObjArray=array of PRtcStringObjArr;

  tRtcFastStringObjList=class
  private
    FData:tRtcStringObjArray; // array of PRtcStringObjArr;
    FPack:PRtcStringObjArr;
    Tree:TStringIntList;

    FDataCnt,
    FPackCnt:integer;
    FCnt:integer;
    FOnChange: TNotifyEvent;

    function GetName(const index: integer): UString;
    function GetValue(const index: integer): TObject;
    procedure SetName(const index: integer; const _Value: UString);
    procedure SetValue(const index: integer; const _Value: TObject);
    function GetCount: integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure DestroyObjects;

    function Add(const Name:UString; _Value:TObject=nil):integer;
    function Find(const Name:UString):integer;
    function IndexOf(const Name:UString):integer;

    // Case-sensitive Add, Find and IndexOf
    function AddCS(const Name:UString; _Value:TObject=nil):integer;
    function FindCS(const Name:UString):integer;
    function IndexOfCS(const Name:UString):integer;

    property Objects[const index:integer]:TObject read GetValue write SetValue;
    property Strings[const index:integer]:UString read GetName write SetName;

    property Count:integer read GetCount;

    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    end;

{$IFDEF UNICODE}
function UpperCase(const s:AnsiString):AnsiString; overload;
function Trim(const S: AnsiString): AnsiString; overload;
{$ENDIF}

function Upper_Case(const s:AnsiString):AnsiString;
function UpperCaseStr(const s:UString):UString;

function Same_Text(const s1,s2:AnsiString):boolean;

implementation

{$IFDEF Unicode}
function UpperCase(const s:AnsiString):AnsiString; overload;
  var
    i:integer;
    c,d:^AnsiChar;
  begin
  i:=length(s);
  if i>0 then
    begin
    SetLength(Result,i);
    c:=@(s[1]);
    d:=@(Result[1]);
    for i:=1 to i do
      begin
      if (c^>='a') and (c^<='z') then
        d^:=AnsiChar(Ord(c^) - 32)
      else
        d^:=c^;
      Inc(d);
      Inc(c);
      end;
    end
  else
    Result:='';
  end;

function Trim(const S: AnsiString): AnsiString; overload;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;
{$ENDIF}

function Upper_Case(const s:AnsiString):AnsiString;
  var
    i:integer;
    c,d:^AnsiChar;
  begin
  i:=length(s);
  if i>0 then
    begin
    SetLength(Result,i);
    c:=@(s[1]);
    d:=@(Result[1]);
    for i:=1 to i do
      begin
      if (c^>='a') and (c^<='z') then
        d^:=AnsiChar(Ord(c^) - 32)
      else
        d^:=c^;
      Inc(d);
      Inc(c);
      end;
    end
  else
    Result:='';
  end;

function Same_Text(const s1,s2:AnsiString):boolean;
  var
    i:integer;
    c,d:^AnsiChar;
    e,f:AnsiChar;
  begin
  i:=length(s1);
  if i<>length(s2) then
    Result:=False
  else if i>0 then
    begin
    Result:=True;
    c:=@(s1[1]);
    d:=@(s2[1]);
    for i:=1 to i do
      begin
      if (c^>='a') and (c^<='z') then
        e:=AnsiChar(Ord(c^) - 32)
      else
        e:=c^;
      if (d^>='a') and (d^<='z') then
        f:=AnsiChar(Ord(d^) - 32)
      else
        f:=d^;
      if e<>f then
        begin
        Result:=False;
        Break;
        end;
      Inc(d);
      Inc(c);
      end;
    end
  else
    Result:=True;
  end;

function UpperCaseStr(const s:UString):UString;
  var
    i:integer;
    c,d:^UChar;
  begin
  i:=length(s);
  if i>0 then
    begin
    SetLength(Result,i);
    c:=@(s[1]);
    d:=@(Result[1]);
    for i:=1 to i do
      begin
      if (c^>='a') and (c^<='z') then
        d^:=UChar(Ord(c^) - 32)
      else
        d^:=c^;
      Inc(d);
      Inc(c);
      end;
    end
  else
    Result:='';
  end;

{ TRtcHugeString }

constructor TRtcHugeString.Create;
  begin
  inherited;

  FPack:=nil;
  SetLength(FData,0);
  FDataCnt:=0;

  New(FPack);
  FillChar(FPack^,SizeOf(FPack^),0);

  FPackCnt:=0;
  FPackFree:=0;
  FPackLoc:=0;

  FCount:=0;
  FSize:=0;
  end;

destructor TRtcHugeString.Destroy;
  begin
  Clear;
  if FPack<>nil then Dispose(FPack);
  inherited;
  end;

procedure TRtcHugeString.Clear;
  var
    a,b:integer;
    FPack2:PRtcStrArr;
  begin
  if FDataCnt>0 then
    begin
    for a:=0 to FDataCnt-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        FPack2^[b].str:='';
      Dispose(FPack2);
      end;
    SetLength(FData,0);
    FDataCnt:=0;
    end;

  if FPackCnt>0 then
    begin
    for b:=0 to FPackCnt-1 do
      FPack^[b].str:='';
    FPackCnt:=0;
    FPackFree:=0;
    FPackLoc:=0;
    end;

  FSize:=0;
  FCount:=0;
  end;

procedure TRtcHugeString.Add(const s: AnsiString);
  var
    len:integer;
  procedure GrowHugeStringList;
    begin
    if length(FData)<=FDataCnt then
      SetLength(FData, FDataCnt + RTC_STROBJ_PACK);
    FData[FDataCnt]:=FPack;
    Inc(FDataCnt);

    New(FPack);
    FillChar(FPack^,SizeOf(FPack^),0);
    FPackCnt:=0;
    end;
  begin
  len:=length(s);
  if len>0 then
    begin
    FSize:=FSize + len;

    if FPackFree>=len then
      begin
      with FPack^[FPackCnt-1] do
        begin
        Move(s[1], str[FPackLoc], len);
        Inc(siz, len);
        end;
      Inc(FPackLoc,len);
      Dec(FPackFree,len);
      end
    else
      begin
      if FPackCnt>=RTC_STROBJ_PACK then
        GrowHugeStringList;

      if len>=255 then
        begin
        with FPack^[FPackCnt] do
          begin
          str:=s;
          siz:=len;
          end;
        FPackFree:=0;
        FPackLoc:=0;
        end
      else
        begin
        with FPack^[FPackCnt] do
          begin
          SetLength(str, 290);
          Move(s[1],str[1],len);
          siz:=len;
          end;
        FPackFree:=290-len;
        FPackLoc:=len+1;
        end;
      Inc(FPackCnt);
      Inc(FCount);
      end;
    end;
  end;

function TRtcHugeString.Get: AnsiString;
  var
    a,b,loc:integer;
    FPack2:PRtcStrArr;
  begin
  if FCount>1 then
    begin
    SetLength(Result, FSize);
    loc:=1;

    for a:=0 to FDataCnt-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        with FPack2^[b] do
          begin
          Move(str[1], Result[loc], siz);
          Inc(loc, siz);
          end;
      end;

    for b:=0 to FPackCnt-1 do
      with FPack^[b] do
        begin
        Move(str[1], Result[loc], siz);
        Inc(loc, siz);
        end;

    if loc<>FSize+1 then
      raise Exception.Create('Internal Huge AnsiString error.');
    end
  else if FCount>0 then
    begin
    with FPack^[0] do
      begin
      SetLength(Result, siz);
      Move(str[1], Result[1], siz);
      end;
    end
  else
    Result:='';
  end;

{ tRtcFastStrObjList }

constructor tRtcFastStrObjList.Create;
  begin
  inherited;
  FPack:=nil;
  Tree:=tStrIntList.Create(RTC_STROBJ_PACK);

  SetLength(FData,0);
  New(FPack);
  FillChar(FPack^,SizeOf(FPack^),0);

  FCnt:=0;
  FDataCnt:=0;
  FPackCnt:=0;
  end;

destructor tRtcFastStrObjList.Destroy;
  begin
  Clear;
  if FPack<>nil then Dispose(FPack);
  FreeAndNil(Tree);
  inherited;
  end;

procedure tRtcFastStrObjList.Clear;
  var
    a,b:integer;
    FPack2:PRtcStrObjArr;
  begin
  if self=nil then Exit;
  
  if FPackCnt>0 then
    begin
    for b:=0 to FPackCnt-1 do
      with FPack^[b] do
        begin
        str:='';
        obj:=nil;
        end;
    FPackCnt:=0;
    end;

  if FDataCnt>0 then
    begin
    for a:=0 to FDataCnt-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        with FPack2^[b] do
          begin
          str:='';
          obj:=nil;
          end;
      Dispose(FPack2);
      end;
    SetLength(FData,0);
    FDataCnt:=0;
    end;

  if assigned(Tree) then
    Tree.removeall;
  FCnt:=0;

  if assigned(FOnChange) then FOnChange(self);
  end;

procedure tRtcFastStrObjList.DestroyObjects;
  var
    a,b,c:integer;
    FPack2:PRtcStrObjArr;
  begin
  if self=nil then Exit;

  if FPackCnt>0 then
    begin
    c:=FPackCnt;
    FPackCnt:=0;
    for b:=0 to c-1 do
      with FPack^[b] do
        begin
        str:='';
        obj.Free;
        end;
    end;

  if FDataCnt>0 then
    begin
    c:=FDataCnt;
    FDataCnt:=0;
    for a:=0 to c-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        with FPack2^[b] do
          begin
          str:='';
          obj.Free;
          end;
      Dispose(FPack2);
      end;
    SetLength(FData,0);
    end;

  if assigned(Tree) then
    Tree.removeall;
  FCnt:=0;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStrObjList.Add(const Name: AnsiString; _Value:TObject=nil): integer;
  procedure GrowStrObjList;
    begin
    if length(FData)<=FDataCnt then
      SetLength(FData, FDataCnt + RTC_STROBJ_PACK);
    FData[FDataCnt]:=FPack;
    Inc(FDataCnt);

    New(FPack);
    FillChar(FPack^,SizeOf(FPack^),0);
    FPackCnt:=0;
    end;
  begin
  if FPackCnt>=RTC_STROBJ_PACK then
    GrowStrObjList;

  Tree.insert(Upper_Case(Name), FCnt);
  with FPack[FPackCnt] do
    begin
    str:=Name;
    obj:=_Value;
    end;
  Inc(FPackCnt);
  Inc(FCnt);

  Result:=FCnt-1;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStrObjList.Find(const Name: AnsiString): integer;
  begin
  Result:=Tree.search(Upper_Case(Name));
  end;

function tRtcFastStrObjList.IndexOf(const Name: AnsiString): integer;
  begin
  Result:=Tree.search(Upper_Case(Name));
  end;

function tRtcFastStrObjList.AddCS(const Name: AnsiString; _Value:TObject=nil): integer;
  begin
  if FPackCnt>=RTC_STROBJ_PACK then
    begin
    if length(FData)<=FDataCnt then
      SetLength(FData, FDataCnt + RTC_STROBJ_PACK);
    FData[FDataCnt]:=FPack;
    Inc(FDataCnt);

    New(FPack);
    FillChar(FPack^,SizeOf(FPack^),0);
    FPackCnt:=0;
    end;

  Tree.insert(Name, FCnt);
  with FPack[FPackCnt] do
    begin
    str:=Name;
    obj:=_Value;
    end;
  Inc(FPackCnt);
  Inc(FCnt);

  Result:=FCnt-1;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStrObjList.FindCS(const Name: AnsiString): integer;
  begin
  Result:=Tree.search(Name);
  end;

function tRtcFastStrObjList.IndexOfCS(const Name: AnsiString): integer;
  begin
  Result:=Tree.search(Name);
  end;

function tRtcFastStrObjList.GetName(const index: integer): AnsiString;
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    Result:=FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].str
  else
    Result:=FPack^[index and RTC_STROBJ_AND].str;
  end;

function tRtcFastStrObjList.GetValue(const index: integer): TObject;
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    Result:=FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].obj
  else
    Result:=FPack^[index and RTC_STROBJ_AND].obj;
  end;

procedure tRtcFastStrObjList.SetName(const index: integer; const _Value: AnsiString);
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    begin
    with FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND] do
      begin
      Tree.remove(Upper_Case(str));
      str:=_Value;
      Tree.insert(Upper_Case(_Value), index);
      end;
    end
  else
    begin
    with FPack^[index and RTC_STROBJ_AND] do
      begin
      Tree.remove(Upper_Case(str));
      str:=_Value;
      Tree.insert(Upper_Case(_Value), index);
      end;
    end;
  if assigned(FOnChange) then FOnChange(self);
  end;

procedure tRtcFastStrObjList.SetValue(const index: integer; const _Value: TObject);
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].obj:=_Value
  else
    FPack^[index and RTC_STROBJ_AND].obj:=_Value;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStrObjList.GetCount: integer;
  begin
  Result:=FCnt;
  end;

{ tRtcFastStringObjList }

constructor tRtcFastStringObjList.Create;
  begin
  inherited;
  FPack:=nil;
  Tree:=tStringIntList.Create(RTC_STROBJ_PACK);

  SetLength(FData,0);
  New(FPack);
  FillChar(FPack^,SizeOf(FPack^),0);

  FCnt:=0;
  FDataCnt:=0;
  FPackCnt:=0;
  end;

destructor tRtcFastStringObjList.Destroy;
  begin
  Clear;
  if FPack<>nil then Dispose(FPack);
  FreeAndNil(Tree);
  inherited;
  end;

procedure tRtcFastStringObjList.Clear;
  var
    a,b:integer;
    FPack2:PRtcStringObjArr;
  begin
  if FPackCnt>0 then
    begin
    for b:=0 to FPackCnt-1 do
      with FPack^[b] do
        begin
        str:='';
        obj:=nil;
        end;
    FPackCnt:=0;
    end;

  if FDataCnt>0 then
    begin
    for a:=0 to FDataCnt-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        with FPack2^[b] do
          begin
          str:='';
          obj:=nil;
          end;
      Dispose(FPack2);
      end;
    SetLength(FData,0);
    FDataCnt:=0;
    end;

  if assigned(Tree) then
    Tree.removeall;
  FCnt:=0;

  if assigned(FOnChange) then FOnChange(self);
  end;

procedure tRtcFastStringObjList.DestroyObjects;
  var
    a,b,c:integer;
    FPack2:PRtcStringObjArr;
  begin
  if FPackCnt>0 then
    begin
    c:=FPackCnt;
    FPackCnt:=0;
    for b:=0 to c-1 do
      with FPack^[b] do
        begin
        str:='';
        obj.Free;
        end;
    end;

  if FDataCnt>0 then
    begin
    c:=FDataCnt;
    FDataCnt:=0;
    for a:=0 to c-1 do
      begin
      FPack2:=FData[a];
      for b:=0 to RTC_STROBJ_PACK-1 do
        with FPack2^[b] do
          begin
          str:='';
          obj.Free;
          end;
      Dispose(FPack2);
      end;
    SetLength(FData,0);
    end;

  if assigned(Tree) then
    Tree.removeall;
  FCnt:=0;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStringObjList.Add(const Name: UString; _Value:TObject=nil): integer;
  procedure FastStringListGrow;
    begin
    if length(FData)<=FDataCnt then
      SetLength(FData, FDataCnt + RTC_STROBJ_PACK);
    FData[FDataCnt]:=FPack;
    Inc(FDataCnt);

    New(FPack);
    FillChar(FPack^,SizeOf(FPack^),0);
    FPackCnt:=0;
    end;
  begin
  if FPackCnt>=RTC_STROBJ_PACK then
    FastStringListGrow;

  Tree.insert(UpperCaseStr(Name), FCnt);
  with FPack[FPackCnt] do
    begin
    str:=Name;
    obj:=_Value;
    end;
  Inc(FPackCnt);
  Inc(FCnt);

  Result:=FCnt-1;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStringObjList.Find(const Name: UString): integer;
  begin
  Result:=Tree.search(UpperCaseStr(Name));
  end;

function tRtcFastStringObjList.IndexOf(const Name: UString): integer;
  begin
  Result:=Tree.search(UpperCaseStr(Name));
  end;

function tRtcFastStringObjList.AddCS(const Name: UString; _Value:TObject=nil): integer;
  procedure FastStringListGrow;
    begin
    if length(FData)<=FDataCnt then
      SetLength(FData, FDataCnt + RTC_STROBJ_PACK);
    FData[FDataCnt]:=FPack;
    Inc(FDataCnt);

    New(FPack);
    FillChar(FPack^,SizeOf(FPack^),0);
    FPackCnt:=0;
    end;
  begin
  if FPackCnt>=RTC_STROBJ_PACK then
    FastStringListGrow;

  Tree.insert(Name, FCnt);
  with FPack[FPackCnt] do
    begin
    str:=Name;
    obj:=_Value;
    end;
  Inc(FPackCnt);
  Inc(FCnt);

  Result:=FCnt-1;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStringObjList.FindCS(const Name: UString): integer;
  begin
  Result:=Tree.search(Name);
  end;

function tRtcFastStringObjList.IndexOfCS(const Name: UString): integer;
  begin
  Result:=Tree.search(Name);
  end;

function tRtcFastStringObjList.GetName(const index: integer): UString;
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    Result:=FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].str
  else
    Result:=FPack^[index and RTC_STROBJ_AND].str;
  end;

function tRtcFastStringObjList.GetValue(const index: integer): TObject;
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    Result:=FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].obj
  else
    Result:=FPack^[index and RTC_STROBJ_AND].obj;
  end;

procedure tRtcFastStringObjList.SetName(const index: integer; const _Value: UString);
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    begin
    with FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND] do
      begin
      Tree.remove(UpperCaseStr(str));
      str:=_Value;
      Tree.insert(UpperCaseStr(_Value), index);
      end;
    end
  else
    begin
    with FPack^[index and RTC_STROBJ_AND] do
      begin
      Tree.remove(UpperCaseStr(str));
      str:=_Value;
      Tree.insert(UpperCaseStr(_Value), index);
      end;
    end;
  if assigned(FOnChange) then FOnChange(self);
  end;

procedure tRtcFastStringObjList.SetValue(const index: integer; const _Value: TObject);
  begin
  if index shr RTC_STROBJ_SHIFT<FDataCnt then
    FData[index shr RTC_STROBJ_SHIFT]^[index and RTC_STROBJ_AND].obj:=_Value
  else
    FPack^[index and RTC_STROBJ_AND].obj:=_Value;

  if assigned(FOnChange) then FOnChange(self);
  end;

function tRtcFastStringObjList.GetCount: integer;
  begin
  Result:=FCnt;
  end;

end.

