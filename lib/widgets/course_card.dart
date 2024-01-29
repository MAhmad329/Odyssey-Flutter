import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Image.network(course.imageUrl), // Replace with your image asset
            Text(course.name,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text(course.description),
            ElevatedButton(
              onPressed: onActionPressed,
              child: Text(isInMyList ? 'Delete' : 'Interested'),
            ),
          ],
        ),
      ),
    );
  }
}
