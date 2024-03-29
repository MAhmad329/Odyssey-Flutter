import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:odyssey/widgets/button.dart';
import 'package:provider/provider.dart';
import '../Providers/InterestProvider.dart';
import '../services/auth_services.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({Key? key}) : super(key: key);

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthServiceProvider>(context, listen: false);
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF264653),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        toolbarHeight: 75.h,
        title: Text(
          'Personal',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 48.sp),
        ),
        centerTitle: true,
      ),
      body: Consumer<InterestProvider>(
        builder: (context, interestModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 60.h,
                  bottom: 70.h,
                  left: 5.w,
                  right: 5.w,
                ),
                child: Center(
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: 180.h, maxHeight: 180.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        25.r,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Center(
                        child: Text(
                          interestModel.currentQuestionText,
                          textAlign: interestModel.currentQuestionIndex == 0
                              ? TextAlign.left
                              : TextAlign.center,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontFamily: 'Kameron',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (interestModel.currentQuestionIndex == 1)
                ...interestModel.interestOptions.map(
                  (interest) {
                    bool isSelected =
                        interest == interestModel.selectedInterest;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 30.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? primaryColor
                              : const Color(0xFF2A9D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          interestModel.selectInterest(interest);
                        },
                        child: SizedBox(
                          width: 365.w,
                          height: 60.h,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                interest,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              SizedBox(
                height: interestModel.currentQuestionIndex == 0 ? 360.h : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.w),
                      child: MyButton(
                        onTap: () {
                          interestModel.goToPreviousQuestion();
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          size: 50.r,
                        ),
                        buttonColor: Colors.white,
                        buttonSize: 65.r,
                        isCircular: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 25.w),
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                            )
                          : MyButton(
                              onTap: () async {
                                if (interestModel.currentQuestionIndex == 1 &&
                                    interestModel.selectedInterest.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (user != null) {
                                    await authService.updateUserInterest(
                                        user.uid,
                                        interestModel.selectedInterest);
                                    await authService.completeSetup(user.uid);
                                  }

                                  if (mounted) {
                                    Navigator.pushReplacementNamed(
                                        context, 'home_screen');
                                  }
                                } else {
                                  interestModel.goToNextQuestion();
                                }
                              },
                              buttonWidth: 150.w,
                              buttonHeight: 70.h,
                              buttonSize: 65.r,
                              buttonColor: Colors.white,
                              textColor: Colors.black,
                              buttonText: isLoading
                                  ? ''
                                  : interestModel.currentQuestionIndex == 0
                                      ? 'Next'
                                      : 'Submit',
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
