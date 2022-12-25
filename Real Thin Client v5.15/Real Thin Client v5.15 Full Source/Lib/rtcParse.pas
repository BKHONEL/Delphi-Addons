{
  @html(<b>)
  Simple Parser
  @html(</b>)
  - Copyright (c) 2004-2012 by Cord Schneider & Danijel Tkalcec (http://www.realthinclient.com)
  @html(<br><br>)

  This unit defines a simple parser which is designed to be used either
  stand-alone or hand-in-hand with any of the RTC components. RTC parser uses
  a source AnsiString as Template and replaces tokens inside TokenOpen and TokenClose.
  If you are writing a Web Server, you can use this parser to generate dynamic content
  by using HTML templates designed with any Web Page Editor.
}

unit rtcParse;

interface

{$include rtcDefs.inc}

uses
  Classes, SysUtils,
  rtcFastStrings, rtcLog, rtcInfo;

type
  { @exclude
    ERtcParse is an exception handler for TRtcParse objects }
  ERtcParse = class(Exception);

  // @exclude
  TString = class(TObject)
  public
    Value: AnsiString;
    constructor Create(const AValue: AnsiString = '');
  end;

  { @abstract(Simple Template parser)
    Simple parser which is designed to be used either stand-alone or
    hand-in-hand with any of the RTC components. RTC parser uses
    a source AnsiString as Template and replaces tokens inside TokenOpen and TokenClose.
    If you are writing a Web Server, you can use this parser to generate dynamic content
    by using HTML templates designed with any Web Page Editor. }
  TRtcParse = class(TObject)
  private
    FSource: AnsiString;
    FSilent: Boolean;
    FTokenClose: AnsiString;
    FTokenOpen: AnsiString;
    FVariables: TStringList;

    // @exclude
    function FindPos(const Substr, Str: AnsiString; StartPos: Integer = 1): Integer;

    // @exclude
    function GetCount: Integer;
    // @exclude
    function GetVariableName(Index: Integer): String;
    // @exclude
    procedure SetVariableName(Index: Integer; const AValue: String);
    // @exclude
    function GetVariableValue(Index: Integer): AnsiString;
    // @exclude
    procedure SetVariableValue(Index: Integer; const AValue: AnsiString);
    // @exclude
    function GetValue(const Index: String): AnsiString;
    // @exclude
    procedure SetValue(const Index: String; const AValue: AnsiString);

    // @exclude
    procedure SetSource(const AValue: AnsiString);

    // @exclude
    procedure SetTokenOpen(const AValue: AnsiString);
    // @exclude
    procedure SetTokenClose(const AValue: AnsiString);

  protected
    { @exclude
      Parses the source AnsiString and builds a list of variable names }
    procedure GetVariables;

  public
    { Constructor: use to create a parser object.
      Pass FileName as parameter to load local file as Source template. }
    constructor Create(const AFilename: String = '');

    { Destructor: when you are done using the parser,
      you should destroy it by calling Free. }
    destructor Destroy; override;

    { Clears values for all variables parsed from the source AnsiString.
      Using Clear, you can re-use your Source Template to generate more
      outputs with different content, since only values for variables will
      be removed, while Source and known variable names remain. }
    procedure Clear;

    { Loads the source AnsiString from a file }
    procedure LoadFromFile(const aFilename: String);

    { Loads the source AnsiString from a stream }
    procedure LoadFromStream(aStream:TStream);

    { Generates the output, replacing all variables with their associated values }
    function Output: AnsiString;

    { Gets count of variables parsed from the source AnsiString }
    property Count: Integer read GetCount default 0;

    { Name of the 'index'-th variable parsed from the source AnsiString (starting from 0) }
    property VariableName[Index: Integer]: String read GetVariableName write SetVariableName;
    { Value of the 'index'-th variable parsed from the source AnsiString (starting from 0) }
    property VariableValue[Index: Integer]: AnsiString read GetVariableValue write SetVariableValue;
    { Value of the variable with the name 'Index' parsed from the source AnsiString }
    property Value[const Index: String]: AnsiString read GetValue write SetValue; default;

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

implementation

{ TString }

constructor TString.Create(const AValue: AnsiString = '');
  begin
  inherited Create;
  Value := AValue;
  end;

{ TRtcParse }

function TRtcParse.FindPos(const Substr, Str: AnsiString; StartPos: Integer = 1): Integer;
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

function TRtcParse.GetCount: Integer;
  begin
  if Assigned(FVariables) then
    Result := FVariables.Count
  else
    Result := 0;
  end;

function TRtcParse.GetVariableName(Index: Integer): String;
  begin
  // return the selected variable's name
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    Result := FVariables.Strings[Index]
  else
    Result := '';
  end;

procedure TRtcParse.SetVariableName(Index: Integer; const AValue: String);
  begin
  // set the selected variable's name
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    FVariables.Strings[Index] := AValue;
  end;

function TRtcParse.GetVariableValue(Index: Integer): AnsiString;
  begin
  // return the selected variable's value
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) and
     Assigned(FVariables.Objects[Index]) then
    Result := TString(FVariables.Objects[Index]).Value
  else
    Result := '';
  end;

procedure TRtcParse.SetVariableValue(Index: Integer; const AValue: AnsiString);
  begin
  // set the selected variable's value
  if Assigned(FVariables) and (Index >= 0) and (Index < FVariables.Count) then
    if Assigned(Fvariables.Objects[Index]) then
      TString(FVariables.Objects[Index]).Value := AValue
    else
      FVariables.Objects[Index]:=TString.Create(AValue);
  end;

