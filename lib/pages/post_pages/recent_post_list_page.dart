import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/pages/post_detail_page.dart';
import 'package:fishpi_flutter/pages/post_pages/post_list_item.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/iwpz_tableview.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentPostListPage extends StatefulWidget {
  const RecentPostListPage({Key? key}) : super(key: key);

  @override
  State<RecentPostListPage> createState() => _RecentPostListPageState();
}

class _RecentPostListPageState extends State<RecentPostListPage> with AutomaticKeepAliveClientMixin {
  List postList = List.empty(growable: true);
  final RefreshController _refreshController = RefreshController();
  int currentPage = 1;
  int maxPage = -1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadData(currentPage);
    super.initState();
  }

  void _loadData(int page) async {
    debugPrint('请求第$page页数据');
    var res = await Api.getRecentPosts(page: page);
    if (res['code'] == 0) {
      maxPage = res['data']['pagination']['paginationPageCount'];
      if (page == 1) {
        _refreshController.resetNoData();
        _refreshController.refreshCompleted();
      } else {
        if (page == maxPage) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      }
      setState(() {
        postList.addAll(res['data']['articles'].where((a) => postList.every((b) => a['oId'] != b['oId'])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IWPZTableView(
      enablePullDown: true,
      enablePullUp: true,
      refreshController: _refreshController,
      onRefresh: () {
        currentPage = 1;
        postList.clear();
        _loadData(currentPage);
      },
      onLoading: () {
        currentPage++;
        _loadData(currentPage);
      },
      rowCount: (indexPath) {
        return postList.length;
      },
      row: (indexPath) {
        return PostListItem(
          postItem: postList[indexPath.row!],
          onTap: (item) {
            NavigatorTool.push(context, page: PostDetailPage(item: item));
          },
        );
      },
    );
  }
}
