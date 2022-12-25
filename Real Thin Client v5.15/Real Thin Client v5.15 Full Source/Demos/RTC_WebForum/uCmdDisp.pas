unit uCmdDisp;

{$INCLUDE defines.inc}

{$INCLUDE rtcDefs.inc}

interface

uses
  {$IFDEF IDE_1}
  FileCtrl,
  {$ENDIF}
  SysUtils, Classes, rtcInfo,
  rtcConn, rtcCrypt, rtcDataSrv,
  rtcParse, rtcParseEx,

  uTrans, uTypes, uMessages,
  uDB, uForumDB;

const
  LOGIN_ADMIN = 'admin';
  LOGIN_GUEST = '';

const
  ACCESS_LEVEL_DENIED = -1;
  ACCESS_LEVEL_USER   = 0;
  ACCESS_LEVEL_ADMIN  = 1;

const
  SELECTED = 'selected';
  CHECKED = 'checked';

type
  TCommandsDispatcher = class
  private
    fPageMessage : AnsiString;
    fSrv : TRtcDataServer;

    procedure ShowPageMessage(Page : TRtcParse); overload;
    procedure ShowPageMessage(Page : TRtcParseEx); overload;
    procedure SetPageMessage(const Value: AnsiString);
    function GetPageMessage: AnsiString;

    function GetRequestValue (name : AnsiString) : AnsiString;

    function FindSession : boolean;
    function GetSession: TRtcServerSession;
    function GetSessionID: AnsiString;

    function GetTemplatePath: AnsiString;
    function GetUploadPath: AnsiString;

  private
    property PageMessage : AnsiString read GetPageMessage write SetPageMessage;

  protected
    procedure Relocation (URL : AnsiString);
    function RelocationOnError(MsgID : AnsiString):AnsiString;
    //
    function DoCommonAccess(Cmd : AnsiString) : AnsiString;
    function DoAdminAccess(Cmd : AnsiString) : AnsiString;
    //
    function DoRedir : AnsiString;
    //
    function DoIndexPage (msg : AnsiString = '' ) : AnsiString;
    function HeaderArea(DocumentTitle : AnsiString = '') : AnsiString;
    //
    function DoAdmin : AnsiString;
    //
    // Login, Logout
    //
    function DoLogin (const Guest : boolean = false): integer; overload;
    function DoLogin (user, pwd : AnsiString): integer; overload;
    function DoLogOut : AnsiString;
    //
    // Users
    //
    function DoShowUsers : AnsiString;
    function DoEditUser : AnsiString;
    function DoSaveUser : AnsiString;
    function DoDelUser : AnsiString;
    //
    // User Access Rights
    //
    function DoShowSectionsAccess : AnsiString;
    function DoEditSectionsAccess : AnsiString;
    function DoSaveSectionsAccess : AnsiString;
    //
    // Sections
    //
    function DoShowSections : AnsiString;
    function DoAddSection : AnsiString;
    function DoEditSection : AnsiString;
    function DoSaveSection : AnsiString;
    function DoDelSection : AnsiString;
    function DoMoveSection : AnsiString;
    //
    // User's password
    //
    function DoSavePwd : AnsiString;
    function DoChangePwd : AnsiString;
    //
    // Packages and files
    //
    function DoShowPackAccess : AnsiString;
    function DoEditPackAccess : AnsiString;
    function DoSavePackAccess : AnsiString;
    //
    function DoShowPackages : AnsiString;
    function DoAddPack : AnsiString;
    function DoEditPack : AnsiString;
    function DoSavePack : AnsiString;
    function DoDelPack : AnsiString;
    //
    function DoPackFiles : AnsiString;
    function DoAddFile : AnsiString;
    function DoEditFile : AnsiString;
    function DoSaveFile : AnsiString;
    function DoDelFile : AnsiString;
    //-------------------------------------------------------------------------
    // Forum and Packages for user's access
    //-------------------------------------------------------------------------
    function DoForum : AnsiString;
    function DoPackagesSectionView : AnsiString;
    function DoSectionView : AnsiString;
    function DoNewTopic : AnsiString;
    function DoSaveTopic : AnsiString;
    function DoTopicView : AnsiString;
    function DoDeleteTopic : AnsiString;
    function DoDeleteReply: AnsiString;
    //
    function DoSetFilter : AnsiString;
    //
    //
  public
    constructor Create(aSrv : TRtcDataServer);
    function MakeDispatch : AnsiString;
    function GetSessionLogin : AnsiString;
    //
    property Srv : TRtcDataServer read fSrv;
    property Session : TRtcServerSession read GetSession;
    property SessionID : AnsiString read GetSessionID;

    property TemplatePath : AnsiString read GetTemplatePath;
    property UploadPath : AnsiString read GetUploadPath;
  end;

procedure InitForumData(data, templates, upload:AnsiString);

implementation

var
  Forum_Templates_Path,
  Forum_Upload_Path:AnsiString;

  ForumData:TRtcForumData=nil;

procedure InitForumData(data, templates, upload:AnsiString);
  begin
  if assigned(ForumData) then
    begin
    ForumData.Free;
    ForumData:=nil;
    end;

  data:=_IncludeTrailingPathDelimiter(data);
  templates:=_IncludeTrailingPathDelimiter(templates);
  upload:=_IncludeTrailingPathDelimiter(upload);

  Forum_Templates_Path:=templates;
  Forum_Upload_Path:=upload;

  InitUserData(data);
  ForumData:=TRtcForumData.Create(data);
  end;

// Visibility of section. Look at matrix.xls for details...
function IsSectionVisible(SectionVisLevel : TVisibilityLevel;
  UserLevel : TUserAccessLevel) : boolean;
begin
  Result :=
    (SectionVisLevel = vlPublic) or
    ( (SectionVisLevel = vlPrivate) and (UserLevel > uaNone) );
end;

// Writable of section for user. Look at matrix.xls for details...
function IsSectionWritable(SectionAccessLevel : TAccessLevel;
  UserLevel : TUserAccessLevel) : boolean;
begin
  Result :=
    (SectionAccessLevel = alOpen) or
    ( (SectionAccessLevel = alClosed) and (UserLevel >= uaWrite) );
end;

// Moderatable of section for user. Look at matrix.xls for details...
function IsSectionModeratable(SectionAccessLevel : TAccessLevel;
  UserLevel : TUserAccessLevel) : boolean;
begin
  Result := (UserLevel >= uaModerate) ;
end;

{-- Encode/decode login information --------------------------------------------}
const
  __crypt_key = '{A73A8BE7-18FD-4D38-99BC-9BC2BFD5E6BC}';  // randomly generated key

function EncodeLoginInfo(user, pwd : AnsiString) : AnsiString;
var
  Arr : TRtcArray;
  S : AnsiString;
begin
  S := '';
  Result := '';

  Arr := TRtcArray.Create;
  try
    Arr.asString[0]:=user;
    Arr.asString[1]:=pwd;
    S := Arr.toCode;
  finally
    Arr.Kill;
  end;

  Crypt(S, __crypt_key);
  Result := URL_Encode(Mime_Encode(S));
end;

procedure DecodeLoginInfo(str : AnsiString; var user, pwd : AnsiString);
var
  Arr : TRtcArray;
  S : AnsiString;
begin
  try
    S := Mime_Decode(URL_Decode(str));
    Decrypt(S, __crypt_key);

    Arr := TRtcArray.FromCode(S);
    try
      user := Arr.asString[0];
      pwd := Arr.asString[1];
    finally
      Arr.Kill;
      end;
  except
    user:='';
    pwd:='';
    end;
end;

{-- TCommandsDispatcher  -------------------------------------------------------}

function TCommandsDispatcher.MakeDispatch : AnsiString;
var
  Cmd : AnsiString;
  Access_Level : integer;
  user, pwd : AnsiString;
  S : AnsiString;

  function _ChangeSID (S : AnsiString) : AnsiString;               //cmd=packages&sid=88464CC05F1244CFACA1C6584B498D48
  var
    P0, P1 : integer;
  begin
    Result := S;
    P0 := Pos('sid=', S);
    if P0 = 0 then begin
      S := Format('%s&sid=', [S]);
      P0 := Length(S) - 3;
    end;
    P0 := P0 + 4;
    P1 := P0 + 32;
    Result:=Copy(S, 1, P0-1);
    if assigned(Session) then
      Result := Result+SessionID;
    Result:=Result+Copy(S, P1+1, MAXINT);
  end;