function TRtcParse.GetValue(const Index: String): AnsiString;
  var
    idx: Integer;
  begin
  // return the value of variable named 'Index'
  if Assigned(FVariables) then
    begin
    idx := FVariables.IndexOf(UpperCase(Trim(Index)));
    if (idx >= 0) and Assigned(FVariables.Objects[idx]) then
      Result := TString(FVariables.Objects[idx]).Value
    else
      Result := '';
    end
  else
    Result := '';
  end;

procedure TRtcParse.SetValue(const Index: String; const AValue: AnsiString);
  var
    idx: Integer;
  begin
  if Assigned(FVariables) then
    begin
    // set the value of variable named 'Index'
    idx := FVariables.IndexOf(UpperCase(Trim(Index)));
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

procedure TRtcParse.SetSource(const AValue: AnsiString);
  begin
  // set the new source AnsiString and (re)build the variables list
  if FSource <> AValue then
    begin
    FSource := AValue;
    GetVariables;
    end;
  end;

procedure TRtcParse.SetTokenOpen(const AValue: AnsiString);
  begin
  // set the new open token delimiter and (re)build the variables list
  if (AValue <> '') and (FTokenOpen <> AValue) then
    begin
    FTokenOpen := Trim(AValue);
    GetVariables;
    end;
  end;

procedure TRtcParse.SetTokenClose(const AValue: AnsiString);
  begin
  // set the new close token delimiter and (re)build the variables list
  if (AValue <> '') and (FTokenClose <> AValue) then
    begin
    FTokenClose := Trim(AValue);
    GetVariables;
    end;
  end;

procedure TRtcParse.GetVariables;
  var
    lTokenOpen: Integer;
    posStart: Integer;
    posEnd: Integer;
    variable: String;
    idx: Integer;
  begin
  if (FSource <> '') then
    begin
    // clear/create the existing variable list
    if Assigned(FVariables) then
      begin
      Clear;
      FVariables.Clear;
      end
    else
      FVariables := TStringList.Create;

    lTokenOpen := Length(FTokenOpen);

    // look for the tokens in the source AnsiString and extract the variables
    posStart := FindPos(FTokenOpen, FSource, 1);
    while posStart > 0 do
      begin
      posEnd := FindPos(FTokenClose, FSource, posStart+lTokenOpen);
      if (posEnd <= 0) then Break;

      // extract the variable name from the source AnsiString
      variable := String(Copy(FSource, posStart+lTokenOpen, posEnd-(posStart+lTokenOpen)));
      if variable <> '' then
        begin
        variable := UpperCase(Trim(variable));

        // we don't want duplicated variable names
        idx := FVariables.IndexOf(variable);
        if (idx < 0) then
          FVariables.AddObject(variable, TString.Create);
        end;
      posStart := FindPos(FTokenOpen, FSource, posEnd+1);
      end;
    end;
  end;

constructor TRtcParse.Create(const AFilename: String = '');
  begin
  inherited Create;

  // set the default values for the parser
  FSource := '';
  FSilent := False;
  FTokenOpen := '<%';
  FTokenClose := '%>';
  FVariables := nil;

  // load the source AnsiString from a file
  if AFilename <> '' then
    try
      LoadFromFile(AFilename);
    except
    end;
  end;

destructor TRtcParse.Destroy;
  begin
  try
    // clear the variable list and clean up any allocated memory
    Clear;
    FreeAndNil(FVariables);

    inherited;
  except
    on E:Exception do
      begin
      if LOG_AV_ERRORS then
        Log('TRtcParse.Destroy',E,'ERROR');
      raise;
      end;
    end;
  end;

procedure TRtcParse.Clear;
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
  end;

procedure TRtcParse.LoadFromFile(const aFilename: String);
  begin
  if FileExists(aFileName) then
    begin
    FSource:=Read_File(aFileName);
    // build the variable list
    GetVariables;
    end
  else
    raise ERtcParse.Create('File not found: ' + aFilename);
  end;

procedure TRtcParse.LoadFromStream(aStream: TStream);
  var
    Len:int64;
  begin
  if assigned(aStream) then
    begin
    Len:=aStream.Size-aStream.Position;
    if Len>0 then
      begin
      SetLength(FSource, Len);
      aStream.Read(FSource[1],Len);
      end
    else
      FSource:='';
    GetVariables;
    end
  else
    raise ERtcParse.Create('aStream parameter is NIL');
  end;

function TRtcParse.Output: AnsiString;
  var
    lSource: Integer;
    lTokenOpen: Integer;
    lTokenClose: Integer;

    copyStart: Integer;
    posStart: Integer;
    posEnd: Integer;
    variable: String;
    idx: Integer;
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
      variable := String(Copy(FSource, posStart+lTokenOpen, posEnd-(posStart+lTokenOpen)));
      if variable <> '' then
        begin
        variable := UpperCase(Trim(variable));

        // only replace the variable if it is present in list
        idx := FVariables.IndexOf(variable);
        if idx > -1 then Result := Result + GetVariableValue(idx);
        end;

      copyStart := posEnd + lTokenClose;
      posStart := FindPos(FTokenOpen, FSource, posEnd+1);
      end;

      // make sure that remaining part of FSource is returned
      if copyStart < lSource then
        Result := Result + Copy(FSource, copyStart, lSource-copyStart+1);
    end;
  end;

end.
