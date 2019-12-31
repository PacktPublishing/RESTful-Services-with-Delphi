unit FormMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  FMX.Effects, FMX.Filter.Effects, AndroidApi.Network, UnitUtil,DataModule,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, BOUser, BOOrders,System.JSON;

type
  TfrmMain = class(TForm)
    tbcMain: TTabControl;
    Login: TTabItem;
    List: TTabItem;
    Details: TTabItem;
    imgLoginBackground: TImage;
    gausBlurEff: TGaussianBlurEffect;
    tbTop: TToolBar;
    rectTbTop: TRectangle;
    lblSignIn: TLabel;
    verscBoxLogin: TVertScrollBox;
    InfoLayout: TLayout;
    lblErrorInfo: TText;
    SignInBackgroundRect: TRectangle;
    FormLayout: TLayout;
    edtUsername: TEdit;
    UserImage: TImage;
    edtPassword: TEdit;
    LockImage: TImage;
    restBtnSignIn: TRectangle;
    SignInText: TText;
    FormSpacerLayout: TLayout;
    HeaderLayout: TLayout;
    TextLayout: TLayout;
    WelcomeLabel: TLabel;
    sbSterling: TStyleBook;
    imgLogo: TImage;
    Settings: TTabItem;
    imbBgrSett: TImage;
    GaussianBlurEffect1: TGaussianBlurEffect;
    tbSettings: TToolBar;
    rectSettings: TRectangle;
    lblSettings: TLabel;
    VertScrollBoxSett: TVertScrollBox;
    rectSett: TRectangle;
    Layout2: TLayout;
    edtIPAddress: TEdit;
    rectSaveSett: TRectangle;
    txtSaveSett: TText;
    LogoLayout: TLayout;
    Image4: TImage;
    InfoSettLayout: TLayout;
    HeaderSettLayout: TLayout;
    lblSett: TLabel;
    rectCancelSett: TRectangle;
    txtCancelSett: TText;
    imgListBackground: TImage;
    GaussianBlurEffect2: TGaussianBlurEffect;
    tbList: TToolBar;
    rectTop: TRectangle;
    tbListBottom: TToolBar;
    rectPending: TRectangle;
    rectDelivered: TRectangle;
    lblOrders: TLabel;
    lblOrdersPending: TLabel;
    lblOrdersDelivered: TLabel;
    lvOrdersList: TListView;
    ShadowEffect1: TShadowEffect;
    imgOrderDetailBackground: TImage;
    GaussianBlurEffect3: TGaussianBlurEffect;
    tbTopOrdersDetail: TToolBar;
    Rectangle2: TRectangle;
    lblOrdersDetail: TLabel;
    tbOrdersDetailBottom: TToolBar;
    rectOrdersDertailDeliver: TRectangle;
    lblDeliver: TLabel;
    rectOrdersDetailCancel: TRectangle;
    lblOrdersDetailCancel: TLabel;
    rectBtnExit: TRectangle;
    ExitText: TText;
    btnRefresh: TButton;
    btnLogout: TButton;
    layTop: TLayout;
    rectDetails: TRectangle;
    lblName: TLabel;
    lblAddress: TLabel;
    lblPhone1: TLabel;
    lblPhone2: TLabel;
    lblPrice: TLabel;
    lblNameValue: TLabel;
    lblAddressValue: TLabel;
    lblPhone1Value: TLabel;
    lblPhone2Value: TLabel;
    lvProducts: TListView;
    ShadowEffect2: TShadowEffect;
    lblPriceValue: TLabel;
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure restBtnSignInClick(Sender: TObject);
    procedure rectCancelSettClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txtSaveSettClick(Sender: TObject);
    procedure lblOrdersDetailCancelClick(Sender: TObject);
    procedure lblOrdersDeliveredClick(Sender: TObject);
    procedure lblOrdersPendingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblDeliverClick(Sender: TObject);
    procedure rectBtnExitClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure lvOrdersListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnLogoutClick(Sender: TObject);
  private
    CurrentUser: TLoggedUser;
    OrderList : TOrderList;
    CurrentPackageID : integer;
    procedure FillOrdersList;
    procedure FillOrderDetail( AOrder : TOrder);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  settUser = 'sett';
  settPass = 'sett';

