import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class TouchFaceService {
  TouchFaceService._();
  static final TouchFaceService instance = TouchFaceService._();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<String> authenticateWithBiometrics({
    String appName = 'ứng dụng',
  }) async {
    bool supported = false;

    // Thiết bị có support không
    try {
      supported = await _auth.isDeviceSupported();
    } on PlatformException {
      supported = false;
    }

    if (!supported) {
      return 'Thiết bị của bạn không hỗ trợ Touch ID/Face ID';
    }

    // Có bật biometrics không
    try {
      supported = await _auth.canCheckBiometrics;
    } on PlatformException {
      supported = false;
    }

    if (!supported) {
      return 'Thiết bị của bạn không thể dùng Touch ID/Face ID';
    }

    // Lấy loại biometric
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException {
      // ignore
    }

    if (availableBiometrics.isEmpty) {
      return 'Thiết bị của bạn đang không kích hoạt Touch ID/Face ID';
    }

    String biometricsType = 'Face ID';
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      biometricsType = 'Touch ID';
    }

    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Sử dụng $biometricsType để mở khóa $appName',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      authenticated = false;
    }

    return authenticated ? 'Authorized' : 'Not Authorized';
  }

  // 0: không hỗ trợ, 1: fingerprint, 2: face
  Future<int> getBiometricIconType() async {
    bool supported = false;

    try {
      supported = await _auth.isDeviceSupported();
    } on PlatformException {
      supported = false;
    }
    if (!supported) return 0;

    try {
      supported = await _auth.canCheckBiometrics;
    } on PlatformException {
      supported = false;
    }
    if (!supported) return 0;

    List<BiometricType> biometrics = [];
    try {
      biometrics = await _auth.getAvailableBiometrics();
    } on PlatformException {
      // ignore
    }

    if (biometrics.isEmpty) return 0;
    return biometrics.contains(BiometricType.fingerprint) ? 1 : 2;
  }
}