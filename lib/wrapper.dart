import 'package:flutter/material.dart';
import 'package:odyssey/screens/assessment_screen.dart';
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
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? const LoginScreen() : const AssessmentScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
