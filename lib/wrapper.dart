import 'package:flutter/material.dart';
import 'package:odyssey/screens/assessment_screen.dart';
import 'package:odyssey/screens/home_screen.dart';
import 'package:odyssey/screens/interest_screen.dart';
import 'package:odyssey/screens/login_screen.dart';
import 'package:odyssey/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'models/UserModel.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServiceProvider>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        }

        final User? user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        } else if (user.assessmentLevel == '') {
          return const AssessmentScreen();
        } else if (!user.hasCompletedSetup) {
          return const InterestScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}
