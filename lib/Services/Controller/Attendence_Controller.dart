import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/AttendenceModel.dart';
import 'package:vitap/Services/Models/MarksModel.dart';

class AttendenceController extends GetxController {
  final attendenceList = RxList<AttendenceModel>();

  final status = true.obs;
  final message = ''.obs;

  void setStatus(bool value) {
    status.value = value;
  }

  Future<void> setData(List<AttendenceModel> marks) async {
    attendenceList.value = marks;
  }

  Future<void> saveAttendence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString("username")!;
    String password = await prefs.getString("password")!;
    await fetchAndSaveAttendenceData(username, password).then((v) async {
      print(v);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('attendenceData', v).then((d) {
        getAttendence();
        setStatus(false);
        Get.snackbar(
            "Successfully Updated", "your attendence data has been updated!!",
            colorText: Colors.white,
            backgroundColor: Colors.green.withOpacity(0.7));
      });
    });
  }

  Future<void> getAttendence() async {
    getAttendenceDataFromPrefs().then((data) {
      setData(data);
      if (attendenceList.isEmpty) {
        setStatus(true);
        saveAttendence();
      }
      setStatus(false);
    });
  }
}

Future<List<AttendenceModel>> getAttendenceDataFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? attendenceJson = prefs.getString('attendenceData');

  if (attendenceJson != null) {
    List<dynamic> data = jsonDecode(attendenceJson);
    return data.map((item) => AttendenceModel.fromJson(item)).toList();
  } else {
    // Get.snackbar(title, message)
    return [];
  }
}
