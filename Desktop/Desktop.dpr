program Desktop;

uses
  Vcl.Forms,
  FormOrders in 'Forms\FormOrders.pas' {frmMain},
  FormLogin in 'Forms\FormLogin.pas' {frmLogin},
  ModuleData in 'Modules\ModuleData.pas' {DM: TDataModule},
  UnitUtil in 'Units\UnitUtil.pas',
  FormUsers in 'Forms\FormUsers.pas' {frmUsers},
  FormProducts in 'Forms\FormProducts.pas' {frmProducts},
  FormNewOrder in 'Forms\FormNewOrder.pas' {frmNewOrder},
  FormAssignOrders in 'Forms\FormAssignOrders.pas' {frmAssignOrders};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  if ShowUserLogin then
  begin
    Application.CreateForm(TfrmMain, frmMain);
  end
  else
  begin
    Application.Terminate;
  end;
  Application.Run;
end.
