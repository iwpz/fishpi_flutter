import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/iwpz_dialog.dart';
import 'package:fishpi_flutter/widget/medal_widget.dart';
import 'package:fishpi_flutter/widget/redpack_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_viewer/image_viewer.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> with AutomaticKeepAliveClientMixin {
  List<types.Message> _messages = [];
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
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  String redpackType = 'random';
  int rockPackType = 0;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    ChatRoomMessageManager.listeningNewMessage((message) {
      print('听到了一个消息：内容是：');
      print(message);
      print(message['type']);
      setState(() {
        _addMessageToUI(message);
      });
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.any,
    // );

    // if (result != null && result.files.single.path != null) {
    //   final message = types.FileMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     id: const Uuid().v4(),
    //     mimeType: lookupMimeType(result.files.single.path!),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: result.files.single.path!,
    //   );

    //   _addMessage(message);
    // }
  }

  void _handleImageSelection() async {
    // final result = await ImagePicker().pickImage(
    //   imageQuality: 70,
    //   maxWidth: 1440,
    //   source: ImageSource.gallery,
    // );

    // if (result != null) {
    //   final bytes = await result.readAsBytes();
    //   final image = await decodeImageFromList(bytes);

    //   final message = types.ImageMessage(
    //     author: _user,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     height: image.height.toDouble(),
    //     id: const Uuid().v4(),
    //     name: result.name,
    //     size: bytes.length,
    //     uri: result.path,
    //     width: image.width.toDouble(),
    //   );

    //   _addMessage(message);
    // }
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
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
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
      backgroundColor: const Color(0xFFCECECE),
      height: MediaQuery.of(context).size.height,
      showCancel: true,
      onOKTap: () async {
        List selectedUsers = List.empty(growable: true);
        for (int i = 0; i < specifyChoosedUsers.length; i++) {
          selectedUsers.add(specifyChoosedUsers['userName']);
        }
        var res = await Api.sendRedPacket(
          type: redpackType,
          money: int.parse(_redPacketScoreController.text),
          count: int.parse(_redPacketCountController.text),
          msg: _redPacketMessageController.text,
          recivers: redpackType == 'average' ? selectedUsers : [],
          gesture: redpackType == 'rockPaperScissors' ? rockPackType : -1,
        );
        print('红包-----');
        print(res);
      },
      contentWidget: StatefulBuilder(
        builder: (context, builderState) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // random(拼手气红包), average(平分红包)，specify(专属红包)，heartbeat(心跳红包)
                    const Text('拼:'),
                    Radio(
                        groupValue: redpackType,
                        value: 'random',
                        onChanged: (String? value) {
                          builderState(() {
                            _redPacketMessageController.text = '摸鱼者，事竟成！';
                            _redPacketCountController.text = '2';

                            redpackType = value!;
                          });
                        }),
                    const Text('普:'),
                    Radio(
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
                    const Text('专:'),
                    Radio(
                        groupValue: redpackType,
                        value: 'specify',
                        onChanged: (String? value) {
                          builderState(() {
                            redpackType = value!;
                            _redPacketMessageController.text = '试试看，这是给你的红包吗？';
                          });
                        }),
                    const Text('心:'),
                    Radio(
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
                    const Text('猜:'),
                    Radio(
                        groupValue: redpackType,
                        value: 'rockPaperScissors',
                        onChanged: (String? value) {
                          print(value);
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
                          Text('发给谁:'),
                          Container(
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
                                        // if (onlineUsers[index]['selected'] == null ||
                                        //     onlineUsers[index]['selected'] == false) {
                                        //   onlineUsers[index]['selected'] = true;
                                        //   builderState(() {
                                        //     specifyRedPackCount++;
                                        //   });
                                        // } else {
                                        //   onlineUsers[index]['selected'] = false;
                                        //   builderState(() {
                                        //     specifyRedPackCount--;
                                        //   });
                                        // }
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
                                      color: specifyChoosedUsers.keys.contains(onlineUsers[index]['userName'])
                                          ? Colors.blue[200]
                                          : const Color(0xFFCECECE),
                                      child: Text(onlineUsers[index]['userName']),
                                    ),
                                  );
                                },
                              ))
                        ],
                      )
                    : Container(),
                redpackType == 'rockPaperScissors'
                    ? Container(
                        height: 60,
                        child: Row(
                          children: [
                            const Text('石头:'),
                            Radio(
                                groupValue: rockPackType,
                                value: 0,
                                onChanged: (int? value) {
                                  builderState(() {
                                    rockPackType = value!;
                                  });
                                }),
                            const Text('剪刀:'),
                            Radio(
                                groupValue: rockPackType,
                                value: 1,
                                onChanged: (int? value) {
                                  builderState(() {
                                    rockPackType = value!;
                                  });
                                }),
                            const Text('布:'),
                            Radio(
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
                    Text('积分:'),
                    Container(
                      width: 80,
                      child: TextField(
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
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('个数:'),
                    Container(
                      width: 80,
                      child: TextField(
                        controller: _redPacketCountController,
                        enabled: redpackType != 'rockPaperScissors',
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('留言:'),
                    Expanded(
                      child: TextField(
                        controller: _redPacketMessageController,
                      ),
                    ),
                  ],
                ),
                Text('总计：$_redPacketTotalScore'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onFaceSelect() async {
    var res = await Api.getFacePack();
    print(res);
  }

  void _onImageSelect() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择了图片：');
    print(image!.path);
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
    print('add a message ${msg['type']} to ui:');
    print(msg['content']);
    String type = msg['type'];
    if (type == 'msg') {
      print('add a text msg to ui');
      setState(() {
        types.CustomMessage message = types.CustomMessage(
          id: msg['oId'],
          author: types.User(id: msg['userName']),
          metadata: msg,
        );
        print('添加到消息list');
        _messages.insert(0, message);
        print('添加之后：');
        print(_messages.last);
      });
    } else if (type == 'redPacketStatus') {
      types.CustomMessage message = types.CustomMessage(
        id: msg['oId'],
        author: const types.User(id: 'system'),
        metadata: msg,
      );
      setState(() {
        _messages.insert(0, message);
      });
    } else if (type == 'online') {
      print('online----------');
      print(msg);
      setState(() {
        onlineCount = msg['onlineChatCnt'];
        currentDiscussing = msg['discussing'];
        onlineUsers = msg['users'];
      });
      print('online----------');

      //更新在线信息
      // message = types.CustomMessage(
      //   id: '',
      //   author: types.User(id: 'system'),
      //   metadata: msg,
      // );
    }
  }

  Widget _getMessageWidget(types.CustomMessage message) {
    print('获取消息');
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
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: CachedNetworkImage(imageUrl: message.metadata!['userAvatarURL']),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        Text(message.metadata!['userNickname'].isEmpty
                            ? message.metadata!['userName']
                            : '${message.metadata!['userNickname']} (${message.metadata!['userName']})'),
                        ...metals == null || metals['list'] == null
                            ? []
                            : List.generate(metals['list'].length, (index) {
                                if (metals['list'][index]['enabled'] == true) {
                                  return MedalWidget(medal: metals['list'][index]);
                                }
                                return Container();
                              }),
                      ],
                    ),
                  ),
                  isMessage
                      ? Html(
                          data: message.metadata!['content'],
                          onImageTap: (String? url, RenderContext rContext, Map<String, String> attributes, element) {
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
                            height: 60,
                            margin: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                            width: double.infinity,
                            color: redPack['count'] == redPack['got']
                                ? const Color.fromARGB(255, 243, 208, 162)
                                : Colors.orange,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(redPack['msg']),
                                Text(redPack['type'] == 'rockPaperScissors'
                                    ? '石头剪刀布红包'
                                    : redPack['type'] == 'random'
                                        ? '拼手气红包'
                                        : redPack['type'] == 'average'
                                            ? '普通红包'
                                            : redPack['type'] == 'specify'
                                                ? '专属红包'
                                                : redPack['type'] == 'heartbeat'
                                                    ? '心跳红包'
                                                    : '未知红包???'),
                                Text('${redPack['got']}/${redPack['count']}' +
                                    (redPack['count'] == redPack['got'] ? '红包被抢光啦！' : '')),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRedPackgetMessageWidget(types.CustomMessage message) {
    var meta = message.metadata;
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Text(meta!['whoGot']),
          const Text('抢到了'),
          Text(meta['whoGive']),
          const Text('的'),
          const Text('红包'),
          Text('（${meta['got']}/${meta['count']}）'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: BaseAppBar(
        title: '聊天室',
        showBack: false,
        rightTitle: '在线人数：$onlineCount',
      ),
      child: Chat(
          l10n: const ChatL10nZhCN(),
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _onFaceSelect,
                        child: const Icon(Icons.emoji_emotions),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _onRedPackSelect,
                        child: const Icon(Icons.money),
                      ),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          const Text(
                            '当前话题：',
                            style: TextStyle(fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              _textInputController.text = _textInputController.text + ' `# $currentDiscussing #` \n';
                            },
                            child: Text('#$currentDiscussing#',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF569e3d))),
                          ),
                        ],
                      ),
                      SizedBox(width: 50),
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
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textInputController,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _sendMessageReq(_textInputController.text);
                      },
                      child: const SizedBox(
                        width: 40,
                        child: Text('发送'),
                      ),
                    ),
                  ],
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
