

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/helper_functions.dart';
import 'package:flutter_application_1/pages/loginscreen.dart';
import 'package:flutter_application_1/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isloading = false;
  final _formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullname = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 80.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                       Text(
                          "hey BUDDY",
                          style: GoogleFonts.newsCycle(
                              fontSize: 40, letterSpacing: -3),
                        ),
                        SizedBox(
                          height: 9.0,
                        ),
                        Text(
                          "Create your account now to chat and explore",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15.0),
                        ),
                        Image.asset("assets/register.png"),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Fullname",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              fullname = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "name cannot be empty";
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            return RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(value!)
                                ? null
                                : "enter a valid email ";
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          cursorColor: Colors.black,
                          decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return "atleast 6 characters required";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0))),
                              onPressed: () {
                                register();
                              },
                              child: Text("Register")),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text.rich(TextSpan(
                            text: "Already have an account?  ",
                            style: TextStyle(fontSize: 15.0),
                            children: [
                              TextSpan(
                                  text: 'Login now',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, Loginpage());
                                    })
                            ]))
                      ],
                    ),
                  )),
            ),
    );
  }

  register() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      await authService
          .registerUserWithEmailandPassword(fullname, email, password)
          .then((value) async {
        if (value == true) {
          await Helper.saveloginuser(true);
          await Helper.saveEmailsf(email);
          await Helper.saveUserNamesf(fullname);
          // nextScreenReplace(context, Homepage());
        } else {
             showsnackbar(context, Colors.red, value);
          setState(() {
         
            _isloading = false;
          });
        }
      });
    }
  }
}