begin
  Cmd := GetRequestValue('cmd');

  if (Cmd = 'logout') then
    begin
    if (Srv.Request.Cookie['rtc_forum_uid'] <> '') and
       (CompareText(Srv.Request.Cookie['rtc_forum_uid'],'null')<>0) then  // only if cookie present
      begin
      Srv.Response.Cookie['rtc_forum_uid'] := 'null; expires=Sat, 01-Jan-2000 00:00:00 GMT; path=/;';
      Srv.Request.Cookie['rtc_forum_uid']:='';
      end;
    if FindSession then
      begin
      Srv.Session.Close;
      Srv.UnLockSession;
      end;
    Relocation('?cmd=home');
    Exit; // **** EXIT ****
    end
  else if (Cmd = 'login') then
    begin
    Access_Level := DoLogin;
    if (Access_Level=ACCESS_LEVEL_ADMIN) then // Admin always logs into initial screen
      Srv.Request.Query['cmd']:='';
    end
  else if FindSession and Session.asBoolean['login'] then
    Access_Level := Session.asInteger['access_level']
  else
    begin
    S := Srv.Request.Cookie['rtc_forum_uid'];
    if (length(s)>0) and (CompareText(s,'null')<>0) then
      begin
      DecodeLoginInfo(S, user, pwd);
      if (user<>'') then
        Access_Level := DoLogin(user, pwd)
      else
        Access_Level := DoLogin(True);
      end
    else
      Access_Level := DoLogin(True);
    end;

  if (Cmd='login') or (Cmd='logout') then
    begin
    Srv.Request.Method:='GET';
    Cmd:=GetRequestValue('cmd');
    end;

  if assigned(Session) and
      (Access_Level<>ACCESS_LEVEL_DENIED) and
      (Srv.Request.Query['sid']<>Session.ID) then
    Relocation('?'+_ChangeSID(Srv.Request.Query.Text))
  else
    begin
    case Access_Level of
      ACCESS_LEVEL_USER :
        Result := DoCommonAccess(Cmd);
      ACCESS_LEVEL_ADMIN :
        Result := DoAdminAccess(Cmd);
      else
        begin
        PageMessage := GetMsg('error_login_failed');
        Result := DoCommonAccess(Cmd);
        end;
      end;
    end;
  end;

function TCommandsDispatcher.DoLogin(const Guest : boolean = false) : integer;
var
  user, pwd: AnsiString;
  guest_access : boolean;
  S : AnsiString;
  PreviousLogon : TDateTime;
begin
  if not Guest then
    user := GetRequestValue('user');

  if user = '' then
    user := LOGIN_GUEST;

  pwd := GetRequestValue('pwd');

  guest_access := Guest or (CompareText(user, LOGIN_GUEST)=0);

  if Guest or CheckUser(user, pwd) then
    begin
    if not guest_access then
      begin
      Srv.OpenSession;
      if user = LOGIN_ADMIN then
        Session.asInteger['access_level'] := ACCESS_LEVEL_ADMIN
      else
        Session.asInteger['access_level'] := ACCESS_LEVEL_USER;
      Session.asString['user_name'] := user;
      Session.asBoolean['login'] := True;
      Session.KeepAlive := 60 * 60; //60 minutes
      {$IFDEF USE_COOKIE_SESSIONID}
      Srv.Response.Cookie['session'] := SessionID;
      {$ENDIF}

      // get previuos logon datetime
      GetLastLogon(user, PreviousLogon);
      Session.asDateTime['previous logon'] := PreviousLogon;
      SetLastLogon(user, Now);
      // set cookie for auto-open session next visit
      S := EncodeLoginInfo(user, pwd);
      Srv.Response.Cookie['rtc_forum_uid'] := Format('%s; expires=Sun, 01-Jan-2034 00:00:00 GMT; path=/;', [S]);

      Result := Session.asInteger['access_level'];
      end
    else
      Result := ACCESS_LEVEL_USER;
    end
  else
    Result := ACCESS_LEVEL_DENIED;
end;

function TCommandsDispatcher.DoShowUsers : AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  Users : TStringList;
  I : integer;
