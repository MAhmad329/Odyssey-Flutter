import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/services/auth_services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        cursorColor: primaryColor,
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
                        cursorColor: primaryColor,
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
                          var user =
                              await authService.signInWithEmailAndPassword(
                                  emailController.text,
                                  passwordController.text);
                          if (!mounted) return;

                          if (user != null) {
                            if (user.hasCompletedSetup) {
                              Navigator.pushReplacementNamed(
                                  context, 'courses_screen');
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, 'assessment_screen');
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Login failed, please check your credentials"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;
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
                      buttonColor: primaryColor,
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
                        color: primaryColor,
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
                      buttonColor: primaryColor,
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
