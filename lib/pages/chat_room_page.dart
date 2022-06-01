import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:fishpi_flutter/pages/chat_message_cell.dart';
import 'package:fishpi_flutter/pages/user_profile_page.dart';
import 'package:fishpi_flutter/style/global_style.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:fishpi_flutter/widget/iwpz_tableview.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
import 'package:fishpi_flutter/widget/redpack_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> with WidgetsBindingObserver {
  int onlineCount = 0;
  List onlineUsers = [];
  Map specifyChoosedUsers = {};
  String currentDiscussing = '';
  int specifyRedPackCount = 0;
  bool isGettingOldMessage = false;
  int historyMessagePage = 1;
  ScrollController chatScrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  final TextEditingController _redPacketScoreController = TextEditingController();
  late String _redPacketTotalScore = '32';
  final TextEditingController _redPacketCountController = TextEditingController();
  final TextEditingController _redPacketMessageController = TextEditingController();

  final TextEditingController _textInputController = TextEditingController();
  final FocusNode _textInputNode = FocusNode();
  // final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  String redpackType = 'random';
  int rockPackType = 0;
  late StreamSubscription messageStream;
  late StreamSubscription historyStream;
  double refreshSavedOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    messageStream = eventBus.on<OnChatMessageUpdate>().listen((event) {
      var theMessage = event.message;
      if (theMessage['type'] == 'online') {
        setState(() {
          onlineCount = DataManager.chatRoomOnLineInfo['onlineChatCnt'];
          currentDiscussing = DataManager.chatRoomOnLineInfo['discussing'];
          onlineUsers = DataManager.chatRoomOnLineInfo['users'];
        });
      }
      print('聊天列表页更新消息：');
      bool needToBottom = false;
      if (chatScrollController.position.maxScrollExtent - chatScrollController.offset <= 100) {
        needToBottom = true;
      }
      setState(() {
        ChatRoomMessageManager.intForUpdateUI++;
      });
      if (needToBottom) {
        Future.delayed(const Duration(milliseconds: 100), () {
          chatScrollController.animateTo(chatScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 50), curve: Curves.bounceIn);
        });
      }
    });

    historyStream = eventBus.on<OnHistoryMessageLoaded>().listen((event) {
      refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          ChatRoomMessageManager.intForUpdateUI++;
        });
        // double spanOffset = chatScrollController.position.maxScrollExtent - refreshSavedOffset;
        // Future.delayed(const Duration(milliseconds: 50), () {
        //   chatScrollController.jumpTo(spanOffset);
        // });
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        onlineCount = DataManager.chatRoomOnLineInfo['onlineChatCnt'];
        currentDiscussing = DataManager.chatRoomOnLineInfo['discussing'];
        onlineUsers = DataManager.chatRoomOnLineInfo['users'];
      });
      chatScrollController.animateTo(chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50), curve: Curves.bounceIn);
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          /// 键盘收回
        } else {
          Future.delayed(const Duration(milliseconds: 100), () {
            chatScrollController.animateTo(chatScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 50), curve: Curves.bounceIn);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    historyStream.cancel();
    messageStream.cancel();
    super.dispose();
  }

  void _onRedPackSelect() async {
    _redPacketScoreController.text = '32';
    _redPacketCountController.text = '2';
    _redPacketTotalScore = _redPacketScoreController.text;
    specifyRedPackCount = 0;
    _redPacketMessageController.text = '摸鱼者，事竟成！';
    IWPZDialog.show(
      context,
      title: '发红包',
      titleColor: Colors.white,
      okColor: Colors.white,
      backgroundColor: Colors.red,
      height: 530,
      showCancel: true,
      onOKTap: () async {
        List selectedUsers = List.empty(growable: true);
        selectedUsers.addAll(specifyChoosedUsers.keys);
        var res = await Api.sendRedPacket(
          type: redpackType,
          money: int.parse(_redPacketScoreController.text),
          count: int.parse(_redPacketCountController.text),
          msg: _redPacketMessageController.text,
          recivers: redpackType == 'specify' ? selectedUsers : [],
          gesture: redpackType == 'rockPaperScissors' ? rockPackType : -1,
        );
        if (res['code'] == 0) {
        } else {
          Fluttertoast.showToast(msg: res['msg']);
        }
      },
      contentWidget: StatefulBuilder(
        builder: (context, builderState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  // random(拼手气红包), average(平分红包)，specify(专属红包)，heartbeat(心跳红包)，dice(骰子红包)
                  SizedBox(
                    width: 70,
                    child: Row(children: [
                      const Text(
                        '拼:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                          activeColor: Colors.white,
                          groupValue: redpackType,
                          value: 'random',
                          onChanged: (String? value) {
                            builderState(() {
                              _redPacketMessageController.text = '摸鱼者，事竟成！';
                              _redPacketCountController.text = '2';

                              redpackType = value!;
                            });
                          }),
                    ]),
                  ),
                  SizedBox(
                    width: 70,
                    child: Row(children: [
                      const Text(
                        '普:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                          activeColor: Colors.white,
                          groupValue: redpackType,
                          value: 'average',
                          onChanged: (String? value) {
                            setState(() {
                              _redPacketTotalScore = (int.parse(_redPacketScoreController.text) *
                                      (int.parse(_redPacketCountController.text)))
                                  .toString();
                            });

                            builderState(() {
                              redpackType = value!;
                              _redPacketCountController.text = '2';
                              _redPacketMessageController.text = '平分红包，人人有份！';
                            });
                          }),
                    ]),
                  ),
                  SizedBox(
                    width: 70,
                    child: Row(children: [
                      const Text(
                        '专:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                          activeColor: Colors.white,
                          groupValue: redpackType,
                          value: 'specify',
                          onChanged: (String? value) {
                            builderState(() {
                              redpackType = value!;
                              _redPacketMessageController.text = '试试看，这是给你的红包吗？';
                            });
                          }),
                    ]),
                  ),
                  SizedBox(
                    width: 70,
                    child: Row(children: [
                      const Text(
                        '心:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                          activeColor: Colors.white,
                          groupValue: redpackType,
                          value: 'heartbeat',
                          onChanged: (String? value) {
                            builderState(() {
                              redpackType = value!;
                              _redPacketMessageController.text = '玩的就是心跳！';
                              _redPacketCountController.text = '5';
                              _redPacketTotalScore = _redPacketScoreController.text;
                            });
                          }),
                    ]),
                  ),
                  SizedBox(
                    width: 70,
                    child: Row(children: [
                      const Text(
                        '猜:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                        activeColor: Colors.white,
                        groupValue: redpackType,
                        value: 'rockPaperScissors',
                        onChanged: (String? value) {
                          builderState(() {
                            redpackType = value!;
                            _redPacketCountController.text = '1';
                            _redPacketMessageController.text = '石头剪刀布！';
                          });
                        },
                      ),
                    ]),
                  ),
                  // const Text(
                  //   '骰:',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  // Radio(
                  //   activeColor: Colors.white,
                  //   groupValue: redpackType,
                  //   value: 'dice',
                  //   onChanged: (String? value) {
                  //     builderState(() {
                  //       redpackType = value!;
                  //       _redPacketCountController.text = '3';
                  //       _redPacketMessageController.text = '买定离手！';
                  //     });
                  //   },
                  // ),
                  //dice
                ],
              ),
              //specify
              redpackType == 'specify'
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '发给谁:',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 200,
                            child: ListView.builder(
                              itemCount: onlineUsers.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    builderState(() {
                                      String userName = onlineUsers[index]['userName'];
                                      if (specifyChoosedUsers.keys.contains(userName)) {
                                        builderState(() {
                                          specifyRedPackCount--;
                                          specifyChoosedUsers.remove(userName);
                                        });
                                      } else {
                                        specifyChoosedUsers[userName] = onlineUsers[index];
                                      }
                                      builderState(() {
                                        _redPacketTotalScore =
                                            (int.parse(_redPacketScoreController.text) * specifyChoosedUsers.length)
                                                .toString();
                                        _redPacketCountController.text = specifyChoosedUsers.length.toString();
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: specifyChoosedUsers.keys.contains(onlineUsers[index]['userName'])
                                          ? Colors.blue[200]
                                          : Colors.red,
                                      border: const Border(
                                        bottom: BorderSide(color: Color(0xFFCECECE)),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      onlineUsers[index]['userName'],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ))
                      ],
                    )
                  : Container(),
              redpackType == 'rockPaperScissors'
                  ? SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Image.asset('assets/images/rock.png', height: 20, width: 20),
                          const Text(
                            ' :',
                            style: TextStyle(color: Colors.white),
                          ),
                          Radio(
                              activeColor: Colors.white,
                              groupValue: rockPackType,
                              value: 0,
                              onChanged: (int? value) {
                                builderState(() {
                                  rockPackType = value!;
                                });
                              }),
                          Image.asset('assets/images/knife.png', height: 20, width: 20),
                          const Text(
                            ' :',
                            style: TextStyle(color: Colors.white),
                          ),
                          Radio(
                              activeColor: Colors.white,
                              groupValue: rockPackType,
                              value: 1,
                              onChanged: (int? value) {
                                builderState(() {
                                  rockPackType = value!;
                                });
                              }),
                          Image.asset('assets/images/rul.png', height: 20, width: 20),
                          const Text(
                            ' :',
                            style: TextStyle(color: Colors.white),
                          ),
                          Radio(
                              activeColor: Colors.white,
                              groupValue: rockPackType,
                              value: 2,
                              onChanged: (int? value) {
                                builderState(() {
                                  rockPackType = value!;
                                });
                              }),
                        ],
                      ),
                    )
                  : Container(),
              Row(
                children: [
                  const Text(
                    '积分:',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 80,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: IWPZTextField(
                        contentPaddingValue: 5,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: const Color.fromARGB(102, 248, 115, 115),
                        style: const TextStyle(color: Colors.white),
                        controller: _redPacketScoreController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          builderState(() {
                            if (redpackType == 'average') {
                              _redPacketTotalScore =
                                  (int.parse(value) * (int.parse(_redPacketCountController.text))).toString();
                            } else {
                              _redPacketTotalScore = value;
                            }
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    '个数:',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 80,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: IWPZTextField(
                        contentPaddingValue: 5,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: const Color.fromARGB(102, 248, 115, 115),
                        style: const TextStyle(color: Colors.white),
                        controller: _redPacketCountController,
                        enabled: redpackType != 'rockPaperScissors',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    '留言:',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      child: IWPZTextField(
                        contentPaddingValue: 5,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: const Color.fromARGB(102, 248, 115, 115),
                        style: const TextStyle(color: Colors.white),
                        controller: _redPacketMessageController,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '总计：$_redPacketTotalScore',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  // void _onFaceSelect() async {
  //   var res = await Api.getFacePack();
  // }

  void _onEmojiSelect() async {
    var res = await Api.getFacePack();
    if (res['code'] == 0) {
      var list = jsonDecode(res['data']);
      if (list.isEmpty) {
        Fluttertoast.showToast(msg: '您没有表情');
      } else {
        IWPZDialog.show(
          context,
          title: '请选择表情',
          height: 400,
          contentWidget: SingleChildScrollView(
            child: Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(list.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _textInputController.text += "![image.png](${list[index]})";
                      NavigatorTool.pop(context);
                      _textInputNode.requestFocus();
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        maxWidth: 60,
                      ),
                      child: Image.network(list[index]),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      }
    }
  }

  void _onImageSelect() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var res = await Api.upload([image]);
    if (res['code'] == 0) {
      Map imgMap = res['data']['succMap'];
      String imageName = imgMap.keys.first;
      String fileUrl = imgMap[imageName];
      _textInputController.text = '![$imageName]($fileUrl)';
    }
  }

  void _sendMessageReq(String message) async {
    var res = await Api.sendMessage(message);
    if (res['code'] != 0) {
      Fluttertoast.showToast(msg: '消息发送失败!');
    }
    _textInputController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天室',
        showBack: true,
        rightTitle: '在线人数：$onlineCount',
        backgroundColor: GlobalStyle.mainThemeColor,
      ),
      backgroundColor: Colors.white,
      scaleWithKeyboard: true,
      child: GestureDetector(
        onTap: () {
          _textInputNode.unfocus();
        },
        child: IWPZTableView(
          sectionCount: 1,
          controller: chatScrollController,
          hideLine: true,
          enablePullDown: true,
          refreshController: refreshController,
          refreshLabel: '加载历史消息',
          onRefresh: () {
            refreshSavedOffset = chatScrollController.position.maxScrollExtent;
            ChatRoomMessageManager.loadMessage();
          },
          rowCount: (section) {
            return ChatRoomMessageManager.messageList.length + 1;
          },
          row: (indexPath) {
            if (indexPath.row == ChatRoomMessageManager.messageList.length) {
              return Container(height: 20);
            }
            return ChatMessageCell(
              key: Key(ChatRoomMessageManager.messageList[indexPath.row!]['oId']),
              message: ChatRoomMessageManager.messageList[indexPath.row!],
              onUserAvatarLongPress: (message) {
                _textInputController.text += '@${message['userName']} ';
                _textInputNode.requestFocus();
              },
              onUserAvatarPress: (message) async {
                var res = await Api.getOtherUserInfo(message['userName']);
                debugPrint(res.toString());
                NavigatorTool.push(
                  context,
                  page: UserProfilePage(userProfile: res),
                  then: (dynamic) {
                    setState(() {});
                  },
                );
              },
              onMessageLongPress: (int value, message) async {
                if (value == 1) {
                  var res = await Api.revokeMessage(message['oId']);
                  if (res['code'] != 0) {
                    Fluttertoast.showToast(msg: res['msg']);
                  }
                } else if (value == 2) {
                  await Api.reportMessage(
                    reportDataId: message['oId'],
                    reportDataType: 3,
                    reportType: 49,
                    reportMemo: '在聊天室中的举报',
                  );
                }
              },
              onRedpackaetPress: (message, gesture) async {
                if (gesture == -1) {
                  var res = await Api.openRedPack(message['oId']);
                  RedpackDialog.show(context, redPack: res);
                } else {
                  var res = await Api.openRedPack(message['oId'], gesture: gesture);
                  RedpackDialog.show(context, redPack: res);
                }
              },
            );
          },
        ),
      ),
      bottomPanel: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFCECECE),
              offset: Offset(0, -1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _onImageSelect,
                    child: const Icon(Icons.image),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _onEmojiSelect,
                    child: const Icon(Icons.emoji_emotions),
                  ),
                  GestureDetector(
                    onTap: _onRedPackSelect,
                    child: Image.asset(
                      'assets/images/redpacket_icon.png',
                      height: 36,
                      width: 36,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Text(
                            '当前话题：',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_textInputController.text.contains('*`# $currentDiscussing #`*')) {
                              } else {
                                _textInputController.text = _textInputController.text + '*`# $currentDiscussing #`*';
                              }
                              Future.delayed(const Duration(milliseconds: 50), () {
                                _textInputNode.requestFocus();
                              });
                            },
                            child: AutoSizeText(
                              '#$currentDiscussing#',
                              minFontSize: 10,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14, color: Color(0xFF569e3d)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50),
                  FocusScope.of(context).hasFocus
                      ? GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: const Icon(Icons.keyboard_arrow_down_rounded),
                        )
                      : Container(),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const Divider(
              height: 0.5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 60,
                      minHeight: 30.0,
                    ),
                    margin: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    child: IWPZTextField(
                      controller: _textInputController,
                      focusNode: _textInputNode,
                      maxLength: null,
                      textInputAction: TextInputAction.send,
                      borderRadius: BorderRadius.circular(4),
                      keyboardType: TextInputType.text,
                      contentPaddingValue: 6,
                      backgroundColor: const Color(0xFFEEEEEE),
                      onSubmitted: (text) {
                        if (_textInputController.text.isEmpty) {
                        } else {
                          _sendMessageReq(_textInputController.text);
                        }
                      },
                    ),
                  ),
                ),
                // const  SizedBox(width: 10),
                // GestureDetector(
                //   onTap: () async {
                //     if (_textInputController.text.isEmpty) {
                //     } else {
                //       _sendMessageReq(_textInputController.text);
                //     }
                //   },
                //   child: Container(
                //     width: 40,
                //     height: 30,
                //     margin: const EdgeInsets.only(top: 10),
                //     child: const Text('发送'),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
