import 'package:customer/services/utilities/device_info_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Map<String, dynamic>? useDeviceInfo() {
  final info = useState<Map<String, dynamic>?>(null);

  useEffect(() {
    DeviceInfoService.instance.getFullDeviceInfo().then(
      (result) => result.fold((_) => null, (data) => info.value = data),
    );
    return null;
  }, const []);

  return info.value;
}
