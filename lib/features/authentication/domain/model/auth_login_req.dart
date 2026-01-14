
import 'package:flutter_clean_architecture_getx/core/domain/models/password.dart';
import 'package:flutter_clean_architecture_getx/core/domain/models/phone_number.dart';

class AuthLoginReq {
  final PhoneNumber _phoneNumber;
  final Password _password;

  AuthLoginReq({
    required PhoneNumber phoneNumber,
    required Password password,
  })  : _phoneNumber = phoneNumber,
        _password = password;

  PhoneNumber get phoneNumber => _phoneNumber;
  Password get password => _password;

  Map<String, dynamic> toJson() {
    return {
      'phone_number': _phoneNumber.withoutCountryCode,
      'password': _password.value,
    };
  }
}
