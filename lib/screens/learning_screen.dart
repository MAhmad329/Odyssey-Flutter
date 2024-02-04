import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:highlight/languages/python.dart';
import 'package:odyssey/Providers/PageProvider.dart';
import 'package:odyssey/constants.dart';
import 'package:odyssey/providers/CourseContentProvider.dart';
import 'package:odyssey/screens/community_screen.dart';
import 'package:provider/provider.dart';
import '../models/CourseModel.dart';
import '../widgets/button.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({Key? key, required this.course}) : super(key: key);
  final Course course;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF264653),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        toolbarHeight: 75.h,
        title: Text(
          'Learn',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 48.sp),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildUI(context),
          )
        ],
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    return Consumer<CourseContentProvider>(
      builder: (context, provider, child) {
        return Column(
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
                        pageProvider.toggleMode(true);
                        provider.resetEditedCode();
                      },
                      buttonText: 'Course',
                      textColor: Colors.black,
                      buttonColor: pageProvider.isCourseSelected
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
                        pageProvider.toggleMode(false);
                      },
                      buttonText: 'Practice',
                      textColor: Colors.black,
                      buttonColor: !pageProvider.isCourseSelected
                          ? const Color(0xFF2A9D8F)
                          : const Color(0xFFE0E1DD),
                      buttonHeight: 60.h,
                      buttonWidth: 190.w,
                    ),
                  ),
                ],
              ),
            ),
            // Inside LearningScreen Widget
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CommunityScreen(),
                  ),
                );
              },
              child: Text('Join Community Chat'),
            ),

            if (pageProvider.isCourseSelected)
              _buildCourseView(context, provider),
            if (!pageProvider.isCourseSelected)
              _buildPracticeView(context, provider),
          ],
        );
      },
    );
  }

  Widget _buildCourseView(
      BuildContext context, CourseContentProvider provider) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              child: Image(
                height: 200.h,
                width: double.infinity.w,
                fit: BoxFit.fill,
                image: const AssetImage('assets/java.png'),
              ),
            ),
            SizedBox(height: 25.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      onTap: () {
                        provider.previousTopic();
                      },
                      buttonSize: 50.r,
                      isCircular: true,
                      icon: Icon(
                        Icons.chevron_left,
                        size: 50.r,
                      ),
                    ),
                    Text(
                      provider.currentTopic.title,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    MyButton(
                      onTap: () {
                        provider.nextTopic();
                      },
                      buttonSize: 50.r,
                      isCircular: true,
                      icon: Icon(
                        Icons.chevron_right,
                        size: 50.r,
                      ),
                    ),
                  ],
                ),
                Text(provider.currentTopic.content),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            if (provider.currentTopic.codeExample != null)
              Material(
                child: CodeField(
                  readOnly: true,
                  controller: CodeController(
                      text: provider.currentTopic.codeExample!,
                      language: python),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeView(
      BuildContext context, CourseContentProvider provider) {
    var practiceCodeController = CodeController(
      text: provider.editedCode,
      language: python,
    );

    // When the code is edited, update it in the provider
    practiceCodeController.addListener(() {
      provider.updateEditedCode(practiceCodeController.text);
    });
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.currentTopic.codeExample != null)
              Material(
                child: Column(
                  children: [
                    SizedBox(height: 25.h),
                    const Column(
                      children: [
                        Text('Task'),
                        Text(
                            'Replace the XX part of the code with the right syntax'),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CodeField(
                          controller: practiceCodeController,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyButton(
                            onTap: () {
                              provider.runCode(provider.editedCode);
                            },
                            buttonText: 'Run',
                            textColor: Colors.black,
                            buttonColor: const Color(0xFF2A9D8F),
                            buttonHeight: 50.h,
                            buttonWidth: 100.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Output:'),
                              Text(provider.output),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (provider.currentTopic.codeExample == null)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 50.h), // Adjust padding as needed
                  child: Text(
                    'This topic has no exercise',
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      fontSize: 24.sp, // Set a font size (adjust as needed)
                      color: Colors.black, // Set text color
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
