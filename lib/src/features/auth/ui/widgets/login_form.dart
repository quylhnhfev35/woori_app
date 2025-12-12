import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocus,
    required this.passwordFocus,
    required this.usernameError,
    required this.passwordError,
    required this.obscurePassword,
    required this.isLoading,
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.onTogglePasswordVisibility,
    required this.onLoginPressed,
    required this.onBiometricPressed,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final FocusNode usernameFocus;
  final FocusNode passwordFocus;

  final String usernameError;
  final String passwordError;
  final bool obscurePassword;
  final bool isLoading;

  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLoginPressed;
  final VoidCallback onBiometricPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ô nhập tên đăng nhập
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Colors.grey[100],
          ),
          child: TextField(
            focusNode: usernameFocus,
            controller: usernameController,
            onChanged: onUsernameChanged,
            cursorColor: primary,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 20.0),
            onSubmitted: (_) {
              passwordFocus.requestFocus();
            },
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                width: 30,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: usernameError.isNotEmpty
                      ? Colors.red
                      : (usernameFocus.hasFocus ||
                              usernameController.text.trim().isNotEmpty)
                          ? primary
                          : (textColor ?? Colors.black),
                ),
              ),
              hintText: 'Nhập tên đăng nhập',
              hintStyle: const TextStyle(fontSize: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: usernameError.isNotEmpty ? Colors.red : Colors.white,
                  width: usernameError.isNotEmpty ? 1 : 0.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      usernameError.isNotEmpty ? Colors.red : Colors.lightGreen,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Ô nhập mật khẩu
        Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Colors.grey[100],
          ),
          child: TextField(
            focusNode: passwordFocus,
            controller: passwordController,
            onChanged: onPasswordChanged,
            cursorColor: primary,
            obscureText: obscurePassword,
            style: const TextStyle(fontSize: 20.0),
            onSubmitted: (_) => onLoginPressed(),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                width: 30,
                child: Icon(
                  Icons.lock,
                  size: 30,
                  color: passwordError.isNotEmpty
                      ? Colors.red
                      : (passwordFocus.hasFocus ||
                              passwordController.text.isNotEmpty)
                          ? primary
                          : (textColor ?? Colors.black),
                ),
              ),
              hintText: 'Nhập mật khẩu',
              hintStyle: const TextStyle(fontSize: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: passwordError.isNotEmpty ? Colors.red : Colors.white,
                  width: passwordError.isNotEmpty ? 1 : 0.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color:
                      passwordError.isNotEmpty ? Colors.red : Colors.lightGreen,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  obscurePassword
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  color: const Color(0xDC7C837F),
                  size: 20,
                ),
              ),
            ),
          ),
        ),

        // Dòng error
        Container(
          height: 20,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            usernameError +
                (usernameError.isNotEmpty && passwordError.isNotEmpty
                    ? '\n'
                    : '') +
                passwordError,
            maxLines: 2,
            style: const TextStyle(color: Colors.red),
          ),
        ),

        // Nút Đăng nhập
        GestureDetector(
          onTap: isLoading ? null : onLoginPressed,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              color: isLoading ? primary.withValues(alpha: 0.5) : primary,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Icon TouchID / FaceID
        GestureDetector(
          onTap: onBiometricPressed,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Icon(
              Icons.fingerprint,
              size: 50,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}