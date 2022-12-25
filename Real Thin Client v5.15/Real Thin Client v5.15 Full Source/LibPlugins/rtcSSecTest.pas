unit rtcSSecTest;

{$include rtcDefs.inc}

interface

uses
  SysUtils, Forms, SyncObjs, Classes,
  rtcInfo, rtcPlugins, rtcLog,

  // StreamSec Tools II ...
  MpX509, TlsInternalServer, rtcSSecPlugin,
  SecUtils, StreamSecII, MPYarrow, SecComp,
  Asn1, TlsClass, TlsConst, X509Base;

type
  StrArray=array of String;
  WStrArray=array of WideString;

var
  ClientSessionTimeout:longint=60; // SSL session timeout in seconds (default = 60 seconds)
  ServerSessionTimeout:longint=60; // SSL session timeout in seconds (default = 60 seconds)

{ A server root cert file serves two purposes: It allows you to load
  intermediary CA certificate issued by the root when present in the server PFX,
  and it allows you to accept client certificates issued by the root. }
procedure AddServerRootCertFile(const CertFileName:String);
procedure AddServerPFXFile(const PFXFileName:String; PFXKey:WideString);
function GetServerCryptPlugin:TRtcCryptPlugin;

{ A client root cert file serves two purposes: It allows you to load
  intermediary CA certificate issued by the root when present in the client PFX,
  and it allows you to accept server certificates issued by the root. NOTE that
  unless certificate name checking is turned on CA chaining is the ONLY way the
  server certificates are authenticated. DO NOT use the same inhouse root CA
  for issuing server certificates deployed to any server you do not want the
  client to regard as authentic. }
procedure AddClientRootCertFile(const CertFileName:String);
procedure AddClientPFXFile(const PFXFileName:String; PFXKey:WideString);
function GetClientCryptPlugin:TRtcCryptPlugin;

{ Call AllowExpiredCertificates(True) to accept expired server certificates.
  Please note that expired root certificates will always be rejected. }
procedure AllowExpiredCertificates(aValue: Boolean);
{ Call BeGullablAndTrustAnythingSentToYou(True) if you have to suspend all CA
  chaining for testing purposes, e.g. when testing a client against a server
  with an unknown CA chain. }
procedure BeGullableAndTrustAnythingSentToYou(aValue: Boolean);
{ Use AddCertificateNameMap client side if the remote server is using a
  certificate with the wrong name, but should be accepted anyway.
  aRemoteAddr might be either ServerAddr or the IP of the server, depending on
  with certificate name information you need to map. Both aRemoteAddr and
  aCertName might be wildcard '*' strings. If aRemoteAddr is a wildcard,
  the commonname, DNSname or URI of the server certificate must mach aCertName.
  If aCertName is a wildcard, any certificate sent from a server at a
  location matching aRemoteAddr will be accepted. }
procedure AddCertificateNameMap(const aRemoteAddr, aCertName: string);

procedure ReleaseCryptPlugins;

implementation

