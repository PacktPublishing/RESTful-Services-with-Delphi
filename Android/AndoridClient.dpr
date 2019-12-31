program AndoridClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormMain in 'Forms\FormMain.pas' {frmMain},
  AndroidApi.Network in 'Units\AndroidApi.Network.pas',
  Androidapi.Misc in 'Units\Androidapi.Misc.pas',
  DataModule in 'Modules\DataModule.pas' {DataMod: TDataModule},
  UnitUtil in 'Units\UnitUtil.pas',
  BOUser in 'Units\BOUser.pas',
  BOOrders in 'Units\BOOrders.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDataMod, DataMod);
  Application.Run;
end.
