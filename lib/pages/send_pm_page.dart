import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SendPMPage extends StatefulWidget {
  final String userName;
  const SendPMPage({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<SendPMPage> createState() => _SendPMPageState();
}

class _SendPMPageState extends State<SendPMPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '发送私信',
        rightTitle: '发送',
        onRightTap: () async {
          if (titleController.text.isEmpty) {
            Fluttertoast.showToast(msg: '请输入主题');
            return;
          } else if (contentController.text.isEmpty) {
            Fluttertoast.showToast(msg: '请输入正文内容');
            return;
          }
          // var res =
              await Api.sendPM(userName: widget.userName, title: titleController.text, content: contentController.text);
          NavigatorTool.pop(context);
        },
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFCECECE))),
            ),
            child: IWPZTextField(
              hintText: '发送给:${widget.userName}',
              enabled: false,
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFCECECE))),
            ),
            child: IWPZTextField(
              hintText: '主题',
              controller: titleController,
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: IWPZTextField(
                  hintText: '正文',
                  controller: contentController,
                  maxLines: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
