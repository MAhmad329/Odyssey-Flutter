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
      text: 'Which data structure uses LIFO (Last In, First Out) principle?',
      options: ['Queue', 'Stack', 'Array', 'LinkedList'],
      correctAnswer: 'Stack',
    ),
    Question(
      text: 'What is the time complexity of binary search algorithm?',
      options: ['O(n)', 'O(log n)', 'O(n^2)', 'O(n log n)'],
      correctAnswer: 'O(log n)',
    ),
    Question(
      text: 'Which of the following is a lossless data compression technique?',
      options: ['Huffman Coding', 'JPEG', 'MP3', 'MPEG'],
      correctAnswer: 'Huffman Coding',
    ),
    Question(
      text: 'What does SQL stand for?',
      options: [
        'Structured Question Language',
        'Structured Query List',
        'Simple Query Language',
        'Structured Query Language'
      ],
      correctAnswer: 'Structured Query Language',
    ),
    Question(
      text:
          'Which of the following is not a relational database management system (RDBMS)?',
      options: ['MySQL', 'MongoDB', 'PostgreSQL', 'Oracle'],
      correctAnswer: 'MongoDB',
    ),
    Question(
      text: 'In the MVC design pattern, what does "C" stand for?',
      options: ['Control', 'Controller', 'Container', 'Component'],
      correctAnswer: 'Controller',
    ),
    Question(
      text: 'What is the primary purpose of normalization in databases?',
      options: [
        'To reduce data redundancy',
        'To increase storage efficiency',
        'To speed up queries',
        'To simplify database design'
      ],
      correctAnswer: 'To reduce data redundancy',
    ),
    Question(
      text:
          'Which sorting algorithm is considered the fastest in general cases?',
      options: ['Bubble Sort', 'Quick Sort', 'Insertion Sort', 'Merge Sort'],
      correctAnswer: 'Quick Sort',
    ),
    Question(
      text: 'What is encapsulation in object-oriented programming?',
      options: [
        'The process of combining data and functions into a single unit',
        'Breaking down a program into smaller parts',
        'The practice of hiding internal implementation details',
        'A pattern used to create objects'
      ],
      correctAnswer:
          'The process of combining data and functions into a single unit',
    ),
    Question(
      text: 'Which of the following is true about IPv6 addresses?',
      options: [
        'They are 32 bits in length',
        'They offer fewer IP address possibilities than IPv4',
        'They are 128 bits in length',
        'They use only hexadecimal digits'
      ],
      correctAnswer: 'They are 128 bits in length',
    ),
    Question(
      text: 'In programming, what is recursion?',
      options: [
        'A function that calls itself',
        'A loop that never ends',
        'A type of inheritance in OOP',
        'A method for solving differential equations'
      ],
      correctAnswer: 'A function that calls itself',
    ),
    Question(
      text: 'Which protocol is used to send email?',
      options: ['SMTP', 'FTP', 'HTTP', 'SNMP'],
      correctAnswer: 'SMTP',
    ),
    Question(
      text: 'What is the main difference between a class and an object in OOP?',
      options: [
        'An object is a blueprint from which a class is created',
        'A class is an instance of an object',
        'A class is a blueprint from which objects are created',
        'There is no difference'
      ],
      correctAnswer: 'A class is a blueprint from which objects are created',
    ),
    Question(
      text: 'Which of the following is a NoSQL database?',
      options: ['Oracle', 'SQL Server', 'MongoDB', 'DB2'],
      correctAnswer: 'MongoDB',
    ),
    Question(
      text: 'What is the main advantage of using cloud computing?',
      options: [
        'Unlimited data storage for free',
        'Absolute data privacy',
        'Scalability and flexibility of resources',
        'One-time payment for services'
      ],
      correctAnswer: 'Scalability and flexibility of resources',
    ),
    Question(
      text: 'In computer networking, what does DHCP stand for?',
      options: [
        'Dynamic Host Configuration Protocol',
        'Direct HTTP Connection Protocol',
        'Data Handling Control Protocol',
        'Domain Host Control Protocol'
      ],
      correctAnswer: 'Dynamic Host Configuration Protocol',
    ),
    Question(
      text: 'What is the primary function of a compiler?',
      options: [
        'To convert high-level programming language to machine language',
        'To increase the execution speed of a program',
        'To manage the resources of a computer',
        'To provide a platform for running application software'
      ],
      correctAnswer:
          'To convert high-level programming language to machine language',
    ),
    Question(
      text: 'Which of the following best describes Agile software development?',
      options: [
        'A set of programming tools',
        'A type of software license',
        'A method that emphasizes incremental development and collaboration',
        'A database design principle'
      ],
      correctAnswer:
          'A method that emphasizes incremental development and collaboration',
    ),
    Question(
      text: 'In web development, what does CSS stand for?',
      options: [
        'Cascading Style Sheets',
        'Computer Style Syntax',
        'Common Styling Sheets',
        'Compact Style Scripts'
      ],
      correctAnswer: 'Cascading Style Sheets',
    ),
  ];

  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  int calculateScore() {
    int score = 0;
    _selectedOptions.forEach((index, answer) {
      if (_questions[index].correctAnswer == answer) {
        score++;
      }
    });
    return score;
  }

  String determineLevel(int score) {
    if (score <= 5) {
      return 'Beginner';
    } else if (score <= 12) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }

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
