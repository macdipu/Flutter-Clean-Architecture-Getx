import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.onkur.customer/core/presentation/widgets/appbar/common_appbar.dart';
import 'package:com.onkur.customer/core/presentation/widgets/buttons/common_button.dart';
import 'package:com.onkur.customer/core/presentation/widgets/images/round_image.dart';
import 'package:com.onkur.customer/features/authentication/presentation/reset_pin/controller/reset_pin_controller.dart';
import 'package:com.onkur.customer/res/resources.dart';
import 'package:com.onkur.customer/res/routes/app_routes.dart';

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
            CRoundImage(imagePath: Resources.drawable.loginUpperImage),
            Text('PIN Changed!', style: TextStyle(fontSize:20, fontWeight: FontWeight.w500) ,),
            Text('Your PIN has been Changed successfully!', style: TextStyle(fontSize:14) , textAlign: TextAlign.center,),
            _continue_btn(),
          ],
        ),
      ),
    );
  }


  _continue_btn() {
    return CommonButton.elevated(
      key: const ValueKey("continue_button"),
      title: 'Continue',
      onTap: () async {
          Get.offAllNamed(AppRoutes.login,);
      },
    );
  }
}
