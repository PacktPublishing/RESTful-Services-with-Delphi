unit FormUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, ModuleData;

type
  TfrmUsers = class(TForm)
    panTop: TPanel;
    navUsers: TDBNavigator;
    panUsers: TPanel;
    gridUsers: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowUsers;



implementation

{$R *.dfm}
procedure ShowUsers;
var
  frmUsers: TfrmUsers;
begin
  DM.tableUSers.Active := true;
  frmUsers := TfrmUsers.Create(nil);
  try

    frmUsers.ShowModal;
  finally
    FreeAndNil(frmUsers);
    DM.tableUSers.Active := false;
  end;

end;

end.
