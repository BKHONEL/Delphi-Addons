unit sAlphaGraph;
{$I sDefs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {$IFNDEF DELPHI5}Types,{$ENDIF}
    ComCtrls, sConst, ExtCtrls, Jpeg, math{$IFNDEF ACHINTS}, sMaskData, sCommonData{$ENDIF};

{$IFNDEF NOTFORHELP}
type
  TsCorner = (scLeftTop, scLeftBottom, scRightTop, scRightBottom);
  TsCorners = set of TsCorner;

{$ENDIF} // NOTFORHELP
function SwapColor(Color : TColor) : TColor;
function SwapRedBlue(Color : TColor) : TColor;
procedure BlendColorRect(Bmp: TBitmap; R: TRect; Transparency: TPercent; Color: TColor);
procedure FillRect32(const Bmp : TBItmap; R : TRect; Color : TColor; Alpha : byte = MaxByte);
procedure FillAlphaRect(const Bmp : TBItmap; const R : TRect; Value : byte; SkipFuchsia : boolean = False);

{$IFNDEF ACHINTS}
// Copy with AlphaMask from MasterBmp (get transp. pixels from parent)
procedure CopyMasterRect(R1, R2 : TRect; Bmp : TBitmap; CI : TCacheInfo; MaskData : TsMaskData);
procedure DrawSmallSkinRect(Bmp : TBitmap; R : TRect; Filling : boolean; ci : TCacheInfo; MaskData : TsMaskData; State : integer);
// Skinned rectangle with transparent corners
procedure DrawSkinRect(const Bmp : TBitmap; const R : TRect; const Filling : boolean; const ci : TCacheInfo; const MaskData : TsMaskData; const State : integer; const UpdateCorners : boolean; SkinManager : TObject = nil);
procedure DrawSkinRect32(const Bmp : TBitmap; const R : TRect; const Filling : boolean; const ci : TCacheInfo; const MaskData : TsMaskData; const State : integer; SkinManager : TObject = nil);
// Skip transparent part of corners
procedure DrawSkinGlyph(Bmp : TBitmap; P : TPoint; State, AddedTransparency : integer; MaskData : TsMaskData; const CI : TCacheInfo);
procedure StretchBltMask(DstX1, DstY1, Dst_Width, Dst_Height, SrcX1, SrcY1, Src_Width, Src_Height : integer; BmpDst, BmpSrc : TBitmap; MaskOffset : integer; NoStdStretch : boolean = False);
procedure StretchBltMask32(DstX1, DstY1, Dst_Width, Dst_Height, SrcX1, SrcY1, Src_Width, Src_Height : integer; BmpDst, BmpSrc : TBitmap; MaskOffset : integer; NoStdStretch : boolean = False);
// Transparency - percent of the bmp visibility
procedure BmpDisabledKind(Bmp : TBitmap; DisabledKind : TsDisabledKind; Parent : TControl; CI : TCacheInfo; Offset : TPoint);
{$IFNDEF NOTFORHELP}
// Skip transparent pixels
procedure CopyMasterRectA(R1, R2 : TRect; Bmp : TBitmap; CI : TCacheInfo; MaskData : TsMaskData);
procedure CopyByMask32(R1, R2 : TRect; const Bmp1, Bmp2 : TBitmap; CI : TCacheInfo; const MaskData : TsMaskData);
procedure BlendGlyphByMask(R1, R2 : TRect; Bmp1, Bmp2 : TBitmap; TransColor : TColor; AddedTransparency : integer; MaskData : TsMaskData);
//procedure UpdateCorners(SkinData : TsCommonData; State : integer); overload;
procedure UpdateCorners(SkinData : TsCommonData; State : integer; Corners : TsCorners = [scLeftTop, scLeftBottom, scRightTop, scRightBottom]); //overload;
procedure FillTransPixels32(const DstBmp, SrcBmp : TBitmap; const DstRect : TRect; const SrcPoint : TPoint; MaskIndex : integer = -1; SkinManager : TObject = nil; MaskPos : Cardinal = HTTOPLEFT);
{$IFNDEF WIN64}
procedure FillLongword(var X; Count: Integer; Value: Longword);
{$ENDIF}
// Copy mask (red channel in bitmap) as AlphaChannel
procedure ConvertMaskToAlpha(DstBmp, SrcBmp : TBitmap; DstRect, SrcRect : TRect);

procedure WriteText32(const Bmp : TBitmap; Text: PacChar; Enabled: boolean; var aRect : TRect; Flags: Cardinal; SkinIndex : integer; Hot : boolean; SkinManager : TObject = nil; IsAnsi : boolean = False);
//function CorrectColor32(Color : TColor) : TColor; {$IFDEF WARN_DEPRECATED} deprecated; {$ENDIF}
procedure FillDCBorder32(const Bmp: TBitmap; const aRect: TRect; const wl, wt, wr, wb : integer; const Color: TColor);
//procedure PaintTransPixels(const DstBmp : TBitmap; R: TRect; const MaskData : TsMaskData; CI : TCacheInfo; State : integer; SkinManager : TObject);
function SwapLong(Value: Cardinal): Cardinal; overload;
function GetAPixel(const Bmp : TBitmap; x, y : integer) : TsColor;
procedure SetAPixel(const Bmp : TBitmap; x, y : integer; Value : TsColor);
//procedure PaintItem32(SkinIndex : integer; Filling : boolean; State : integer; R : TRect; pP : TPoint; DC : HDC; SkinManager : TObject = nil); overload;
procedure PaintItem32(SkinIndex : integer; Filling : boolean; State : integer; R : TRect; pP : TPoint; ItemBmp : TBitmap; SkinManager : TObject = nil); overload;
procedure PaintItemBG32(SkinIndex : integer; State : integer; R : TRect; pP : TPoint; ItemBmp : TBitmap; SkinManager : TObject; OffsetX : integer = 0; OffsetY : integer = 0; CustomColor : TColor = clFuchsia);
procedure UpdateAlpha(Img: TBitmap); overload;
procedure UpdateAlpha(Img: TBitmap; R : TRect); overload;
//procedure InvertAlpha(Img: TBitmap; R : TRect); overload;

{$ENDIF} // NOTFORHELP
{$ENDIF}
implementation

Uses acntUtils, sGraphUtils{$IFNDEF ACHINTS}, sDefaults, sVclUtils, sSkinManager{$ENDIF}, sGradient;

function SwapLong(Value: Cardinal): Cardinal; overload;
{$IFDEF WIN64}
begin
  PByte(@Result)[0] := PByte(@Value)[3];
  PByte(@Result)[1] := PByte(@Value)[2];
  PByte(@Result)[2] := PByte(@Value)[1];
  PByte(@Result)[3] := PByte(@Value)[0];
{$ELSE}
asm
  BSWAP EAX
{$ENDIF}
end;

procedure UpdateAlpha(Img: TBitmap);
begin
  UpdateAlpha(Img, Rect(0, 0, Img.Width, Img.Height));
end;

procedure UpdateAlpha(Img: TBitmap; R : TRect);
var
  x, y : integer;
  S : PRGBAArray;
begin
  for Y := R.Top to R.Bottom - 1 do begin
    S := Img.ScanLine[Y];
    for X := R.Left to R.Right - 1 do with S[X] do if (I = clWhite) then I := 0 else begin
      R := (R * A) shr 8;
      G := (G * A) shr 8;
      B := (B * A) shr 8;
    end;
  end;
end;
{
procedure InvertAlpha(Img: TBitmap; R : TRect); overload;
var
  x, y : integer;
  S : PRGBAArray;
begin
  for Y := R.Top to R.Bottom - 1 do begin
    S := Img.ScanLine[Y];
    for X := R.Left to R.Right - 1 do with S[X]
      do S[X].A := MaxByte - S[X].A;
  end;
end;
}
function GetAPixel(const Bmp : TBitmap; x, y : integer) : TsColor;
var
  S : PRGBAArray;
begin
  S := Bmp.ScanLine[Y];
  Result.I := S[X].I;
end;

procedure SetAPixel(const Bmp : TBitmap; x, y : integer; Value : TsColor);
var
  S : PRGBAArray;
begin
  S := Bmp.ScanLine[Y];
  S[X].I := Value.I;
end;

procedure FillTransPixels32(const DstBmp, SrcBmp : TBitmap; const DstRect : TRect; const SrcPoint : TPoint; MaskIndex : integer = -1; SkinManager : TObject = nil; MaskPos : Cardinal = HTTOPLEFT);
var
  S, D : PRGBAArray;
  X, Y, w, h, wi, hi : integer;
  C : TsColor_;
  M : PRGBAArray;
  mOffset : TPoint;
  MaskBmp : TBitmap;
begin
//  if (SrcPoint.y < 0) or (SrcPoint.x < 0) then Exit;
  w := min(WidthOf(DstRect, True) - 1, SrcBmp.Width - SrcPoint.X - 1);
  h := min(HeightOf(DstRect, True) - 1, SrcBmp.Height - SrcPoint.Y - 1);
  if (MaskIndex = -1) then begin
    for Y := 0 to h do begin
      S := SrcBmp.ScanLine[SrcPoint.Y + Y];
      D := DstBmp.ScanLine[DstRect.Top + Y];
      for X := 0 to w do begin
        C := D[DstRect.Left + X];
        C.A := 0;
        if C.C = clFuchsia then D[DstRect.Left + X] := S[SrcPoint.X + X];
      end;
    end;
  end
  else with TsSkinManager(SkinManager) do begin
    MaskBmp := ma[MaskIndex].Bmp;
    if MaskBMp = nil then MaskBmp := MasterBitmap;
    wi := WidthOfImage(ma[MaskIndex]);
    hi := HeightOfImage(ma[MaskIndex]);
    case MaskPos of
      HTTOPLEFT : mOffset := ma[MaskIndex].R.TopLeft;
      HTTOPRIGHT : mOffset := Point(ma[MaskIndex].R.Left + wi - ma[MaskIndex].WR, ma[MaskIndex].R.Top);
      HTBOTTOMLEFT : mOffset := Point(ma[MaskIndex].R.Left, ma[MaskIndex].R.Top + hi - ma[MaskIndex].WB);
      HTBOTTOMRIGHT : mOffset := Point(ma[MaskIndex].R.Left + wi - ma[MaskIndex].WR, ma[MaskIndex].R.Top + hi - ma[MaskIndex].WB);
      else mOffset := ma[MaskIndex].R.TopLeft;
    end;
    for Y := 0 to h do begin
      S := SrcBmp.ScanLine[SrcPoint.Y + Y];
      D := DstBmp.ScanLine[DstRect.Top + Y];
      M := MaskBMp.ScanLine[mOffset.Y + Y];
      for X := 0 to w do begin
        C := M[mOffset.X + X];
        C.A := 0;
        if C.C = clFuchsia then D[DstRect.Left + X] := S[SrcPoint.X + X];
      end;
    end;
  end;
end;

procedure WriteText32(const Bmp : TBitmap; Text: PacChar; Enabled: boolean; var aRect : TRect; Flags: Cardinal; SkinIndex : integer; Hot : boolean; SkinManager : TObject = nil; IsAnsi : boolean = False);
var
  R, Rd: TRect;
  State, nLength: Integer;
  C : TColor;
  procedure WriteColor(const Bmp : TBitmap; Text: PacChar; Length : integer; Enabled: boolean; var lRect : TRect; Flags: Cardinal; Color : TColor);
  var
    TmpBmp : TBitmap;
    R : TRect;
    x, y, h, w, miny, minx : integer;
    S, D : PRGBAArray;
    C : TsColor_;
    SrcColor : TsColor;
  begin
    TmpBmp := CreateBmp32(WidthOf(lRect), HeightOf(lRect));
    TmpBmp.Canvas.Font.Assign(Bmp.Canvas.Font);

    SetTextColor(TmpBmp.Canvas.Handle, 0);
    SetBkColor(TmpBmp.Canvas.Handle, clWhite);

    R := Rect(0, 0, TmpBmp.Width, TmpBmp.Height);
    if IsAnsi
      then DrawText(TmpBmp.Canvas.Handle, PAnsiChar(Text), StrLen(PChar(Text)), R, Flags)
      else AcDrawText(TmpBmp.Canvas.Handle, Text, R, Flags);

    h := TmpBmp.Height - 1;
    w := TmpBmp.Width - 1;

    if lRect.Top + h > Bmp.Height - 1 then h := Bmp.Height - 1 - lRect.Top;
    if lRect.Left + w > Bmp.Width - 1 then w := Bmp.Width - 1 - lRect.Left;
    if lRect.Top < 0 then miny := -lRect.Top else miny := 0;
    if lRect.Left < 0 then minx := -lRect.Left else minx := 0;

    C.A := MaxByte;
    SrcColor.C := Color;

    if Enabled then for y := miny to h do begin
      S := TmpBmp.ScanLine[y];
      D := Bmp.ScanLine[y + lRect.Top];
      for x := minx to w do begin
        if (S[x].C <> clWhite) and (S[x].I <> -1) then begin
//          b := (S[x].R + S[x].G + S[x].B) div 3;
          C.R := ((D[x + lRect.Left].R - SrcColor.R) * S[x].R + SrcColor.R shl 8) shr 8;
          C.G := ((D[x + lRect.Left].G - SrcColor.G) * S[x].G + SrcColor.G shl 8) shr 8;
          C.B := ((D[x + lRect.Left].B - SrcColor.B) * S[x].B + SrcColor.B shl 8) shr 8;
          D[x + lRect.Left] := C;
        end;
      end;
    end
    else for y := miny to h do begin
      S := TmpBmp.ScanLine[y];
      D := Bmp.ScanLine[y + lRect.Top];
      for x := minx to w do begin
        if (S[x].C <> clWhite) and (S[x].I <> -1) then begin
//          b := (S[x].R + S[x].G + S[x].B) div 3;
          C.R := ((D[x + lRect.Left].R - SrcColor.R) * S[x].R + SrcColor.R shl 8) shr 8;
          C.G := ((D[x + lRect.Left].G - SrcColor.G) * S[x].G + SrcColor.G shl 8) shr 8;
          C.B := ((D[x + lRect.Left].B - SrcColor.B) * S[x].B + SrcColor.B shl 8) shr 8;
          D[x + lRect.Left] := C;
        end;
      end;
    end;
    FreeAndNil(TmpBmp);
  end;
begin
 if (Text <> '') and not IsRectEmpty(aRect) then begin
    nLength := Length(Text);
    if SkinManager = nil then SkinManager := DefaultManager;
    if Assigned(SkinManager) then with TsSkinManager(SkinManager) do begin
      R := aRect;
      if IsValidSkinIndex(SkinIndex) then begin
        if Hot and (gd[SkinIndex].States > 0) then State := 1 else State := 0;
        if Enabled then begin
          // Left
          C := gd[SkinIndex].Props[State].FontColor.Left;
          if C <> -1 then begin
            Rd := Rect(R.Left - 1, R.Top, R.Right - 1, R.Bottom);
            WriteColor(Bmp, Text, nLength, True, Rd, Flags, C);
          end;
          // Top
          C := gd[SkinIndex].Props[State].FontColor.Top;
          if C <> -1 then begin
            Rd := Rect(R.Left, R.Top - 1, R.Right, R.Bottom - 1);
            WriteColor(Bmp, Text, nLength, True, Rd, Flags, C);
          end;
          // Right
          C := gd[SkinIndex].Props[State].FontColor.Right;
          if C <> -1 then begin
            Rd := Rect(R.Left + 1, R.Top, R.Right + 1, R.Bottom);
            WriteColor(Bmp, Text, nLength, True, Rd, Flags, C);
          end;
          // Bottom
          C := gd[SkinIndex].Props[State].FontColor.Bottom;
          if C <> -1 then begin
            Rd := Rect(R.Left, R.Top + 1, R.Right, R.Bottom + 1);
            WriteColor(Bmp, Text, nLength, True, Rd, Flags, C);
          end;
        end;
        // Center
        C := gd[SkinIndex].Props[State].FontColor.Color;
        WriteColor(Bmp, Text, nLength, Enabled, R, Flags, C);
      end
      else WriteColor(Bmp, Text, nLength, Enabled, R, Flags, Bmp.Canvas.Font.Color);
    end
    else begin
      WriteColor(Bmp, Text, nLength, Enabled, aRect, Flags, Bmp.Canvas.Font.Color);
    end;
  end;
end;
{
function CorrectColor32(Color : TColor) : TColor;
var
  c : TsColor;
begin
  if Color = -1 then Result := -1 else begin
    c.C := Color;
    C.A := MaxByte;
    Result := C.C
  end;
end;
}
procedure FillDCBorder32(const Bmp: TBitmap; const aRect: TRect; const wl, wt, wr, wb : integer; const Color: TColor);
begin
  FillRect32(Bmp, Rect(aRect.Left, aRect.Top, aRect.Right, aRect.Top + wt), Color);
  FillRect32(Bmp, Rect(aRect.Left, aRect.Top + wt, aRect.Left + wl, aRect.Bottom), Color);
  FillRect32(Bmp, Rect(aRect.Left + wl, aRect.Bottom - wb, aRect.Right, aRect.Bottom), Color);
  FillRect32(Bmp, Rect(aRect.Right - wr, aRect.Top + wt, aRect.Right, aRect.Bottom - wb), Color);
end;

procedure BlendColorRect(Bmp: TBitmap; R: TRect; Transparency: TPercent; Color: TColor);
var
  BmpLine : PRGBAArray;
  BlendColor : TsColor;
  x, y : integer;
  rT, tR : real;
begin
  if R.Left < 0 then R.Left := 0;
  if R.Top < 0 then R.Top := 0;
  if R.Right > Bmp.Width - 1 then R.Right := Bmp.Width - 1;
  if R.Bottom > Bmp.Height - 1 then R.Bottom := Bmp.Height - 1;
  BlendColor.C := ColorToRGB(Color);
  rT := Transparency / 100;
  tR := 1 - rT;
  for y := R.Top to R.Bottom do begin
    BmpLine := Bmp.ScanLine[y];
    for x := R.Left to R.Right do begin
      BmpLine[X].R := Round(BmpLine[X].R * rT + BlendColor.R * tR);
      BmpLine[X].G := Round(BmpLine[X].G * rT + BlendColor.G * tR);
      BmpLine[X].B := Round(BmpLine[X].B * rT + BlendColor.B * tR);
    end;
  end;
end;

function SwapColor(Color : TColor) : TColor;
asm
  BSWAP   EAX
  ROR     EAX,8
end;

function SwapRedBlue(Color : TColor) : TColor;
begin
  TsColor(Result).A := TsColor_(Color).A;
  TsColor(Result).R := TsColor_(Color).R;
  TsColor(Result).G := TsColor_(Color).G;
  TsColor(Result).B := TsColor_(Color).B;
end;

procedure FillRect32(const Bmp : TBItmap; R : TRect; Color : TColor; Alpha : byte = MaxByte);
var
  S : PRGBAArray;
  X, Y : integer;
  C : TsColor_;
begin
  if Bmp.Height < R.Bottom then R.Bottom := Bmp.Height;

  C.C := SwapRedBlue(Color);
  C.A := Alpha;

{  if Bmp.Height = 1 then begin
    if (R.Top >= 0) and (R.Top < Bmp.Height) then begin
      S := Bmp.ScanLine[R.Top];
      for X := 0 to Bmp.Width - 1 do S[R.Left + X] := C
    end;
  end
  else begin   }
  for Y := max(0, R.Top) to min(Bmp.Height, R.Bottom) - 1 do begin
    S := Bmp.ScanLine[Y];
    for X := max(0, R.Left) to min(Bmp.Width, R.Right) - 1 do S[X] := C;
  end;
//  end;
end;

procedure BlendRect32(const Bmp : TBItmap; R : TRect; Color : TColor; BlendValue : byte; Alpha : byte = MaxByte);
var
  S : PRGBAArray;
  X, Y : integer;
  Col : TsColor_;
begin
  if Bmp.Height < R.Bottom then R.Bottom := Bmp.Height;

  Col.C := SwapRedBlue(Color);
  Col.A := Alpha;

  for Y := max(0, R.Top) to min(Bmp.Height, R.Bottom) - 1 do begin
    S := Bmp.ScanLine[Y];
    for X := max(0, R.Left) to min(Bmp.Width, R.Right) - 1 do with S[X] do begin
      R := Round(R - BlendValue * (R - Col.R) / 100);
      G := Round(G - BlendValue * (G - Col.G) / 100);
      B := Round(B - BlendValue * (B - Col.B) / 100);
      A := Col.A;
    end;
  end;
end;

procedure FillAlphaRect(const Bmp : TBItmap; const R : TRect; Value : byte; SkipFuchsia : boolean = False);
var
  S : PRGBAArray;
  X, Y, w, h : integer;
begin
  w := WidthOf(R, True) - 1;
  h := HeightOf(R, True) - 1;
  if SkipFuchsia then for Y := 0 to h do begin
    S := Bmp.ScanLine[R.Top + Y];
    for X := 0 to w do if TsColor_(S[R.Left + X]).C <> clFuchsia then TsColor_(S[R.Left + X]).A := Value;
  end
  else for Y := 0 to h do begin
    S := Bmp.ScanLine[R.Top + Y];
    for X := 0 to w do TsColor_(S[R.Left + X]).A := Value;
  end;
end;

{$IFNDEF ACHINTS}
procedure BmpDisabledKind(Bmp : TBitmap; DisabledKind : TsDisabledKind; Parent : TControl; CI : TCacheInfo; Offset : TPoint);
var
  C : TColor;
  R : TRect;
begin
  if (dkGrayed in DisabledKind) then begin
    GrayScale(Bmp);
  end;
  if (dkBlended in DisabledKind) then begin
    R := Rect(0, 0, Bmp.Width, Bmp.Height);
    if CI.Ready then begin
      OffsetRect(R, CI.X + Offset.X, CI.Y + Offset.Y);
      BlendTransRectangle(Bmp, 0, 0, CI.Bmp, R, DefDisabledBlend);
    end
    else begin
      if CI.FillColor <> clFuchsia then C := CI.FillColor else C := GetControlColor(Parent);
      BlendColorRect(Bmp, R, 50, C);
    end;
  end;
end;

procedure DrawSmallSkinRect(Bmp : TBitmap; R : TRect; Filling : boolean; ci : TCacheInfo; MaskData : TsMaskData; State : integer);
var
  x, y : integer;
  w, h : integer;
  dw, dh : integer;
  mw, mh, minhp, minwp, minh, minw : integer;
begin
  if MaskData.Bmp = nil then with TsSkinManager(MaskData.Manager) do begin
    if MaskData.Manager = nil then Exit;
    if (WidthOf(R) < 2) or (HeightOf(R) < 2) then Exit;

    if MaskData.ImageCount = 0 then exit;
    if State >= MaskData.ImageCount then State := MaskData.ImageCount - 1;
    dw := State * WidthOf(MaskData.R) div (MaskData.ImageCount);        // Width of mask
    dh := HeightOf(MaskData.R) div (1 + MaskData.MaskType);             // Height of mask

    w := WidthOf(MaskData.R) div (3 * MaskData.ImageCount);
    h := HeightOf(MaskData.R) div (3 * (1 + MaskData.MaskType));

    if WidthOf(R) < w * 2 then mw := WidthOf(R) div 2 else mw := 0;
    if HeightOf(R) < h * 2 then mh := HeightOf(R) div 2 else mh := 0;
    
    if mh > 0 then begin
      minh := mh;
      if HeightOf(R) mod 2 <> 0 then minhp := minh + 1 else minhp := minh;
    end
    else begin
      minh := h;
      minhp := h;
    end;
    if mw > 0 then begin
      minw := mw;
      if WidthOf(R) mod 2 <> 0 then minwp := minw + 1 else minwp := minw;
    end
    else begin
      minw := w;
      minwp := w;
    end;

    if MaskData.MaskType = 0 then begin
      // left - top
      CopyTransRect(Bmp, MasterBitmap, R.Left, R.Top, Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + minw, MaskData.R.Top + minh), clFuchsia, CI, True);
      // left - middle
      y := R.Top + h;
      if MaskData.DrawMode and BDM_STRETCH = 0 then begin
        while y < R.Bottom - h do begin
          BitBlt(Bmp.Canvas.Handle, R.Left, y, minw, h, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + h, SRCCOPY);
          inc(y, h);
        end;
        if y < R.Bottom - h then BitBlt(Bmp.Canvas.Handle, R.Left, y, minw, h,
               MasterBitmap.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + h, SRCCOPY);
      end
      else StretchBlt(Bmp.Canvas.Handle, R.Left, y, R.Left + minw, R.Bottom - minh - y, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + h, minw, h, SRCCOPY);

      // top - middle
      x := R.Left + minw;
      if MaskData.DrawMode and BDM_STRETCH = 0 then begin
        while x < R.Right - w - minw do begin
          BitBlt(Bmp.Canvas.Handle, x, R.Top, w, minh, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top, SRCCOPY);
          inc(x, w);
        end;
        if x < R.Right - minw then BitBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - minw - x, minh, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top, SRCCOPY);
      end
      else StretchBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - minw - x, minh, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top, w, minh, SRCCOPY);

      // left - bottom
      CopyTransRect(Bmp, MasterBitmap, R.Left, R.Bottom - minhp, Rect(MaskData.R.Left + dw, MaskData.R.Bottom - minhp, MaskData.R.Left + dw + minw - 1,
                         MaskData.R.Bottom - 1), clFuchsia, CI, True);
      // bottom - middle
      x := R.Left + minw;
      if MaskData.DrawMode and BDM_STRETCH = 0 then begin
        while x < R.Right - w - minw do begin
          BitBlt(Bmp.Canvas.Handle, x, R.Bottom - minh, w, minh, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Bottom - minh, SRCCOPY);
          inc(x, w);
        end;
        if x < R.Right - minw then BitBlt(Bmp.Canvas.Handle, x, R.Bottom - minh, R.Right - minw - x, minh,
                                          MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Bottom - minh, SRCCOPY);
      end
      else StretchBlt(Bmp.Canvas.Handle, x, R.Bottom - minh, R.Right - minw - x, minh, MasterBitmap.Canvas.Handle,
                 MaskData.R.Left + dw + w, MaskData.R.Bottom - minh, w, minh, SRCCOPY);
      // right - bottom
      CopyTransRect(Bmp, MasterBitmap, R.Right - minwp, R.Bottom - minhp,
                    Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Bottom - minhp, MaskData.R.Left + dw + 3 * w - 1, MaskData.R.Bottom - 1), clFuchsia, CI, True);
      // right - top
      CopyTransRect(Bmp, MasterBitmap, R.Right - minwp, R.Top,
                    Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top, MaskData.R.Left + dw + 3 * w - 1, MaskData.R.Top + minh - 1), clFuchsia, CI, True);
      // right - middle
      y := R.Top + h;
      while y < R.Bottom - h do begin
        BitBlt(Bmp.Canvas.Handle, R.Right - minwp, y, minwp, h, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top + h, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - h then begin
        BitBlt(Bmp.Canvas.Handle, R.Right - minwp, y, minwp, R.Bottom - h - y, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top + h, SRCCOPY);
      end;

      // Fill
      if {Filling and} (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
        y := R.Top + h;
        while y < R.Bottom - 2 * h do begin
          x := R.Left + w;
          while x < R.Right - 2 * w do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, h, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top + h, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - w then begin
            BitBlt(Bmp.Canvas.Handle, x, y, R.Right - w - x,  R.Bottom - h - y, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top + h, SRCCOPY);
          end;
          inc(y, h);
        end;
        x := R.Left + w;
        if y < R.Bottom - h then begin
          while x < R.Right - 2 * w do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w,  R.Bottom - h - y, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top + h, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - w then begin
            BitBlt(Bmp.Canvas.Handle, x, y, R.Right - w - x, R.Bottom - h - y, MasterBitmap.Canvas.Handle, MaskData.R.Left + dw + w, MaskData.R.Top + h, SRCCOPY);
          end
        end;
      end;

    end
    else begin
      CopyMasterRect(Rect(R.Left, R.Top, R.Left + minw + 1, R.Top + minh + 1), Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + minw, MaskData.R.Top + minh), Bmp, ci, MaskData);
      // left - middle
      y := R.Top + h;
      while y < R.Bottom - h do begin
        CopyMasterRect(Rect(R.Left, y, R.Left + minw + 1, y + h + 1), Rect(MaskData.R.Left + dw, MaskData.R.Top + h, MaskData.R.Left + dw + minw, MaskData.R.Top + 2 * h), Bmp, CI, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - h then begin
        CopyMasterRect(Rect(R.Left, y, R.Left + minw, R.Bottom - h), Rect(MaskData.R.Left + dw, MaskData.R.Top + h, MaskData.R.Left + dw + minw, MaskData.R.Top + dh - h), Bmp, CI, MaskData);
      end;
      // top - middle
      x := R.Left + w;
      while x < R.Right - 2 * w do begin
        CopyMasterRect(Rect(x, R.Top, x + w, R.Top + minh), Rect(MaskData.R.Left + dw + w, MaskData.R.Top, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + minh), Bmp, CI, MaskData);
        inc(x, w);
      end;
      if x < R.Right - w then begin
        CopyMasterRect(Rect(x, R.Top, R.Right - w, R.Top + minh), Rect(MaskData.R.Left + dw + w, MaskData.R.Top, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + minh), Bmp, CI, MaskData);
      end;
      // left - bottom
      CopyMasterRect(Rect(R.Left, R.Bottom - minhp, R.Left + minw, R.Bottom), Rect(MaskData.R.Left + dw, MaskData.R.Top + dh - minhp, MaskData.R.Left + dw + minw, MaskData.R.Top + dh), Bmp, CI, MaskData);
      // bottom - middle
      x := R.Left + w;
      while x < R.Right - 2 * w do begin
        CopyMasterRect(Rect(x, R.Bottom - minhp, x + w, R.Bottom), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + dh - minhp, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + dh), Bmp, CI, MaskData);
        inc(x, w);
      end;
      if x < R.Right - w then begin
        CopyMasterRect(Rect(x, R.Bottom - minhp, R.Right - w, R.Bottom), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + dh - minhp, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + dh), Bmp, CI, MaskData);
      end;
      // right - bottom
      CopyMasterRect(Rect(R.Right - minwp, R.Bottom - minhp, R.Right, R.Bottom), Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top + dh - minhp, MaskData.R.Left + dw + 3 * w, MaskData.R.Top + dh), Bmp, CI, MaskData);
      // right - top
      CopyMasterRect(Rect(R.Right - minwp, R.Top, R.Right, R.Top + minh), Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top, MaskData.R.Left + dw + 3 * w, MaskData.R.Top + minh), Bmp, CI, MaskData);
      // right - middle
      y := R.Top + h;
      while y < R.Bottom - h do begin
        CopyMasterRect(Rect(R.Right - minwp, y, R.Right, y + h), Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top + h, MaskData.R.Left + dw + 3 * w, MaskData.R.Top + 2 * h), Bmp, CI, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - h then begin
        CopyMasterRect(Rect(R.Right - minwp, y, R.Right, R.Bottom - h), Rect(MaskData.R.Left + dw + 3 * w - minwp, MaskData.R.Top + h, MaskData.R.Left + dw + 3 * w, MaskData.R.Top + 2 * h), Bmp, CI, MaskData);
      end;
      // Fill
      if {Filling and} (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
        y := R.Top + h;
        while y < R.Bottom - h do begin
          x := R.Left + w;
          while x < R.Right - 2 * w do begin
            CopyMasterRect(Rect(x, y, x + w, y + h), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + h, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + 2 * h), Bmp, EmptyCI, MaskData);
            inc(x, w);
          end;
          if x < R.Right - w then begin
            CopyMasterRect(Rect(x, y, R.Right - w, y + h), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + h, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + 2 * h), Bmp, EmptyCI, MaskData);
          end;
          inc(y, h);
        end;
        x := R.Left + w;
        if y < R.Bottom - h then begin
          while x < R.Right - 2 * w do begin
            CopyMasterRect(Rect(x, y, x + w, R.Bottom - h), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + h, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + 2 * h), Bmp, EmptyCI, MaskData);
            inc(x, w);
          end;
          if x < R.Right - w then begin
            CopyMasterRect(Rect(x, y, R.Right - w, R.Bottom - h), Rect(MaskData.R.Left + dw + w, MaskData.R.Top + h, MaskData.R.Left + dw + 2 * w, MaskData.R.Top + 2 * h), Bmp, EmptyCI, MaskData);
          end
        end;
      end;
    end;
  end;
