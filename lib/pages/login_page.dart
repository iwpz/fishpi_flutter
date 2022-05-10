import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:fishpi_flutter/pages/index_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/sp_tool.dart';
import 'package:fishpi_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _twoStepController = TextEditingController();

  void _loginAction() async {
    var res = await Api.getKey(
      nameOrEmail: _userNameController.text,
      userPassword: StringTool.getMd5(_pwdController.text),
      twoStepCode:_twoStepController.text,
    );
    debugPrint(res);
    if (res['code'] == 0) {
      RequestManager.updateApiKey(res['Key']);
      debugPrint('缓存ApiKey:${res['Key']}');
      SPTool().setStorage('ApiKey', res['Key']);
      var ress = await Api.getUserInfo();
      if (ress['code'] == 0) {
        DataManager.myInfo = ress['data'];
        NavigatorTool.pushAndRemove(context, page: const IndexPage());
      }
    } else {
      Fluttertoast.showToast(msg: res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  const Text('用户名:'),
                  Expanded(
                    child: TextField(
                      controller: _userNameController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  const Text('密码:'),
                  Expanded(
                    child: TextField(
                      controller: _pwdController,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  const Text('两部认证码:'),
                  Expanded(
                    child: TextField(
                      controller: _twoStepController,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_userNameController.text.isEmpty) {
                    Fluttertoast.showToast(msg: '请输入用户名！');
                  } else if (_pwdController.text.isEmpty) {
                    Fluttertoast.showToast(msg: '请输入密码！');
                  } else {
                    _loginAction();
                  }
                },
                child: const Text('登录')),
          ],
        ),
      ),
    );
  }
}
