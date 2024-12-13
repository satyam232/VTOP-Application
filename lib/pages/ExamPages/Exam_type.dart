import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitap/Services/Controller/ExamsController.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/pages/ExamPages/exam_details.dart';

class ExamTypePage extends StatefulWidget {
  @override
  State<ExamTypePage> createState() => _ExamTypePageState();
}

class _ExamTypePageState extends State<ExamTypePage> {
  final ThemeController themeController = Get.put(ThemeController());
  final ExamsController examsController = Get.put(ExamsController());

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadData() async {
    await examsController.reloadExamsData();
  }

  void loadSavedData() async {
    await examsController.loadExamsFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exam Timetable',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadData(); // Reload the exam data when the refresh button is pressed
            },
          ),
        ],
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
          Obx(() {
            if (examsController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (examsController.errorMessage.isNotEmpty) {
              return Center(
                  child: Text(
                examsController.errorMessage.value,
                style: TextStyle(color: Colors.white),
              ));
            } else if (examsController.examsModel.value != null) {
              var examTypes = examsController.examsModel.value!;
              return ListView.builder(
                itemCount: examTypes.getTypes().length,
                itemBuilder: (context, index) {
                  String examType = examTypes.getTypes().elementAt(index);
                  List<Map<String, String>> examDetails = examTypes
                      .getExamsForType(examType)
                      .map((exam) => exam
                          .toJson()
                          .map((key, value) => MapEntry(key, value.toString())))
                      .toList();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamDetailPage(
                            examType: examType,
                            exams: examDetails,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        examType,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: Text(
                'if exam timetable has been released in VTOP.. kindly refresh it',
                style: TextStyle(color: Colors.white),
              ));
            }
          }),
        ],
      ),
    );
  }
}
