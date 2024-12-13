import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/OutingDetails.dart';

class OutingdetailsController extends GetxController {
  var isLoading = false.obs;
  var outingList = RxList<OutingDetails>();
  var errorMessage = ''.obs;

  Future<void> fetchOutingData(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<OutingDetails> fetchedMarks = await fetchOuting(username, password);

      if (fetchedMarks.isNotEmpty) {
        outingList.value = fetchedMarks;
        await saveOutingToSharedPreferences(fetchedMarks);
        Get.snackbar("Successfully Updated",
            "your Outing Details has been updated as per VTOP!!",
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

  Future<void> loadOutingFromSharedPreferences() async {
    isLoading.value = true;

    try {
      List<OutingDetails>? savedMarks = await getOutingsFromSharedPreferences();

      if (savedMarks != null && savedMarks.isNotEmpty) {
        outingList.value = savedMarks;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load saved marks data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reload marks data from API
  Future<void> reloadOutingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    await fetchOutingData(username!, password!);
  }

  Future<void> saveOutingToSharedPreferences(List<OutingDetails> marks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String marksJson = jsonEncode(marks.map((item) => item.toJson()).toList());
    await prefs.setString('outing', marksJson);
  }

  Future<List<OutingDetails>?> getOutingsFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? marksJson = prefs.getString('outing');

    if (marksJson != null && marksJson.isNotEmpty) {
      List<dynamic> jsonData = jsonDecode(marksJson);
      return jsonData.map((item) => OutingDetails.fromJson(item)).toList();
    }
    return null;
  }
}
