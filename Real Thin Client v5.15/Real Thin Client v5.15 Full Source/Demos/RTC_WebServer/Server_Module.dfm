object Data_Server: TData_Server
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 272
  Top = 230
  Height = 163
  Width = 196
  object ServerHTTP: TRtcHttpServer
    MultiThreaded = True
    Timeout.AfterConnecting = 60
    ServerPort = '80'
    OnConnecting = ServerHTTPConnecting
    OnDisconnecting = ServerHTTPDisconnecting
    OnDisconnect = ServerHTTPDisconnect
    RestartOn.ListenLost = True
    OnListenStart = ServerHTTPListenStart
    OnListenStop = ServerHTTPListenStop
    OnListenError = ServerHTTPListenError
    FixupRequest.RemovePrefix = True
    FixupRequest.DecodeFileName = True
    OnRequestNotAccepted = ServerHTTPRequestNotAccepted
    MaxRequestSize = 128000
    MaxHeaderSize = 16000
    OnInvalidRequest = ServerHTTPInvalidRequest
    Left = 24
    Top = 16
  end
  object ServerHTTPS: TRtcHttpServer
    MultiThreaded = True
    Timeout.AfterConnecting = 60
    ServerPort = '443'
    OnConnecting = ServerHTTPConnecting
    OnDisconnecting = ServerHTTPDisconnecting
    OnDisconnect = ServerHTTPDisconnect
    RestartOn.ListenLost = True
    OnListenStart = ServerHTTPListenStart
    OnListenStop = ServerHTTPListenStop
    OnListenError = ServerHTTPListenError
    FixupRequest.RemovePrefix = True
    FixupRequest.DecodeFileName = True
    OnRequestNotAccepted = ServerHTTPRequestNotAccepted
    MaxRequestSize = 128000
    MaxHeaderSize = 16000
    OnInvalidRequest = ServerHTTPInvalidRequest
    Left = 108
    Top = 16
  end
  object ServerLink: TRtcDualDataServerLink
    Server = ServerHTTP
    Server2 = ServerHTTPS
    Left = 64
    Top = 68
  end
end
