import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/Curriculum_Model.dart';

class MyCurriculum extends GetxController {
  var isLoading = false.obs;
  var curriculumModel = Rxn<Curriculum>(); // Rxn allows null values
  var errorMessage = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadExamsFromSharedPreferences(); // Load saved data initially
  // }

  // Fetch data from API and update state
  Future<void> fetchExamsData(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      Curriculum? fetchedCurriculum = await fetchCurriculum(username, password);

      if (fetchedCurriculum != null) {
        // print(examsModel.value.)
        curriculumModel.value = fetchedCurriculum;
        Get.snackbar("Successfully Updated",
            "your Exams Schedule has been updated as per VTOP!!",
            colorText: Colors.white,
            backgroundColor: Colors.green.withOpacity(0.7));
      } else {
        print("Failed");
        errorMessage.value = 'Failed to fetch exam data';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load exams data from SharedPreferences
  Future<void> loadCurriculumFromSharedPreferences() async {
    isLoading.value = true;

    try {
      Curriculum? savedExams = await getCurriculumFromSharedPreferences();

      if (savedExams != null) {
        curriculumModel.value = savedExams;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load saved exam data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reload data from API
  Future<void> reloadCurriculumData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    await fetchExamsData(username!, password!);
  }
}

Future<Curriculum?> getCurriculumFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? examsJson = prefs.getString('curriculum');
  if (examsJson != null) {
    Map<String, dynamic> jsonMap = jsonDecode(examsJson);
    return Curriculum.fromJson(jsonMap);
  }
  return null;
}
