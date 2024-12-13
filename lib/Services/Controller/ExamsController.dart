import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/ExamModel.dart';

class ExamsController extends GetxController {
  var isLoading = false.obs;
  var examsModel = Rxn<ExamsModel>(); // Rxn allows null values
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
      ExamsModel? fetchedExams = await fetchExams(username, password);

      if (fetchedExams != null) {
        // print(examsModel.value.)
        examsModel.value = fetchedExams;
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
  Future<void> loadExamsFromSharedPreferences() async {
    isLoading.value = true;

    try {
      ExamsModel? savedExams = await getExamsFromSharedPreferences();

      if (savedExams != null) {
        examsModel.value = savedExams;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load saved exam data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reload data from API
  Future<void> reloadExamsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    await fetchExamsData(username!, password!);
  }
}

Future<ExamsModel?> getExamsFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? examsJson = prefs.getString('exams_data');
  if (examsJson != null) {
    Map<String, dynamic> jsonMap = jsonDecode(examsJson);
    return ExamsModel.fromJson(jsonMap);
  }
  return null;
}
