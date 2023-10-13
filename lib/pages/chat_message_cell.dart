import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishpi_flutter/manager/black_list_manager.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/pages/image_view_page.dart';
import 'package:fishpi_flutter/tools/navigator_tool.dart';
import 'package:fishpi_flutter/widget/medal_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChatMessageCell extends StatefulWidget {
  final message;
  final Function? onMessageLongPress;
  final Function? onUserAvatarLongPress;
  final Function? onUserAvatarPress;
  final Function? onRedpackaetPress;
  const ChatMessageCell({
    Key? key,
    required this.message,
    this.onMessageLongPress,
    this.onUserAvatarLongPress,
    this.onUserAvatarPress,
    this.onRedpackaetPress,
  }) : super(key: key);

  @override
  State<ChatMessageCell> createState() => _ChatMessageCellState();
}

class _ChatMessageCellState extends State<ChatMessageCell> {
  @override
  Widget build(BuildContext context) {
    String type = widget.message['type'];
    if (type == 'msg') {
      return _getMessageWidget(widget.message);
    } else if (type == 'redPacketStatus') {
      return _getRedPackgetMessageWidget(widget.message);
    }
    return Container();
  }

  Widget _getRedPackgetMessageWidget(message) {
    var meta = message;
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

  Widget _getMessageWidget(message) {
    if (BlackListManager().isInBlackList(message['userName'])) {
      return Container();
    }
    var metals = {};
    if (message['sysMetal'] != null) {
      try {
        metals = json.decode(message['sysMetal']);
      } catch (ex) {
        metals = {};
      }
    }
    bool isMessage = true;
    Map redPack = {};
    if (message['content'].toString().startsWith('{')) {
      isMessage = false;
      redPack = json.decode(message['content']);
    }
    Widget messageCell = Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message['userName'] == DataManager.myInfo['userName']
                ? Container(width: MediaQuery.of(context).size.width * 0.2)
                : GestureDetector(
                    onLongPress: () {
                      if (widget.onUserAvatarLongPress != null) {
                        widget.onUserAvatarLongPress!(message);
                      }
                    },
                    onTap: () async {
                      if (widget.onUserAvatarPress != null) {
                        widget.onUserAvatarPress!(message);
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: CachedNetworkImage(imageUrl: message['userAvatarURL']),
                    ),
                  ),
            Expanded(
              child: GestureDetector(
                onLongPressStart: (details) {
                  double x = details.globalPosition.dx;
                  double y = details.globalPosition.dy;
                  final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                  RelativeRect position = RelativeRect.fromRect(
                    Rect.fromLTRB(x, y, x + 50, y - 50),
                    Offset.zero & overlay!.size,
                  );
                  PopupMenuItem backMenuItem = const PopupMenuItem(
                    child: Text("撤回"),
                    value: 1,
                    height: 20,
                  );
                  PopupMenuItem reportMenuItem = const PopupMenuItem(
                    child: Text("举报"),
                    value: 2,
                    height: 20,
                  );
                  List<PopupMenuEntry<dynamic>> list = [backMenuItem, reportMenuItem]; //菜单栏需要显示的菜单项集合

                  showMenu(context: context, position: position, items: list).then((value) async {
                    if (widget.onMessageLongPress != null) {
                      widget.onMessageLongPress!(value, message);
                    }
                  });
                  // PopupMenuButton
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: message['userName'] == DataManager.myInfo['userName']
                        ? isMessage
                            ? Colors.blue[100]
                            : Colors.transparent
                        : isMessage
                            ? Colors.grey[200]
                            : Colors.transparent,
                    borderRadius: message['userName'] == DataManager.myInfo['userName']
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 5),
                        child: message['userName'] == DataManager.myInfo['userName']
                            ? Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 2,
                                children: [
                                  ...metals['list'] == null
                                      ? []
                                      : List.generate(metals['list'].length, (index) {
                                          if (metals['list'][index]['enabled'] == true) {
                                            return MedalIcon(medal: metals['list'][index]);
                                          }
                                          return Container();
                                        }),
                                  Text(message['userNickname'].isEmpty
                                      ? message['userName']
                                      : '${message['userNickname']} (${message['userName']})'),
                                ],
                              )
                            : Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  Text(message['userNickname'].isEmpty
                                      ? message['userName']
                                      : '${message['userNickname']} (${message['userName']})'),
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
                          ? message['content'].toString().contains('<iframe')
                              ? Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 150,
                                    maxWidth: 150,
                                  ),
                                  child: InAppWebView(
                                    initialData: InAppWebViewInitialData(data: message['content']),
                                  ),
                                ) //webview
                              : Html(
                                  data: message['content'],
                                  onImageTap:
                                      (String? url, RenderContext rContext, Map<String, String> attributes, element) {
                                    if (url != null || url!.isNotEmpty) {
                                      NavigatorTool.push(context,
                                          page: ImageViewPage(imageUrl: url), withAnimation: true);
                                    }
                                    // ImageViewer.showImageSlider(
                                    //   images: [
                                    //     url!,
                                    //   ],
                                    // );
                                  },
                                )
                          : GestureDetector(
                              onTap: () async {
                                if (widget.onRedpackaetPress != null) {
                                  widget.onRedpackaetPress!(message, -1);
                                }
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
                                                    if (widget.onRedpackaetPress != null) {
                                                      widget.onRedpackaetPress!(message, 0);
                                                    }
                                                  },
                                                  child: Image.asset('assets/images/rock.png', height: 32, width: 32),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (widget.onRedpackaetPress != null) {
                                                      widget.onRedpackaetPress!(message, 1);
                                                    }
                                                  },
                                                  child: Image.asset('assets/images/knife.png', height: 32, width: 32),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (widget.onRedpackaetPress != null) {
                                                      widget.onRedpackaetPress!(message, 2);
                                                    }
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
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          message['time'],
                          style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 10),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            message['userName'] == DataManager.myInfo['userName']
                ? GestureDetector(
                    onTap: () async {
                      if (widget.onUserAvatarPress != null) {
                        widget.onUserAvatarPress!(message);
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: CachedNetworkImage(imageUrl: message['userAvatarURL']),
                    ),
                  )
                : Container(width: MediaQuery.of(context).size.width * 0.2),
          ],
        ),
      ),
    );
    return messageCell;
  }
}
