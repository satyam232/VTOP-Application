import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'dart:ui';

snackBar(String? title, String? message) {
  return Get.snackbar(
    "sat",
    "yam",
    backgroundColor: Colors.purple.withOpacity(0.3),
    snackPosition: SnackPosition.TOP,
    barBlur: 10, // Adjust blur intensity as needed
    isDismissible: true,
    // dismissDirection: ,
  );
}
