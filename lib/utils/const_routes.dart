import 'package:flutter/material.dart';
import 'package:social_media_app/modules/dashboard/dashboard.dart';
import 'package:social_media_app/modules/login/login_screen.dart';
import 'package:social_media_app/modules/sign_up/sign_up_screen.dart';

class ConstRoutes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signUp = '/signUp';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ConstRoutes.dashboard:
      return MaterialPageRoute(
          builder: (_) => const Dashboard(), settings: settings);

    case ConstRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage(), settings: settings);

    case ConstRoutes.signUp:
      return MaterialPageRoute(builder: (_) => const SignUpScreen(), settings: settings);

    default:
      return MaterialPageRoute(
          builder: (_) => const LoginPage(), settings: settings);
  }
}