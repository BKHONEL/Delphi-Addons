{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Angus Robertson
Creation:     July 3, 2009
Description:  This is an email form demo, designed to send a email to a hard
              coded email address.  It attempts to stop various common
              attacks on email forms and prevents common HTML tags being
              entered in the form.  This demo uses a test email account at
              Magenta Systems, but the sender gets an identical copy of the
              email so you see it worked.
Version:      1.03
EMail:        angus@magsys.co.uk
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 2009 by Fran?ois PIETTE
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
Jul 10, 2009 V1.01 Arno fixed a bug in SmtpClient.OnGetData, we may not send
                   Unicode.
Jul 10, 2009 V1.02 Arno Removed string cast warnings.
Sept 1, 2009 V1.03 Angus - report exceptions creating virtual pages

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsWebAppServerMailer;

interface

Uses
    Windows, SysUtils, Classes, ExtCtrls,
    OverbyteIcsHttpAppServer, OverbyteIcsHttpSrv, OverbyteIcsWebSession,
    OverbyteIcsSmtpProt, OverbyteIcsUtils, OverbyteIcsWSocket,
    OverbyteIcsFtpSrvT;

type

   TUrlHandlerMailer = class(TUrlHandler)
    private
        SmtpClient: TSmtpCli;
        WSocket: TWSocket;
        AbortTimer: TTimer;
        EmailBody: TStringList;
        sMailBody: string ;
        sMailFrom: string ;
        sMailName: string ;
        sMailTo: string ;
        sIPAddr: string ;
        sUserIPHost: string ;
        sPageUrl: string ;
        errorMsg: string ;
        CurSmtpServer: integer ;
    public
        destructor  Destroy; override;
        procedure Execute; override;
        procedure DoneDnsLookup (Sender: TObject; Error: Word);
        procedure TimerAbortTimer(Sender: TObject);
        procedure SmtpClientGetData(Sender: TObject; LineNum: Integer;
              MsgLine: Pointer; MaxLen: Integer; var More: Boolean);
        procedure SmtpClientRequestDone(Sender: TObject; RqType: TSmtpRequest;
             ErrorCode: Word);
        procedure SmtpClientDisplay(Sender: TObject; Msg: String);
    end;

{ the magsys SMTP servers host the ftptest.org domain and may be used for testing
  this email form.  You won't be able to access this mailbox, but will get a CC
  of the email to your mailbox }

var
    SmtpServerList: array [0..1] of string =
        ('mail.magsys.co.uk',
         'mail3.magsys.co.uk') ;

{ note the email host is deliberately hardcoded in this form, to prevent it being
  supplied as a form parameter, which is how spammers abuse email forms.
  The account may be passed as a parameter with the form, but sending the form will
  fail unless it's another valid account at ftptest.org }

const
    DefaultEmailDomain = '@ftptest.org' ;
    DefaultEmailAccount = 'testing' ;

implementation

uses OverbyteIcsWebAppServerMain;

function GetTempLastMod (Client: THttpAppSrvConnection; const FName: string): string ;
var
    FileDT: TDateTime ;
    FSize: Int64 ;
    FullName: string ;
const
    DateMmmMask = 'dd mmm yyyy' ;
begin
    FullName := Client.TemplateDir + '/' + Fname ;
    if GetUAgeSizeFile (FullName, FileDT, FSize) then
        DateTimeToString (Result, DateMmmMask, FileDT)
    else
        Result := 'Page not found' ;
end ;

// get exception literal message

function GetExceptMess (ExceptObject: TObject): string;
var
  MsgPtr: PChar;
  MsgEnd: PChar;
  MsgLen: Integer;
  MessEnd: String ;
begin
  MsgPtr := '';
  MsgEnd := '';
  if ExceptObject is Exception then
  begin
    MsgPtr := PChar(Exception(ExceptObject).Message);
    MsgLen := StrLen(MsgPtr);
    if (MsgLen <> 0) and (MsgPtr[MsgLen - 1] <> '.') then MsgEnd := '.';
  end;
  result := Trim (MsgPtr) ;
  MessEnd := Trim (MsgEnd) ;
  if Length (MessEnd) > 5 then result := result + ' - ' + MessEnd ;
end;

// does a string contain any common HTML tags, used for email body validation to stop spammers using HTML

function IsHtmlTags (const S: string): boolean ;
var
    S2: string ;
begin
    result := false ;
    S2 := Lowercase (S) ;
    if Pos ('<a', S2) > 0 then result := true
    else if Pos ('</a', S2) > 0 then result := true
    else if Pos ('href', S2) > 0 then result := true
    else if Pos ('<img', S2) > 0 then result := true
    else if Pos ('[/url]', S2) > 0 then result := true ;
end;

function IsValidEmail(const Value: String): Boolean;
var
    I : Integer;
    NamePart, ServerPart: String;

    function CheckAllowed(const S: String): Boolean;
    var i: Integer;
    begin
        Result:= false;
        for I := 1 to Length(S) do
          case S[I] of
              'a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.' : {continue};
            else
                Exit;
          end;
        Result:= true;
    end;

begin
    Result := False;
    I := Pos('@', Value);
    if I = 0 then Exit;
    NamePart := Copy(Value, 1, I - 1);
    ServerPart := Copy(Value, I + 1, Length(Value));
    if (Length(NamePart) = 0) or ((Length(ServerPart) < 5)) then
        Exit;
    I := Pos('.', ServerPart);
    if (I = 0) or (I > (Length(ServerPart) - 2)) then
        Exit;
    Result:= CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;


procedure TUrlHandlerMailer.Execute;
begin
    WSocket := TWSocket.Create (self) ;
    WSocket.OnDnsLookupDone := DoneDnsLookup ;
    WSocket.OnBgException := WebAppSrvForm.HttpAppSrvClientBgException;
    AbortTimer := TTimer.Create (self) ;
    AbortTimer.OnTimer := TimerAbortTimer ;
    AbortTimer.Interval := 5000 ;     // five second timeout for DNS
// SmtpClient.RcptName.Clear ; // deliberate exception
    try
//  get user IP address and lookup host name
        sIPAddr := Client.GetPeerAddr ;
        sUserIPHost := '' ;
        WSocket.ReverseDnsLookup (sIPAddr) ;
        AbortTimer.Enabled := true ;
    except
        WebAppSrvForm.Display ('Exception Looking up DNS - ' + GetExceptMess (ExceptObject)) ;
        DoneDnsLookup (Self, 999) ; // continue to use form
    end;
end;

destructor TUrlHandlerMailer.Destroy;
begin
    if Assigned (AbortTimer) then
    begin
        AbortTimer.Enabled := false ;
        FreeAndNil (AbortTimer) ;
    end ;
    FreeAndNil (WSocket) ;
    FreeAndNil (SmtpClient) ;
    FreeAndNil (EmailBody) ;
    inherited Destroy;
end;

procedure TUrlHandlerMailer.DoneDnsLookup (Sender: TObject; Error: Word);
var
    AWSocket: TWSocket ;
    I: integer ;
    sTemp, sTempFrom, sMagEmail: string ;
begin
    AbortTimer.Enabled := false ;
    AbortTimer.Interval := 60000 ;     // 60 second timeout for SMTP
    sTemp := '' ;
    AWSocket:= Sender as TWSocket ;
    if Error = 0 then
    begin
        if AWSocket.DnsResultList.Count <> 0 then
        begin
            for I := 0 to Pred (AWSocket.DnsResultList.Count) do
            begin
                if I <> 0 then sTemp := sTemp + ', ' ;
                sTemp := sTemp + AWSocket.DnsResultList [I] ;
            end
        end
        else
            sTemp := AWSocket.DnsResult ;
        sUserIPHost := sTemp + ' (' + sIPAddr + ')' ;
    end
    else
    begin
        WebAppSrvForm.Display ('DNS Lookup Failed - ' + WSocketErrorDesc (Error)) ;
        sUserIPHost := sIPAddr ;
    end;
    sPageUrl := 'http://' + Client.RequestHost + Client.Path ;  // used for POST URL
    errorMsg := '' ;

// see if to email account passed as query - no domain
    if Client.Method = 'GET' then
    begin
  //      ExtractURLEncodedValue (Params, 'EmailTo', sMailTo) ;
    	sMailTo := Params ;
//  SmtpClient.RcptName.Clear ; // deliberate exception
    end ;

// see if page is being POSTed by itself to send and email
    if Client.Method = 'POST' then
    begin
        ExtractURLEncodedValue (String(Client.PostedData), 'MailZBody', sMailBody) ;
	    if IsHtmlTags (sMailBody) then
        begin
            errorMsg := 'Please specify valid content' ; // spammers use HTML tags in the body
            WebAppSrvForm.Display ('Email validation error: ' + errorMsg + ' - ' + sMailBody) ;
        end
        else if (Length (sMailBody) < 40) then
        begin
            errorMsg := 'Please specify your full message' ;
            WebAppSrvForm.Display ('Email validation error: ' + errorMsg + ' - ' + sMailBody) ;
        end;
        ExtractURLEncodedValue (String(Client.PostedData), 'MailZFrom', sMailFrom) ;
        ExtractURLEncodedValue (String(Client.PostedData), 'MailZName', sMailName) ;
        ExtractURLEncodedValue (String(Client.PostedData), 'MailZTo', sMailTo) ;
        if Length (sMailTo) < 4 then sMailTo := DefaultEmailAccount ;  // no account passed, use default
        if NOT IsValidEmail (sMailFrom) then
        begin
            errorMsg := 'Please specify a valid email address' ;
            WebAppSrvForm.Display ('Email validation error: ' + errorMsg + ' - ' + sMailFrom) ;
        end;
     // the IP check is to stop spammers POSTing this page without having GET it first, they have to know the IP and host name
        ExtractURLEncodedValue (String(Client.PostedData), 'MailZIp', sTemp) ;
        if sUserIPHost <> sTemp then
        begin
            errorMsg := 'Please specify your message again, internal error' ;
            WebAppSrvForm.Display ('Email validation error: ' + errorMsg + ' - IP Address ' + sTemp) ;
        end;
        if Length (sMailName) < 5 then
            errorMsg := 'Please specify your full name'
        else if NOT IsUsAscii (sMailName) then errorMsg := 'Your full name can not contain punctuation' ;

    //  build form email and display content
        if (errorMsg = '') then
        begin
          // email it to hardcoded host
            try
                sMagEmail := sMailTo + DefaultEmailDomain ;
                sTempFrom := '"' + sMailName + '" <' + sMailFrom + '>' ;
                if NOT Assigned (EmailBody) then EmailBody := TStringList.Create ;
                if NOT Assigned (SmtpClient) then SmtpClient := TSmtpCli.Create (self) ;
                SmtpClient.OnBgException := WebAppSrvForm.HttpAppSrvClientBgException;
                SmtpClient.OnDisplay := SmtpClientDisplay ;
                SmtpClient.OnGetData := SmtpClientGetData ;
                SmtpClient.OnRequestDone := SmtpClientRequestDone ;
                EmailBody.Text := RemoveHtmlSpecialChars (sMailBody) +  #13#10 +  #13#10 +
                        'User Address: ' + sUserIPHost +  #13#10 +
                        'Email Sent from Web Site Response Form: ' + sPageUrl +  #13#10 ;
                if Client.AuthUserName <> '' then
                                 EmailBody.Add ('User Account: ' + Client.AuthUserName) ;
                WebAppSrvForm.Display ('Sending Email Form to ' + sMagEmail + ' from ' + sTempFrom) ;
                SmtpClient.RcptName.Clear ;
                SmtpClient.RcptName.Add (sMagEmail) ;
                SmtpClient.RcptName.Add (sMailFrom) ;
                SmtpClient.FromName := sMailFrom ;
                SmtpClient.HdrTo := sMagEmail ;
                SmtpClient.HdrFrom := sTempFrom ;
                SmtpClient.HdrReplyTo := sTempFrom ;
                SmtpClient.HdrCc := sTempFrom ;
                SmtpClient.HdrSubject := 'ICS Demo Web Site Email Form - ' + sMailTo ;
                SmtpClient.Host := SmtpServerList [0] ;
                CurSmtpServer := 0 ;
                SmtpClient.Open ;  // connect, then helo
                AbortTimer.Enabled := true ;
                exit ; // wait for events to send response
            except
                errorMsg := 'Failed to Start Sending Email Form: ' + GetExceptMess (ExceptObject) ;
                WebAppSrvForm.Display (errorMsg) ;
            end;
        end ;
    end ;

    AnswerPage('', NO_CACHE, 'mailer.html', nil,
             ['PageLastMod', GetTempLastMod (Client, 'mailer.html'),
              'sPageUrl', sPageUrl, 'sMailTo', sMailTo, 'sMailName', sMailName,
              'sUserIPHost', sUserIPHost, 'sMailFrom', sMailFrom,
              'sMailBody', sMailBody, 'errorMsg', errorMsg
               ]);
    Finish;
end;

procedure TUrlHandlerMailer.SmtpClientGetData(Sender: TObject; LineNum: Integer;
      MsgLine: Pointer; MaxLen: Integer; var More: Boolean);
begin
    try
        if NOT Assigned (EmailBody) then
            More := false
        else
        begin
            if LineNum > EmailBody.Count then
                More := false
            else
                StrPCopy (PAnsiChar(MsgLine), AnsiString(EmailBody [Pred (LineNum)])) ;
        end ;
    except
    end ;
end;

procedure TUrlHandlerMailer.TimerAbortTimer(Sender: TObject);
begin
    AbortTimer.Enabled := false ;
    if sUserIPHost = '' then
    begin
        WebAppSrvForm.Display ('DNS Lookup Timed Out') ;
        WSocket.CancelDnsLookup ;
    end
    else
    begin
        WebAppSrvForm.Display ('SMTP Send Timed Out') ;
        SmtpClient.Quit ;
    end ;
end;

procedure TUrlHandlerMailer.SmtpClientRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
begin
    if not Assigned(Client) then begin
        // Client is gone, abort everything
        SmtpClient.Abort;
        Finish;
        Exit;
    end;

    AbortTimer.Enabled := false ;
    try
        if RqType = smtpOpen then
        begin
            if ErrorCode = 0 then
            begin
                WebAppSrvForm.Display ('Connected to SMTP Server: ' + SmtpClient.Host) ;
                SmtpClient.Mail ;  // headers then data
                AbortTimer.Enabled := true ;
                exit ;
            end ;
            errorMsg := 'Failed to Send Email Form, SMTP Server: ' + SmtpClient.Host +
                                                ', Open Error - ' + SmtpClient.ErrorMessage ;
            WebAppSrvForm.Display (errorMsg) ;

          // see if trying second server
            inc (CurSmtpServer) ;
            if CurSmtpServer < Length (SmtpServerList) then
            begin
                WebAppSrvForm.Display ('Trying Alternate SMTP Server') ;
                SmtpClient.Host := SmtpServerList [CurSmtpServer] ;
                SmtpClient.Open ;
                AbortTimer.Enabled := true ;
                exit ;
            end ;
            SmtpClient.Quit ;
        end
        else if RqType = smtpQuit then
        begin
            errorMsg := 'Quit Send Email Form - ' + SmtpClient.ErrorMessage ;
        end
        else if RqType = smtpMail then
        begin
            SmtpClient.Quit ;
            if ErrorCode = 0 then
            begin
                WebAppSrvForm.Display ('Sent Email Form OK') ;
                AnswerPage('', NO_CACHE, 'maildone.html', nil, []) ;
                Finish;
                exit ;
            end
            else
            begin
                errorMsg := 'Failed to Send Email Form, Mail Error - ' + SmtpClient.ErrorMessage ;
            end ;
        end
        else
        begin
            SmtpClient.Quit ;
            errorMsg := 'Unexpected Email Form Request Done: ' + IntToStr (Ord (RqType)) ;
        end ;
    except
        errorMsg := '!! Error Sending Email - ' + GetExceptMess (ExceptObject) +
                                                     ' - ' + SmtpClient.ErrorMessage ;
    end ;
    WebAppSrvForm.Display (errorMsg) ;
    AnswerPage('', NO_CACHE, 'mailer.html', nil,
             ['PageLastMod', GetTempLastMod (Client, 'mailer.html'),
              'sPageUrl', sPageUrl, 'sMailTo', sMailTo, 'sMailName', sMailName,
              'sUserIPHost', sUserIPHost, 'sMailFrom', sMailFrom,
              'sMailBody', sMailBody, 'errorMsg', errorMsg
               ]);
    Finish;
end;

procedure TUrlHandlerMailer.SmtpClientDisplay(Sender: TObject; Msg: String);
begin
    WebAppSrvForm.Display ('Smtp:' + Msg) ;
end;

end.
