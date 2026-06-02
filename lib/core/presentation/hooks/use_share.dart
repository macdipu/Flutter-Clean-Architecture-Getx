import 'package:com.onkur.customer/core/presentation/utils/logger.dart';
import 'package:com.onkur.customer/services/others/share_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


/// A hook to simplify sharing logic within widgets with loading state.
(bool, Future<void> Function(String, {String? subject})) useShare() {
  final isLoading = useState(false);
  final service = ShareService.instance;

  Future<void> share(String text, {String? subject}) async {
    isLoading.value = true;
    try {
      final result = await service.shareText(text, subject: subject);
      result.fold(
        (failure) => AppLogger.error('Sharing failed: ${failure.message}'),
        (success) => AppLogger.info('Sharing result: ${success.status}'),
      );
    } finally {
      isLoading.value = false;
    }
  }

  return (isLoading.value, share);
}
