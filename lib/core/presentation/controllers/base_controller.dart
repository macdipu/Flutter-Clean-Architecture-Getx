import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/presentation/utils/state_status.dart';
import 'package:customer/core/presentation/widgets/snackbar/custom_snackbar.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final status = StateStatus.initial.obs;
  final errorMessage = Rxn<String>();
  final isLoading = false.obs;

  void handleFailure(Failure failure) {
    status.value = StateStatus.error;
    isLoading.value = false;
    errorMessage.value = failure.message;
    CustomSnackbar.error(failure.message);
  }

  Future<void> doAction<T>({
    required Function action,
    required Function(T) onSuccess,
    Function(String?)? onError,
  }) async {
    status.value = StateStatus.loading;
    isLoading.value = true;
    final result = await action();
    await result.fold(
      (failure) async {
        status.value = StateStatus.error;
        isLoading.value = false;
        errorMessage.value = failure.message;
        if (onError != null) {
          onError.call(failure.message);
        } else {
          CustomSnackbar.error(failure.message);
        }
      },
      (success) async {
        status.value = StateStatus.success;
        isLoading.value = false;
        await onSuccess(success);
      },
    );
  }
}
