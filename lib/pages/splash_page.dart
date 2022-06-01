import 'dart:io';

import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:fishpi_flutter/pages/index_page.dart';
import 'package:fishpi_flutter/pages/login_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/sp_tool.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _getVersionInfo().then((void _) {
      RequestManager.init();

      debugPrint('check login status');
      _checkLoginStatus();
    });
    super.initState();
  }

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isIOS) {
      DataManager.userAgent =
          'Mozilla/5.0 (iPhone; CPU iPhone OS 15_3_1 like Mac OS X) FishPiFlutter/${packageInfo.version} AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Mobile/15E148 Safari/604.1';
    } else if (Platform.isAndroid) {
      DataManager.userAgent =
          'Mozilla/5.0 (Linux; Android 11; ) FishPiFlutter/${packageInfo.version} AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Mobile Safari/537.36';
    } else {
      DataManager.userAgent =
          'Mozilla/5.0 (Windows NT 10.0; WOW64) FishPiFlutter/NEVER AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36';
    }
  }

  void _checkLoginStatus() async {
    debugPrint('准备获取storage');
    String apiKey = await SPTool().getStorage('ApiKey') ?? '';

    debugPrint('获取APIkey：');
    debugPrint(apiKey);
    if (apiKey.isEmpty) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        NavigatorTool.pushAndRemove(context, page: const LoginPage());
      });
    } else {
      RequestManager.updateApiKey(apiKey);
      debugPrint('API KEY not null');
      var res = await Api.getUserInfo();

      if (res['code'] == 0) {
        DataManager.myInfo = res['data'];
        Future.delayed(const Duration(milliseconds: 1000), () {
          NavigatorTool.pushAndRemove(context, page: const IndexPage());
        });
      } else {
        Fluttertoast.showToast(msg: res['msg']);
        SPTool().removeStorage('ApiKey');
        NavigatorTool.pushAndRemove(context, page: const LoginPage());
      }
      debugPrint(res.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('assets/images/icon1024.png', height: 80, width: 80),
            ),
            const SizedBox(height: 32),
            const Text('欢迎来到摸鱼派'),
          ],
        ),
      ),
    );
  }
}
