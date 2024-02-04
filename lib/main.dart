import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odyssey/Providers/AssessmentProvider.dart';
import 'package:odyssey/Providers/CourseListProvider.dart';
import 'package:odyssey/Providers/InterestProvider.dart';
import 'package:odyssey/Providers/PageProvider.dart';
import 'package:odyssey/Providers/SearchProvider.dart';
import 'package:odyssey/providers/ChatProvider.dart';
import 'package:odyssey/providers/CourseContentProvider.dart';
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => AuthServiceProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PageProvider(),
      ),
      ChangeNotifierProxyProvider<AuthServiceProvider, CourseContentProvider>(
        create: (context) => CourseContentProvider(
            Provider.of<AuthServiceProvider>(context, listen: false)),
        update: (context, authServiceProvider, previous) =>
            CourseContentProvider(authServiceProvider),
      ),
      ChangeNotifierProvider(
        create: (context) => CourseListProvider(
            Provider.of<AuthServiceProvider>(context, listen: false)),
      ),
      ChangeNotifierProxyProvider<AuthServiceProvider, CourseListProvider>(
        create: (context) => CourseListProvider(
            Provider.of<AuthServiceProvider>(context, listen: false)),
        update: (context, authServiceProvider, previous) =>
            CourseListProvider(authServiceProvider),
      ),
      ChangeNotifierProvider(
        create: (context) => AssessmentProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => InterestProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChatProvider(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
