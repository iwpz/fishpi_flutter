import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/liveness_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:fishpi_flutter/pages/about_page.dart';
import 'package:fishpi_flutter/pages/black_list_page.dart';
import 'package:fishpi_flutter/pages/privacy_page.dart';
import 'package:fishpi_flutter/pages/setting_item.dart';
import 'package:fishpi_flutter/pages/splash_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/sp_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:fishpi_flutter/widget/iwpz_tableview.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '设置',
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      child: IWPZTableView(
        rowCount: (section) {
          return 4;
        },
        row: (indexPath) {
          if (indexPath.row == 0) {
            return SettingItem(
              title: '屏蔽列表',
              onTap: () {
                NavigatorTool.push(context, page: BlackListPage());
              },
            );
          } else if (indexPath.row == 1) {
            return SettingItem(
              title: '隐私政策',
              onTap: () {
                NavigatorTool.push(context, page: PrivcyPage());
              },
            );
          } else if (indexPath.row == 2) {
            return SettingItem(
              title: '关于',
              onTap: () {
                NavigatorTool.push(context, page: AboutPage());
              },
            );
          } else if (indexPath.row == 3) {
            BuildContext ctx = context;
            return SettingItem(
              title: '退出登录',
              onTap: () {
                IWPZDialog.show(
                  context,
                  title: '提示',
                  content: '确定退出登录吗？',
                  showCancel: true,
                  onOKTap: () {
                    RequestManager.updateApiKey("");
                    ChatRoomMessageManager.unlistenNewMessage();
                    LivenessManager.stopUpdateLiveness();
                    SPTool().removeStorage('ApiKey');
                    NavigatorTool.pop(context);
                    Future.delayed(const Duration(milliseconds: 50), () {
                      NavigatorTool.push(ctx, page: const SplashPage());
                    });
                  },
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
