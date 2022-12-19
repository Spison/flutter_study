import 'package:flutter/cupertino.dart';
import 'package:flutter_study/ui/roots/auth.dart';
import 'package:flutter_study/ui/roots/loader.dart';
import 'package:flutter_study/ui/roots/app.dart';
import 'package:flutter_study/ui/roots/profile/profile.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/app/profile";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return await key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static Future toAuth() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static Future toHome() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static Future toProfile(BuildContext bc) async {
    return await key.currentState?.pushNamed(NavigationRoutes.profile);
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
      // case NavigationRoutes.profile:
      //   return PageRouteBuilder(
      //       pageBuilder: ((_, __, ___) => Profile.create(context: bc)));
    }
    return null;
  }
}
