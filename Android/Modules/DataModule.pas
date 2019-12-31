unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.FMXUI.Async, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.IOUtils, REST.Types,
  System.JSON, UnitUtil, BOUser, BOOrders, System.Variants;

type
  TDataMod = class(TDataModule)
    FDSQLiteDB: TFDConnection;
    FDPhSQLiteDrvLnk: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDGUIxAsyncExecuteDialog: TFDGUIxAsyncExecuteDialog;
    FDQueryCreate: TFDQuery;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateAllTables;
    function UserLogin( var ALoggedUser : TLoggedUser ) : Boolean;
    function UserLoginLocal( var ALoggedUser : TLoggedUser ) : Boolean;
    procedure DoSynch(var AOrderList : TOrderList; AUserID: integer );
    procedure DSToList(var AOrderList : TOrderList);
    function ListNotSendToJson (AOrderList : TOrderList; var ACanSend : Boolean): TJsonArray;
    function SendOrders( AOrders : TJsonArray ): Boolean;
    procedure UpdateLocalDB( AOrders : TJsonArray);
    procedure UpdateLocalUser( ALoggedUser : TLoggedUser );
    procedure DeleteSendOrders(AOrderList : TOrderList);
    procedure JSONToDB( AOrders : TJsonArray );
    function GetMaxDetailID : integer;
  end;


var
  DataMod: TDataMod;

const
  sqlCreateUser  = 'CREATE TABLE IF NOT EXISTS User ' +
                   '(ID INT, ' +
                   ' UName text, '+
                   ' UPassword text); ';

  sqlCreatePackage = 'CREATE TABLE IF NOT EXISTS Package ' +
                     '(ID INT, ' +
                     ' CustName text, '+
                     ' CustSurname text, ' +
                     ' CustAddress text, ' +
                     ' CustPhone1 text, ' +
                     ' CustPhone2 text, ' +
                     ' Delivered text, ' +
                     ' TotalPrice text, ' +
                     ' DeiveredDT text, ' +
                     ' Send BOOL ); ';

  sqlCreatePackageDet = 'CREATE TABLE IF NOT EXISTS PackageDet ' +
                     '(ID INT, ' +
                     ' PackageID INT, '+
                     ' Quantity INT, ' +
                     ' PName text, ' +
                     ' PPrice real, ' +
                     ' PDescription text ); ';

  sqlSelectLocalUser = 'SELECT * FROM User WHERE UName = %s1 ' +
                       ' UPassword = %s2';

  sqlSelectMasterOrder = 'SELECT * FROM Package';

  sqlSelectDetailOrder = 'SELECT * FROM PackageDet WHERE PackageID = %s';

  sqlSelectNotSendOrders = ' SELECT * FROM Package WHERE Send = 0 ' ;

  sqlAddOrder       = 'INSERT INTO Package( ID, CustName, CustSurname, CustAddress, ' +
                      'CustPhone1, CustPhone2, Delivered, TotalPrice, Send  ) ' +
                      'VALUES ( :ID, :CustName, :CustSurname, :CustAddress, ' +
                      ' :CustPhone1, :CustPhone2, :Delivered, :TotalPrice, 0 ) ' ;

  sqlAddOrderDetail = 'INSERT INTO PackageDet( ID, PackageID, Quantity, PName, PPrice, PDescription ) ' +
                      'VALUES ( :ID, :PackageID, :Quantity, :PName, :PPrice, :PDescription ) ' ;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDataMod.CreateAllTables;
begin
  // create table User
  FDQueryCreate.SQL.Text := sqlCreateUser  ;
  try
    FDQueryCreate.ExecSQL;
  finally
    FDQueryCreate.Close;
  end;

  FDQueryCreate.SQL.Clear;

  // create table Package
  FDQueryCreate.SQL.Text := sqlCreatePackage  ;
  try
    FDQueryCreate.ExecSQL;
  finally
    FDQueryCreate.Close;
  end;

  FDQueryCreate.SQL.Clear;

  // create table PackageDet
  FDQueryCreate.SQL.Text := sqlCreatePackageDet  ;
  try
    FDQueryCreate.ExecSQL;
  finally
    FDQueryCreate.Close;
  end;
