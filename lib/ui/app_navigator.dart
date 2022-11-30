import 'package:flutter/cupertino.dart';
import 'package:flutter_study/ui/roots/auth.dart';
import 'package:flutter_study/ui/roots/loader.dart';
import 'package:flutter_study/ui/roots/home.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const home = "/home";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toLoader() {
    key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static void toAuth() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static void toHome() {
    key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.home, ((route) => false));
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => LoaderWidget.create()));
      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Auth.create()));
      case NavigationRoutes.home:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => const Home(
                  title: "Hi",
                )));
    }
    return null;
  }
}
