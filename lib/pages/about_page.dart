import 'dart:io';

import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    // TODO: implement initState
    _getVersionInfo();
    super.initState();
  }

  String version = '';

  _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.appName);
    //APP名称
    String appName = packageInfo.appName;
    //包名
    String packageName = packageInfo.packageName;
    //版本名
    setState(() {
      version = packageInfo.version;
    });
    //版本号
    String buildNumber = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: const BaseAppBar(
          title: '关于',
        ),
        child: Column(
          children: [
        const  SizedBox(height: 32),
        SizedBox(
          // height: 200,
          child: Image.asset('assets/images/icon1024.png', height: 80, width: 80),
        ),
        const  SizedBox(height: 32),
        Text(
          '摸鱼派${Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : ''} $version',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const  SizedBox(height: 20),
        const Text('By:iwpz'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('官方网站：'),
            GestureDetector(
              onTap: () async {
                var uri = Uri(path: 'https://fishpi.cn/');
                if (await canLaunchUrl(uri)) {
                  launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text(
                'https://fispi.cn/',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
          ],
        ));
  }
}
