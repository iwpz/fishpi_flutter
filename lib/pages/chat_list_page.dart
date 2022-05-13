import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/pages/chat_room_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/chat_list/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with AutomaticKeepAliveClientMixin {
  List? messageList = List.empty(growable: true);
  /*
  ['userNickname'].toString(),
                  content: latestMessage['content'].toString(),
                  time: latestMessage['time'].toString(),
                  avatar: latestMessage['userAvatarURL']
   */
  var latestMessage = null;

  @override
  void initState() {
    _getHistoryMessage();

    ChatRoomMessageManager.listeningNewMessage((message) {
      if (message['type'] == 'msg') {
        setState(() {
          latestMessage = message;
        });
      } else if (message['type'] == 'online') {
        DataManager.chatRoomOnLineInfo = message;
      }
    });
    super.initState();
  }

  void _getHistoryMessage() async {
    var res = await Api.getChatHistoryMessage(page: 1);
    if (res['code'] == 0) {
      // setState(() {
      messageList = res['data'];
      // });

      setState(() {
        if (messageList != null && messageList!.isNotEmpty) {
          latestMessage = messageList!.first;
          debugPrint('最新消息：');
          debugPrint(latestMessage['content']);
        }
      });
    }
  }

  void _gotoChatRoom() {
    NavigatorTool.push(context, page: const ChatRoomPage());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天',
        showBack: false,
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return latestMessage == null
              ? ChatListItem(
                  title: '聊天室',
                  content: '',
                  time: '',
                  messageId: '',
                  avatar: '',
                  onTap: () {
                    _gotoChatRoom();
                  },
                )
              : ChatListItem(
                  title: latestMessage['userNickname'].toString().isEmpty
                      ? latestMessage['userName']
                      : latestMessage['userNickname'] + '(${latestMessage['userName']})',
                  messageId: latestMessage['oId'],
                  content: latestMessage['content'].toString(),
                  time: latestMessage['time'].toString(),
                  avatar: latestMessage['userAvatarURL'].toString(),
                  onTap: () {
                    _gotoChatRoom();
                  },
                );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
