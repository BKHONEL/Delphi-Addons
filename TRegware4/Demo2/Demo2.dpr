program Demo1;

{%ToDo 'Demo1.todo'}
{%ToDo 'Demo2.todo'}

uses
  Forms,
  demo1main in 'demo1main.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TRegware Demo 2';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
