import 'package:app_version_update/app_version_update.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_getx/core/domain/usecase/usecase.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/logger.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/task_runner.dart';
import 'package:flutter_clean_architecture_getx/res/routes/global_navigator.dart';


/// A service to check for app updates and manage version information using
/// the `app_version_update` package.
class VersionUpdateService {
  VersionUpdateService._();
  static final VersionUpdateService instance = VersionUpdateService._();

  /// Check if a newer version of the app is available in the store.
  ResultFuture<AppVersionResult?> checkForUpdate({
    String? appleId,
    String? playStoreId,
  }) async {
    return runTask(() async {
      return await AppVersionUpdate.checkForUpdates(
        appleId: appleId,
        playStoreId: playStoreId,
      );
    }, requiresNetwork: true);
  }

  /// High-level method to check for updates and show the dialog automatically if available.
  ResultFuture<void> checkAndShowUpdate({
    String? appleId,
    String? playStoreId,
    bool mandatory = false,
  }) async {
    return runTask(() async {
      final result = await AppVersionUpdate.checkForUpdates(
        appleId: appleId,
        playStoreId: playStoreId,
      );

      if (result.canUpdate ?? false) {
        final context = rootContext;
        if (context == null) {
          AppLogger.warning('Cannot show update dialog: rootContext is null');
          return;
        }

        if(context.mounted){
          AppVersionUpdate.showAlertUpdate(
            appVersionResult: result,
            context: context,
            mandatory: mandatory,
          );
        }
      }
    }, requiresNetwork: true);
  }

  /// Display a platform-specific update dialog.
  ResultFuture<void> showUpdateAlert({
    required AppVersionResult updateResult,
    bool mandatory = false,
    String? title,
    String? content,
    String? cancelText,
    String? updateText,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      AppVersionUpdate.showAlertUpdate(
        appVersionResult: updateResult,
        context: context,
        mandatory: mandatory,
        title: title ?? 'New version available',
        content: content ?? 'Would you like to update your application?',
        cancelButtonText: cancelText ?? 'UPDATE LATER',
        updateButtonText: updateText ?? 'UPDATE',
      );
    });
  }

  /// Display a platform-specific update bottom sheet.
  ResultFuture<void> showUpdateBottomSheet({
    required AppVersionResult updateResult,
    bool mandatory = false,
    String? title,
    Widget? content,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      AppVersionUpdate.showBottomSheetUpdate(
        appVersionResult: updateResult,
        context: context,
        mandatory: mandatory,
        title: title ?? 'New version available',
        content: content,
      );
    });
  }

  /// Display a dedicated update page.
  ResultFuture<void> showUpdatePage({
    required AppVersionResult updateResult,
    bool mandatory = false,
    Widget? page,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      AppVersionUpdate.showPageUpdate(
        appVersionResult: updateResult,
        context: context,
        mandatory: mandatory,
        page: page,
      );
    });
  }
}