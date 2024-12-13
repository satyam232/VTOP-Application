import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Apis.dart';
import 'package:vitap/Services/Models/ExamModel.dart';
import 'package:vitap/Services/networks/Urls.dart';
import 'package:vitap/pages/HomePage/Nav_page.dart';

class LoginController extends GetxController {
  RxBool loginStatus = true.obs;
  RxString message = "".obs;

  Future<Map<String, dynamic>> login(
      String username, String password, BuildContext context) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(AllUrls.login),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        log('Response Data: $responseData');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (responseData['profile'] != null) {
          prefs.setString('profile', json.encode(responseData['profile']));
          prefs.setString("username", username);
          prefs.setString("password", password);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavPage()),
            (Route<dynamic> route) => false,
          );
        }
        // if (responseData['examTimetable'] != null) {
        //   ExamsModel examsModel =
        //       ExamsModel.fromJson(responseData['examTimetable']);
        //   await saveExamsToSharedPreferences(examsModel);
        // }
        if (responseData['attendence'] != null) {
          prefs.setString(
              'attendenceData', json.encode(responseData['attendence']));
        }
        if (responseData['timetable'] != null) {
          prefs.setString('timetable', json.encode(responseData['timetable']));

          // log('Timetable Saved: ${json.encode(responseData['timetable'])}');
        } else {
          log('No timetable found in response');
        }

        loginStatus.value = true;
        log("Successfully Logged In");

        // Ensure the data is saved before navigating
        await Future.delayed(Duration(milliseconds: 500));

        return responseData;
      }
      if (response.statusCode == 401) {
        Get.snackbar("Login Failed", "please enter the valid credentails",
            backgroundColor: Colors.red.withOpacity(0.2),
            colorText: Colors.white);
        message.value = "Invalid Credentials";
        return {"error": "incorrect username or password"};
      }
      if (response.statusCode == 500) {
        Get.snackbar("Error", "Vtop server is down!!, try again after sometime",
            backgroundColor: Colors.red.withOpacity(0.2),
            colorText: Colors.white);
        return {"error": "Vtop is not responding"};
      } else {
        loginStatus.value = false;
        log('Failed to login: ${response.statusCode}');

        return {'error': 'Failed to login', 'statusCode': response.statusCode};
      }
    } catch (e) {
      message.value = "Internal error occurred";
      log('Error: $e');
      return {'error': 'An error occurred', 'exception': e.toString()};
    }
  }
}
