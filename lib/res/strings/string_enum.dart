import 'package:get/get.dart';

enum TextEnum{
  appName(en: "Flutter Demo", bn: "ফ্লাটার ডেমো"),
  verify(en: "Verify", bn: "যাচাই করুন"),
  send(en: "Send", bn: "পাঠান"),
  submit(en: "Submit", bn: "জমা দিন"),
  ok(en: "OK", bn: "ঠিক আছে"),
  cancel(en: "Cancel", bn: "বাতিল করুন"),
  resend(en: "Resend", bn: "পুনরায় পাঠান"),
  about(en: "About", bn: "সম্পর্কে"),
  contactUs(en: "Contact Us", bn: "যোগাযোগ করুন"),
  loginDescription(
      en: "We will send --------- code to login",
      bn: "আমরা লগইন করার জন্য --------- কোড পাঠাব"),
  loginUpperText(en: "Login to continue", bn: "চালিয়ে যাওয়ার জন্য লগইন করুন"),
  next(en: "Next", bn: "পরবর্তী"),
  otpResend(
      en: "OTP will be sent again in @time",
      bn: '@time এবার OTP পাঠাবেন'
  ),
  // Add more entries as required
  ;

  final String en;
  final String bn;

  const TextEnum({required this.en, required this.bn});
}

extension TextEnumExtention on TextEnum {
  String get _key => name;
  String get tr => _key.tr;
  String trParams([Map<String, String>? params]) => _key.trParams(params ?? {});
}
