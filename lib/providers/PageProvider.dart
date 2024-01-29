import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  int _selectedIndex = 0;
  final List<String> _titles = ['Courses', 'Learn', 'Progress', 'Profile'];

  int get selectedIndex => _selectedIndex;
  String get currentTitle => _titles[_selectedIndex];

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
