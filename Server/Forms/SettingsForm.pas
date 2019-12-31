unit SettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BOSettings;

type
  TFormSettings = class(TForm)
    panBottom: TPanel;
    panServer: TPanel;
    panDatabase: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    lblServerSettings: TLabel;
    edtServerPort: TEdit;
    lblServerPort: TLabel;
    chkBoxServerAutostart: TCheckBox;
    lblDatabaseSettings: TLabel;
    lblDatabaseServer: TLabel;
    edtDatabaseServer: TEdit;
    lblDatabaseName: TLabel;
    edtDatabaseName: TEdit;
    chkBoxOSAuthenticate: TCheckBox;
    lblUsername: TLabel;
    lblDBatabasePassword: TLabel;
    edtDBUsername: TEdit;
    edtDBPassword: TEdit;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    FSettings : TSettings;
    procedure Init;
  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.dfm}

{ TFormSettings }

procedure TFormSettings.btnOkClick(Sender: TObject);
begin
  FSettings.ServerPort := edtServerPort.Text;
  FSettings.AutoStart := chkBoxServerAutostart.Checked;
  FSettings.DBServer := edtDatabaseServer.Text;
  FSettings.DBName := edtDatabaseName.Text;
  FSettings.OSAuth := chkBoxOSAuthenticate.Checked;
  FSettings.DBUname := edtDBUsername.Text;
  FSettings.DBPwd := edtDBPassword.Text;
end;

procedure TFormSettings.Init;
begin
  edtServerPort.Text := FSettings.ServerPort;
  chkBoxServerAutostart.Checked := FSettings.AutoStart;
  edtDatabaseServer.Text := FSettings.DBServer;
  edtDatabaseName.Text := FSettings.DBName;
  chkBoxOSAuthenticate.Checked := FSettings.OSAuth;
  edtDBUsername.Text := FSettings.DBUname;
  edtDBPassword.Text := FSettings.DBPwd;
end;

end.
