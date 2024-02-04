import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/CourseModel.dart';
import '../services/auth_services.dart';

class CourseListProvider with ChangeNotifier {
  bool _isDisposed = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServiceProvider _authService;
  List<Course> _myList = [];
  bool _showMyList = true; // Toggle between all courses and my list
  List<Course> get myList => _myList;
  List<Course> get courses => _showMyList ? _myList : _allCourses;
  bool get showMyList => _showMyList;
  Course? _currentCourse;

  CourseListProvider(this._authService) {
    _authService.user.listen((user) {
      if (user != null) {
        _fetchMyList();
      }
    });
  }

  void clearCourseList() {
    _myList.clear();
    notifyListeners();
  }

  Stream<List<Course>> get courseStream {
    if (_authService.currentUser == null) {
      return Stream.value([]);
    }
    String userId = _authService.currentUser!.uid;

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('interestedCourses')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) {
              // Assuming each doc is a map representing a Course,
              // and you have the topics available in _allCourses.
              String courseName = doc.data()['name'];
              Course? fullCourse = _allCourses.firstWhere(
                  (c) => c.name == courseName,
                  orElse: () => Course(
                      courseID: '',
                      name: '',
                      description: '',
                      topics: [],
                      language: '',
                      mainFileName: '',
                      courseImage: ''));

              return fullCourse != null
                  ? Course.fromMap(doc.data(), fullCourse.topics)
                  : null;
            })
            .whereType<Course>()
            .toList(); // Filter out any null values
      },
    );
  }

  final List<Course> _allCourses = [
    Course(
        courseID: '1',
        name: 'Java',
        description: 'Java from zero-to-hero for beginners with practice',
        topics: [
          Topic(
              title: 'Introduction to Java',
              content: 'Java is...',
              codeExample:
                  "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello, World!\");\n    }\n}"),
          Topic(
              title: 'Variables in Java',
              content: 'Variables are...',
              codeExample:
                  "public class Main {\n    public static void main(String[] args) {\n        String name = \"Java\";\n        int number = 10;\n        System.out.println(\"Name: \" + name + \", Number: \" + number);\n    }\n}"),
          Topic(
              title: 'Loops in Java',
              content: 'Loops are...',
              codeExample:
                  "public class Main {\n    public static void main(String[] args) {\n        for(int i = 0; i < 5; i++) {\n            System.out.println(\"Loop iteration: \" + i);\n        }\n    }\n}"),
          Topic(
              title: 'If-Else in Java',
              content: 'If-Else are...',
              codeExample:
                  "public class Main {\n    public static void main(String[] args) {\n        int number = 5;\n        if(number > 0) {\n            System.out.println(\"Number is positive.\");\n        } else {\n            System.out.println(\"Number is not positive.\");\n        }\n    }\n}"),
        ],
        language: 'java',
        mainFileName: 'Main.java',
        courseImage:
            'https://developers.redhat.com/sites/default/files/styles/share/public/ST-java1_2x.png?itok=LP1xR4KL'),
    Course(
        courseID: '2',
        name: 'Python',
        description: 'Python from zero-to-hero for beginners with practice',
        topics: [
          Topic(
              title: 'Introduction to Python',
              content: 'Python is...',
              codeExample: "print('Hello, World!')"),
          Topic(
              title: 'Variables in Python',
              content: 'Variables are...',
              codeExample:
                  "name = 'Python'\nnumber = 10\nprint(f'Name: {name}, Number: {number}')"),
          Topic(
              title: 'Loops in Python',
              content: 'Loops are...',
              codeExample:
                  "for i in range(5):\n    print(f'Loop iteration: {i}')"),
          Topic(
              title: 'If-Else in Python',
              content: 'If-Else are...',
              codeExample:
                  "number = 5\nif number > 0:\n    print('Number is positive.')\nelse:\n    print('Number is not positive.')"),
        ],
        language: 'python',
        mainFileName: 'main.py',
        courseImage:
            'https://miro.medium.com/v2/resize:fit:1400/1*ycIMlwgwicqlO6PcFRA-Iw.png'),
    Course(
      courseID: '3',
      name: 'C++',
      description: 'C++ from zero-to-hero for beginners with practice',
      topics: [
        Topic(
          title: 'Introduction to C++',
          content: 'C++ is...',
          // codeExample:
          //     "#include <iostream>\nint main() {\n    std::cout << \"Hello World\" << std::endl;\n    return 0;\n}",
        ),
        Topic(
          title: 'Variables in C++',
          content: 'Variables are...',
          codeExample:
              "#include <iostream>\nint main() {\n    int myNumber = 10;\n    double myFloatNum = 5.99;\n    char myLetter = 'D';\n    bool myBoolean = true;\n    std::string myText = \"Hello\";\n\n    std::cout << \"Integer: \" << myNumber << '\\n';\n    std::cout << \"Double: \" << myFloatNum << '\\n';\n    std::cout << \"Char: \" << myLetter << '\\n';\n    std::cout << \"Boolean: \" << myBoolean << '\\n';\n    std::cout << \"String: \" << myText << std::endl;\n    return 0;\n}",
        ),
        Topic(
          title: 'Loops in C++',
          content: 'Loops are...',
          codeExample:
              "#include <iostream>\nint main() {\n    for(int i = 0; i < 5; i++) {\n        std::cout << \"Loop iteration: \" << i << std::endl;\n    }\n    return 0;\n}",
        ),
        Topic(
          title: 'If-Else in C++',
          content: 'If-Else are...',
          codeExample:
              "#include <iostream>\nint main() {\n    int number = 10;\n    if(number > 0) {\n        std::cout << \"Number is positive.\" << std::endl;\n    } else {\n        std::cout << \"Number is non-positive.\" << std::endl;\n    }\n    return 0;\n}",
        ),
      ],
      language: 'cpp',
      mainFileName: 'Main.cpp',
      courseImage:
          'https://beecrowd.io/wp-content/uploads/2023/01/Post-1_2-BKG.jpg',
    ),
    Course(
        courseID: '4',
        name: 'Cyber',
        description:
            'CyberSecurity from zero-to-hero for beginners with practice',
        topics: [
          Topic(
              title: 'Introduction to CyberSecurity',
              content: 'Cyber Security is is...',
              codeExample: "print('Something about if else in python')"),
          Topic(
            title: 'Something in cyber security',
            content: 'Cyber is ...',
            // No code example for this topic
          ),
          Topic(
              title: 'something else in cyber security',
              content: 'Loops are...',
              codeExample: "print('Something about if else in python')"),
          Topic(
              title: ' something else else in cyber security',
              content: 'If-Else are...',
              codeExample: "print('Something about if else in python')"),
        ],
        language: 'python',
        mainFileName: 'Main.py',
        courseImage:
            'https://www.cloud4c.com/ph/sites/ph/files/2024-01/Cybersecurity-strategy-services-cloud4c-webpage-1.webp'),
  ];

  // Toggle view between all courses and my list
  void toggleView(bool showMyList) {
    _showMyList = showMyList;
    notifyListeners();
  }

  void setCurrentCourse(Course course) {
    _currentCourse = course;
  }

  Course? getCurrentCourse() {
    return _currentCourse;
  }

  Future<void> _fetchMyList() async {
    if (_authService.currentUser == null) return;
    String userId = _authService.currentUser!.uid;

    var userDoc = await _firestore.collection('users').doc(userId).get();
    var userData = userDoc.data();
    bool isFirstTime = userData?['isFirstTime'] ?? true;

    var snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('interestedCourses')
        .get();

    _myList = snapshot.docs
        .map((doc) {
          String courseName = doc.data()['name'];
          Course? fullCourse = _allCourses.firstWhere(
              (c) => c.name == courseName,
              orElse: () => Course(
                  courseID: '',
                  name: '',
                  description: '',
                  topics: [],
                  language: '',
                  mainFileName: '',
                  courseImage: ''));

          return fullCourse != null
              ? Course.fromMap(doc.data(), fullCourse.topics)
              : null;
        })
        .whereType<Course>()
        .toList(); // Remove any nulls from the list

    if (isFirstTime) {
      String? selectedInterest = _authService.currentUser?.selectedInterest;
      if (selectedInterest != null) {
        Course courseForInterest = _findCourseForInterest(selectedInterest);
        if (courseForInterest.name.isNotEmpty) {
          addToMyList(courseForInterest);
          await _firestore
              .collection('users')
              .doc(userId)
              .update({'isFirstTime': false});
        }
      }
    }

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Course _findCourseForInterest(String interest) {
    if (interest.toLowerCase().contains('websites')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Java',
        orElse: () => Course(
            courseID: '',
            name: '',
            description: '',
            topics: [],
            language: '',
            mainFileName: '',
            courseImage: ''),
      );
    } else if (interest.toLowerCase().contains('network')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Cyber',
        orElse: () => Course(
            courseID: '',
            name: '',
            description: '',
            topics: [],
            language: '',
            mainFileName: '',
            courseImage: ''),
      );
    } else if (interest.toLowerCase().contains('data')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Python',
        orElse: () => Course(
            courseID: '',
            name: '',
            description: '',
            topics: [],
            language: '',
            mainFileName: '',
            courseImage: ''),
      );
    } else if (interest.toLowerCase().contains('smart')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'C++',
        orElse: () => Course(
            courseID: '',
            name: '',
            description: '',
            topics: [],
            language: '',
            mainFileName: '',
            courseImage: ''),
      );
    }
    return Course(
        courseID: '',
        name: '',
        description: '',
        topics: [],
        language: '',
        mainFileName: '',
        courseImage: '');
  }

  Future<void> addToMyList(Course course) async {
    if (_authService.currentUser == null || course.name.isEmpty) return;
    String userId = _authService.currentUser!.uid;

    if (!_myList.any((c) => c.name == course.name)) {
      _myList.add(course);
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('interestedCourses')
          .doc(course.name)
          .set(course.toMap());
      notifyListeners();
    }
  }

  Future<void> removeFromMyList(Course course) async {
    if (_authService.currentUser == null) return;
    String userId = _authService.currentUser!.uid;

    _myList.removeWhere((c) => c.name == course.name);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('interestedCourses')
        .doc(course.name)
        .delete();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
