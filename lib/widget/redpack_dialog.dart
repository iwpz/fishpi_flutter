import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/tools/no_shadow_scroll_behavior.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:flutter/cupertino.dart';

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
      height: MediaQuery.of(context).size.height * 0.7,
      contentWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(imageUrl: info['userAvatarURL']),
                Text('${info['userName']} 的红包'),
              ],
            ),
          ),
          Text(info['msg']),
          Text(count == -27016 ? '你错过了这个红包' : '抢到了 $count 积分'),
          Text('总计 ${info['got']}/${info['count']}'),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoShadowScrollBehavior(),
              child: ListView.builder(
                itemCount: who.length,
                itemBuilder: (context, index) {
                  var people = who[index];
                  return Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CachedNetworkImage(imageUrl: people['avatar']),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(people['userName']),
                              Text(people['time']),
                            ],
                          ),
                        ),
                        people['userMoney'] == 0
                            ? Container(
                                width: 60,
                                child: Text('0溢事件'),
                              )
                            : Container(),
                        Text(people['userMoney'].toString()),
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
