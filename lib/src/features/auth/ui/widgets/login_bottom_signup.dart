import 'package:flutter/material.dart';

class LoginBottomSignup extends StatelessWidget {
  const LoginBottomSignup({
    super.key,
    required this.primary,
    required this.textColor,
    required this.onRegisterPressed,
  });

  final Color primary;
  final Color? textColor;
  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bạn chưa có tài khoản?  ',
          style: TextStyle(
            fontSize: 15,
            color: textColor ?? Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onRegisterPressed,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Đăng ký',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}