end;

function TDataMod.GetMaxDetailID: integer;
var
  strSQL : String;

begin
  result := 0;
  strSQL := 'SELECT MAX(ID) FROM PackageDet';
  result := StrToInt(VarToStrDef(FDSQLiteDB.ExecSQLScalar(strSQL),'0'));
end;

procedure TDataMod.JSONToDB(AOrders: TJsonArray);
var
  fJSONObj: TJSONObject;
  fJSonArray: TJsonArray;
  I: Integer;
  tmpMasterQry : TFDQuery;
  tmpDetailQry : TFDQuery;
  intDetailID : integer;
  intMasterID : String;
  j: Integer;
begin
  intDetailID := GetMaxDetailID + 1;

  tmpMasterQry :=  TFDQuery.Create(Self);
  tmpMasterQry.Connection := FDSQLiteDB;
  tmpDetailQry :=  TFDQuery.Create(Self);
  tmpDetailQry.Connection := FDSQLiteDB;

  try
    for I := 0 to AOrders.Count - 1 do
    begin
      fJSONObj :=  AOrders.Items[I] as TJSONObject;

      tmpMasterQry.SQL.Text := sqlAddOrder;
      intMasterID := fJSONObj.GetValue( 'PackageID' ).Value;
      tmpMasterQry.Params.ParamByName('ID').Value := StrToInt(intMasterID);
      tmpMasterQry.Params.ParamByName('CustName').Value := fJSONObj.GetValue( 'CustName' ).Value;
      tmpMasterQry.Params.ParamByName('CustSurname').Value := fJSONObj.GetValue( 'CustSurname' ).Value;
      tmpMasterQry.Params.ParamByName('CustAddress').Value := fJSONObj.GetValue( 'CustAddress' ).Value;
      tmpMasterQry.Params.ParamByName('CustPhone1').Value := fJSONObj.GetValue( 'CustPhone1' ).Value;
      tmpMasterQry.Params.ParamByName('CustPhone2').Value := fJSONObj.GetValue( 'CustPhone2' ).Value;
      tmpMasterQry.Params.ParamByName('Delivered').Value := 'Assigned';
      tmpMasterQry.Params.ParamByName('TotalPrice').Value := fJSONObj.GetValue( 'TotalPrice' ).Value;
      tmpMasterQry.Prepare;
      tmpMasterQry.ExecSQL;
      tmpMasterQry.SQL.Clear;

      fJSonArray := fJSONObj.GetValue('Products') as TJSONArray;
      for j := 0 to fJSonArray.Count - 1 do
      begin
        fJSONObj :=  fJSonArray.Items[j] as TJSONObject;

        tmpDetailQry.SQL.Text := sqlAddOrderDetail;
        tmpDetailQry.Params.ParamByName('ID').Value := intDetailID;
        tmpDetailQry.Params.ParamByName('PackageID').Value := StrToInt(intMasterID);
        tmpDetailQry.Params.ParamByName('Quantity').Value := StrToInt(fJSONObj.GetValue( 'Quantity' ).Value);
        tmpDetailQry.Params.ParamByName('PName').Value := fJSONObj.GetValue( 'PName' ).Value;
        tmpDetailQry.Params.ParamByName('PPrice').Value := fJSONObj.GetValue( 'PPrice' ).Value;
        tmpDetailQry.Params.ParamByName('PDescription').Value := fJSONObj.GetValue( 'PDescription' ).Value;
        tmpDetailQry.Prepare;
        tmpDetailQry.ExecSQL;
        tmpDetailQry.SQL.Clear;
      end;
    end;
  finally
    tmpMasterQry.Free;
    tmpDetailQry.Free;
  end;
end;

procedure TDataMod.DataModuleCreate(Sender: TObject);
begin
{$IF DEFINED(ANDROID)}
  FDSQLiteDB.Params.Database := TPath.GetDocumentsPath + PathDelim + 'ClientAndroid.db' ;
  FDSQLiteDB.Params.Values['LockingMode'] := 'Normal';
  CreateAllTables;
{$ENDIF}
end;

