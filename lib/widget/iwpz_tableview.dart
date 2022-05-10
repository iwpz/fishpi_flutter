import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef TableRowItem = Widget Function(TableIndexPath indexPath);

typedef TableRowCount = int Function(int section);
typedef TableSectionItem = Widget Function(int section, bool? isSpreads);
typedef OnTableSectionSpread = Function(int section, bool? isSpreads);
typedef TableSectionSpread = bool Function(int section);
typedef TableSectionFooter = Widget Function(int section);
typedef TableHeaderItem = Widget Function();
typedef TableFooterItem = Widget Function();
typedef TableBuildContext = Function(BuildContext context);
typedef TableViewDidSelect = Function(TableIndexPath indexPath);

class IWPZTableView extends StatefulWidget {
  /// 当前控件高度
  final double? height;

  /// 当前控件宽度
  final double? width;

  /// 背景颜色
  final Color? backgroundColor;

  /// 下划线颜色
  final Color? lineColor;

  /// 下划线Padding
  final EdgeInsets? linePadding;

  /// 滑动控制器
  final ScrollController? controller;

  /// section是否自动展开收起(默认false)
  final bool? autoSpread;

  /// List的section的数量
  final int sectionCount;

  /// 当前section对应的row的数量
  final TableRowCount? rowCount;

  /// 当前row对应的item
  final TableRowItem? row;

  /// 当前section对应的item
  final TableSectionItem? sectionHeader;

  /// 当前section对应的footer
  final TableSectionFooter? sectionFooter;

  /// 当前section的展开状态(默认true)
  final TableSectionSpread? sectionSpread;

  final OnTableSectionSpread? onSectionSpread;

  /// header
  final TableHeaderItem? header;

  /// footer
  final TableFooterItem? footer;

  /// 当前buildContext(手动刷新时使用)
  final TableBuildContext? buildContext;

  final bool? shrinkWrap;

  ///用于集成KeyboardActions控件
  ///如果Table中含有textField类型控件，将文本框node传入nodeList即可。
  final List<FocusNode>? nodeList;

  ///KeyboardActions额外向上滚动高度
  ///用于显示文本框下方文字说明
  final double? overscroll;

  /// 下拉刷新，上拉加载更多 控制器
  final RefreshController? refreshController;

  /// 启用下拉刷新
  final bool? enablePullDown;

  /// 启用上拉加载更多
  final bool? enablePullUp;

  /// 加载更多回调
  final VoidCallback? onLoading;

  /// 下拉刷新回调
  final VoidCallback? onRefresh;
  final TableViewDidSelect? cellOnTap;

  /// 滚动方式
  final ScrollPhysics? physics;

  ///是否隐藏row对应的item分割线,默认为false
  final bool hideLine;

  /// 最后一行是否隐藏分割线
  final bool showLastLine;

  const IWPZTableView({
    Key? key,
    this.height,
    this.width,
    this.backgroundColor = Colors.transparent,
    this.controller,
    this.autoSpread = false,
    this.sectionCount = 1,
    this.rowCount,
    this.row,
    this.sectionHeader,
    this.sectionFooter,
    this.sectionSpread,
    this.onSectionSpread,
    this.header,
    this.footer,
    this.buildContext,
    this.lineColor = const Color(0xFFE6E6E6),
    this.linePadding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.nodeList,
    this.overscroll = 0,
    this.refreshController,
    this.enablePullDown = false,
    this.enablePullUp = false,
    this.onLoading,
    this.onRefresh,
    this.cellOnTap,
    this.physics,
    this.hideLine = false,
    this.showLastLine = false,
  })  : assert(rowCount != null, '需要通过rowCount来设置当前section的row的数量，不能为空'),
        super(key: key);

  @override
  _IWPZTableViewState createState() => _IWPZTableViewState();

  static _IWPZTableViewState of(BuildContext context) {
    return context.findAncestorStateOfType<_IWPZTableViewState>()!;
  }
}

