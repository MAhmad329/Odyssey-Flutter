import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/widgets/button.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/auth_services.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final String level;

  const SummaryScreen({Key? key, required this.score, required this.level})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        toolbarHeight: 75.h,
        title: Text(
          'Assessment',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 48.sp),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score:  $score',
              style: TextStyle(
                  fontFamily: 'Kameron',
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                  color: primaryColor),
            ),
            Text(
              'Your Level:  $level',
              style: TextStyle(
                  fontFamily: 'Kameron',
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                  color: primaryColor),
            ),
            SizedBox(
              height: 15.h,
            ),
            MyButton(
              buttonWidth: 175.w,
              buttonHeight: 70.h,
              buttonColor: Colors.white,
              textColor: Colors.black,
              buttonText: 'Continue',
              onTap: () {
                final authProvider =
                    Provider.of<AuthServiceProvider>(context, listen: false);
                authProvider.updateUserLevel(level).then((_) {
                  Navigator.pushNamed(context, 'interest_screen');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
