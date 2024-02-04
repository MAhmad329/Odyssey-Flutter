import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:provider/provider.dart';
import '../Providers/PageProvider.dart';
import '../models/CourseModel.dart';
import '../Providers/CourseListProvider.dart';
import '../widgets/button.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseListProvider =
        Provider.of<CourseListProvider>(context, listen: false);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    return StreamBuilder<List<Course>>(
      stream: courseListProvider.courseStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 50.w,
              height: 50.h,
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show a message if there are no courses
          return _buildNoCoursesMessage("No courses found");
        }

        List<Course> allCourses = snapshot.data ?? [];
        List<Course> completedCourses = allCourses
            .where(
                (course) => course.lastTopicIndex == course.topics.length - 1)
            .toList();
        List<Course> inProgressCourses = allCourses
            .where((course) => course.lastTopicIndex < course.topics.length - 1)
            .toList();

        return Scaffold(
          body: Column(
            children: [
              Container(
                color: const Color(0xFF264653),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyButton(
                        onTap: () {
                          pageProvider.toggleProgressMode(true);
                        },
                        buttonText: 'Complete',
                        textColor: Colors.black,
                        buttonColor: pageProvider.isCompletedSelected
                            ? const Color(0xFF2A9D8F)
                            : const Color(0xFFE0E1DD),
                        buttonHeight: 60.h,
                        buttonWidth: 190.w,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyButton(
                        onTap: () {
                          pageProvider.toggleProgressMode(false);
                        },
                        buttonText: 'Progress',
                        textColor: Colors.black,
                        buttonColor: !pageProvider.isCompletedSelected
                            ? const Color(0xFF2A9D8F)
                            : const Color(0xFFE0E1DD),
                        buttonHeight: 60.h,
                        buttonWidth: 190.w,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: pageProvider.isCompletedSelected
                      ? _buildCompletedView(completedCourses)
                      : _buildProgressView(context, inProgressCourses),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompletedView(List<Course> completedCourses) {
    if (completedCourses.isEmpty) {
      return _buildNoCoursesMessage("No courses completed till now");
    }

    return Column(
      children: completedCourses.map((course) {
        return Card(
          color: Colors.amber[200], // Adjust color to match the screenshot
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp, // Adjust font size as needed
                  ),
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)), // Rounded corners
                  child: Stack(
                    children: [
                      LinearProgressIndicator(
                        value: 1.0, // Completed course, so progress is 100%
                        minHeight: 20.h, // Adjust for the desired thickness
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.teal[300],
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '100%', // 100% completion
                                style: TextStyle(
                                  fontFamily: 'Kameron',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Completed', // Display completion status
                  style: TextStyle(
                    fontSize: 14.sp, // Adjust font size as needed
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget _buildProgressView(
    BuildContext context, List<Course> inProgressCourses) {
  if (inProgressCourses.isEmpty) {
    return _buildNoCoursesMessage("No currently active courses");
  }

  return Column(
    children: inProgressCourses.map((course) {
      int topicsCovered = course.lastTopicIndex == 0 && !course.isInterested
          ? 0
          : course.lastTopicIndex + 1;
      int totalTopics = course.topics.length;
      double progress = totalTopics > 0 ? (topicsCovered / totalTopics) : 0.0;

      return Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp, // Adjust font size as needed
                ),
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(10)), // Rounded corners
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 20.h, // Adjust for the desired thickness
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.teal[300],
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%', // Rounded percentage
                              style: const TextStyle(
                                fontFamily: 'Kameron',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '$topicsCovered out of $totalTopics',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 16.sp, // Adjust font size as needed
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildNoCoursesMessage(String message) {
  return Container(
    color: Colors.amber, // Yellow color
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16.sp, // Adjust font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
