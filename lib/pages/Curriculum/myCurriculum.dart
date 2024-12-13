import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitap/Services/Controller/Curriculum_Controller.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/Services/Models/Curriculum_Model.dart';

class CurriculumScreen extends StatefulWidget {
  @override
  _CurriculumScreenState createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  final ThemeController themeController = Get.put(ThemeController());
  final myCurriculum = Get.put(MyCurriculum());
  bool isLoading = true;
  double allTotalCredits = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      myCurriculum.loadCurriculumFromSharedPreferences(),
    ]);
    setState(() {
      isLoading = false;
      _calculateAllTotalCredits(); // Calculate total credits after data is loaded
    });
  }

  void _calculateAllTotalCredits() {
    allTotalCredits = 0.0;
    allTotalCredits +=
        _calculateTotalCredits(_getCoursesByCategory('ProgramCore'));
    allTotalCredits +=
        _calculateTotalCredits(_getCoursesByCategory('ProgramElective'));
    allTotalCredits +=
        _calculateTotalCredits(_getCoursesByCategory('UniversityCore'));
    allTotalCredits +=
        _calculateTotalCredits(_getCoursesByCategory('UniversityElective'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Curriculum',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4.0,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
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
                RefreshIndicator(
                  onRefresh: myCurriculum.reloadCurriculumData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCurriculumCategory('ProgramCore'),
                        _buildCurriculumCategory('ProgramElective'),
                        _buildCurriculumCategory('UniversityCore'),
                        _buildCurriculumCategory('UniversityElective'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildTotalCreditsFooter(), // Add footer here
    );
  }

  Widget _buildCurriculumCategory(String category) {
    List<Course> courses = _getCoursesByCategory(category);
    double totalCredits = _calculateTotalCredits(courses);

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        leading: const Icon(
          Icons.book,
          color: Colors.blueAccent,
        ),
        title: Text(
          category,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: totalCredits > 0
            ? Text(
                '$totalCredits Credits',
                style: const TextStyle(fontSize: 14, color: Colors.green),
              )
            : null,
        children: courses.map((course) => _buildCourseCard(course)).toList(),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      color: course.registrationStatus == "Registered"
          ? Colors.green[100]
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.courseTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Course Code: ${course.courseCode}',
                style: const TextStyle(fontSize: 14)),
            Text('Credits: ${course.credits}',
                style: const TextStyle(fontSize: 14)),
            Text(
              'Registration Status: ${course.registrationStatus}',
              style: TextStyle(
                fontSize: 14,
                color: course.registrationStatus == "Registered"
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCreditsFooter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey.withOpacity(0.2),
      child: Text(
        'Total Credits: $allTotalCredits',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.greenAccent,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Course> _getCoursesByCategory(String category) {
    if (myCurriculum.curriculumModel.value == null) return [];
    final model = myCurriculum.curriculumModel.value!;
    switch (category) {
      case 'ProgramCore':
        return model.programCore;
      case 'ProgramElective':
        return model.programElective;
      case 'UniversityCore':
        return model.universityCore;
      case 'UniversityElective':
        return model.universityElective;
      default:
        return [];
    }
  }

  double _calculateTotalCredits(List<Course> courses) {
    double totalCredits = 0.0; // Use double instead of int
    for (var course in courses) {
      if (course.registrationStatus == "Registered") {
        try {
          totalCredits += double.parse(course.credits); // Parse as double
        } catch (e) {
          debugPrint(
              'Error parsing credits for course ${course.courseTitle}: $e');
        }
      }
    }
    return totalCredits;
  }
}
