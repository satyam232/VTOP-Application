import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Controller/Attendence_Controller.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/AttendenceModel.dart';
import 'package:vitap/pages/attendencePage/Attendence_history.dart';
import 'package:vitap/utils/Colors.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Allattendence = Get.put(AttendenceController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Allattendence.getAttendence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 1, 29),
      appBar: AppBar(
        // backgroundColor: AppColors.primaryColors,
        title: Text(
          'Attendance',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: [0.1, 0.8, 1.2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: themeController.gradientColors)),
          ),
          RefreshIndicator(
            onRefresh: Allattendence.saveAttendence,
            child: Obx(() {
              if (Allattendence.status.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: Allattendence.attendenceList.length,
                  itemBuilder: (context, index) {
                    final data = Allattendence.attendenceList[index];
                    final double percentage =
                        double.parse(data.percentage!.replaceAll('%', '')) /
                            100;

                    return GestureDetector(
                      onTap: () {
                        if (data.history!.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendenceHistory(
                                        history: data.history!,
                                      )));
                        }
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data.courseName}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Slot: ${data.slot}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Faculty: ${data.faculty}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 60.0,
                                    lineWidth: 5.0,
                                    percent: percentage,
                                    center: new Text(
                                      "${data.percentage}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    progressColor: Colors.blueAccent,
                                    backgroundColor: Colors.white24,
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Attended: ${data.attended} / ${data.total}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Type: ${data.type}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Last updated: ${data.updatedOn}',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().slideY(
                        begin: index * 0.55,
                        delay: Duration(milliseconds: index + 100));
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
