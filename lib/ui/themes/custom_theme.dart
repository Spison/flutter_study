import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        //2
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.amber.shade100,
        canvasColor: Colors.amber.shade300,
        fontFamily: 'Montserrat', //3
        textTheme: ThemeData.light().textTheme,
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
