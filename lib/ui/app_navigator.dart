import 'package:flutter/cupertino.dart';
import 'package:flutter_study/ui/roots/auth.dart';
import 'package:flutter_study/ui/roots/loader.dart';
import 'package:flutter_study/ui/roots/app.dart';
import 'package:flutter_study/ui/roots/profile.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/profile";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static void toAuth() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static void toProfile() {
    key.currentState?.pushNamed(NavigationRoutes.app);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => LoaderWidget.create()));
      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Auth.create()));
      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => App.create()));
      case NavigationRoutes.profile:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => Profile.create()));
    }
    return null;
  }
}
