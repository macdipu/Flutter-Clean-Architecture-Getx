import 'dart:convert';

import 'package:flutter_clean_architecture_getx/core/domain/models/phone_number.dart';

class UserInfo {
  final PhoneNumber? phoneNumber;
  final String? fullName;
  final String? ogrName;
  final String? role;
  final String accessToken;
  final String? refreshToken;
  final String? email;

  UserInfo({
    this.phoneNumber,
    this.fullName,
    this.ogrName,
    this.role,
    required this.accessToken,
    required this.refreshToken,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'phone_number': phoneNumber?.withoutCountryCode,
        'fullName': fullName,
        'ogrName': ogrName,
        'role': role,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'email': email,
      };

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        phoneNumber: json['phone_number'] != null
            ? PhoneNumber(json['phone_number'])
            : null,
        fullName: json['fullName'],
        ogrName: json['ogrName'],
        role: json['role'],
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        email: json['email'],
      );

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory UserInfo.fromJsonString(String json) {
    return UserInfo.fromJson(jsonDecode(json));
  }
}
