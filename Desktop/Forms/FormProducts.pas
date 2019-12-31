unit FormProducts;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, ModuleData;

type
  TfrmProducts = class(TForm)
    Panel1: TPanel;
    panProducts: TPanel;
    gridProducts: TDBGrid;
    DBNavigator1: TDBNavigator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure showProducts;


implementation

{$R *.dfm}

procedure showProducts;
var
  frmProducts: TfrmProducts;
begin
  DM.tableProducts.Active := true;
  frmProducts := TfrmProducts.Create(nil);
  try
    frmProducts.ShowModal;
  finally
    DM.tableProducts.Active := false;
    FreeAndNil(frmProducts);
  end;
end;

end.
