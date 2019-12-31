program Server;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Windows,
  MainForm in 'Forms\MainForm.pas' {FormMain},
  SMUnit in 'Modules\SMUnit.pas' {SM: TDataModule},
  WMUnit in 'Modules\WMUnit.pas' {WebMod: TWebModule},
  SettingsForm in 'Forms\SettingsForm.pas' {FormSettings},
  BOSettings in 'Units\BOSettings.pas',
  DataModule in 'Modules\DataModule.pas' {DataMod: TDataModule};

{$R *.res}

const
  APP_MUTEX_NAME = 'Server';

var
  hMutex, rtMutex: longword;

begin
  hMutex := CreateMutex(nil, false, APP_MUTEX_NAME);
  rtMutex := 0;
  try
    rtMutex := GetLastError;
    ReleaseMutex(hMutex);
  finally
    if rtMutex = ERROR_ALREADY_EXISTS then
    begin
      Application.Terminate; // kill the application
    end;
  end;

  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

  Application.Initialize;
  Application.CreateForm(TDataMod, DataMod);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
