import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

const Color customColor1 = Color(0xFF123456); // Replace with your custom color
const Color customColor2 = Color(0xFF654321);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  buttonTheme: ButtonThemeData(buttonColor: customColor1), // Using custom color
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: customColor2),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.grey[900],
  buttonTheme: ButtonThemeData(buttonColor: customColor2), // Using custom color
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: customColor1),
);
