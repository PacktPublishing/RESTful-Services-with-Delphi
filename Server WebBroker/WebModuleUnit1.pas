unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer,
  Datasnap.DSAuth, DataModule, System.JSON;

type
  TWebModule1 = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1actCheckUserAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1actGetOrdersAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    procedure CheckUser( Request: TWebRequest; Response: TWebResponse );
    procedure GetOrders( Request: TWebRequest; Response: TWebResponse );
    procedure UpdateOrders( Request: TWebRequest; Response: TWebResponse );
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation


{$R *.dfm}

uses Web.WebReq;

procedure TWebModule1.CheckUser(Request: TWebRequest; Response: TWebResponse);
var
  userID : string;
  jsobj: TJSONObject;
begin
  if Request.QueryFields.Count > 0 then
  begin
    userID := datamod.GetUserID(Request.QueryFields.values['AUser'], Request.QueryFields.Values['APass']);
    Response.StatusCode := 200;
  end
  else
  begin
    Response.StatusCode := 555; // username or password not provided
    exit;
  end;

  jsobj := TJsonObject.Create;
  jsobj.AddPair('UserID',userID);
  Response.ContentType := 'application/json; charset="UTF-8"';
  Response.Content := jsobj.ToString;
end;

procedure TWebModule1.GetOrders(Request: TWebRequest; Response: TWebResponse);
begin
  if Request.QueryFields.Count > 0 then
  begin
    Response.ContentType := 'application/json; charset="UTF-8"';
    Response.Content := datamod.GetOrders(Request.QueryFields.values['AID']);
  end;
end;

procedure TWebModule1.UpdateOrders(Request: TWebRequest;
  Response: TWebResponse);
var
  jsobj: TJSONObject;
begin
  jsobj := TJSONObject.Create;
  if datamod.UpdateOrders(Request.QueryFields.values['Orders']) then
  begin
    jsobj.AddPair('UpdateStatus','Updated');
  end
  else
  begin
    jsobj.AddPair('UpdateStatus','Not updated');
  end;
  Response.ContentType := 'application/json; charset="UTF-8"';
  Response.Content := jsobj.ToString;
end;

procedure TWebModule1.WebModule1actCheckUserAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
    mtGet : CheckUser( Request, Response );
  else
    begin
      Response.StatusCode := 400;
      Response.SendResponse;
    end;
  end;
end;

procedure TWebModule1.WebModule1actGetOrdersAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := true;
  case Request.MethodType of
    mtGet : GetOrders( Request, Response );
    mtPut : UpdateOrders( Request, Response );
  else
    begin
      Response.StatusCode := 400;
      Response.SendResponse;
    end;
  end;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>DataSnap Server</title></head>' +
    '<body>DataSnap Server</body>' +
    '</html>';
end;

initialization
finalization
  Web.WebReq.FreeWebModules;

end.

