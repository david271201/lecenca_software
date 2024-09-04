import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  // Obtém o sistema operacional e o identificador único do aparelho
  static Future<Map<String, String?>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final Map<String, String?> deviceData = {};

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData['platform'] = 'Android';
      deviceData['uniqueId'] = androidInfo.id; // androidId
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData['platform'] = 'iOS';
      deviceData['uniqueId'] = iosInfo.identifierForVendor; // Identificador único para iOS
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      deviceData['platform'] = 'Windows';
      deviceData['uniqueId'] = windowsInfo.deviceId; // Identificador único para Windows
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceData['platform'] = 'Linux';
      deviceData['uniqueId'] = linuxInfo.machineId; // Usar machineId como identificador único para Linux
    } else {
      deviceData['platform'] = 'Unknown';
      deviceData['uniqueId'] = null;
    };
    return deviceData;
  }
}