class _IWPZTableViewState extends State<IWPZTableView> {
  /// 记录坐标数组
  List<TableIndexPath>? indexPaths;

  /// 记录展开状态数组
  List<bool> isSpreads = List.empty(growable: true);

  /// 用于校验数组
  List<int> rows = List.empty(growable: true);

  /// 是否是内部自动展开
  bool spread = false;

  @override
  void initState() {
    super.initState();

    // 初始化rows数组
    compareReload();
    // 创建indexPath的数组
    setUpIndexPaths();
  }

  /// 手动刷新列表
  reload() {
    setState(() {
      compareReload();
      setUpIndexPaths();
    });
  }

  // 判断是否需要整体刷新数据
  bool compareReload() {
    // 是否要刷新数据
    bool reload = false;
    // 是否要初始化数组
    bool initList = false;

    // 获取section的数量
    int sections = widget.sectionCount;
    if (rows.length != sections) {
      rows = List.empty(growable: true);
      initList = true;
    }
    reload = initList;

    for (int i = 0; i < sections; i++) {
      // 获取每个section对应的row的数量
      int rowNum = widget.rowCount!(i);
      if (initList) {
        rows.add(rowNum);
      } else {
        if (rows[i] != rowNum) {
          rows[i] = rowNum;
          reload = true;
        }
      }
    }
    return reload;
  }

  /// 设置坐标数组
  setUpIndexPaths() {
    // 初始化展开列表数组/indexPaths数组
    if (!spread) {
      isSpreads = List.empty(growable: true);
      spread = false;
    }
    indexPaths = List.empty(growable: true);

    // 添加header
    if (widget.header != null) {
      TableIndexPath sectionIndexPath = TableIndexPath(section: 0, row: 0, type: TableItemType.header);
      indexPaths!.add(sectionIndexPath);
    }

    // 判断是否缓存了展开状态数据
    bool isNull = isSpreads.isEmpty;

    for (int i = 0; i < rows.length; i++) {
      // 添加section对应的indexPath
      TableIndexPath sectionIndexPath = TableIndexPath(section: i, row: 0, type: TableItemType.sectionHeader);
      indexPaths!.add(sectionIndexPath);

      // 获取当前section是否是展开状态,如果不展开，不添加对应的rowItems
      bool isSpread = widget.sectionSpread == null ? true : widget.sectionSpread!(i);
      if (widget.autoSpread == true) isNull ? isSpreads.add(isSpread) : isSpread = isSpreads[i];

      if (isSpread != true) continue;
      for (int j = 0; j <= rows[i]; j++) {
        // 添加row对应的indexPath
        TableIndexPath rowIndexPath = TableIndexPath(
          section: i,
          row: j,
          type: j == rows[i] ? TableItemType.sectionFooter : TableItemType.row,
        );
        indexPaths!.add(rowIndexPath);
      }
    }

    // 添加footer
    if (widget.footer != null) {
      TableIndexPath sectionIndexPath = TableIndexPath(section: 0, row: 0, type: TableItemType.footer);
      indexPaths!.add(sectionIndexPath);
    }
  }

