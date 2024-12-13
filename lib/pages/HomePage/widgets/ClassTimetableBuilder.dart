import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vitap/pages/HomePage/widgets/custom_Card.dart';
import 'package:vitap/pages/TimeTable/timetablepage.dart';

Widget buildTodaysPlanSection(List<dynamic> todayClasses, BuildContext context,
    int currentPage, PageController _pageController, bool isLoading) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Text(
              "Today's Plan",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimetablePage()),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("view all", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      SizedBox(height: 10),
      isLoading
          ? Container(
              height: 150,
              child: Shimmer.fromColors(
                baseColor: Colors.black!,
                highlightColor: Colors.blue!,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Number of shimmer items
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width - 40,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    );
                  },
                ),
              ),
            )
          : todayClasses.isNotEmpty
              ? Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 150,
                      // width: MediaQuery.of(context).size.width - 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        itemCount: todayClasses.length,
                        itemBuilder: (context, index) {
                          var classInfo = todayClasses[index];
                          return CustomCard(
                            venu: classInfo['class'],
                            courseCode: classInfo['code'],
                            slot: classInfo['slot'],
                            courseName: classInfo['courseName'],
                            startTime: classInfo['startTime'],
                            endTime: classInfo['endTime'],
                          )
                              .animate()
                              .slideX(begin: (index.toDouble() + 1) * 0.25);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(todayClasses.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No classes right now",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
    ],
  );
}
