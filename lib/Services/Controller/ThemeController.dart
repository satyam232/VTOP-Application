import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/utils/Colors.dart';

enum AppTheme { theme1, theme2, theme3, theme4 }

class ThemeController extends GetxController {
  var currentTheme = AppTheme.theme2.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPreferences(); // Load the saved theme when the controller is initialized
  }

  void switchTheme(AppTheme theme) async {
    currentTheme.value = theme;
    saveThemeToPreferences(theme); // Save the selected theme to preferences
  }

  ThemeData get themeData {
    switch (currentTheme.value) {
      case AppTheme.theme1:
        return ThemeData(
          primaryColor: AppColors.primaryColors1,
          scaffoldBackgroundColor: AppColors.primaryColors1,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColors1),
        );
      case AppTheme.theme2:
        return ThemeData(
          primaryColor: AppColors.primaryColors2,
          scaffoldBackgroundColor: AppColors.primaryColors2,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColors2),
        );
      case AppTheme.theme3:
        return ThemeData(
          primaryColor: AppColors.primaryColors3,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColors3),
          scaffoldBackgroundColor: AppColors.primaryColors3,
        );
      case AppTheme.theme4:
        return ThemeData(
          primaryColor: AppColors.primaryColors4,
          scaffoldBackgroundColor: AppColors.primaryColors4,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColors4),
        );
      default:
        return ThemeData(
          primaryColor: AppColors.primaryColors2,
          scaffoldBackgroundColor: AppColors.primaryColors2,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColors2),
        );
    }
  }

  List<Color> get gradientColors {
    switch (currentTheme.value) {
      case AppTheme.theme1:
        return [
          AppColors.primaryColors1,
          Colors.black,
          AppColors.primaryColors1
        ];
      case AppTheme.theme2:
        return [
          AppColors.primaryColors2,
          Colors.black,
          AppColors.primaryColors2
        ];
      case AppTheme.theme3:
        return [
          AppColors.primaryColors3,
          Colors.black,
          AppColors.primaryColors3
        ];
      case AppTheme.theme4:
        return [
          AppColors.primaryColors4,
          Colors.black,
          AppColors.primaryColors4
        ];
      default:
        return [
          AppColors.primaryColors1,
          Colors.black,
          AppColors.primaryColors1
        ];
    }
  }

  Future<void> saveThemeToPreferences(AppTheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedTheme', theme.index);
  }

  // Load the theme from SharedPreferences
  Future<void> loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('selectedTheme');
    if (themeIndex != null) {
      currentTheme.value = AppTheme.values[themeIndex];
    }
  }
}
