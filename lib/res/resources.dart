import 'drawable/app_drawable.dart';

class Resources {
  // Private constructor
  Resources._();

  // Singleton instances (created once and reused)
  static final AppDrawable _drawable = AppDrawable();

  static AppDrawable get drawable => _drawable;
}
