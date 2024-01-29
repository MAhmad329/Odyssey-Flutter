import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/constants.dart';
import 'package:provider/provider.dart';
import '../Providers/SearchProvider.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: 'Search courses',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: primaryColor, width: 2.5.w),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          suffixIcon: Icon(
            Icons.search,
            size: 35.r,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) =>
            Provider.of<SearchProvider>(context, listen: false)
                .updateSearchQuery(value),
      ),
    );
  }
}
