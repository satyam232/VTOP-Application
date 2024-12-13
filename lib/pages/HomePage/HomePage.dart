import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Controller/profile_controller.dart';
import 'package:vitap/Services/Models/ProfileModel.dart';
import 'package:vitap/Services/Models/timetable_model.dart';
import 'package:vitap/pages/HomePage/widgets/ClassTimetableBuilder.dart';
import 'package:vitap/pages/HomePage/widgets/QuickLinks.dart';
import 'package:vitap/pages/HomePage/widgets/profileSection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeController themeController = Get.put(ThemeController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimetableModel timetable = TimetableModel();
  // ProfileModel profile = ProfileModel();
  ProfileController profileController = Get.put(ProfileController());
  String? username = '';
  bool isLoading = false;
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    _notificationsFuture = _fetchNotifications(); // Fetch notifications once
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    // _fetchNotifications();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    // ProfileModel? savedProfile = await loadProfile();
    TimetableModel? savedTimetable = await loadTimetable();

    if (savedTimetable != null) {
      username = savedUsername ?? '';
      setState(() {
        timetable = savedTimetable;
        // isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('notifications').get();
      List<Map<String, dynamic>> notificationList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        notificationList.add(document.data() as Map<String, dynamic>);
      }

      return notificationList;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  List<dynamic> getTodayClasses() {
    int today = DateTime.now().weekday;
    List<dynamic> todayClasses = timetable.toJson()[_days[today]] ?? [];

    DateTime now = DateTime.now();
    todayClasses = todayClasses.where((classInfo) {
      List<String> startTimeParts = classInfo['endTime'].split(':');
      DateTime startTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      );

      return startTime.isAfter(now);
    }).toList();

    todayClasses.sort((a, b) {
      List<String> startTimePartsA = a['startTime'].split(':');
      DateTime startTimeA = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(startTimePartsA[0]),
        int.parse(startTimePartsA[1]),
      );

      List<String> startTimePartsB = b['startTime'].split(':');
      DateTime startTimeB = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(startTimePartsB[0]),
        int.parse(startTimePartsB[1]),
      );

      return startTimeA.compareTo(startTimeB);
    });

    return todayClasses;
  }

  static const _days = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  @override
  Widget build(BuildContext context) {
    List<dynamic> todayClasses = getTodayClasses();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    child: ProfileSection(
                        themeController: themeController,
                        profile: profileController.profile.value,
                        username: username!)),
                const SizedBox(height: 20),
                buildTodaysPlanSection(todayClasses, context, _currentPage,
                    _pageController, isLoading),
                const SizedBox(height: 30),
                buildQuickLinksSection(context, themeController),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 20),
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _notificationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerEffect();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildNotificationsSection();
                    }

                    List<Map<String, dynamic>> notifications = snapshot.data!;

                    return _buildNotificationsSection(
                        notifications: notifications);
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
      {List<Map<String, dynamic>>? notifications}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: notifications != null && notifications.isNotEmpty
                ? notifications.map((notification) {
                    Timestamp timestamp =
                        notification['createdon'] as Timestamp;
                    DateTime createdOnDateTime = timestamp.toDate();
                    String description = notification['description'] ?? '';
                    String title = notification['title'] ?? '';

                    return _buildNotificationTile(
                        icon: Icons.notifications,
                        title: title,
                        time: _formatTimestamp(createdOnDateTime),
                        subtitle: description);
                  }).toList()
                : [
                    _buildNotificationTile(
                        icon: Icons.notifications,
                        title: "No new notifications.",
                        time: "",
                        subtitle: "")
                  ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String time,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  maxLines: 1, // Limit to one line
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  maxLines: 5, // Limit to five lines
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  maxLines: 1, // Limit to one line
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    // Format the DateTime to a more readable format
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) => _buildShimmerTile()),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
