?
 TFORM1 0?  TPF0TForm1Form1Left? Top? WidthvHeight?CaptionRTC WebServer Stress Tool v1.2Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterOnCreate
FormCreatePixelsPerInch`
TextHeight TPanelmyPanelLeft Top? WidthfHeight? AlignalClientBorderWidthTabOrder  	TPaintBoxmyBoxLeftTopWidthZHeight? AlignalClient   TPanelPanel1Left Top WidthfHeight? AlignalTopBorderWidthTabOrder TLabelLabel16Left?TopnWidth_HeightCaptionConnections Active:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel17LeftDTop#WidthWHeightCaptionConnection count:  TLabelLabel18LeftDTop:WidthYHeightCaptionRequests per loop:  TLabellblFloodLeft?Top? WidthHeightCaption0  TLabel
lblClientsLeft?TopnWidthHeightCaption----  TLabelLabel25Left?Top? WidtheHeightCaptionRequests Completed:  TLabelLabel26LeftFTopUWidthWHeight	AlignmenttaRightJustifyCaptionUpdate stats after:  TLabelLabel32LeftDTop
WidthZHeightCaptionMax Thread count:  TLabelLabel11LeftTop7WidthHeightCaption?Enter a list of requests you want to send (1 request per line):  TLabelLabel12LeftTTop
WidthHHeightCaptionServer Address  TLabelLabel13Left Top
WidthHeightCaptionPort  TBevelBevel1Left8TopWidthHeight?   TLabelLabel1Left?Top? WidthaHeightCaptionRequests Reposted:  TLabel	lblRepostLeft?Top? WidthHeightCaption0  TEditeConCntLeft?TopWidth1HeightTabOrderText100  TEditeReqCntLeft?Top7Width1HeightTabOrderText100  	TCheckBoxxReqAutoRepeatLeft?Top-Width? HeightCaptionAuto-Repeat LoopsTabOrder  TEditeUpdCntLeft?TopPWidth!HeightTabOrderText1  	TCheckBoxxAutoDisconnectLeft?TopWidth? HeightCaptionDisconnect after loopTabOrder
  	TCheckBoxxReqAutoConnectLeft?TopWidthyHeightCaptionUse Auto-ConnectChecked	State	cbCheckedTabOrder	  TEditeThreadsLeft?TopWidth1HeightTabOrderText16  TEditeServerLeftTTopWidth? HeightTabOrderOnChangeeServerChange  	TCheckBoxxProxyLeftTop
WidthEHeightTabStop	AlignmenttaLeftJustifyCaption	use ProxyTabOrder OnClickxProxyClick  TEditePortLeft TopWidth1HeightTabOrderText80OnChangeeServerChange  	TCheckBoxxSSLLeftTopWidthEHeightTabStop	AlignmenttaLeftJustifyCaptionuse SSLTabOrderOnClick	xSSLClick  TMemoMemo1LeftTopKWidth)HeightVLines.Strings/ TabOrder  TButtonbtnMultiFloodLeft?TopFWidtheHeightCaptionStart the TestDefault	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height?	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickbtnMultiFloodClick   TPanelPanel2Left Top?WidthfHeightCursorcrHandPointAlignalBottomCaption`Copyright (c) Danijel Tkalcec -> Built using RealThinClient SDK -> http://www.realthinclient.comTabOrderOnClickPanel2Click  TRtcHttpClient	RtcClientMultiThreaded	Timeout.AfterConnectingxTimeout.AfterConnect<
ServerAddr	localhost
ServerPort80ReconnectOn.ConnectError	ReconnectOn.ConnectLost	ReconnectOn.ConnectFail	AutoConnect	MaxHeaderSize?>LeftTop?   TRtcDataRequestDataRequestOnBeginRequestDataRequestBeginRequestOnResponseDoneDataRequestResponseDoneOnRepostCheckDataRequestRepostCheckOnDataReceivedDataRequestDataReceivedLeft\Top?    