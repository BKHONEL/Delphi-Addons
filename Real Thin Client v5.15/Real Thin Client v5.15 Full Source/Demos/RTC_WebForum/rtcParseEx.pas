{
  @html(<b>)
  Extended Parser
  @html(</b>)
  - Copyright (c) Danijel Tkalcec
  @html(<br><br>)

  This unit defines an extended parser which is designed to be used either
  stand-alone or hand-in-hand with any of the RTC components. RTC parser uses
  a source AnsiString as Template and replaces tokens inside TokenOpen and TokenClose.
  If you are writing a Web Server, you can use this parser to generate dynamic content
  by using HTML templates designed with any Web Page Editor.

  Conditions:
    <%if:condition_name%>
      ...
    <%elseif:condition_name%>
      ...
    <%endif:condition_name%>

  Include:
    <%include:file_name%>  
}

unit rtcParseEx;
{$H+}

interface

{$include rtcDefs.inc}

uses
  Classes, SysUtils, rtcParse;

const
  BEGIN_CONDITION  = 'IF:';
  ELSE_CONDITION   = 'ELSEIF:';
  END_CONDITION    = 'ENDIF:';
  BEGIN_INCLUDE    = 'INCLUDE:';


type
  // @exclude
  TCondition = class(TObject)
  public
    Value: boolean;
    constructor Create(AValue: boolean = False);
  end;

  { @abstract(Extended Template parser)
    Extended parser which is designed to be used either stand-alone or
    hand-in-hand with any of the RTC components. RTC parser uses
    a source AnsiString as Template and replaces tokens inside TokenOpen and TokenClose.
    If you are writing a Web Server, you can use this parser to generate dynamic content
    by using HTML templates designed with any Web Page Editor. }
  TRtcParseEx = class(TObject)
  private
    FSource: AnsiString;
    FSilent: Boolean;
    FTokenClose: AnsiString;
    FTokenOpen: AnsiString;
    FVariables: TStringList;
    FConditions: TStringList;
    FIncludePath : AnsiString;


    // @exclude
    function FindPos(const Substr, Str: AnsiString; StartPos: Integer = 1): Integer;
    // Uppercase case-insensitive FindPos
    function FindPosUp(const Substr, Str: AnsiString; StartPos: Integer = 1): Integer;

    // @exclude
    function GetCount: Integer;
    // @exclude
    function GetVariableName(Index: Integer): AnsiString;
    // @exclude
    procedure SetVariableName(Index: Integer; const AValue: AnsiString);
    // @exclude
    function GetVariableValue(Index: Integer): AnsiString;
    // @exclude
    procedure SetVariableValue(Index: Integer; const AValue: AnsiString);
    // @exclude
    function GetValue(Index: AnsiString): AnsiString;
    // @exclude
    procedure SetValue(Index: AnsiString; const AValue: AnsiString);

    // @exclude
    procedure SetSource(AValue: AnsiString);

    // @exclude
    procedure SetTokenOpen(AValue: AnsiString);
    // @exclude
    procedure SetTokenClose(AValue: AnsiString);

    // @exclude
    function GetCondition(Index: AnsiString): boolean;
    // @exclude
    procedure SetCondition(Index: AnsiString; const Value: boolean);

  protected
    { @exclude
      Parses the source AnsiString and builds a list of variables and
      list of conditions names }
    procedure Parse;

  public
    { Constructor: use to create a parser object.
      Pass FileName as parameter to load local file as Source template. }
    constructor Create(AFilename: AnsiString = '');

    { Destructor: when you are done using the parser,
      you should destroy it by calling Free. }
    destructor Destroy; override;

    { Clears values for all variables parsed from the source AnsiString.
      Using Clear, you can re-use your Source Template to generate more
      outputs with different content, since only values for variables will
      be removed, while Source and known variable names remain. }
    procedure Clear;

    { Loads the source AnsiString from a file }
    procedure LoadFromFile(const aFilename: AnsiString);

    { Generates the output, replacing all variables with their associated values }
    function Output: AnsiString;

    { Gets count of variables parsed from the source AnsiString }
    property Count: Integer read GetCount default 0;

    { Name of the 'index'-th variable parsed from the source AnsiString (starting from 0) }
    property VariableName[Index: Integer]: AnsiString read GetVariableName write SetVariableName;
    { Value of the 'index'-th variable parsed from the source AnsiString (starting from 0) }
    property VariableValue[Index: Integer]: AnsiString read GetVariableValue write SetVariableValue;
    { Value of the variable with the name 'Index' parsed from the source AnsiString }
    property Value[Index: AnsiString]: AnsiString read GetValue write SetValue; default;

    property Condition[Index: AnsiString]: boolean read GetCondition write SetCondition;
    property Conditions : TStringList read FConditions;

    { Source AnsiString (Template) to use when generating the output }
    property Source: AnsiString read FSource write SetSource;

    { Prevents an exception from being raised when trying to set the value
      of a non-existent variable }
    property Silent: Boolean read FSilent write FSilent default False;
    { AnsiString to use for opening token. Default is <% }
    property TokenOpen: AnsiString read FTokenOpen write SetTokenOpen;
    { AnsiString to use for closing token. Default is %> }
    property TokenClose: AnsiString read FTokenClose write SetTokenClose;
  end;

