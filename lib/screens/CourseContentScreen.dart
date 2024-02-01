import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/CourseModel.dart';
import '../providers/CourseContentProvider.dart';

class CourseContentScreen extends StatelessWidget {
  final Course course;

  const CourseContentScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseContentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(provider.currentCourse!.name),
          ),
          body: Column(
            children: [
              // Course content section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(provider.currentTopic.title,
                          style: TextStyle(fontSize: 24)),
                      Text(provider.currentTopic.content),
                      if (provider.currentTopic.codeExample != null)
                        CodeField(code: provider.currentTopic.codeExample!),
                    ],
                  ),
                ),
              ),
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: provider.previousTopic,
                    child: Text('Previous Topic'),
                  ),
                  ElevatedButton(
                    onPressed: provider.nextTopic,
                    child: Text('Next Topic'),
                  ),
                ],
              ),
              // Practice section
              Expanded(
                child: provider.currentTopic.codeExample != null
                    ? CodeTextField(editableCode: provider.currentCodeExample)
                    : Text('No practice for this topic'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CodeField extends StatelessWidget {
  final String code;

  const CodeField({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('woorking');
    // Return a widget to display the code (read-only)
    // You can use `code_text_editor` or any other suitable widget
  }
}

class CodeTextField extends StatelessWidget {
  final String editableCode;

  const CodeTextField({Key? key, required this.editableCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('woorking');
    // Return an editable text field for code
    // You can use `code_text_editor` or any other suitable widget
  }
}
