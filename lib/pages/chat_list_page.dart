import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List? messageList = List.empty(growable: true);
  @override
  void initState() {
    // TODO: implement initState
    _getHistoryMessage();
    super.initState();
  }

  void _getHistoryMessage() async {
    var res = await Api.getChatHistoryMessage(page: 1);
    if (res['code'] == 0) {
      setState(() {
        messageList = res['data'];
      });

      print(messageList![0]);
      // print(res['data']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天',
        showBack: false,
      ),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return messageList!.length > 0
              ? ChatListItem(
                  title: messageList![0]['userNickname'].toString(),
                  content: messageList![0]['content'].toString(),
                  time: messageList![0]['time'].toString(),
                  avatar:messageList![0]['userAvatarURL'].toString() ,
                )
              : Container(
                  child: Text('empty'),
                );
        },
      ),
    );
  }
}
