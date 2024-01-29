import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/CourseModel.dart';
import '../services/auth_services.dart';

class CourseListProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServiceProvider _authService;

  CourseListProvider(this._authService) {
    _fetchMyList();
  }

  final List<Course> _allCourses = [
    Course(
        name: 'Java',
        description: 'Java from zero-to-hero for beginners with practice'),
    Course(
        name: 'Flutter',
        description: 'Flutter from zero-to-hero for beginners with practice'),
    Course(
        name: 'React',
        description: 'React from zero-to-hero for beginners with practice'),
    Course(
        name: 'Cyber',
        description: 'React from zero-to-hero for beginners with practice'),
  ];

  List<Course> _myList = [];
  bool _showMyList = false; // Toggle between all courses and my list
  List<Course> get myList => _myList;
  List<Course> get courses => _showMyList ? _myList : _allCourses;
  bool get showMyList => _showMyList;

  // Toggle view between all courses and my list
  void toggleView(bool showMyList) {
    _showMyList = showMyList;
    notifyListeners();
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
    _myList = snapshot.docs.map((doc) => Course.fromMap(doc.data())).toList();

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

    notifyListeners();
  }

  Course _findCourseForInterest(String interest) {
    if (interest.toLowerCase().contains('websites')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Flutter',
        orElse: () => Course(name: '', description: ''),
      );
    } else if (interest.toLowerCase().contains('network')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Cyber',
        orElse: () => Course(name: '', description: ''),
      );
    } else if (interest.toLowerCase().contains('data')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'React',
        orElse: () => Course(name: '', description: ''),
      );
    } else if (interest.toLowerCase().contains('smart')) {
      return _allCourses.firstWhere(
        (c) => c.name == 'Java',
        orElse: () => Course(name: '', description: ''),
      );
    }
    return Course(name: '', description: '');
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
