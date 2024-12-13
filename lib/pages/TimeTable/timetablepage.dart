import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/timetable_model.dart';
import 'package:get/get.dart';

class TimetablePage extends StatefulWidget {
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableModel timetable = TimetableModel();
  final ThemeController themeController = Get.put(ThemeController());
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  String? selectedDay;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
    String currentDay = DateFormat('EEEE').format(DateTime.now());
    selectedDay = currentDay;

    // Set the initial page to the current day
    int initialPage = daysOfWeek.indexOf(currentDay);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(initialPage);
      scrollToDay(initialPage);
    });
  }

  void loadData() async {
    TimetableModel? savedTimetable = await loadTimetable();
    if (savedTimetable != null) {
      setState(() {
        timetable = savedTimetable;
      });
    }
  }

  void scrollToDay(int index) {
    double position =
        index * 100.0 - MediaQuery.of(context).size.width / 2 + 50;
    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<ClassDetail>? getClassesForDay(String day) {
    List<ClassDetail>? classes;
    switch (day) {
      case 'Monday':
        classes = timetable.monday;
        break;
      case 'Tuesday':
        classes = timetable.tuesday;
        break;
      case 'Wednesday':
        classes = timetable.wednesday;
        break;
      case 'Thursday':
        classes = timetable.thursday;
        break;
      case 'Friday':
        classes = timetable.friday;
        break;
      case 'Saturday':
        classes = timetable.saturday;
        break;
      case 'Sunday':
        classes = timetable.sunday;
        break;
      default:
        return null;
    }

    // Sort classes by startTime
    classes?.sort((a, b) {
      final timeFormat = DateFormat("HH:mm");
      final timeA = timeFormat.parse(a.startTime!);
      final timeB = timeFormat.parse(b.startTime!);
      return timeA.compareTo(timeB);
    });

    return classes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timetable",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      backgroundColor: Color.fromARGB(255, 11, 1, 29),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: [0.1, 0.8, 1.2],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: themeController.gradientColors)),
          ),
          Column(
            children: [
              SizedBox(
                height: 90,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = daysOfWeek[index];
                            pageController.jumpToPage(index);
                            scrollToDay(index);
                          });
                        },
                        child: _buildDayButton(daysOfWeek[index]),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: daysOfWeek.length,
                  onPageChanged: (index) {
                    setState(() {
                      selectedDay = daysOfWeek[index];
                      scrollToDay(index);
                    });
                  },
                  itemBuilder: (context, index) {
                    List<ClassDetail>? classes =
                        getClassesForDay(daysOfWeek[index]);
                    return selectedDay != null && classes?.isNotEmpty == true
                        ? ListView.builder(
                            itemCount: classes!.length,
                            itemBuilder: (context, classIndex) {
                              return _buildClassInfo(classes[classIndex])
                                  .animate()
                                  .slideY(
                                      begin: classIndex * 0.25,
                                      delay: Duration(
                                          milliseconds: classIndex + 100));
                            },
                          )
                        : Center(
                            child: Text(
                              'No classes for this day',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayButton(String day) {
    bool isSelected = selectedDay == day;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 0.2),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          // fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClassInfo(ClassDetail classInfo) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classInfo.courseName ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Code: ${classInfo.code}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Class: ${classInfo.className}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Slot: ${classInfo.slot}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Time: ${classInfo.startTime} - ${classInfo.endTime}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
