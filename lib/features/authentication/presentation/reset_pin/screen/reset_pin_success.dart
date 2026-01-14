import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/gap/custom_space.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/appbar/common_appbar.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/buttons/common_button.dart';
import 'package:flutter_clean_architecture_getx/core/presentation/widgets/images/round_image.dart';
import 'package:flutter_clean_architecture_getx/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import 'package:flutter_clean_architecture_getx/res/resources.dart';
import 'package:flutter_clean_architecture_getx/res/routes/app_routes.dart';

class ResetPinSuccess extends GetView<ForgotPinController> {
  ResetPinSuccess({super.key});

  final _formKey = GlobalKey<FormState>();
  final theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppbar(
          title: 'Reset PIN',
        ),
        body: _pageBody(),
      ),
    );
  }

  _pageBody() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CRoundImage(imagePath: Resources.drawable.checkmark),
            customSpace(height: 24),
            Text('PIN Changed!', style: TextStyle(fontSize:20, fontWeight: FontWeight.w500) ,),
            customSpace(height: 24),
            Text('Your PIN has been Changed successfully!', style: TextStyle(fontSize:14) , textAlign: TextAlign.center,),
            customSpace(height: 24),
            _continue_btn(),
          ],
        ),
      ),
    );
  }


  _continue_btn() {
    return CommonButton(
      key: const ValueKey("continue_button"),
      title: 'Continue',
      bgColor: theme.colorScheme.onPrimary,
      borderColor: theme.colorScheme.primary,
      textStyle: TextStyle(color: theme.colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w500),
      height: 48,
      onTap: () async {
          Get.offAllNamed(AppRoutes.login,);
      },
    );
  }
}