end;

procedure DrawSkinRect(const Bmp : TBitmap; const R : TRect; const Filling : boolean; const ci : TCacheInfo; const MaskData : TsMaskData; const State : integer; const UpdateCorners : boolean; SkinManager : TObject = nil);
var
  x, y : integer;
  w, h : integer;
  dw, dh, dhm : integer;
  wl, wt, wr, wb : integer;
  BmpSrc : TBitmap;
  NewState : integer;
  Stretch : boolean;
begin
  if (State = 0) and (MaskData.DrawMode and BDM_ACTIVEONLY = BDM_ACTIVEONLY) then Exit;
  if (WidthOf(R) < 2) or (HeightOf(R) < 2) or (MaskData.Manager = nil) then Exit;
  wl := MaskData.WL; wt := MaskData.WT; wr := MaskData.WR; wb := MaskData.WB;
  if wl + wr > WidthOf(R) then begin
    y := ((wl + wr) - WidthOf(R));
    x := y div 2;
    dec(wl, x); dec(wr, x); if y mod 2 > 0 then dec(wr);
    if wl < 0 then wl := 0;
    if wr < 0 then wr := 0;
  end;
  if wt + wb > HeightOf(R) then begin
    y := ((wt + wb) - HeightOf(R));
    x := y div 2;
    dec(wt, x); dec(wb, x); if y mod 2 > 0 then dec(wb);
    if wt < 0 then wt := 0;
    if wb < 0 then wb := 0;
  end;
  if State >= MaskData.ImageCount then NewState := MaskData.ImageCount - 1 else NewState := State;
