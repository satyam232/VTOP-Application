import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/MarksModel.dart';

class MarksController extends GetxController {
  var isLoading = false.obs;
  var marksList = RxList<MarksModel>();
  var errorMessage = ''.obs;

  // Fetch marks data from API and update state
  Future<void> fetchMarksData(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<MarksModel> fetchedMarks = await fetchMarks(username, password);

      if (fetchedMarks.isNotEmpty) {
        marksList.value = fetchedMarks;
        await saveMarksToSharedPreferences(fetchedMarks);
        Get.snackbar(
            "Successfully Updated", "your Marks has been updated as per VTOP!!",
            colorText: Colors.white,
            backgroundColor: Colors.green.withOpacity(0.7));
      } else {
        errorMessage.value = 'No marks data available';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load marks data from SharedPreferences
  Future<void> loadMarksFromSharedPreferences() async {
    isLoading.value = true;

    try {
      List<MarksModel>? savedMarks = await getMarksFromSharedPreferences();

      if (savedMarks != null && savedMarks.isNotEmpty) {
        marksList.value = savedMarks;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load saved marks data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reload marks data from API
  Future<void> reloadMarksData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    await fetchMarksData(username!, password!);
  }

  // Save marks data to SharedPreferences
  Future<void> saveMarksToSharedPreferences(List<MarksModel> marks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String marksJson = jsonEncode(marks.map((item) => item.toJson()).toList());
    await prefs.setString('marks_data', marksJson);
  }

  // Get marks data from SharedPreferences
  Future<List<MarksModel>?> getMarksFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? marksJson = prefs.getString('marks_data');

    if (marksJson != null && marksJson.isNotEmpty) {
      List<dynamic> jsonData = jsonDecode(marksJson);
      return jsonData.map((item) => MarksModel.fromJson(item)).toList();
    }
    return null;
  }
}
