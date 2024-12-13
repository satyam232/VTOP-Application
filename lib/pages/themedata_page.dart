import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/utils/Colors.dart';

class ThemeSelectionPage extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Theme',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: themeController.themeData.primaryColor,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                themeController.themeData.primaryColor.withOpacity(0.8),
                themeController.themeData.primaryColor.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 16.0, // Horizontal space between grid items
              mainAxisSpacing: 16.0, // Vertical space between grid items
              childAspectRatio: 3 / 2, // Aspect ratio for grid items
            ),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildThemeCard(
                      AppTheme.theme1, "Ocean Green", AppColors.primaryColors1);
                case 1:
                  return _buildThemeCard(AppTheme.theme2, "Blue Sapphire",
                      AppColors.primaryColors2);
                case 2:
                  return _buildThemeCard(
                      AppTheme.theme3, "Deep Purple", AppColors.primaryColors3);
                case 3:
                  return _buildThemeCard(
                      AppTheme.theme4, "Fiery Brown", AppColors.primaryColors4);
                default:
                  return SizedBox(); // Return an empty widget if index is out of range
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildThemeCard(AppTheme theme, String title, Color color) {
    return GestureDetector(
      onTap: () {
        themeController.switchTheme(theme);
        // Get.back(); // Go back to the previous screen after selecting a theme
      },
      child: Card(
        elevation: 10,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Icon(
                Icons.palette,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
