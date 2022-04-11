import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String title = '';
  String content = '';

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    var res = await Api.getUserInfo();
    print(res);
    if (res['code'] == 0) {
      setState(() {
        DataManager.myInfo = res['data'];
      });
      setState(() {
        title = DataManager.myInfo['userNickname'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: DataManager.myInfo['userNickname'],
        showBack: false,
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 128,
              width: 128,
              child: Image.network(DataManager.myInfo['userAvatarURL']),
            ),
            Text(
              DataManager.myInfo['userNickname'],
              style: TextStyle(fontSize: 20),
            ),
            Text(
              DataManager.myInfo['userName'],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
