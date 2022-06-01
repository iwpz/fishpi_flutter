import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivcyPage extends StatefulWidget {
  PrivcyPage({Key? key}) : super(key: key);

  @override
  State<PrivcyPage> createState() => _PrivcyPageState();
}

class _PrivcyPageState extends State<PrivcyPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: const BaseAppBar(
        title: '隐私政策',
      ),
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.tryParse('https://fishpi.cn/privacy')),
      ),
    );
  }
}
