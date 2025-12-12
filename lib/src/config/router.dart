import 'package:flutter/material.dart';
import 'package:woori_app/src/features/auth/ui/register_screen.dart';
import 'package:woori_app/src/features/auth/ui/login_screen.dart';
import 'package:woori_app/src/features/main/ui/main_bottom_nav_screen.dart';

class AppRouter {
  static const String initialRoute = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      // ADDED: màn bottom navigation
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const MainBottomNavScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}