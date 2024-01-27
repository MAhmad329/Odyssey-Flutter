import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/services/auth_services.dart';
import 'package:odyssey/widgets/text_field.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF264653),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      child: Image(
                        height: 155.h,
                        width: 146.w,
                        fit: BoxFit.contain,
                        image: const AssetImage('assets/logo.png'),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontFamily: "Inika",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 360.w,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        cursorColor: const Color(0xFFE9C46A),
                        controller: emailController,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SizedBox(
                      width: 360.w,
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        cursorColor: const Color(0xFFE9C46A),
                        controller: passwordController,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    const Spacer(),
                    MyButton(
                      onTap: () async {
                        try {
                          await authService.signInWithEmailAndPassword(
                              emailController.text, passwordController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Failed to sign in: ${e.toString()}"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      buttonText: 'Login',
                      textColor: Colors.black,
                      buttonColor: const Color(0xFFE9C46A),
                      buttonWidth: 355.w,
                      buttonHeight: 50.h,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: const Color(0xFFE9C46A),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    MyButton(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, 'signup_screen');
                      },
                      buttonText: 'Register',
                      textColor: Colors.black,
                      buttonColor: const Color(0xFFE9C46A),
                      buttonWidth: 355.w,
                      buttonHeight: 50.h,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
