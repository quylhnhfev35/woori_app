// lib/src/features/auth/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori_app/src/features/auth/auth_repository.dart';
import 'package:woori_app/src/services/biometric_auth_service.dart';
import 'package:woori_app/src/services/local_storage_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  (ref) => AuthController(AuthRepository()),
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repo) : super(const AsyncData(null));

  final AuthRepository _repo;

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      await _repo.login(username: username, password: password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String hoTen,
    String? soDienThoai,
  }) async {
    state = const AsyncLoading();
    try {
      await _repo.register(
        username: username,
        password: password,
        hoTen: hoTen,
        soDienThoai: soDienThoai,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> loginWithBiometrics() async {
    final enabled = LocalStorageService.instance.isBiometricEnabled;
    if (!enabled) return false;

    final ok = await BiometricAuthService.instance.authenticate();
    return ok;
  }

  Future<void> enableBiometrics(bool enabled) async {
    await LocalStorageService.instance.setBiometricEnabled(enabled);
  }
}