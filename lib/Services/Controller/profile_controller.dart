import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitap/Services/Models/ProfileModel.dart';

class ProfileController extends GetxController {
  var profile = Rx<ProfileModel>(ProfileModel());
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    isLoading.value = true;
    ProfileModel? savedProfile = await loadProfile();
    if (savedProfile != null) {
      profile.value = savedProfile;
    }
    isLoading.value = false;
  }

  Future<ProfileModel?> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileJson = prefs.getString('profile');
    if (profileJson != null) {
      return ProfileModel.fromJson(json.decode(profileJson));
    }
    return null;
  }

  Future<void> saveProfile(ProfileModel profileModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileJson = json.encode(profileModel.toJson());
    await prefs.setString('profile', profileJson);
    profile.value = profileModel;
  }
}