function _IncludeTrailingPathDelimiter(const S: AnsiString): AnsiString;

implementation

uses
  Windows;

const
  ShLWApiDll = 'SHLWAPI.DLL';

function PathCombine(szDest:PAnsiChar; lpszDir:PAnsiChar; lpszFile:PAnsiChar):PAnsiChar;stdcall;
   external ShLwApiDll name 'PathCombineA';

function GetPathRelativeTo (Root : AnsiString; FilePath : AnsiString): AnsiString;
var
  PS : PAnsiChar;
begin
  Result := FilePath;
  if (Result <> '') and (Result[1] = '\') and (Result[2] <> '\') then
    Result := '.' + Result;
  PS := AllocMem(MAX_PATH);
  try
    if PathCombine(PS, PAnsiChar(Root), PAnsiChar(Result) ) <> nil then
      Result := PS;
  finally
    FreeMem(PS);
  end;
end;

function _IncludeTrailingPathDelimiter(const S: AnsiString): AnsiString;
begin
  Result := S;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + '\';
end;

function Read_File(const fname:AnsiString; Loc,Size:int64):AnsiString; overload;
  var
    fHandle: Integer;
    sRead: Int64;
  begin
  Result := '';
  fHandle := FileOpen(fname, fmOpenRead+fmShareDenyNone);
  if fHandle < 0 then
    raise ERtcParse.Create('Unable to open file: ' + fname)
  else
    begin
    if Loc < 0 then
      Loc := 0;
    try
      if Size < 0 then
        Size := FileSeek(fHandle, Int64(0), 2) - Loc;
      if FileSeek(fHandle, Loc, 0) <> Loc then
        raise ERtcParse.Create('Unable to seek to location: ' + IntToStr(Loc));
      SetLength(Result, Size);
      sRead := FileRead(fHandle, Result[1], Size);
      if sRead < Size then
        SetLength(Result, sRead);
    finally
      FileClose(fHandle);
      end;
    end;
  end;

function Read_File(const fname:AnsiString):AnsiString; overload;
  begin
  Result:=Read_File(fname,0,-1);
  end;


{ TRtcParseEx }

function TRtcParseEx.FindPos(const Substr, Str: AnsiString; StartPos: Integer = 1): Integer;
  var
    lenStr: Integer;
    lenSubstr: Integer;
    x, y: Integer;
  begin
  lenStr := Length(Str);
  lenSubstr := Length(Substr);

  case lenSubstr of
    0: Result := 0;

    1: begin
      Result := 0;
      for x:= StartPos to lenStr do
        if (Substr[1] = Str[x]) then
          begin
          Result := x;
          Break;
          end;
      end;
    2: begin
      Result := 0;
      for x := StartPos to lenStr-1 do
        if ((Substr[1] = Str[x]) and (SubStr[2] = Str[x+1])) then
          begin
          Result := x;
          Break;
          end;
      end;
    else
      begin
      Result := 0;
      for x := StartPos to lenStr-lenSubstr+1 do
        if ((Substr[1] = Str[x]) and (Substr[2] = Str[x+1]) and (Substr[3] = Str[x+2])) then
          begin
          Result := x;
          for y := 3 to lenSubstr-1 do
            if (Substr[1+y] <> Str[x+y]) then
              begin
              Result := 0;
              Break;
              end;
          if Result > 0 then
            Break;
          end;
      end;
    end;
  end;

function TRtcParseEx.FindPosUp(const Substr,Str: AnsiString; StartPos: Integer = 1): Integer;
  var
    lenStr: Integer;
    lenSubstr: Integer;
    x, y: Integer;
  begin
  lenStr := Length(Str);
  lenSubstr := Length(Substr);

  case lenSubstr of
    0: Result := 0;

    1: begin
      Result := 0;
      for x:= StartPos to lenStr do
        if Substr[1] = UpCase(Str[x]) then
          begin
          Result := x;
          Break;
          end;
      end;
    2: begin
      Result := 0;
      for x := StartPos to lenStr-1 do
        if ((Substr[1] = UpCase(Str[x])) and (SubStr[2] = UpCase(Str[x+1]))) then
          begin
          Result := x;
          Break;
          end;
      end;
    else
      begin
      Result := 0;
      for x := StartPos to lenStr-lenSubstr+1 do
        if ((Substr[1] = UpCase(Str[x])) and (Substr[2] = UpCase(Str[x+1])) and (Substr[3] = UpCase(Str[x+2]))) then
          begin
          Result := x;
          for y := 3 to lenSubstr-1 do
            if (Substr[1+y] <> UpCase(Str[x+y])) then
              begin
              Result := 0;
              Break;
              end;
          if Result > 0 then
            Break;
          end;
      end;
    end;
  end;

function TRtcParseEx.GetCount: Integer;
  begin
  if Assigned(FVariables) then
    Result := FVariables.Count
  else
    Result := 0;
  end;

function TRtcParseEx.GetVariableName(Index: Integer): AnsiString;
  begin
  // return the selected variable's name
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    Result := FVariables.Strings[Index]
  else
    Result := '';
  end;

procedure TRtcParseEx.SetVariableName(Index: Integer; const AValue: AnsiString);
  begin
  // set the selected variable's name
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    FVariables.Strings[Index] := AValue;
  end;

function TRtcParseEx.GetVariableValue(Index: Integer): AnsiString;
  begin
  // return the selected variable's value
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) and
     Assigned(FVariables.Objects[Index]) then
    Result := TString(FVariables.Objects[Index]).Value
  else
    Result := '';
  end;

