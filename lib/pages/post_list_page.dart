import 'package:fishpi_flutter/pages/post_pages/good_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/hot_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_reply_post_list_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatefulWidget {
  PostListPage({Key? key}) : super(key: key);

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
