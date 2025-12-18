import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if device supports biometric authentication
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  // Check if biometrics are available
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticate({
    String reason = 'Silakan autentikasi untuk melanjutkan',
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      final isSupported = await isDeviceSupported();

      if (!canCheck || !isSupported) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }

  // Get biometric type name for display
  String getBiometricTypeName(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong)) {
      return 'Biometric';
    }
    return 'Biometric';
  }

  // Check if biometric is enrolled
  Future<bool> isBiometricEnrolled() async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
  }
}
