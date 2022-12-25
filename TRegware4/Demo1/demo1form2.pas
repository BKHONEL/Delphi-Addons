unit demo1form2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellApi;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TForm2.Label2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'Open', 'http://wak.cjb.net/', nil, nil, SW_SHOW);
end;

end.
