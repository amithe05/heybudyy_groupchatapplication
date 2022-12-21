import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice {
  String? uid;
  Databaseservice({this.uid});

  final CollectionReference usercollectionreference =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupscollectionreference =
      FirebaseFirestore.instance.collection("groups");

  Future updateData(String fullname, String email) async {
    return await usercollectionreference.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilepic": "",
      "uid": uid,
    });
  }

  Future gettinUserData(String email) async {
    QuerySnapshot snapshot =
        await usercollectionreference.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getusergroups() async {
    return usercollectionreference.doc(uid).snapshots();
  }

  Future creategroup(String groupname, String id, String username) async {
    DocumentReference documentreference = await groupscollectionreference.add({
      "groupName": groupname,
      "groupIcon": "",
      "admin": "${id}_$username",
      "members": [],
      "groupid": "",
      "recentmessage": "",
      "recentmessagesender": "",
    });
    documentreference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"]),
      "groupid": documentreference.id
    });

    DocumentReference userdocumentrefence = usercollectionreference.doc(uid);
    return await userdocumentrefence.update({
      "groups": FieldValue.arrayUnion(["${documentreference.id}_$groupname"])
    });
  }

  getchat(String groupid) async {
    return groupscollectionreference
        .doc(groupid)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getadmin(String groupid) async {
    DocumentReference d = groupscollectionreference.doc(groupid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  getgroupmembers(String groupid) async {
    return groupscollectionreference.doc(groupid).snapshots();
  }

  searcheddata(String groupname) {
    return groupscollectionreference
        .where("groupName", isEqualTo: groupname).get()
        ;
  }

  Future<bool> isuserjoined(
      String groupid, String groupname, String username) async {
    DocumentReference userdocumentreference = usercollectionreference.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocumentreference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupid}_$groupname")) {
      return true;
    } else {
      return false;
    }
  }

  Future togglejoin(String groupid, String groupname, String username) async {
    DocumentReference userdocumentReference = usercollectionreference.doc(uid);
    DocumentReference groupdocumentReference =
        groupscollectionreference.doc(groupid);

    DocumentSnapshot documentSnapshot = await userdocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupid}_$groupname")) {
      await userdocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupid}_$groupname"])
      });

      await groupdocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$username"])
      });
    } else {
      await userdocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupid}_$groupname"])
      });
      await groupdocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$username"])
      });
    }
  }

  sendmessage(String groupid, Map<String, dynamic> chatmessagedata) {
    groupscollectionreference
        .doc(groupid)
        .collection("messages")
        .add(chatmessagedata);
    groupscollectionreference.doc(groupid).update({
      "recentmessage":chatmessagedata['message'],
      "recentmessagesender":chatmessagedata['sender'],
      "recentmessagetime":chatmessagedata['time'].toString()
    });
  }
}
