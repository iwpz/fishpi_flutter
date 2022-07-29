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
    // _getPrivateMessage();
    super.initState();
  }

  void _getPrivateMessage() async {
    /*
    {"code":0,"data":{"meReceived":[{"fromUserName":"Yui","toUserAvatar":"https://pwl.stackoverflow.wiki/2021/12/blob-0b83b50c.png","fromUserId":"1630488635229","toUserName":"iwpz","theme":"test","mapId":"1653900224302","fromUserAvatar":"https://pwl.stackoverflow.wiki/2022/02/blob-d135095b.png","toUserId":"1637917131504","content":":huaji:\n"}],"meSent":[]}}
     */
    var res = await Api.getPrivateMessage();
    if (res['code'] == 0) {
      setState(() {
        DataManager.receivePrivateMessageList = res['data']['meReceived'];
        DataManager.sendPrivateMessageList = res['data']['meSent'];
      });
    }
  }

  void _getUserInfo() async {
    var res = await Api.getUserInfo();
    if (res['code'] == 0) {
      setState(() {
        DataManager.myInfo = res['data'];
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
        backgroundColor: GlobalStyle.mainThemeColor,
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
            // padding: const EdgeInsets.only(top: MediaQuery.of(context).size.width / 6),
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
                      // const SizedBox(width: 20),
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
                                      child: Image.network('https://pwl.stackoverflow.wiki/policeRole.png'),
                                    )
                                  : DataManager.myInfo['userRole'] == '管理员'
                                      ? SizedBox(
                                          height: 20,
                                          width: 64,
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
                                    // const  SizedBox(height: 10),
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
          DataManager.receivePrivateMessageList.isNotEmpty || DataManager.sendPrivateMessageList.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    '私信：',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Container(),
          DataManager.receivePrivateMessageList.isNotEmpty || DataManager.sendPrivateMessageList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataManager.receivePrivateMessageList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(left: 30),
                            child: const Text(
                              '收到的私信：',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        : Container(),
                    DataManager.receivePrivateMessageList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(left: 40),
                            alignment: Alignment.centerLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(DataManager.receivePrivateMessageList.length, (index) {
                                  var revPM = DataManager.receivePrivateMessageList[index];
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFCECECE),
                                      )),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Text('来自：'),
                                                  Image.network(
                                                    revPM['fromUserAvatar'],
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text('${revPM['fromUserName']}'),
                                                  const SizedBox(width: 10),
                                                  Text('主题：${revPM['theme']}'),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: Text('正文：${revPM['content']}'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            var res = await Api.markPMReaded(revPM['mapId']);
                                            if (res['code'] == 0) {
                                              _getPrivateMessage();
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 16),
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                              color: GlobalStyle.mainThemeColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text('已读',
                                                style: TextStyle(
                                                  color: Color(0xFFd23f31),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                          )
                        : Container(),
                    DataManager.sendPrivateMessageList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(left: 30),
                            child: const Text(
                              '发出的私信：',
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        : Container(),
                    DataManager.sendPrivateMessageList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(left: 40),
                            alignment: Alignment.centerLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(DataManager.sendPrivateMessageList.length, (index) {
                                  var revPM = DataManager.sendPrivateMessageList[index];
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                        width: 1,
                                        color: Color(0xFFCECECE),
                                      )),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Text('发送给：'),
                                                  Image.network(
                                                    revPM['toUserAvatar'],
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text('${revPM['toUserName']}'),
                                                  const SizedBox(width: 10),
                                                  Text('主题：${revPM['theme']}'),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: Text('正文：${revPM['content']}'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            var res = await Api.revokePM(revPM['mapId']);
                                            if (res['code'] == 0) {
                                              _getPrivateMessage();
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 16),
                                            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                              color: GlobalStyle.mainThemeColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text('撤回',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                          )
                        : Container()
                  ],
                )
              : Container(),
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
