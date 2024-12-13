import 'package:flutter/material.dart';
import 'package:vitap/Services/Models/MarksModel.dart';

class MarksDetailPage extends StatelessWidget {
  final MarksModel marksModel;

  MarksDetailPage({required this.marksModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(marksModel.courseTitle ?? 'Course Marks',
            style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: marksModel.marks?.length ?? 0,
        itemBuilder: (context, index) {
          final mark = marksModel.marks?[index];
          return Card(
            color: Colors.white.withOpacity(0.2),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mark?.markTitle ?? 'No Title',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Max Mark: ${mark?.maxMark ?? "N/A"}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("Scored Mark: ${mark?.scoredMark ?? "N/A"}",
                      style: TextStyle(color: Colors.white)),
                  Text("Status: ${mark?.status ?? "N/A"}",
                      style: TextStyle(color: Colors.white)),
                  Text("Weightage: ${mark?.weightage ?? "N/A"}",
                      style: TextStyle(color: Colors.white)),
                  Text("Weightage Mark: ${mark?.weightageMark ?? "N/A"}",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
