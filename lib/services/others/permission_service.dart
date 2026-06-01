import 'package:flutter_clean_architecture_getx/core/presentation/utils/task_runner.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/typedefs.dart';
import 'package:permission_handler/permission_handler.dart';

/// A service to handle device permission requests and status checks.
class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  /// Check the status of a specific permission.
  ResultFuture<PermissionStatus> checkStatus(Permission permission) async {
    return runTask(() => permission.status);
  }

  /// Request a specific permission.
  ResultFuture<PermissionStatus> request(Permission permission) async {
    return runTask(() => permission.request());
  }

  /// Request multiple permissions at once.
  ResultFuture<Map<Permission, PermissionStatus>> requestMultiple(List<Permission> permissions) async {
    return runTask(() => permissions.request());
  }

  /// Open the app settings.
  ResultFuture<bool> openSettings() async {
    return runTask(() => openAppSettings());
  }
}
