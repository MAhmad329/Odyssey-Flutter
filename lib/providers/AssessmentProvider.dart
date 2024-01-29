import 'package:flutter/cupertino.dart';

import '../models/QuestionModel.dart';

class AssessmentProvider with ChangeNotifier {
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedOptions = {};
  bool get isFirstQuestion => _currentQuestionIndex == 0;
  final List<Question> _questions = [
    Question(
      text:
          'To get to know each other, the following questions are made to evaluate your background and knowledge in IT (information technology) field. please answer by your own. if you know nothing. you can skip',
      options: ['Option A', 'Option B', 'Option C', 'Option D'],
      correctAnswer: 'Option A',
    ),
    Question(
      text: 'What does the \'var\' keyword in JavaScript declare?',
      options: [
        'A variable with block scope',
        'A constant',
        'A variable with function scope',
        'A package'
      ],
      correctAnswer: 'A variable with function scope',
    ),
    Question(
      text: 'What does the \'var\' keyword in JavaScript declare?',
      options: [
        'A variable with block scope',
        'A constant',
        'A variable with function scope',
        'A package'
      ],
      correctAnswer: 'A variable with function scope',
    ),
    Question(
      text: 'What does the \'var\' keyword in JavaScript declare?',
      options: [
        'A variable with block scope',
        'A constant',
        'A variable with function scope',
        'A package'
      ],
      correctAnswer: 'A variable with function scope',
    ),
  ];

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  void nextQuestion() {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      // Handle the end of the assessment, such as calculating the score or showing results
    }
  }

  void previousQuestion() {
    if (!isFirstQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void answerQuestion(String option) {
    _selectedOptions[_currentQuestionIndex] =
        option; // Store the selected option
    notifyListeners();
  }

  String? getSelectedOption() {
    return _selectedOptions[_currentQuestionIndex];
  }
}
