import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/CommonWidgets/snackBar.dart';
import 'package:vitap/Services/Models/AttendenceModel.dart';
import 'package:vitap/Services/Models/Curriculum_Model.dart';
import 'package:vitap/Services/Models/ExamModel.dart';
import 'package:vitap/Services/Models/MarksModel.dart';
import 'package:vitap/Services/Models/OutingDetails.dart';
import 'package:vitap/Services/Models/ProfileModel.dart';
import 'package:vitap/Services/Models/timetable_model.dart';
import 'package:vitap/Services/networks/Urls.dart';

Future<void> fetchTimetable(String username, String password) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.timetable),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Parse the timetable data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('timetable', json.encode(response.body));
    } else {
      print('Failed to load timetable: ${response.statusCode}');
      print('Response body: ${response.body}');
      Get.snackbar("Error", "Failed to load timetable");
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
  } catch (e) {
    print('Error fetching timetable: $e');
    Get.snackbar("Error", "Failed to load timetable", colorText: Colors.white);
  }
}

Future<List<MarksModel>> fetchMarks(String username, String password) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.marksUrl),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<MarksModel> marksList =
          data.map((item) => MarksModel.fromJson(item)).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String marksJson = jsonEncode(marksList.map((e) => e.toJson()).toList());
      await prefs.setString('marks', marksJson);
      return marksList;
    } else {
      Get.snackbar("Error", "Failed to load marks");
      return [];
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
    return [];
  } catch (e) {
    print('Error fetching marks: $e');
    Get.snackbar("Error", "Failed to load marks", colorText: Colors.white);
    return [];
  }
}

Future<List<OutingDetails>> fetchOuting(
    String username, String password) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.outingUrl),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<OutingDetails> outingList =
          data.map((item) => OutingDetails.fromJson(item)).toList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String outingsJson =
          jsonEncode(outingList.map((e) => e.toJson()).toList());
      await prefs.setString('outing', outingsJson);
      return outingList;
    } else {
      Get.snackbar("Error", "Failed to load Outing Details");
      return [];
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
    return [];
  } catch (e) {
    print('Error fetching Outing Details: $e');
    Get.snackbar("Error", "Failed to load Outing Details",
        colorText: Colors.white);
    return [];
  }
}

Future<ExamsModel?> fetchExams(String username, String password) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.examsUrl),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Parse response
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Convert to ExamsModel
      if (responseData != {}) {
        ExamsModel examsModel = ExamsModel.fromJson(responseData);
        await saveExamsToSharedPreferences(examsModel);
        return examsModel;
      }

      // Save to SharedPreferences

      return null;
    } else {
      Get.snackbar("Error", "Failed to load marks");
      return null;
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
    return null;
  } catch (e) {
    print('Error fetching marks: $e');
    Get.snackbar("Error", "Failed to load examsData", colorText: Colors.white);
    return null;
  }
}

Future<Curriculum?> fetchCurriculum(String username, String password) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.curriculumUrl),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Parse response
      Map<String, dynamic> responseData = jsonDecode(response.body);

      // Convert to ExamsModel
      if (responseData != {}) {
        Curriculum myCurriculum = Curriculum.fromJson(responseData);
        await saveCurriculumToSharedPreferences(myCurriculum);
        return myCurriculum;
      }

      // Save to SharedPreferences

      return null;
    } else {
      Get.snackbar("Error", "Failed to load curriculum");
      return null;
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
    return null;
  } catch (e) {
    print('Error fetching marks: $e');
    Get.snackbar("Error", "Failed to load curriculum", colorText: Colors.white);
    return null;
  }
}

Future<String> fetchAndSaveAttendenceData(
    String username, String password) async {
  final Map<String, String> body = {
    'username': username,
    'password': password,
  };
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    final response = await http
        .post(Uri.parse(AllUrls.attendenceUrl),
            body: jsonEncode(body), headers: headers)
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<AttendenceModel> attendenceList =
          data.map((item) => AttendenceModel.fromJson(item)).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String attendenceJson =
          jsonEncode(attendenceList.map((e) => e.toJson()).toList());
      await prefs.setString('attendenceData', attendenceJson);

      return attendenceJson;
    } else {
      Get.snackbar("Server Error", "Failed to load attendance");
      throw Exception('Failed to load attendance');
    }
  } on TimeoutException catch (e) {
    print('Request timed out: $e');
    Get.snackbar("Error", "Request timed out");
    throw Exception('Request timed out');
  } catch (e) {
    print('Error fetching attendance: $e');
    Get.snackbar("Error", "Failed to load attendance");
    throw Exception('Failed to load attendance');
  }
}

// Function to load timetable from shared preferences
Future<TimetableModel?> loadTimetable() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? timetableJson = prefs.getString('timetable');
  if (timetableJson != null) {
    return TimetableModel.fromJson(json.decode(timetableJson));
  }
  return null;
}

Future<ProfileModel?> loadProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? profileJson = prefs.getString('profile');
  if (profileJson != null) {
    return ProfileModel.fromJson(json.decode(profileJson));
  }
  return null;
}

Future<void> saveExamsToSharedPreferences(ExamsModel examsModel) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert ExamsModel to JSON string
  String examsJson = jsonEncode(examsModel.toJson());

  // Save JSON string in SharedPreferences
  await prefs.setString('exams_data', examsJson);
}

Future<void> saveCurriculumToSharedPreferences(Curriculum examsModel) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert ExamsModel to JSON string
  String examsJson = jsonEncode(examsModel.toJson());

  // Save JSON string in SharedPreferences
  await prefs.setString('curriculum', examsJson);
}
