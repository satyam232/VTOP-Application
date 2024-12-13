import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vitap/Services/Controller/OutingDetails_Controller.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';

class OutingPage extends StatefulWidget {
  const OutingPage({super.key});

  @override
  State<OutingPage> createState() => _OutingPageState();
}

class _OutingPageState extends State<OutingPage> {
  final ThemeController themeController = Get.put(ThemeController());
  final OutingdetailsController controller = Get.put(OutingdetailsController());

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadData() async {
    await controller.reloadOutingData();
  }

  void loadSavedData() async {
    await controller.loadOutingFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Outing Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadData(); // Reload the exam data when the refresh button is pressed
            },
          ),
        ],
      ),
      body: Stack(
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (controller.outingList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: controller.outingList.length,
                    itemBuilder: (context, index) {
                      var outingModel = controller.outingList[index];
                      return Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outingModel.bookingId!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(outingModel.dateOfVisit!,
                                    style: TextStyle(color: Colors.white)),
                                Text(outingModel.placeOfVisit!,
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    outingModel.hostelBlock! +
                                        " " "${outingModel.roomNo}",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: (outingModel.status ==
                                          "Outing  Request Accepted")
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                (outingModel.status!),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "If marks have been released in VTOP, kindly refresh.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}
