import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/providers/CourseContentProvider.dart';
import 'package:odyssey/screens/learning_screen.dart';
import 'package:provider/provider.dart';
import '../models/CourseModel.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isInMyList;
  final VoidCallback onActionPressed;

  const CourseCard({
    Key? key,
    required this.course,
    required this.isInMyList,
    required this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Image.network(course.imageUrl), // Replace with your image asset
            Column(
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(course.description),
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: onActionPressed,
                  child: Row(
                    children: [
                      Text(isInMyList ? 'Delete' : 'Interested'),
                      Icon(isInMyList
                          ? Icons.delete_forever_sharp
                          : Icons.add_box_outlined),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<CourseContentProvider>(context, listen: false)
                        .setCurrentCourse(course);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningScreen(course: course),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(isInMyList ? 'Proceed' : 'Preview'),
                      const Icon(Icons.play_arrow_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
