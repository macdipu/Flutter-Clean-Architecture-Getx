import 'dart:io';

import 'package:flutter_clean_architecture_getx/core/presentation/utils/logger.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/snackbar/custom_snackbar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

/// A hook to handle URL launching with state feedback.
(bool, Future<void> Function(String)) useLaunchUrl({LaunchMode? mode}) {
  final isLoading = useState(false);

  Future<void> launch(String url) async {
    isLoading.value = true;
    try {
      final formattedUrl = _formatUrl(url);
      final uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: mode ?? LaunchMode.externalApplication,
        );
      } else {
        AppLogger.error('Could not launch url: $formattedUrl');
        CustomSnackbar.showGlobalToast(
          message: 'Could not launch url',
          status: 'error',
        );
      }
    } catch (e) {
      AppLogger.error('Error launching URL: $e');
      CustomSnackbar.showGlobalToast(
        message: 'Could not launch url',
        status: 'error',
      );
    } finally {
      isLoading.value = false;
    }
  }

  return (isLoading.value, launch);
}

String _formatUrl(String url) {
  if (url.isValidUrl && !url.contains('://')) {
    return 'https://$url';
  }
  if (url.isValidPhoneNumber) {
    return Platform.isAndroid
        ? 'whatsapp://send?phone=$url'
        : 'https://wa.me/$url';
  }
  return url;
}
