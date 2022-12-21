import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/loginscreen.dart';

import '../helper/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
      _getcurrentstatus();
      _navigatetonext();
  
  
  }



  _getcurrentstatus() async {
    await Helper.getstatus().then((value) {
      if (value != null) {
        setState(() {
          _signedIn = value;
        });
      }
    });
  }
    _navigatetonext() {
    Future.delayed(Duration(milliseconds: 2500), (() {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: ((context) => _signedIn ? Homepage() : Loginpage())));

    }));
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat,color: Colors.white,),

              Text("hey \n BUDDY",style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold
              ),)
              
            ]
          ),
        ),
      ),
    );
  }
}
