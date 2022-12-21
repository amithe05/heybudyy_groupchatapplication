import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/helper_functions.dart';
import 'package:flutter_application_1/pages/chatpage.dart';
import 'package:flutter_application_1/service/clouddata.dart';
import 'package:flutter_application_1/widgets/widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchcontroller = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchsnapshot;
  bool isusersearched = false;
  String username = "";
  User? user;
  bool isjoined = false;
  @override
  void initState() {
    getusername();
    super.initState();
  }

  getusername() async {
    await Helper.getusersf().then((value) {
      setState(() {
        username = value!;
      });
      user = FirebaseAuth.instance.currentUser!;
    });
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchcontroller,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "search groups....",
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16.0)),
                )),
                GestureDetector(
                  onTap: (() {
                    initiatesearch();
                  }),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.white.withOpacity(0.2)),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isloading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : grouplist()
        ],
      ),
    );
  }

  initiatesearch() async {
    if (searchcontroller.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await Databaseservice()
          .searcheddata(searchcontroller.text)
          .then((snapshot) {
        setState(() {
          searchsnapshot = snapshot;
          isusersearched = true;
          _isloading = false;
        });
      });
    }
  }

  grouplist() {
    return isusersearched
        ? ListView.builder(
            itemCount: searchsnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return grouptile(
                username,
                searchsnapshot!.docs[index]["groupName"],
                searchsnapshot!.docs[index]["groupid"],
                searchsnapshot!.docs[index]["admin"],
              );
            },
          )
        : Container();
  }

  isjoinedornot(
      String groupname, String username, String groupid, String admin) async {
    await Databaseservice(uid: user!.uid)
        .isuserjoined(groupid, groupname, username)
        .then((value) {
      setState(() {
        isjoined = value;
      });
    });
  }

  Widget grouptile(
      String username, String groupname, String groupid, String admin) {
    isjoinedornot(groupname, username, groupid, admin);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupname.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(groupname),
      subtitle: Text("Admin:${getname(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await Databaseservice(uid: user!.uid)
              .togglejoin(groupid, groupname, username);
          if (isjoined) {
            setState(() {
              isjoined = !isjoined;
            });
            showsnackbar(context, Colors.green, "succesfully joined the group");
            Future.delayed(Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupname: groupname,
                      groupid: groupid,
                      username: username));
            });
          } else {
            setState(() {
              isjoined = !isjoined;
            });

            showsnackbar(context, Colors.red, "left the group");
          }
        },
        child: isjoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text("join now"),
              ),
      ),
    );
  }
}
