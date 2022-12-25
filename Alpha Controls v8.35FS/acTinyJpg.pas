unit acTinyJPG;

interface

uses windows, classes, sysutils, graphics, axctrls;

type
  TacTinyJPGImage = class (TOleGraphic)
public
  procedure LoadFromFile(const Filename: string); override;
  procedure LoadFromStream(Stream: TStream); override;
end;

implementation

procedure TacTinyJPGImage.LoadFromStream(Stream: TStream);
begin
  Stream.Position := 0;
  inherited;
end;

procedure TacTinyJPGImage.LoadFromFile(const Filename: string);
var
  s : TFileStream;
begin
  s := TFileStream.Create (FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream (s)
  finally
    s.Free
  end
end;

{
initialization
  TPicture.RegisterFileFormat('JPG', 'JPG Image', TTinyJPGImage);
finalization
  TPicture.UnregisterGraphicClass(TTinyJPGImage);
}  
end.