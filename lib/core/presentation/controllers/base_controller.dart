import 'package:flutter_clean_architecture_getx/core/domain/error/failure.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/utils/state_status.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/snackbar/custom_snackbar.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  var status = StateStatus.initial.obs;
  var errorMessage = Rxn<String>();
  // final GetLoggedInMobile getLoggedInMobile = Get.find();
  RxBool isLoading = false.obs;

  RxString loggedInMobile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // _getUserMobileNumber();
  }

  // void _getUserMobileNumber() async {
  //   final result = await getLoggedInMobile();
  //   result.fold(
  //     (error) => loggedInMobile.value = "",
  //     (mobile) => loggedInMobile.value = mobile,
  //   );
  // }

  void handleFailure(Failure failure, bool isErrorDismissable) {
    status.value = StateStatus.error;
    isLoading.value = false;
    errorMessage.value = failure.message;
    if (isErrorDismissable) {
      CustomSnackbar.error(errorMessage.value.toString(),
      );
    } else {
      CustomSnackbar.error(errorMessage.value.toString());
    }
  }

  Future<void> doAction<T>({
    required Function action,
    required Function(T) onSuccess,
    Function(String?)? onError,
    bool? isErrorDismissable,
  }) async {
    status.value = StateStatus.loading;
    isLoading.value = true;
    var result = await action();
    await result.fold(
      (failure) async {
        isLoading.value = false;
        if (onError != null) {
          onError.call(failure.message['error'] ??
              failure.message['message'] ??
              failure.message['failure'] ??
              failure.message);
        }
        handleFailure(failure, isErrorDismissable ?? true);
      },
      (success) async {
        status.value = StateStatus.success;
        isLoading.value = false;
        await onSuccess(success);
      },
    );
  }
}
