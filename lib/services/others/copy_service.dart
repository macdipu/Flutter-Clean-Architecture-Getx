import 'package:flutter/services.dart';
import 'package:com.onkur.customer/core/domain/usecase/usecase.dart';
import 'package:com.onkur.customer/core/presentation/utils/logger.dart';
import 'package:com.onkur.customer/core/presentation/utils/task_runner.dart';

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
