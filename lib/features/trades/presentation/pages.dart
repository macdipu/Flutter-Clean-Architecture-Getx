import 'package:clean_architecture_getx/features/trades/presentation/screens/trades_screen.dart';
import 'package:get/get.dart';

import '../../../res/routes/app_routes.dart';

class TradesPages {
  static final routes = [
    GetPage(
      name: AppRoutes.trades,
      page: () => const TradesScreen(),
    ),
  ];
}
