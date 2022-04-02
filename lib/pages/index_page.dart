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
    ChatListPage(),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
  ];

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
