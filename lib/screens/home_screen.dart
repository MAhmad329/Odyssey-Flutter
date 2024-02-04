import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/screens/profile_screen.dart';
import 'package:odyssey/screens/progress_screen.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../Providers/PageProvider.dart';
import 'courses_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF264653),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            foregroundColor: Colors.black,
            toolbarHeight: 75.h,
            title: Text(
              pageProvider.currentTitle,
              style: TextStyle(fontFamily: 'Kameron', fontSize: 48.sp),
            ),
            centerTitle: true,
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              if (index != 1) {
                // Exclude 'Learn' screen index
                pageProvider.selectedIndex = index;
              }
            },
            children: [
              CoursesScreen(),
              CoursesScreen(), // added just for replacement
              ProgressScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 75.h,
            child: BottomNavigationBar(
              currentIndex: pageProvider.selectedIndex,
              onTap: (index) {
                if (index != 1) {
                  // Check if the tapped item is not 'Learn'
                  _pageController.jumpToPage(index);
                  pageProvider.selectedIndex = index;
                }
              },
              selectedItemColor: const Color(0xFF2A9D8F),
              unselectedItemColor: Colors.black,
              selectedIconTheme: IconThemeData(
                color: const Color(0xFF2A9D8F),
                size: 35.r,
              ),
              unselectedIconTheme: IconThemeData(
                color: Colors.black,
                size: 30.r,
              ),
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Kameron',
                fontSize: 16.sp,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 16.sp,
              ),
              backgroundColor: primaryColor,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Courses',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.code),
                  label: 'Learn',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