procedure TRtcParseEx.SetVariableValue(Index: Integer; const AValue: AnsiString);
  begin
  // set the selected variable's value
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    if Assigned(Fvariables.Objects[Index]) then
      TString(FVariables.Objects[Index]).Value := AValue
    else
      FVariables.Objects[Index]:=TString.Create(AValue);
  end;

function TRtcParseEx.GetValue(Index: AnsiString): AnsiString;
  var
    idx: Integer;
  begin
  // return the value of variable named 'Index'
  if Assigned(FVariables) then
    begin
    {$IFDEF AnsiUpperCase}
    Index := AnsiUpperCase(Trim(Index));
    {$ELSE}
    Index := UpperCase(Trim(Index));
    {$ENDIF}

    idx := FVariables.IndexOf(Index);
    if (idx >= 0) and Assigned(FVariables.Objects[idx]) then
      Result := TString(FVariables.Objects[idx]).Value
    else
      Result := '';
    end
  else
    Result := '';
  end;

procedure TRtcParseEx.SetValue(Index: AnsiString; const AValue: AnsiString);
  var
    idx: Integer;
  begin
  if Assigned(FVariables) then
    begin
    {$IFDEF AnsiUpperCase}
    Index := AnsiUpperCase(Trim(Index));
    {$ELSE}
    Index := UpperCase(Trim(Index));
    {$ENDIF}

    // set the value of variable named 'Index'
    idx := FVariables.IndexOf(Index);
    if idx >= 0 then
      begin
      if Assigned(Fvariables.Objects[idx]) then
        TString(FVariables.Objects[idx]).Value := AValue
      else
        FVariables.Objects[idx]:=TString.Create(AValue);
      end
    else
      if not Silent then
        raise ERtcParse.Create('Unknown Variable: ' + Index);
    end;
  end;

procedure TRtcParseEx.SetSource(AValue: AnsiString);
begin
  // set the new source AnsiString and (re)build the variables list
  if FSource <> AValue then begin
    FSource := AValue;
    Parse;
  end;
end;

procedure TRtcParseEx.SetTokenOpen(AValue: AnsiString);
  begin
  // set the new open token delimiter and (re)build the variables list
  if (AValue <> '') and (FTokenOpen <> AValue) then
    begin
    FTokenOpen := Trim(AValue);
    Parse;
    end;
  end;

procedure TRtcParseEx.SetTokenClose(AValue: AnsiString);
  begin
  // set the new close token delimiter and (re)build the variables list
  if (AValue <> '') and (FTokenClose <> AValue) then
    begin
    FTokenClose := Trim(AValue);
    Parse;
    end;
  end;

procedure TRtcParseEx.Parse;
var
  lTokenOpen, lTokenClose: Integer;
  posStart: Integer;
  posEnd: Integer;
  variable: AnsiString;
  idx: Integer;
