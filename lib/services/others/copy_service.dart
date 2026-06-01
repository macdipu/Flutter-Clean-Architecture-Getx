import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/logger.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/task_runner.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/typedefs.dart';

/// A service to handle clipboard operations.
class CopyService {
  CopyService._();
  static final CopyService instance = CopyService._();

  /// Copy text to the system clipboard.
  ResultFuture<void> copy(String text) async {
    return runTask(() async {
      await Clipboard.setData(ClipboardData(text: text));
      AppLogger.info('Text copied to clipboard');
    });
  }
}
