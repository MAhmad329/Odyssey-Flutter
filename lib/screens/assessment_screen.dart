import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:odyssey/screens/summary_screen.dart';
import 'package:odyssey/widgets/button.dart';
import 'package:provider/provider.dart';
import '../Providers/AssessmentProvider.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Consumer<AssessmentProvider>(
          builder: (context, assessmentModel, child) {
            bool isLastQuestion = assessmentModel.isLastQuestion;
            bool isFirstQuestion = assessmentModel.isFirstQuestion;
            String rightButtonText = isLastQuestion ? 'Submit' : 'Next';

            return Column(
              children: <Widget>[
                Expanded(
                  child: Column(
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
                            constraints: BoxConstraints(
                              minHeight: 180.h,
                              maxHeight:
                                  !isFirstQuestion ? 180.h : double.infinity,
                            ),
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
                                  assessmentModel.currentQuestion.text,
                                  textAlign: isFirstQuestion
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
                      if (!assessmentModel.isFirstQuestion)
                        ...assessmentModel.currentQuestion.options.map(
                          (option) {
                            bool isSelected =
                                option == assessmentModel.getSelectedOption();
                            return Padding(
                              padding: EdgeInsets.only(bottom: 30.h),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? primaryColor
                                      : const Color(
                                          0xFF2A9D8F), // Highlight selected option
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  assessmentModel.answerQuestion(option);
                                },
                                child: SizedBox(
                                  width: 365.w,
                                  height: 60.h,
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        option,
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
                      SizedBox(height: isFirstQuestion ? 170.h : 0.h),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Previous question button
                            Padding(
                              padding: EdgeInsets.only(left: 25.w),
                              child: MyButton(
                                onTap: () {
                                  assessmentModel.previousQuestion();
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
                              child: MyButton(
                                onTap: () {
                                  if (isLastQuestion) {
                                    final provider =
                                        Provider.of<AssessmentProvider>(context,
                                            listen: false);
                                    final score = provider.calculateScore();
                                    final level =
                                        provider.determineLevel(score);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SummaryScreen(
                                            score: score, level: level),
                                      ),
                                    );
                                  } else {
                                    assessmentModel.nextQuestion();
                                  }
                                },
                                isCircular: !isFirstQuestion && !isLastQuestion,
                                buttonWidth: 150.w,
                                buttonHeight: 70.h,
                                buttonSize: 65.r,
                                buttonColor: Colors.white,
                                textColor: Colors.black,
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                  size: 50.r,
                                ),
                                buttonText: isFirstQuestion || isLastQuestion
                                    ? rightButtonText
                                    : null, // Dynamic text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
