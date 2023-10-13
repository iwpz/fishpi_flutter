import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:fishpi_flutter/pages/index_page.dart';
import 'package:fishpi_flutter/pages/reg_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/sp_tool.dart';
import 'package:fishpi_flutter/tools/string_tool.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
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
      twoStepCode: _twoStepController.text,
    );
    debugPrint(res.toString());
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
    return BasePage(
      backgroundColor: const Color(0xFF1F1F1F),
      scaleWithKeyboard: true,
      // resizeToAvoidBottomInset: true,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              SizedBox(
                // height: 200,
                child: Image.asset('assets/images/icon1024.png', height: 80, width: 80),
              ),
              const Text(
                '登录',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    // const SizedBox(width: 70, child: Text('用户名:', style: TextStyle(color: Colors.red))),
                    Expanded(
                      child: Container(
                        child: IWPZTextField(
                          backgroundColor: Colors.transparent,
                          hintText: '请输入用户名',
                          height: 40,
                          maxLines: 1,
                          contentPaddingValue: 0,
                          border: Border.all(color: Colors.white),
                          leftWidget: const Icon(Icons.account_circle, color: Colors.white),
                          // borderRadius: BorderRadius.circular(20),
                          style: const TextStyle(color: Colors.white),
                          controller: _userNameController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    // const  SizedBox(
                    //   width: 70,
                    //   child: Text('密码:',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       )),
                    // ),
                    Expanded(
                      child: IWPZTextField(
                        backgroundColor: Colors.transparent,
                        hintText: '请输入密码',
                        border: Border.all(color: Colors.white),
                        leftWidget: const Icon(Icons.lock, color: Colors.white),
                        // borderRadius: BorderRadius.circular(20),
                        style: const TextStyle(color: Colors.white),
                        isPassword: true,
                        controller: _pwdController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    // const  SizedBox(
                    //   width: 70,
                    //   child: Text('两步认证:',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       )),
                    // ),
                    Expanded(
                      child: IWPZTextField(
                        backgroundColor: Colors.transparent,
                        hintText: '请输入两步验证码',
                        maxLines: 1,
                        contentPaddingValue: 0,
                        keyboardType: TextInputType.number,
                        border: Border.all(color: Colors.white),
                        leftWidget: const Icon(Icons.shield, color: Colors.white),
                        // borderRadius: BorderRadius.circular(20),
                        style: const TextStyle(color: Colors.white),
                        isPassword: true,
                        controller: _twoStepController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (_userNameController.text.isEmpty) {
                        Fluttertoast.showToast(msg: '请输入用户名！');
                      } else if (_pwdController.text.isEmpty) {
                        Fluttertoast.showToast(msg: '请输入密码！');
                      } else {
                        _loginAction();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Text(
                        '登录',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  GestureDetector(
                    onTap: () {
                      NavigatorTool.push(context, page: const RegPage());
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Text(
                        '注册',
                        style: TextStyle(color: Color(0xFF1F1F1F)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
