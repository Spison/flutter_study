import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        //2
        primaryColor: Colors.amber,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.amber.shade100,
        canvasColor: Colors.amber.shade300,
        fontFamily: 'Montserrat', //3
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headline2: TextStyle(fontSize: 14.0, color: Colors.black),
          headline6: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ), //email
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        elevatedButtonTheme:
            const ElevatedButtonThemeData(style: ButtonStyle()),
        appBarTheme: const AppBarTheme(
          color: Colors.amber,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.amber.shade300,
        ),
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          // buttonColor: CustomColors.lightPurple,
          buttonColor: Colors.purple.shade300,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.grey.shade800,
        canvasColor: Colors.grey.shade800,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.dark().textTheme,
        drawerTheme: ThemeData.dark().drawerTheme,
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purple.shade300,
        ));
  }
}
