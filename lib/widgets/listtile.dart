import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widget.dart';

class ListTil extends StatefulWidget {
  final String groupname;
  final String groupid;
  final String username;

  const ListTil(
      {super.key,
      required this.groupname,
      required this.groupid,
      required this.username});

  @override
  State<ListTil> createState() => _ListTilState();
}

class _ListTilState extends State<ListTil> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // nextScreen(context, ChatPage(groupname: widget.groupname,groupid: widget.groupid,username: widget.username,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupname.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            widget.groupname,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("join in chat as ${widget.username}"),
        ),
      ),
    );
  }
}
