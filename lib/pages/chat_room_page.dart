import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/pages/user_profile_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:fishpi_flutter/widget/iwpz_textfield.dart';
import 'package:fishpi_flutter/widget/medal_icon.dart';
import 'package:fishpi_flutter/widget/medal_widget.dart';
import 'package:fishpi_flutter/widget/redpack_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<types.Message> messageList = List.empty(growable: true);
  int onlineCount = 0;
  List onlineUsers = [];
  Map specifyChoosedUsers = {};
  String currentDiscussing = '';
  int specifyRedPackCount = 0;
  final TextEditingController _redPacketScoreController = TextEditingController();
  late String _redPacketTotalScore = '32';
  final TextEditingController _redPacketCountController = TextEditingController();
  final TextEditingController _redPacketMessageController = TextEditingController();

  final TextEditingController _textInputController = TextEditingController();
  final FocusNode _textInputNode = FocusNode();
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  String redpackType = 'random';
  int rockPackType = 0;
  late StreamSubscription stream;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    if (DataManager.chatRoomOnLineInfo != null) {
      setState(() {
        onlineCount = DataManager.chatRoomOnLineInfo['onlineChatCnt'];
        currentDiscussing = DataManager.chatRoomOnLineInfo['discussing'];
        onlineUsers = DataManager.chatRoomOnLineInfo['users'];
      });
    }
    stream = ChatRoomMessageManager.listeningNewMessage((message) {
      if (mounted) {
        setState(() {
          _addMessageToUI(message);
        });
      }
    });
  }

  @override
  void dispose() {
    ChatRoomMessageManager.unlistenNewMessage(stream);
    super.dispose();
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      // await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messageList.indexWhere((element) => element.id == message.id);
    final updatedMessage = messageList[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        messageList[index] = updatedMessage;
      });
    });
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
              Row(
                children: [
                  // random(拼手气红包), average(平分红包)，specify(专属红包)，heartbeat(心跳红包)
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
                          _redPacketTotalScore =
                              (int.parse(_redPacketScoreController.text) * (int.parse(_redPacketCountController.text)))
                                  .toString();
                        });

                        builderState(() {
                          redpackType = value!;
                          _redPacketCountController.text = '2';
                          _redPacketMessageController.text = '平分红包，人人有份！';
                        });
                      }),
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
                          _redPacketCountController.text = '2';
                          _redPacketTotalScore = _redPacketScoreController.text;
                        });
                      }),
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
                      }),
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
                                      style: TextStyle(color: Colors.white),
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

  void _onFaceSelect() async {
    var res = await Api.getFacePack();
  }

  void _onImageSelect() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var res = await Api.upload([image]);
    if (res['code'] == 0) {
      Map imgMap = res['data']['succMap'];
      String imageName = imgMap.keys.first;
      String fileUrl = imgMap[imageName];
      _textInputController.text = '![$imageName](${fileUrl})';
    }
  }

  void _handleSendPressed(types.PartialText message) {
    _sendMessageReq(message.text);
  }

  void _sendMessageReq(String message) async {
    var res = await Api.sendMessage(message);
    if (res['code'] != 0) {
      Fluttertoast.showToast(msg: '消息发送失败!');
    }
    _textInputController.text = '';
  }

  void _loadMessages() async {
    var res = await Api.getChatHistoryMessage(page: 1);
    if (res['code'] == 0) {
      List messageList = res['data'];
      for (int i = messageList.length - 1; i >= 0; i--) {
        var msg = messageList[i];
        msg['type'] = 'msg';
        _addMessageToUI(msg);
      }
    }
  }

  void _addMessageToUI(msg) {
    String type = msg['type'];
    if (type == 'msg') {
      setState(() {
        types.CustomMessage message = types.CustomMessage(
          id: msg['oId'],
          author: types.User(id: msg['userName']),
          metadata: msg,
        );
        messageList.insert(0, message);
      });
    } else if (type == 'redPacketStatus') {
      types.CustomMessage message = types.CustomMessage(
        id: msg['oId'],
        author: const types.User(id: 'system'),
        metadata: msg,
      );
      setState(() {
        messageList.insert(0, message);
      });
    } else if (type == 'online') {
      setState(() {
        onlineCount = msg['onlineChatCnt'];
        currentDiscussing = msg['discussing'];
        onlineUsers = msg['users'];
      });
    } else if (type == 'revoke') {
      String oId = msg['oId'];
      setState(() {
        messageList.removeWhere((msg) => msg.metadata!['oId'] == oId);
      });
    }
  }

  Widget _getMessageWidget(types.CustomMessage message) {
    var metals = {};
    if (message.metadata!['sysMetal'] != null) {
      try {
        metals = json.decode(message.metadata!['sysMetal']);
      } catch (ex) {
        metals = {};
      }
    }
    bool isMessage = true;
    Map redPack = {};
    if (message.metadata!['content'].toString().startsWith('{')) {
      isMessage = false;
      redPack = json.decode(message.metadata!['content']);
    }
    Widget messageCell = Material(
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.metadata!['userName'] == DataManager.myInfo['userName']
                ? Container()
                : GestureDetector(
                    onLongPress: () {
                      _textInputController.text += '@${message.metadata!['userName']} ';
                      _textInputNode.requestFocus();
                    },
                    onTap: () async {
                      var res = await Api.getOtherUserInfo(message.metadata!['userName']);
                      print(res);
                      NavigatorTool.push(context, page: UserProfilePage(userProfile: res));
                      // if (res['code'] == 0) {}
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: CachedNetworkImage(imageUrl: message.metadata!['userAvatarURL']),
                    ),
                  ),
            Expanded(
              child: GestureDetector(
                onLongPressStart: (details) {
                  double x = details.globalPosition.dx;
                  double y = details.globalPosition.dy;
                  final RenderBox? overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
                  RelativeRect position = RelativeRect.fromRect(
                    Rect.fromLTRB(x, y, x + 50, y - 50),
                    Offset.zero & overlay!.size,
                  );
                  PopupMenuItem popupMenuItem = const PopupMenuItem(
                    child: Text("撤回"),
                    value: 1,
                    height: 20,
                    // padding: EdgeInsets.only(),
                  );
                  List<PopupMenuEntry<dynamic>> list = [popupMenuItem]; //菜单栏需要显示的菜单项集合

                  showMenu(context: context, position: position, items: list).then((value) async {
                    if (value == 1) {
                      var res = await Api.revokeMessage(message.metadata!['oId']);
                      if (res['code'] != 0) {
                        Fluttertoast.showToast(msg: res['msg']);
                      }
                    }
                  });
                  // PopupMenuButton
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: message.metadata!['userName'] == DataManager.myInfo['userName']
                        ? isMessage
                            ? Colors.blue[100]
                            : Colors.white
                        : isMessage
                            ? Colors.grey[200]
                            : Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        child: message.metadata!['userName'] == DataManager.myInfo['userName']
                            ? Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  ...metals['list'] == null
                                      ? []
                                      : List.generate(metals['list'].length, (index) {
                                          if (metals['list'][index]['enabled'] == true) {
                                            return MedalIcon(medal: metals['list'][index]);
                                          }
                                          return Container();
                                        }),
                                  Text(message.metadata!['userNickname'].isEmpty
                                      ? message.metadata!['userName']
                                      : '${message.metadata!['userNickname']} (${message.metadata!['userName']})'),
                                ],
                              )
                            : Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  Text(message.metadata!['userNickname'].isEmpty
                                      ? message.metadata!['userName']
                                      : '${message.metadata!['userNickname']} (${message.metadata!['userName']})'),
                                  ...metals['list'] == null
                                      ? []
                                      : List.generate(metals['list'].length, (index) {
                                          if (metals['list'][index]['enabled'] == true) {
                                            return MedalIcon(medal: metals['list'][index]);
                                          }
                                          return Container();
                                        }),
                                ],
                              ),
                      ),
                      isMessage
                          ? message.metadata!['content'].toString().contains('<iframe')
                              ? Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 100,
                                    maxWidth: 150,
                                  ),
                                  child: Expanded(
                                    child: InAppWebView(
                                      initialData: InAppWebViewInitialData(data: message.metadata!['content']),
                                    ),
                                  ),
                                ) //webview
                              : Html(
                                  data: message.metadata!['content'],
                                  onImageTap:
                                      (String? url, RenderContext rContext, Map<String, String> attributes, element) {
                                    ImageViewer.showImageSlider(
                                      images: [
                                        url!,
                                      ],
                                    );
                                  },
                                )
                          : GestureDetector(
                              onTap: () async {
                                var res = await Api.openRedPack(message.id);
                                RedpackDialog.show(context, redPack: res);
                              },
                              child: Container(
                                height: redPack['type'] == 'rockPaperScissors' ? 110 : 70,
                                margin: const EdgeInsets.only(left: 0, right: 10, top: 0, bottom: 20),
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: redPack['count'] == redPack['got']
                                      ? const Color.fromARGB(255, 243, 208, 162)
                                      : Colors.orange,
                                  border: Border.all(color: const Color.fromARGB(255, 243, 208, 162)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      redPack['msg'],
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    const Divider(
                                      height: 0.5,
                                      endIndent: 20,
                                      color: Color(0xFFCECECE),
                                    ),
                                    Text(
                                      redPack['type'] == 'rockPaperScissors'
                                          ? '石头剪刀布红包'
                                          : redPack['type'] == 'random'
                                              ? '拼手气红包'
                                              : redPack['type'] == 'average'
                                                  ? '普通红包'
                                                  : redPack['type'] == 'specify'
                                                      ? '专属红包'
                                                      : redPack['type'] == 'heartbeat'
                                                          ? '心跳红包'
                                                          : '未知红包???',
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      '${redPack['got']}/${redPack['count']}' +
                                          (redPack['count'] == redPack['got'] ? '红包被抢光啦！' : ''),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    redPack['type'] == 'rockPaperScissors'
                                        ? Container(
                                            margin: const EdgeInsets.only(top: 2, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    var res = await Api.openRedPack(message.id, gesture: 0);
                                                    RedpackDialog.show(context, redPack: res);
                                                  },
                                                  child: Image.asset('assets/images/rock.png', height: 32, width: 32),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () async {
                                                    var res = await Api.openRedPack(message.id, gesture: 1);
                                                    RedpackDialog.show(context, redPack: res);
                                                  },
                                                  child: Image.asset('assets/images/knife.png', height: 32, width: 32),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () async {
                                                    var res = await Api.openRedPack(message.id, gesture: 2);
                                                    RedpackDialog.show(context, redPack: res);
                                                  },
                                                  child: Image.asset('assets/images/rul.png', height: 32, width: 32),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            message.metadata!['userName'] == DataManager.myInfo['userName']
                ? Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: CachedNetworkImage(imageUrl: message.metadata!['userAvatarURL']),
                  )
                : Container(),
          ],
        ),
      ),
    );
    return messageCell;
  }

  Widget _getRedPackgetMessageWidget(types.CustomMessage message) {
    var meta = message.metadata;
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: 40,
      child: Row(
        children: [
          // Expanded(
          // child:
          AutoSizeText(
            meta!['whoGot'],
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
          // ),
          const Text(
            '抢到了',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            meta['whoGive'],
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
          const Text(
            '的',
            style: TextStyle(fontSize: 12),
          ),
          const Text(
            '红包',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '（${meta['got']}/${meta['count']}）',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天室',
        showBack: true,
        rightTitle: '在线人数：$onlineCount',
      ),
      child: SafeArea(
        child: Chat(
            l10n: const ChatL10nZhCN(),
            messages: messageList,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: _user,
            customBottomWidget: Container(
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
              height: 100,
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
                        // const SizedBox(width: 10),
                        // GestureDetector(
                        //   onTap: _onFaceSelect,
                        //   child: const Icon(Icons.emoji_emotions),
                        // ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _onRedPackSelect,
                          child: Image.asset('assets/images/redpacket_icon.png', height: 36, width: 36),
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
                                    _textInputController.text =
                                        _textInputController.text + ' `# $currentDiscussing #` \n';
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
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: IWPZTextField(
                              controller: _textInputController,
                              focusNode: _textInputNode,
                              borderRadius: BorderRadius.circular(4),
                              contentPaddingValue: 6,
                              backgroundColor: const Color(0xFFEEEEEE),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            if (_textInputController.text.isEmpty) {
                            } else {
                              _sendMessageReq(_textInputController.text);
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 30,
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text('发送'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            customMessageBuilder: (types.CustomMessage message, {int messageWidth = 10}) {
              String type = message.metadata!['type'];
              if (type == 'msg') {
                return _getMessageWidget(message);
              } else if (type == 'redPacketStatus') {
                return _getRedPackgetMessageWidget(message);
              }
              return Container();
            }),
      ),
    );
  }
}
