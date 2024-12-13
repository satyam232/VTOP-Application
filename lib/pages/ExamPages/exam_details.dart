import 'package:flutter/material.dart';

class ExamDetailPage extends StatelessWidget {
  final String examType;
  final List<Map<String, String>> exams;

  ExamDetailPage({required this.examType, required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$examType Details',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          var exam = exams[index];
          return Card(
            color: Colors.white.withOpacity(0.2), // Updated background color
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading for the subject name
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0), // Added padding below the title
                    child: Text(
                      exam['Course Title'] ?? 'Course Title',
                      style: TextStyle(
                        fontSize: 22, // Larger font size for the heading
                        fontWeight:
                            FontWeight.bold, // Bold text for the heading
                        color: Colors.white, // White color for text
                      ),
                    ),
                  ),
                  // Other details
                  _buildDetailRow('Course Code', exam['Course Code']),
                  _buildDetailRow('Exam Date', exam['Exam Date']),
                  _buildDetailRow('Exam Time', exam['Exam Time']),
                  _buildDetailRow('Reporting Time', exam['Reporting Time']),
                  _buildDetailRow('Seat Location', exam['Seat Location']),
                  _buildDetailRow('Seat No', exam['Seat No']),
                  _buildDetailRow('Slot', exam['Slot']),
                  _buildDetailRow('Venue Block', exam['Venue Block']),
                  _buildDetailRow('Venue Room', exam['Venue Room']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
