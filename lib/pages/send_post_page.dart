import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SendPostPage extends StatefulWidget {
  SendPostPage({Key? key}) : super(key: key);

  @override
  State<SendPostPage> createState() => _SendPostPageState();
}

class _SendPostPageState extends State<SendPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: '发帖',
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.tryParse('https://fishpi.cn/pre-post')),
      ),
    );
  }
}
