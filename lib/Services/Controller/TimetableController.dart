import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vitap/Services/Models/TimetableModel.dart';
import 'package:vitap/Services/Models/timetable_model.dart'; // Adjust path as per your project

class TimetableController extends GetxController {
  var timetable = Rx<TimetableModel?>(null);
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTimetableData();
  }

  Future<void> loadTimetableData() async {
    isLoading.value = true;
    TimetableModel? savedTimetable = await loadTimetable();
    if (savedTimetable != null) {
      timetable.value = savedTimetable;
    }
    isLoading.value = false;
  }

  Future<TimetableModel?> loadTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timetableJson = prefs.getString('timetable');
    if (timetableJson != null) {
      return TimetableModel.fromJson(json.decode(timetableJson));
    }
    return null;
  }

  Future<void> saveTimetable(TimetableModel timetableModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String timetableJson = json.encode(timetableModel.toJson());
    await prefs.setString('timetable', timetableJson);
    timetable.value = timetableModel;
  }
}
