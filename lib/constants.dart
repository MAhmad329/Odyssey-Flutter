import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color primaryColor = const Color(0xFFE9C46A);

TextStyle kText2 = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
  fontFamily: 'Poppins',
);

InputDecoration kTextFieldDecoration = const InputDecoration(
  hintText: 'hint text',
  hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Kameron'),
  filled: true,
  fillColor: Colors.blueGrey,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFE9C46A), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    borderSide: BorderSide(
      width: 2,
      color: Colors.red,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    borderSide: BorderSide(
      width: 2,
      color: Colors.red,
    ),
  ),
);
