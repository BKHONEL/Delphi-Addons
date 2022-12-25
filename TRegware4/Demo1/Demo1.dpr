program Demo1;

{%ToDo 'Demo1.todo'}

uses
  Forms,
  demo1main in 'demo1main.pas' {MainForm},
  demo1form2 in 'demo1form2.pas' {Form2},
  proginfo_frame in 'proginfo_frame.pas' {ProgInfoFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TRegware Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
