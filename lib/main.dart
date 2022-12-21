import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/loginscreen.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';

import 'package:flutter_application_1/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.appKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messageSenderId,
      projectId: Constants.projectId,
    ));
  } else {
    await Firebase.initializeApp();
  }

 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Constants.primarycolour,
            scaffoldBackgroundColor:const Color(0xffffffff)),
        debugShowCheckedModeBanner: false,
        home:const  SplashScreen());
  }
}
