import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/models/InterestModel.dart';
import 'package:odyssey/models/PageProvider.dart';
import 'package:odyssey/screens/assessment_screen.dart';
import 'package:odyssey/screens/home_screen.dart';
import 'package:odyssey/screens/interest_screen.dart';
import 'package:odyssey/screens/landing_screen.dart';
import 'package:odyssey/screens/login_screen.dart';
import 'package:odyssey/screens/signup_screen.dart';
import 'package:odyssey/services/auth_services.dart';
import 'package:odyssey/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/AssessmentModel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => PageProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthService(),
      ),
      ChangeNotifierProvider(
        create: (context) => AssessmentModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => InterestModel(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: 'landing_screen',
            routes: {
              'wrapper': (context) => const Wrapper(),
              'landing_screen': (context) => const LandingScreen(),
              'assessment_screen': (context) => const AssessmentScreen(),
              'interest_screen': (context) => const InterestScreen(),
              'login_screen': (context) => const LoginScreen(),
              'signup_screen': (context) => const SignupScreen(),
              'home_screen': (context) => HomeScreen(),
            },
          );
        });
  }
}
