unit WMUnit;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer,
  Web.WebFileDispatcher, Web.HTTPProd,
  DataSnap.DSAuth,
  Datasnap.DSProxyJavaScript, IPPeerServer, Datasnap.DSCommonServer,
  Datasnap.DSHTTP,
  BOSettings;

type
  TWebMod = class(TWebModule)
    WebDispatcher: TDSRESTWebDispatcher;
    Server: TDSServer;
    ServerClass: TDSServerClass;
    procedure ServerClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
  end;

var
  WebModuleClass: TComponentClass = TWebMod;

implementation


{$R *.dfm}

uses SMUnit, Web.WebReq;

procedure TWebMod.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>DataSnap Server v1.0</title></head>' +
    '<body>DataSnap Server v1.0</body>' +
    '</html>';
end;

procedure TWebMod.ServerClassGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := SMUnit.TSM;
end;

initialization

finalization
  Web.WebReq.FreeWebModules;

end.