begin
  if (FSource <> '') then begin
    // clear/create the existing variable list
    if Assigned(FVariables) then
      begin
        Clear;
        FVariables.Clear;
      end
    else
      FVariables := TStringList.Create;

    // clear/create the existing conditions list
    if Assigned(FConditions) then
      begin
        Clear;
        FConditions.Clear;
      end
    else
      FConditions := TStringList.Create;

    lTokenOpen := Length(FTokenOpen);
    lTokenClose := Length(FTokenClose);

    // look for the tokens in the source AnsiString and extract the variables
    posStart := FindPos(FTokenOpen, FSource, 1);
    while posStart > 0 do begin
      posEnd := FindPos(FTokenClose, FSource, posStart+lTokenOpen);
      if (posEnd <= 0) then Break;

      // extract the variable name from the source AnsiString
      variable := Copy(FSource, posStart+lTokenOpen, posEnd-(posStart+lTokenOpen));
      if variable <> '' then begin
        {$IFDEF AnsiUpperCase}
        variable := AnsiUpperCase(Trim(variable));
        {$ELSE}
        variable := UpperCase(Trim(variable));
        {$ENDIF}

        if Copy(variable, 1, 8) = BEGIN_INCLUDE then
          begin
            variable := Copy(variable, 9, MAXINT);
            Delete(FSource, posStart, lTokenOpen + 8 + Length(variable) + lTokenClose);
            variable := _IncludeTrailingPathDelimiter(GetPathRelativeTo(FIncludePath, ExtractFilePath(variable))) +
              ExtractFileName(variable);
            if FileExists(variable) then
              Insert(Read_File(variable), FSource, posStart);
            posEnd := posStart - 1;
          end

        else if Copy(variable, 1, 3) = BEGIN_CONDITION then
          begin
            variable := Copy(variable, 4, MAXINT);
            idx := FConditions.IndexOf(variable);
            if (idx < 0) then
              FConditions.AddObject(variable, TCondition.Create);
          end

        else if Copy(variable, 1, 7) = ELSE_CONDITION then
          begin
            // nothing to do
          end

        else if Copy(variable, 1, 6) = END_CONDITION then
          begin
            // nothing to do
          end

        else
          begin
            // we don't want duplicated variable names
            idx := FVariables.IndexOf(variable);
            if (idx < 0) then
              FVariables.AddObject(variable, TString.Create);
          end;
      end;
      posStart := FindPos(FTokenOpen, FSource, posEnd+1);
    end;
  end;
end;

constructor TRtcParseEx.Create(AFilename: AnsiString = '');
begin
  inherited Create;

  // set the default values for the parser
  FSource := '';
  FSilent := False;
  FTokenOpen := '<%';
  FTokenClose := '%>';
  FVariables := nil;
  FConditions := nil;

  FIncludePath := '';

  // load the source AnsiString from a file
  if AFilename <> '' then
    try
      LoadFromFile(AFilename);
    except
    end;
end;

destructor TRtcParseEx.Destroy;
  begin
  // clear the variable list and clean up any allocated memory
  Clear;
  FVariables.Free;
  FVariables:=nil;
  FConditions.Free;
  FConditions:=nil;

  inherited;
  end;

procedure TRtcParseEx.Clear;
  var
    count: Integer;
  begin
  // clear all variables parsed from source AnsiString
  if Assigned(FVariables) then
    begin
    for count := 0 to FVariables.Count-1 do
      if Assigned(FVariables.Objects[count]) then
        begin
        FVariables.Objects[count].Free;
        FVariables.Objects[count] := nil;
        end;
    end;
  if Assigned(FConditions) then
    begin
    for count := 0 to FConditions.Count-1 do
      if Assigned(FConditions.Objects[count]) then
        begin
        FConditions.Objects[count].Free;
        FConditions.Objects[count] := nil;
        end;
    end;
  end;

procedure TRtcParseEx.LoadFromFile(const aFilename: AnsiString);
begin
  if FileExists(aFileName) then
    begin
      FIncludePath := _IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(AFilename)));
      FSource:=Read_File(aFileName);
      Parse;
    end
  else
    raise ERtcParse.Create('File not found: ' + aFilename);
end;

