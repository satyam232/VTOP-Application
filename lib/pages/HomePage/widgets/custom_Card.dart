import 'package:flutter/material.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/utils/Colors.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final double height;
  final String courseCode;
  final String slot;
  final String courseName;
  final String venu;
  final String startTime;
  final String endTime;

  CustomCard(
      {Key? key,
      this.height = 130,
      required this.courseCode,
      required this.slot,
      required this.venu,
      required this.courseName,
      required this.startTime,
      required this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 80,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        boxShadow: [
          BoxShadow(
              blurRadius: 3,
              spreadRadius: 5,
              offset: Offset.infinite,
              color: Colors.green)
        ],
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 0.6, 0.9],
            colors: themeController.gradientColors),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(courseCode,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              Text(slot, style: TextStyle(color: Colors.grey)),
            ],
          ),
          Text(courseName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          Text(venu,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          Row(
            children: [
              Text(startTime, style: TextStyle(color: Colors.white)),
              Text(" - ${endTime}", style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
