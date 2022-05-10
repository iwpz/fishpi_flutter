import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:fishpi_flutter/pages/index_page.dart';
import 'package:fishpi_flutter/pages/login_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/sp_tool.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    RequestManager.init();

    debugPrint('check login status');
    _checkLoginStatus();
    super.initState();
  }

  void _checkLoginStatus() async {
    debugPrint('准备获取storage');
    String apiKey = await SPTool().getStorage('ApiKey') ?? '';

    debugPrint('获取APIkey：');
    debugPrint(apiKey);
    if (apiKey.isEmpty) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        NavigatorTool.push(context, page: const LoginPage());
      });
    } else {
      RequestManager.updateApiKey(apiKey);
      debugPrint('API KEY not null');
      var res = await Api.getUserInfo();

      if (res['code'] == 0) {
        DataManager.myInfo = res['data'];
        NavigatorTool.pushAndRemove(context, page: const IndexPage());
      } else {
        Fluttertoast.showToast(msg: res['msg']);
        SPTool().removeStorage('ApiKey');
        NavigatorTool.push(context, page: const LoginPage());
      }
      debugPrint(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('myp'),
      ),
    );
  }
}
