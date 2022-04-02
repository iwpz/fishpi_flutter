import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    // TODO: implement initState
    _getHistoryMessage();
    super.initState();
  }

  void _getHistoryMessage() async {
    var res = await Api.getChatHistoryMessage(page: 1);
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天',
        showBack: false,
      ),
      child: Text('聊天列表'),
    );
  }
}
