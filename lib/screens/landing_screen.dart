import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:odyssey/widgets/button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 175.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image(
                      height: 155.h,
                      width: 146.w,
                      fit: BoxFit.contain,
                      image: const AssetImage('assets/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    'Odyssey',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontFamily: "Inika",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 305.h,
              ),
              MyButton(
                  onTap: () {
                    Navigator.pushNamed(context, 'wrapper');
                  },
                  buttonText: 'Get Started',
                  textColor: Colors.black,
                  buttonColor: primaryColor,
                  buttonWidth: 315.w,
                  buttonHeight: 65.h),
            ],
          ),
        ),
      ),
    );
  }
}
