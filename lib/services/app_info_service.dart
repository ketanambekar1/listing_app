import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService extends GetxService {
  final Rxn<AppInfo> _info = Rxn<AppInfo>();
  AppInfo? get info => _info.value;

  String get appName => _info.value?.appName ?? '';
  String get version => _info.value?.version ?? '';
  String get buildNumber => _info.value?.buildNumber ?? '';

  Future<AppInfoService> init() async {
    final info = await PackageInfo.fromPlatform();
    _info.value = AppInfo(
      appName: info.appName,
      packageName: info.packageName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
    return this;
  }
}


class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  @override
  String toString() =>
      '$appName ($packageName) — v$version+$buildNumber';
}
