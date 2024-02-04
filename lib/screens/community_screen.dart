import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/Providers/CourseListProvider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/CourseModel.dart';
import 'chat_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseListProvider = Provider.of<CourseListProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        toolbarHeight: 75.h,
        title: Text(
          'Community',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 48.sp),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: courseListProvider.myList.length,
        itemBuilder: (context, index) {
          Course course = courseListProvider.myList[index];
          return Container(
            margin: EdgeInsets.all(5.0.r),
            decoration: BoxDecoration(
              color: primaryColor, // Yellow box
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            child: ListTile(
              title: Text(
                course.name,
                style:
                    const TextStyle(color: Colors.black), // Custom text style
              ),
              onTap: () {
                // Navigate to the ChatScreen for the selected course
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(course: course),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
