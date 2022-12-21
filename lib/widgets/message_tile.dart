import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentbyme;
  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentbyme});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.sentbyme ? 0 : 24,
          right: widget.sentbyme ? 24 : 0,
          top: 5,
          bottom: 5),
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentbyme
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(
                right: 30,
              ),
        decoration: BoxDecoration(
            borderRadius: widget.sentbyme
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
            color: widget.sentbyme
                ? Theme.of(context).primaryColor
                : Colors.grey[500]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
