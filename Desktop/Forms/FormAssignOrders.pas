unit FormAssignOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ModuleData, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmAssignOrders = class(TForm)
    panTop: TPanel;
    panClient: TPanel;
    gridOrders: TDBGrid;
    lblCustomers: TLabel;
    cboxCuriers: TComboBox;
    btnAssign: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAssignClick(Sender: TObject);
  private
    procedure FillCuriersCombo;
  public
    { Public declarations }
  end;

  procedure ShowAssignOrder;

implementation

{$R *.dfm}

procedure ShowAssignOrder;
var
  frmAssignOrders: TfrmAssignOrders;
begin
  DM.qryOrders.Active := False;
  DM.qryOrders.SQL.Clear;
  DM.qryOrders.SQL.Add('select * from Package where Delivered = '+QuotedStr('Created'));
  DM.qryOrders.Active := True;

  frmAssignOrders := TfrmAssignOrders.Create(nil);
  try
    frmAssignOrders.ShowModal;
  finally
    DM.qryOrders.Active := False;
    FreeAndNil(frmAssignOrders);
  end;
end;

procedure TfrmAssignOrders.btnAssignClick(Sender: TObject);
var
  packageID : integer;
begin
  packageID := DM.qryOrders.FieldByName('ID').AsInteger;

  DM.qryOrders.Active := False;
  DM.qryOrders.SQL.Clear;
  DM.qryOrders.SQL.Add('Update Package set Delivered = ' + QuotedStr('Assigned') +
                                           ', CourierID = ' + inttostr(Integer(cboxCuriers.Items.Objects[cboxCuriers.ItemIndex])) +
                                           ' where ID = ' + inttostr(packageID));
  DM.qryOrders.ExecSQL;

  DM.qryOrders.Active := False;
  DM.qryOrders.SQL.Clear;
  DM.qryOrders.SQL.Add('select * from Package where Delivered = '+QuotedStr('Created'));
  DM.qryOrders.Active := True;
end;

procedure TfrmAssignOrders.FillCuriersCombo;
begin
  with DM do
  begin
    tableUsers.Open;
    tableUsers.First;
    while not tableUsers.Eof do
    begin
      if tableUsers.FieldByName('URole').AsString = 'courier' then
      begin
        cboxCuriers.AddItem(tableUsers.FieldByName('UName').AsString, TObject(tableUsers.FieldByName('ID').AsInteger));
      end;
      tableUsers.Next;
    end;
    tableUsers.Close;
  end;
  cboxCuriers.ItemIndex := 0;
end;

procedure TfrmAssignOrders.FormCreate(Sender: TObject);
begin
  FillCuriersCombo;
end;

end.
