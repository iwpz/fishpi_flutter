import 'dart:convert';

import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/pages/setting_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/medal_widget.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  String title = '';
  String content = '';
  List medalList = [];

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    var res = await Api.getUserInfo();
    if (res['code'] == 0) {
      setState(() {
        DataManager.myInfo = res['data'];
        /*
        {"msg":"","code":0,"data":
        {"userCity":"大连","userOnlineFlag":true,"userPoint":8971,"userAppRole":"0","userIntro":"","userNo":"1809",
        "onlineMinute":57597,"userAvatarURL":"https://pwl.stackoverflow.wiki/2021/12/blob-0b83b50c.png",
        "userNickname":"和平哥","oId":"1637917131504","userName":"iwpz","cardBg":"","followingUserCount":0,"sysMetal":
        "{\"list\":[{\"data\":\"\",\"name\":\"摸鱼派粉丝\",\"description\":\"捐助摸鱼派达16RMB\",\"attr\":\"url=https://pwl.stackoverflow.wiki/2021/12/ht1-d8149de4.jpg&backcolor=ffffff&
flutter: fontcolor=ff3030\",\"enabled\":true},{\"data\":\"\",\"name\":\"开发\",\"description\":\"摸鱼派官方开发组成员\",\"attr\":\"url=https://pwl.stackoverflow.wiki/2021/12/metaldev-db507262.png&backcolor=483d8b&fontcolor=f8f8ff\",\"enabled\":true},{\"data\":\"\",\"name\":\"纪律委员\",\"description\":\"摸鱼派管理组成员\",\"attr\":\"url=https://pwl.stackoverflow.wiki/2021/12/011shield-46ce360b.jpg&backcolor=2568ff&fontcolor=ffffff\",\"enabled\":true}]}",
"userRole":"纪律委员","followerCount":0,"userURL":""}}
         */
        debugPrint('check data:');
        debugPrint(DataManager.myInfo.toString());
        medalList = json.decode(DataManager.myInfo['sysMetal'].toString())['list'];
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
        rightWidget: GestureDetector(
          onTap: () {
            NavigatorTool.push(context, page: SettingPage());
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.settings),
          ),
        ),
        showBack: false,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 6),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              // color: Colors.white,
              image: DecorationImage(image: NetworkImage(DataManager.myInfo['cardBg']), fit: BoxFit.fill),
              boxShadow: [
                GlobalStyle.bottomShadow,
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.width / 2 / 7 * 3,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(92, 214, 227, 235),
                          Color.fromARGB(194, 255, 255, 255),
                          Color.fromARGB(194, 255, 255, 255)
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width / 2 / 8 * 3,
                  left: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(width: 20),
                      Column(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.network(DataManager.myInfo['userAvatarURL']),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              DataManager.myInfo['userRole'] == '纪律委员'
                                  ? SizedBox(
                                      height: 20,
                                      width: 64,
                                      // margin: const EdgeInsets.only(top: 10),
                                      child: Image.network('https://pwl.stackoverflow.wiki/policeRole.png'),
                                    )
                                  : DataManager.myInfo['userRole'] == '管理员'
                                      ? SizedBox(
                                          height: 20,
                                          width: 64,
                                          // margin: const EdgeInsets.only(top: 10),
                                          child: Image.network('https://pwl.stackoverflow.wiki/adminRole.png'),
                                        )
                                      : Container(),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, top: MediaQuery.of(context).size.width / 2 / 7 * 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DataManager.myInfo['userNickname'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      DataManager.myInfo['userName'],
                                      style: const TextStyle(fontSize: 14, color: Color.fromARGB(138, 00, 00, 0)),
                                    ),
                                    // const SizedBox(height: 10),
                                  ],
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '''摸鱼派 ${DataManager.myInfo['userNo']} 号成员, ${DataManager.myInfo['userAppRole'] == 0 ? '黑客' : '画家'} 积分 ${DataManager.myInfo['userPoint']}
在线时间：${DataManager.myInfo['onlineMinute']}分钟   位置：${DataManager.myInfo['userCity']}
                            ''',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(138, 00, 00, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text(
              '徽章：',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              // alignment: WrapAlignment.start,
              // runAlignment: WrapAlignment.start,
              // crossAxisAlignment: WrapCrossAlignment.center,
              // spacing: 5,
              // runSpacing: 5,
              children: List.generate(
                medalList.length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 40,
                    child: Row(
                      children: [
                        MedalWidget(medal: medalList[index]),
                        Text(
                          medalList[index]['description'],
                          style: const TextStyle(color: Color(0xFFCCCCCC)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
