import 'package:fishpi_flutter/manager/websocket_manager.dart';
import 'package:fishpi_flutter/pages/chat_room_page.dart';
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
    ChatRoomPage(),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
  ];

  @override
  void initState() {
    WebsocketManager manager = WebsocketManager();
    manager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: '聊天室'),
              BottomNavigationBarItem(icon: Icon(Icons.nightlight), label: '清风明月'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: '我的'),
            ],
          ),
          body: pages[_tabIndex]),
    );
  }
}
