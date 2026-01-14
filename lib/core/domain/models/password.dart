class Password {
  final String _value;

  Password._(this._value);

  factory Password(String input) {
    if (!_isValid(input)) {
      throw FormatException('Invalid password');
    }
    return Password._(input);
  }

  static Password? tryParse(String input) {
    try {
      return Password(input);
    } catch (_) {
      return null;
    }
  }

  static bool isValid(String input) {
    return _isValid(input);
  }

  static bool _isValid(String value) {
    return value.length >= 6;
  }

  String get value => _value;

  @override
  String toString() => '******';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Password && other._value == _value;

  @override
  int get hashCode => _value.hashCode;
}
