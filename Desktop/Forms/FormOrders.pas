unit FormOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Menus, Vcl.ExtCtrls, ModuleData, Vcl.StdCtrls, FireDAC.VCLUI.ConnEdit, UnitUtil, FormUsers,
  FormProducts, FormNewOrder, FormAssignOrders;

type
  TfrmMain = class(TForm)
    panTop: TPanel;
    panMaster: TPanel;
    gridOrders: TDBGrid;
    panOrderDetails: TPanel;
    panMasterCaption: TPanel;
    panDetailsCaption: TPanel;
    gridOrderDetails: TDBGrid;
    lblOrders: TLabel;
    lblOrderDetails: TLabel;
    btnNewOrder: TButton;
    btnProducts: TButton;
    btnUsers: TButton;
    btnDBSettings: TButton;
    panBottom: TPanel;
    btnExit: TButton;
    btnAssignOrder: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnDBSettingsClick(Sender: TObject);
    procedure btnUsersClick(Sender: TObject);
    procedure btnProductsClick(Sender: TObject);
    procedure btnNewOrderClick(Sender: TObject);
    procedure btnAssignOrderClick(Sender: TObject);
  private
    procedure LoadData;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnAssignOrderClick(Sender: TObject);
begin
  ShowAssignOrder;
  LoadData;
end;

procedure TfrmMain.btnDBSettingsClick(Sender: TObject);
var
  FDConnEditor : TfrmFDGUIxFormsConnEdit;
begin
  if DM.DBConnection.Connected then
    DM.DBConnection.Connected := False;

  FDConnEditor := TfrmFDGUIxFormsConnEdit.Create(Self);
  try
    FDConnEditor.Execute(DM.DBConnection, 'Database Connection editor', nil);
  finally
    FDConnEditor.Free;
    SaveConnString(DM.DBConnection.ConnectionString);
  end;

  try
    DM.DBConnection.Connected := True;
    LoadData;
  except on E: Exception do
    begin
      MessageDlg('Not connected to database!'#13#10'Check connection definition file.', mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;

end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnNewOrderClick(Sender: TObject);
begin
  ShowNewOrder;
  LoadData;
end;

procedure TfrmMain.btnProductsClick(Sender: TObject);
begin
  showProducts;
end;

procedure TfrmMain.btnUsersClick(Sender: TObject);
begin
  ShowUsers;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadData;
end;

procedure TfrmMain.LoadData;
begin
  DM.qryOrders.SQL.Clear;
  DM.qryOrders.SQL.Add('select * from Package');
  DM.qryOrders.Active := True;
end;

end.
