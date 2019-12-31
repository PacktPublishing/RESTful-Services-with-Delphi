unit SMUnit;

interface

uses System.SysUtils, System.Classes, System.Json,
    Datasnap.DSServer, Datasnap.DSAuth,
    DataModule;

type
{$METHODINFO ON}
  TSM = class(TDataModule)
  private
    { Private declarations }
  public
    function CheckUser(AUser, APass : String): TJSONObject;
    function GetOrders(AID: String): TJSONObject;
    function UpdateGetOrders(Order : TJSONObject):String;
    { Public declarations }
  end;
{$METHODINFO OFF}

implementation


{$R *.dfm}


{ TSM }

function TSM.CheckUser(AUser, APass : String): TJSONObject;
begin
  result := TJSONObject.Create;
  if (AUser = '') or (APass = '') then
  begin
    result.AddPair('ID', '-1');
    exit;
  end;
  result.AddPair('ID', datamod.GetUserID(AUser, APass));
end;

function TSM.GetOrders(AID: String): TJSONObject;
begin
  result := TJSONObject.Create;
  result.AddPair('Packages', datamod.GetOrders(AID));
end;

function TSM.UpdateGetOrders(Order: TJSONObject):String;
begin
  result := 'Not updated';
  if datamod.UpdateOrders(Order) then
  begin
    result := 'Updated';
  end;
end;

end.

