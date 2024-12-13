import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/ProfileModel.dart';
import 'package:vitap/pages/LoginPage.dart';
import 'package:vitap/pages/themedata_page.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? profile;
  final ThemeController themeController = Get.find<ThemeController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('marks_data');
    await prefs.remove('exams_data');
    await prefs.remove('attendenceData');
    await prefs.remove('timetable');
    await prefs.remove('profile');
    await prefs.clear().then((v) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    });
  }

  void loadData() async {
    ProfileModel? savedProfile = await loadProfile();

    setState(() {
      profile = savedProfile;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchAllDocuments() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('notifications').get();
      List<Map<String, dynamic>> documentList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        documentList.add(document.data() as Map<String, dynamic>);
      }

      return documentList;
    } catch (e) {
      print('Error fetching documents: $e');
      return [];
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeData = themeController.themeData;
      final Color primaryTextColor = Colors.white;
      final Color accentColor = Colors.white70;
      final Color highlightColor = Colors.amberAccent;
      final Color boxColor = themeData.cardColor.withOpacity(0.1);

      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.1, 0.8, 1.2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: themeController.gradientColors,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: Offset(4, 4),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: themeData.cardColor,
                            radius: 60,
                            backgroundImage: (profile?.profileImageBase64 !=
                                    null)
                                ? MemoryImage(
                                    base64Decode(profile!.profileImageBase64!))
                                : null, // If the string is null or empty, don't display an image
                            child: (profile?.profileImageBase64 == null)
                                ? Icon(Icons.person,
                                    size: 50, color: Colors.black)
                                : null, // If there's no image, display the default icon
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      profile?.name ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      profile?.email ?? 'Loading...',
                      style: TextStyle(fontSize: 18, color: primaryTextColor),
                    ),
                    SizedBox(height: 24),
                    _buildProfileDetail(
                      'Application Number',
                      profile?.appNo ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    _buildProfileDetail(
                      'Branch',
                      profile?.branch ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    _buildProfileDetail(
                      'Program',
                      profile?.program ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ThemeSelectionPage());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Text(
                          "Change Theme",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Proctor Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: highlightColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildProfileDetail(
                      'Proctor Name',
                      profile?.proctorName ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    _buildProfileDetail(
                      'Proctor Email',
                      profile?.proctorEmail ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    _buildProfileDetail(
                      'Proctor Mobile Number',
                      profile?.proctorMobileNumber ?? 'Loading...',
                      accentColor,
                      boxColor,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        _showLogoutDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: highlightColor,
                        backgroundColor: themeData.scaffoldBackgroundColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProfileDetail(
    String title,
    String value,
    Color textColor,
    Color boxColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.3),
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: textColor),
            SizedBox(width: 16),
            Text(
              '$title: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.4).fade(duration: Duration(milliseconds: 100));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () async {
                await logout(context);
              },
            ),
          ],
        );
      },
    );
  }
}
