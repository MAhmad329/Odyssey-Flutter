import 'package:flutter/material.dart';

class InterestModel with ChangeNotifier {
  String _selectedInterest = '';
  int _currentQuestionIndex = 0;

  final List<String> _questions = [
    'Now let’s dive into your interests and what brings you here before starting your journey',
    'What draws your attention when you think about technology?'
  ];

  final List<String> _interestOptions = [
    'Creating websites or apps',
    'Analysing data or creating visual reports',
    'Making smart systems or robots',
    'Ensuring that computer networks are safe and secure'
  ];

  String get selectedInterest => _selectedInterest;
  int get currentQuestionIndex => _currentQuestionIndex;
  String get currentQuestionText => _questions[_currentQuestionIndex];
  List<String> get interestOptions => _interestOptions;

  void selectInterest(String interest) {
    if (_selectedInterest != interest) {
      _selectedInterest = interest;
      notifyListeners();
    }
  }

  void goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }
}
