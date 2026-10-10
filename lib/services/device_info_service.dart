import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoData {
  const DeviceInfoData({required this.model, required this.osVersion});
  final String model;
  final String osVersion;
}

class DeviceInfoService {
  DeviceInfoService({DeviceInfoPlugin? plugin})
    : _plugin = plugin ?? DeviceInfoPlugin();
  final DeviceInfoPlugin _plugin;

  Future<DeviceInfoData> getInfo() async {
    if (kIsWeb) {
      final info = await _plugin.webBrowserInfo;
      return DeviceInfoData(
        model: info.browserName.name,
        osVersion: info.userAgent ?? 'Web',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final info = await _plugin.androidInfo;
        return DeviceInfoData(
          model: info.model,
          osVersion: 'Android ${info.version.release}',
        );
      case TargetPlatform.iOS:
        final info = await _plugin.iosInfo;
        return DeviceInfoData(
          model: info.utsname.machine,
          osVersion: 'iOS ${info.systemVersion}',
        );
      case TargetPlatform.windows:
        final info = await _plugin.windowsInfo;
        return DeviceInfoData(
          model: info.computerName,
          osVersion: 'Windows ${info.majorVersion}.${info.minorVersion}',
        );
      case TargetPlatform.macOS:
        final info = await _plugin.macOsInfo;
        return DeviceInfoData(
          model: info.model,
          osVersion: 'macOS ${info.osRelease}',
        );
      case TargetPlatform.linux:
        final info = await _plugin.linuxInfo;
        return DeviceInfoData(
          model: info.prettyName,
          osVersion: 'Linux ${info.versionId ?? ''}'.trim(),
        );
      case TargetPlatform.fuchsia:
        return const DeviceInfoData(
          model: 'Fuchsia device',
          osVersion: 'Fuchsia',
        );
    }
  }
}
