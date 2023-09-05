import 'package:device_info_plus/device_info_plus.dart';

Future<bool> checkAndroidVersion() async {
  int sdkInt = 0;
  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    sdkInt = androidInfo.version.sdkInt;
  } catch (e) {
    return false;
  }
  return sdkInt >= 30;
}