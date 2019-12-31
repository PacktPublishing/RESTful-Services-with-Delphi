unit AndroidApi.Network;

interface

uses
  System.SysUtils,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net,
  Androidapi.Misc,
  FMX.Helpers.Android;

function IsConnected: Boolean;

function IsRoaming: Boolean;

function IsWiFiConnected: Boolean;

function IsMobileConnected: Boolean;

function WiFiSSID: string;

implementation

// These Android classes are imported by Delphi XE8 and later in the Androidapi.JNI.Net unit

{$IF RTLVersion < 29} // XE7-
type
  JConnectivityManager = interface;
  JNetworkInfo = interface;
  JWifiManager = interface;
  JWifiInfo = interface;

  JConnectivityManagerClass = interface(JObjectClass)
  ['{E03A261F-59A4-4236-8CDF-0068FC6C5FA1}']
    {Property methods}
    function _GetTYPE_WIFI: Integer; cdecl;
    function _GetTYPE_WIMAX: Integer; cdecl;
    function _GetTYPE_MOBILE: Integer; cdecl;
    {Properties}
    property TYPE_WIFI: Integer read _GetTYPE_WIFI;
    property TYPE_WIMAX: Integer read _GetTYPE_WIMAX;
    property TYPE_MOBILE: Integer read _GetTYPE_MOBILE;
  end;

  [JavaSignature('android/net/ConnectivityManager')]
  JConnectivityManager = interface(JObject)
  ['{1C4C1873-65AE-4722-8EEF-36BBF423C9C5}']
    {Methods}
    function getActiveNetworkInfo: JNetworkInfo; cdecl;
    function getNetworkInfo(networkType: Integer): JNetworkInfo; cdecl;
  end;
  TJConnectivityManager = class(TJavaGenericImport<JConnectivityManagerClass, JConnectivityManager>) end;

  JNetworkInfoClass = interface(JObjectClass)
  ['{E92E86E8-0BDE-4D5F-B44E-3148BD63A14C}']
  end;

  [JavaSignature('android/net/NetworkInfo')]
  JNetworkInfo = interface(JObject)
  ['{6DF61A40-8D17-4E51-8EF2-32CDC81AC372}']
    {Methods}
    function isAvailable: Boolean; cdecl;
    function isConnected: Boolean; cdecl;
    function isConnectedOrConnecting: Boolean; cdecl;
    function isRoaming: Boolean; cdecl;
  end;
  TJNetworkInfo = class(TJavaGenericImport<JNetworkInfoClass, JNetworkInfo>) end;

  JWifiManagerClass = interface(JObjectClass)
  ['{609C773B-E42E-40F1-8C12-AB38DD38DBB1}']
  end;

  [JavaSignature('android/net/wifi/WifiManager')]
  JWifiManager = interface(JObject)
  ['{051511E1-6B00-4635-8BCA-5F1A4DD9A473}']
    {Methods}
    function getConnectionInfo: JWifiInfo; cdecl;
  end;
  TJWifiManager = class(TJavaGenericImport<JWifiManagerClass, JWifiManager>) end;

  JWifiInfoClass = interface(JObjectClass)
  ['{DBFE7F9D-5B77-49BC-AD59-54CE78227A88}']
  end;

  [JavaSignature('android/net/wifi/WifiInfo')]
  JWifiInfo = interface(JObject)
  ['{5120EF5E-9878-437F-8524-70CEEB07A99C}']
    {Methods}
    function getSSID: JString; cdecl;
  end;
  TJWifiInfo = class(TJavaGenericImport<JWifiInfoClass, JWifiInfo>) end;
{$ENDIF}

function GetConnectivityManager: JConnectivityManager;
var
  ConnectivityServiceObj: JObject;
begin
  if not HasPermission('android.permission.ACCESS_NETWORK_STATE') then
    raise Exception.Create('You need the ACCESS_NETWORK_STATE permission');
  ConnectivityServiceObj := TAndroidHelper.Context.getSystemService(
    TJContext.JavaClass.CONNECTIVITY_SERVICE);
  if ConnectivityServiceObj = nil then
    raise Exception.Create('Could not access Connectivity Service');
  Result := TJConnectivityManager.Wrap(ConnectivityServiceObj);
  if Result = nil then
    raise Exception.Create('Could not access Connectivity Manager');
end;

function GetWifiManager: JWifiManager;
var
  WifiServiceObj: JObject;
begin
  if not HasPermission('android.permission.ACCESS_WIFI_STATE') then
    raise Exception.Create('You need the ACCESS_WIFI_STATE permission');
  WifiServiceObj := TAndroidHelper.Context.getSystemService(
    TJContext.JavaClass.WIFI_SERVICE);
  if WifiServiceObj = nil then
    raise Exception.Create('Could not access Wifi Service');
  Result := TJWifiManager.Wrap(WifiServiceObj);
  if Result = nil then
    raise Exception.Create('Could not access Wifi Manager');
end;

function IsConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  ActiveNetwork: JNetworkInfo;
begin
  ConnectivityManager := GetConnectivityManager;
  ActiveNetwork := ConnectivityManager.getActiveNetworkInfo;
  Result := (ActiveNetwork <> nil) and ActiveNetwork.isConnected;
end;

function IsRoaming: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  ActiveNetwork: JNetworkInfo;
begin
  ConnectivityManager := GetConnectivityManager;
  ActiveNetwork := ConnectivityManager.getActiveNetworkInfo;
  Result := (ActiveNetwork <> nil) and ActiveNetwork.isRoaming;
end;

function IsWiFiConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  WiFiNetworkInfo: JNetworkInfo;
begin
  ConnectivityManager := GetConnectivityManager;
  WiFiNetworkInfo := ConnectivityManager.getNetworkInfo(
    TJConnectivityManager.JavaClass.TYPE_WIFI);
  Result := (WiFiNetworkInfo <> nil) and WiFiNetworkInfo.isConnected;
end;

function IsMobileConnected: Boolean;
var
  ConnectivityManager: JConnectivityManager;
  MobileNetworkInfo: JNetworkInfo;
begin
  ConnectivityManager := GetConnectivityManager;
  MobileNetworkInfo := ConnectivityManager.getNetworkInfo(
    TJConnectivityManager.JavaClass.TYPE_MOBILE);
  Result := (MobileNetworkInfo <> nil) and MobileNetworkInfo.isConnected;
end;

function WiFiSSID: string;
var
  WiFiManager: JWifiManager;
  WiFiInfo: JWifiInfo;
begin
  Result := '';
  if IsWiFiConnected then
  begin
    WifiManager := GetWifiManager;
    WiFiInfo := WifiManager.getConnectionInfo;
    if WiFiInfo <> nil then
      Result := JStringToString(WiFiInfo.getSSID)
  end;
end;

end.
