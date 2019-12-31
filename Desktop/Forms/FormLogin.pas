unit FormLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ModuleData;

type
  TfrmLogin = class(TForm)
    panClient: TPanel;
    Panel2: TPanel;
    lblUser: TLabel;
    lblPassword: TLabel;
    edtUserName: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure edtAccountPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnLoginClick(Sender: TObject);
  private
    FUserValid : Boolean;
  public
    { Public declarations }
  end;

  function ShowUserLogin : boolean;

implementation

{$R *.dfm}

// Return true if user has logged in
function ShowUserLogin : boolean;
var
  frmLogin : TfrmLogin;
begin
  Result := False;
  frmLogin := TfrmLogin.Create(nil);
  try
    Result := frmLogin.ShowModal = mrOK;
  finally
    FreeAndNil(frmLogin);
  end;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  FUserValid := DM.UserLogin(edtUserName.Text,edtPassword.Text);
  if not FUserValid then
  begin
    MessageDlg('Login failed!'#13#10'Invalid credentials', mtError, [mbOK], 0);
    edtUserName.SetFocus;
  end;
end;

procedure TfrmLogin.edtAccountPropertiesChange(Sender: TObject);
begin
  btnLogin.Enabled := ( Trim(edtUserName.Text) <> '') and
                      ( Trim(edtPassword.Text) <> '');
end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FUserValid or (ModalResult = mrCancel);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FUserValid := False;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edtUserName.SetFocus;
end;

end.
