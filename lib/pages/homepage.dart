import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/helper_functions.dart';
import 'package:flutter_application_1/pages/loginscreen.dart';

import 'package:flutter_application_1/service/auth_service.dart';
import 'package:flutter_application_1/service/clouddata.dart';
import 'package:flutter_application_1/widgets/listtile.dart';
import 'package:flutter_application_1/widgets/widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  AuthService authService = AuthService();
  String username = " ";
  String email = " ";
  Stream? groups;
  bool _isloading = false;
  String groupname = "";
  @override
  void initState() {
    getemailandusername();
    super.initState();
  }

  String getgroupid(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getgroupname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getemailandusername() async {
    await Helper.getusersf().then((value) {
      setState(() {
        username = value!;
      });
    });
    await Helper.getemailsf().then((valu) {
      setState(() {
        email = valu!;
      });
    });

    await Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getusergroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                // nextScreen(context, SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
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
              username.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            Divider(height: 3),
            ListTile(
              onTap: (() {}),
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              // onTap: (() {
              //   nextScreenReplace(
              //       context,
              //       ProfilePage(
              //         username: username,
              //         email: email,
              //       ));
              // }),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
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
      body: grouplist(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          popupdialog(context);
        }),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  grouplist() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: ((context, index) {
                    int reverseindex =
                        snapshot.data['groups'].length - index - 1;
                    return ListTil(
                        groupname:
                            getgroupname(snapshot.data['groups'][reverseindex]),
                        groupid:
                            getgroupid(snapshot.data['groups'][reverseindex]),
                        username: username);
                  }));
            } else {
              return nowidget();
            }
          } else {
            return nowidget();
          }
        } else
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
      },
    );
  }

  nowidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popupdialog(context);
            },
            child: Icon(
              Icons.add_circle,
              size: 75,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "you haven't joined any groups, click on the icon to add a group or also search from top search button",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  popupdialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Create your group",
                  textAlign: TextAlign.left,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isloading == true
                        ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                        )
                        : TextField(
                            onChanged: ((value) {
                              groupname = value;
                            }),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ))))
                  ],
                ),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: Text(
                        "Cancel",
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: (() {
                        if (groupname != "") {
                          setState(() {
                            _isloading = true;
                          });
                          Databaseservice(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .creategroup(
                                  groupname,
                                  FirebaseAuth.instance.currentUser!.uid,
                                  username)
                              .whenComplete(() => _isloading = false);
                          Navigator.of(context).pop();
                          showsnackbar(context, Colors.green,
                              "Group created succesfully");
                        }
                      }),
                      child: Text(
                        "Create",
                      ))
                ],
              );
            },
          );
        }));
  }
}
