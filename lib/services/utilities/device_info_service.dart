import 'dart:io';

import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:customer/core/presentation/utils/task_runner.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceInfoService {
  DeviceInfoService._();
  static final DeviceInfoService instance = DeviceInfoService._();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String>? _deviceIdFuture;

  Future<String> _resolveDeviceId() =>
      _deviceIdFuture ??= FlutterUdid.consistentUdid;

  Future<String> get deviceId => _resolveDeviceId();

  ResultFuture<Map<String, dynamic>> getFullDeviceInfo() => runTask(() async {
        final deviceId = await _resolveDeviceId();

        if (Platform.isAndroid) {
          final info = await _deviceInfo.androidInfo;
          return {
            'deviceId': deviceId,
            'model': info.model,
            'manufacturer': info.manufacturer,
            'version': info.version.release,
            'sdkInt': info.version.sdkInt,
            'id': info.id,
            'isPhysicalDevice': info.isPhysicalDevice,
          };
        } else if (Platform.isIOS) {
          final info = await _deviceInfo.iosInfo;
          return {
            'deviceId': deviceId,
            'name': info.name,
            'model': info.model,
            'systemName': info.systemName,
            'systemVersion': info.systemVersion,
            'identifierForVendor': info.identifierForVendor,
            'isPhysicalDevice': info.isPhysicalDevice,
          };
        } else if (Platform.isMacOS) {
          final info = await _deviceInfo.macOsInfo;
          return {
            'deviceId': deviceId,
            'computerName': info.computerName,
            'hostName': info.hostName,
            'model': info.model,
            'osRelease': info.osRelease,
          };
        } else if (Platform.isWindows) {
          final info = await _deviceInfo.windowsInfo;
          return {
            'deviceId': deviceId,
            'computerName': info.computerName,
            'numberOfCores': info.numberOfCores,
            'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
          };
        }

        return {'deviceId': deviceId, 'platform': 'unknown'};
      });
}
