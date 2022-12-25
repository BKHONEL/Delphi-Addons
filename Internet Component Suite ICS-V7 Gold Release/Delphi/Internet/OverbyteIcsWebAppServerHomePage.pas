{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Fran�ois PIETTE
Creation:     April 11, 2009
Description:  This source is part of WebAppServer demo application.
              The purpose is to implement the home page for the application.
              It is very basic with a counter and links to other demo pages.
Version:      1.00
EMail:        francois.piette@overbyte.be    http://www.overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2009 by Fran�ois PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsWebAppServerHomePage;

interface

uses
    Windows, Classes, SysUtils,
    OverbyteIcsHttpSrv,
    OverbyteIcsHttpAppServer,
    OverbyteIcsWebAppServerDataModule,
    OverbyteIcsWebAppServerHttpHandlerBase,
    OverbyteIcsWebAppServerUrlDefs,
    OverbyteIcsWebAppServerSessionData;

type
    TUrlHandlerDefaultDoc = class(TUrlHandlerBase)
    public
        procedure Execute; override;
    end;

    TUrlHandlerHomePageHtml = class(TUrlHandlerBase)
    public
        procedure Execute; override;
    end;

implementation

procedure TUrlHandlerDefaultDoc.Execute;
begin
    if NotLogged then
        Exit;
    Relocate(UrlHomePage);
end;

procedure TUrlHandlerHomePageHtml.Execute;
begin
    if NotLogged then
        Exit;
    AnswerPage('', NO_CACHE, '/HomePage.html', nil,
               ['LOGIN',       UrlLogin,
                'COUNTER',     UrlCounter,
                'CONFIG',      UrlConfigForm,
                'COUNTERVIEW', UrlCounterViewHtml,
                'USERCODE',    SessionData.UserCode,
                'LOGINTIME',   DateToStr(SessionData.LogonTime)]);
    Finish;
end;

end.
