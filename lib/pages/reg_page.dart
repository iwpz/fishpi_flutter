import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/config.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/tools/string_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegPage extends StatefulWidget {
  RegPage({Key? key}) : super(key: key);

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();
  String userId = '';
  String captchaImage = '';
  bool showQQLabel = false;
  int times = 0;

  String userPassword = '';
  int userAppRole = -1;
  bool isFinishRegister = false;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdSureController = TextEditingController();

  @override
  void initState() {
    _getCaptcha();
    super.initState();
  }

  void _getCaptcha() async {
    setState(() {
      captchaImage = AppConfig.baseUrl + '/captcha?times=$times';
      times++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xFF1F1F1F),
      appBar: const BaseAppBar(
        showBack: true,
        title: '',
        backgroundColor: Color(0xFF1F1F1F),
        showBottomShadow: false,
      ),
      // resizeToAvoidBottomInset: true,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: isFinishRegister
              ? Column(
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      child: Image.asset('assets/images/icon1024.png', height: 80, width: 80),
                    ),
                    Text(
                      '完成注册',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '黑客',
                            style: TextStyle(color: Colors.white),
                          ),
                          Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio(
                              activeColor: Colors.white,
                              groupValue: userAppRole,
                              value: 0,
                              onChanged: (int? value) {
                                setState(() {
                                  userAppRole = 0;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 40),
                          const Text(
                            '画家',
                            style: TextStyle(color: Colors.white),
                          ),
                          Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.white),
                            child: Radio(
                              activeColor: Colors.white,
                              groupValue: userAppRole,
                              value: 1,
                              onChanged: (int? value) {
                                setState(() {
                                  userAppRole = 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请输入密码',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.account_circle, color: Colors.white),
                              // borderRadius: BorderRadius.circular(20),
                              style: TextStyle(color: Colors.white),
                              isPassword: true,
                              controller: _pwdController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请确认一次',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.account_circle, color: Colors.white),
                              style: TextStyle(color: Colors.white),
                              isPassword: true,
                              controller: _pwdSureController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (_pwdController.text != _pwdSureController.text) {
                          Fluttertoast.showToast(msg: '密码不一致哦~');
                          return;
                        }

                        var res = await Api.finishRegister(
                          userAppRole: userAppRole,
                          userPassword: StringTool.getMd5(_pwdController.text),
                          userId: userId,
                        );
                        if (res['code'] == 0) {
                          Fluttertoast.showToast(msg: '注册成功！');
                          NavigatorTool.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: res['msg']);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          '完成注册',
                          style: TextStyle(color: Color(0xFF1F1F1F)),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      child: Image.asset('assets/images/icon1024.png', height: 80, width: 80),
                    ),
                    Text(
                      '注册',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请输入用户名',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.account_circle, color: Colors.white),
                              // borderRadius: BorderRadius.circular(20),
                              style: TextStyle(color: Colors.white),
                              controller: _userNameController,
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
                          // const SizedBox(
                          //   width: 70,
                          //   child: Text('密码:',
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //       )),
                          // ),
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请输入手机号码',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.phone_android, color: Colors.white),
                              // borderRadius: BorderRadius.circular(20),
                              style: TextStyle(color: Colors.white),
                              controller: phoneNumberController,
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
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请输入验证码',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.code_sharp, color: Colors.white),
                              style: TextStyle(color: Colors.white),
                              controller: _captchaController,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                captchaImage = '';
                                Future.delayed(const Duration(milliseconds: 50), () {
                                  _getCaptcha();
                                });
                              });
                            },
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(left: 10),
                              child: captchaImage.isEmpty ? Container() : Image.network(captchaImage, fit: BoxFit.fill),
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
                          Expanded(
                            child: IWPZTextField(
                              backgroundColor: Colors.transparent,
                              hintText: '请输入短信验证码',
                              border: Border.all(color: Colors.white),
                              leftWidget: Icon(Icons.code_sharp, color: Colors.white),
                              style: TextStyle(color: Colors.white),
                              controller: _verifyCodeController,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_userNameController.text.isEmpty) {
                                Fluttertoast.showToast(msg: '请输入用户名!');
                                return;
                              }
                              if (phoneNumberController.text.isEmpty) {
                                Fluttertoast.showToast(msg: '请输入手机号码!');
                                return;
                              }
                              if (_captchaController.text.isEmpty) {
                                Fluttertoast.showToast(msg: '请输入验证码!');
                                return;
                              }
                              var res = await Api.register(
                                  userName: _userNameController.text,
                                  phoneNumber: phoneNumberController.text,
                                  captcha: _captchaController.text);
                              if (res['code'] != null && res['code'] == 0) {
                                setState(() {
                                  showQQLabel = true;
                                });
                              }
                              Fluttertoast.showToast(msg: res['msg']);
                            },
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                '获取验证码',
                                style: TextStyle(color: Colors.white),
                              ),
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
                            var res = await Api.checkVerifyCode(_verifyCodeController.text);
                            if (res['code'] == 0) {
                              userId = res['userId'];
                              setState(() {
                                isFinishRegister = true;
                              });
                            } else {
                              Fluttertoast.showToast(msg: res['msg']);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                            ),
                            child: Text(
                              '注册',
                              style: TextStyle(color: Color(0xFF1F1F1F)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    showQQLabel
                        ? Text(
                            '验证码已发送，请查收。如果您未收到短信，请联系QQ/微信：1101635162',
                            style: TextStyle(color: Colors.white),
                          )
                        : Container(),
                  ],
                ),
        ),
      ),
    );
  }
}
