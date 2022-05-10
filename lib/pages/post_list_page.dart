import 'package:fishpi_flutter/pages/post_pages/good_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/hot_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_reply_post_list_page.dart';
import 'package:fishpi_flutter/pages/send_post_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: PopupMenuButton<String>(
                onSelected: (item) {
                  debugPrint('点击了$item');
                  NavigatorTool.push(context, page: SendPostPage());
                },
                itemBuilder: (BuildContext context) {
                  return {'帖子', '问答', '思绪', '机要', '同城广播'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                child: const Icon(Icons.post_add),
              ),
            ),
          ],

          // [
          //   GestureDetector(
          //     onTap: () {
          //       NavigatorTool.push(context, page: SendPostPage());
          //     },
          //     child: Container(
          //       margin: const EdgeInsets.only(right: 20),
          //       child: const Icon(Icons.post_add),
          //     ),
          //   ),

          // ],
          backgroundColor: GlobalStyle.mainThemeColor,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '最新'),
              Tab(text: '热门'),
              Tab(text: '点赞'),
              Tab(text: '最近回复'),
            ],
          ),
          title: const Text('帖子们'),
        ),
        body: TabBarView(
          children: [
            RecentPostListPage(),
            HotPostListPage(),
            GoodPostListPage(),
            RecentReplyPostListPage(),
          ],
        ),
      ),
    );
  }
}
