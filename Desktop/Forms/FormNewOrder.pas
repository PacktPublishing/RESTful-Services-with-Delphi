unit FormNewOrder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  ModuleData, Vcl.Grids;

type
  TsgProducts = class(TStringGrid);

  TfrmNewOrder = class(TForm)
    panBottom: TPanel;
    btnSaveClose: TButton;
    btnCancel: TButton;
    panCustomerHeader: TPanel;
    lblCustomers: TLabel;
    panOrderDetails: TPanel;
    lblCustName: TLabel;
    edtCustName: TEdit;
    lblCustSurname: TLabel;
    edtCustSurname: TEdit;
    lblCustAddress: TLabel;
    edtCustAddress: TEdit;
    lblCustPhone1: TLabel;
    lblCustPhone2: TLabel;
    edtCustPhone1: TEdit;
    edtCustPhone2: TEdit;
    panProducts: TPanel;
    lblProducts: TLabel;
    lblProductQty: TLabel;
    edtProductQty: TEdit;
    btnAddProduct: TButton;
    cboxProducts: TComboBox;
    sgProducts: TStringGrid;
    btnDeleteProduct: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveCloseClick(Sender: TObject);
    procedure btnAddProductClick(Sender: TObject);
    procedure btnDeleteProductClick(Sender: TObject);
  private
    procedure FillProductCombo;
  public
    { Public declarations }
  end;

  procedure ShowNewOrder;

implementation

{$R *.dfm}

procedure ShowNewOrder;
var
  frmNewOrder: TfrmNewOrder;
begin
  DM.tableProducts.Active := true;
  frmNewOrder := TfrmNewOrder.Create(nil);
  try
    frmNewOrder.ShowModal;
  finally
    DM.tableProducts.Active := false;
    FreeAndNil(frmNewOrder);
  end;
end;

procedure TfrmNewOrder.btnAddProductClick(Sender: TObject);
begin
  if edtProductQty.Text = '' then
  begin
    MessageDlg('Enter quuantity!', mtError, [mbOK], 0);
    edtProductQty.SetFocus;
    exit;
  end;

  if sgProducts.Cells[0,1] <> '' then
  begin
    sgProducts.RowCount := sgProducts.RowCount + 1;
  end;

  sgProducts.Cells[0,sgProducts.RowCount - 1] := cboxProducts.Text;
  sgProducts.Cells[1,sgProducts.RowCount - 1] := edtProductQty.Text;
  sgProducts.Objects[1,sgProducts.RowCount - 1] := cboxProducts.Items.Objects[cboxProducts.ItemIndex];
  edtProductQty.Text := '';
end;

procedure TfrmNewOrder.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNewOrder.btnDeleteProductClick(Sender: TObject);
var
  MyStringGrid: TsgProducts;
begin
  MyStringGrid := TsgProducts(sgProducts);
  MyStringGrid.DeleteRow(sgProducts.Row);

  if sgProducts.RowCount = 1 then
  begin
    sgProducts.RowCount := sgProducts.RowCount + 1;
    sgProducts.FixedRows := 1;
    sgProducts.Cells[0,0] := 'Product Name';
    sgProducts.Cells[1,0] := 'Product Quantity';
    sgProducts.Cells[0,1] := '';
    sgProducts.Cells[1,1] := '';
  end;

end;

procedure TfrmNewOrder.btnSaveCloseClick(Sender: TObject);
var
  intLastId, i: integer;
  totalPrice : integer;
begin
  if sgProducts.Cells[0,1] = '' then
  begin
    MessageDlg('Must have products assigned to order!', mtError, [mbOK], 0);
    cboxProducts.SetFocus;
    exit;
  end;

  if (edtCustName.Text = '') or
     (edtCustSurname.Text = '') or
     (edtCustAddress.Text = '') or
     (edtCustPhone1.Text = '' ) then
  begin
    MessageDlg('Missing customer info!', mtError, [mbOK], 0);
    edtCustName.SetFocus;
    exit;
  end;

  DM.qryOrders.Open;
  DM.qryOrders.Append;
  DM.qryOrders.FieldByName('CustName').AsString := edtCustName.Text;
  DM.qryOrders.FieldByName('CustSurname').AsString := edtCustSurname.Text;
  DM.qryOrders.FieldByName('CustAddress').AsString := edtCustAddress.Text;
  DM.qryOrders.FieldByName('CustPhone1').AsString := edtCustPhone1.Text;
  DM.qryOrders.FieldByName('CreatinoDate').AsDateTime := now;
  DM.qryOrders.FieldByName('Delivered').AsString := 'Created';
  DM.qryOrders.Post;
  intLastId := DM.GetLastPackageID;
  DM.qryOrders.Close;

  DM.qryOrderDetails.Open('Select * from PackageDet');
  totalPrice := 0;
  for I := 1 to sgProducts.RowCount - 1 do
  begin
    DM.qryOrderDetails.Append;
    DM.qryOrderDetails.FieldByName('PackageID').AsInteger := intLastId;
    DM.qryOrderDetails.FieldByName('ProductID').AsInteger := Integer(sgProducts.Objects[1,i]);
    DM.qryOrderDetails.FieldByName('Quantity').AsInteger := sgProducts.Cells[1,i].ToInteger;
    totalPrice := totalPrice + DM.GetProductPrice(Integer(sgProducts.Objects[1,i])) * sgProducts.Cells[1,i].ToInteger;
    DM.qryOrderDetails.Post;
  end;

  DM.qryOrders.SQL.Clear;
  DM.qryOrders.SQL.Add('Update Package set TotalPrice = ' + inttostr(totalPrice) + ' where ID = ' + inttostr(intLastId));
  DM.qryOrders.ExecSQL;

  Close;
end;

procedure TfrmNewOrder.FillProductCombo;
begin
  with DM do
  begin
    tableProducts.First;
    while not tableProducts.Eof do
    begin
      cboxProducts.AddItem(tableProducts.FieldByName('PName').AsString, TObject(tableProducts.FieldByName('ID').AsInteger));
      tableProducts.Next;
    end;
  end;
  cboxProducts.ItemIndex := 0;
end;

procedure TfrmNewOrder.FormCreate(Sender: TObject);
begin
  FillProductCombo;
  sgProducts.Cells[0,0] := 'Product Name';
  sgProducts.Cells[1,0] := 'Product Quantity';
end;

end.
