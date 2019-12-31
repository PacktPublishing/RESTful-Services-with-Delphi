unit ModuleData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.VCLUI.ConnEdit, UnitUtil, Vcl.Dialogs, VCL.Forms, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    DBConnection: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
    qryOrders: TFDQuery;
    dsOrders: TDataSource;
    qryOrderDetails: TFDQuery;
    dsOrderDetails: TDataSource;
    tableUsers: TFDTable;
    tableUsersUName: TWideStringField;
    tableUsersUPassword: TWideStringField;
    tableUsersURole: TWideStringField;
    dsUsers: TDataSource;
    tableUsersID: TFDAutoIncField;
    tableProducts: TFDTable;
    dsProducts: TDataSource;
    tableProductsID: TFDAutoIncField;
    tableProductsPName: TWideStringField;
    tableProductsPPrice: TCurrencyField;
    tableProductsPQuantity: TIntegerField;
    tableProductsPDescription: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qryOrdersAfterScroll(DataSet: TDataSet);
    procedure qryOrdersAfterClose(DataSet: TDataSet);
  private
    { Private declarations }
  public
    function UserLogin( AUsername, APassword : String ) : Boolean;
    function GetLastPackageID: integer;
    function GetProductPrice( AID: integer) : Integer;
  end;

var
  DM: TDM;

const
  roleOperator = 'Operator';

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
var
  FDConnEditor : TfrmFDGUIxFormsConnEdit;
  strConnString : String;
begin
  if DBConnection.Connected then
    DBConnection.Connected := False;

  if not LoadConnString( strConnString ) then
  begin
    FDConnEditor := TfrmFDGUIxFormsConnEdit.Create(Self);
    try
      FDConnEditor.Execute(DBConnection, 'Database Connection editor', nil);
    finally
      FDConnEditor.Free;
      SaveConnString(DBConnection.ConnectionString);
    end;
  end
  else
  begin
    DBConnection.ConnectionString := strConnString;
  end;

  try
    DBConnection.Connected := True;
  except on E: Exception do
    begin
      MessageDlg('Not connected to database!'#13#10'Check connection definition file.', mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;

end;

function TDM.GetLastPackageID: integer;
begin
  Result := Integer(DBConnection.GetLastAutoGenValue('ID'));
end;

function TDM.GetProductPrice(AID: integer): Integer;
begin
  Result := 0;
  Result := Integer(DBConnection.ExecSQLScalar('Select PPrice from Products where ID = ' + inttostr(AID)));
end;

procedure TDM.qryOrdersAfterClose(DataSet: TDataSet);
begin
  qryOrders.SQL.Clear;
  qryOrders.SQL.Add('select * from Package');
end;

procedure TDM.qryOrdersAfterScroll(DataSet: TDataSet);
var
  strSQL : String;
begin
  qryOrderDetails.Close;
  qryOrderDetails.SQL.Clear;
  strSQL := ' select m.ID, p.PName, d.Quantity, d.PackageID from Package m ' +
            ' join PackageDet d on d.PackageID = m.ID ' +
            ' join Products p on p.ID = d.ProductID ' +
            ' where d.PackageID = ' + qryOrders.FieldByName('ID').AsString;
  qryOrderDetails.Open(strSQL);
end;

function TDM.UserLogin(AUsername, APassword: String): Boolean;
var
  strSQL : String;
begin
  Result := False;
  strSQL := ' SELECT COUNT(UName) from Users ' +
            ' WHERE UName = ' + QuotedStr( AUsername ) +
            ' AND   UPassword = ' + QuotedStr( APassword ) +
            ' AND URole = ' + QuotedStr( roleOperator );

  Result := DBConnection.ExecSQLScalar(strSQL) = 1;
end;

end.
