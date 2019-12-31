unit UnitUtil;

interface

uses
  IniFiles, SysUtils, System.IOUtils;

  function LoadIPAddress( var AIPAddress : String )  : Boolean;
  procedure SaveIPAddress( AIPAddress : String );

const
  strIP = '127.0.0.1';

implementation

function LoadIPAddress( var AIPAddress : String )  : Boolean;
var
  iniFile : TIniFile;
  strIniFilePath : String;
begin
  Result := False;
  AIPAddress := '';
  strIniFilePath := TPath.GetDocumentsPath + PathDelim + 'Settings.ini' ;

  if not FileExists(strIniFilePath) then
  begin
    AIPAddress := strIP;
    exit;
  end;

  iniFile := TIniFile.Create(strIniFilePath);
  try
    AIPAddress := iniFile.ReadString('REST', 'IP', '');
  finally
    iniFile.Free;
  end;

  Result := (AIPAddress <> '');

  if (AIPAddress = '') then
  begin
    AIPAddress := strIP;
  end;
end;

procedure SaveIPAddress( AIPAddress : String );
var
  iniFile : TIniFile;
  strIniFilePath : String;
begin
  strIniFilePath := TPath.GetDocumentsPath + PathDelim + 'Settings.ini' ;

  iniFile := TIniFile.Create(strIniFilePath);
  try
    iniFile.WriteString('REST', 'IP', AIPAddress);
  finally
    iniFile.Free;
  end;
end;

end.
