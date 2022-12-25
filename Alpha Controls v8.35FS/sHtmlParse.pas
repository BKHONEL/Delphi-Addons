unit sHtmlParse;
{$I sDefs.inc}

interface
uses windows, Graphics, SysUtils, Classes, acntUtils, Math, sConst {$IFDEF DELPHI_XE3}, UItypes{$ENDIF};

const
  Letters = ['A','B','C','D','E','F'];
  Digits = ['0','1','2','3','4','5','6','7','8','9'];
  DisabledChars = [#13, #10];

type
  TsHtml = class(TObject)
  protected
    Calculating : boolean;
  public
    Bitmap : TBitmap;
    CurX, CurY, Len : integer;
    Origin, UppedText : string;
    aFonts : array of TFont;
    Area : TRect;
{KJS ADDED TO ALLOW CLAMPING OF WIDTH}
    WrapWidth : Integer;
    MaxBmpWidth : integer;
    MaxBmpHeight : integer;
    CurWidthValue : integer;
    CurHeightValue : integer;
    CurrentRowHeight : integer;
    CurrentRowAlignment : TAlignment;
    destructor Destroy; override;
{KJS CHANGED VARIBLE NAMES FOR CLARITY AND REMOVED VAR AS IT WAS NOT BEING USED!}
    procedure ShowCut(inCurPos: integer; inLastPos: integer);
    procedure Init(Bmp : TBitmap; Text : string; aRect : TRect); // {KJS ADDED}; inWrapWidth:Integer = 0{END ADD});
    function ExecTag(const s : string) : boolean;
    procedure NewRow;
    procedure NewFont(const s : string);
    procedure BackFont;
    function HTMLText(CalcOnly : boolean = False) : TRect;
    procedure SetAlignment(const Tag : string);
{KJS ADDED FOR SPECIAL HTML CHARACTERS}
    function GetSpecialCharacter(inString:String; inPos:Integer): String;
  end;

function GetTag(const s: string; CurPos : integer) : string;
procedure SetFont(Font: TFont; const Tag : string);

implementation

uses sGraphUtils;

function GetTag(const s: string; CurPos : integer) : string;
var
  i, l, j : integer;
begin
  Result := '';
  l := length(s);
  for i := CurPos to l do begin
    if s[i] = '>' then begin
      for j := CurPos to i do
        Result := Result + s[j];
      break;
    end;
  end;
end;

procedure SetFont(Font: TFont; const Tag : string);
const
  Delims = [' ', '=', '"', #13, #10, '<', '>'];
var
  i, count, len, j1, j2 : integer;
  Atom, Value, Buffer : string;
begin
  count := WordCount(Tag, Delims);
  len := length(tag);
  for i := 1 to count do begin
    Atom := ExtractWord(i, Tag, Delims);
    if Atom = 'SIZE' then begin
      Value := ExtractWord(i + 1, Tag, Delims);
      if Value <> '' then begin
        if Value[1] = '-' then begin
          Delete(Value, 1, 1);
          if Value <> '' then Font.Size := Font.Size - StrToInt(Value);
        end
        else if Value[1] = '+' then begin
          Delete(Value, 1, 1);
          if Value <> '' then Font.Size := Font.Size + StrToInt(Value);
        end
        else begin
          try
            Font.Size := StrToInt(Value);
          finally
          end;
        end;
      end;
    end
    else if Atom = 'COLOR' then begin
      Value := ExtractWord(i + 1, Tag, Delims);
      if Value <> '' then begin
        if Value[1] = '#' then begin
          Delete(Value, 1, 1);
          Buffer := '';
          Font.Color := SwapInteger(HexToInt(Value));
        end else
        if Value = 'AQUA' then Font.Color := clAqua else
        if Value = 'BLACK' then Font.Color := clBlack else
        if Value = 'BLUE' then Font.Color := clBlue else
        if Value = 'FUCHSIA' then Font.Color := clFuchsia else
        if Value = 'GRAY' then Font.Color := clGray else
        if Value = 'GREEN' then Font.Color := clGreen else
        if Value = 'LIME' then Font.Color := clLime else
        if Value = 'MAROON' then Font.Color := clMaroon else
        if Value = 'NAVY' then Font.Color := clNavy else
        if Value = 'OLIVE' then Font.Color := clOlive else
        if Value = 'PURPLE' then Font.Color := clPurple else
        if Value = 'RED' then Font.Color := clRed else
        if Value = 'SILVER' then Font.Color := clSilver else
        if Value = 'TEAL' then Font.Color := clTeal else
        if Value = 'WHITE' then Font.Color := clWhite else
        if Value = 'YELLOW' then Font.Color := clYellow
        else begin
          Buffer := '';
          Font.Color := SwapInteger(HexToInt(Value));
        end;
      end;
    end
    else if Atom = 'FACE' then begin
      j1 := pos(Atom, Tag);
      while (Tag[j1] <> '"') and (j1 < len) do inc(j1);
      j2 := j1 + 1;
      while (Tag[j2] <> '"') and (j2 < len) do inc(j2);
      if j2 > j1 then begin
        Value := '';
        inc(j1);
        while j1 < j2 do begin
          Value := Value + Tag[j1];
          inc(j1);
        end;
        if Value <> '' then Font.Name := Value;
      end;
    end;
  end;
end;

{ TsHtml }

procedure TsHtml.BackFont;
var
  len : integer;
begin
  len := High(aFonts);
  if len <> -1 then begin
    Bitmap.Canvas.Font.Assign(aFonts[len]);
    if Assigned(aFonts[len]) then FreeAndNil(aFonts[len]);
    SetLength(aFonts, len);
  end;
end;

destructor TsHtml.Destroy;
var
  len : integer;
begin
  Bitmap := nil;
  len := High(aFonts);
  while Len >= 0 do begin
    if Assigned(aFonts[len]) then FreeAndNil(aFonts[len]);
    SetLength(aFonts, len);
    len := High(aFonts);
  end;
  inherited;
end;

function TsHtml.ExecTag(const s: string) : boolean;
  function OpenTag(const Tag : string) : boolean;
  var
    p : integer;
  begin
    Result := False;
    p := pos(Tag, s);
    if p > 0 then begin
      if (p + length(Tag)) <= length(s) then begin
        if Tag = 'FONT'
          then Result := True
          else Result := (p = 2) and (s[p + length(Tag)] = '>');
      end;
    end;
  end;
  function CloseTag(const Tag : string) : boolean; begin
    Result := pos(Tag, s) = 3;
  end;
begin
  Result := False;
  if (s <> '') and (s[2] = '/') then begin
    if CloseTag('B') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style - [fsBold];
      Result := True;
    end
    else if CloseTag('I') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style - [fsItalic];
      Result := True;
    end
    else if CloseTag('U') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style - [fsUnderline];
      Result := True;
    end
    else if CloseTag('FONT') then begin
      BackFont;
      Result := True;
    end;
  end
  else begin
    if OpenTag('BR') or OpenTag('BR/') then begin
      CurX := Area.Left;
{KJS ADDED TO SUPPORT <BR><BR>}
      if CurrentRowHeight = 0 then
         CurrentRowHeight := Bitmap.Canvas.TextHeight('X');
{KJS END ADD}
      NewRow;
      Result := True;
    end
    else if OpenTag('B') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style + [fsBold];
      Result := True;
    end
    else if OpenTag('I') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style + [fsItalic];
      Result := True;
    end
    else if OpenTag('U') then begin
      Bitmap.Canvas.Font.Style := Bitmap.Canvas.Font.Style + [fsUnderline];
      Result := True;
    end
    else if OpenTag('P') then begin
      CurX := Area.Left;
{KJS ADDED TO Ensure NEW Row does just that}
      if CurrentRowHeight = 0 then
         CurrentRowHeight := Bitmap.Canvas.TextHeight('X');
{KJS END ADD}
      NewRow;
      SetAlignment(s);
      Result := True;
    end
    else if OpenTag('FONT') then begin
      NewFont(s);
      Result := True;
    end;
  end;
end;
{KJS ADDED to handle HTML SpecialCharacters}
function TsHtml.GetSpecialCharacter(inString:String; inPos:Integer): String;
var
  SemiColonPos: Integer;
  SpacePos: Integer;
  SpecialChar:String;
begin
     result:=copy(inString,Succ(inPos),255);
     SemiColonPos:=Pos(';',Result);
     SpacePos:=Pos(' ',Result);
     if (SemiColonPos = 0) or ((SpacePos > 0) and (SpacePos < SemiColonPos)) then
        result:=''
     else
     begin
        result:=Copy(result,1,Pred(SemiColonPos));
        if SameText(result,'ndash') OR (Result='#8211') then
          SpecialChar:='–'
        else if SameText(result,'mdash') or (Result='#8212') then // 	em dash
          SpecialChar := '—'
        else if SameText(result,'nbsp') or (Result='#160') then // 	non-braking space
          SpecialChar := ' '
        else if SameText(result,'iexcl') or (Result='#161') then // 	inverted exclamation
          SpecialChar := '¡'
        else if SameText(result,'iquest') or (Result='#191') then // 	inverted question mark
          SpecialChar := '¿'
        else if SameText(result,'quot') or (Result='#34') then // 	quotation mark
          SpecialChar := '"'
        else if SameText(result,'ldquo') or (Result='#8220') then // 	left double curly quote
          SpecialChar := '“'
        else if SameText(result,'rdquo') or (Result='#8221') then // 	right double curly quote
          SpecialChar := '”'
        else if SameText(result,'39') then // 	apostrophe (single quote)
          SpecialChar := #39
        else if SameText(result,'lsquo') or (Result='#8216') then // 	left single curly quote
          SpecialChar := '‘'
        else if SameText(result,'rsquo') or (Result='#8217') then // 	right single curly quote
          SpecialChar := '’'
        else if SameText(result,'laquo') or (Result='#171') then
          SpecialChar := '«'
        else if SameText(result,'raquo') or (Result = '#187') then
          SpecialChar := '»'
        else if SameText(result,'amp') or (Result='#38') then // 	ampersand
          SpecialChar := '&'
        else if SameText(result,'cent') or (Result='#162') then // 	cent
          SpecialChar := '¢'
        else if SameText(result,'copy') or (Result='#169') then // 	copyright
          SpecialChar := '©'
        else if SameText(result,'divide') or (Result='#247') then // 	divide
          SpecialChar := '÷'
        else if SameText(result,'gt') or (Result='#62') then // 	greater than
          SpecialChar := '>'
        else if SameText(result,'lt') or (Result='#60') then // 	less than
          SpecialChar := '<'
        else if SameText(result,'micro') or (Result='#181') then // 	micron
          SpecialChar := 'µ'
        else if SameText(result,'middot') or (Result='#183') then // 	middle dot
          SpecialChar := '·'
        else if SameText(result,'para') or (Result='#182') then // 	pilcrow (paragraph sign)
          SpecialChar := '¶'
        else if SameText(result,'plusmn') or (Result='#177') then // 	plus/minus
          SpecialChar := '±'
        else if SameText(result,'euro') or (Result='#8364') then // 	Euro
          SpecialChar := '€'
        else if SameText(result,'pound') or (Result='#163') then // 	British Pound Sterling
          SpecialChar := '£'
        else if SameText(result,'reg') or (Result='#174') then // 	registered
          SpecialChar := '®'
        else if SameText(result,'sect') or (Result='#167') then // 	section
          SpecialChar := '§'
        else if SameText(result,'trade') or (Result='#153') then // 	trademark
          SpecialChar := '™'
        else if SameText(result,'yen') or (Result='#165') then // 	Japanese Yen
          SpecialChar := '¥'
        else if SameText(result,'szlig') or (Result='#223') then
          SpecialChar:='ß'
        else if (result='yuml') or (Result='#255') then
          SpecialChar:='ÿ'
        else if (result='aacute') or (Result='#225') then
          SpecialChar :='á'
        else if (result='Aacute') or (Result='#193') then
          SpecialChar :='Á'
        else if (result='agrave') or (Result='#224') then
          SpecialChar:='à'
        else if (result='Agrave') or (result='#192') then
          SpecialChar:='À'
        else if (result='acirc') or (Result='#226') then
          SpecialChar:='â'
        else if (result='Acirc') or (result='#194') then
          SpecialChar:='Â'
        else if (result='aring') or (Result='#229') then
          SpecialChar:='å'
        else if (result='Aring') or (result='#197') then
          SpecialChar:='Å'
        else if (result='atilde') or (Result='#227') then
          SpecialChar:='ã'
        else if (result='Atilde') or (result='#195') then
          SpecialChar:='Ã'
        else if (result='auml') or (Result='#228') then
          SpecialChar:='ä'
        else if (result='Auml') or (result='#196') then
          SpecialChar:='Ä'
        else if (result='aelig') or (Result='#230') then
          SpecialChar:='æ'
        else if (result='AElig') or (result='#198') then
          SpecialChar:='Æ'
        else if (result='ccedil') or (Result='#231') then
          SpecialChar:='ç'
        else if (result='Ccedil') or (result='#199') then
          SpecialChar:='Ç'
        else if (result='eacute') or (Result='#233') then
          SpecialChar:='é'
        else if (result='Eacute') or (result='#201') then
          SpecialChar:='É'
        else if (result='egrave') or (Result='#232') then
          SpecialChar:='è'
        else if (result='Egrave') or (result='#200') then
          SpecialChar:='È'
        else if (result='ecirc') or (Result='#234') then
          SpecialChar:='ê'
        else if (result='Ecirc') or (result='#202') then
          SpecialChar:='Ê'
        else if (result='euml') or (Result='#235') then
          SpecialChar:='ë'
        else if (result='Euml') or (result='#203') then
          SpecialChar:='Ë'
        else if (result='iacute') or (Result='#237') then
          SpecialChar:='í'
        else if (result='Iacute') or (result='#205') then
          SpecialChar:='Í'
        else if (result='igrave') or (Result='#236') then
          SpecialChar:='ì'
        else if (result='Igrave') or (result='#204') then
          SpecialChar:='Ì'
        else if (result='icirc') or (Result='#238') then
          SpecialChar:='î'
        else if (result='Icirc') or (result='#206') then
          SpecialChar:='Î'
        else if (result='iuml') or (Result='#239') then
          SpecialChar:='ï'
        else if (result='Iuml') or (result='#207') then
          SpecialChar:='Ï'
        else if (result='ntilde') or (Result='#241') then
          SpecialChar:='ñ'
        else if (result='Ntilde') or (result='#209') then
          SpecialChar:='Ñ'
        else if (result='oacute') or (Result='#243') then
          SpecialChar:='ó'
        else if (result='Oacute') or (result='#211') then
          SpecialChar:='Ó'
        else if (result='ograve') or (Result='#242') then
          SpecialChar:='ò'
        else if (result='Ograve') or (result='#210') then
          SpecialChar:='Ò'
        else if (result='ocirc') or (Result='#244') then
          SpecialChar:='ô'
        else if (result='Ocirc') or (result='#212') then
          SpecialChar:='Ô'
        else if (result='oslash') or (Result='#248') then
          SpecialChar:='ø'
        else if (result='Oslash') or (result='#216') then
          SpecialChar:='Ø'
        else if (result='otilde') or (Result='#245') then
          SpecialChar:='õ'
        else if (result='Otilde') or (result='#213') then
          SpecialChar:='Õ'
        else if (result='ouml') or (Result='#246') then
          SpecialChar:='ö'
        else if (result='Ouml') or (result='#214') then
          SpecialChar:='Ö'
        else if (result='uacute') or (Result='#250') then
          SpecialChar:='ú'
        else if (result='Uacute') or (Result='#218') then
          SpecialChar:='Ú'
        else if (result='ugrave') or (Result='#249') then
          SpecialChar:='ù'
        else if (result='Ugrave') or (Result='#217') then
          SpecialChar:='Ù'
        else if (result='ucirc') or (Result='#251') then
          SpecialChar:='û'
        else if (result='Ucirc') or (result='#219') then
          SpecialChar:='Û'
        else if (result='uuml') or (Result='#252') then
          SpecialChar:='ü'
        else if (result='Uuml') or (Result='#220') then
          SpecialChar:='Ü'
        else if (result='#180') then
          SpecialChar:='´'
        else if (result='#96') then
          SpecialChar:='`'
        else
         begin
            result:='';
            exit;
         end;
       if (Area.Right > 0) and (CurX + Bitmap.Canvas.TextWidth(SpecialChar) > Area.Right) then
        begin
          CurX := Area.Left;
          NewRow;
        end;
        Bitmap.Canvas.TextOut(CurX, CurY, SpecialChar);
        CurX := CurX + Bitmap.Canvas.TextWidth(SpecialChar);
        CurWidthValue := CurX;
        if Bitmap.Canvas.TextHeight('X') > CurrentRowHeight then
           CurrentRowHeight := Bitmap.Canvas.TextHeight('X');
        result:='&'+result+';';
     end;
end;

function TsHtml.HTMLText(CalcOnly : boolean = False) : TRect;
var
  CurPos, LastPos: integer;
  sCurrentTag: string;
{KJS ADDED}
  sCurrentChar: string;
begin
  Result := Rect(0, 0, 100, 0);
  Calculating := CalcOnly;
  try
    LastPos := 1;
    CurPos := 1;
    while CurPos <= Len do begin
      case UppedText[CurPos] of
{KJS ADDED FOR SPECIAL CHARACTERS}
        '&': begin
          sCurrentChar := GetSpecialCharacter(origin,CurPos);
          if (sCurrentChar <> '') then begin
            inc(CurPos, Length(sCurrentChar));
            LastPos := CurPos;
            dec(CurPos);
          end;
        end;
        '<': begin
          if UppedText[CurPos + 1] <> '<' then begin
            if CurPos > LastPos then
              ShowCut(CurPos, LastPos);
            sCurrentTag := GetTag(UppedText, CurPos);
            if sCurrentTag = '' then begin
              inc(CurPos);
              LastPos := CurPos;
              Continue;
            end;
            if ExecTag(sCurrentTag) then begin
              inc(CurPos, Length(sCurrentTag));
              LastPos := CurPos;
              dec(CurPos);
            end
            else begin
              inc(CurPos);
              ShowCut(CurPos, LastPos);
              LastPos := CurPos;
            end;
          end
          else begin
            if CurPos > LastPos then
               ShowCut(CurPos, LastPos);
            inc(CurPos);
            LastPos := CurPos;
          end;
        end;
      end;
      inc(CurPos);
    end;
    if CurPos > LastPos then
      ShowCut(CurPos, LastPos);

    if CurWidthValue > MaxBmpWidth then MaxBmpWidth := CurWidthValue;
    CurWidthValue := 0;
    MaxBmpHeight := CurY + CurrentRowHeight;

  finally
    Result := Rect(0, 0, MaxBmpWidth, MaxBmpHeight);
    Calculating := False;
  end;
end;

procedure TsHtml.Init(Bmp : TBitmap; Text : string; aRect : TRect);//{KJS ADDED}; inWrapWidth : Integer = 0{END ADD});
begin
  Bitmap := Bmp;
  Origin := Text;
  Area := aRect;
  UppedText := AnsiUpperCase(Origin);

  Len := Length(UppedText);
  CurX := Area.Left;
  CurY := Area.Top;
{KJS ADDED TO SUPPORT MAX WIDTH}
//  WrapWidth := inWrapWidth;
  MaxBmpWidth := 0;
  MaxBmpHeight := 0;
  CurWidthValue := 0;
  CurHeightValue := 0;
  CurrentRowAlignment := taLeftJustify;
end;

procedure TsHtml.NewFont(const s: string);
var
  len : integer;
begin
  len := High(aFonts);
  inc(len, 2);
  SetLength(aFonts, len);
  aFonts[len - 1] := TFont.Create;
  aFonts[len - 1].Assign(Bitmap.Canvas.Font);
  SetFont(Bitmap.Canvas.Font, s);
end;

procedure TsHtml.NewRow;
begin
  CurY := CurY + CurrentRowHeight + 2;
  if CurWidthValue > MaxBmpWidth then MaxBmpWidth := CurWidthValue;
  CurWidthValue := 0;
  CurrentRowHeight := 0;
end;

procedure TsHtml.SetAlignment(const Tag: string);
const
  Delims = [' ', '=', '"', #13, #10, '<', '>'];
var
  i, count : integer;
  Atom, Value : string;
begin
  count := WordCount(Tag, Delims);
  for i := 1 to count do begin
    Atom := ExtractWord(i, Tag, Delims);
    if Atom = 'ALIGN' then begin
      Value := ExtractWord(i + 1, Tag, Delims);
      if Value <> '' then begin
        if Value = 'CENTER' then CurrentRowAlignment := taCenter;
        if Value = 'LEFT' then CurrentRowAlignment := taLeftJustify;
        if Value = 'RIGHT' then CurrentRowAlignment := taRightJustify;
      end;
    end;
  end;
end;

{KJS CHANGED VARIBLE NAMES FOR CLARITY AND REMOVED VAR AS IT WAS NOT BEING USED!}
procedure TsHtml.ShowCut(inCurPos: integer; inLastPos: integer);
var
  CutString : string;
  i, SpaceWidth, sw : integer;
  procedure OutLine(sLine : acString);
  var
    j, c, w, h, CharCount : integer;
    s : string;
  begin
    c := WordCount(sLine, [' ']);
    CharCount := 0;
    for j := 1 to c do begin
      s := ExtractWord(j, sLine, [' ']);
      w := Bitmap.Canvas.TextWidth(s);
      h := Bitmap.Canvas.TextHeight('X');
      if w > WidthOf(Area) then begin
        CurX := Area.Left;
        if not Calculating then Bitmap.Canvas.TextOut(CurX, CurY, s);
        CurrentRowHeight := max(CurrentRowHeight, h);
        inc(CurY, CurrentRowHeight);
        CharCount := Length(s);
        if CharCount > 0 then
          Delete(sLine, 1, CharCount);
        OutLine(sLine);
        Break;
      end
      else if (CurX + w > Area.Right) then begin
        CurX := Area.Left;
        CurrentRowHeight := max(CurrentRowHeight, h);
        inc(CurY, CurrentRowHeight);
        if CharCount > 0 then
          Delete(sLine, 1, CharCount);
        OutLine(sLine);
        Break;
      end
      else begin
        if not Calculating then Bitmap.Canvas.TextOut(CurX, CurY, s);
        CurX := CurX + w + SpaceWidth;
        inc(CharCount, Length(s) + 1);
        CurWidthValue := max(CurWidthValue, CurX);
        CurrentRowHeight := max(CurrentRowHeight, h);
      end;
    end;
  end;
begin
  CutString := '';
  for i := inLastPos to inCurPos - 1 do
    if not CharInSet(Origin[i], DisabledChars) then
      CutString := CutString + Origin[i];
  if (CutString <> '') then begin
    Bitmap.Canvas.Brush.Style := bsClear;
    sw := Bitmap.Canvas.TextWidth(CutString);
    if (Area.Right > 0) and (CurX + sw > Area.Right) then begin
      SpaceWidth := Bitmap.Canvas.TextWidth(' ');
      if CutString[1] = ' ' then inc(CurX, SpaceWidth);
      OutLine(CutString);
    end
    else begin
      if not Calculating then Bitmap.Canvas.TextOut(CurX, CurY, CutString);
      CurX := CurX + sw;
      CurWidthValue := max(CurWidthValue, CurX);
      CurrentRowHeight := max(CurrentRowHeight, Bitmap.Canvas.TextHeight('X'));
    end;
  end;
end;

end.
