unit UnitUtil;

interface

uses
  IniFiles, SysUtils, VCL.Forms;

  function LoadConnString( var AConnString : String )  : Boolean;
  procedure SaveConnString( AConnString : String );

implementation

function LoadConnString( var AConnString : String )  : Boolean;
var
  iniFileName : String;
  iniFile : TIniFile;
begin
  Result := False;
  AConnString := '';

  iniFileName := ChangeFileExt( Application.ExeName, '.ini');
  if not FileExists(iniFileName) then
  begin
    exit;
  end;

  iniFile := TIniFile.Create(iniFileName);
  try
    AConnString := iniFile.ReadString('CONN', 'ConnectionString', '');
  finally
    iniFile.Free;
  end;

  Result := (AConnString <> '');
end;

procedure SaveConnString( AConnString : String );
var
  iniFileName : String;
  iniFile : TIniFile;
begin
  iniFileName := ChangeFileExt( Application.ExeName, '.ini');

  iniFile := TIniFile.Create(iniFileName);
  try
    iniFile.WriteString('CONN', 'ConnectionString', AConnString);
  finally
    iniFile.Free;
  end;
end;

end.
