import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/widget/base_app_bar.dart';
import 'package:fishpi_flutter/widget/base_page.dart';
import 'package:fishpi_flutter/widget/redpack_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_viewer/image_viewer.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<types.Message> _messages = [];
  final TextEditingController _textInputController = TextEditingController();
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');

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
    if (message.metadata!['content'].toString().contains('汗滴禾下土')) {
      print(message);
    }
    var metals = json.decode(message.metadata!['sysMetal']);
    bool isMessage = true;
    Map redPack = {};
    if (message.metadata!['content'].toString().startsWith('{')) {
      isMessage = false;
      redPack = json.decode(message.metadata!['content']);
    }
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: CachedNetworkImage(
                      imageUrl: message.metadata!['userAvatarURL']),
                ),
                Text(message.metadata!['userNickname']),
                metals['list'] == null
                    ? Container()
                    : Container(
                        height: 30,
                        // width: 60,
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(metals['list'][0]['name']),
                      ),
              ],
            ),
          ),
          isMessage
              ? Html(
                  data: message.metadata!['content'],
                  /*
                   String? url,
    RenderContext context,
    Map<String, String> attributes,
    dom.Element? element,
                   */
                  onImageTap: (String? url, RenderContext rContext,
                      Map<String, String> attributes, element) {
                    print(url);
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
                    margin: const EdgeInsets.only(
                        left: 40, right: 40, top: 10, bottom: 10),
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
                            (redPack['count'] == redPack['got']
                                ? '红包被抢光啦！'
                                : '')),
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
      appBar: BaseAppBar(title: '聊天室', showBack: false),
      child: Chat(
          l10n: const ChatL10nZhCN(),
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _user,
          customBottomWidget: SizedBox(
            height: 100,
            child: Row(
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
                    width: 80,
                    child: Text('发送'),
                  ),
                ),
              ],
            ),
          ),
          customMessageBuilder: (types.CustomMessage message,
              {int messageWidth = 10}) {
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
}
