import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/widgets/button.dart';
import 'package:provider/provider.dart';
import '../Providers/CourseListProvider.dart';
import '../Providers/SearchProvider.dart';
import '../widgets/course_card.dart';
import '../widgets/custom_search_bar.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseListProvider = Provider.of<CourseListProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.setSearchLists(
        courseListProvider.courses, courseListProvider.myList);

    return Column(
      children: [
        const CustomSearchBar(),
        _buildTabBar(context, courseListProvider),
        Expanded(
          child: courseListProvider.showMyList
              ? _buildCourseList(context, true)
              : _buildCourseList(context, false),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, CourseListProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyButton(
            onTap: () => provider.toggleView(true),
            buttonText: 'MyList',
            textColor: Colors.black,
            buttonColor: provider.showMyList
                ? const Color(0xFF2A9D8F)
                : const Color(0xFFE0E1DD),
            buttonHeight: 60.h,
            buttonWidth: 190.w,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyButton(
            onTap: () => provider.toggleView(false),
            buttonText: 'All',
            textColor: Colors.black,
            buttonColor: !provider.showMyList
                ? const Color(0xFF2A9D8F)
                : const Color(0xFFE0E1DD),
            buttonHeight: 60.h,
            buttonWidth: 190.w,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(BuildContext context, bool isMyList) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        final courses = isMyList
            ? Provider.of<CourseListProvider>(context, listen: false).myList
            : searchProvider.searchResults;

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              course: course,
              isInMyList: isMyList,
              onActionPressed: () {
                final courseListProvider =
                    Provider.of<CourseListProvider>(context, listen: false);
                if (isMyList) {
                  courseListProvider.removeFromMyList(course);
                } else {
                  courseListProvider.addToMyList(course);
                }
              },
            );
          },
        );
      },
    );
  }
}
