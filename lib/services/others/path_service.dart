import 'dart:io';
import 'package:com.onkur.customer/core/domain/usecase/usecase.dart';
import 'package:com.onkur.customer/core/presentation/utils/task_runner.dart';
import 'package:path_provider/path_provider.dart';

/// A service to easily access platform-specific file system locations.
class PathService {
  PathService._();
  static final PathService instance = PathService._();

  /// Get the directory where the application may place data that is user-generated.
  ResultFuture<Directory> getDocumentsDirectory() async =>
      runTask(() => getApplicationDocumentsDirectory());

  /// Get the directory where the application may place application-specific cache files.
  ResultFuture<Directory> getTempDirectory() async =>
      runTask(() => getTemporaryDirectory());

  /// Get the directory where the application may place data that is specific to 
  /// the application and not meant to be seen by the user.
  ResultFuture<Directory> getAppSupportDirectory() async =>
      runTask(() => getApplicationSupportDirectory());

  /// Get the directory where current application-specific data may be found.
  ResultFuture<Directory> getAppLibraryDirectory() async =>
      runTask(() => getLibraryDirectory());

  /// Get the path to the external storage directory (Android only).
  ResultFuture<Directory?> getExternalStorageDirectoryPath() async =>
      runTask(() => getExternalStorageDirectory());
}
