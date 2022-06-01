import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ChatListItem extends StatefulWidget {
  final String title;
  final String content;
  final String messageId;
  final String? avatar;
  final String time;
  final Function? onTap;
  final String? md;
  const ChatListItem({
    Key? key,
    required this.title,
    required this.messageId,
    required this.content,
    required this.time,
    this.avatar,
    this.onTap,
    this.md,
  }) : super(key: key);

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
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
              margin: const EdgeInsets.only(left: 10),
              child: widget.avatar == null || widget.avatar!.isEmpty ? const Text('头像') : Image.network(widget.avatar!),
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
                            widget.time.isEmpty ? '' : formatDate(DateTime.parse(widget.time), [HH, ':', nn]),
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        child: widget.content.startsWith('{')
                            ? const Text('[红包]')
                            : widget.content.contains('<img')
                                ? const Text('[图片]')
                                : widget.content.contains('<iframe')
                                    ? const Text('[功能]')
                                    : Html(
                                        key: Key(widget.messageId),
                                        data: widget.content.toString(),
                                      ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
