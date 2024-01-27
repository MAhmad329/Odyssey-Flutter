import 'package:flutter/material.dart';
import 'package:odyssey/screens/assessment_screen.dart';
import 'package:odyssey/screens/home_screen.dart';
import 'package:odyssey/screens/login_screen.dart';
import 'package:odyssey/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'models/UserModel.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final User? user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        } else if (!user.hasCompletedSetup) {
          return const AssessmentScreen();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}
