unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCBase,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  BOSettings, Vcl.Dialogs, FireDAC.DApt, System.JSON, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  Data.DBXJSONCommon;

type
  TDataMod = class(TDataModule)
    DatabaseConnection: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
  private

  public
    function Init(ASettings : TSettings): boolean;
    function GetUserID(AUser, APass: String):String;
    function GetOrders(AID:String):TJSONArray;
    function UpdateOrders(AOrders : TJSONObject):boolean;
  end;

var
  DataMod: TDataMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataMod }

function TDataMod.GetOrders(AID: String): TJSONArray;
var
  ssql : String;
  dsResultSet, dsResultSetDetail: TDataSet;
  JSONObj : TJSONObject;
  detailJSONObj : TJSONObject;
  detailJsonArray : TJSONArray;
begin
  result := TJSONArray.Create;
  ssql := Format('Select * from PACKAGE where Delivered = ' +
                  QuotedStr('Assigned')  +
                 ' and ' +
                 ' CourierID = %0:s ', [QuotedStr(AID)]);
  dsResultSet := TDataSet.Create(Self);
  try
    if DatabaseConnection.ExecSQL(ssql, dsResultSet) > 0 then
    begin
      dsResultSet.First;
      while not dsResultSet.Eof do
      begin
        JSONObj := TJSONObject.Create;
        JSONObj.AddPair('PackageID',dsResultSet.FieldByName('ID').AsString);
        JSONObj.AddPair('CustName',dsResultSet.FieldByName('CustName').AsString);
        JSONObj.AddPair('CustSurname',dsResultSet.FieldByName('CustSurname').AsString);
        JSONObj.AddPair('CustAddress',dsResultSet.FieldByName('CustAddress').AsString);
        JSONObj.AddPair('CustPhone1',dsResultSet.FieldByName('CustPhone1').AsString);
        JSONObj.AddPair('CustPhone2',dsResultSet.FieldByName('CustPhone2').AsString);
        JSONObj.AddPair('TotalPrice',dsResultSet.FieldByName('TotalPrice').AsString);

        ssql := '';
        ssql := 'Select D.Quantity, P.PName, P.PPrice, P.PDescription from PackageDet D ' +
                'Join ' +
                'Products P on P.ID = D.ProductID ' +
                'where D.PackageID = ' + dsResultSet.FieldByName('ID').AsString;
        dsResultSetDetail := TDataSet.Create(Self);
        try
          if DatabaseConnection.ExecSQL(ssql, dsResultSetDetail) > 0 then
          begin
            dsResultSetDetail.First;
            detailJsonArray := TJSONArray.Create;
            while not dsResultSetDetail.Eof do
            begin
              detailJSONObj := TJSONObject.Create;
              detailJSONObj.AddPair('Quantity',dsResultSetDetail.FieldByName('Quantity').AsString);
              detailJSONObj.AddPair('PName',dsResultSetDetail.FieldByName('PName').AsString);
              detailJSONObj.AddPair('PPrice',dsResultSetDetail.FieldByName('PPrice').AsString);
              detailJSONObj.AddPair('PDescription',dsResultSetDetail.FieldByName('PDescription').AsString);
              dsResultSetDetail.Next;
              detailJsonArray.AddElement(detailJSONObj);
            end;
          end;
        finally
          FreeAndNil(dsResultSetDetail);
        end;
        dsResultSet.Next;

        JSONObj.AddPair('Products',detailJsonArray);
        result.AddElement(JSONObj);
      end;
    end;
  finally
    FreeAndNil(dsResultSet);
  end;

end;

function TDataMod.GetUserID(AUser, APass: String): String;
var
  ssql : String;
  dsResultSet: TDataSet;
begin
  result := '0';
  ssql := Format('Select * from USERS where URole = + ' +
                  QuotedStr('courier')  +
                 ' and ' +
                 'UName = %0:s and UPassword = %1:s', [QuotedStr(AUser), QuotedStr(APass)]);
  dsResultSet := TDataSet.Create(Self);
  try
    if DatabaseConnection.ExecSQL(ssql, dsResultSet) = 1 then
    begin
      result := dsResultSet.FieldByName('ID').AsString;
    end
    else
    begin
      result := '0';
    end;
  finally
    FreeAndNil(dsResultSet);
  end;
end;

function TDataMod.Init(ASettings: TSettings): boolean;
begin
  result := false;
  TrueBoolStrs := ['Yes'];
  FalseBoolStrs := ['No'];
  DatabaseConnection.Params.clear;

  with DatabaseConnection.Params do
  begin
    Add('Database=' + ASettings.DBName);
    Add('Server=' + ASettings.DBServer);
    Add('OSAuthent=' + BoolToStr(ASettings.OSAuth, True));
    if ASettings.DBUname <> '' then
    begin
      Add('User_Name' + ASettings.DBUname);
    end;

    if ASettings.DBPwd <> '' then
    begin
      Add('Password' + ASettings.DBPwd);
    end;

    Add('DriverID=MSSQL');
  end;

  if DatabaseConnection.Connected then
  begin
    DatabaseConnection.Connected := false;
  end;

  try
    DatabaseConnection.Connected := true;
    result := true;
  except on E: Exception do
    ShowMessage('Error Connecting to Database. Check Settings !');
  end;
end;

function TDataMod.UpdateOrders(AOrders: TJSONObject): boolean;
var
  JSONArr : TJSONArray;
  JSONObj : TJSONObject;
  fJSonValue: TJSonValue;
  i : integer;
  ssql : String;
  qry : TFDQuery;
  frmSett : TFormatSettings;
begin
  result := false;
  if assigned(AOrders.Values['Orders']) then
  begin
    JSONArr := TJSONArray(AOrders.Values['Orders']);
  end
  else
  begin
    exit;
  end;

  try
    for I := 0 to JSONArr.Count - 1 do
    begin
      JSONObj := TJSONObject(JSONArr.Items[i]);

      qry := TFDQuery.Create(Self);
      qry.Connection :=  DatabaseConnection;
      qry.UpdateOptions.RequestLive := true;
      try
        qry.SQL.Add(' update Package ');
        qry.SQL.Add(' set Delivered = :Delivered , ');
        qry.SQL.Add('  DeliveredDT = :DeliveredDT  ');
        qry.SQL.Add(' where ID = :PackageID  ');

        qry.ParamByName('Delivered').Value := JSONObj.GetValue('Delivered').Value;

        frmSett := TFormatSettings.Create;
        frmSett.DateSeparator := '-';
        frmSett.TimeSeparator := ':';
        frmSett.ShortDateFormat := 'YYYY-MM-DD';
        frmSett.LongDateFormat := 'YYYY-MM-DD';
        frmSett.ShortTimeFormat := 'HH:MM:SS';
        frmSett.LongTimeFormat := 'HH:MM:SS';
        qry.ParamByName('DeliveredDT').AsDateTime := StrToDateTime(JSONObj.GetValue('DeliveredDT').Value,frmSett);
        qry.ParamByName('PackageID').Value := JSONObj.GetValue('PackageID').Value;
        qry.ExecSQL;
      finally
        qry.Free;
      end;
    end;
  finally
    result := true;
  end;
end;

end.