procedure TDataMod.DeleteSendOrders(AOrderList : TOrderList);
var
  strSQL : String;
  tmpQry : TFDQuery;
  strIDList : String;
  I: Integer;
begin
  strIDList := '';
  for I := 0 to AOrderList.Count - 1 do
  begin
    if AOrderList[i].Send then
    begin
      strIDList := strIDList + InttoStr(AOrderList[i].ID) + ',';
    end;
  end;
  // delete last comma value
  Delete(strIDList,length(strIDList),1);

  tmpQry := TFDQuery.Create(Self);
  tmpQry.Connection := FDSQLiteDB;
  try
    strSQL := ' DELETE FROM Package ' +
            ' WHERE ID IN( ' + strIDList + ' )';
    tmpQry.ExecSQL(strSQL);

    strSQL :=' DELETE FROM PackageDet ' +
            ' WHERE PackageID IN( ' + strIDList + ' )';
    tmpQry.ExecSQL(strSQL);
  finally
    tmpQry.Free;
  end;
end;

procedure TDataMod.DoSynch(var AOrderList : TOrderList; AUserID: integer );
var
  fJSONArray: TJSONArray;
  bolCanSend : boolean;
  strRestServer : String;
  fJSONArrayRecive: TJSONArray;
  fJSONObj, fJSONObj1: TJSONObject;
  sqlDelete : String;
begin
  // first check are there processed orders to be send
  AOrderList.Clear;
  DSToList(AOrderList);
  bolCanSend := False;
  fJSONArray := ListNotSendToJson(AOrderList, bolCanSend);

  if bolCanSend then
  begin
    // Json List is not empty - we have orders to be send
    if SendOrders(fJSONArray) then
    begin
      // Orders send ok. Update Local db
      UpdateLocalDB(fJSONArray);
    end
    else
    begin
      // we didnt send data dont load new one.
      exit;
    end;
  end;

  //Delete all data (we dont have items which are delivered and not send !!!
  sqlDelete := ' DROP TABLE Package ' ;
  FDSQLiteDB.ExecSQL(sqlDelete);
  sqlDelete := ' DROP TABLE PackageDet ' ;
  FDSQLiteDB.ExecSQL(sqlDelete);
  CreateAllTables;

  //Get orders from Server
  LoadIPAddress(strRestServer);
  RESTClient.BaseURL := strRestServer;
  RESTRequest.Resource := 'datasnap/rest/TSM/GetOrders/' + IntToStr(AUserID);
  RESTRequest.Method   := TRESTRequestMethod.rmGET;
  RESTRequest.Response := RESTResponse;
  try
    RESTRequest.Execute;

    // we got proper response from server update local database
    if RESTRequest.Response.StatusCode = 200 then
    begin
      fJSONObj := TJSonObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
      fJSONArray := fJSONObj.GetValue('result') as TJSONArray;
      fJSONObj1 := fJSONArray.Items[0] as TJSONObject;
      fJSONArrayRecive := fJSONObj1.GetValue('Packages') as TJSONArray;

      JSONToDB(fJSONArrayRecive);
    end;
  finally
    //after we saved orders data in local database and get new orders update list of orders
    AOrderList.Clear;
    DSToList(AOrderList);
  end;
end;

procedure TDataMod.DSToList(var AOrderList: TOrderList);
var
  tmpMasterQry : TFDQuery;
  tmpDetailQry : TFDQuery;
  tmpOrder : TOrder;
  tmpOrderDet : TOrderDet;
  strSQL : String;
