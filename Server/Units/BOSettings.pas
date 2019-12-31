unit BOSettings;

interface

uses
  SysUtils, Vcl.Forms, IniFiles;

type
  TSettings = class
  private
    FServerPort : String;
    FAutoStart : Boolean;
    FDBName : String;
    FDBServer : String;
    FOSAuth : boolean;
    FDBUname : String;
    FDBPwd : String;
  public
    property ServerPort : String read FServerPort write FServerPort;
    property AutoStart : Boolean read FAutoStart write FAutoStart;
    property DBName : String read FDBName write FDBName;
    property DBServer : String read FDBServer write FDBServer;
    property OSAuth : Boolean read FOSAuth write FOSAuth;
    property DBUname : String read FDBUname write FDBUname;
    property DBPwd : string read FDBPwd write FDBPwd;

    function LoadSettings : Boolean;
    function SaveSettings : Boolean;
  End;

implementation

{ TSettings }

function TSettings.LoadSettings : Boolean;
var
  iniFilePath : String;
  iniFile : TiniFile;
begin
  Result := false;
  iniFilePath := ChangeFileExt( Application.ExeName,'.ini' );

  if not FileExists(iniFilePath) then
  begin
    exit;
  end;

  iniFile := TIniFile.Create(iniFilePath);
  try
    with iniFile do
    begin
      ServerPort :=  ReadString('Rest server','Port','8080');
      AutoStart  :=  ReadBool('Rest server','AutoStart',false);

      DBName   := ReadString('Database','DBName','MasterCourier');
      DBServer := ReadString('Database','DBServer','127.0.0.1');
      OSAuth   := ReadBool('Database','OSAuth',false);
      DBUname  := ReadString('Database','DBUname','');
      DBPwd    := ReadString('Database','DBPwd','');
    end;
    Result := true;
  finally
    iniFile.Free;
  end;
end;

function TSettings.SaveSettings: Boolean;
var
  iniFilePath : String;
  iniFile : TiniFile;
begin
  Result := false;
  iniFilePath := ChangeFileExt( Application.ExeName,'.ini' );

  iniFile := TIniFile.Create(iniFilePath);
  try
    with iniFile do
    begin
      WriteString('Rest server','Port',ServerPort);
      WriteBool('Rest server','AutoStart',AutoStart);

      WriteString('Database','DBName',DBName);
      WriteString('Database','DBServer',DBServer);
      WriteBool('Database','OSAuth',OSAuth);
      WriteString('Database','DBUname',DBUname);
      WriteString('Database','DBPwd',DBPwd);
    end;
    Result := true;
  finally
    iniFile.Free;
  end;

end;

end.
