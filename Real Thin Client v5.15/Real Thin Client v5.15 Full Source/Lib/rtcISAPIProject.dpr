{ @html(<b>)
  ISAPI Project Template
  @html(</b>)
  - Copyright (c) 2004-2009 by Danijel Tkalcec
  @html(<br><br>)

  @exclude }
library rtcISAPIProject;

uses
  ActiveX,
  ComObj,
  rtcISAPIApp;

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.Run;
end.
