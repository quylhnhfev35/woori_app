import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woori_app/src/core/network/api_exception.dart';
import 'package:woori_app/src/core/widget/app_dialog.dart';
import 'package:woori_app/src/features/auth/auth_controller.dart';
import 'package:woori_app/src/services/biometric_auth_service.dart';
import 'package:woori_app/src/services/local_storage_service.dart';

import 'widgets/login_form.dart';
import 'widgets/login_bottom_signup.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  String _usernameError = '';
  String _passwordError = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initLoginScreen();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _initLoginScreen() async {
    final storage = LocalStorageService.instance;
    await storage.init();

    // Auto-fill username lần đăng nhập gần nhất
    final lastUsername = storage.lastUsername;
    if (mounted && lastUsername != null && lastUsername.isNotEmpty) {
      setState(() {
        _usernameController.text = lastUsername;
      });
    }

    // Nếu user đã bật biometric -> tự động gọi login bằng biometrics
    if (storage.isBiometricEnabled) {
      final ok =
          await ref.read(authControllerProvider.notifier).loginWithBiometrics();

      if (!mounted) return;

      if (ok) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _usernameError = '';
      _passwordError = '';
    });
    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty) {
      setState(() => _usernameError = 'Vui lòng nhập tên đăng nhập');
      _usernameFocus.requestFocus();
      return;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Vui lòng nhập mật khẩu');
      _passwordFocus.requestFocus();
      return;
    }

    final storage = LocalStorageService.instance;
    final bioService = BiometricAuthService.instance;

    // Chỉ hỏi nếu CHƯA bật biometric
    if (!storage.isBiometricEnabled) {
      final imageType = await bioService.imageTouchFaceType();

      if (imageType != 0) {
        final dialog = AppDialog(context);
        final option = await dialog.showBiometricConfirm(
          isFaceId: imageType == 2,
        );

        if (!mounted) return;

        if (option == Option.ok) {
          final result = await bioService.checkSupportTouchFace(
            appName: 'Woori App',
          );

          if (result == 'Authorized') {
            await storage.setBiometricEnabled(true);
          } else if (result == 'Not Authorized') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Xác thực không hợp lệ.')),
            );
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result)),
            );
            return;
          }
        }
      }
    }

    // --- BƯỚC 2: Call API đăng nhập ---
    await ref.read(authControllerProvider.notifier).login(username, password);

    final state = ref.read(authControllerProvider);
    if (!state.isLoading && !state.hasError) {
      if (!mounted) return;

      // LƯU username lần đăng nhập gần nhất (nếu bạn đã thêm hàm)
      await LocalStorageService.instance.saveLastUsername(username);

      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _handleBiometricLogin() async {
    FocusScope.of(context).unfocus();
    final ok =
        await ref.read(authControllerProvider.notifier).loginWithBiometrics();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Đăng nhập bằng FaceID/TouchID thành công'
              : 'Không thể đăng nhập bằng FaceID/TouchID',
        ),
      ),
    );

    if (ok) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _onUsernameChanged(String _) {
    if (_usernameError.isNotEmpty) {
      setState(() {
        _usernameError = '';
      });
    }
  }

  void _onPasswordChanged(String _) {
    if (_passwordError.isNotEmpty) {
      setState(() {
        _passwordError = '';
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final msg = err is ApiException ? err.message : 'Đăng nhập thất bại';
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          }
        },
      );
    });

    final authState = ref.watch(authControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: LoginForm(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        usernameFocus: _usernameFocus,
                        passwordFocus: _passwordFocus,
                        usernameError: _usernameError,
                        passwordError: _passwordError,
                        obscurePassword: _obscurePassword,
                        isLoading: authState.isLoading,
                        onUsernameChanged: _onUsernameChanged,
                        onPasswordChanged: _onPasswordChanged,
                        onTogglePasswordVisibility: _togglePasswordVisibility,
                        onLoginPressed: _handleLogin,
                        onBiometricPressed: _handleBiometricLogin,
                      ),
                    ),
                  ),
                ),
                LoginBottomSignup(
                  primary: primary,
                  textColor: textColor,
                  onRegisterPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}