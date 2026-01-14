import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class CommonPinInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final bool readOnly;
  final ValueChanged<String>? onCompleted;

  const CommonPinInputField({
    super.key,
    required this.onChanged,
    this.controller,
    this.readOnly = false,
    this.onCompleted,
  });

  @override
  State<CommonPinInputField> createState() => _CommonPinInputFieldState();
}

class _CommonPinInputFieldState extends State<CommonPinInputField> {
  late FocusNode focusNode = FocusNode();
  late final SmsRetriever smsRetriever;

  @override
  void initState() {
    super.initState();
    smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
  }

  @override
  void dispose() {
    smsRetriever.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _fieldValidator,
        builder: (formValue) {
          return Column(
            children: [
              Pinput(
                focusNode: focusNode,
                textInputAction: TextInputAction.next,
                controller: widget.controller ?? TextEditingController(),
                length: 6,
                obscureText: false,
                pinAnimationType: PinAnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                keyboardType: TextInputType.number,
                autofillHints: [AutofillHints.oneTimeCode],
                defaultPinTheme: PinTheme(
                  width: 40,
                  height: 50,
                  textStyle: theme.textTheme.titleLarge!
                      .copyWith(color: theme.colorScheme.onSurface),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: theme.colorScheme.surface.withValues(alpha: 0.1),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 40,
                  height: 50,
                  textStyle: theme.textTheme.titleLarge!
                      .copyWith(color: theme.colorScheme.onSurface),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: theme.colorScheme.surface,
                  ),
                ),
                onChanged: (value) {
                  widget.onChanged(value);
                },
                onCompleted: widget.onCompleted,
                smsRetriever: smsRetriever,
              ),
              formValue.hasError
                  ? Text(
                      formValue.errorText ?? "",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.start,
                    )
                  : const SizedBox.shrink(),
            ],
          );
        });
  }

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP cannot be empty';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    if (value.length < 6) {
      return 'OTP must be 6 digits long';
    }
    return null;
  }


}
class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.hasData   ) {
      final code = RegExp(r'(\d{6})').stringMatch(res.data?.code ?? "") ?? '';
      return code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}