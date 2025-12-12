import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/constants.dart';

class LocalStorageService {
  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --------- TOKEN ----------
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  Future<void> clearAccessToken() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
  }

  // Lưu username gần nhất
  Future<void> saveLastUsername(String username) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(AppConstants.lastUsernameKey, username);
  }

  // Đọc username gần nhất
  String? get lastUsername {
    return _prefs?.getString(AppConstants.lastUsernameKey);
  }

  // --------- BIOMETRIC FLAG ----------
  Future<void> setBiometricEnabled(bool enabled) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(AppConstants.isBiometricEnabledKey, enabled);
  }

  bool get isBiometricEnabled =>
      _prefs?.getBool(AppConstants.isBiometricEnabledKey) ?? false;
}