begin
  AOrderList.Clear;
  tmpMasterQry := TFDQuery.Create(Self);
  tmpMasterQry.Connection := FDSQLiteDB;
  tmpDetailQry := TFDQuery.Create(Self);
  tmpDetailQry.Connection := FDSQLiteDB;
  try
    tmpMasterQry.Open(sqlSelectMasterOrder);
    while not tmpMasterQry.Eof do
    begin
      // adding master order data to list
      tmpOrder := TOrder.Create;

      tmpOrder.ID := tmpMasterQry.FieldByName('ID').AsInteger;
      tmpOrder.CustName := tmpMasterQry.FieldByName('CustName').AsString;
      tmpOrder.CustSurname := tmpMasterQry.FieldByName('CustSurname').AsString;
      tmpOrder.CustAddress := tmpMasterQry.FieldByName('CustAddress').AsString;
      tmpOrder.CustPhone1 := tmpMasterQry.FieldByName('CustPhone1').AsString;
      tmpOrder.CustPhone2 := tmpMasterQry.FieldByName('CustPhone2').AsString;
      tmpOrder.Delivered := tmpMasterQry.FieldByName('Delivered').AsString;
      tmpOrder.TotalPrice := tmpMasterQry.FieldByName('TotalPrice').AsString;
      tmpOrder.DeiveredDT := tmpMasterQry.FieldByName('DeiveredDT').AsString;
      tmpOrder.Send := tmpMasterQry.FieldByName('Send').AsBoolean;

      AOrderList.Add(tmpOrder);

      strSQL := Format(sqlSelectDetailOrder, [tmpMasterQry.FieldByName('ID').AsString]);
      try
        tmpDetailQry.SQL.Clear;
        tmpDetailQry.Open(strSQL);
        while not tmpDetailQry.Eof do
        begin
          tmpOrderDet := TOrderDet.Create;

          tmpOrderDet.ID := tmpDetailQry.FieldByName('ID').AsInteger;
          tmpOrderDet.PackageID := tmpDetailQry.FieldByName('PackageID').AsInteger;
          tmpOrderDet.Quantity := tmpDetailQry.FieldByName('Quantity').AsInteger;
          tmpOrderDet.PName := tmpDetailQry.FieldByName('PName').AsString;
          tmpOrderDet.PPrice := tmpDetailQry.FieldByName('PPrice').AsFloat;
          tmpOrderDet.PDescription := tmpDetailQry.FieldByName('PDescription').AsString;

          tmpOrder.DetailList.Add(tmpOrderDet);

          tmpDetailQry.Next;
        end;
      finally
        tmpDetailQry.Close;
      end;
      tmpMasterQry.Next;
    end;
  finally
    tmpMasterQry.Close;
    tmpMasterQry.Free;
    tmpDetailQry.Free;
  end;
end;

function TDataMod.SendOrders( AOrders : TJsonArray ): Boolean;
var
  strRestServer : String;
  fJsonObject : TJSONObject;
begin
  Result := False;
  LoadIPAddress(strRestServer);
  RESTClient.BaseURL := strRestServer;
  RESTRequest.Resource := 'datasnap/rest/TSM/GetOrders/';
  RESTRequest.Method   := TRESTRequestMethod.rmPOST;
  RESTRequest.Response := RESTResponse;
  try
    fJsonObject := TJSONObject.Create;
    fJsonObject.AddPair('Orders',AOrders);
    RESTRequest.Body.Add(fJsonObject);
    RESTRequest.Execute;

    // we got proper response from server update local database
    if RESTRequest.Response.StatusCode = 200 then
    begin
      Result := True;
    end;

  except on E: Exception do
    Result := False;
  end;
end;

function TDataMod.ListNotSendToJson(AOrderList: TOrderList; var ACanSend : Boolean) : TJsonArray;
var
  i: Integer;
  fJSONObj: TJSONObject;
begin
  Result := TJsonArray.Create;
  try
    for i := 0 to AOrderList.Count - 1 do
    begin
      if (not AOrderList.Items[i].Send) and (AOrderList.Items[i].Delivered = 'Delivered') then
      begin
        // add to json array orders which are not send and which are delivered
        result.Add(AOrderList.Items[i].OrderToJSON);
      end;
    end;
  except on E: Exception do
    // process error in creating json array
    begin
      ACanSend := false;
      Exit;
    end;
  end;

  ACanSend := (Result.Count > 0);
end;

procedure TDataMod.UpdateLocalDB(AOrders: TJsonArray);
var
  strSQL : String;
  strSQLWhere: String;
  tmpQry : TFDQuery;
  i : integer;