begin
  Page := TRtcParse.Create(TemplatePath + 'users.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'users_table_row.htm');
    try
      Users := TStringList.Create;
      try
        GetUsers(Users);
        for I := 0 to Users.Count - 1 do begin
          TableRow.Clear;
          TableRow['user_login'] := Users.Names[I];
          TableRow['user_login_enc'] := URL_Encode(Users.Names[I]);
          TableRow['user_name'] := _GetValueFromIndex(Users,I);
          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        Users.Free;
      end;
    finally
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoEditUser : AnsiString;
var
  Page : TRtcParse;
  name, pwd : AnsiString;
  login: AnsiString;
begin
  Page := TRtcParse.Create(TemplatePath + 'edituser.htm');
  try
    Page['header_area'] := HeaderArea;
    login := GetRequestValue('user');
    GetUserInfo(login, name, pwd);
    if name = '' then
      begin
        Page['caption'] := 'Add user';
        Page['new'] := 'true';
      end
    else
      begin
        Page['caption'] := 'Edit user';
        Page['new'] := '';
      end;
    Page['name'] := name;
    Page['login'] := login;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoSaveUser : AnsiString;
var
  login : AnsiString;
begin
  login := GetRequestValue('login');
  if (GetRequestValue('new')='true') and IsUserExists(login) then
    PageMessage := Format(GetMsg('error_user_exists'), [login])
  else
    SaveUserInfo(login, GetRequestValue('name'), GetRequestValue('pwd'));

  //Result := DoShowUsers;
  Relocation(Format('?cmd=showusers&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoDelUser : AnsiString;
var
  login: AnsiString;
begin
  login := GetRequestValue('user');
  if (CompareText(login, LOGIN_ADMIN)=0) or (CompareText(login, LOGIN_GUEST)=0) then
    PageMessage := Format(GetMsg('error_del_user'), [login])
  else if not DeleteUser(login) then
      PageMessage := Format(GetMsg('error_del_user'), [login]);

  //Result := DoShowUsers;
  Relocation(Format('?cmd=showusers&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoEditSectionsAccess : AnsiString;
begin
end;

function TCommandsDispatcher.DoShowSectionsAccess : AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  I : integer;
  login: AnsiString;

  SectionsList:TList;
  Section:PSectionRecord;
  UserAccessRights : TUserAccessLevel;
  Filter : TFilterUserAccessRights;

  function InFilter(F: TFilterUserAccessRights; U: TUserAccessLevel): boolean;
  begin
    Result :=
      ( F = frAll ) or
      ( (F = frNone) and (U = uaNone) ) or
      ( (F = frRead) and (U = uaRead) ) or
      ( (F = frWrite) and (U = uaWrite) ) or
      ( (F = frModerate) and (U = uaModerate) ) or
      ( (F = frPower) and (U in [uaRead..uaModerate]) );
  end;

begin
  Page := TRtcParse.Create(TemplatePath + 'useraccess.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    login := GetRequestValue('user');
    Page['user'] := login;
    Page['user_login_enc'] := URL_Encode(login);

    // get filter
    Filter := TFilterUserAccessRights(StrToIntDef(GetRequestValue('filter'), 5));
    case Filter of
      frNone :
        Page['none_selected'] := SELECTED;
      frRead :
        Page['read_selected'] := SELECTED;
      frWrite :
        Page['write_selected'] := SELECTED;
      frModerate :
        Page['moderate_selected'] := SELECTED;
      frPower :
        Page['power_selected'] := SELECTED;
      else
        Page['all_selected'] := SELECTED;
    end;

    // list of sections
    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'access_table_row.htm');

    ForumData.Lock;
    try
      ForumData.LoadSections;
      ForumData.LoadRights;

      SectionsList := ForumData.Sections.GetOrderedList;
      try
        for I := 0 to SectionsList.Count - 1 do
          begin
          Section := PSectionRecord(SectionsList[I]);

          if Section^.Deleted then
            Continue;

          UserAccessRights :=
            ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);

          if not InFilter(Filter, UserAccessRights) then
            Continue;

          TableRow.Clear;
          TableRow['section_id'] := IntToStr(Section^.ID);
          TableRow['section_name'] := Section^.Name;
          TableRow['vis_level'] := VisibilityToStr(Section^.VisibilityLevel);
          TableRow['access_level'] := AccessToStr(Section^.AccessLevel);

          // show Write for all users for public sections
          //if (Section^.VisibilityLevel = vlPublic) and (UserAccessRights <> uaModerate) then
          //  UserAccessRights := uaWrite;

          case UserAccessRights of
            uaNone :
              TableRow['none_selected'] := SELECTED;
            uaRead :
              TableRow['read_selected'] := SELECTED;
            uaWrite :
              TableRow['write_selected'] := SELECTED;
            uaModerate :
              TableRow['moderate_selected'] := SELECTED;
          end;

          TableRow['user'] := login;
          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        SectionsList.Free;
        end;
    finally
      ForumData.Unlock;
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoSaveSectionsAccess : AnsiString;
var
  login, section_id : AnsiString;
begin
  login := GetRequestValue('user');
  section_id := GetRequestValue('section_id');

  ForumData.Lock;
  try
    ForumData.LoadRights;

    ForumData.Rights.SetUserAccessLevel(
      LowerCase(login),
      StrToIntDef(section_id, 0),
      TUserAccessLevel(StrToIntDef(GetRequestValue('rights'), 0))
    );
  finally
    ForumData.Unlock;
    end;

  //Result := DoShowSectionsAccess;
  Relocation(Format('?cmd=showsectionsaccess&user=%s&sid=%s', [login, SessionID]));
end;

function TCommandsDispatcher.DoShowSections : AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  I : integer;
  SectionsList : TList;
begin
  Page := TRtcParse.Create(TemplatePath + 'sections.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'sections_table_row.htm');

    ForumData.Lock;
    try
      ForumData.LoadSections;

      SectionsList := ForumData.Sections.GetOrderedList;
      try
      for I := 0 to SectionsList.Count - 1 do
        with PSectionRecord (SectionsList[I])^ do
          if not Deleted then begin
            TableRow.Clear;
            TableRow['section_name'] := Name;
            TableRow['section_id'] := IntToStr(ID);
            TableRow['vis_level'] := VisibilityToStr(VisibilityLevel);
            TableRow['access_level'] := AccessToStr(AccessLevel);
            TableRow['topics_count'] := IntToStr(TopicsCount);
            TableRow['posts_count'] := IntToStr(PostCount);
            if I > 0 then
              TableRow['place_above'] := IntToStr(PSectionRecord(SectionsList[I-1])^.ID);
            if I < SectionsList.Count - 1 then
              TableRow['place_below'] := IntToStr(PSectionRecord(SectionsList[I+1])^.ID);
            TableRow['sid'] := SessionID;
            S := S + TableRow.Output;
          end;
      finally
        SectionsList.Free;
      end;
    finally
      ForumData.Unlock;
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoAddSection : AnsiString;
var
  Page : TRtcParse;
begin
  Page := TRtcParse.Create(TemplatePath + 'editsection.htm');
  try
    Page['header_area'] := HeaderArea;
    Page['caption'] := 'Add Section';
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoEditSection : AnsiString;
var
  Page : TRtcParse;
  section_id : AnsiString;
  Section : PSectionRecord;
begin
  Page := TRtcParse.Create(TemplatePath + 'editsection.htm');

  ForumData.Lock;
  try
    ForumData.LoadSections;

    Page['header_area'] := HeaderArea;
    Page['caption'] := 'Edit Section';
    Page['sid'] := SessionID;

    section_id := GetRequestValue('section_id');
    Page['section_id'] := section_id;

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then
      Exit;

    Page['section_name'] := Section^.Name;

    Page['sort_order'] := IntToStr(Section^.SortOrder);

    case Section^.VisibilityLevel of
      vlPublic : Page['public_selected'] := SELECTED;
      vlPrivate : Page['private_selected'] := SELECTED;
    end;

    case Section^.AccessLevel of
      alOpen : Page['open_selected'] := SELECTED;
      alClosed : Page['closed_selected'] := SELECTED;
    end;

    Result := Page.Output;
  finally
    ForumData.Unlock;
    
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoSaveSection: AnsiString;
var
  section_id : AnsiString;
  i_section_id : integer;
  sectionname, vis_level, acc_level : AnsiString;
  Section : PSectionRecord;
begin
  section_id := GetRequestValue('section_id');
  sectionname := GetRequestValue('section_name');
  vis_level := GetRequestValue('vis_level');
  acc_level := GetRequestValue('acc_level');
  i_section_id := StrToIntDef(section_id, 0);

  ForumData.Lock;
  try
    ForumData.LoadSections;
    
    if section_id = '' then
      Section := ForumData.Sections.New
    else
      begin
        Section := ForumData.Sections.ItemsByID[i_section_id];
        if not Assigned(Section) then
          Section := ForumData.Sections.New;
      end;

    with Section^ do begin
      Name := sectionname;
      VisibilityLevel := StrToVisibility(vis_level);
      AccessLevel := StrToAccess(acc_level);
      SortOrder := StrToIntDef(GetRequestValue('order'), ID)
    end;
  finally
    ForumData.Unlock;
    end;

  //Result := DoShowSections;
  Relocation(Format('?cmd=showsections&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoDelSection : AnsiString;
var
  section_id : integer;
begin
  section_id := StrToIntDef(GetRequestValue('section_id'), 0);
  ForumData.Lock;
  try
    ForumData.LoadSections;
    if ForumData.Sections.DeleteByID(section_id) then
      ForumData.DeleteSection(section_id)
    else
      PageMessage := GetMsg('error_del_section');
  finally
    ForumData.Unlock;
    end;

  //Result := DoShowSections;
  Relocation(Format('?cmd=showsections&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoIndexPage(msg: AnsiString): AnsiString;
var
  Access_Level : integer;
begin
  if assigned(Session) and Session.asBoolean['login'] then
    Access_Level:=Session.asInteger['access_level']
  else
    Access_Level:=ACCESS_LEVEL_USER;

  case Access_Level of
    ACCESS_LEVEL_ADMIN :
      Result := DoAdmin;

    ACCESS_LEVEL_USER :
      Result := DoForum;

    else
      begin
        DoLogin(True);
        Result := DoForum;
      end;
  end;
end;

function TCommandsDispatcher.DoLogOut: AnsiString;
begin
  DoLogin(True);
  //Result := DoIndexPage;
  Relocation('?cmd=home');
end;

function TCommandsDispatcher.DoSavePwd : AnsiString;
begin
  if assigned(Session) then
    ChangePassword(Srv.Session.asString['user_name'], GetRequestValue('old_pwd'), GetRequestValue('pwd'));

  //Result := DoLogOut;
  Relocation(Format('?cmd=logout&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoChangePwd : AnsiString;
var
  Page : TRtcParse;
begin
  Page := TRtcParse.Create(TemplatePath + 'user_changepwd.htm');
  try
    Page['header_area'] := HeaderArea;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoCommonAccess(Cmd: AnsiString): AnsiString;
begin
  if Cmd = 'logout' then
    begin
      if assigned(Session) then
        begin
        Srv.Session.Close;
        Srv.UnLockSession;
        Result := DoLogOut;
        end
      else
        Result := DoIndexPage;
    end
  else if Cmd = 'changepwd' then
    begin
      if assigned(Session) and Srv.Session.asBoolean['login'] then
        Result := DoChangePwd
      else
        Result := DoIndexPage;
    end
  else if Cmd = 'savepwd' then
    begin
      if assigned(Session) and Srv.Session.asBoolean['login'] then
        Result := DoSavePwd
      else
        Result := DoIndexPage;
    end
  else if Cmd = 'packages' then
    begin
      Result := DoPackagesSectionView;
    end
  else if Cmd = 'redir' then   //
    begin                      //  for DEBUG purpouse only !
      Result := DoRedir;       //  for DEBUG purpouse only !
    end                        //
  else if Cmd = 'home' then
    begin
      Result := DoIndexPage;
    end
  else if Cmd = 'forum' then
    begin
      Result := DoForum;
    end
  else if Cmd = 'viewsection' then
    begin
      Result := DoSectionView;
    end
  else if Cmd = 'newtopic' then
    begin
      Result := DoNewTopic;
    end
  else if Cmd = 'savetopic' then
    begin
      Result := DoSaveTopic;
    end
  else if Cmd = 'viewtopic' then
    begin
      Result := DoTopicView;
    end
  else if Cmd = 'delreply' then
    begin
      Result := DoDeleteReply;
    end
  else if Cmd = 'deltopic' then
    begin
      Result := DoDeleteTopic;
    end
  else if Cmd = 'setfilter' then
    begin
      Result := DoSetFilter;
    end
  else
    Result := DoIndexPage;
end;

function TCommandsDispatcher.DoAdminAccess(Cmd: AnsiString): AnsiString;
var
  fname : AnsiString;
  size : integer;
begin
  if Cmd = 'showusers' then
    Result := DoShowUsers

  else if Cmd = 'showsections' then
    Result := DoShowSections

  else if Cmd = 'edituser' then
    Result := DoEditUser

  else if Cmd = 'saveuser' then
    Result := DoSaveUser

  else if Cmd = 'deluser' then
    Result := DoDelUser

  else if Cmd = 'showsectionsaccess' then
    Result := DoShowSectionsAccess

  else if Cmd = 'editsectionsaccess' then
    Result := DoEditSectionsAccess

  else if Cmd = 'savesectionsaccess' then
    Result := DoSaveSectionsAccess

  else if Cmd = 'addsection' then
    Result := DoAddSection

  else if Cmd = 'editsection' then
    Result := DoEditSection

  else if Cmd = 'movesection' then
    Result := DoMoveSection

  else if Cmd = 'savesection' then
    Result := DoSaveSection

  else if Cmd = 'delsection' then
    Result := DoDelSection

//--- Packages -----------------------------------------------------
  else if Cmd = 'showpacks' then
    Result := DoShowPackages

  else if Cmd = 'showpacksaccess' then
    Result := DoShowPackAccess

  else if Cmd = 'editpacksaccess' then
    Result := DoEditPackAccess

  else if Cmd = 'savepacksaccess' then
    Result := DoSavePackAccess

  else if Cmd = 'addpack' then
    Result := DoAddPack

  else if Cmd = 'editpack' then
    Result := DoEditPack

  else if Cmd = 'savepack' then
    Result := DoSavePack

  else if Cmd = 'delpack' then
    Result := DoDelPack

  else if Cmd = 'packfiles' then
    Result := DoPackFiles

  else if Cmd = 'addfile' then
    Result := DoAddFile

  else if Cmd = 'editfile' then
    Result := DoEditFile

  else if Cmd = 'savefile' then
    begin
      if Srv.Request.Params['datafile']<>'' then
        begin // save new/updates file
          if not DirectoryExists(UploadPath) then
            CreateDir(UploadPath);

          fname := ExtractFileName(Srv.Request.Params['datafile']);
          Srv.Request.Info['fname'] := fname;
          if Srv.Request.Params.GetFile('datafile', UploadPath+'\' + fname) then begin
            size := File_Size(UploadPath+'\' + fname);
            if size = 0 then begin
              PageMessage := GetMsg('error_file_size');
              //Result := DoPackFiles;
              Relocation(Format('?cmd=packfiles&pack_id=%s&sid=%s', [GetRequestValue('pack_id'), SessionID]));
              Exit;
            end;
            Srv.Request.Info['size'] := IntToStr(size);
            Result := DoSaveFile;
          end;
        end
      else // save selected file
        begin
          Srv.Request.Info['fname'] := GetRequestValue('filename');
          Result := DoSaveFile;
        end;
    end

  else if Cmd = 'delfile' then
    Result := DoDelFile
//------------------------------------------------------------------
  else
    Result := DoCommonAccess(Cmd);
end;

function TCommandsDispatcher.DoAdmin : AnsiString;
var
  Page : TRtcParse;
begin
  Page := TRtcParse.Create(TemplatePath + 'admin.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoForum : AnsiString;
var
  Page : TRtcParseEx;
  TableRow : TRtcParseEx;
  S : AnsiString;
  I : integer;
  Section : PSectionRecord;
  login: AnsiString;
  SectionsList : TList;
  PreviousLogon : TDateTime;
begin
  Page := TRtcParseEx.Create(TemplatePath + 'index.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea(GetMsg('title_index'));

    Page['sid'] := SessionID;
    Page['packs_section_name'] := GetMsg('Download Area');
    Page['forum_page_header'] := GetMsg('Forum');

    login := GetSessionLogin;
    if assigned(Session) then
      PreviousLogon := Session.asDateTime['previous logon']
    else
      PreviousLogon := Now-1; // will mark all topics posted in the last 24 hours

    S := '';

    // Show Sections
    TableRow := TRtcParseEx.Create(TemplatePath + 'forum_area_row.htm');

    ForumData.Lock;
    try
      ForumData.LoadSections;
      ForumData.LoadRights;

      SectionsList := ForumData.Sections.GetOrderedList;
      try
        for I := 0 to SectionsList.Count - 1 do begin
          Section := SectionsList[I];

          if not IsSectionVisible(Section^.VisibilityLevel,
            ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID)) then
            Continue;

          TableRow.Clear;
          TableRow['section_id'] := IntToStr(Section^.ID);
          TableRow['section_name'] := Section^.Name;
          TableRow['posts_count'] := IntToStr(Section^.PostCount);
          TableRow['topics_count'] := IntToStr(Section^.TopicsCount);
          TableRow.Condition['topics_exists'] := (Section^.PostCount > 0);
          TableRow.Condition['new_posts'] := assigned(Session) and (PreviousLogon < Section^.LastPostTimeStamp);

          if Section^.PostCount > 0 then begin
            TableRow.Condition['last_topic_exist'] := not ((Section^.LastPostTopicID = 0) and
              (CompareText('deleted', Section^.LastPostTopicName)=0) );
            TableRow['last_post_timestamp'] := DateTimeToStr(Section^.LastPostTimeStamp);
            TableRow['last_post_topic_subject'] := Section^.LastPostTopicName;
            TableRow['last_post_topic_id'] := IntToStr(Section^.LastPostTopicID);
          end;

          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        SectionsList.Free;
      end;
    finally
      ForumData.Unlock;
      TableRow.Free;
    end;

    Page['forum_table_rows'] := S;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.GetRequestValue (name : AnsiString) : AnsiString;
begin
  if Srv.Request.Method='GET' then
    Result := URL_Decode(Srv.Request.Query[name])
  else
    Result := Srv.Request.Params[name];
end;

constructor TCommandsDispatcher.Create(aSrv: TRtcDataServer);
begin
  fSrv := aSrv;
end;

function TCommandsDispatcher.GetSession: TRtcServerSession;
begin
  Result := Srv.Session;
end;

function TCommandsDispatcher.GetTemplatePath: AnsiString;
begin
  Result := Forum_Templates_Path;
end;

procedure TCommandsDispatcher.ShowPageMessage(Page: TRtcParse);
begin
  if Trim(PageMessage) <> '' then
    begin
      Page['message_text'] := PageMessage;
      Page['message_visible'] := '1';
    end
  else
    begin
      Page['message_text'] := '';
      Page['message_visible'] := '';
    end;
  PageMessage := '';
end;

procedure TCommandsDispatcher.ShowPageMessage(Page: TRtcParseEx);
begin
  if Trim(PageMessage) <> '' then
    begin
      Page['message_text'] := PageMessage;
      Page['message_visible'] := '1';
    end
  else
    begin
      Page['message_text'] := '';
      Page['message_visible'] := '';
    end;
  PageMessage := '';
end;

procedure TCommandsDispatcher.Relocation(URL: AnsiString);
begin
  Srv.Response.Status(302,'Moved');
  Srv.Response['Location'] := URL;
  Srv.Write('Status 302: Moved');
end;

function TCommandsDispatcher.HeaderArea(DocumentTitle : AnsiString = '') : AnsiString;
var
  Page : TRtcParseEx;
  fname : AnsiString;
  login : AnsiString;
  username : AnsiString;
  filter : AnsiString;
  sid : AnsiString;
begin
  if Assigned(Session) and Session.asBoolean['login'] then
    begin
      login := Session.asString['user_name'];
      filter := Session.asString['forum_filter'];
      fname := TemplatePath + 'logged.htm';
      GetUserInfo(login, username);
      sid := SessionID;
    end
  else
    begin
      login := LOGIN_GUEST;
      filter := '';
      fname := TemplatePath + 'notlogged.htm';
      username := 'Guest';
    end;

  Page := TRtcParseEx.Create(fname);
  try
    Page.Silent := True;
    Page['user_name'] := username;
    Page['now_datetime'] := DateTimeToStr(Now);
    Page['logged_ip_address'] := Srv.PeerAddr;
    Page['sid'] := sid;
    Page['title_of_document'] := DocumentTitle;
    Page['filter_text'] := filter;
    if Assigned(Session) and (CompareText(login, LOGIN_ADMIN)<>0) then
      Page.Condition['show_forum_filter'] := true;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.FindSession: boolean;
begin
  Result :=
  Srv.FindSession(GetRequestValue('sid'))
  {$IFDEF USE_COOKIE_SESSIONID}
  or Srv.FindSession(Srv.Request.Cookie['session'])
  {$ENDIF}
  ;
end;

function TCommandsDispatcher.DoAddFile: AnsiString;
var
  Page : TRtcParseEx;
  pack_id : AnsiString;
  packname, order_link, extend_lic_link : AnsiString;
  S : AnsiString;
  Files, PackFiles, SL : TStringList;
  I : integer;
  file_id : AnsiString;
begin
  Result := '';
  Page := TRtcParseEx.Create(TemplatePath + 'editfile.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;

    pack_id := GetRequestValue('pack_id');
    if not GetPackInfo(pack_id, packname, order_link, extend_lic_link) then
      Exit;

    Page['pack_id'] := pack_id;
    Page['package_name'] := packname;

    Page['new_checked'] := CHECKED;
    Page.Condition['select'] := False;
    Page['none_selected'] := SELECTED;

    S := '';
    Files := TStringList.Create;
    PackFiles := TStringList.Create;
    SL := TStringList.Create;
    try
      GetFilesAll(Files);
      GetFilesTiny(pack_id, PackFiles);
      for I := 0 to Files.Count - 1 do begin
        file_id := Files.Names[I];
        if PackFiles.IndexOfName(file_id) < 0 then begin
          SL.CommaText := _GetValueFromIndex(Files,I);
          S := S + Format(
            '<option value="%s">%s  (%s)</option>'#13#10, [
            file_id, SL.Values['desc'], SL.Values['fname']
          ]);
        end;
      end;
    finally
      SL.Free;
      PackFiles.Free;
      Files.Free;
    end;
    Page['options_files'] := S;

    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoAddPack: AnsiString;
var
  Page : TRtcParse;
begin
  Page := TRtcParse.Create(TemplatePath + 'editpack.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    Page['caption'] := 'Add package';

    if DEFAULT_PACK_VISIBILITY_LEVEL = 'public' then
      Page['public_selected'] := SELECTED
    else
      Page['private_selected'] := SELECTED;

    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoDelFile: AnsiString;
var
  pack_id, file_id : AnsiString;
  fname, description, filedatetime, size : AnsiString;
begin
  pack_id := GetRequestValue('pack_id');
  file_id := GetRequestValue('file_id');
  if GetFileInfo(pack_id, file_id, fname, description, filedatetime, size) then begin
    if DelFile(pack_id, file_id) then
      Delete_File(fname);
  end;

  //Result := DoPackFiles;
  Relocation(Format('?cmd=packfiles&pack_id=%s&sid=%s', [pack_id, SessionID]));
end;

function TCommandsDispatcher.DoDelPack: AnsiString;
begin
  if not DeletePack(GetRequestValue('pack_id')) then
    PageMessage := GetMsg('error_del_pack');

  //Result := DoShowPackages;
  Relocation(Format('?cmd=showpacks&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoEditFile: AnsiString;
var
  Page : TRtcParseEx;
  pack_id : AnsiString;
  packname, order_link, extend_lic_link : AnsiString;
  fname, description, filedatetime, size : AnsiString;
  S : AnsiString;
  Files, PackFiles, SL : TStringList;
  I : integer;
  file_id, f_id : AnsiString;
  sel : AnsiString;
begin
  Result := '';
  Page := TRtcParseEx.Create(TemplatePath + 'editfile.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;

    pack_id := GetRequestValue('pack_id');
    if not GetPackInfo(pack_id, packname, order_link, extend_lic_link) then
      Exit;

    file_id := GetRequestValue('file_id');
    if not GetFileInfo(pack_id, file_id, fname, description, filedatetime, size) then
      Exit;

    Page['pack_id'] := pack_id;
    Page['file_id'] := file_id;
    Page['package_name'] := packname;

    Page['select_checked'] := CHECKED;
    Page.Condition['select'] := True;

    S := '';
    Files := TStringList.Create;
    PackFiles := TStringList.Create;
    SL := TStringList.Create;
    try
      GetFilesAll(Files);
      GetFilesTiny(pack_id, PackFiles);

      for I := 0 to Files.Count - 1 do begin
        f_id := Files.Names[I];
        if (f_id = file_id) or (PackFiles.IndexOfName(f_id) < 0) then begin
          SL.CommaText := _GetValueFromIndex(Files,I);

          if f_id = file_id then
            begin
              sel := SELECTED;
              Page['name'] := SL.Values['desc'];
            end
          else
            sel := '';

          S := S + Format(
            '<option %s value="%s">%s  (%s)</option>'#13#10, [
            sel, f_id, SL.Values['desc'], SL.Values['fname']
          ]);
        end;
      end;

    finally
      SL.Free;
      PackFiles.Free;
      Files.Free;
    end;
    Page['options_files'] := S;

    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoEditPack: AnsiString;
var
  Page : TRtcParse;
  pack_id, packname, order_link, extend_lic_link : AnsiString;
begin
  Page := TRtcParse.Create(TemplatePath + 'editpack.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    pack_id := GetRequestValue('pack_id');
    GetPackInfo(pack_id, packname, order_link, extend_lic_link);
    Page['caption'] := 'Edit package';
    Page['pack_id'] := pack_id;
    Page['name'] := packname;
    
    if GetPackVisibility(pack_id) = 'public' then
      Page['public_selected'] := SELECTED
    else
      Page['private_selected'] := SELECTED;

    Page['order_link'] := order_link;
    Page['extend_lic_link'] := extend_lic_link;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoEditPackAccess: AnsiString;
var
  Page : TRtcParse;
  expiredate : AnsiString;
  grant : boolean;
  login, pack_id: AnsiString;
  packname, order_link, extend_lic_link : AnsiString;
begin
  login := GetRequestValue('user');
  pack_id := GetRequestValue('pack_id');
  GetPackInfo(pack_id, packname, order_link, extend_lic_link);


  Page := TRtcParse.Create(TemplatePath + 'editpackaccess.htm');
  try
    Page['header_area'] := HeaderArea;
    grant := GetGrant(login, pack_id, expiredate);
    if grant then
      Page['grant_checked'] := 'checked';

    Page['expiredate'] := expiredate;

    Page['pack_id'] := pack_id;
    Page['package_name'] := packname;
    Page['user'] := login;
    Page['user_login_enc'] := URL_Encode(login);
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoPackFiles: AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  Files : TStringList;
  SL : TStringList;
  I : integer;
  pack_id : AnsiString;
  packname, order_link, extend_lic_link : AnsiString;
begin
  Result := '';
  Page := TRtcParse.Create(TemplatePath + 'packfiles.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    pack_id := GetRequestValue('pack_id');
    if not GetPackInfo(pack_id, packname, order_link, extend_lic_link) then
      Exit;

    Page['pack_id'] := pack_id;
    Page['package_name'] := packname;

    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'files_table_row.htm');
    try
      Files := TStringList.Create;
      SL := TStringList.Create;
      try
        GetFiles(pack_id, Files);
        for I := 0 to Files.Count - 1 do begin
          SL.CommaText := _GetValueFromIndex(Files,I);
          TableRow.Clear;
          TableRow['pack_id'] := pack_id;
          TableRow['file_id'] := Files.Names[I];
          TableRow['file_name'] := SL.Values['fname'];
          if SL.Values['desc'] <> '' then
            TableRow['file_description'] := SL.Values['desc']
          else
            TableRow['file_description'] := '&nbsp;';
          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        SL.Free;
        Files.Free;
      end;
    finally
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoSaveFile: AnsiString;
var
  pack_id, file_id, datetime : AnsiString;
  fname, description, size: AnsiString;
  bind_file : boolean;
  selected_file_id : AnsiString;
begin
  Result := '';
  pack_id := GetRequestValue('pack_id');
  file_id := GetRequestValue('file_id');
  fname := Srv.Request.Info.asString['fname'];
  description := Trim(GetRequestValue('description'));
  if description = '' then
    description := fname;
  bind_file := CompareText(GetRequestValue('fileaction'), 'select')=0;
  selected_file_id := GetRequestValue('selectedfile');

  if bind_file then
    begin  // select file
      if selected_file_id = file_id then
        SaveFileDesc(file_id, description)    // change description of the file
      else
        BindFile(pack_id, selected_file_id);     // bind file to the package
    end
  else
    begin  // new file
      datetime := DateTime2Str(Now);
      datetime := Copy(datetime, 1, Pos('.', datetime)-1);
      size := Srv.Request.Info.asString['size'];
      file_id := '';
      AddFile(pack_id, fname, description, size, datetime, file_id)
    end;

  //Result := DoPackFiles;
  Relocation(Format('?cmd=packfiles&pack_id=%s&sid=%s', [pack_id, SessionID]));
end;

function TCommandsDispatcher.DoSavePack: AnsiString;
var
  pack_id : AnsiString;
  packname, order_link, extend_lic_link: AnsiString;
  vis_level : AnsiString;
begin
  pack_id := GetRequestValue('pack_id');
  packname := GetRequestValue('name');
  order_link := GetRequestValue('order_link');
  extend_lic_link := GetRequestValue('extend_lic_link');
  vis_level := GetRequestValue('vis_level');

  if pack_id = '' then
    begin
      if IsPackExists(packname) then
        PageMessage := Format(GetMsg('error_pack_exists'), [packname])
      else
        begin
          AddPack(packname, order_link, extend_lic_link, pack_id);
          SetPackVisibility(pack_id, vis_level)
        end;
    end
  else
    begin
      SavePackInfo(pack_id, packname, order_link, extend_lic_link);
      SetPackVisibility(pack_id, vis_level)
    end;

  //Result := DoShowPackages;
  Relocation(Format('?cmd=showpacks&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.DoSavePackAccess: AnsiString;
var
  login, pack_id, grant, expiredate: AnsiString;
begin
  login := GetRequestValue('user');
  pack_id := GetRequestValue('pack_id');
  grant := GetRequestValue('grant');
  expiredate := Trim(GetRequestValue('expiredate'));
  if expiredate <> '' then
    try
      Str2DateTime(expiredate);
    except
      PageMessage := GetMsg('error_bad_date');
      expiredate := '';
    end;
  SaveUserAccess(login, pack_id, grant = 'on', expiredate);

  //Result := DoShowPackAccess;
  Relocation(Format('?cmd=showpacksaccess&user=%s&sid=%s', [login,SessionID]));
end;

function TCommandsDispatcher.DoShowPackAccess: AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  Packs : TStringList;
  I : integer;
  grant : boolean;
  expiredate : AnsiString;
  pack_id : AnsiString;
  login: AnsiString;
begin
  Page := TRtcParse.Create(TemplatePath + 'packaccess.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    login := GetRequestValue('user');
    Page['user'] := login;
    Page['user_login_enc'] := URL_Encode(login);

    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'pack_access_table_row.htm');
    try
      Packs := TStringList.Create;
      try
        GetPacks(Packs);
        for I := 0 to Packs.Count - 1 do begin
          pack_id := Packs.Names[I];
          TableRow.Clear;
          TableRow['user'] := login;
          TableRow['pack_id'] := pack_id;
          TableRow['package_name'] := _GetValueFromIndex(Packs,I);

          grant := GetGrant(login, pack_id, expiredate);

          if grant then
            TableRow['grant_checked'] := 'checked'
          else
            TableRow['grant_checked'] := '';

          TableRow['expiredate'] := expiredate;
          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        Packs.Free;
      end;
    finally
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoShowPackages: AnsiString;
var
  Page : TRtcParse;
  TableRow : TRtcParse;
  S : AnsiString;
  Packs, Files : TStringList;
  I : integer;
  pack_id : AnsiString;
begin
  Page := TRtcParse.Create(TemplatePath + 'packages.htm');
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;
    S := '';
    TableRow := TRtcParse.Create(TemplatePath + 'packages_table_row.htm');
    try
      Packs := TStringList.Create;
      Files := TStringList.Create;
      try
        GetPacks(Packs);
        for I := 0 to Packs.Count - 1 do begin
          pack_id := Packs.Names[I];
          GetFiles(pack_id, Files);
          TableRow.Clear;
          TableRow['pack_id'] := pack_id;
          TableRow['package_name'] := _GetValueFromIndex(Packs,I);
          TableRow['vis_level'] := GetPackVisibility(pack_id);
          TableRow['files_count'] := IntToStr(Files.Count);
          TableRow['sid'] := SessionID;
          S := S + TableRow.Output;
        end;
      finally
        Files.Free;
        Packs.Free;
      end;
    finally
      TableRow.Free;
    end;

    Page['table_rows'] := S;
    Page['sid'] := SessionID;
    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.GetUploadPath: AnsiString;
begin
  Result := Forum_Upload_Path;
end;

function TCommandsDispatcher.DoPackagesSectionView: AnsiString;
var
  login : AnsiString;
  Page, Row : TRtcParseEx;
  Packs : TStrings;
  I : integer;
  S : AnsiString;
  grant : boolean;
  s_expiredate : AnsiString;
  d_expiredate : TDateTime;
  expired : boolean;

  RowOneFile : TRtcParse;

  pack_id : AnsiString;
  packname, order_link, extend_lic_link : AnsiString;

  function FineSize(Size : AnsiString) : AnsiString;
  var
    N : cardinal;
    suff : AnsiString;
    devisor : cardinal;
    R : Double;
  begin
    suff := '';
    N := StrToIntDef(Size, 0);
    if N < 1024 then
      begin
        suff := 'b';
        devisor := 1;
      end
    else if N < 1048576 then
      begin
        suff := 'Kb';
        devisor := 1024;
      end
    else if N < 1073741824 then
      begin
        suff := 'Mb';
        devisor := 1048576;
      end
    else
      begin
        suff := 'Gb';
        devisor := 1073741824;
      end;

    if devisor > 1 then
      begin
        R := N / devisor;
        Result := Format('%-.2f %s', [R, suff]);
      end
    else
      Result := Format('%d %s', [N, suff]);
  end;

  procedure InitRows;
  begin
    Row := TRtcParseEx.Create(TemplatePath + 'packages_view_row.htm');
    RowOneFile := TRtcParse.Create(TemplatePath + 'user_pack_files_row.htm');
  end;

  procedure DoneRows;
  begin
    if Assigned(RowOneFile) then
      begin
      RowOneFile.Free;
      RowOneFile:=nil;
      end;
    if Assigned(Row) then
      begin
      Row.Free;
      Row:=nil;
      end;
  end;

  procedure PackFiles (pack_id, name, expiredate : AnsiString);
  var
    Files : TStringList;
    I : integer;
    description : AnsiString;
    filedatetime : AnsiString;
    size : AnsiString;
    s_out : AnsiString;
    fname : AnsiString;
    SL : TStringList;
    file_id : AnsiString;
  begin
    Row['pack_id'] := pack_id;
    Row['pack_name'] := name;

    if Trim(expiredate) <> '' then
      Row['expire_date'] := expiredate
    else
      Row['expire_date'] := 'n/a';

    s_out := '';

    Files := TStringList.Create;
    SL := TStringList.Create;
    try
      GetFiles(pack_id, Files);
      Row['files_count'] := IntToStr(Files.Count);
      for I := 0 to Files.Count - 1 do begin
        file_id := Files.Names[I];
        GetFileInfo(pack_id, file_id, fname, description, filedatetime, size);
        RowOneFile.Clear;
        RowOneFile['file_link'] := URL_Encode(ExtractFileName(fname));
        RowOneFile['file_description'] := description;
        RowOneFile['file_datetime'] := filedatetime;
        RowOneFile['file_size'] := FineSize(size);
        RowOneFile['sid'] := SessionID;
        s_out := s_out + RowOneFile.Output;
      end;
    finally
      SL.Free;
      Files.Free;
    end;

    Row['table_rows'] := s_out;
  end;

  procedure PackExpired (name, extend_lic_link : AnsiString);
  begin
    Row['pack_name'] := name;
    Row['extend_lic_link'] := extend_lic_link;
  end;

  procedure PackBuy (name, order_link : AnsiString);
  begin
    Row['pack_name'] := name;
    Row['order_link'] := order_link;
  end;

begin
  login := GetSessionLogin;

  Page := TRtcParseEx.Create(TemplatePath + 'packages_view.htm');  //user_packs.htm
  try
    ShowPageMessage(Page);
    Page['header_area'] := HeaderArea;

    Page['sid'] := SessionID;
    Page['packs_section_name'] := GetMsg('Download Area');
    Page['forum_page_header'] := GetMsg('Forum');

    Packs := TStringList.Create;
    GetPacks(Packs);

    S := '';

    if Packs.Count > 0 then
      begin
        InitRows;
        try
          for I := 0 to Packs.Count - 1 do begin
            pack_id := Packs.Names[I];
            if not assigned(Session) and (CompareText(GetPackVisibility(pack_id),'private')=0) then
              Continue;

            Row.Clear;
            Row['sid'] := SessionID;

            grant := GetGrant(login, pack_id, s_expiredate);
            Row.Condition['grant'] := grant;

            GetPackInfo(pack_id, packname, order_link, extend_lic_link);
            if grant then
              begin
                if Trim(s_expiredate) <> '' then
                  d_expiredate := Str2DateTime(s_expiredate)
                else
                  d_expiredate := Now;

                expired := Trunc(d_expiredate) < Trunc(Now);
                Row.Condition['expired'] := expired;

                if expired then
                  PackExpired(packname, extend_lic_link)
                else
                  PackFiles(pack_id, packname, s_expiredate);
              end
            else
              PackBuy(packname, order_link);

            S := S + Row.Output;

          end;
        finally
          DoneRows;
        end;

        Page['table_rows'] := S;

      end
    else
      begin
       // TODO: show 'no packages' message
      end;
    Packs.Free;

    Result := Page.Output;
  finally
    Page.Free;
  end;
end;

function TCommandsDispatcher.DoRedir: AnsiString;
var
  URL : AnsiString;
begin
  URL := GetRequestValue('url');
  Relocation(URL);
end;

function TCommandsDispatcher.GetSessionLogin: AnsiString;
begin
  if assigned(Session) then
    Result := Session.asString['user_name']
  else
    Result:=LOGIN_GUEST;
end;

function TCommandsDispatcher.DoSectionView: AnsiString;
var
  Page : TRtcParseEx;
  TableRow : TRtcParseEx;
  section_id : AnsiString;
  Section : PSectionRecord;
  login : AnsiString;
  UserAL : TUserAccessLevel;
  I : integer;
  S : AnsiString;
  ed_topic_id : integer;
  TopicsList : TList;
  PreviousLogon : TDateTime;
  filter : AnsiString;
begin
  //http://localhost:8080/?cmd=viewsection&section_id=4&sid=93C0D0AC68224F2E860E8FBD1092EA69

  ForumData.Lock;
  try
    ForumData.LoadSections;
    ForumData.LoadRights;

    login := GetSessionLogin;
    section_id := GetRequestValue('section_id');

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);

    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    if assigned(Session) then
      begin
      PreviousLogon := Session.asDateTime['previous logon'];
      filter := LowerCase(Session.asString['forum_filter']);
      end
    else
      begin
      PreviousLogon := Now;
      filter := '';
      end;

    ForumData.LoadTopics(Section^.ID);

    Page := TRtcParseEx.Create(TemplatePath + 'topics.htm');
    try
      ShowPageMessage(Page);
      Page['header_area'] := HeaderArea(GetMsg('title_viewsection'));

      Page['forum_page_header'] := GetMsg('Forum');
      Page['sid'] := SessionID;

      Page['section_id'] := section_id;
      Page['section_name'] := Section^.Name;

      Page.Condition['write_access'] := IsSectionWritable(Section^.AccessLevel, UserAL);
      Page.Condition['moderator_access'] := IsSectionModeratable(Section^.AccessLevel, UserAL);

      Page['topics_count'] := IntToStr(Section^.TopicsCount);
      Page['posts_count'] := IntToStr(Section^.PostCount);

      ed_topic_id := StrToIntDef(GetRequestValue('ed_topic_id'), -1);

      S := '';
      TableRow := TRtcParseEx.Create(TemplatePath + 'topics_row.htm');
      try
        TopicsList := ForumData.Topics.GetOrderedList;
        for I := 0 to TopicsList.Count - 1 do
          with PTopicRecord(TopicsList[I])^ do begin
            //if not Deleted then begin
              if (filter <> '') and (Pos(filter, LowerCase(Name)) = 0) then
                Continue;
              TableRow.Clear;
              TableRow['section_id'] := section_id;
              TableRow['topic_id'] := IntToStr(ID);
              TableRow['topic_subject'] := Name;
              TableRow['topic_user_creator'] := CreatorUser;
              TableRow['topic_replies_cnt'] := IntToStr(RepliesCount);
              TableRow['topic_last_post_timestamp'] := DateTimeToStr(LastPostTimeStamp);
              TableRow['topic_last_post_user'] := LastPostUser;
              TableRow['sid'] := SessionID;
              TableRow.Condition['moderator_access'] := IsSectionModeratable(Section^.AccessLevel, UserAL);
              TableRow.Condition['view'] := not (ed_topic_id = ID);
              TableRow.Condition['new_posts'] := assigned(Session) and not (ed_topic_id = ID) and (PreviousLogon < LastPostTimeStamp);
              TableRow['reply_id'] := IntToStr(First_Reply_ID);
              S := S + TableRow.Output;
            //end; //if not Deleted
          end;
      finally
        TableRow.Free;
      end;

      Page['table_row'] := S;

      Result := Page.Output;
    finally
      Page.Free;
    end;
  finally
    ForumData.Unlock;
    end;
end;

function TCommandsDispatcher.DoNewTopic: AnsiString;
var
  Page, PagePreview : TRtcParseEx;
  section_id : AnsiString;
  Section : PSectionRecord;
  login : AnsiString;
  UserAL : TUserAccessLevel;
  preview : boolean;
  preview_text : AnsiString;
begin
  // http://localhost:8080/?cmd=newtopic&section_id=9&sid=19D13E35CE234D0DB15A5F13288F6EBE

  ForumData.Lock;
  try
    login := GetSessionLogin;
    section_id := GetRequestValue('section_id');

    ForumData.LoadSections;
    ForumData.LoadRights;

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);
    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) or
      not IsSectionWritable(Section^.AccessLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    Page := TRtcParseEx.Create(TemplatePath + 'new_topic.htm');
    try
      ShowPageMessage(Page);
      Page['header_area'] := HeaderArea(GetMsg('title_newtopic'));

      Page['forum_page_header'] := GetMsg('Forum');
      Page['sid'] := SessionID;

      Page['section_id'] := section_id;
      Page['section_name'] := Section^.Name;

      Page.Condition['guest_access'] := not assigned(Session);
      Page.Condition['new_topic'] := True;
      Page.Condition['alone'] := True;
      Page.Condition['formvisible'] := True;

      preview_text := GetRequestValue('reply_text');
      preview := preview_text <> '';
      if preview then begin
        Page['topic_subject'] := GetRequestValue('topic_subject');
        Page['reply_text'] := preview_text;
        if not assigned(Session) then
          Page['user_name'] := GetRequestValue('user_name');

        PagePreview := TRtcParseEx.Create(TemplatePath + 'replies_row.htm');
        try
          if not assigned(Session) then
            begin
              PagePreview['user_name'] := Copy(GetRequestValue('user_name'), 1, SizeOf(TUserName));
              PagePreview['user_type'] := Format(GetMsg('guest_details'), [Srv.PeerAddr]);
            end
          else
            begin
              PagePreview['user_name'] := Copy(GetUserName(login), 1, SizeOf(TUserName));
              PagePreview['user_type'] := GetMsg('user_details');
            end;
          PagePreview['post_timestamp'] := DateTimeToStr(Now);
          PagePreview['reply_text'] := BBCode2HTML(HTMLEncode( preview_text ));
          PagePreview.Condition['view'] := True;
          PagePreview.Condition['moderator_access'] := False;
          PagePreview.Condition['preview'] := true;

          Page['table_row'] := PagePreview.Output;
        finally
          PagePreview.Free;
        end;

        Page['reply_text'] := preview_text;
        Page.Condition['preview'] := true;
      end;

      Result := Page.Output;
    finally
      Page.Free;
    end;
  finally
    ForumData.Unlock;
    end;
end;

function TCommandsDispatcher.DoSaveTopic: AnsiString;
var
  login : AnsiString;
  section_id : AnsiString;
  topic_id : AnsiString;
  reply_id : AnsiString;
  Topic : PTopicRecord;
  Section : PSectionRecord;
  UserAL : TUserAccessLevel;
  Reply : PReplyRecord;
  tmpReply : TReplyRecord;
  msg : AnsiString;
  topic_subject : AnsiString;
  new_topic : boolean;
  new_reply : boolean;
  edit_topic : boolean;
begin
  section_id := GetRequestValue('section_id');
  topic_id := GetRequestValue('topic_id');
  reply_id := GetRequestValue('reply_id');
  login := GetSessionLogin;

  edit_topic := False;

  ForumData.Lock;
  try
    ForumData.LoadSections;
    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    ForumData.LoadRights;
    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);
    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) or
      not IsSectionWritable(Section^.AccessLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    msg := Trim(GetRequestValue('reply_text'));
    topic_subject := GetRequestValue('topic_subject');

    ForumData.LoadTopics(Section^.ID);
    if topic_id = '' then
      begin
      Topic:=nil;
      new_topic := True;
      end
    else
      begin
      Topic := ForumData.Topics.ItemsByID[StrToIntDef(topic_id, 0)];
      if not Assigned(Topic) then
        new_topic := True
      else
        begin
        new_topic := False;
        ForumData.LoadReplies(Section^.ID, Topic^.ID);
        end;
      end;

    //create topic text in "topic.replies.data" file

    if new_topic or (reply_id = '') then
      begin
      Reply:=nil;
      new_reply := True;
      end
    else
      begin
      Reply := ForumData.Replies.ItemsByID[StrToIntDef(reply_id, 0)];

      if not Assigned(Reply) then
        new_reply := True
      else
        begin
        new_reply := False;
        if msg<>'' then
          begin
          tmpReply := Reply^;
          Reply^.ID := -1 * Reply^.ID;
          ForumData.Replies.Delete(Reply);

          Reply := ForumData.Replies.New(msg);
          with Reply^ do
            begin
            ID := tmpReply.ID;
            ID_Topic := tmpReply.ID_Topic;
            User := tmpReply.User;
            UserType := tmpReply.UserType;
            UserIP := tmpReply.UserIP;
            TimeStamp := tmpReply.TimeStamp;
            end;
          end;
        end;
      end;

    if new_topic then begin
      Topic := ForumData.Topics.New;

      with Topic^ do begin
        if CompareText(login, LOGIN_GUEST)=0 then
          begin
            CreatorUser := Copy(GetRequestValue('user_name'), 1, Sizeof(TUserName));
            CreatorUserType := utGuest;
          end
        else
          begin
            CreatorUser := Copy(GetUserName(login), 1, Sizeof(TUserName));
            CreatorUserType := utRegistered;
          end;
      end;

      ForumData.LoadReplies(Section^.ID, Topic^.ID);

      with Section^ do begin
        Inc(TopicsCount);
      end;
    end;

    if (topic_subject <> '') and (topic_subject <> Topic^.Name) then begin
      Topic^.Name := topic_subject;
      edit_topic := True;
    end;

    if new_reply then
      begin
      Reply := ForumData.Replies.New(msg);

      with Topic^ do begin
        Inc(RepliesCount);
        LastPostTimeStamp := Now;
        if CompareText(login, LOGIN_GUEST)=0 then
          begin
            LastPostUser := Copy(GetRequestValue('user_name'), 1, SizeOf(TUserName));
            LastPostUserType := utGuest;
          end
        else
          begin
            LastPostUser := Copy(GetUserName(login), 1, SizeOf(TUserName));
            LastPostUserType := utRegistered;
          end;
      end;

      with Section^ do begin
        Inc(PostCount);
        LastPostTimeStamp := Now;
        LastPostTopicID := Topic^.Id;
        LastPostTopicName := Topic^.Name;
        LastPostUserName := Topic^.LastPostUser;
        LastPostUserType := Topic^.LastPostUserType;
      end;

      with Reply^ do
        begin
        ID_Topic := Topic^.ID;
        if CompareText(login, LOGIN_GUEST)=0 then
          begin
          User := Copy(GetRequestValue('user_name'), 1, SizeOf(TUserName));
          UserType := utGuest;
          end
        else
          begin
          User := Copy(GetUserName(login), 1, SizeOf(TUserName));
          UserType := utRegistered;
          end;
        TimeStamp := Now;
        UserIP := Srv.PeerAddr;
        end;
      end;

    if new_topic and new_reply then
      Topic^.First_Reply_ID := Reply^.ID;

  finally
    ForumData.Unlock;
    end;

  //Result := DoSectionView;
  if new_topic or edit_topic then
    Relocation(Format('?cmd=viewsection&section_id=%s&sid=%s', [section_id, SessionID]))
  else
    Relocation(Format('?cmd=viewtopic&section_id=%s&topic_id=%s&sid=%s', [section_id, topic_id, SessionID]))
end;

function TCommandsDispatcher.DoTopicView: AnsiString;
var
  Page : TRtcParseEx;
  TableRow : TRtcParseEx;
  section_id : AnsiString;
  topic_id : AnsiString;
  tID : integer;
  Section : PSectionRecord;
  Topic : PTopicRecord;
  login : AnsiString;
  UserAL : TUserAccessLevel;
  I : integer;
  S : AnsiString;
  Reply : PReplyRecord;
  PreviewReply : TReplyRecord;
  ed_reply_id : integer;
  RepliesList : TList;
  is_view : boolean;
  nn : integer;
  preview : boolean;
  preview_text : AnsiString;
begin
  // http://localhost:8080/?cmd=viewtopic&section_id=1&topic_id=1&sid=B1CDA2069C9F4F838420FC52F3B54F28

  ForumData.Lock;
  try
    login := GetSessionLogin;
    section_id := GetRequestValue('section_id');

    ForumData.LoadSections;

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    ForumData.LoadRights;

    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);

    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    ForumData.LoadTopics(Section^.ID);

    Page := TRtcParseEx.Create(TemplatePath + 'replies.htm');
    try
      ShowPageMessage(Page);
      Page['header_area'] := HeaderArea(GetMsg('title_viewtopic'));

      Page['forum_page_header'] := GetMsg('Forum');
      Page['sid'] := SessionID;

      Page.Condition['guest_access'] := not assigned(Session);

      topic_id := GetRequestValue('topic_id');
      tID := StrToIntDef(topic_id, 0);

      Page['section_id'] := section_id;
      Page['topic_id'] := topic_id;
      Page['section_name'] := Section^.Name;

      Page.Condition['write_access'] := IsSectionWritable(Section^.AccessLevel, UserAL);
      Page.Condition['new_topic'] := False;
      Page.Condition['moderator_access'] := IsSectionModeratable(Section^.AccessLevel, UserAL);

      preview := GetRequestValue('reply_text') <> '';
      Page.Condition['formvisible'] := preview;
      if preview then begin
        preview_text := GetRequestValue('reply_text');
        Page['reply_text'] := preview_text;
        if not assigned(Session) then
          Page['user_name'] := GetRequestValue('user_name');

        with PreviewReply do begin
          ID := -1;
          ID_Topic := tID;
          TextLength := -1;
          if not assigned(Session) then
            begin
              User := Copy(GetRequestValue('user_name'), 1, SizeOf(TUserName));
              UserType := utGuest;
              UserIP := Srv.PeerAddr;
            end
          else
            begin
              User := Copy(GetUserName(login), 1, SizeOf(TUserName));
              UserType := utRegistered;
            end;
          TimeStamp := Now;
        end;
      end;

      Topic := ForumData.Topics.ItemsByID[tID];
      if Assigned(Topic) then
        begin
        Page['replies_count'] := IntToStr(Topic^.RepliesCount);
        Page['topic_subject'] := Topic^.Name;

        ed_reply_id := StrToIntDef(GetRequestValue('ed_reply_id'), -1);

        S := '';
        {}
        TableRow := TRtcParseEx.Create(TemplatePath + 'replies_row.htm');
        try

          ForumData.LoadReplies(Section^.ID, Topic^.ID);

          RepliesList := ForumData.Replies.GetOrderedList;
          try
            if preview then
              RepliesList.Add(@PreviewReply);

            nn := 0;
            for I := 0 to RepliesList.Count - 1 do begin
              Reply := RepliesList[I];

              TableRow.Clear;
              nn := nn + 1;
              TableRow.Condition['odd_row'] := Boolean(nn mod 2);
              TableRow['user_name'] := Reply^.User;
              if Reply^.UserType = utRegistered then
                begin
                  TableRow['user_type'] := GetMsg('user_details');
                end
              else
                begin
                  TableRow['user_type'] := Format(GetMsg('guest_details'), [Reply^.UserIP]);
                end;

              is_view := (ed_reply_id < 0) or not (ed_reply_id = Reply^.ID);

              TableRow['post_timestamp'] := DateTimeToStr(Reply^.TimeStamp);

              if is_view then
                begin
                  if preview and (Reply^.TextLength = -1) then
                    begin
                      TableRow['reply_text'] := BBCode2HTML(HTMLEncode( preview_text ));
                      TableRow.Condition['preview'] := true;
                    end
                  else
                    TableRow['reply_text'] := BBCode2HTML(HTMLEncode(AnsiString(ForumData.Replies.Messages[Reply])))
                end
              else
                TableRow['reply_text'] := AnsiString(ForumData.Replies.Messages[Reply]);

              TableRow['section_id'] := section_id;
              TableRow['topic_id'] := topic_id;
              TableRow['reply_id'] := IntToStr(Reply^.ID);
              TableRow['sid'] := SessionID;
              TableRow.Condition['view'] := is_view;

              TableRow.Condition['moderator_access'] := IsSectionModeratable(Section^.AccessLevel, UserAL);
              TableRow.Condition['moderator_delete'] := not (Topic^.First_Reply_ID = Reply^.ID);

              S := S + TableRow.Output;
            end;
          finally
            RepliesList.Free;
          end
        finally
          TableRow.Free;
          end;
        end // if assigned(Topic)
      else
        begin
          Result:=RelocationOnError('error_object_not_exists');
          Exit;
        end;
      Page['table_row'] := S;

      Result := Page.Output;
    finally
      Page.Free;
    end;
  finally
    ForumData.Unlock;
    end;
end;

function TCommandsDispatcher.DoDeleteTopic: AnsiString;
var
  section_id : AnsiString;
  Section : PSectionRecord;
  Topic : PTopicRecord;
  login : AnsiString;
  UserAL : TUserAccessLevel;
  tID : integer;
begin
  //http://localhost:8080/?cmd=deltopic&section_id=13&topic_id=1&sid=80DD6BFA425446BAAE9C63D482557F58

  login := GetSessionLogin;
  section_id := GetRequestValue('section_id');

  ForumData.Lock;
  try
    ForumData.LoadSections;

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    ForumData.LoadRights;
    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);

    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) or
      not IsSectionWritable(Section^.AccessLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    ForumData.LoadTopics(Section^.ID);

    tID := StrToIntDef(GetRequestValue('topic_id'), 0);
    Topic := ForumData.Topics.ItemsByID[tID];
    if Assigned(Topic) then
      begin
      Section^.TopicsCount := Section^.TopicsCount - 1;
      Section^.PostCount := Section^.PostCount - Topic^.RepliesCount;
      if Section^.LastPostTopicID = tID then begin
        Section^.LastPostTopicID := 0;
        Section^.LastPostTopicName := 'deleted';
      end;
      ForumData.Topics.Delete(Topic);

      ForumData.DeleteTopic(Section^.ID, tID);
      if Section^.TopicsCount<=0 then
        ForumData.ClearSection(Section^.ID);
      end;

  finally
    ForumData.Unlock;
    end;

  //Result := DoSectionView;
  Relocation(Format('?cmd=viewsection&section_id=%s&sid=%s', [section_id, SessionID]));
end;

function TCommandsDispatcher.DoDeleteReply: AnsiString;
var
  section_id : AnsiString;
  topic_id : AnsiString;
  Section : PSectionRecord;
  Topic : PTopicRecord;
  login : AnsiString;
  UserAL : TUserAccessLevel;
  Reply : PReplyRecord;
  tID : integer;
begin
  //http://localhost:8080/?cmd=delreply&section_id=1&topic_id=1&reply_id=3&sid=F16BF790F37D4CBDA0DBEFB6175972E4
  login := GetSessionLogin;
  section_id := GetRequestValue('section_id');

  ForumData.Lock;
  try
    ForumData.LoadSections;

    Section := ForumData.Sections.ItemsByID[StrToIntDef(section_id, 0)];
    if not Assigned(Section) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    ForumData.LoadRights;

    UserAL := ForumData.Rights.GetUserAccessLevel(LowerCase(login), Section^.ID);

    if not IsSectionVisible(Section^.VisibilityLevel, UserAL) or
      not IsSectionWritable(Section^.AccessLevel, UserAL) then begin
      Result:=RelocationOnError('error_access_denied');
      Exit;
    end;

    ForumData.LoadTopics(Section^.ID);

    topic_id := GetRequestValue('topic_id');
    tID := StrToIntDef(topic_id, 0);

    Topic := ForumData.Topics.ItemsByID[tID];
    if not Assigned(Topic) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;

    ForumData.LoadReplies(Section^.ID,Topic^.ID);

    Reply := ForumData.Replies.ItemsByID[StrToIntDef(GetRequestValue('reply_id'), 0)];
    if not Assigned(Reply) then begin
      Result:=RelocationOnError('error_object_not_exists');
      Exit;
    end;
    ForumData.Replies.Delete(Reply);
    Section^.PostCount := Section^.PostCount - 1;
    Topic^.RepliesCount := Topic^.RepliesCount - 1;
  finally
    ForumData.Unlock;
    end;
  //Result := DoSectionView;
  Relocation(Format('?cmd=viewtopic&section_id=%s&topic_id=%s&sid=%s', [section_id, topic_id, SessionID]));
end;

function TCommandsDispatcher.DoLogin(user, pwd: AnsiString): integer;
var
  S : AnsiString;
  PreviousLogon : TDateTime;
begin
  if CheckUser(user, pwd) then
    begin
      Srv.OpenSession;

      if user = LOGIN_ADMIN then
        Session.asInteger['access_level'] := ACCESS_LEVEL_ADMIN
      else
        Session.asInteger['access_level'] := ACCESS_LEVEL_USER;

      Session.asString['user_name'] := user;
      Session.asBoolean['login'] := True;
      Session.KeepAlive := 60 * 60; // 60 minutes
      {$IFDEF USE_COOKIE_SESSIONID}
      Srv.Response.Cookie['session'] := SessionID;
      {$ENDIF}

      GetLastLogon(user, PreviousLogon);
      Session.asDateTime['previous logon'] := PreviousLogon;
      SetLastLogon(user, Now);

      // set cookie for auto-open session next visit
      S := EncodeLoginInfo(user, pwd);
      Srv.Response.Cookie['rtc_forum_uid'] := Format('%s; expires=Sun, 01-Jan-2034 00:00:00 GMT; path=/;', [S]);

      Result := Session.asInteger['access_level'];
    end
  else
    Result := ACCESS_LEVEL_DENIED;
end;

function TCommandsDispatcher.DoMoveSection: AnsiString;
var
  section_id : integer;
  Section1 : PSectionRecord;
  Section2 : PSectionRecord;
  place : integer;
  tmp : integer;
begin
  section_id := StrToIntDef(GetRequestValue('section_id'), 0);
  place := StrToIntDef(GetRequestValue('place'), 0);

  if (section_id <> 0) and (place <> 0) then
    begin
    ForumData.Lock;
    try
      ForumData.LoadSections;
      Section1 := ForumData.Sections.ItemsByID[section_id];
      Section2 := ForumData.Sections.ItemsByID[place];
      tmp := Section1^.SortOrder;
      Section1^.SortOrder := Section2^.SortOrder;
      Section2^.SortOrder := tmp;
    finally
      ForumData.Unlock;
      end;
  end;

  //Result := DoShowSections;
  Relocation(Format('?cmd=showsections&sid=%s', [SessionID]));
end;

function TCommandsDispatcher.RelocationOnError(MsgID: AnsiString):AnsiString;
begin
  PageMessage := GetMsg(MsgID);
  Result:=DoForum;

  {if Assigned(Session) then
    URL := Format('?sid=%s&errmsg=%s', [SessionID, URL_Encode(PageMessage)])
  else
    URL := Format('?errmsg=%s', [URL_Encode(PageMessage)])
  Relocation(URL); }
end;

function TCommandsDispatcher.GetPageMessage: AnsiString;
begin
  if Assigned(Session) then
    Result := Session.asString['PageMessage']
  else
    Result := GetRequestValue('errmsg');

  if Result = '' then
    Result := fPageMessage;
end;

procedure TCommandsDispatcher.SetPageMessage(const Value: AnsiString);
begin
  if Assigned(Session) then
    Session.asString['PageMessage'] := Value
  else
    fPageMessage := Value;
end;

function TCommandsDispatcher.DoSetFilter: AnsiString;
var
  filter_text : AnsiString;
begin
  filter_text := GetRequestValue('filter_text');
  if FindSession then
    Session.asString['forum_filter'] := filter_text;
  Relocation(Srv.Request.Referer);
end;

function TCommandsDispatcher.GetSessionID: AnsiString;
  begin
  if assigned(Session) then
    Result:=Session.ID
  else
    Result:='';
  end;

initialization

finalization
  FreeAndNil(ForumData);
end.
