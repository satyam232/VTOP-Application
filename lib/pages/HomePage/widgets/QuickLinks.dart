import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vitap/Services/Controller/ThemeController.dart';
import 'package:vitap/pages/Curriculum/myCurriculum.dart';
import 'package:vitap/pages/ExamPages/Exam_type.dart';
import 'package:vitap/pages/HomePage/widgets/CustomIcons.dart';
import 'package:vitap/pages/MarksPage/MarksPage.dart';
import 'package:vitap/pages/Outing_Leave/outingPage.dart';
import 'package:vitap/pages/WebView/webview_vtop.dart';
import 'package:vitap/pages/attendencePage/AttendencePage.dart';

Widget buildQuickLinksSection(BuildContext context, ThemeController theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 10, left: 20),
        child: Text(
          "Quick Links",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate icon width for 4 icons in a row
            final double iconWidth =
                (constraints.maxWidth - 45) / 4; // 3 * spacing = 45
            return Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                buildQuickLinkIcon(
                        icon: Icons.school,
                        name: 'Exam',
                        page: ExamTypePage(),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
                buildQuickLinkIcon(
                        icon: Icons.grade,
                        name: 'Marks',
                        page: MarksPage(),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
                buildQuickLinkIcon(
                        icon: Icons.person,
                        name: 'Attendance',
                        page: AttendancePage(),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
                buildQuickLinkIcon(
                        icon: Icons.person,
                        name: 'Curriculum',
                        page: CurriculumScreen(),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
                buildQuickLinkIcon(
                        icon: Icons.laptop,
                        name: 'VTOP',
                        page: WebViewPage(url: 'https://vtop.vitap.ac.in/'),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
                buildQuickLinkIcon(
                        icon: Icons.outbond,
                        name: 'Outings',
                        page: OutingPage(),
                        context: context,
                        themeController: theme,
                        width: iconWidth)
                    .animate()
                    .slideX(begin: 1),
              ],
            );
          },
        ),
      ),
    ],
  );
}

Widget buildQuickLinkIcon({
  required IconData icon,
  required String name,
  required Widget page,
  required BuildContext context,
  required ThemeController themeController,
  required double width,
}) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ),
    child: SizedBox(
      width: width,
      child: CustomIconWidget(
        icon: icon,
        name: name,
        color: themeController.gradientColors[0],
      ),
    ),
  );
}
