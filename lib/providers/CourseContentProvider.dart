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
  String? _editedCode;
  String get editedCode => _editedCode ?? currentTopic.codeExample ?? '';
  Course? get currentCourse => _currentCourse;
  String get currentCodeExample => currentTopic.codeExample ?? '';

  CourseContentProvider(this._authService);

  String get output => _output;
  Future<void> runCode(String code) async {
    if (_currentCourse == null) {
      _output = "No course selected";
      notifyListeners();
      return;
    }
    // Use dynamic values
    String language = _currentCourse!.language;
    String mainFileName = _currentCourse!.mainFileName;

    final response = await http.post(
      Uri.parse('https://glot.io/api/run/$language/latest'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            '0c4556d3-df67-4801-80ea-7c74d05cd168', // Replace with your API key
      },
      body: jsonEncode({
        'files': [
          {'name': mainFileName, 'content': code}
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

  void updateEditedCode(String newCode) {
    _editedCode = newCode;
  }

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

  Topic get currentTopic =>
      _currentCourse?.topics[_currentTopicIndex] ??
      Topic(title: '', content: '');

  void nextTopic() {
    if (_currentTopicIndex < (_currentCourse?.topics.length ?? 0) - 1) {
      _currentTopicIndex++;
      updateLastTopicIndexInFirebase();
      resetEditedCode();
      notifyListeners();
    }
  }

  void previousTopic() {
    if (_currentTopicIndex > 0) {
      _currentTopicIndex--;
      resetEditedCode();
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
}