implementation

{$R *.fmx}

procedure TfrmMain.btnLogoutClick(Sender: TObject);
begin
  DataMod.DoSynch(OrderList, CurrentUser.ID);
  edtUsername.Text := '';
  edtPassword.Text := '';
  tbcMain.SetActiveTabWithTransition(Login, TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  DataMod.DoSynch(OrderList, CurrentUser.ID);
  FillOrdersList;
end;

procedure TfrmMain.edtPasswordKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    restBtnSignInClick(Sender);
  end
  else
  begin
    if Key = vkTab then
    begin
      edtPassword.SetFocus;
    end;
  end;
end;

procedure TfrmMain.FillOrderDetail(AOrder: TOrder);
var
  lvItem: TListViewItem;
  I: Integer;
begin
  lvProducts.BeginUpdate;
  lvProducts.Items.Clear;
  for I := 0 to AOrder.DetailList.Count - 1 do
  begin
    lvItem := lvProducts.Items.Add;
    lvItem.Text := AOrder.DetailList[i].PName + '-' + IntToStr(AOrder.DetailList[i].Quantity);
    lvItem.Detail := FloatToStr(AOrder.DetailList[i].PPrice) + '-' + AOrder.DetailList[i].PDescription;
  end;
  lvProducts.EndUpdate;
end;

procedure TfrmMain.FillOrdersList;
var
  lvItem: TListViewItem;
  I: Integer;
begin
  lvOrdersList.BeginUpdate;

  lvOrdersList.Items.Clear;
  for I := 0 to OrderList.Count - 1 do
  begin
    // add orders which are not delivered
    if (lblOrders.Text = 'Orders - To Be Delivered') then
    begin
      if OrderList.Items[i].Delivered <> 'Delivered' then
      begin
        lvItem := lvOrdersList.Items.Add;
        lvItem.Text := OrderList.Items[i].CustName + ' ' +
                       OrderList.Items[i].CustSurname;

        lvItem.Detail := OrderList.Items[i].CustAddress;
        lvItem.Tag := OrderList.Items[i].ID;
      end;
    end
    else
    // add orders which are delivered
    begin
      if OrderList.Items[i].Delivered = 'Delivered' then
      begin
        lvItem := lvOrdersList.Items.Add;
        lvItem.Text := OrderList.Items[i].CustName + ' ' +
                       OrderList.Items[i].CustSurname;

        lvItem.Detail := OrderList.Items[i].CustAddress;
        lvItem.Tag := OrderList.Items[i].ID;
      end;
    end;
  end;

  lvOrdersList.EndUpdate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  OrderList := TOrderList.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  OrderList.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  //Ensure we're on the login tab
  tbcMain.TabPosition := TTabPosition.None;
  tbcMain.ActiveTab := Login;
  SignInText.Text := 'SIGN IN';
end;

procedure TfrmMain.lblDeliverClick(Sender: TObject);
var
  I: Integer;
  fJSONArray : TJsonArray;
  frmSett: TFormatSettings;
begin
  // if packakge is already delivered just go back
  if lblOrders.Text = 'Orders - Delivered' then
  begin
    tbcMain.SetActiveTabWithTransition(List, TTabTransition.Slide, TTabTransitionDirection.Reversed);
    exit;
  end;

  // update package - set it to delivered
  for I := 0 to OrderList.Count - 1 do
  begin
    if OrderList[i].ID = CurrentPackageID then
    begin
      fJSONArray := TJsonArray.Create;
      OrderList[i].Delivered := 'Delivered';
      frmSett := TFormatSettings.Create;
      frmSett.DateSeparator := '-';
      frmSett.TimeSeparator := ':';
      frmSett.ShortDateFormat := 'YYYY-MM-DD';
      frmSett.LongDateFormat := 'YYYY-MM-DD';
      frmSett.ShortTimeFormat := 'HH:MM:SS';
      frmSett.LongTimeFormat := 'HH:MM:SS';
      OrderList[i].DeiveredDT := DateTimeToStr(Now,frmSett);
      fJSONArray.Add(OrderList[i].OrderToJSON);

      if DataMod.SendOrders(fJSONArray) then
      begin
        // Orders send ok. Update Local db
        DataMod.UpdateLocalDB(fJSONArray);
        OrderList.Clear;
        DataMod.DSToList(OrderList);
      end;
      FillOrdersList;
      tbcMain.SetActiveTabWithTransition(List, TTabTransition.Slide, TTabTransitionDirection.Reversed);
      exit;
    end;
  end;
end;

procedure TfrmMain.lblOrdersDeliveredClick(Sender: TObject);
begin
  lblOrders.Text := 'Orders - Delivered';
  FillOrdersList;
end;

procedure TfrmMain.lblOrdersDetailCancelClick(Sender: TObject);
begin
  tbcMain.SetActiveTabWithTransition(List, TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.lblOrdersPendingClick(Sender: TObject);
begin
  lblOrders.Text := 'Orders - To Be Delivered';
  FillOrdersList;
end;

procedure TfrmMain.lvOrdersListItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  I: Integer;
begin
  for I := 0 to OrderList.Count - 1 do
  begin
    if OrderList.Items[i].ID = AItem.Tag then
    begin
      CurrentPackageID := AItem.Tag;
      lblNameValue.Text := OrderList.Items[i].CustName + ' ' + OrderList.Items[i].CustSurname;
      lblAddressValue.Text := OrderList.Items[i].CustAddress;
      lblPhone1Value.Text := OrderList.Items[i].CustPhone1;
      lblPhone2Value.Text := OrderList.Items[i].CustPhone2;
      lblPriceValue.Text := OrderList.Items[i].TotalPrice;
      FillOrderDetail(OrderList.Items[i]);
      tbcMain.SetActiveTabWithTransition(Details, TTabTransition.Slide, TTabTransitionDirection.Reversed);
      exit;
    end;
  end;
end;

procedure TfrmMain.rectBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.rectCancelSettClick(Sender: TObject);
begin
  edtUsername.Text := '';
  edtPassword.Text := '';
  tbcMain.SetActiveTabWithTransition(Login, TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

procedure TfrmMain.restBtnSignInClick(Sender: TObject);
var
  strIP : String;
begin
  SignInText.Text := 'Autenticating...';

  try
    // special login to show settings form
    if (edtUsername.Text = settUser) and
       (edtPassword.Text = settPass) then
    begin
      strIP := '';
      SignInText.Text := 'SIGN IN';
      LoadIPAddress(strIP);
      edtIPAddress.Text := strIP;
      tbcMain.SetActiveTabWithTransition(Settings, TTabTransition.Slide, TTabTransitionDirection.Normal);
      exit;
    end;

    CurrentUser.ID := -1;
    CurrentUser.Username := edtUsername.Text;
    CurrentUser.Password := edtPassword.Text;

    //offline login
    if (not isConnected) then
    begin
      // check user local
      if DataMod.UserLoginLocal(CurrentUser) then
      begin
        DataMod.DSToList(OrderList);
        FillOrdersList;
        tbcMain.SetActiveTabWithTransition(List, TTabTransition.Slide, TTabTransitionDirection.Normal);
      end;
      exit;
    end;

    // normal login
    if DataMod.UserLogin(CurrentUser) then
    begin
      // do synchronization
      DataMod.DoSynch(OrderList, CurrentUser.ID);
      FillOrdersList;
      tbcMain.SetActiveTabWithTransition(List, TTabTransition.Slide, TTabTransitionDirection.Normal);
      exit;
    end;

  finally
    SignInText.Text := 'SIGN IN';
  end;

  ShowMessage('Invalid User Name / Password !');
end;

procedure TfrmMain.txtSaveSettClick(Sender: TObject);
begin
  SaveIPAddress(edtIPAddress.Text);
  edtUsername.Text := '';
  edtPassword.Text := '';

  tbcMain.SetActiveTabWithTransition(Login, TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

end.
