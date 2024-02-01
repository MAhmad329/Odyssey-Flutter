import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/CourseModel.dart';
import '../services/auth_services.dart';

class CourseContentProvider with ChangeNotifier {
  int _currentTopicIndex = 0;
  Course? _currentCourse;
  String _output = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServiceProvider _authService;

  CourseContentProvider(this._authService);

  String get output => _output;
  Future<void> runCode(String code) async {
    final response = await http.post(
      Uri.parse('https://glot.io/api/run/java/latest'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            '0c4556d3-df67-4801-80ea-7c74d05cd168', // Replace with your API key
      },
      body: jsonEncode({
        'files': [
          {'name': 'Main.java', 'content': code}
        ],
      }),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      String output = result['stdout'] ?? '';
      String error = result['stderr'] ?? '';

      if (error.isNotEmpty) {
        _output = "Error:\n$error";
      }
      if (output.isNotEmpty) {
        _output = output;
      }
      if (output.isEmpty && error.isEmpty) {
        _output = "No output or error";
      }
    } else {
      _output = 'Error running code. Status code: ${response.statusCode}';
    }
    notifyListeners();
  }

  String? _editedCode;

  void updateEditedCode(String newCode) {
    _editedCode = newCode;
  }

  String get editedCode => _editedCode ?? currentTopic.codeExample ?? '';

  void resetEditedCode() {
    _editedCode = currentTopic.codeExample;
    notifyListeners();
  }

  Future<void> loadLastTopicIndex() async {
    if (_currentCourse != null && _authService.currentUser != null) {
      String userId = _authService.currentUser!.uid;
      String courseName = _currentCourse!.name;

      var courseDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('interestedCourses')
          .doc(courseName)
          .get();

      if (courseDoc.exists) {
        int lastTopicIndex = courseDoc.data()?['lastTopicIndex'] ?? 0;
        _currentTopicIndex = lastTopicIndex;
        notifyListeners();
      }
    }
  }

  void setCurrentCourse(Course course) {
    _currentCourse = course;
    loadLastTopicIndex();
    notifyListeners();
  }

  Course? get currentCourse => _currentCourse;

  Topic get currentTopic =>
      _currentCourse?.topics[_currentTopicIndex] ??
      Topic(title: '', content: '');

  void nextTopic() {
    if (_currentTopicIndex < (_currentCourse?.topics.length ?? 0) - 1) {
      _currentTopicIndex++;
      updateLastTopicIndexInFirebase();
      notifyListeners();
    }
  }

  void previousTopic() {
    if (_currentTopicIndex > 0) {
      _currentTopicIndex--;
      notifyListeners();
    }
  }

  void updateLastTopicIndexInFirebase() async {
    if (_currentCourse != null && _authService.currentUser != null) {
      String userId = _authService.currentUser!.uid;
      String courseName = _currentCourse!.name;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('interestedCourses')
          .doc(courseName)
          .update({'lastTopicIndex': _currentTopicIndex});
      notifyListeners();
    }
  }

  String get currentCodeExample => currentTopic.codeExample ?? '';
}
