import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService._internal();
  static final BiometricAuthService instance = BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  // Chỉ kiểm tra xem có thể dùng biometrics hay không
  Future<bool> canCheckBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  // Lấy danh sách loại biometrics đang có trên máy
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      final available = await canCheckBiometrics();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: 'Xác thực bằng FaceID/TouchID',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      // Log để debug, không show trực tiếp cho user
      print('Biometric error: ${e.code} - ${e.message}');
      return false;
    }
  }

  Future<String> checkSupportTouchFace({String appName = 'ứng dụng của bạn'}) async {
    bool isSupported = false;

    // 1. Thiết bị có hỗ trợ biometrics không
    try {
      isSupported = await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      isSupported = false;
      // LOG
      print('[BIOMETRIC] isDeviceSupported PlatformException: ${e.code} - ${e.message}');
    } catch (e) {
      isSupported = false;
      print('[BIOMETRIC] isDeviceSupported error: $e');
    }

    if (!isSupported) {
      print('[BIOMETRIC] Device not supported');
      return 'Thiết bị của bạn không hỗ trợ Touch ID/Face ID';
    }

    // 2. Hệ thống có cho check biometrics không
    bool canCheck = false;
    try {
      canCheck = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheck = false;
      print('[BIOMETRIC] canCheckBiometrics PlatformException: ${e.code} - ${e.message}');
    } catch (e) {
      canCheck = false;
      print('[BIOMETRIC] canCheckBiometrics error: $e');
    }

    if (!canCheck) {
      print('[BIOMETRIC] canCheckBiometrics = false');
      return 'Thiết bị của bạn không thể dùng Touch ID/Face ID';
    }

    // 3. Thiết bị đã đăng ký vân tay/face chưa
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('[BIOMETRIC] getAvailableBiometrics PlatformException: ${e.code} - ${e.message}');
      availableBiometrics = [];
    } catch (e) {
      print('[BIOMETRIC] getAvailableBiometrics error: $e');
      availableBiometrics = [];
    }

    print('[BIOMETRIC] availableBiometrics = $availableBiometrics');

    if (availableBiometrics.isEmpty) {
      return 'Thiết bị của bạn đang không kích hoạt Touch ID/Face ID';
    }

    // 4. Xác định loại (Face ID hay Touch ID) để hiển thị cho đẹp
    String biometricsType = 'Face ID';
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      biometricsType = 'Touch ID';
    }

    // 5. Thực hiện authenticate
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Sử dụng $biometricsType để mở khóa $appName',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      print('[BIOMETRIC] authenticate result = $authenticated');
    } on PlatformException catch (e) {
      print('[BIOMETRIC] authenticate PlatformException: ${e.code} - ${e.message}');
      authenticated = false;
    } catch (e) {
      print('[BIOMETRIC] authenticate error: $e');
      authenticated = false;
    }

    return authenticated ? 'Authorized' : 'Not Authorized';
  }

  // - 0: không hỗ trợ
  // - 1: có fingerprint -> icon vân tay
  // - 2: còn lại (face) -> icon face
  Future<int> imageTouchFaceType() async {
    bool isSupported = false;

    try {
      isSupported = await _auth.isDeviceSupported();
    } on PlatformException {
      isSupported = false;
    }

    if (!isSupported) return 0;

    bool canCheck = false;
    try {
      canCheck = await _auth.canCheckBiometrics;
    } on PlatformException {
      canCheck = false;
    }

    if (!canCheck) return 0;

    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException {
      availableBiometrics = [];
    }

    if (availableBiometrics.isEmpty) return 0;

    // fingerprint = 1, ngược lại = 2 (face)
    return availableBiometrics.contains(BiometricType.fingerprint) ? 1 : 2;
  }
}