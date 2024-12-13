import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/pages/HomePage/HomePage.dart';
import 'package:vitap/pages/TimeTable/timetablepage.dart';
import 'package:vitap/pages/attendencePage/AttendencePage.dart';
import 'package:vitap/pages/profilepage/profilepage.dart';
import 'package:vitap/pages/termsAndConditions/terms_and_conditions.dart';
import 'package:vibration/vibration.dart';
// import 'package:vitap/utils/Colors.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:uni_links/uni_links.dart'; // Make sure you have the uni_links package in your pubspec.yaml

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 0;
  final ThemeController themeController = Get.put(ThemeController());

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TimetablePage(),
    AttendancePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    vibrateOnIconClick();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _navigateToPageFromLink(initialLink);
      }

      linkStream.listen((String? link) {
        if (link != null) {
          _navigateToPageFromLink(link);
        }
      });
    } on PlatformException {
      // Handle exception
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    try {
      if (await canLaunch(emailLaunchUri.toString())) {
        await launch(emailLaunchUri.toString());
      } else {
        print('Could not launch URL: ${emailLaunchUri.toString()}');
        // Show user-friendly message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No email client found.'),
          ),
        );
      }
    } catch (e) {
      print('Error launching email client: $e');
      // Show user-friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching email client.'),
        ),
      );
    }
  }

  void _navigateToPageFromLink(String link) {
    if (link.contains('some_path')) {}
  }

  Future<void> vibrateOnIconClick() async {
    if ((await Vibration.hasVibrator())!) {
      Vibration.vibrate(duration: 5); // Vibration pattern
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/vitlogo.png',
                    width: height * 0.12,
                  ),
                  Container()
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjusted blur level
          child: Container(
            color: Colors.black.withOpacity(0.3), // Slightly less opacity
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'VIT-AP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Colors.white),
                  title: const Text('Contact Us',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    await _sendEmail("codewayr232@gmail.com");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description, color: Colors.white),
                  title: const Text('Terms and Conditions',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsAndConditionsPage()),
                    );
                  },
                ),
                const Spacer(), // Pushes the following content to the bottom
                Divider(color: Colors.white.withOpacity(0.3)),
                ListTile(
                  onTap: () {
                    launchURL();
                  },
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Satyam Rana',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text("Developer"),
                ),
                const Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.schedule),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.check),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void launchURL() async {
    final Uri url =
        Uri.parse('https://www.linkedin.com/in/satyam-rana-68938117b');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
