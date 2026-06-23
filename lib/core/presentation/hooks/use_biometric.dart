import 'package:customer/services/others/biometric_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:local_auth/local_auth.dart';

({
  bool isSupported,
  bool isEnrolled,
  bool isLoading,
  List<BiometricType> types,
  Future<bool> Function({String reason}) authenticate,
}) useBiometric() {
  final isSupported = useState(false);
  final isEnrolled = useState(false);
  final isLoading = useState(false);
  final types = useState<List<BiometricType>>(const []);

  useEffect(() {
    Future<void> init() async {
      isLoading.value = true;
      try {
        isSupported.value = await BiometricService.instance.isDeviceSupported();
        isEnrolled.value = await BiometricService.instance.isEnrolled();
        types.value = await BiometricService.instance.getAvailableBiometrics();
      } finally {
        isLoading.value = false;
      }
    }

    init();
    return null;
  }, const []);

  Future<bool> authenticate({String reason = 'Authenticate to continue'}) async {
    isLoading.value = true;
    try {
      return await BiometricService.instance.authenticate(reason: reason);
    } finally {
      isLoading.value = false;
    }
  }

  return (
    isSupported: isSupported.value,
    isEnrolled: isEnrolled.value,
    isLoading: isLoading.value,
    types: types.value,
    authenticate: authenticate,
  );
}