type
  TMyPlugs=class
  protected
    procedure SimpleTLSInternalServer1BeforeImportTLSCert(Sender: TObject;
      Cert: TASN1Struct; var ExplicitTrust, AllowExpired: Boolean);
    procedure SimpleTLSInternalServer1CertNotAccepted(Sender: TObject;
      Cert: TASN1Struct; Status: TCertStatusCode);
    procedure SimpleTLSInternalServer1CertNotTrusted(Sender: TObject;
      Cert: TASN1Struct; var ExplicitTrust: Boolean);
    procedure SimpleTLSInternalServer1TLSIncomingAlert(Sender: TObject;
      Client: TCustomTLS_ContentLayer; var Fatal: Boolean; AlertCode: Integer);
    procedure SimpleTLSInternalServer1TLSOutgoingAlert(Sender: TObject;
      Client: TCustomTLS_ContentLayer; var Fatal: Boolean; AlertCode: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    end;

var
  myPlugs:TMyPlugs=nil;

var
  Server_RootCertFiles:array of String;
  Server_PFXFiles:array of String;
  Server_PFXKeys:array of WideString;

  Server_Ready:boolean=False;
  Server_SimpleTLSInternalServer:TSimpleTLSInternalServer=nil;
  Server_SsPrivateKeyRingComponent:TSsPrivateKeyRingComponent=nil;
  Server_CryptPlugin:TRtcSSecServerPlugin=nil;

  Client_RootCertFiles:array of String;
  Client_PFXFiles:array of String;
  Client_PFXKeys:array of WideString;

  Client_Ready:boolean=False;
  Client_SsPrivateKeyRingComponent:TSsPrivateKeyRingComponent=nil;
  Client_SimpleTLSInternalServer:TSimpleTLSInternalServer=nil;
  Client_CryptPlugin:TRtcSSecClientPlugin=nil;
  Client_CertificateExceptions:TStringList;

  Global_ExplicitTrust: Boolean = False;
  Global_AllowExpired: Boolean = False;

  CS:TCriticalSection;


procedure AllowExpiredCertificates(aValue: Boolean);
begin
  Global_AllowExpired := aValue;
end;

procedure BeGullableAndTrustAnythingSentToYou(aValue: Boolean);
begin
  Global_ExplicitTrust := aValue;
end;

procedure AddCertificateNameMap(const aRemoteAddr, aCertName: string);
begin
  if not Assigned(Client_CertificateExceptions) then
    Client_CertificateExceptions := TStringList.Create;
  Client_CertificateExceptions.Values[aRemoteAddr] := aCertName;
end;

procedure AddServerRootCertFile(const CertFileName:String);
  var
    have:boolean;
    a:integer;
  begin
  if not File_Exists(CertFileName) then Exit;
  CS.Acquire;
  try
    have:=False;
    for a:=0 to length(Server_RootCertFiles)-1 do
      if Server_RootCertFiles[a]=CertFileName then
        have:=True;
    if not have then
      begin
      SetLength(Server_RootCertFiles,length(Server_RootCertFiles)+1);
      Server_RootCertFiles[length(Server_RootCertFiles)-1]:=CertFileName;
      end;
  finally
    CS.Release;
    end;
  end;

procedure AddServerPFXFile(const PFXFileName:String; PFXKey:WideString);
  var
    have:boolean;
    a:integer;
  begin
  if not File_Exists(PFXFileName) then Exit;
  CS.Acquire;
  try
    have:=False;
    for a:=0 to length(Server_PFXFiles)-1 do
      if Server_PFXFiles[a]=PFXFileName then
        have:=True;
    if not have then
      begin
      SetLength(Server_PFXFiles,length(Server_PFXFiles)+1);
      Server_PFXFiles[length(Server_PFXFiles)-1]:=PFXFileName;
      SetLength(Server_PFXKeys,length(Server_PFXKeys)+1);
      Server_PFXKeys[length(Server_PFXKeys)-1]:=PFXKey;
      end;
  finally
    CS.Release;
    end;
  end;

procedure AddClientRootCertFile(const CertFileName:String);
  var
    have:boolean;
    a:integer;
  begin
  if not File_Exists(CertFileName) then Exit;
  CS.Acquire;
  try
    have:=False;
    for a:=0 to length(Client_RootCertFiles)-1 do
      if Client_RootCertFiles[a]=CertFileName then
        have:=True;
    if not have then
      begin
      SetLength(Client_RootCertFiles,length(Client_RootCertFiles)+1);
      Client_RootCertFiles[length(Client_RootCertFiles)-1]:=CertFileName;
      end;
  finally
    CS.Release;
    end;
  end;

procedure AddClientPFXFile(const PFXFileName:String; PFXKey:WideString);
  var
    have:boolean;
    a:integer;
  begin
  if not File_Exists(PFXFileName) then Exit;
  CS.Acquire;
  try
    have:=False;
    for a:=0 to length(Client_PFXFiles)-1 do
      if Client_PFXFiles[a]=PFXFileName then
        have:=True;
    if not have then
      begin
      SetLength(Client_PFXFiles,length(Client_PFXFiles)+1);
      Client_PFXFiles[length(Client_PFXFiles)-1]:=PFXFileName;
      SetLength(Client_PFXKeys,length(Client_PFXKeys)+1);
      Client_PFXKeys[length(Client_PFXKeys)-1]:=PFXKey;
      end;
  finally
    CS.Release;
    end;
  end;

function GetServerCryptPlugin:TRtcCryptPlugin;
  var
    havePFX:boolean;
    a:integer;
  begin
  Result:=nil;
  CS.Acquire;
  try
    if Server_Ready then
      Result:=Server_CryptPlugin
    else
      begin
      if length(Server_PFXFiles)<>length(Server_PFXKeys) then
        raise Exception.Create('PFXKeys array requires exactly one element for each PFXFile element.');

      havePFX:=False;
      for a:=0 to length(Server_PFXFiles)-1 do
        if File_Exists(Server_PFXFiles[a]) then
          havePFX:=True;

      if havePFX then
        begin
        { Wait for the PRNG to finish. It is threaded by default to allow background
          reseeding while the application is running. Background reseeding is not
          implemented in this demo. }
        while not YarrowHasReseeded do begin
          Sleep(10);                   // give the thread a time slice
          Application.ProcessMessages; // allow the thread to terminate
        end;

        Server_SsPrivateKeyRingComponent := TSsPrivateKeyRingComponent.Create(nil);
        Server_SimpleTLSInternalServer := TSimpleTLSInternalServer.Create(nil);

        with Server_SsPrivateKeyRingComponent do
          begin
          AllowPlainTextKeys := True;
          CacheKeyInterfaces := True;
          DefaultHashAlgorithm := haSHA1;
          SessionKeyLifeSpan := ServerSessionTimeout /24/60/60;
          end;
        with Server_SimpleTLSInternalServer do
          begin
          PrivateKeyRing := Server_SsPrivateKeyRingComponent;
          SessionKeyLifeSpan := ServerSessionTimeout /24/60/60;
          LeastKeyBitSize := 512;
          Options.BulkCipherAES128 := prPrefer;
          Options.BulkCipherAES256 := prAllowed;
          Options.EphemeralECDHKeySize := ecs256;
          Options.KeyAgreementDH := prNotAllowed;
          Options.KeyAgreementECDHE := prAllowed;
          Options.KeyAgreementRSA := prNotAllowed;
          Options.SignatureDSS := prNotAllowed;
          Options.SignatureRSA := prNotAllowed;
          Options.VerifyServerName := [vsnIP, vsnDNS, vsnURI];
          BeforeImportTLSCert := myPlugs.SimpleTLSInternalServer1BeforeImportTLSCert;
          OnCertNotTrusted := myPlugs.SimpleTLSInternalServer1CertNotTrusted;
          OnCertNotAccepted := myPlugs.SimpleTLSInternalServer1CertNotAccepted;
          OnTLSIncomingAlert := myPlugs.SimpleTLSInternalServer1TLSIncomingAlert;
          OnTLSOutgoingAlert := myPlugs.SimpleTLSInternalServer1TLSOutgoingAlert;
          end;

        with Server_SimpleTLSInternalServer do
          begin
          for a:=0 to length(Server_RootCertFiles)-1 do
            if File_Exists(Server_RootCertFiles[a]) then // root.cer
              LoadRootCertsFromFile(Server_RootCertFiles[a]);

          for a:=0 to length(Server_PFXFiles)-1 do
            if File_Exists(Server_PFXFiles[a]) then // server.pfx
              ImportFromPFX(Server_PFXFiles[a],TSecretKey.CreateBMPStr(PWideChar(Server_PFXKeys[a]),length(Server_PFXKeys[a]))); // abc, 3

          // RSA is faster than DHE
          Options.KeyAgreementRSA := prPrefer;
          // Change block cipher preferences
          Options.BulkCipherAES128 := prNotAllowed;
          Options.BulkCipherAES192 := prNotAllowed;
          Options.BulkCipherAES256 := prNotAllowed;
          Options.BulkCipherARC4 := prPrefer;

          Options.RequestClientCertificate := False;
          Options.RequireClientCertificate := False;

          TLSSetupServer;
          end;

        Server_CryptPlugin := TRtcSSecServerPlugin.Create(nil);
        Server_CryptPlugin.TLSServer := Server_SimpleTLSInternalServer;

        Server_Ready:=True;
        Result:=Server_CryptPlugin;
        end
      else
        Server_Ready:=True;
      end;
  finally
    CS.Release;
    end;
  end;

function GetClientCryptPlugin:TRtcCryptPlugin;
  var
    haveRoot, havePFX:boolean;
    a:integer;
  begin
  Result:=nil;
  CS.Acquire;
  try
    if Client_Ready then
      Result:=Client_CryptPlugin
    else
      begin
      if length(Client_PFXFiles)<>length(Client_PFXKeys) then
        raise Exception.Create('PFXKeys array requires exactly one element for each PFXFile element.');

      haveRoot:=length(Client_RootCertFiles)=0;
      for a:=0 to length(Client_RootCertFiles)-1 do
        if File_Exists(Client_RootCertFiles[a]) then
          haveRoot:=True;

      if haveRoot then
        begin
        { Wait for the PRNG to finish. It is threaded by default to allow background
          reseeding while the application is running. Background reseeding is not
          implemented in this demo. }
        while not YarrowHasReseeded do
          begin
          Sleep(10);                   // give the thread a time slice
          Application.ProcessMessages; // allow the thread to terminate
          end;

        Client_SsPrivateKeyRingComponent:=TSsPrivateKeyRingComponent.Create(nil);
        Client_SimpleTLSInternalServer:=TSimpleTLSInternalServer.Create(nil);

        with Client_SsPrivateKeyRingComponent do
          begin
          AllowPlainTextKeys := True;
          CacheKeyInterfaces := True;
          DefaultHashAlgorithm := haSHA1;
          SessionKeyLifeSpan := ClientSessionTimeout /24/60/60;
          end;

        with Client_SimpleTLSInternalServer do
          begin
          PrivateKeyRing := Client_SsPrivateKeyRingComponent;
          PublicKeyAlgorithms := [pkaRSA, pkaDSA, pkaECDSA, pkaDH, pkaECDH];
          SessionKeyLifeSpan := ClientSessionTimeout /24/60/60;
          LeastKeyBitSize := 512;
          Options.BulkCipherAES128 := prPrefer;
          Options.BulkCipherAES256 := prAllowed;
          Options.EphemeralECDHKeySize := ecs256;
          Options.KeyAgreementECDHE := prAllowed;
          Options.SignatureECDSA := prAllowed;
          Options.VerifyServerName := [vsnIP, vsnDNS, vsnURI];
          BeforeImportTLSCert := myPlugs.SimpleTLSInternalServer1BeforeImportTLSCert;
          OnCertNotTrusted := myPlugs.SimpleTLSInternalServer1CertNotTrusted;
          OnCertNotAccepted := myPlugs.SimpleTLSInternalServer1CertNotAccepted;
          OnTLSIncomingAlert := myPlugs.SimpleTLSInternalServer1TLSIncomingAlert;
          OnTLSOutgoingAlert := myPlugs.SimpleTLSInternalServer1TLSOutgoingAlert;
          end;

        with Client_SimpleTLSInternalServer do
          begin
          ClientOrServer := cosClientSide;
          for a:=0 to length(Client_RootCertFiles)-1 do
            if File_Exists(Client_RootCertFiles[a]) then
              LoadRootCertsFromFile(Client_RootCertFiles[a]); // root.cer

          havePFX:=False;
          for a:=0 to length(Client_PFXFiles)-1 do
            if File_Exists(Client_PFXFiles[a]) then // client.pfx
              begin
              havePFX:=True;
              ImportFromPFX(Client_PFXFiles[a],TSecretKey.CreateBMPStr(PWideChar(Client_PFXKeys[a]),length(Client_PFXKeys[a]))) // abc
              end;
          if not havePFX then
            begin
            Options.RequestClientCertificate := False;
            Options.RequireClientCertificate := False;
            end;
          // RSA is faster than DHE
          Options.KeyAgreementRSA := prPrefer;
          TLSSetupClient;
          end;

        Client_CryptPlugin:=TRtcSSecClientPlugin.Create(nil);
        Client_CryptPlugin.TLSServer := Client_SimpleTLSInternalServer;
        if assigned(Client_CertificateExceptions) then
          Client_CryptPlugin.CertificateNameMap := Client_CertificateExceptions;

        Client_Ready:=True;
        Result:=Client_CryptPlugin;
        end
      else
        Client_Ready:=True;
      end;
  finally
    CS.Release;
    end;
  end;

procedure ReleaseCryptPlugins;
  var
    a:integer;
  begin
  for a:=0 to length(Server_RootCertFiles)-1 do
    Server_RootCertFiles[a]:='';
  SetLength(Server_RootCertFiles,0);

  for a:=0 to length(Server_PFXFiles)-1 do
    Server_PFXFiles[a]:='';
  SetLength(Server_PFXFiles,0);

  for a:=0 to length(Server_PFXKeys)-1 do
    Server_PFXKeys[a]:='';
  SetLength(Server_PFXKeys,0);

  for a:=0 to length(Client_RootCertFiles)-1 do
    Client_RootCertFiles[a]:='';
  SetLength(Client_RootCertFiles,0);

  for a:=0 to length(Client_PFXFiles)-1 do
    Client_PFXFiles[a]:='';
  SetLength(Client_PFXFiles,0);

  for a:=0 to length(Client_PFXKeys)-1 do
    Client_PFXKeys[a]:='';
  SetLength(Client_PFXKeys,0);

  if assigned(Client_CertificateExceptions) then
    FreeAndNil(Client_CertificateExceptions);

  if Server_Ready then
    begin
    if assigned(Server_CryptPlugin) then
      FreeAndNil(Server_CryptPlugin);
    if assigned(Server_SimpleTLSInternalServer) then
      FreeAndNil(Server_SimpleTLSInternalServer);
    if assigned(Server_SsPrivateKeyRingComponent) then
      FreeAndNil(Server_SsPrivateKeyRingComponent);
    Server_Ready:=False;
    end;

  if Client_Ready then
    begin
    if assigned(Client_CryptPlugin) then
      FreeAndNil(Client_CryptPlugin);
    if assigned(Client_SimpleTLSInternalServer) then
      FreeAndNil(Client_SimpleTLSInternalServer);
    if assigned(Client_SsPrivateKeyRingComponent) then
      FreeAndNil(Client_SsPrivateKeyRingComponent);
    Client_Ready:=False;
    end;

  end;

{ TMyPlugs }

constructor TMyPlugs.Create;
  begin
  inherited;
  CS:=TCriticalSection.Create;
  end;

destructor TMyPlugs.Destroy;
  begin
  ReleaseCryptPlugins;
  FreeAndNil(CS);
  inherited;
  end;

procedure TMyPlugs.SimpleTLSInternalServer1BeforeImportTLSCert(Sender: TObject;
  Cert: TASN1Struct; var ExplicitTrust, AllowExpired: Boolean);
begin
  AllowExpired := Global_AllowExpired;
  // ExplicitTrust := Global_ExplicitTrust; // Set in OnCertNotTrusted
end;

procedure TMyPlugs.SimpleTLSInternalServer1CertNotAccepted(Sender: TObject;
  Cert: TASN1Struct; Status: TCertStatusCode);
var
  lName: TX501Name;
  lMsg: string;
begin
  ExtractSubject(Cert,lName);
  lMsg := Format('Certificate with commonname "%s" not accepted.'#13#10,[lName.commonName.Str]);
  case Status of
    // crcOK: ;
    crcExpired:
      lMsg := lMsg + 'Status = Expired.';
    crcInvalidSignature:
      lMsg := lMsg + 'Status = The signature is invalid.'#13#10 +
        'Probable cause: The certificate data is corrupt, the certificate is a forgery, or'#13#10 +
        'the issuer public key has been replaced.';
    crcCANotTrusted:
      lMsg := lMsg + 'Status = The issuer of this certificate is not trusted.';
    crcRevoked:
      lMsg := lMsg + 'Status = Revoked.';
    crcCAExpiredOrRevoked:
      lMsg := lMsg + 'Status = The issuer certificate has expired or has been revoked.';
    crcConstraintFault:
      lMsg := lMsg + 'Status = Constraint fault. The certificate does not comply with the constraints of the issuer.';
    crcInvalidKeyUsage:
      lMsg := lMsg + 'Status = Invalid key usage. The issuer certificate cannot be used for issuing this kind of certificates.';
    crcUnsupportedExtension:
      lMsg := lMsg + 'Status = Unsupported extension. The certificate has a critical extension this implementation does not understand.';
    // crcSuperseeded: ; // CRLs only
    crcSyntax:
      lMsg := lMsg + 'Status = Syntax error. There is a problem with the format of this certificate.';
    // crcBaseNotFound: ; // CRLs only
    // crcTrusted: ;
    crcTooSmallKey:
      lMsg := lMsg + 'Status = Too small key. The public key of this certificate is smaller than LeastKeyBitSize.';
    crcPolicyNotAccepted:
      lMsg := lMsg + 'Status = You do not accept the policies of this certificate.';
    crcDuplicateKeyIdentifier:
      lMsg := lMsg + 'Status = Duplicate key identifier. There already exists another certificate with the same key identifier.';
  end;
  lMsg := StringReplace(lMsg,#13#10,#32,[rfReplaceAll]);
  rtcLog.Log(lMsg,'SSL-TLS-FATAL');
end;

procedure TMyPlugs.SimpleTLSInternalServer1CertNotTrusted(Sender: TObject;
  Cert: TASN1Struct; var ExplicitTrust: Boolean);
var
  lName: TX501Name;
  lMsg: string;
begin
  ExtractSubject(Cert,lName);
  ExplicitTrust := Global_ExplicitTrust;
  if ExplicitTrust then begin
    lMsg := Format('Certificate with commonname "%s" explicitly trusted.'#13#10,[lName.commonName.Str]);
    rtcLog.Log(lMsg,'SSL-TLS-WARN');
  end else begin
    lMsg := Format('Certificate with commonname "%s" not trusted.'#13#10,[lName.commonName.Str]);
    rtcLog.Log(lMsg,'SSL-TLS-FATAL');
  end;
end;

procedure TMyPlugs.SimpleTLSInternalServer1TLSIncomingAlert(Sender: TObject;
  Client: TCustomTLS_ContentLayer; var Fatal: Boolean; AlertCode: Integer);
var
  lMsg: string;
begin
  // AlertCode = 0 signals connection close and is expected
  if AlertCode <> 0 then begin
    if Fatal then
      lMsg := 'INcoming fatal alert:'
    else
      lMsg := 'INcoming warning:';
    lMsg := lMsg + AlertMsg(AlertCode);
    lMsg := StringReplace(lMsg,#13#10,#32,[rfReplaceAll]);
    if Fatal then
      rtcLog.Log(lMsg,'SSL-TLS-FATAL')
    else
      rtcLog.Log(lMsg,'SSL-TLS-WARN');
  end;
end;

procedure TMyPlugs.SimpleTLSInternalServer1TLSOutgoingAlert(Sender: TObject;
  Client: TCustomTLS_ContentLayer; var Fatal: Boolean; AlertCode: Integer);
var
  lMsg: string;
begin
  if AlertCode <> 0 then begin
    if Fatal then
      lMsg := 'OUTgoing fatal alert:'
    else
      lMsg := 'OUTgoing warning:';
    lMsg := lMsg + AlertMsg(AlertCode);
    if AlertCode and certificate_unknown <> 0 then begin
      { Certificate name errors are just warnings by default. Typically,
        StrSecII is used client side only for connecting to "your" servers
        and you are expected to use inhouse PKI, so that only "your" servers
        will have server certificates issued by the root CA the client is
        aware of. If the certificate is issued by an unknown CA an unknown_ca
        alert will occur sooner. If you do not want to connect if the name is
        wrong, simply flip Fatal to True, although please note that
        certificates WITHOUT any name information will ALWAYS be accepted as is,
        so it is imperative that you only load root CA certificates of CAs you
        trust to issue certificates that will work with the implementation. }
      // Fatal := True;
      if AlertCode and $FFFF0000 = server_cert_name then begin
        lMsg := Format('%s cert_name=%s expected=%s',
          [lMsg,ExtractDNSName(Client.ServerCertificate^),Client.DNSNameToCheck])
      end else if AlertCode and $FFFF0000 = server_cert_uri then begin
        lMsg := Format('%s cert_uri=%s expected=%s',
          [lMsg,ExtractURI(Client.ServerCertificate^),Client.URIToCheck])
      end else if AlertCode and $FFFF0000 = server_cert_ip then begin
        lMsg := Format('%s cert_ip=%s expected=%s',
          [lMsg,ExtractIP(Client.ServerCertificate^),Client.IPToCheck])
      end;
    end;
    lMsg := StringReplace(lMsg,#13#10,#32,[rfReplaceAll]);
    if Fatal then
      rtcLog.Log(lMsg,'SSL-TLS-FATAL')
    else
      rtcLog.Log(lMsg,'SSL-TLS-WARN');
  end;
end;

initialization
{ "StartLog" will enable logging errors and warnings to a file.
  If you do not want errors and warnings to be logged to a file,
  comment this line out and do not call "StartLog" in your code. }
rtcLog.StartLog;

myPlugs:=TMyPlugs.Create;
finalization
myPlugs.Free;
end.