//  if MaskData.ImageCount = 0 then begin Exit; end; Version 6 compatibility
  dw := WidthOfImage(MaskData);                  // Width of mask
  dh := HeightOfImage(MaskData);                 // Height of mask
  if MaskData.MaskType = 0 then dhm := 0 else dhm := dh;

  if MaskData.DrawMode and BDM_STRETCH = BDM_STRETCH then begin
    Stretch := True;
    SetStretchBltMode(Bmp.Canvas.Handle, COLORONCOLOR);
  end
  else Stretch := False;

  w := dw - wl - wr;
  if w < 0 then Exit;                            // Width of middle piece must be > 0
  h := dh - wt - wb;
  if h < 0 then Exit;                            // Height of middle piece must be > 0
  dw := dw * NewState;                           // Offset of mask

  if MaskData.Bmp <> nil then BmpSrc := MaskData.Bmp else BmpSrc := TsSkinManager(MaskData.Manager).MasterBitmap;
  if MaskData.MaskType = 0 then begin // Copy without mask
    // left - top
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Top, Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, SRCCOPY);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Top, w, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, SRCCOPY);
    // left - bottom
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Bottom - wb, Rect(MaskData.R.Left + dw, MaskData.R.Bottom - wb, MaskData.R.Left + dw + wl - 1, MaskData.R.Bottom - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, w, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, w, wb, SRCCOPY);
    // right - bottom
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Bottom - wb, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Bottom - wb, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Bottom - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    // right - top
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Top, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    y := R.Top + wt;
    // right - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, SRCCOPY);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if not Stretch then begin
        y := R.Top + wt;
        if h > 0 then while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x,  R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
        end;
      end
      else begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, SRCCOPY);
      end;
    end;
  end
  else begin
    // left - top
    CopyByMask(Rect(R.Left, R.Top, R.Left + wl, R.Top + wt), Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl, MaskData.R.Top + wt), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask(Rect(R.Left, y, R.Left + wl, y + h), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask(Rect(R.Left, y, R.Left + wl, R.Bottom - wb), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + wt + h), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(R.Left, y, wl, R.Bottom - wb - y, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, Bmp, BmpSrc, dhm);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask(Rect(x, R.Top, x + w, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask(Rect(x, R.Top, R.Right - wr, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(x, R.Top, R.Right - wr - x, wt, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, Bmp, BmpSrc, dhm);
    // left - bottom
    CopyByMask(Rect(R.Left, R.Bottom - wb, R.Left + wl, R.Bottom), Rect(MaskData.R.Left + dw, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask(Rect(x, R.Bottom - wb, x + w, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, bmpSrc, EmptyCI, False, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask(Rect(x, R.Bottom - wb, R.Right - wr, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(x, R.Bottom - wb, R.Right - wr - x, wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, w, wb, Bmp, BmpSrc, dhm);
    // right - bottom
    CopyByMask(Rect(R.Right - wr, R.Bottom - wb, R.Right, R.Bottom), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + dh), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // right - top
    CopyByMask(Rect(R.Right - wr, R.Top, R.Right, R.Top + wt), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + wt), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // right - middle
    y := R.Top + wt;
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask(Rect(R.Right - wr, y, R.Right, y + h), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask(Rect(R.Right - wr, y, R.Right, R.Bottom - wb), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(R.Right - wr, y, wr, R.Bottom - wb - y, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, Bmp, BmpSrc, dhm);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if Stretch then begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBltMask(x, y, R.Right - wr - x, R.Bottom - wb - y, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, Bmp, BmpSrc, dhm, True)
      end
      else begin
        y := R.Top + wt;
        while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          while x < R.Right - w - wr do begin
            CopyByMask(Rect(x, y, x + w, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask(Rect(x, y, R.Right - wr, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
          end;
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          while x < R.Right - w - wr do begin
            CopyByMask(Rect(x, y, x + w, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask(Rect(x, y, R.Right - wr, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
          end
        end;
      end;
    end;
  end;
end;
{
procedure DrawSkinRect32(const Bmp : TBitmap; const R : TRect; const Filling : boolean; const MaskData : TsMaskData; const State : integer; SkinManager : TObject = nil);
var
  x, y : integer;
  w, h : integer;
  dw, dh, dhm : integer;
  wl, wt, wr, wb : integer;
  BmpSrc : TBitmap;
  NewState : integer;
  Stretch : boolean;
begin
  if (State = 0) and (MaskData.DrawMode and BDM_ACTIVEONLY = BDM_ACTIVEONLY) then Exit;
  if (WidthOf(R) < 2) or (HeightOf(R) < 2) or (MaskData.Manager = nil) then Exit;
  wl := MaskData.WL; wt := MaskData.WT; wr := MaskData.WR; wb := MaskData.WB;
  if wl + wr > WidthOf(R) then begin
    x := ((wl + wr) - WidthOf(R)) div 2;
    dec(wl, x); dec(wr, x); if WidthOf(R) mod 2 > 0 then dec(wr);
    if wl < 0 then wl := 0;
    if wr < 0 then wr := 0;
  end;
  if wt + wb > HeightOf(R) then begin
    x := ((wt + wb) - HeightOf(R)) div 2;
    dec(wt, x); dec(wb, x); if HeightOf(R) mod 2 > 0 then dec(wb);
    if wt < 0 then wt := 0;
    if wb < 0 then wb := 0;
  end;
  if State >= MaskData.ImageCount then NewState := MaskData.ImageCount - 1 else NewState := State;
//  if MaskData.ImageCount = 0 then begin Exit; end; Version 6 compatibility
  dw := WidthOfImage(MaskData);                  // Width of mask
  dh := HeightOfImage(MaskData);                 // Height of mask
  if MaskData.MaskType = 0 then dhm := 0 else dhm := dh;

  if MaskData.DrawMode and BDM_STRETCH = BDM_STRETCH then begin
    Stretch := True;
    SetStretchBltMode(Bmp.Canvas.Handle, COLORONCOLOR);
  end
  else Stretch := False;

  w := dw - wl - wr;
  if w < 0 then Exit;                            // Width of middle piece must be > 0
  h := dh - wt - wb;
  if h < 0 then Exit;                            // Height of middle piece must be > 0
  dw := dw * NewState;                           // Offset of mask

  if MaskData.Bmp <> nil then BmpSrc := MaskData.Bmp else BmpSrc := TsSkinManager(MaskData.Manager).MasterBitmap;
  if MaskData.MaskType = 0 then begin // Copy without mask
    // left - top
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Top, Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, SRCCOPY);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Top, w, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, SRCCOPY);
    // left - bottom
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Bottom - wb, Rect(MaskData.R.Left + dw, MaskData.R.Bottom - wb, MaskData.R.Left + dw + wl - 1, MaskData.R.Bottom - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, w, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, w, wb, SRCCOPY);
    // right - bottom
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Bottom - wb, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Bottom - wb, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Bottom - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    // right - top
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Top, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, UpdateCorners and (MaskData.CornerType > 0));
    y := R.Top + wt;
    // right - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, SRCCOPY);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if not Stretch then begin
        y := R.Top + wt;
        if h > 0 then while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x,  R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
        end;
      end
      else begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, SRCCOPY);
      end;
    end;
  end
  else begin
    // left - top
    CopyByMask(Rect(R.Left, R.Top, R.Left + wl, R.Top + wt), Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl, MaskData.R.Top + wt), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask(Rect(R.Left, y, R.Left + wl, y + h), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask(Rect(R.Left, y, R.Left + wl, R.Bottom - wb), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + wt + h), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(R.Left, y, wl, R.Bottom - wb - y, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, Bmp, BmpSrc, dhm);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask(Rect(x, R.Top, x + w, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask(Rect(x, R.Top, R.Right - wr, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(x, R.Top, R.Right - wr - x, wt, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, Bmp, BmpSrc, dhm);
    // left - bottom
    CopyByMask(Rect(R.Left, R.Bottom - wb, R.Left + wl, R.Bottom), Rect(MaskData.R.Left + dw, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask(Rect(x, R.Bottom - wb, x + w, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, bmpSrc, EmptyCI, False, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask(Rect(x, R.Bottom - wb, R.Right - wr, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(x, R.Bottom - wb, R.Right - wr - x, wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, w, wb, Bmp, BmpSrc, dhm);
    // right - bottom
    CopyByMask(Rect(R.Right - wr, R.Bottom - wb, R.Right, R.Bottom), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + dh), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // right - top
    CopyByMask(Rect(R.Right - wr, R.Top, R.Right, R.Top + wt), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + wt), Bmp, BmpSrc, CI, UpdateCorners and (MaskData.CornerType > 0), MaskData);
    // right - middle
    y := R.Top + wt;
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask(Rect(R.Right - wr, y, R.Right, y + h), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask(Rect(R.Right - wr, y, R.Right, R.Bottom - wb), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
      end;
    end
    else StretchBltMask(R.Right - wr, y, wr, R.Bottom - wb - y, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, Bmp, BmpSrc, dhm);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if Stretch then begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBltMask(x, y, R.Right - wr - x, R.Bottom - wb - y, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, Bmp, BmpSrc, dhm, True)
      end
      else begin
        y := R.Top + wt;
        while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          while x < R.Right - w - wr do begin
            CopyByMask(Rect(x, y, x + w, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask(Rect(x, y, R.Right - wr, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
          end;
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          while x < R.Right - w - wr do begin
            CopyByMask(Rect(x, y, x + w, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask(Rect(x, y, R.Right - wr, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, False, MaskData);
          end
        end;
      end;
    end;
  end;
end;
}
procedure CopyMasterRect(R1, R2 : TRect; Bmp : TBitmap; CI : TCacheInfo; MaskData : TsMaskData);
var
  S1, S2, M : PRGBAArray;
  X, Y, h, w: Integer;
  col_ : TsColor_;
  col : TsColor;
begin
  if MaskData.Manager = nil then Exit;
  with TsSkinManager(MaskData.Manager) do begin
    h := Min(HeightOf(R1), HeightOf(R2));
    h := Min(h, Bmp.Height - R1.Top);
    h := Min(h, TsSkinManager(MaskData.Manager).MasterBitmap.Height - R2.Top) - 1;
    if h < 0 then Exit;
    w := Min(WidthOf(R1), WidthOf(R2));
    w := Min(w, Bmp.Width - R1.Left);
    w := Min(w, MasterBitmap.Width - R2.Left) - 1;
    if w < 0 then Exit;
    if R1.Left < R2.Left then begin
      if (R1.Left < 0) then begin
        inc(R2.Left, - R1.Left);
        dec(w, - R1.Left);
        R1.Left := 0;
      end;
    end
    else
      if (R2.Left < 0) then begin
        inc(R1.Left, - R2.Left);
        dec(w, - R2.Left);
        R2.Left := 0;
      end;
    if R1.Top < R2.Top then begin
      if (R1.Top < 0) then begin
        inc(R2.Top, - R1.Top);
        dec(h, - R1.Top);
        R1.Top := 0;
      end;
    end
    else
      if (R2.Top < 0) then begin
        inc(R1.Top, - R2.Top);
        dec(h, - R2.Top);
        R2.Top := 0;
      end;
    col_.R := TsColor(CI.FillColor).R;
    col_.G := TsColor(CI.FillColor).G;
    col_.B := TsColor(CI.FillColor).B;
    col_.A := TsColor(CI.FillColor).A;

    if not CI.Ready then begin
      for Y := 0 to h do begin
        S1 := Bmp.ScanLine[R1.Top + Y];
        S2 := MasterBitmap.ScanLine[R2.Top + Y];
        M  := MasterBitmap.ScanLine[R2.Top + HeightOf(MaskData.R) div 2 + Y];
        for X := 0 to w do begin
          if (S2[R2.Left + X].C <> clFuchsia) then begin
            S1[R1.Left + X].R := ((S1[R1.Left + X].R - S2[R2.Left + X].R) * M[R2.Left + X].R + S2[R2.Left + X].R shl 8) shr 8;
            S1[R1.Left + X].G := ((S1[R1.Left + X].G - S2[R2.Left + X].G) * M[R2.Left + X].G + S2[R2.Left + X].G shl 8) shr 8;
            S1[R1.Left + X].B := ((S1[R1.Left + X].B - S2[R2.Left + X].B) * M[R2.Left + X].B + S2[R2.Left + X].B shl 8) shr 8;
          end
          else if CI.FillColor <> clFuchsia then S1[R1.Left + X] := col_;
        end;
      end;
    end
    else begin
      for Y := 0 to h do begin
        S1 := Bmp.ScanLine[R1.Top + Y];
        S2 := MasterBitmap.ScanLine[R2.Top + Y];
        M  := MasterBitmap.ScanLine[R2.Top + HeightOf(MaskData.R) div 2 + Y];
        for X := 0 to w do begin
          if (S2[R2.Left + X].C <> clFuchsia) then begin
            S1[R1.Left + X].R := ((S1[R1.Left + X].R - S2[R2.Left + X].R) * M[R2.Left + X].R + S2[R2.Left + X].R shl 8) shr 8;
            S1[R1.Left + X].G := ((S1[R1.Left + X].G - S2[R2.Left + X].G) * M[R2.Left + X].G + S2[R2.Left + X].G shl 8) shr 8;
            S1[R1.Left + X].B := ((S1[R1.Left + X].B - S2[R2.Left + X].B) * M[R2.Left + X].B + S2[R2.Left + X].B shl 8) shr 8;
          end
          else if CI.FillColor <> clFuchsia then begin
            S1[R1.Left + X].R := col_.R;
            S1[R1.Left + X].G := col_.G;
            S1[R1.Left + X].B := col_.B;
          end
          else begin
            if (CI.Bmp.Height <= R1.Top + ci.Y + Y) then Continue;
            if (CI.Bmp.Width <= R1.Left + ci.X + X) then Break;
            if R1.Top + ci.Y + Y < 0 then Continue;
            if R1.Left + ci.X + X < 0 then Continue;
            col := GetAPixel(ci.Bmp, R1.Left + ci.X + X, R1.Top + ci.Y + Y);
            col_.A := col.A;
            col_.R := col.B;
            col_.G := col.G;
            col_.B := col.R;
            S1[R1.Left + X] := col_;
          end;
        end;
      end;
    end;
  end;
end;

procedure CopyMasterRectA(R1, R2 : TRect; Bmp : TBitmap; CI : TCacheInfo; MaskData : TsMaskData);
var
  S1, S2, M : PRGBAArray;
  X, Y, h, w: Integer;
  col : TsColor;
begin
  if MaskData.Manager = nil then Exit;
  with TsSkinManager(MaskData.Manager) do begin
    h := Min(HeightOf(R1), HeightOf(R2));
    h := Min(h, Bmp.Height - R1.Top);
    h := Min(h, MasterBitmap.Height - R2.Top) - 1;
    if h < 0 then Exit;
    w := Min(WidthOf(R1), WidthOf(R2));
    w := Min(w, Bmp.Width - R1.Left);
    w := Min(w, MasterBitmap.Width - R2.Left) - 1;
    if w < 0 then Exit;
    if R1.Left < R2.Left then begin
      if (R1.Left < 0) then begin
        inc(R2.Left, - R1.Left);
        dec(w, - R1.Left);
        R1.Left := 0;
      end;
    end
    else
      if (R2.Left < 0) then begin
        inc(R1.Left, - R2.Left);
        dec(w, - R2.Left);
        R2.Left := 0;
      end;
    if R1.Top < R2.Top then begin
      if (R1.Top < 0) then begin
        inc(R2.Top, - R1.Top);
        dec(h, - R1.Top);
        R1.Top := 0;
      end;
    end
    else
      if (R2.Top < 0) then begin
        inc(R1.Top, - R2.Top);
        dec(h, - R2.Top);
        R2.Top := 0;
      end;
    col.C := CI.FillColor;
    if not CI.Ready then for Y := 0 to h do begin
      S1 := Bmp.ScanLine[R1.Top + Y];
      S2 := MasterBitmap.ScanLine[R2.Top + Y];
      M  := MasterBitmap.ScanLine[R2.Top + HeightOf(MaskData.R) div 2 + Y];
      for X := 0 to w do if (S2[R2.Left + X].C <> clFuchsia) then begin 
        S1[R1.Left + X].R := ((S1[R1.Left + X].R - S2[R2.Left + X].R) * M[R2.Left + X].R + S2[R2.Left + X].R shl 8) shr 8;
        S1[R1.Left + X].G := ((S1[R1.Left + X].G - S2[R2.Left + X].G) * M[R2.Left + X].G + S2[R2.Left + X].G shl 8) shr 8;
        S1[R1.Left + X].B := ((S1[R1.Left + X].B - S2[R2.Left + X].B) * M[R2.Left + X].B + S2[R2.Left + X].B shl 8) shr 8;
      end;
    end
    else for Y := 0 to h do begin
      S1 := Bmp.ScanLine[R1.Top + Y];
      S2 := MasterBitmap.ScanLine[R2.Top + Y];
      M  := MasterBitmap.ScanLine[R2.Top + HeightOf(MaskData.R) div 2 + Y];
      for X := 0 to w do if (S2[R2.Left + X].C <> clFuchsia) then begin
        S1[R1.Left + X].R := ((S1[R1.Left + X].R - S2[R2.Left + X].R) * M[R2.Left + X].R + S2[R2.Left + X].R shl 8) shr 8;
        S1[R1.Left + X].G := ((S1[R1.Left + X].G - S2[R2.Left + X].G) * M[R2.Left + X].G + S2[R2.Left + X].G shl 8) shr 8;
        S1[R1.Left + X].B := ((S1[R1.Left + X].B - S2[R2.Left + X].B) * M[R2.Left + X].B + S2[R2.Left + X].B shl 8) shr 8;
      end;
    end;
  end;
end;

procedure CopyByMask32(R1, R2 : TRect; const Bmp1, Bmp2 : TBitmap; CI : TCacheInfo; const MaskData : TsMaskData);
var
  S1, S2, M, CacheBMP : PRGBAArray;
  X, Y, h, w, dX1, dX2, hdiv2, k1: Integer;
  a, a_ : integer;
  Cur : TsColor_;
  C1 : TsColor;
  Color : TsColor_;
begin
{$IFDEF NOSLOWDETAILS} Exit;{$ENDIF}
  h := R1.Bottom - R1.Top;
  if h > R2.Bottom - R2.Top then h := R2.Bottom - R2.Top;
  if h > Bmp1.Height - R1.Top then h := Bmp1.Height - R1.Top;
  if h > Bmp2.Height - R2.Top then h := Bmp2.Height - R2.Top - 1 else h := h - 1;
  if h < 0 then Exit;

  w := R1.Right - R1.Left;
  if w > R2.Right - R2.Left then w := R2.Right - R2.Left;
  if w > Bmp1.Width - R1.Left then w := Bmp1.Width - R1.Left;
  if w > Bmp2.Width - R2.Left then w := Bmp2.Width - R2.Left - 1 else w := w - 1;
  if w < 0 then Exit;
//  BgTransparency := MaxByte - BgTransparency;

  if R1.Left < R2.Left then begin
    if (R1.Left < 0) then begin
      inc(R2.Left, - R1.Left);
      dec(w, - R1.Left);
      R1.Left := 0;
    end;
  end
  else begin
    if (R2.Left < 0) then begin
      inc(R1.Left, - R2.Left);
      dec(w, - R2.Left);
      R2.Left := 0;
    end;
  end;
  if R1.Top < R2.Top then begin
    if (R1.Top < 0) then begin
      inc(R2.Top, - R1.Top);
      dec(h, - R1.Top);
      R1.Top := 0;
    end;
  end
  else begin
    if (R2.Top < 0) then begin
      inc(R1.Top, - R2.Top);
      dec(h, - R2.Top);
      R2.Top := 0;
    end;
  end;
  Cur.A := 0;
  C1.A := 0;
  Color.I := 0;

  hdiv2 := (MaskData.R.Bottom - MaskData.R.Top) div 2;
  k1 := min(R2.Top + hdiv2, Bmp2.Height - h - 1); // Mask offset
  if CI.Ready and (CI.Bmp <> nil) then begin
    if h >= CI.Bmp.Height then h := CI.Bmp.Height - 1;
    for Y := 0 to h do begin
      S1 := Bmp1.ScanLine[R1.Top + Y];
      S2 := Bmp2.ScanLine[R2.Top + Y];
      M  := Bmp2.ScanLine[k1 + Y];
      CacheBMP := CI.Bmp.ScanLine[R1.Top + Y + CI.Y];
      dX1 := R1.Left;
      dX2 := R2.Left;
      for X := 0 to w do begin
        cur := S2[dX2];
        if cur.C <> clFuchsia then begin
          a := M[dX2].R;// div MaxByte;
          a_ := MaxByte - a;

          S1[dX1].R := (S1[dX1].R * a + cur.R * a_) shr 8;
          S1[dX1].G := (S1[dX1].G * a + cur.G * a_) shr 8;
          S1[dX1].B := (S1[dX1].B * a + cur.B * a_) shr 8;

          case S1[dX1].A of
            0 : S1[dX1].A := 255 - M[dX2].R; // Full transparency
            MaxByte : ; // Do not change
            else S1[dX1].A := max(S1[dX1].A, 255 - M[dX2].R);
          end;

        end
        else begin
          S1[dX1] := CacheBMP[dX1 + CI.X];
        end;
        inc(dX1);
        inc(dX2);
      end;
    end;
  end
  else for Y := 0 to h do begin
    S1 := Bmp1.ScanLine[R1.Top + Y];
    S2 := Bmp2.ScanLine[R2.Top + Y];
    M  := Bmp2.ScanLine[k1 + Y];
    dX1 := R1.Left;
    dX2 := R2.Left;
    for X := 0 to w do begin
      cur := S2[dX2];
      if cur.C <> clFuchsia then begin
        a := M[dX2].R;// div MaxByte;
        a_ := MaxByte - a;

        S1[dX1].R := (S1[dX1].R * a + cur.R * a_) shr 8;
        S1[dX1].G := (S1[dX1].G * a + cur.G * a_) shr 8;
        S1[dX1].B := (S1[dX1].B * a + cur.B * a_) shr 8;

        case S1[dX1].A of
          0 : S1[dX1].A := 255 - M[dX2].R; // Full transparency
          MaxByte : ; // Do not change
          else S1[dX1].A := max(S1[dX1].A, 255 - M[dX2].R);
        end;

      end
      else begin
        S1[dX1].A := 0;
      end;
      inc(dX1);
      inc(dX2);
    end;
  end;
end;

procedure DrawSkinGlyph(Bmp : TBitmap; P : TPoint; State, AddedTransparency : integer; MaskData : TsMaskData; const CI : TCacheInfo);
var
  w, h, cy, cx : integer;
  dw : integer;
begin
  w := WidthOfImage(MaskData);
  h := HeightOfImage(MaskData);

  if State > MaskData.ImageCount - 1 then State := MaskData.ImageCount - 1;
  dw := State * w;
  if p.y < 0 then cy := - p.y else cy := 0;
  if p.x < 0 then cx := - p.x else cx := 0;

  if MaskData.Bmp = nil then with TsSkinManager(MaskData.Manager) do begin
    if MaskData.Manager = nil then Exit;
    if MaskData.ImageCount = 0 then Exit;

    if (MaskData.MaskType > 0) then begin
      BlendGlyphByMask(Rect(p.x + cx, p.y + cy, p.x + w - 1 + cx, p.y + h + cy - 1),
               Rect(dw + cx + MaskData.R.Left, cy + MaskData.R.Top, dw + w - 1 + cx + MaskData.R.Left, h - 1 + cy + MaskData.R.Top),
               Bmp, MasterBitmap, clFuchsia, AddedTransparency, MaskData);
    end
    else begin
      if AddedTransparency <> 1 then begin
        BlendTransRectangle(Bmp, p.x + cx, p.y + cy, MasterBitmap,
          Rect(dw + cx + MaskData.R.Left, cy + MaskData.R.Top, dw + cx + MaskData.R.Left + w - 1, cy + MaskData.R.Top + h - 1), 0.5);
      end
      else
        CopyTransRect(Bmp, MasterBitmap, p.x + cx, p.y + cy,
          Rect(dw + cx + MaskData.R.Left, cy + MaskData.R.Top, dw + cx + MaskData.R.Left + w - 1, cy + MaskData.R.Top + h - 1), clFuchsia, CI, True);
    end;
  end
  else begin
    if (MaskData.R.Right > MaskData.Bmp.Width) or (MaskData.R.Bottom > MaskData.Bmp.Height) then Exit;
    BlendGlyphByMask(Rect(p.x + cx, p.y + cy, p.x + w - 1 + cx, p.y + h + cy - 1),
               Rect(dw + cx + MaskData.R.Left, cy + MaskData.R.Top, dw + w - 1 + cx + MaskData.R.Left, h - 1 + cy + MaskData.R.Top),
               Bmp, MaskData.Bmp, clFuchsia, AddedTransparency, MaskData);
  end;
end;

procedure StretchBltMask(DstX1, DstY1, Dst_Width, Dst_Height, SrcX1, SrcY1, Src_Width, Src_Height : integer; BmpDst, BmpSrc : TBitmap; MaskOffset : integer; NoStdStretch : boolean = False);
var
  MaskBmp, Bmp, TmpBmp : TBitmap;
  S1, S2, M : PRGBAArray;
  X, Y, iY, iX: Integer;
  C : TsColor_;
begin
  if (DstX1 < 0) or (DstY1 < 0) or (Dst_Width < 0) or (Dst_Height < 1) or (Dst_Width < 1) or (BmpDst.Height < 2) or (BmpDst.Width < 2) then Exit;

  if (MaskOffset <> 0) then begin // If masked
    if BmpSrc.Width < SrcX1 + Src_Width then Exit;
    if BmpSrc.Height < SrcY1 + Src_Height then Exit;

    if NoStdStretch and (Src_Width = 1) and (Src_Height = 1) then begin
      if SrcY1 + MaskOffset >= BmpSrc.Height then Exit;
      S2 := BmpSrc.ScanLine[SrcY1];
      M := BmpSrc.ScanLine[SrcY1 + MaskOffset];
      C := S2[SrcX1];
      C.A := M[SrcX1].R; // Get mask value
      case C.A of
        MaxByte : ; // Dst Changed
        0 : begin // If not transparent pixel
          C.C := SwapRedBlue(C.C);
          FillRect32(BmpDst, Rect(DstX1, DstY1, DstX1 + Dst_Width, DstY1 + Dst_Height), C.C);
        end
        else begin
          for Y := DstY1 to DstY1 + Dst_Height - 1 do begin
            S1 := BmpDst.ScanLine[Y];
            for X := DstX1 to DstX1 + Dst_Width - 1 do begin
              S1[X].R := (((S1[X].R - C.R) * C.A + C.R shl 8) shr 8) and MaxByte;
              S1[X].G := (((S1[X].G - C.G) * C.A + C.G shl 8) shr 8) and MaxByte;
              S1[X].B := (((S1[X].B - C.B) * C.A + C.B shl 8) shr 8) and MaxByte;
            end;
          end;
        end;
      end;
      Exit;
    end;
    Bmp := TBitmap.Create;
    Bmp.PixelFormat := pf32bit;
    Bmp.Width := Dst_Width;
    Bmp.Height := Dst_Height;

    MaskBmp := TBitmap.Create;
    MaskBmp.PixelFormat := pf32bit;
    MaskBmp.Width := Dst_Width;
    MaskBmp.Height := Dst_Height;

    if ((Src_Width > Dst_Width) and (Src_Height = Dst_Height) or (Src_Width = Dst_Width) and (Src_Height > Dst_Height) or NoStdStretch) and (Dst_Width > 1) and (Dst_Height > 1) then begin
      TmpBmp := TBitmap.Create;
      TmpBmp.PixelFormat := pf32bit;
      TmpBmp.Width := max(Src_Width, 2);
      TmpBmp.Height := max(Src_Height, 2);

      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Src_Width, Src_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, SRCCOPY);
      if Src_Width = 1 then BitBlt(TmpBmp.Canvas.Handle, 1, 0, 1, Src_Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      if Src_Height = 1 then BitBlt(TmpBmp.Canvas.Handle, 0, 1, Src_Width, 1, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      Stretch(TmpBmp, Bmp, Dst_Width, Dst_Height, ftMitchell);

      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Src_Width, Src_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1 + MaskOffset, SRCCOPY);
      if Src_Width = 1 then BitBlt(TmpBmp.Canvas.Handle, 1, 0, 1, Src_Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      if Src_Height = 1 then BitBlt(TmpBmp.Canvas.Handle, 0, 1, Src_Width, 1, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      Stretch(TmpBmp, MaskBmp, Dst_Width, Dst_Height, {ftMitchell);//}ftHermite);

      TmpBmp.Free;
    end
    else begin
      StretchBlt(Bmp.Canvas.Handle, 0, 0, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, Src_Width, Src_Height, SRCCOPY);
      StretchBlt(MaskBmp.Canvas.Handle, 0, 0, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1 + MaskOffset, Src_Width, Src_Height, SRCCOPY);
    end;

    iY := 0;
    if DstY1 + Dst_Height > BmpDst.Height then Dst_Height := BmpDst.Height - DstY1;
    for Y := DstY1 to DstY1 + Dst_Height - 1 do begin
      S1 := BmpDst.ScanLine[Y];
      S2 := Bmp.ScanLine[iY];
      M := MaskBmp.ScanLine[iY];
      iX := 0;
      for X := DstX1 to DstX1 + Dst_Width - 1 do begin
        S1[X].R := (((S1[X].R - S2[iX].R) * M[iX].R + S2[iX].R shl 8) shr 8) and MaxByte;
        S1[X].G := (((S1[X].G - S2[iX].G) * M[iX].G + S2[iX].G shl 8) shr 8) and MaxByte;
        S1[X].B := (((S1[X].B - S2[iX].B) * M[iX].B + S2[iX].B shl 8) shr 8) and MaxByte;
        S1[X].A := MaxByte;
        inc(iX);
      end;
      inc(iY);
    end;
    MaskBmp.Free;
    Bmp.Free;
  end
  else begin
    StretchBlt(BmpDst.Canvas.Handle, DstX1, DstY1, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, Src_Width, Src_Height, SRCCOPY);
  end;
end;

procedure StretchBltMask32(DstX1, DstY1, Dst_Width, Dst_Height, SrcX1, SrcY1, Src_Width, Src_Height : integer; BmpDst, BmpSrc : TBitmap; MaskOffset : integer; NoStdStretch : boolean = False);
var
  MaskBmp, Bmp, TmpBmp : TBitmap;
  S1, S2, M : PRGBAArray;
  X, Y, iY, iX: Integer;
  C : TsColor_;
  a, a_ : byte;
begin
  if (DstX1 < 0) or (DstY1 < 0) or (Dst_Width < 0) or (Dst_Height < 1) or (Dst_Width < 1) or (BmpDst.Height < 2) or (BmpDst.Width < 2) then Exit;

  if (MaskOffset <> 0) then begin // If masked
    if BmpSrc.Width < SrcX1 + Src_Width then Exit;
    if BmpSrc.Height < SrcY1 + Src_Height then Exit;

    if NoStdStretch and (Src_Width = 1) and (Src_Height = 1) then begin
      if SrcY1 + MaskOffset >= BmpSrc.Height then Exit;
      S2 := BmpSrc.ScanLine[SrcY1];
      M := BmpSrc.ScanLine[SrcY1 + MaskOffset];
      C := S2[SrcX1];
      C.A := M[SrcX1].R; // Get mask value
      case C.A of
        MaxByte : ; // Dst Changed
        0 : begin // If not transparent pixel
          C.C := SwapRedBlue(C.C);
          FillRect32(BmpDst, Rect(DstX1, DstY1, DstX1 + Dst_Width, DstY1 + Dst_Height), C.C);
        end
        else for Y := DstY1 to DstY1 + Dst_Height - 1 do begin
          S1 := BmpDst.ScanLine[Y];
          for X := DstX1 to DstX1 + Dst_Width - 1 do begin
            a := min({255 - }C.A, S1[X].A);
            a_ := MaxByte - a;
            S1[X].R := (S1[X].R * a + C.R * a_) shr 8;
            S1[X].G := (S1[X].G * a + C.G * a_) shr 8;
            S1[X].B := (S1[X].B * a + C.B * a_) shr 8;
            S1[X].A := max(S1[X].A, 255 - C.A);
          end;
        end;
      end;
      Exit;
    end;
    Bmp := TBitmap.Create;
    Bmp.PixelFormat := pf32bit;
    Bmp.Width := Dst_Width;
    Bmp.Height := Dst_Height;

    MaskBmp := TBitmap.Create;
    MaskBmp.PixelFormat := pf32bit;
    MaskBmp.Width := Dst_Width;
    MaskBmp.Height := Dst_Height;

    if ((Src_Width > Dst_Width) and (Src_Height = Dst_Height) or (Src_Width = Dst_Width) and (Src_Height > Dst_Height) or NoStdStretch) and (Dst_Width > 1) and (Dst_Height > 1) then begin
      TmpBmp := TBitmap.Create;
      TmpBmp.PixelFormat := pf32bit;
      TmpBmp.Width := max(Src_Width, 2);
      TmpBmp.Height := max(Src_Height, 2);

      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Src_Width, Src_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, SRCCOPY);
      if Src_Width = 1 then BitBlt(TmpBmp.Canvas.Handle, 1, 0, 1, Src_Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      if Src_Height = 1 then BitBlt(TmpBmp.Canvas.Handle, 0, 1, Src_Width, 1, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      Stretch(TmpBmp, Bmp, Dst_Width, Dst_Height, ftMitchell);

      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Src_Width, Src_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1 + MaskOffset, SRCCOPY);
      if Src_Width = 1 then BitBlt(TmpBmp.Canvas.Handle, 1, 0, 1, Src_Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      if Src_Height = 1 then BitBlt(TmpBmp.Canvas.Handle, 0, 1, Src_Width, 1, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      Stretch(TmpBmp, MaskBmp, Dst_Width, Dst_Height, {ftMitchell}ftHermite);

      TmpBmp.Free;
    end
    else begin
      StretchBlt(Bmp.Canvas.Handle, 0, 0, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, Src_Width, Src_Height, SRCCOPY);
      StretchBlt(MaskBmp.Canvas.Handle, 0, 0, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1 + MaskOffset, Src_Width, Src_Height, SRCCOPY);
    end;

    iY := 0;
    if DstY1 + Dst_Height > BmpDst.Height then Dst_Height := BmpDst.Height - DstY1;
    for Y := DstY1 to DstY1 + Dst_Height - 1 do begin
      S1 := BmpDst.ScanLine[Y];
      S2 := Bmp.ScanLine[iY];
      M := MaskBmp.ScanLine[iY];
      iX := 0;
      for X := DstX1 to DstX1 + Dst_Width - 1 do begin
        case M[iX].R of
          MaxByte : ; // Continue;
          0 : begin
            S1[X].I := S2[iX].I;
            S1[X].A := MaxByte;
          end
          else begin
            a := min({255 - }M[iX].R, S1[X].A);
            a_ := MaxByte - a;
            S1[X].R := (S1[X].R * a + S2[iX].R * a_) shr 8;
            S1[X].G := (S1[X].G * a + S2[iX].G * a_) shr 8;
            S1[X].B := (S1[X].B * a + S2[iX].B * a_) shr 8;
            S1[X].A := max(S1[X].A, 255 - M[iX].R);
          end;
        end;
        inc(iX);
      end;
      inc(iY);
    end;
    MaskBmp.Free;
    Bmp.Free;
  end
  else begin
    StretchBlt(BmpDst.Canvas.Handle, DstX1, DstY1, Dst_Width, Dst_Height, BmpSrc.Canvas.Handle, SrcX1, SrcY1, Src_Width, Src_Height, SRCCOPY);
  end;
end;

procedure BlendGlyphByMask(R1, R2 : TRect; Bmp1, Bmp2 : TBitmap; TransColor : TColor; AddedTransparency : integer; MaskData : TsMaskData);
var
  S1, S2, M : PRGBAArray;
  X, Y, h, w, hdiv2, dx1, dy1, dx2, dy2: Integer;
  c : TsColor_;
  RegRect : TRect;
begin
  hdiv2 := HeightOf(MaskData.R) div (MaskData.MaskType + 1);
  h := Min(HeightOf(R1), HeightOf(R2));
  h := min(h, Bmp1.Height - R1.Top - 1);
  h := min(h, Bmp2.Height - R2.Top - hdiv2 - 1);

  if MaskData.ImageCount < 1 then h := min(h, hdiv2 - R2.Top - 1);
  w := Min(WidthOf(R1), WidthOf(R2));
  w := min(w, Bmp1.Width - R1.Left - 1);

  if MaskData.ImageCount < 1 then w := min(w, Bmp2.Width - R2.Left - 1);
  RegRect := Rect(-1, 0, 0, 0);

  if MaskData.MaskType = 0 then CopyTransRectA(Bmp1, Bmp2, R1.Left, R1.Top, R2, clFuchsia, EmptyCI) else begin
    c.A := 0;
    if R2.Top + h > Bmp2.Height then Exit;
    dy1 := R1.Top;
    dy2 := R2.Top;
    if Bmp1.PixelFormat = pf32bit then begin
      for Y := 0 to h do begin
        S1 := Bmp1.ScanLine[dy1];
        S2 := Bmp2.ScanLine[dy2];
        M  := Bmp2.ScanLine[dy2 + hdiv2];
        dx1 := R1.Left;
        dx2 := R2.Left;
        for X := 0 to w do begin
          c := S2[R2.Left + X];
          if (c.C <> clFuchsia) and (M[dx2].R <> MaxByte) then begin
            if AddedTransparency <> 1 then begin
              S1[dx1].R := ((S1[dx1].R - S2[dx2].R) * min(M[dx2].R + 100, MaxByte) + S2[dx2].R shl 8) shr 8;
              S1[dx1].G := ((S1[dx1].G - S2[dx2].G) * min(M[dx2].G + 100, MaxByte) + S2[dx2].G shl 8) shr 8;
              S1[dx1].B := ((S1[dx1].B - S2[dx2].B) * min(M[dx2].B + 100, MaxByte) + S2[dx2].B shl 8) shr 8;
              S1[dx1].A := S1[dX1].A + ((MaxByte - S1[dX1].A) * (MaxByte - M[dx2].R)) shr 8;
            end
            else begin
              S1[dx1].R := ((S1[dx1].R - S2[dx2].R) * M[dx2].R + S2[dx2].R shl 8) shr 8;
              S1[dx1].G := ((S1[dx1].G - S2[dx2].G) * M[dx2].G + S2[dx2].G shl 8) shr 8;
              S1[dx1].B := ((S1[dx1].B - S2[dx2].B) * M[dx2].B + S2[dx2].B shl 8) shr 8;
              S1[dx1].A := S1[dX1].A + ((MaxByte - S1[dX1].A) * (MaxByte - M[dx2].R)) shr 8;
            end;
          end;
          inc(dx1);
          inc(dx2);
        end;
        inc(dy1);
        inc(dy2);
      end;
    end
  end;
end;

procedure CopyTransCorner(SrcBmp: Graphics.TBitMap; X, Y : integer; SrcRect: TRect; BGInfo : TacBGInfo; SkinData : TsCommonData);
var
  Dst, Src : PRGBAArray;
  sX, sY, SrcX, DstX, DstY : Integer;
  NewColor : TsColor_;
  h, w : integer;
  col : TsColor;
begin

  if SrcRect.Top < 0 then SrcRect.Top := 0;
  if SrcRect.Bottom > SrcBmp.Height - 1 then SrcRect.Bottom := SrcBmp.Height - 1;
  if SrcRect.Left < 0 then SrcRect.Left := 0;
  if SrcRect.Right > SrcBmp.Width - 1 then SrcRect.Right := SrcBmp.Width - 1;

  h := HeightOf(SrcRect);
  w := WidthOf(SrcRect);
  if (BGInfo.BgType = btCache) and (BGInfo.Bmp <> nil) then begin
    for sY := 0 to h do begin
      DstY := sY + Y;
      if (DstY <= SkinData.FCacheBmp.Height - 1) and (DstY >= 0) then begin
        Dst := SkinData.FCacheBmp.ScanLine[DstY];
        Src := SrcBmp.ScanLine[sY + SrcRect.Top];
        for sX := 0 to w do begin
          DstX := sX + X;
          if (DstX <= SkinData.FCacheBmp.Width - 1) and (DstX >= 0) then begin
            SrcX := sX + SrcRect.Left;
            if (Src[SrcX].C = clFuchsia) {if transparent pixel} then begin
              if (BGInfo.Offset.Y + DstY >= BGInfo.Bmp.Height) or (BGInfo.Offset.X + DstX >= BGInfo.Bmp.Width) or (BGInfo.Offset.Y + DstY < 0) or (BGInfo.Offset.X + DstX < 0) then continue;
              try
                col := GetAPixel(BGInfo.Bmp, BGInfo.Offset.X + DstX, BGInfo.Offset.Y + DstY);
              finally
                NewColor.R := col.B;
                NewColor.G := col.G;
                NewColor.B := col.R;
                Dst[DstX] := NewColor
              end
            end;
          end;
        end
      end;
    end;
  end
  else if BGInfo.Color <> clFuchsia then for sY := 0 to h do begin
    DstY := sY + Y;
    if (DstY <= SkinData.FCacheBmp.Height - 1) and (DstY >= 0) then begin
      Dst := SkinData.FCacheBmp.ScanLine[DstY];
      Src := SrcBmp.ScanLine[sY + SrcRect.Top];
      for sX := 0 to w do begin
        DstX := sX + X;
        if (DstX <= SkinData.FCacheBmp.Width - 1) and (DstX >= 0) then begin
          SrcX := sX + SrcRect.Left;
          if (Src[SrcX].C = clFuchsia) then begin
            NewColor.C := BGInfo.Color;
            NewColor.R := TsColor(BGInfo.Color).R;
            NewColor.B := TsColor(BGInfo.Color).B;
            Dst[DstX] := NewColor;
          end;
        end;
      end
    end;
  end;
end;
procedure CopyMasterCorner(R1, R2 : TRect; Bmp : TBitmap; BGInfo : TacBGInfo; SkinData : TsCommonData);
var
  S1, S2 : PRGBAArray;
  X, Y, h, w: Integer;
  col_ : TsColor_;
  col : TsColor;
begin
  h := Min(HeightOf(R1), HeightOf(R2));
  h := Min(h, SkinData.FCacheBmp.Height - R1.Top);
  h := Min(h, Bmp.Height - R2.Top) - 1;
  if h < 0 then Exit;
  w := Min(WidthOf(R1), WidthOf(R2));
  w := Min(w, SkinData.FCacheBmp.Width - R1.Left);
  w := Min(w, Bmp.Width - R2.Left) - 1;
  if w < 0 then Exit;
  if R1.Left < R2.Left then begin
    if (R1.Left < 0) then begin
      inc(R2.Left, - R1.Left);
      dec(w, - R1.Left);
      R1.Left := 0;
    end;
  end
  else begin
    if (R2.Left < 0) then begin
      inc(R1.Left, - R2.Left);
      dec(w, - R2.Left);
      R2.Left := 0;
    end;
  end;
  if R1.Top < R2.Top then begin
    if (R1.Top < 0) then begin
      inc(R2.Top, - R1.Top);
      dec(h, - R1.Top);
      R1.Top := 0;
    end;
  end
  else begin
    if (R2.Top < 0) then begin
      inc(R1.Top, - R2.Top);
      dec(h, - R2.Top);
      R2.Top := 0;
    end;
  end;
  col_.C := BGInfo.Color;
  col_.B := TsColor(BGInfo.Color).B;
  col_.R := TsColor(BGInfo.Color).R;

  if BGInfo.BgType <> btCache then begin
    for Y := 0 to h do begin
      S1 := SkinData.FCacheBmp.ScanLine[R1.Top + Y];
      S2 := Bmp.ScanLine[R2.Top + Y];
      for X := 0 to w do if (S2[R2.Left + X].C = clFuchsia) then S1[R1.Left + X] := col_;
    end;
  end
  else begin
    for Y := 0 to h do begin
      S1 := SkinData.FCacheBmp.ScanLine[R1.Top + Y];
      S2 := Bmp.ScanLine[R2.Top + Y];
      if BGInfo.BgType <> btCache then begin
        for X := 0 to w do if (S2[R2.Left + X].C = clFuchsia) then S1[R1.Left + X] := col_;
      end
      else begin
        for X := 0 to w do begin
          if (S2[R2.Left + X].C = clFuchsia) then begin
            if (BGInfo.Bmp.Height <= R1.Top + BGInfo.Offset.Y + Y) then Continue;
            if (BGInfo.Bmp.Width <= R1.Left + BGInfo.Offset.X + X) then Break;
            if R1.Top + BGInfo.Offset.Y + Y < 0 then Break;
            if R1.Left + BGInfo.Offset.X + X < 0 then Continue;
            col := GetAPixel(BGInfo.Bmp, R1.Left + BGInfo.Offset.X + X, R1.Top + BGInfo.Offset.Y + Y);
            S1[R1.Left + X].R := col.B;
            S1[R1.Left + X].G := col.G;
            S1[R1.Left + X].B := col.R;
          end
        end;
      end;
    end;
  end;
end;

procedure UpdateCorners(SkinData : TsCommonData; State : integer; Corners : TsCorners = [scLeftTop, scLeftBottom, scRightTop, scRightBottom]);
var
  w, Width, Height : integer;
  dw, dh : integer;
  MaskData : TsMaskData;
  BGInfo : TacBGInfo;
  ParentColor : TsColor;
  SrcBmp : TBitmap;
  wl, wt, wr, wb : integer;
begin
  if not Skindata.SkinManager.IsValidImgIndex(SkinData.BorderIndex) or
       not Assigned(SkinData.FCacheBmp) or (SkinData.FOwnerControl = nil) {or //not (SkinData.FOwnerControl is TControl) or
         (SkinData.FOwnerControl.Width < 2) or (SkinData.FOwnerControl.Height < 2)} then Exit;
  MaskData := SkinData.SkinManager.ma[SkinData.BorderIndex];
  if MaskData.CornerType = 0 then Exit;

  BGInfo.PleaseDraw := False;
  BGInfo.DrawDC := 0;
  if SkinData.FOwnerControl.Parent = nil then begin
    if SkinData.FOwnerControl is TWinControl then GetBGInfo(@BGInfo, GetParent(TWinControl(SkinData.FOwnerControl).Handle)) else Exit;;
  end
  else begin
    GetBGInfo(@BGInfo, SkinData.FOwnerControl.Parent);
  end;

  Width := SkinData.FOwnerControl.Width;
  Height := SkinData.FOwnerControl.Height;
  wl := MaskData.WL; wt := MaskData.WT; wr := MaskData.WR; wb := MaskData.WB;
  if (MaskData.ImageCount = 0) and (MaskData.Bmp <> nil) then begin // if external
    MaskData.MaskType := 1;
    MaskData.ImageCount := 3;
    MaskData.R := Rect(0, 0, MaskData.Bmp.Width, MaskData.Bmp.Height);
  end;

  if BGInfo.BgType <> btCache then begin
    ParentColor.C := ColorToRGB(BGInfo.Color);
  end
  else begin
    inc(BGInfo.Offset.X, SkinData.FOwnerControl.Left);
    inc(BGInfo.Offset.Y, SkinData.FOwnerControl.Top);
  end;

  if State >= MaskData.ImageCount then State := MaskData.ImageCount - 1;
  dw := State * (WidthOfImage(MaskData));
  dh := HeightOfImage(MaskData);

  w := WidthOfImage(MaskData) - wl - wr;             // Width of piece of mask

  if MaskData.Bmp <> nil then SrcBmp := MaskData.Bmp else SrcBmp := SkinData.SkinManager.MasterBitmap;
  if MaskData.MaskType = 0 then begin // Copy without mask
    if (scLeftTop in Corners) then CopyTransCorner(SrcBmp, 0, 0, Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl - 1, MaskData.R.Top + wt - 1), BGInfo, SkinData);
    if (scLeftBottom in Corners) then CopyTransCorner(SrcBmp, 0, Height - wb, Rect(MaskData.R.Left + dw, MaskData.R.Bottom - wb, MaskData.R.Left + dw + wl - 1, MaskData.R.Bottom - 1), BGInfo, SkinData);
    if (scRightBottom in Corners) then CopyTransCorner(SrcBmp, Width - wr, Height - wb, Rect(MaskData.R.Left + dw + wl + w, MaskData.R.Bottom - wb, MaskData.R.Left + dw + wl + w + wr - 1, MaskData.R.Bottom - 1), BGInfo, SkinData);
    if (scRightTop in Corners) then CopyTransCorner(SrcBmp, Width - wr, 0, Rect(MaskData.R.Left + dw + wl + w, MaskData.R.Top, MaskData.R.Left + dw + wl + w + wr - 1, MaskData.R.Top + wt - 1), BGInfo, SkinData);
  end
  else begin
    if (scLeftTop in Corners) then CopyMasterCorner(Rect(0, 0, wl + 1, wt + 1), Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl, MaskData.R.Top + wt), SrcBmp, BGInfo, SkinData);
    if (scLeftBottom in Corners) then CopyMasterCorner(Rect(0, Height - wb, wl, Height), Rect(MaskData.R.Left + dw, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh), SrcBmp, BGInfo, SkinData);
    if (scRightBottom in Corners) then CopyMasterCorner(Rect(Width - wr, Height - wb, Width, Height), Rect(MaskData.R.Left + dw + wl + w, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + wl + w + wr, MaskData.R.Top + dh), SrcBmp, BGInfo, SkinData);
    if (scRightTop in Corners) then CopyMasterCorner(Rect(Width - wr, 0, Width, wt), Rect(MaskData.R.Left + dw + wl + w, MaskData.R.Top, MaskData.R.Left + dw + wl + w + wr, MaskData.R.Top + wt), SrcBmp, BGInfo, SkinData);
  end;
end;

{$ENDIF}

{$IFNDEF WIN64}
procedure FillLongword(var X; Count: Integer; Value: Longword);
asm
// EAX = X
// EDX = Count
// ECX = Value
        PUSH    EDI

        MOV     EDI,EAX  // Point EDI to destination
        MOV     EAX,ECX
        MOV     ECX,EDX
        TEST    ECX,ECX
        JS      @exit

        REP     STOSD    // Fill count dwords
@exit:
        POP     EDI
end;
{$ENDIF}
{
procedure PaintItem32(SkinIndex : integer; Filling : boolean; State : integer; R : TRect; pP : TPoint; DC : HDC; SkinManager : TObject = nil); overload;
var
  TempBmp : TBitmap;
  SavedDC : HDC;
begin
  if (SkinManager = nil) then SkinManager := DefaultManager;
  if not Assigned(SkinManager) or not TsSkinManager(SkinManager).IsValidSkinIndex(SkinIndex) or IsRectEmpty(R) then Exit;
  SavedDC := SaveDC(DC);
  TempBmp := CreateBmp32(WidthOf(r, True), HeightOf(r, True));
  try
    PaintItem32(SkinIndex, Filling, State , Rect(0, 0, TempBmp.Width, TempBmp.Height), pP, TempBmp, SkinManager);
    BitBlt(DC, r.Left, r.top, WidthOf(r, True), HeightOf(r, True), TempBmp.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    FreeAndNil(TempBmp);
    RestoreDC(DC, SavedDC);
  end;
end;
}

procedure ConvertMaskToAlpha(DstBmp, SrcBmp : TBitmap; DstRect, SrcRect : TRect); 
var
  w, h, Y, X : integer;
  S, D : PRGBAArray;
begin
  w := WidthOf(SrcRect, True);
  h := HeightOf(SrcRect, True) div 2;
  if (w = 0) or (h = 0) then Exit;
  if (w <> WidthOf(DstRect)) or (h <> HeightOf(DstRect)) then Exit;
  // Copy mask (red channel) as AlphaChannel
  for Y := 0 to h - 1 do begin
    S := SrcBmp.ScanLine[SrcRect.Top + Y + h];
    D := DstBmp.ScanLine[DstRect.Top + Y];
    for X := 0 to w - 1 do D[DstRect.Left + X].A := MaxByte - S[SrcRect.Left + X].R;
  end;
end;

procedure PaintItem32(SkinIndex : integer; Filling : boolean; State : integer; R : TRect; pP : TPoint; ItemBmp : TBitmap; SkinManager : TObject = nil); overload;
var
  mState : integer;
  CacheBmp : TBitmap;
begin
  if (ItemBmp = nil) or IsRectEmpty(R) then Exit;
  if (SkinManager = nil) then SkinManager := DefaultManager;
  if not Assigned(SkinManager) or not TsSkinManager(SkinManager).IsValidSkinIndex(SkinIndex) or (R.Bottom > ItemBmp.Height) or (R.Right > ItemBmp.Width) or (R.Left < 0) or (R.Top < 0) then Exit;
  // Count of allowed states is limited in skin
  if TsSkinManager(SkinManager).gd[SkinIndex].States <= State then State := TsSkinManager(SkinManager).gd[SkinIndex].States - 1;
  mState := min(State, 1);
  CacheBmp := CreateBmp32(WidthOf(R) + 1, HeightOf(R) + 1);
  BitBlt(CacheBmp.Canvas.Handle, 0, 0, CacheBmp.Width, CacheBmp.Height, ItemBmp.Canvas.Handle, R.Left, R.Top, SRCCOPY);
  PaintItemBG32(SkinIndex, mState {normal or hot}, R, pP, ItemBmp, SkinManager);
  if TsSkinManager(SkinManager).IsValidImgIndex(TsSkinManager(SkinManager).gd[SkinIndex].BorderIndex)
    then DrawSkinRect32(ItemBmp, R, Filling, MakeCacheInfo(CacheBmp, -R.Left, -R.Top), TsSkinManager(SkinManager).ma[TsSkinManager(SkinManager).gd[SkinIndex].BorderIndex], State, SkinManager);
  CacheBmp.Free;  
  if (ItemBmp.Width = WidthOf(R)) and (ItemBmp.Height = HeightOf(R))
    then UpdateAlpha(ItemBmp, R) // Updating for using of bitmap in layered windows
//    else InvertAlpha(ItemBmp, R);
end;

procedure PaintItemBG32(SkinIndex : integer; State : integer; R : TRect; pP : TPoint; ItemBmp : TBitmap; SkinManager : TObject; OffsetX : integer = 0; OffsetY : integer = 0; CustomColor : TColor = clFuchsia);
var
  aRect: TRect;
  iDrawed : boolean;
  ImagePercent, GradientPercent : integer;
  PatternIndex, Transparency : integer;
  GradientData : string;
  GradientArray : TsGradArray;
  Color : TColor;
  C : TsColor;
  sMan : TsSkinManager;

  procedure PaintAddons(var aBmp : TBitmap);
  var
    bmp : TBitmap;
    R : TRect;
  begin
    iDrawed := False;
    if (ImagePercent + GradientPercent = 100) and (GradientPercent in [1..99]) and
         (sMan.ma[PatternIndex].DrawMode = 0) and (GradientArray[0].Mode1 < 2) and sMan.IsValidImgIndex(PatternIndex) then begin // Optimized drawing
      if sMan.ma[PatternIndex].Bmp <> nil
        then PaintGradTxt(aBmp, aRect, GradientArray, sMan.ma[PatternIndex].Bmp, sMan.ma[PatternIndex].R, MaxByte * ImagePercent div 100, Round(1 - Transparency / 100) * MaxByte)
        else PaintGradTxt(aBmp, aRect, GradientArray, sMan.MasterBitmap, sMan.ma[PatternIndex].R, MaxByte * ImagePercent div 100, Round(1 - Transparency / 100) * MaxByte)
    end
    else begin
      R := aRect;
      // BGImage painting
      if (ImagePercent > 0) then with sMan do begin
        if (PatternIndex > -1) and (PatternIndex < Length(ma)) then begin
          if boolean(ma[PatternIndex].MaskType)
            then TileMasked(aBmp, R, EmptyCI {!}, ma[PatternIndex], acFillModes[ma[PatternIndex].DrawMode])
            else TileBitmap(aBmp.Canvas, R, ma[PatternIndex].Bmp, ma[PatternIndex], acFillModes[ma[PatternIndex].DrawMode]);
          iDrawed := True;
        end;
        if R.Right <> -1 then FillRect32(aBmp, R, Color); // If not all rect was filled by texture
      end;
      // BGGradient painting
      if (GradientPercent > 0) then begin
        if iDrawed then begin // If texture exists
          bmp := CreateBmp32(WidthOf(aRect, True), HeightOf(aRect, True));
          try
            if Length(GradientData) > 0
              then PaintGrad(Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), GradientArray)
              else FillRect32(Bmp, aRect, Color);
            SumBmpRect(aBmp, Bmp, max(min((ImagePercent * integer(MaxByte)) div 100, MaxByte), 0), Rect(0, 0, Bmp.Width, Bmp.Height), Point(aRect.Left, aRect.Top));
          finally
            FreeAndNil(Bmp);
          end;
        end
        else if Length(GradientData) > 0
          then PaintGrad(aBmp, aRect, GradientArray)
          else begin
            FillRect32(aBmp, aRect, Color);
            Exit;
          end;
      end;
      case GradientPercent + ImagePercent of
        1..99 : BlendColorRect(aBmp, aRect, GradientPercent + ImagePercent, Color); // Mix with color
        0 : begin
          // Just fill by color
          C := GetAPixel(aBmp, R.Left, R.Top);
          if C.I <> 0 then begin
            case Transparency of
              0: FillRect32(aBmp, aRect, Color, MaxByte);
              100: FillRect32(aBmp, aRect, Color, C.A);
              else BlendRect32(aBmp, aRect, Color, 100 - Transparency, max(C.A, (100 - Transparency) * MaxByte div 100));
            end;
          end
          else FillRect32(aBmp, aRect, Color, (100 - Transparency) * MaxByte div 100);
          Exit; // AlphaChannel is ready
        end;
      end;
//      if Transparency <> 0 then
//      FillAlphaRect(aBmp, aRect, (100 - Transparency) * MaxByte div 100);
    end;
  end;
begin
  sMan := TsSkinManager(SkinManager);
  if not Assigned(sMan) or not sMan.IsValidSkinIndex(SkinIndex) then Exit;
  Transparency := sMan.gd[SkinIndex].Props[State].Transparency;
  if (Transparency = 100) then begin
    if (ItemBmp.Width = WidthOf(R)) and (ItemBmp.Height = HeightOf(R)) then begin // Make
      FillRect32(ItemBmp, R, clBlack, 0);
    end;
    Exit; // Exit without changes
  end;
  with sMan do begin
    aRect := R;
    PatternIndex := -1;
    if CustomColor = clFuchsia then begin // Get skin props
      Color := gd[SkinIndex].Props[State].Color;
      ImagePercent := gd[SkinIndex].Props[State].ImagePercent;
      GradientPercent := gd[SkinIndex].Props[State].GradientPercent;
      if GradientPercent > 0 then begin
        GradientData := gd[SkinIndex].Props[State].GradientData;
        GradientArray := gd[SkinIndex].Props[State].GradientArray
      end;
      if (ImagePercent > 0) then PatternIndex := gd[SkinIndex].Props[State].TextureIndex
    end
    else begin // Filling by custom color only
      ImagePercent := 0;
      GradientPercent := 0;
      Color := CustomColor;
      Transparency := 0;
    end;
    PaintAddons(ItemBmp);
  end;
end;

procedure DrawSkinRect32(const Bmp : TBitmap; const R : TRect; const Filling : boolean; const ci : TCacheInfo; const MaskData : TsMaskData; const State : integer; SkinManager : TObject = nil);
var
  x, y : integer;
  w, h : integer;
  dw, dh, dhm : integer;
  wl, wt, wr, wb : integer;
  BmpSrc : TBitmap;
  NewState : integer;
  Stretch : boolean;
begin
  if (State = 0) and (MaskData.DrawMode and BDM_ACTIVEONLY = BDM_ACTIVEONLY) then Exit;
  if (WidthOf(R) < 2) or (HeightOf(R) < 2) or (MaskData.Manager = nil) then Exit;
  wl := MaskData.WL; wt := MaskData.WT; wr := MaskData.WR; wb := MaskData.WB;
  if wl + wr > WidthOf(R) then begin
    y := ((wl + wr) - WidthOf(R));
    x := y div 2;
    dec(wl, x); dec(wr, x); if y mod 2 > 0 then dec(wr);
    if wl < 0 then wl := 0;
    if wr < 0 then wr := 0;
  end;
  if wt + wb > HeightOf(R) then begin
    y := ((wt + wb) - HeightOf(R));
    x := y div 2;
    dec(wt, x); dec(wb, x); if y mod 2 > 0 then dec(wb);
    if wt < 0 then wt := 0;
    if wb < 0 then wb := 0;
  end;
  if State >= MaskData.ImageCount then NewState := MaskData.ImageCount - 1 else NewState := State;
  dw := WidthOfImage(MaskData);                  // Width of mask
  dh := HeightOfImage(MaskData);                 // Height of mask
  if MaskData.MaskType = 0 then dhm := 0 else dhm := dh;

  if MaskData.DrawMode and BDM_STRETCH = BDM_STRETCH then begin
    Stretch := True;
    SetStretchBltMode(Bmp.Canvas.Handle, COLORONCOLOR);
  end
  else Stretch := False;

  w := dw - wl - wr; if w < 0 then Exit;      // Width of middle piece must be > 0
  h := dh - wt - wb; if h < 0 then Exit;      // Height of middle piece must be > 0
  dw := dw * NewState;                        // Offset of mask

  if MaskData.Bmp <> nil then BmpSrc := MaskData.Bmp else BmpSrc := TsSkinManager(MaskData.Manager).MasterBitmap;
  if MaskData.MaskType = 0 then begin // Copy without mask
    // left - top
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Top, Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, True);
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Left, y, wl, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, SRCCOPY);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Top, w, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Top, R.Right - wr - x, wt, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, SRCCOPY);
    // left - bottom
    CopyTransRect(Bmp, BmpSrc, R.Left, R.Bottom - wb, Rect(MaskData.R.Left + dw, MaskData.R.Bottom - wb, MaskData.R.Left + dw + wl - 1, MaskData.R.Bottom - 1), clFuchsia, CI, True);
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      if w > 0 then while x < R.Right - w - wr do begin
        BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, w, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
        inc(x, w);
      end;
      if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, x, R.Bottom - wb, R.Right - wr - x, wb, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Bottom - wb, w, wb, SRCCOPY);
    // right - bottom
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Bottom - wb, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Bottom - wb, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Bottom - 1), clFuchsia, CI, True);
    // right - top
    CopyTransRect(Bmp, BmpSrc, R.Right - wr, R.Top, Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr - 1, MaskData.R.Top + wt - 1), clFuchsia, CI, True);
    y := R.Top + wt;
    // right - middle
    if not Stretch then begin
      if h > 0 then while y < R.Bottom - h - wb do begin
        BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, SRCCOPY);
        inc(y, h);
      end;
      if y < R.Bottom - wb then BitBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, SRCCOPY);
    end
    else StretchBlt(Bmp.Canvas.Handle, R.Right - wr, y, wr, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, SRCCOPY);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if not Stretch then begin
        y := R.Top + wt;
        if h > 0 then while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, h, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x,  R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          if w > 0 then while x < R.Right - w - wr do begin
            BitBlt(Bmp.Canvas.Handle, x, y, w, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
            inc(x, w);
          end;
          if x < R.Right - wr then BitBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, SRCCOPY);
        end;
      end
      else begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBlt(Bmp.Canvas.Handle, x, y, R.Right - wr - x, R.Bottom - wb - y, BmpSrc.Canvas.Handle, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, SRCCOPY);
      end;
    end;
  end
  else begin
    // left - top
    CopyByMask32(Rect(R.Left, R.Top, R.Left + wl, R.Top + wt), Rect(MaskData.R.Left + dw, MaskData.R.Top, MaskData.R.Left + dw + wl, MaskData.R.Top + wt), Bmp, BmpSrc, CI, MaskData);
    y := R.Top + wt;
    // left - middle
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask32(Rect(R.Left, y, R.Left + wl, y + h), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask32(Rect(R.Left, y, R.Left + wl, R.Bottom - wb), Rect(MaskData.R.Left + dw, MaskData.R.Top + wt, MaskData.R.Left + dw + wl, MaskData.R.Top + wt + h), Bmp, BmpSrc, EmptyCI, MaskData);
      end;
    end
    else StretchBltMask32(R.Left, y, wl, R.Bottom - wb - y, MaskData.R.Left + dw, MaskData.R.Top + wt, wl, h, Bmp, BmpSrc, dhm);
    // top - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask32(Rect(x, R.Top, x + w, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask32(Rect(x, R.Top, R.Right - wr, R.Top + wt), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt), Bmp, BmpSrc, EmptyCI, MaskData);
      end;
    end
    else StretchBltMask32(x, R.Top, R.Right - wr - x, wt, MaskData.R.Left + dw + wl, MaskData.R.Top, w, wt, Bmp, BmpSrc, dhm);
    // left - bottom
    CopyByMask32(Rect(R.Left, R.Bottom - wb, R.Left + wl, R.Bottom), Rect(MaskData.R.Left + dw, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh), Bmp, BmpSrc, CI, MaskData);
    // bottom - middle
    x := R.Left + wl;
    if not Stretch then begin
      while x < R.Right - w - wr do begin
        CopyByMask32(Rect(x, R.Bottom - wb, x + w, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, BmpSrc, EmptyCI, MaskData);
        inc(x, w);
      end;
      if x < R.Right - wr then begin
        CopyByMask32(Rect(x, R.Bottom - wb, R.Right - wr, R.Bottom), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh), Bmp, BmpSrc, EmptyCI, MaskData);
      end;
    end
    else StretchBltMask32(x, R.Bottom - wb, R.Right - wr - x, wb, MaskData.R.Left + dw + wl, MaskData.R.Top + dh - wb, w, wb, Bmp, BmpSrc, dhm);
    // right - bottom
    CopyByMask32(Rect(R.Right - wr, R.Bottom - wb, R.Right, R.Bottom), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + dh - wb, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + dh), Bmp, BmpSrc, CI, MaskData);
    // right - top
    CopyByMask32(Rect(R.Right - wr, R.Top, R.Right, R.Top + wt), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + wt), Bmp, BmpSrc, CI, MaskData);
    // right - middle
    y := R.Top + wt;
    if not Stretch then begin
      while y < R.Bottom - h - wb do begin
        CopyByMask32(Rect(R.Right - wr, y, R.Right, y + h), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
        inc(y, h);
      end;
      if y < R.Bottom - wb then begin
        CopyByMask32(Rect(R.Right - wr, y, R.Right, R.Bottom - wb), Rect(MaskData.R.Left + dw + w + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl + wr, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
      end;
    end
    else StretchBltMask32(R.Right - wr, y, wr, R.Bottom - wb - y, MaskData.R.Left + dw + wl + w, MaskData.R.Top + wt, wr, h, Bmp, BmpSrc, dhm);
    // Fill
    if (MaskData.DrawMode and BDM_FILL = BDM_FILL) then begin
      if Stretch then begin
        y := R.Top + wt;
        x := R.Left + wl;
        StretchBltMask32(x, y, R.Right - wr - x, R.Bottom - wb - y, MaskData.R.Left + dw + wl, MaskData.R.Top + wt, w, h, Bmp, BmpSrc, dhm, True)
      end
      else begin
        y := R.Top + wt;
        while y < R.Bottom - h - wb do begin
          x := R.Left + wl;
          while x < R.Right - w - wr do begin
            CopyByMask32(Rect(x, y, x + w, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask32(Rect(x, y, R.Right - wr, y + h), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
          end;
          inc(y, h);
        end;
        x := R.Left + wl;
        if y < R.Bottom - wb then begin
          while x < R.Right - w - wr do begin
            CopyByMask32(Rect(x, y, x + w, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
            inc(x, w);
          end;
          if x < R.Right - wr then begin
            CopyByMask32(Rect(x, y, R.Right - wr, R.Bottom - wb), Rect(MaskData.R.Left + dw + wl, MaskData.R.Top + wt, MaskData.R.Left + dw + w + wl, MaskData.R.Top + h + wt), Bmp, BmpSrc, EmptyCI, MaskData);
          end
        end;
      end;
    end;
  end;
end;

end.




