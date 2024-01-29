import 'package:flutter/material.dart';
import '../models/CourseModel.dart';

class SearchProvider with ChangeNotifier {
  List<Course> _searchResults = [];
  List<Course> _allCourses = [];
  List<Course> _myList = [];
  String _searchQuery = '';

  List<Course> get searchResults =>
      _searchQuery.isEmpty ? _allCourses : _searchResults;

  void setSearchLists(List<Course> allCourses, List<Course> myList) {
    _allCourses = allCourses;
    _myList = myList;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    searchCourse(_searchQuery);
    notifyListeners();
  }

  void searchCourse(String query) {
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _allCourses
          .where((course) =>
              course.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _searchResults.addAll(_myList
          .where((course) =>
              course.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
      // Remove duplicates
      _searchResults = _searchResults.toSet().toList();
    }
  }
}
