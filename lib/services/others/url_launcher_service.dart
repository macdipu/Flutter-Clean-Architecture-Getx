import 'dart:io';

import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:customer/core/presentation/utils/app_utils.dart';
import 'package:customer/core/presentation/utils/task_runner.dart';
import 'package:url_launcher/url_launcher.dart';

/// A service to handle URL launching operations.
class UrlLauncherService {
  UrlLauncherService._();
  static final UrlLauncherService instance = UrlLauncherService._();

  /// Launch a URL string.
  ResultFuture<void> launch(String url, {LaunchMode? mode}) async {
    return runTask(() async {
      final formattedUrl = _formatUrl(url);
      final uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: mode ?? LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Could not launch url: $formattedUrl');
      }
    });
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
}
