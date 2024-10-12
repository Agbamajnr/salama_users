import 'package:flutter/material.dart';
import 'package:salama_users/routes/router_names.dart';
import 'package:salama_users/screens/auth/login_screen.dart';
import 'package:salama_users/screens/splash.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.startUp:
      return _getPageRoute(
          routeName: settings.name, viewToShow: const SplashScreen());
    case Routes.login:
      return _getPageRoute(routeName: settings.name, viewToShow: LoginScreen());

    default:
      return MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}

// ignore: strict_raw_type
PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
  return MaterialPageRoute<void>(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow!,
  );
}
