unit Androidapi.Misc;

interface

function HasPermission(const Permission: string): Boolean;
procedure Vibrate(DurationMS: Int64);

implementation

uses
  System.SysUtils,
  System.UITypes,
{$IF RTLVersion >= 31}
  FMX.DialogService,
{$ELSE}
  FMX.Dialogs,
{$ENDIF}
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.JNI.App,
  Androidapi.JNI.OS,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText;

function HasPermission(const Permission: string): Boolean;
begin
  //Permissions listed at http://d.android.com/reference/android/Manifest.permission.html
{$IF RTLVersion >= 30}
  Result := TAndroidHelper.Context.checkCallingOrSelfPermission(
{$ELSE}
  Result := SharedActivityContext.checkCallingOrSelfPermission(
{$ENDIF}
    StringToJString(Permission)) =
    TJPackageManager.JavaClass.PERMISSION_GRANTED
end;

procedure Vibrate(DurationMS: Int64);
var
  VibratorObj: JObject;
  Vibrator: JVibrator;
begin
  if not HasPermission('android.permission.VIBRATE') then
{$IF RTLVersion >= 31}
    TDialogService.MessageDialog('App does not have the VIBRATE permission', TMsgDlgType.mtError, [TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0, nil)
{$ELSE}
    MessageDlg('App does not have the VIBRATE permission', TMsgDlgType.mtError, [TMsgDlgBtn.mbCancel], 0)
{$ENDIF}
  else
  begin
{$IF RTLVersion >= 30}
    VibratorObj := TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.VIBRATOR_SERVICE);
{$ELSE}
    VibratorObj := SharedActivity.getSystemService(TJContext.JavaClass.VIBRATOR_SERVICE);
{$ENDIF}
    Vibrator := TJVibrator.Wrap((VibratorObj as ILocalObject).GetObjectID);
    Vibrator.vibrate(DurationMS);
  end;
end;

end.
