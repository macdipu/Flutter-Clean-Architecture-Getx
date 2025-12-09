import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/flavours/app_flavour.dart';
import 'app/views/app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  bootstrap(() => const MyApp());
}
