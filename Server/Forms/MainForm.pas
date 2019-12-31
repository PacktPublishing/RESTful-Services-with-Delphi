unit MainForm;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp,
  SettingsForm, BOSettings, DataModule;

type
  TFormMain = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    ApplicationEvents1: TApplicationEvents;
    btnSettings: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FServer: TIdHTTPWebBrokerBridge;
    FSettings : TSettings;

    procedure StartServer;
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;

procedure TFormMain.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  btnStart.Enabled := not FServer.Active and DataMod.DatabaseConnection.Connected;
  btnStop.Enabled := FServer.Active;
  btnSettings.Enabled := not FServer.Active;
end;

procedure TFormMain.btnSettingsClick(Sender: TObject);
var
  frmSettings : TFormSettings;
begin
  if not FServer.Active then
  begin
    frmSettings := TFormSettings.Create(Self);
    try
      frmSettings.FSettings := FSettings;
      frmSettings.Init;
      if frmSettings.ShowModal = mrOk then
      begin
        FSettings.SaveSettings;
        DataMod.Init(FSettings);
      end;
    finally
      FreeAndNil(frmSettings);
    end;
  end;
end;

procedure TFormMain.btnStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TFormMain.btnStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FSettings);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  FSettings := TSettings.Create;

  if FSettings.LoadSettings then
  begin
    if FSettings.AutoStart then
    begin
      StartServer;
    end;

    if not DataMod.DatabaseConnection.Connected then
    begin
      DataMod.Init(FSettings);
      try
        DataMod.DatabaseConnection.Connected := true;
      except on E: Exception do
        ShowMessage('Error Connecting to Database. Check Settings !');
      end;
    end;
  end;
end;

procedure TFormMain.StartServer;
begin
  DataMod.Init(FSettings);
  try
    DataMod.DatabaseConnection.Connected := true;
  except on E: Exception do
    ShowMessage('Error Connecting to Database. Check Settings !');
  end;

  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(FSettings.ServerPort);
    FServer.Active := True;
  end;
end;

end.