  ///初始化Table主List
  Widget _setUpTableList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      shrinkWrap: widget.shrinkWrap!,
      physics: widget.physics,
      controller: widget.controller,
      itemCount: indexPaths!.length,
      itemBuilder: (context, index) {
        // 获取到当前item对应的indexPath
        TableIndexPath currentIndexPath = indexPaths![index];
        // 根据indexPath的row属性来判断section/row/header/footer
        switch (currentIndexPath.type) {
          case TableItemType.sectionHeader:
            return GestureDetector(
              onTap: () {
                debugPrint('call on tap!!!');
                // 判断是否自动展开
                // if (widget.autoSpread != true) return;
                // 判断展开记录状态
                bool currentState = isSpreads[currentIndexPath.section!];
                // 修改对应展开状态
                if (widget.onSectionSpread != null) {
                  debugPrint('call onspreads');
                  widget.onSectionSpread!(currentIndexPath.section!, !isSpreads[currentIndexPath.section!]);
                }
                isSpreads[currentIndexPath.section!] = !currentState;

                spread = true;
                setState(() {
                  // 重新生成坐标数组
                  setUpIndexPaths();
                });
              },
              // 如果没有设置section对应的widget，默认SizedBox()占位
              child: widget.sectionHeader == null
                  ? const SizedBox()
                  : widget.sectionHeader!(
                      currentIndexPath.section!, (isSpreads.isNotEmpty ? isSpreads[currentIndexPath.section!] : false)),
            );
          case TableItemType.sectionFooter:
            return widget.sectionFooter == null ? const SizedBox() : widget.sectionFooter!(currentIndexPath.section!);
          case TableItemType.header:
            return widget.header == null ? const SizedBox() : widget.header!();
          case TableItemType.footer:
            return widget.footer == null ? const SizedBox() : widget.footer!();
          default:
            final rowCount = widget.rowCount!(currentIndexPath.section!);
            final isLast = currentIndexPath.row == rowCount - 1;
            return GestureDetector(
              onTap: () {
                if (widget.cellOnTap != null) {
                  widget.cellOnTap!(currentIndexPath);
                }
              },
              child: Column(
                children: <Widget>[
                  widget.row!(currentIndexPath),
                  widget.showLastLine ? showLastLine() : hiddenLine(isLast),
                ],
              ),
            );
        }
      },
    );
  }

  Widget showLastLine() {
    return Padding(
      padding: widget.linePadding!,
      child: Container(
        color: widget.lineColor,
        height: 0.5,
      ),
    );
  }

  Widget hiddenLine(bool isLast) {
    return isLast || widget.hideLine
        ? const SizedBox()
        : Container(
            color: widget.backgroundColor,
            padding: widget.linePadding,
            child: Container(
              color: widget.lineColor,
              height: 1,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    // 如果没有设置宽高,会自动填满
    double height = widget.height == null ? MediaQuery.of(context).size.height : widget.height!;
    double width = widget.width == null ? MediaQuery.of(context).size.width : widget.width!;

    if (compareReload()) {
      // 设置每个item对应的indexPath
      setUpIndexPaths();
    }

    Widget listView;
    if (widget.refreshController != null) {
      /// 如果未传入refreshController，则常规创建table，否则用SmartRefresher包裹List
      listView = SmartRefresher(
        controller: widget.refreshController!,
        enablePullDown: widget.enablePullDown!,
        enablePullUp: widget.enablePullUp!,
        onLoading: widget.onLoading,
        onRefresh: widget.onRefresh,
        child: _setUpTableList(),
        header: CustomHeader(builder: (BuildContext context, RefreshStatus? mode) {
          return SizedBox(
            height: 55.0,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CupertinoActivityIndicator(),
                  SizedBox(width: 6),
                  Text("重新加载"),
                ],
              ),
            ),
          );
        }),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const SizedBox();
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text(
                "加载失败",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              );
            } else if (mode == LoadStatus.canLoading) {
              body = const CupertinoActivityIndicator();
            } else {
              body = const Text(
                "没有更多了",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              );
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
      );
    } else {
      listView = _setUpTableList();
    }

    return Builder(
      builder: (context) {
        // 将列表的context传递出去(手动刷新时使用)
        if (widget.buildContext != null) widget.buildContext!(context);
        return Container(
          alignment: Alignment.topCenter,
          width: width,
          height: height,
          color: widget.backgroundColor,
          child: listView,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// 记录坐标类
class TableIndexPath {
  /// 组
  int? section;

  /// 行
  int? row;

  /// 组/行高
  double? height;

  /// item类型
  TableItemType? type;

  TableIndexPath({
    Key key = const Key('TableIndexPath'),
    this.section,
    this.row,
    this.height,
    this.type,
  });
}

/// item的type类型
enum TableItemType {
  header,
  footer,
  sectionHeader,
  sectionFooter,
  row,
}
