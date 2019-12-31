unit BOOrders;

interface
uses
  SysUtils, Classes, Generics.Collections, System.JSON;

  type
    TOrderDet = class(TObject)
    private
      FID: Integer;
      FPPrice: Double;
      FPDescription: String;
      FQuantity: Integer;
      FPName: String;
      FPackageID: Integer;
    public
      property ID : Integer read FID write FID;
      property PackageID : Integer read FPackageID write FPackageID;
      property Quantity : Integer read FQuantity write FQuantity;
      property PName : String read FPName write FPName;
      property PPrice : Double read FPPrice write FPPrice;
      property PDescription : String read FPDescription write FPDescription;
    end;

    TOrder = class
    private
      FID: Integer;
      FCustName: String;
      FCustPhone1: String;
      FCustSurname: String;
      FCustAddress: String;
      FCustPhone2: String;
      FDeiveredDT: String;
      FTotalPrice: String;
      FDelivered: String;
      FSend: Boolean;
    public
      DetailList : TObjectList<TOrderDet>;
      Constructor Create;
      Destructor Destroy; override;
      property ID : Integer read FID write FID;
      property CustName : String read FCustName write FCustName;
      property CustSurname : String read FCustSurname write FCustSurname;
      property CustAddress : String read FCustAddress write FCustAddress;
      property CustPhone1 : String read FCustPhone1 write FCustPhone1;
      property CustPhone2 : String read FCustPhone2 write FCustPhone2;
      property Delivered : String read FDelivered write FDelivered;
      property TotalPrice : String read FTotalPrice write FTotalPrice;
      property DeiveredDT : String read FDeiveredDT write FDeiveredDT;
      property Send : Boolean read FSend write FSend;
      function OrderToJSON : TJSONObject;
    end;

    TOrderList = TObjectList<TOrder>;

implementation

{ TOrder }

constructor TOrder.Create;
begin
  inherited Create;
  DetailList := TObjectList<TOrderDet>.Create;
end;

destructor TOrder.Destroy;
begin
  DetailList.Free;
  inherited Destroy;
end;

function TOrder.OrderToJSON : TJSONObject;
begin
  result := TJSONObject.Create;
  result.AddPair('PackageID',IntToSTR(Self.ID));
  Result.AddPair('Delivered',Self.Delivered);
  Result.AddPair('DeliveredDT',Self.DeiveredDT);
end;

end.
