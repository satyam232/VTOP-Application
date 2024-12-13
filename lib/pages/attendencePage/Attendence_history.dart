import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/AttendenceModel.dart';
import 'package:vitap/utils/Colors.dart';
import 'package:get/get.dart';

class AttendenceHistory extends StatefulWidget {
  List<HistoryModel> history;
  AttendenceHistory({super.key, required this.history});

  @override
  State<AttendenceHistory> createState() => _AttendenceHistoryState();
}

class _AttendenceHistoryState extends State<AttendenceHistory> {
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
          ListView.builder(
            itemCount: widget.history.length,
            shrinkWrap:
                true, // Ensure the ListView does not take infinite height
            physics: BouncingScrollPhysics(),
            // NeverScrollableScrollPhysics(), // Disable scrolling to allow for SingleChildScrollView
            itemBuilder: (context, index) {
              final historyItem = widget.history[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  title: Text(
                    historyItem.attendanceDate ?? 'No Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slot: ${historyItem.attendanceSlot ?? 'N/A'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('Status: ${historyItem.attendanceStatus ?? 'N/A'}',
                          style: TextStyle(color: Colors.white)),
                      Text('Timing: ${historyItem.dayAndTiming ?? 'N/A'}',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
