import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String loggedInUser = "loggedinuser";
  static String usernamekey = "usernamekey";
  static String useremailkey = "Useremailkey";

  static Future<bool> saveloginuser(bool userloginkey) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(loggedInUser, userloginkey);
  }
   static Future<bool> saveUserNamesf(String name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(usernamekey,name);
  }

 static Future<bool> saveEmailsf(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(useremailkey, email);
  }


  static Future<bool?> getstatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loggedInUser);
  }
   static Future<String?> getusersf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernamekey);
  }
   static Future<String?> getemailsf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useremailkey);
  }
}