function TRtcParseEx.Output: AnsiString;

  function _OutputStr(const FSource : AnsiString) : AnsiString;
    var
      lSource: Integer;
      lTokenOpen: Integer;
      lTokenClose: Integer;

      copyStart: Integer;
      posStart: Integer;
      posEnd: Integer;
      variable: AnsiString;
      idx: Integer;
      S : AnsiString;
      posStart_End_Condition : Integer;
    begin
    if FSource <> '' then
      begin
      lSource := Length(FSource);
      lTokenOpen := Length(FTokenOpen);
      lTokenClose := Length(FTokenClose);

      copyStart := 1;
      Result := '';

      // look for the tokens and replace matching variables with their values
      posStart := FindPos(FTokenOpen, FSource, 1);
      while posStart > 0 do
        begin
        Result := Result + Copy(FSource, copyStart, posStart-copyStart);

        posEnd := FindPos(FTokenClose, FSource, posStart+1);
        if posEnd <= 0 then Break;

        // extract the variable name from the source AnsiString
        variable := Copy(FSource, posStart+lTokenOpen, posEnd-(posStart+lTokenOpen));
        if variable <> '' then
          begin
          {$IFDEF AnsiUpperCase}
          variable := AnsiUpperCase(Trim(variable));
          {$ELSE}
          variable := UpperCase(Trim(variable));
          {$ENDIF}

          if Copy(variable, 1, 3) = BEGIN_CONDITION then
            begin
            variable := Copy(variable, 4, MAXINT);
            idx := FConditions.IndexOf(variable);
            if (idx >= 0) then
              begin
              copyStart := posEnd + lTokenClose;
              posEnd := FindPos(FTokenClose, FSource, posStart+1);

              S := UpperCase(FTokenOpen + END_CONDITION + variable);
              posStart_End_Condition := FindPosUp(S, FSource, posEnd+1);

              posStart := FindPosUp(UpperCase(FTokenOpen + ELSE_CONDITION + variable), FSource, posEnd+1);

              if posStart > posStart_End_Condition then
                posStart := -1;

              if posStart > 0 then
                begin
                if Condition[variable] then
                  Result := Result + _OutputStr(Copy(FSource, copyStart, posStart-copyStart));

                posEnd := FindPos(FTokenClose, FSource, posStart+1);
                copyStart := posEnd + lTokenClose;

                posStart := FindPosUp(S, FSource, posEnd+1); // FTokenOpen + END_CONDITION + variable

                if not Condition[variable] then
                  Result := Result + _OutputStr(Copy(FSource, copyStart, posStart-copyStart));

                posEnd := FindPos(FTokenClose, FSource, posStart+1);
                end
              else
                begin
                posStart := FindPosUp(S, FSource, posEnd+1); // FTokenOpen + END_CONDITION + variable

                posEnd := FindPos(FTokenClose, FSource, posStart+1);

                if Condition[variable] then
                  Result := Result + _OutputStr(Copy(FSource, copyStart, posStart-copyStart));
                end;
              end;
            end
          else
            begin
            // only replace the variable if it is present in list
            idx := FVariables.IndexOf(variable);
            if idx >= 0 then
              Result := Result + VariableValue[idx];
            end;
          end;

        copyStart := posEnd + lTokenClose;
        posStart := FindPos(FTokenOpen, FSource, posEnd+1);
        end;

      // make sure that remaining part of FSource is returned
      if copyStart < lSource then
        Result := Result + Copy(FSource, copyStart, lSource-copyStart+1);
      end
    else
      Result:='';
    end;
  begin
  Result := _OutputStr(FSource);
  end;

function TRtcParseEx.GetCondition(Index: AnsiString): boolean;
var
  idx: Integer;
begin
  // return the value of condition named 'Index'
  if Assigned(FConditions) then
    begin
      {$IFDEF AnsiUpperCase}
      Index := AnsiUpperCase(Trim(Index));
      {$ELSE}
      Index := UpperCase(Trim(Index));
      {$ENDIF}

      idx := FConditions.IndexOf(Index);
      if (idx >= 0) and Assigned(FConditions.Objects[idx]) then
        Result := TCondition(FConditions.Objects[idx]).Value
      else
        Result := False;
    end
  else
    Result := False;
end;

procedure TRtcParseEx.SetCondition(Index: AnsiString; const Value: boolean);
var
  idx: Integer;
begin
  if Assigned(FConditions) then begin
    {$IFDEF AnsiUpperCase}
    Index := AnsiUpperCase(Trim(Index));
    {$ELSE}
    Index := UpperCase(Trim(Index));
    {$ENDIF}

    // set the value of condition named 'Index'
    idx := FConditions.IndexOf(Index);
    if idx >= 0 then
      begin
        if Assigned(FConditions.Objects[idx]) then
          TCondition(FConditions.Objects[idx]).Value := Value
        else
          FConditions.Objects[idx] := TCondition.Create(Value);
      end
    else
      if not Silent then
        raise ERtcParse.Create('Unknown Condition: ' + Index);
  end;
end;

{ TCondition }

constructor TCondition.Create(AValue: boolean);
begin
  inherited Create;
  Value := AValue;
end;

end.
