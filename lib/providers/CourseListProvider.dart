import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/CourseModel.dart';
import '../services/auth_services.dart';
import '../services/courses.dart';

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

  final List<Course> _allCourses = allCourses;

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
