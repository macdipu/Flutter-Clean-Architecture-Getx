import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class BiometricService {
  BiometricService._();
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnrolled() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      if (!canCheck) return false;
      final biometrics = await _auth.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Returns true only if the device supports biometrics AND has enrolled credentials.
  Future<bool> canAuthenticate() async {
    final supported = await isDeviceSupported();
    if (!supported) return false;
    return isEnrolled();
  }

  /// Returns the list of enrolled biometric types (fingerprint, face, iris).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Future<bool> authenticate({
    String reason = 'Authenticate to continue',
    bool biometricOnly = false,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: biometricOnly,
      );
    } catch (e) {
      if (kDebugMode) print('BiometricService.authenticate error: $e');
      return false;
    }
  }

  /// Opens system settings to enroll biometrics.
  /// On iOS opens app settings; on Android opens Security settings via intent URL.
  /// Add `android_intent_plus` to pubspec for a more targeted Android deep-link.
  Future<void> openEnrollmentSettings() async {
    if (Platform.isAndroid) {
      final uri = Uri.parse(
        'android-app://com.android.settings/.Settings\$SecuritySettingsActivity',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
      // Fallback: generic settings
      final fallback = Uri.parse('android-app://com.android.settings');
      if (await canLaunchUrl(fallback)) await launchUrl(fallback);
      return;
    }

    if (Platform.isIOS) {
      final uri = Uri.parse('app-settings:');
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    }
  }
}