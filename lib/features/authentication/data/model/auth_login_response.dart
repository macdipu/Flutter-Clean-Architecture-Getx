class AuthLoginResponse {
  String? _role;
  String? _refreshToken;
  String? _accessToken;

  AuthLoginResponse({
    String? role,
    String? refreshToken,
    String? accessToken,
  })  : _role = role,
        _refreshToken = refreshToken,
        _accessToken = accessToken;

  String? get role => _role;
  String? get refreshToken => _refreshToken;
  String? get accessToken => _accessToken;

  AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    _role = json['role'];
    _refreshToken = json['refresh_token'];
    _accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'role': _role,
      'refresh_token': _refreshToken,
      'access_token': _accessToken,
    };
  }
}
