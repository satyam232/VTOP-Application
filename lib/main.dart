import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/firebase_options.dart';
// import 'package:vitap/pages/HomePage/Nav_page.dart';
// import 'package:vitap/pages/LoginPage.dart';
import 'package:get/get.dart';
import 'package:vitap/pages/SplashScrren.dart'; // <-- Import GetX

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedin = prefs.getString('username') != null;

  runApp(MyApp(isLoggedIn: isLoggedin));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.themeData,
          home: SplashScreen(
            isLogin: isLoggedIn,
          ),
        ));
  }
}
