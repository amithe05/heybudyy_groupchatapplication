import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/helper/helper_functions.dart';
import 'package:flutter_application_1/service/clouddata.dart';

class AuthService {
  final FirebaseAuth firebaseauth = FirebaseAuth.instance;

  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseauth.signInWithEmailAndPassword(
              email: email, password: password)).user!
          ;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUserWithEmailandPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseauth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        Databaseservice(uid: user.uid).updateData(fullname, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signout() async {
    try {
      await Helper.saveloginuser(false);
      await Helper.saveEmailsf("");
      await Helper.saveUserNamesf("");
      await firebaseauth.signOut();
    } catch (e) {
      return null;
    }
  }
}
