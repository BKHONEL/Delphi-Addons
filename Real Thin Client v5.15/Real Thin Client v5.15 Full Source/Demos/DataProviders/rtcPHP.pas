{
  @html(<b>)
  PHP Scripting
  @html(</b>)
  - Copyright (c) Danijel Tkalcec
  @html(<br><br>)

  Based on 'PHP 4 Delphi'
    by Serhiy Perevoznyk
    <serge_perevoznyk(at)hotmail.com>
    <http://users.chello.be/ws36637>
  @html(<br>)

  You have to download and install PHP separately.
  It is not included in the package.
  You can download the latest version of PHP from
    <http://www.php.net/downloads.php>
  @html(<br>)

  For more information on the PHP Group and the PHP project,
  please see <http://www.php.net>.
}

unit rtcPHP;

{$INCLUDE rtcDefs.inc}

interface

uses
  Windows, SysUtils, Classes,

  rtcLog,

  rtcInfo,
  rtcFastStrings,
  rtcPHPTypes,

  rtcThrPool;

{$IFDEF PHP530} {$DEFINE PHP520} {$ENDIF}
{$IFDEF PHP520} {$DEFINE PHP510} {$ENDIF}
{$IFDEF PHP510} {$DEFINE PHP5} {$ENDIF}

type
  { @abstract(All exceptions raised by PHP class will be of this type)
    @exclude }
  EPHPError = class(Exception);

  { @abstract(Provides access to PHP5 file scripting)
    Can be easily used with @Link(TRtcHttpServer) to add
    PHP5 functionality to your HTTP Server. You can create
    as many @name components as you need, as long as each
    of them is created from a different thread. @longcode(#
    IMPORATANT:
      When using TRtcPHP, especially in a multithreaded server,
      YOU HAVE TO create a (temporary) component before processing a
      request and destroy it after the request has been processed.

    NOTE:
      There will be NO EXECUTION SPEED DRAWBACKS from this approach,
      because there is no special initialization in TRtcPHP constructor.
      The only thing that is being initialized in the TRtcPHP
      component are the properties you have to pass to the component.
      Everyting else is initialized from the StatupPHP procedure.

    EXAMPLE:

      function Parse_PHP(Sender:TRtcHttpServer;
                         const PhpFileName, DocRoot:AnsiString;
                         var Header:AnsiString):AnsiString;
        var
          PHP:TRtcPHP;
        begin
        // Create the PHP sripting component
        PHP:=TRtcPHP.Create;
        try
          // Prepare the script for execution
          PHP.FileName:=PhpFileName;
          PHP.DocumentRoot:=DocRoot;

          PHP.LocalAddr:=Sender.LocalAddr;
          PHP.LocalPort:=Sender.LocalPort;
          PHP.PeerAddr:=Sender.PeerAddr;
          PHP.PeerPort:=Sender.PeerPort;

          PHP.Request:=Sender.Request;
          PHP.RequestBody:=Sender.Read;

          // Execute the script
          Result:=PHP.Execute;

          // Get HTTP Header prepared by PHP
          Header:=PHP.ResultHeader;
        finally
          // Release the PHP scripting component
          PHP.Free;
          end;
        end; #) }
  TRtcPHP = class
  private
    FRequest:TRtcRequest;

    FRequestBody : AnsiString;

    FPeerAddr:AnsiString;
    FPeerPort:AnsiString;
    FLocalAddr : AnsiString;
    FLocalPort : AnsiString;

    FDocumentRoot : AnsiString;
    FResultHeader : AnsiString;

    FSessionActive : boolean;
    TSRMLS_D  : pppointer;

    FBuffer : TRtcHugeString;
    FBufferSize : integer;

    FFileName : AnsiString;

    procedure StartupRequest; virtual;
    procedure ShutdownRequest; virtual;

  protected
    { PHP reads posted Body content chunk-wise.
      This variable is used by TRtcPHP to track
      how much of our RequestBody is already out.
      @exclude }
    RequestBodyOut:integer;

  public
    { Create the PHP scripting object }
    constructor Create;
    { Destroy object }
    destructor Destroy; override;

    { EXECUTE the script from file @Link(FileName).
      Before calling Execute, the PHP Library has to
      be initialized by calling @Link(StartupPHP) and
      all TRtcPHP properties have to be filled with valid data.
      Additionally to the resulting HTML page, PHP generates a
      HTML header, accessible from the @Link(ResultHeader) property,
      immediatelly after calling @name.
      @return(HTML output as AnsiString) }
    function  Execute : AnsiString;

    { SET: Filename to execute, including full path (no relative paths!). }
    property  FileName  : AnsiString read FFileName write FFileName;

    { SET: Request information, needed for script execution.
      When using TRtcPHP to execute server-side PHP scripts, simply assign
      the @Link(TRtcDataServer.Request) object from your @Link(TRtcHttpServer)
      connection component.
      This information is used to fill PHP variables. }
    property  Request: TRtcRequest read FRequest write FRequest;

    { SET: Local IP address. Same as @Link(TRtcConnection.LocalAddr).
      When using PHP with a connection component, simply assign the
      connection component's @Link(TRtcConnection.LocalAddr) property.
      This information is used to fill PHP variables. }
    property  LocalAddr : AnsiString read FLocalAddr write FLocalAddr;
    { SET: Local Port. Same as @Link(TRtcConnection.LocalPort).
      When using PHP with a connection component, simply assign the
      connection component's @Link(TRtcConnection.LocalAddr) property.
      This information is used to fill PHP variables. }
    property  LocalPort : AnsiString read FLocalPort write FLocalPort;
    { SET: Peer (remote PC) Address. Same as @Link(TRtcConnection.PeerAddr).
      When using PHP with a connection component, simply assign the
      connection component's @Link(TRtcConnection.PeerAddr) property.
      This information is used to fill PHP variables. }
    property  PeerAddr:AnsiString read FPeerAddr write FPeerAddr;
    { SET: Peer (remote PC) Port. Same as @Link(TRtcConnection.PeerPort).
      When using PHP with a connection component, simply assign the
      connection component's @Link(TRtcConnection.PeerPort) property.
      This information is used to fill PHP variables. }
    property  PeerPort:AnsiString read FPeerPort write FPeerPort;
    { SET: WebServer's Document Root folder.
      You should set this to your HttpServer's Document Root folder.
      This information is used to fill PHP variables. }
    property  DocumentRoot:AnsiString read FDocumentRoot write FDocumentRoot;

    { SET: HTTP Request Body, which was posted after the HTTP Header
      (also called Document Content). Before executing a PHP Request,
      wait for the whole Request to arrive at the server,
      so you can pass the whole Request Body to PHP.
      This information is used to fill PHP variables. }
    property  RequestBody : AnsiString read FRequestBody write FRequestBody;

    { GET: HTTP Response Header generated by PHP.
      For a HTTP Server to process PHP scripts correctly,
      in addition to passing all HTTP properties to the PHP scripting component,
      you have to return this header back to the client when sending the result. }
    property  ResultHeader : AnsiString read FResultHeader write FResultHeader;
  end;

{ Before you can use TRtcPHP components,
  you have to initialize the PHP Library by calling this procedure.
  This is usually done from the OnListenStart event handler
  of your Server connection component.

  @param(DLLFolder - Folder in which the DLL file for PHP5 resides)
  @param(IniFolder - Folder in which the INI file for PHP5 resides) }
procedure StartupPHP(DLLFolder:String; IniFolder:AnsiString);

{ To uninitialize the PHP Library, you should call this procedure.
  This is usually done from the OnListenStop event handler
  of your Server connection component. }
procedure ShutDownPHP;

implementation

uses
  memBinList,
  rtcSyncObjs;

var
  module_active : boolean = False;

  delphi_sapi_module : sapi_module_struct;
  ini_folder : AnsiString;
  CS:TRtcCritSec;
  ThrList:TBinList;

procedure InitResource;
  var
    p:pointer;
  begin
  CS.Acquire;
  try
    if ThrList.search(GetCurrentThreadID)>0 then
      raise EPHPError.Create('InitResource: One thread, multiple resources.');
    p:=ts_resource_ex(0,nil);
    ThrList.insert(GetCurrentThreadID, longword(p));
  finally
    CS.Release;
    end;
  end;

procedure FreeResource;
  var
    a:longword;
  begin
  CS.Acquire;
  try
    a:=ThrList.search(GetCurrentThreadID);
    if a>0 then
      ThrList.remove(GetCurrentThreadID)
    else
      raise EPHPError.Create('FreeResource: Resource not existing.');
  finally
    CS.Release;
    end;
  end;

function GetResource:pointer;
  var
    a:longword;
  begin
  Result:=nil;
  CS.Acquire;
  try
    a:=ThrList.search(GetCurrentThreadID);
    if a>0 then
      Result:=pointer(a)
    else
      raise EPHPError.Create('GetResource: Undefined resource Thread!');
  finally
    CS.Release;
    end;
  end;

function php_delphi_startup(sapi_module : Psapi_module_struct) : integer; cdecl;
  begin
  result := php_module_startup(sapi_module, nil, 0);
  end;

function php_delphi_deactivate(p : pointer) : integer; cdecl;
  begin
  result := 0;
  end;

function php_delphi_ub_write(str : ppointer; len : uint; p : pointer) : integer; cdecl;
  var
    ts : pointer;
    php : TRtcPHP;
    gl : psapi_globals_struct;
    s : AnsiString;
  begin
  try
    Result := 0;

    ts := GetResource;
    if not assigned(ts) then Exit;
    gl := GetSAPIGlobals(ts);
    if not assigned(gl) then Exit;
    php := TRtcPHP(gl^.server_context);
    if not assigned(php) then Exit;

    SetLength(s, len);
    if len>0 then
      Move(str^, s[1], len);

    try
      php.FBuffer.Add(s);
      Inc(php.FBufferSize, length(s));
    except
      end;

    Result := len;
  except
    on E:Exception do
      begin
      Log('Write callback',E,'PHP');
      Result:=0;
      end;
    end;
  end;

procedure php_delphi_register_variables(val : pzval; p : pointer); cdecl;
  var
    php : TRtcPHP;
    gl : psapi_globals_struct;
    ts : pointer;
    i : integer;
    vname, vval:AnsiString;
  begin
  try
    ts := GetResource;
    if not assigned(ts) then Exit;
    gl := GetSAPIGlobals(ts);
    if not assigned(gl) then Exit;
    php := TRtcPHP(gl^.server_context);
    if not assigned(php) then Exit;

    php_register_variable('SERVER_SOFTWARE', 'www.realthinclient.com', val, p);
    php_register_variable('SERVER_SIGNATURE', 'RealThinClient Library (c) Danijel Tkalcec', val, p);
    php_register_variable('SERVER_PROTOCOL', 'HTTP/1.1', val, p);

    if assigned(php.Request) then
      begin
      php_register_variable('REQUEST_METHOD', PAnsiChar(php.Request.Method), val, p);
      php_register_variable('QUERY_STRING', PAnsiChar(php.Request.Query.Text), val, p);

      if php.Request.Query.Text='' then
        php_register_variable('REQUEST_URI', PAnsiChar(php.Request.FileName), val, p)
      else
        php_register_variable('REQUEST_URI', PAnsiChar(php.Request.URI), val, p);

      php_register_variable('SCRIPT_NAME', PAnsiChar(php.Request.FileName), val, p);
      php_register_variable('PHP_SELF', PAnsiChar(php.Request.FileName), val, p);

      php_register_variable('SERVER_NAME', PAnsiChar(php.Request.Host), val, p);

      for i:=0 to php.Request.ItemCount-1 do
        begin
        vname:=AnsiString(StringReplace(String(php.Request.ItemName[i]),'-','_',[rfReplaceAll]));
        vval:=php.Request.ItemValue[i];
        php_register_variable(PAnsiChar('HTTP_'+AnsiUpperCase(vname)), PAnsiChar(vval), val, p);
        end;
      end;

    if php.LocalAddr<>'' then    php_register_variable('SERVER_ADDR', PAnsiChar(php.LocalAddr), val, p);
    if php.LocalPort<>'' then    php_register_variable('SERVER_PORT', PAnsiChar(php.LocalPort), val, p);
    if php.PeerAddr<>'' then     php_register_variable('REMOTE_ADDR', PAnsiChar(php.PeerAddr), val, p);
    if php.PeerPort<>'' then     php_register_variable('REMOTE_PORT', PAnsiChar(php.PeerPort), val, p);
    if php.DocumentRoot<>'' then php_register_variable('DOCUMENT_ROOT', PAnsiChar(php.DocumentRoot), val, p);
    if php.FileName<>'' then     php_register_variable('SCRIPT_FILENAME', PAnsiChar(php.FileName), val, p);
  except
    on E:Exception do
      begin
      Log('Register Variables callback',E,'PHP');
      end;
    end;
  end;

procedure php_delphi_send_header(p1:Psapi_header_struct; p2:pointer); cdecl;
  var
    php : TRtcPHP;
    gl : psapi_globals_struct;
    ts : pointer;
    s : AnsiString;
  begin
  try
    if not assigned(p1) then Exit;

    ts := GetResource;
    if not assigned(ts) then Exit;
    gl := GetSAPIGlobals(ts);
    if not assigned(gl) then Exit;
    php := TRtcPHP(gl^.server_context);
    if not assigned(php) then Exit;

    s:=p1^.header;
    php.ResultHeader:=php.ResultHeader+s+#13#10;
  except
    on E:Exception do
      Log('Send Header callback',E,'PHP');
    end;
  end;

function php_delphi_read_cookies(p1 : pointer) : pointer; cdecl;
  var
    php : TRtcPHP;
    gl : psapi_globals_struct;
    ts : pointer;
  begin
  Result:=nil;
  try
    ts := GetResource;
    if not assigned(ts) then Exit;
    gl := GetSAPIGlobals(ts);
    if not assigned(gl) then Exit;
    php := TRtcPHP(gl^.server_context);
    if not assigned(php) then Exit;

    if php.Request.Value['COOKIE']<>'' then
      Result:=PAnsiChar(php.Request.Value['COOKIE']);
  except
    on E:Exception do
      begin
      Result:=nil;
      Log('Read Cookies callback',E,'PHP');
      end;
    end;
  end;

function php_delphi_read_post(p1:pointer; count_bytes:integer) : integer; cdecl;
  var
    php : TRtcPHP;
    gl : psapi_globals_struct;
    ts : pointer;
    pc : PAnsiChar;
  begin
  Result:=0;
  try
    ts := GetResource;
    if not assigned(ts) then Exit;
    gl := GetSAPIGlobals(ts);
    if not assigned(gl) then Exit;
    php := TRtcPHP(gl^.server_context);
    if not assigned(php) then Exit;

    if (length(php.RequestBody)>php.RequestBodyOut) then
      begin
      if count_bytes <= length(php.RequestBody)-php.RequestBodyOut then
        begin
        if count_bytes>0 then
          Move(php.RequestBody[php.RequestBodyOut+1], p1^, count_bytes);
        Result:=count_bytes;
        php.RequestBodyOut:=php.RequestBodyOut+count_bytes;
        end
      else
        begin
        Result:=length(php.RequestBody)-php.RequestBodyOut;
        pc:=PAnsiChar(Copy(php.RequestBody, php.RequestBodyOut+1, Result));
        Move(pc^,p1^,Result+1);
        php.RequestBodyOut:=php.RequestBodyOut+Result;
        end;
      end;
  except
    on E:Exception do
      begin
      Result:=0;
      Log('Read Post callback',E,'PHP');
      end;
    end;
  end;

{ TRtcPHP }

constructor TRtcPHP.Create;
  begin
  inherited;
  FSessionActive := false;
  end;

destructor TRtcPHP.Destroy;
  begin
  ShutdownRequest;
  inherited;
  end;

function TRtcPHP.Execute : AnsiString;
  var
    file_handle : zend_file_handle;
    // a,len:integer;

  begin
  FBuffer := TRtcHugeString.Create;

  try
    try
      if not File_Exists(String(FFileName)) then
        raise EPHPError.CreateFmt('File %s does not exists', [FFileName]);

      FillChar(file_handle, sizeof(zend_file_handle), 0);
      file_handle._type := ZEND_HANDLE_FILENAME;
      file_handle.filename := PAnsiChar(FFileName);
      file_handle.opened_path := nil;
      file_handle.free_filename := 0;

      ResultHeader:='';

      StartupRequest;
      try
        php_execute_script(@file_handle, TSRMLS_D);
      finally
        ShutdownRequest;
        end;
    except
      on E:Exception do
        FBuffer.Add('<p>ERROR!'+AnsiString(E.Message)+'</p>');
      end;

    Result:=FBuffer.Get;
  finally
    FBuffer.Free;
    end;
  end;

procedure TRtcPHP.StartupRequest;
  var
    gl  : psapi_globals_struct;
  begin
  if FSessionActive then Exit;

  InitResource;

  try
    TSRMLS_D := GetResource;

    PG(TSRMLS_D)^.register_globals := true;

    gl := GetSAPIGlobals(TSRMLS_D);

    with gl^ do
      begin
      RequestBodyOut:=0;

      server_context := Self;
      if Request.Method='HEAD' then
        request_info.request_method := 'GET'
      else
        request_info.request_method := PAnsiChar(Request.Method);

      request_info.query_string := PAnsiChar(Request.Query.Text);
      request_info.content_type := PAnsiChar(Request['CONTENT-TYPE']);
      request_info.content_length := length(RequestBody);

      read_post_bytes:=length(RequestBody);

      request_info.request_uri := PAnsiChar(Request.FileName);
      sapi_headers.http_response_code := 200;
      end;

    php_request_startup(TSRMLS_D);

    FSessionActive := true;
  except
    FSessionActive := false;

    FreeResource;
	raise; // re-raise the exception
    end;
  end;

procedure TRtcPHP.ShutdownRequest;
  begin
  if not FSessionActive then Exit;

  try
    php_request_shutdown(TSRMLS_D);
  finally
    FreeResource;
    FSessionActive := False;
    end;
  end;

procedure StartupModule;
  begin
  delphi_sapi_module.name := 'embed';  //to solve a problem with dl()
  delphi_sapi_module.pretty_name := 'RTC PHP Server';  (* pretty name *)
  delphi_sapi_module.startup := php_delphi_startup;    (* startup *)
  delphi_sapi_module.shutdown := php_module_shutdown_wrapper;   (* shutdown *)
  delphi_sapi_module.activate:= nil;  (* activate *)
  delphi_sapi_module.deactivate := @php_delphi_deactivate;  (* deactivate *)
  delphi_sapi_module.ub_write := @php_delphi_ub_write;      (* unbuffered write *)
  delphi_sapi_module.flush := nil;
  delphi_sapi_module.stat:= nil;
  delphi_sapi_module.getenv:= nil;
  delphi_sapi_module.sapi_error := @zend_error;  (* error handler *)
  delphi_sapi_module.header_handler := nil;
  delphi_sapi_module.send_headers := nil;
  delphi_sapi_module.send_header :=  @php_delphi_send_header;
  delphi_sapi_module.read_post := @php_delphi_read_post;
  delphi_sapi_module.read_cookies := @php_delphi_read_cookies;
  delphi_sapi_module.register_server_variables := @php_delphi_register_variables;   (* register server variables *)
  delphi_sapi_module.log_message := nil;  (* Log message *)
  if ini_folder <> '' then
    delphi_sapi_module.php_ini_path_override := PAnsiChar(ini_folder)
  else
    delphi_sapi_module.php_ini_path_override :=  nil;
  delphi_sapi_module.block_interruptions := nil;
  delphi_sapi_module.unblock_interruptions := nil;
  delphi_sapi_module.default_post_reader := nil;
  delphi_sapi_module.treat_data := nil;
  delphi_sapi_module.executable_location := nil;
  delphi_sapi_module.php_ini_ignore := 0;

  sapi_startup(@delphi_sapi_module);
  php_module_startup(@delphi_sapi_module, nil, 0{1});
  end;

procedure ShutdownModule;
  begin
  delphi_sapi_module.shutdown(@delphi_sapi_module);
  sapi_shutdown;
  end;

procedure StartupPHP(DLLFolder:String; IniFolder:AnsiString);
  begin
  CS.Acquire;
  try
    if not PHPLoaded then
      begin
      if DLLFolder <> '' then
        if Copy(DLLFolder,length(DLLFolder),1)<>'\' then
          DLLFolder:=DLLFolder+'\';

      LoadPHP(DLLFolder);

      ThrList:=tBinList.Create(128);

      tsrm_startup(512, 512, TSRM_ERROR_LEVEL_ERROR , nil);

      ini_folder := IniFolder;
      StartupModule;

      module_active:=True;
      end;
  finally
    CS.Release;
    end;
  end;

procedure ShutDownPHP;
  begin
  CS.Acquire;
  try
    if module_active then
      begin
      ShutDownModule;

      tsrm_shutdown();

      module_active:=false;
      UnloadPHP;

      FreeAndNil(ThrList);
      end;
  finally
    CS.Release;
    end;
  end;

initialization
CS:=TRtcCritSec.Create;
finalization
ShutDownPHP;
FreeAndNil(CS);
end.
