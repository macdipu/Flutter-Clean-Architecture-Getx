import '../core/presentation/resources/colors/app_colors.dart';
import '../core/presentation/resources/dimensions/app_dimension.dart';
import '../core/presentation/style/app_style.dart';
import 'drawable/app_drawable.dart';

class Resources {
  static AppColors get color {
    return AppColors();
  }

  static AppDimension get dimension {
    return AppDimension();
  }

  static AppTextStyle get style {
    return AppTextStyle();
  }

  static AppDrawable get drawable {
    return AppDrawable();
  }
}
