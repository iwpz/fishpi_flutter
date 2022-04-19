import 'package:fishpi_flutter/manager/websocket_manager.dart';
import 'package:fishpi_flutter/pages/chat_room_page.dart';
import 'package:fishpi_flutter/pages/mine_page.dart';
import 'package:fishpi_flutter/pages/post_list_page.dart';
import 'package:fishpi_flutter/pages/wind_moon_page.dart';
import 'package:flutter/material.dart';

import 'chat_list_page.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);

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
    super.initState();
    _pageController = PageController(initialPage: _tabIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.article), label: '帖子'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: '聊天室'),
            BottomNavigationBarItem(icon: Icon(Icons.nightlight), label: '清风明月'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: '我的'),
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
