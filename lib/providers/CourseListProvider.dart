import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/CourseModel.dart';
import '../services/auth_services.dart';

class CourseListProvider with ChangeNotifier {
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServiceProvider _authService;
  List<Course> _myList = [];
  bool _showMyList = true; // Toggle between all courses and my list
  List<Course> get myList => _myList;
  List<Course> get courses => _showMyList ? _myList : _allCourses;
  bool get showMyList => _showMyList;
  Course? _currentCourse;

  // Inside CourseListProvider
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
                      courseID: '', name: '', description: '', topics: []));

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
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}"),
        Topic(
          title: 'Variables in Java',
          content: 'Variables are are...',
          // No code example for this topic
        ),
        Topic(
            title: 'Loops in Java',
            content: 'Loops are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about loops\");\n    }\n}"),
        Topic(
            title: 'If-Else in Java',
            content: 'If-Else are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about ifelse\");\n    }\n}"),
      ],
    ),
    Course(
      courseID: '2',
      name: 'Python',
      description: 'Python from zero-to-hero for beginners with practice',
      topics: [
        Topic(
            title: 'Introduction to Java',
            content: 'Java is...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}"),
        Topic(
          title: 'Variables in Java',
          content: 'Variables are are...',
          // No code example for this topic
        ),
        Topic(
            title: 'Loops in Java',
            content: 'Loops are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about loops\");\n    }\n}"),
        Topic(
            title: 'If-Else in Java',
            content: 'If-Else are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about ifelse\");\n    }\n}"),
      ],
    ),
    Course(
      courseID: '3',
      name: 'React',
      description: 'React from zero-to-hero for beginners with practice',
      topics: [
        Topic(
            title: 'Introduction to Java',
            content: 'Java is...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}"),
        Topic(
          title: 'Variables in Java',
          content: 'Variables are are...',
          // No code example for this topic
        ),
        Topic(
            title: 'Loops in Java',
            content: 'Loops are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about loops\");\n    }\n}"),
        Topic(
            title: 'If-Else in Java',
            content: 'If-Else are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about ifelse\");\n    }\n}"),
      ],
    ),
    Course(
      courseID: '4',
      name: 'Cyber',
      description: 'React from zero-to-hero for beginners with practice',
      topics: [
        Topic(
            title: 'Introduction to Java',
            content: 'Java is...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}"),
        Topic(
          title: 'Variables in Java',
          content: 'Variables are are...',
          // No code example for this topic
        ),
        Topic(
            title: 'Loops in Java',
            content: 'Loops are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about loops\");\n    }\n}"),
        Topic(
            title: 'If-Else in Java',
            content: 'If-Else are...',
            codeExample:
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Something about ifelse\");\n    }\n}"),
      ],
    ),
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
              orElse: () =>
                  Course(courseID: '', name: '', description: '', topics: []));

          // If the course exists in _allCourses, use its topics; otherwise, return null
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
        (c) => c.name == 'React',
        orElse: () =>
            Course(courseID: '', name: '', description: '', topics: []),
      );
    } else if (interest.toLowerCase().contains('network')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Cyber',
        orElse: () =>
            Course(courseID: '', name: '', description: '', topics: []),
      );
    } else if (interest.toLowerCase().contains('data')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Python',
        orElse: () =>
            Course(courseID: '', name: '', description: '', topics: []),
      );
    } else if (interest.toLowerCase().contains('smart')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Java',
        orElse: () =>
            Course(courseID: '', name: '', description: '', topics: []),
      );
    }
    return Course(courseID: '', name: '', description: '', topics: []);
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
}
