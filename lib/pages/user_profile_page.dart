import 'dart:convert';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/medal_widget.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final userProfile;
  const UserProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String title = '';
  String content = '';
  List medalList = [];

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() {
    setState(() {
      try {
        medalList = json.decode(widget.userProfile['sysMetal'].toString())['list'];
      } catch (ex) {
        medalList = [];
      }
      title = widget.userProfile['userNickname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: widget.userProfile['userNickname'],
        showBack: true,
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
              image: DecorationImage(image: NetworkImage(widget.userProfile['cardBg']), fit: BoxFit.fill),
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
                            child: Image.network(widget.userProfile['userAvatarURL']),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              widget.userProfile['userRole'] == '纪律委员'
                                  ? SizedBox(
                                      height: 20,
                                      width: 64,
                                      child: Image.network('https://pwl.stackoverflow.wiki/policeRole.png'),
                                    )
                                  : widget.userProfile['userRole'] == '管理员'
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
                                      widget.userProfile['userNickname'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.userProfile['userName'],
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
                                '''摸鱼派 ${widget.userProfile['userNo']} 号成员, ${widget.userProfile['userAppRole'] == 0 ? '黑客' : '画家'} 积分 ${widget.userProfile['userPoint']}
在线时间：${widget.userProfile['onlineMinute']}分钟   位置：${widget.userProfile['userCity']}
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
