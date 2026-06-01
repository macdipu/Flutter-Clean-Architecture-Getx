
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/logger.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/snackbar/custom_snackbar.dart';

/// A hook to handle copying text to clipboard with state feedback.
(Future<void> Function(String), bool) useCopy() {
  final hasCopied = useState(false);

  Future<void> copyToClipboard(String text) async {
    try {
      hasCopied.value = true;
      await Clipboard.setData(ClipboardData(text: text));

      CustomSnackbar.showGlobalToast(
        message: 'Copied successfully',
        status: 'success',
      );

      await Future.delayed(
        const Duration(seconds: 2),
        () => hasCopied.value = false,
      );
    } catch (e) {
      AppLogger.error('Error copying to clipboard: $e');
      hasCopied.value = false;

      CustomSnackbar.showGlobalToast(
        message: 'Failed to copy',
        status: 'error',
      );
    }
  }

  useEffect(() {
    return () {
      hasCopied.value = false;
    };
  }, []);

  return (copyToClipboard, hasCopied.value);
}
