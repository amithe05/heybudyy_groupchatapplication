

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/clouddata.dart';

class GroupInfo extends StatefulWidget {
  final String admin;
  final String groupid;
  final String groupname;
  const GroupInfo(
      {super.key,
      required this.admin,
      required this.groupid,
      required this.groupname});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getmembers();
    super.initState();
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getmembers() {
    Databaseservice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getgroupmembers(widget.groupid)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("group info"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupname.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group : ${widget.groupname}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Admin:${getname(widget.admin)}")
                    ],
                  )
                ],
              ),
            ),
            memberlist()
          ],
        ),
      ),
    );
  }

  memberlist() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
               return ListView.builder(
                shrinkWrap: true,
                    itemCount: snapshot.data["members"].length,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child:Text(getname(snapshot.data["members"][index]).substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white),)
                          ),
                          title:Text(getname(snapshot.data["members"][index])),
                        ),
                      );
                    }));
              } else {
                return Center(child: Text("No members"));
              }
            } else {
              return Center(child: Text("No members"));
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }
        });
  }
}
