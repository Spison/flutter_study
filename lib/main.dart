import 'package:flutter/material.dart';
import 'package:flutter_study/ui/app_navigator.dart';
import 'package:flutter_study/ui/roots/loader.dart';
import 'package:flutter_study/ui/themes/custom_theme.dart';

import 'data/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) =>
          AppNavigator.onGeneratedRoutes(settings, context),
      theme: CustomTheme.darkTheme,
      home: LoaderWidget.create(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
