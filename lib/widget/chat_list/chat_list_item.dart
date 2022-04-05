import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatefulWidget {
  final String title;
  final String content;
  final String? avatar;
  final String time;
  const ChatListItem(
      {Key? key,
      required this.title,
      required this.content,
      required this.time,
      this.avatar})
      : super(key: key);

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            color: Colors.green,
            margin: const EdgeInsets.only(left: 10),
            child: widget.avatar == null
                ? const Text('头像')
                : Image.network(widget.avatar!),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          formatDate(
                              DateTime.parse(widget.time), [HH, ':', mm]),
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
