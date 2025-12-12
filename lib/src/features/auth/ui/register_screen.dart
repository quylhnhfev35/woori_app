import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woori_app/src/core/widget/custom_app_bar.dart';
import 'package:woori_app/src/core/widget/custom_input.dart';
import 'package:woori_app/src/core/network/api_exception.dart';
import 'package:woori_app/src/features/auth/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _rePasswordFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  String _usernameError = '';
  String _passwordError = '';
  String _rePasswordError = '';
  String _fullNameError = '';
  String _phoneError = '';

  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();

    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _rePasswordFocus.dispose();
    _fullNameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  // Validation methods
  bool _validateUsername(String value) {
    if (value.isEmpty) return false;
    if (value.length < 3) return false;
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return regex.hasMatch(value);
  }

  bool _validatePasswordStructure(String value) {
    if (value.length < 8) return false;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    return hasLetter && hasDigit;
  }

  bool _validateFullName(String value) {
    if (value.isEmpty) return false;
    return value.trim().length >= 2;
  }

  bool _validatePhone(String value) {
    if (value.isEmpty) return false;
    final regex = RegExp(r'^(0|\+84)\d{9,10}$');
    return regex.hasMatch(value);
  }

  void _validateAllFields() {
    setState(() {
      // Validate username
      final username = _usernameController.text.trim();
      if (username.isEmpty) {
        _usernameError = 'Tên đăng nhập không được để trống';
      } else if (!_validateUsername(username)) {
        _usernameError =
            'Tên đăng nhập tối thiểu 3 ký tự, chỉ chứa chữ, số và dấu gạch dưới';
      } else {
        _usernameError = '';
      }

      // Validate password
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = 'Mật khẩu không được để trống';
      } else if (!_validatePasswordStructure(password)) {
        _passwordError =
            'Mật khẩu tối thiểu 8 ký tự, bao gồm chữ cái và số';
      } else {
        _passwordError = '';
      }

      // Validate re-password
      final rePassword = _rePasswordController.text;
      if (rePassword.isEmpty) {
        _rePasswordError = 'Vui lòng nhập lại mật khẩu';
      } else if (rePassword != password) {
        _rePasswordError = 'Mật khẩu nhập lại không khớp';
      } else {
        _rePasswordError = '';
      }

      // Validate full name
      final fullName = _fullNameController.text.trim();
      if (fullName.isEmpty) {
        _fullNameError = 'Họ và tên không được để trống';
      } else if (!_validateFullName(fullName)) {
        _fullNameError = 'Họ và tên phải có ít nhất 2 ký tự';
      } else {
        _fullNameError = '';
      }

      // Validate phone
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Số điện thoại không được để trống';
      } else if (!_validatePhone(phone)) {
        _phoneError = 'Số điện thoại chưa đúng định dạng';
      } else {
        _phoneError = '';
      }
    });
  }

  bool get _canSubmit {
    return _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _rePasswordController.text.isNotEmpty &&
        _fullNameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _usernameError.isEmpty &&
        _passwordError.isEmpty &&
        _rePasswordError.isEmpty &&
        _fullNameError.isEmpty &&
        _phoneError.isEmpty &&
        !_isSubmitting;
  }

  Future<void> _onRegister() async {
    // Validate all fields first
    _validateAllFields();

    // Nếu còn lỗi thì không submit
    if (_usernameError.isNotEmpty ||
        _passwordError.isNotEmpty ||
        _rePasswordError.isNotEmpty ||
        _fullNameError.isNotEmpty ||
        _phoneError.isNotEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Gọi AuthController.register
    await ref.read(authControllerProvider.notifier).register(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          hoTen: _fullNameController.text.trim(),
          soDienThoai: _phoneController.text.trim(),
        );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    final state = ref.read(authControllerProvider);

    if (!state.isLoading && !state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe lỗi từ AuthController và show Snackbar
    ref.listen<AsyncValue<void>>(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final msg =
              err is ApiException ? err.message : 'Đăng ký thất bại';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        },
      );
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: 'Đăng ký tài khoản',
          showBackButton: true,
        ),
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                  children: [
                    const SizedBox(height: 10),

                    // Tên đăng nhập
                    CustomInput(
                      label: 'Tên đăng nhập',
                      icon: Icons.person,
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      isRequired: true,
                      keyboardType: TextInputType.text,
                      errorText: _usernameError,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty || _validateUsername(value)) {
                            _usernameError = '';
                          } else {
                            _usernameError =
                                'Tên đăng nhập tối thiểu 3 ký tự, chỉ chứa chữ, số và dấu gạch dưới';
                          }
                        });
                      },
                      onSubmitted: () => _passwordFocus.requestFocus(),
                    ),

                    // Mật khẩu
                    const SizedBox(height: 12),
                    CustomInput(
                      label: 'Mật khẩu',
                      icon: Icons.lock,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      isPassword: true,
                      isRequired: true,
                      keyboardType: TextInputType.text,
                      errorText: _passwordError,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty ||
                              _validatePasswordStructure(value)) {
                            _passwordError = '';
                          } else {
                            _passwordError =
                                'Mật khẩu tối thiểu 8 ký tự, bao gồm chữ cái và số';
                          }

                          // Check re-password
                          final rePass = _rePasswordController.text;
                          if (rePass.isNotEmpty && rePass != value) {
                            _rePasswordError =
                                'Mật khẩu nhập lại không khớp';
                          } else {
                            _rePasswordError = '';
                          }
                        });
                      },
                      onSubmitted: () => _rePasswordFocus.requestFocus(),
                    ),

                    // Nhập lại mật khẩu
                    const SizedBox(height: 12),
                    CustomInput(
                      label: 'Nhập lại mật khẩu',
                      icon: Icons.lock_outline,
                      controller: _rePasswordController,
                      focusNode: _rePasswordFocus,
                      isPassword: true,
                      isRequired: true,
                      keyboardType: TextInputType.text,
                      errorText: _rePasswordError,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty ||
                              value == _passwordController.text) {
                            _rePasswordError = '';
                          } else {
                            _rePasswordError =
                                'Mật khẩu nhập lại không khớp';
                          }
                        });
                      },
                      onSubmitted: () => _fullNameFocus.requestFocus(),
                    ),

                    // Họ và tên
                    const SizedBox(height: 12),
                    CustomInput(
                      label: 'Họ và tên',
                      icon: Icons.badge,
                      controller: _fullNameController,
                      focusNode: _fullNameFocus,
                      isRequired: true,
                      keyboardType: TextInputType.name,
                      errorText: _fullNameError,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty || _validateFullName(value)) {
                            _fullNameError = '';
                          } else {
                            _fullNameError =
                                'Họ và tên phải có ít nhất 2 ký tự';
                          }
                        });
                      },
                      onSubmitted: () => _phoneFocus.requestFocus(),
                    ),

                    // Số điện thoại
                    const SizedBox(height: 12),
                    CustomInput(
                      label: 'Số điện thoại',
                      icon: Icons.phone_rounded,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      errorText: _phoneError,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty || _validatePhone(value)) {
                            _phoneError = '';
                          } else {
                            _phoneError =
                                'Số điện thoại chưa đúng định dạng';
                          }
                        });
                      },
                      onSubmitted: () => _onRegister(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Nút Đăng ký
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canSubmit ? _onRegister : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}