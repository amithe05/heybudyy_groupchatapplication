

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/groupinfo.dart';
import 'package:flutter_application_1/service/clouddata.dart';
import 'package:flutter_application_1/widgets/widget.dart';

import '../widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupname;
  final String groupid;
  final String username;
  const ChatPage(
      {super.key,
      required this.groupname,
      required this.groupid,
      required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messagecontroller = TextEditingController();
  String admin = "";
  Stream<QuerySnapshot>? chats;
  @override
  void initState() {
    getchatandadmin();
    super.initState();
  }

  getchatandadmin() {
    Databaseservice().getchat(widget.groupid).then((value) {
      setState(() {
        chats = value;
      });
    });

    Databaseservice().getadmin(widget.groupid).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(widget.groupname),
          actions: [
            IconButton(
                onPressed: (() {
                  nextScreen(
                      context,
                      GroupInfo(
                        admin: admin,
                        groupid: widget.groupid,
                        groupname: widget.groupname,
                      ));
                }),
                icon:const Icon(Icons.info))
          ],
        ),
        body: Stack(
          children:<Widget>[
            
    StreamBuilder(
        stream: chats,
        builder: ((context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: ((context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]["message"],
                        sender: snapshot.data.docs[index]["sender"],
                        sentbyme: widget.username ==
                            snapshot.data.docs[index]["sender"]);
                  }))
              : Container();
        })),


            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.grey[700],
                padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      cursorColor: Colors.white,
                      controller: messagecontroller,
                      style:const TextStyle(color: Colors.white),
                      decoration:const InputDecoration(
                          border: InputBorder.none,
                          hintText: "start your chat.....",
                          hintStyle: TextStyle(color: Colors.white)),
                    )),
                   const  SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendmessage();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).primaryColor),
                        child:const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }


  sendmessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> chatmessagemap = {
        "message": messagecontroller.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      Databaseservice().sendmessage(widget.groupid, chatmessagemap);
      setState(() {
        messagecontroller.clear();
      });
    }
  }
}
