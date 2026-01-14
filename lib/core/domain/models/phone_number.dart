class PhoneNumber {
  final String _value;

  PhoneNumber._(this._value);

  factory PhoneNumber(String input) {
    final normalized = _normalize(input);
    if (!_isValid(normalized)) {
      throw FormatException('Invalid Bangladeshi mobile number: $input');
    }
    return PhoneNumber._(normalized);
  }

  static PhoneNumber? tryParse(String input) {
    try {
      return PhoneNumber(input);
    } catch (_) {
      return null;
    }
  }

  static bool isValid(String input) {
    try {
      final normalized = _normalize(input);
      return _isValid(normalized);
    } catch (_) {
      return false;
    }
  }

  static String _normalize(String input) {
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');

    // Format: 8801XXXXXXXXX (13 digits)
    if (digits.startsWith('880') && digits.length == 13) {
      return '+$digits';
    }

    // Format: 01XXXXXXXXX (11 digits) - most common user input
    if (digits.startsWith('0') && digits.length == 11) {
      return '+880${digits.substring(1)}';
    }

    // Format: 1XXXXXXXXX (10 digits)
    if (digits.startsWith('1') && digits.length == 10) {
      return '+880$digits';
    }

    throw FormatException('Invalid phone number format');
  }

  static bool _isValid(String value) {
    return RegExp(r'^\+8801[3-9]\d{8}$').hasMatch(value);
  }

  String get withCountryCode => _value;

  String get withoutCountryCode => '0${_value.substring(4)}';

  String get formatted {
    final local = withoutCountryCode;
    return '${local.substring(0, 5)}-${local.substring(5)}';
  }

  String get operator {
    final secondDigit = _value[5];
    return switch (secondDigit) {
      '3' || '7' => 'Grameenphone',
      '6' || '8' => 'Robi',
      '4' || '9' => 'Banglalink',
      '5' => 'Teletalk',
      _ => 'Unknown',
    };
  }

  @override
  String toString() => _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}

// String _getErrorMessage(String value) {
//   final digits = value.replaceAll(RegExp(r'[^\d]'), '');
//
//   if (digits.isEmpty) {
//     return 'Phone number is required';
//   }
//
//   if (digits.length < 10) {
//     return 'Phone number too short (at least 10 digits)';
//   }
//
//   if (digits.length > 13) {
//     return 'Phone number too long (max 13 digits)';
//   }
//
//   if (!digits.startsWith('0') && !digits.startsWith('1') && !digits.startsWith('880')) {
//     return 'Must start with 0, 1, or 880';
//   }
//
//   return 'Invalid phone number format';
// }
//
// void _handleSubmit() {
//   if (_phoneNumber != null) {
//     widget.onSubmitted?.call(_phoneNumber!);
//   }
// }
