import 'package:fishpi_flutter/manager/black_list_manager.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/websocket_manager.dart';
import 'package:fishpi_flutter/pages/mine_page.dart';
import 'package:fishpi_flutter/pages/post_list_page.dart';
import 'package:fishpi_flutter/pages/wind_moon_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:flutter/material.dart';

import 'chat_list_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _tabIndex = 0;

  final pages = [
    PostListPage(),
    ChatListPage(),
    WindMoonPage(),
    MinePage(),
  ];
  late PageController _pageController;

  @override
  void initState() {
    WebsocketManager manager = WebsocketManager();
    manager.init();
    ChatRoomMessageManager.startListening();
    super.initState();
    _initBlackList();
    _pageController = PageController(initialPage: _tabIndex, keepPage: true);
  }

  _initBlackList() async {
    var res = await BlackListManager().init();
    print('初始化黑名单列表${res}');
    print(BlackListManager().blackList);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          selectedItemColor: GlobalStyle.mainThemeColor,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, color: GlobalStyle.mainThemeColor),
              activeIcon: Icon(Icons.article, color: GlobalStyle.mainThemeColor),
              label: '帖子',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, color: GlobalStyle.mainThemeColor),
              activeIcon: Icon(Icons.chat_rounded, color: GlobalStyle.mainThemeColor),
              label: '聊天室',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nightlight_outlined, color: GlobalStyle.mainThemeColor),
              activeIcon: Icon(Icons.nightlight, color: GlobalStyle.mainThemeColor),
              label: '清风明月',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, color: GlobalStyle.mainThemeColor),
              activeIcon: Icon(Icons.account_circle, color: GlobalStyle.mainThemeColor),
              label: '我的',
            ),
          ],
        ),
        body: PageView(
          children: pages,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
