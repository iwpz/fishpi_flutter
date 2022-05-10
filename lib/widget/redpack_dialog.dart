import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/tools/no_shadow_scroll_behavior.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:flutter/material.dart';

class RedpackDialog {
  static void show(BuildContext context, {var redPack}) {
    var info = redPack['info'];
    var who = redPack['who'];
    int count = -27016;
    for (int i = 0; i < who.length; i++) {
      if (who[i]['userName'] == DataManager.myInfo['userName']) {
        count = who[i]['userMoney'];
      }
    }
    IWPZDialog.show(
      context,
      title: '红包',
      showCancel: false,
      okColor: Colors.white,
      titleColor: Colors.white,
      backgroundColor: Colors.red,
      height: MediaQuery.of(context).size.height * 0.7,
      contentWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40, width: 40,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: NetworkImage(info['userAvatarURL'], scale: 1),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: info['userAvatarURL'],
                  //   height: 40,
                  //   width: 40,
                  // ),
                ),
                Text(
                  '${info['userName']} 的红包',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            info['msg'],
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            count == -27016 ? '你错过了这个红包' : '抢到了 $count 积分',
            style: count == -27016
                ? const TextStyle(
                    color: Colors.white,
                  )
                : const TextStyle(
                    fontSize: 26,
                    color: Colors.amberAccent,
                  ),
          ),
          Text(
            '总计 ${info['got']}/${info['count']}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoShadowScrollBehavior(),
              child: SizedBox(
                child: ListView.builder(
                  itemCount: who.length,
                  itemBuilder: (context, index) {
                    var people = who[index];
                    return Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFCECECE)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CachedNetworkImage(imageUrl: people['avatar']),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  people['userName'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  people['time'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          people['userMoney'] == 0
                              ? Container(
                                  width: 60,
                                  height: 20,
                                  margin: const EdgeInsets.only(right: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '0溢事件',
                                    style: TextStyle(color: Colors.green, fontSize: 12),
                                  ),
                                )
                              : Container(),
                          Text(
                            people['userMoney'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