begin
  strSQL := 'UPDATE Package '+
            ' SET Send = 1 , ' +
            ' Delivered = ' + quotedStr(TJsonObject(AOrders.Items[i]).GetValue('Delivered').Value) +
            ' WHERE ID IN ( ' ;
  strSQLWhere := '';

  for I := 0 to AOrders.Count - 1 do
  begin
    strSQLWhere := strSQLWhere + (TJsonObject(AOrders.Items[i]).GetValue('PackageID').Value) + ',';
  end;

  Delete(strSQLWhere,length(strSQLWhere),1);
  strSQLWhere := strSQLWhere + ')';
  strSQL := strSQL + strSQLWhere;

  tmpQry := TFDQuery.Create(Self);
  tmpQry.Connection := FDSQLiteDB;
  try
    tmpQry.ExecSQL(strSQL);
  finally
    tmpQry.Free;
  end;
end;

procedure TDataMod.UpdateLocalUser(ALoggedUser: TLoggedUser);
var
  strSQL : String;
  tmpQry : TFDQuery;
begin
  strSQL := 'SELECT * FROM User';
  tmpQry := TFDQuery.Create(Nil);
  tmpQry.Connection := FDSQLiteDB;
  try
    tmpQry.Open(strSQL);
    if (tmpQry.RecordCount > 0) then
    begin
      //user exist in local database - update
      strSQL := 'UPDATE User ' +
                ' SET ID = ' + IntToStr(ALoggedUser.ID) + ',' +
                '     UName = ' + QuotedStr(ALoggedUser.Username) + ',' +
                '     UPassword = ' + QuotedStr(ALoggedUser.Password) +
                '     WHERE ID =  ' +  IntToStr(ALoggedUser.ID) ;
    end
    else
    begin
      //no user in local database - insert
      strSQL := 'INSERT INTO User ( ID, UName, UPassword) ' +
                'VALUES ( ' + IntToStr(ALoggedUser.ID) + ',' +
                QuotedStr(ALoggedUser.Username) + ',' +
                QuotedStr(ALoggedUser.Password) + ' ) ';
    end;

    tmpQry.Close;
    tmpQry.SQL.Clear;
    tmpQry.ExecSQL(strSQL);
  finally
    tmpQry.Free;
  end;
end;

function TDataMod.UserLogin(var ALoggedUser : TLoggedUser ) : Boolean;
var
  fJSONArray: TJSONArray;
  fJSONObj: TJSONObject;
  fJSonValue: TJSonValue;
  strRestServer : String;
begin
  Result := False;

  LoadIPAddress(strRestServer);
  RESTClient.BaseURL := strRestServer;
  RESTRequest.Resource := 'datasnap/rest/TSM/CheckUser/' + ALoggedUser.Username + '/' + ALoggedUser.Password;
  RESTRequest.Method   := TRESTRequestMethod.rmGet;
  RESTRequest.Response := RESTResponse;
  try
    RESTRequest.Execute;

    // we got proper response from server
    if RESTRequest.Response.StatusCode = 200 then
    begin
      fJSonValue := TJSonObject.ParseJSONValue(RESTResponse.Content);
      fJSONArray := fJSonValue.GetValue<TJSONArray>('result');
      fJSONObj := fJSONArray.Items[0] as TJsonObject;
      ALoggedUser.ID := StrToInt(fJSONObj.Values['ID'].Value);
      // returned value(ID) > 0 if it's valid user
      if (ALoggedUser.ID  > 0) then
      begin
        Result := True;
        UpdateLocalUser(ALoggedUser);
        exit;
      end;
    end;
  except on E: Exception do
    result := False;
  end;
end;

function TDataMod.UserLoginLocal(var ALoggedUser: TLoggedUser): Boolean;
var
  tmpQry : TFDQuery;
  strSQL : String;
begin
  result := False;
  tmpQry := TFDQuery.Create(Self);
  tmpQry.Connection := FDSQLiteDB;
  try
    strSQL := Format(sqlSelectLocalUser, [ALoggedUser.Username, ALoggedUser.Password]);
    tmpQry.SQL.Add(strSQL);
    tmpQry.Open;
    if (tmpQry.RecordCount - 1) > 0 then
    begin
      Result := True;
      ALoggedUser.ID := tmpQry.FieldByName('ID').AsInteger;
    end;
  finally
    tmpQry.Free;
  end;
end;

end.
