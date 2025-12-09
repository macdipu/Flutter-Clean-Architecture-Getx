import 'package:clean_architecture_getx/app/flavours/app_config.dart';
import 'package:get/get.dart';

part 'authentication_api_urls.dart';
part 'dashboard_api_urls.dart';
part 'trade_api_urls.dart';

class ApiUrl implements AuthenticationApiUrls, DashboardApiUrls, TradeApiUrls {
  final AppConfig appConfig = Get.find();
  get baseUrl => "${appConfig.getApiClientConfig().baseUrl}api/";
  get apiVersion => appConfig.getApiClientConfig().apiVersion;

  @override
  String get emailLoginUrl => "${baseUrl}Account/Login";

  @override
  String get facebookLoginUrl => throw UnimplementedError();

  @override
  String get gmailLoginUrl => throw UnimplementedError();

  @override
  String get registrationUrl => throw UnimplementedError();

  @override
  String get getAllTrade => "${baseUrl}Item/getall";

  @override
  String get getDashboardData => throw UnimplementedError();

  String get refreshTokenUrl => '${baseUrl}auth/refresh-token';
}
