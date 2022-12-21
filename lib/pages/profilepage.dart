
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/widgets/widget.dart';

import 'loginscreen.dart';

class ProfilePage extends StatefulWidget {
  String username;
  String email;

  ProfilePage({super.key, required this.username, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            Text(
              widget.username,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            Divider(height: 3),
            ListTile(
              onTap: (() {
                nextScreen(context, Homepage());
              }),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (() {
                nextScreen(context, Homepage());
              }),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: (() async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        content: Text("Are you sure you want to Logout"),
                        title: Text("Logout"),
                        actions: [
                          IconButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: (() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: ((context) => Loginpage())),
                                  (route) => false);
                            }),
                            icon: Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    }));
              }),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal:40.0,vertical: 170.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,size: 200,color: Colors.grey[700],),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Fullname",style:TextStyle(fontSize: 18.0), ),
                Text(widget.username,style:TextStyle(fontSize: 18.0),)
              ],
            ),
              Divider(height:20.0 ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("email",style:TextStyle(fontSize: 18.0), ),
                Text(widget.email,style:TextStyle(fontSize: 18.0),)
              ],
            ),
          
          ],
        ),
      ),
    );
  }
}
