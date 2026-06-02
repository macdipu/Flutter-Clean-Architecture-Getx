import 'package:com.onkur.customer/core/domain/usecase/usecase.dart';
import 'package:com.onkur.customer/core/presentation/utils/task_runner.dart';
import 'package:share_plus/share_plus.dart';

/// A service to handle sharing content via the platform's native share dialog.
class ShareService {
  ShareService._();
  static final ShareService instance = ShareService._();

  /// Share plain text content.
  ResultFuture<ShareResult> shareText(String text, {String? subject}) async {
    return runTask(() => Share.share(text, subject: subject));
  }

  /// Share files.
  ResultFuture<ShareResult> shareFiles(List<String> paths, {String? text, String? subject}) async {
    return runTask(() => Share.shareXFiles(
      paths.map((p) => XFile(p)).toList(),
      text: text,
      subject: subject,
    ));
  }
}
