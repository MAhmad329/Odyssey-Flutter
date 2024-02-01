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
    List<Course> filteredAllCourses = _filterCourses(query, _allCourses);
    List<Course> filteredMyList = _filterCourses(query, _myList);

    if (query.isEmpty) {
      _searchResults = _allCourses; // When query is empty, show all courses
    } else {
      // Start with filtered 'allCourses'
      _searchResults = filteredAllCourses;

      // Add courses from 'myList' that are not in 'allCourses'
      for (var course in filteredMyList) {
        if (!filteredAllCourses.any((c) => c.name == course.name)) {
          _searchResults.add(course);
        }
      }
    }

    notifyListeners();
  }

  List<Course> _filterCourses(String query, List<Course> courses) {
    if (query.isEmpty) return courses;
    return courses
        .where(
            (course) => course.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Course> getFilteredCourses(bool isMyList, List<Course> myList) {
    if (isMyList) {
      return searchResults.where((course) => myList.contains(course)).toList();
    } else {
      return searchResults;
    }
  }
}
