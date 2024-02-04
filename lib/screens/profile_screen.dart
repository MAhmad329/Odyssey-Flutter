import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/Providers/PageProvider.dart';
import 'package:odyssey/widgets/button.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../services/auth_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServiceProvider>(context);
    final pageProvider = Provider.of<PageProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          FutureBuilder<String?>(
            future: authProvider
                .getUserName(), // Implement this in AuthServiceProvider
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: primaryColor);
              }
              final name = snapshot.data;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name ?? "Set a Name",
                        style: TextStyle(
                          fontFamily: 'Kameron',
                          fontSize: 24.sp,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _editName(context, authProvider, name),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: MyButton(
              onTap: () {
                _changePassword(context);
              },
              buttonWidth: 1.sw - 40.w, // Take full screen width minus padding
              buttonHeight: 50.h,
              textColor: Colors.black,
              buttonText: 'Change Password',
              buttonColor: primaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: MyButton(
              onTap: () async {
                await authProvider.signOut();
                pageProvider.selectedIndex = 0;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'login_screen', (Route<dynamic> route) => false);
              },
              buttonWidth: 1.sw - 40.w, // Full screen width minus padding
              buttonHeight: 50.h,
              textColor: Colors.black,
              buttonText: 'Logout',
              buttonColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

void _editName(BuildContext context, AuthServiceProvider authProvider,
    String? currentName) {
  final pageProvider = Provider.of<PageProvider>(context, listen: false);
  final TextEditingController nameController =
      TextEditingController(text: currentName);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "Edit Name",
            style: TextStyle(
                fontFamily: 'Kameron',
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                color: const Color(0xFF264653)),
          ),
        ),
        backgroundColor: primaryColor,
        content: TextField(
          style: const TextStyle(color: Colors.white),
          controller: nameController,
          cursorColor: primaryColor,
          decoration: kTextFieldDecoration.copyWith(
            hintText: 'Name',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    color: const Color(0xFF264653),
                  ),
                ),
              ),
              SizedBox(
                width: 50.w,
              ),
              TextButton(
                onPressed: () async {
                  await authProvider.updateUserName(
                      authProvider.currentUser!.uid, nameController.text);
                  pageProvider.selectedIndex = 0;
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    color: const Color(0xFF264653),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void _changePassword(BuildContext context) {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      bool passwordsMatch = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: primaryColor,
            title: Center(
              child: Text(
                "Change Password",
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  color: const Color(0xFF264653),
                ),
              ),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 300, // Minimum width for the AlertDialog
                maxWidth: MediaQuery.of(context).size.width *
                    0.9, // 90% of screen width
                minHeight: 100, // Minimum height for the AlertDialog
                maxHeight: MediaQuery.of(context).size.height *
                    0.5, // 50% of screen height
              ),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: primaryColor,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Password',
                      ),
                      controller: passwordController,
                      obscureText: true,
                      onChanged: (_) {
                        setState(
                          () {
                            passwordsMatch = passwordController.text ==
                                confirmPasswordController.text;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: primaryColor,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confirm Password',
                      ),
                      controller: confirmPasswordController,
                      obscureText: true,
                      onChanged: (_) {
                        setState(() {
                          passwordsMatch = passwordController.text ==
                              confirmPasswordController.text;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'Kameron',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                        color: const Color(0xFF264653),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                  TextButton(
                    onPressed: passwordsMatch
                        ? () async {
                            await Provider.of<AuthServiceProvider>(context,
                                    listen: false)
                                .changePassword(passwordController.text);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text(
                      "Change",
                      style: TextStyle(
                        fontFamily: 'Kameron',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                        color: passwordsMatch
                            ? const Color(0xFF264653)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
