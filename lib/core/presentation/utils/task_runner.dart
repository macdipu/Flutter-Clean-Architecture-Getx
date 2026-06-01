

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/error_handler.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/failure.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/logger.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/typedefs.dart';
import 'package:flutter_clean_architecture_getx/services/others/internet_connection_service.dart';

/// A reusable generic function to handle potential exceptions in async tasks
/// and map them to the [Either] type matching [FutureEither<T>].
///
/// If [requiresNetwork] is `true` and [isNetworkAvailable] returns `false`,
/// the [action] will not be executed and a [NetworkFailure] will be returned.
FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  if (requiresNetwork) {
    final hasNetwork = await InternetConnectionService().hasConnection();

    if (!hasNetwork) {
      AppLogger.warning('Network unavailable for task');
      showGlobalToast(
        message:
            'No internet connection. Please check your connection and try again.',
        status: 'warning',
      );
      return left(
        const NetworkFailure(
          'No internet connection. Please check your connection and try again.',
        ),
      );
    }
  }

  try {
    final result = await action();
    return right(result);
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed $error', [error, stackTrace]);
    final errorMessage = AppErrorHandler.format(error);

    // Depending on logic, map error strings/types to specific Failure variants
    return left(ServerFailure(errorMessage, error: error));
  }
}
