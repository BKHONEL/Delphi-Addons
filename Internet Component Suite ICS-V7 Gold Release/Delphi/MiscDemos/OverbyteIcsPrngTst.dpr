program OverbyteIcsPrngTst;

uses
  Forms,
  OverbyteIcsPrngTst1 in 'OverbyteIcsPrngTst1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
