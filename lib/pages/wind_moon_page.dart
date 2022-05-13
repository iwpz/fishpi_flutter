import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:fishpi_flutter/widget/iwpz_tableview.dart';
import 'package:fishpi_flutter/widget/wind_moon_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WindMoonPage extends StatefulWidget {
  const WindMoonPage({Key? key}) : super(key: key);

  @override
  State<WindMoonPage> createState() => _WindMoonPageState();
}

class _WindMoonPageState extends State<WindMoonPage> {
  List dataList = List.empty(growable: true);
  final TextEditingController _inputController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  int currentIndex = 1;
  int pageSize = 10;
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    var res = await Api.getWindMoonList(page: currentIndex, pageSize: pageSize);
    if (res['code'] == 0) {
      setState(() {
        if (currentIndex == 1) {
          dataList.clear();
        }
        currentIndex++;
        dataList.addAll(res['breezemoons']);
        if (res['breezemoons'].length == 0) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      });
    }
  }

  void _refreshData() async {
    currentIndex = 1;
    dataList.clear();
    _refreshController.resetNoData();
    var res = await Api.getWindMoonList(page: currentIndex, pageSize: pageSize);
    if (res['code'] == 0) {
      setState(() {
        dataList.addAll(res['breezemoons']);
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        showBack: false,
        title: '清风明月',
        backgroundColor: GlobalStyle.mainThemeColor,
        rightWidget: GestureDetector(
          onTap: () {
            IWPZDialog.show(
              context,
              title: '发送清风明月',
              height: 230,
              showCancel: true,
              contentWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('内容：'),
                  TextField(
                    controller: _inputController,
                  ),
                ],
              ),
              onOKTap: () async {
                if (_inputController.text.isEmpty) {
                  Fluttertoast.showToast(msg: '请输入内容!');
                } else {
                  var res = await Api.sendWindMoon(_inputController.text);
                  if (res['code'] == 0) {
                    _inputController.text = '';
                    _refreshData();
                  } else {
                    Fluttertoast.showToast(msg: res['msg']);
                  }
                }
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.mode_edit_outlined),
          ),
        ),
      ),
      child: IWPZTableView(
        sectionCount: 1,
        rowCount: (section) {
          return dataList.length;
        },
        refreshController: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () {
          _refreshData();
        },
        onLoading: () {
          _loadData();
        },
        row: (indexPath) {
          return WindMoonItem(
            data: dataList[indexPath.row!],
          );
        },
      ),
    );
  }
}
