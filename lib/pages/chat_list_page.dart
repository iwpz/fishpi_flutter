import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/eventbus_manager.dart';
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
  var chatItem;
  @override
  void initState() {
    eventBus.on<OnChatMessageUpdate>().listen((event) {
      print('聊天列表页更新消息：');
      setState(() {
        try {
          chatItem = ChatRoomMessageManager.messageList.lastWhere((element) => element['type'] == 'msg');
          print('获得最新一条消息');
        } catch (ex) {
          print('cell出错');
          print(ex);
          chatItem = null;
        }
      });
    });

    eventBus.on<OnHistoryMessageLoaded>().listen((event) {
      print('聊天列表页更新消息：');
      setState(() {
        try {
          chatItem = ChatRoomMessageManager.messageList.lastWhere((element) => element['type'] == 'msg');
          print('获得最新一条消息');
        } catch (ex) {
          print('cell出错');
          print(ex);
          chatItem = null;
        }
      });
    });
    _updateMessageFromData();
    _getPrivateMessage();

    // ChatRoomMessageManager.loadMessage();

    super.initState();
  }

  void _getPrivateMessage() async {
    var res = await Api.getPrivateMessage();
    print(res);
  }

  void _updateMessageFromData() {
    if (ChatRoomMessageManager.messageList.isEmpty) {
      return;
    }
    print('加载数据源中的消息');
    // print(ChatRoomMessageManager.messageList);
    setState(() {
      try {
        chatItem = ChatRoomMessageManager.messageList.lastWhere((element) => element['type'] == 'msg');
        print('获得最新一条消息');
      } catch (ex) {
        print('cell出错');
        print(ex);
        chatItem = null;
      }
    });
  }

  void _gotoChatRoom() {
    NavigatorTool.push(context, page: const ChatRoomPage());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const BaseAppBar(
        title: '聊天',
        showBack: false,
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          if (chatItem == null) {
            return ClipRect(
              child: Banner(
                  textDirection: TextDirection.rtl,
                  location: BannerLocation.topEnd,
                  color: const Color(0xFFDD0000),
                  message: '聊天室',
                  child: ChatListItem(
                    title: '聊天室',
                    content: '',
                    time: '',
                    messageId: '',
                    avatar: '',
                    onTap: () {
                      _gotoChatRoom();
                    },
                  )),
            );
          }
          return ClipRect(
            child: Banner(
                textDirection: TextDirection.rtl,
                location: BannerLocation.topStart,
                color: const Color(0xAA00AAAA),
                message: '聊天室',
                child: ChatListItem(
                  title: chatItem['userNickname'].toString().isEmpty
                      ? chatItem['userName']
                      : chatItem['userNickname'] + '(${chatItem['userName']})',
                  messageId: chatItem['oId'],
                  content: chatItem['content'].toString(),
                  time: chatItem['time'].toString(),
                  avatar: chatItem['userAvatarURL'].toString(),
                  onTap: () {
                    _gotoChatRoom();
                  },
                )),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
