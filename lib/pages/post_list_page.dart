import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:fishpi_flutter/pages/post_pages/good_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/hot_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_post_list_page.dart';
import 'package:fishpi_flutter/pages/post_pages/recent_reply_post_list_page.dart';
import 'package:fishpi_flutter/pages/send_post_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
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
        appBar: BaseAppBar(
          showBack: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: PopupMenuButton<String>(
                onSelected: (item) {
                  int type = 0;
                  // 0:帖子,5:问答,3:思绪,1:机要(附加机要标签),2:同城广播
                  if (item == '帖子') {
                    type = 0;
                  } else if (item == '问答') {
                    type = 5;
                  } else if (item == '思绪') {
                    type = 3;
                  } else if (item == '机要') {
                    type = 1;
                  } else if (item == '同城广播') {
                    type = 2;
                  }
                  debugPrint('点击了$item');
                  NavigatorTool.push(context, page: SendPostPage(type: type), then: (dynamic) {
                    eventBus.fire(OnListNeedRefreshEvent());
                  });
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
          title: '帖子们',
        ),
        body: TabBarView(
          children: [
            const RecentPostListPage(),
            const HotPostListPage(),
            const GoodPostListPage(),
            const RecentReplyPostListPage(),
          ],
        ),
      ),
    );
  }
}
