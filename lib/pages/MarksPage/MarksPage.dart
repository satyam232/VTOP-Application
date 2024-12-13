import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:vitap/Services/Controller/MarksPage_Controller.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/pages/MarksPage/Marks_Details.dart';

class MarksPage extends StatefulWidget {
  const MarksPage({super.key});

  @override
  State<MarksPage> createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  final allMarks = Get.put(MarksController());
  final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    allMarks.loadMarksFromSharedPreferences();
    // Removed initial call to allMarks.getMarks() to prevent auto-refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Marks",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              allMarks
                  .reloadMarksData(); // Manually trigger refresh when button is pressed
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
                colors: themeController.gradientColors,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Obx(() {
              if (allMarks.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (allMarks.marksList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: allMarks.marksList.length,
                    itemBuilder: (context, index) {
                      var marksModel = allMarks.marksList[index];
                      return Card(
                        color: Colors.white.withOpacity(0.2),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            marksModel.courseTitle ?? "N/A",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            "Faculty: ${marksModel.faculty ?? "N/A"}",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MarksDetailPage(
                                        marksModel: marksModel)));
                          },
                        ),
                      ).animate().slideY(
                          begin: index * 0.25,
                          delay: Duration(milliseconds: index + 100));
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "If marks have been released in VTOP, kindly refresh.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}
