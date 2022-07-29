import 'dart:async';

import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/data_manager.dart';
import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:fishpi_flutter/manager/websocket_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRoomMessageManager {
  static List<dynamic> messageList = List.empty(growable: true);
  static int currentMessagePage = 1;
  static int intForUpdateUI = 0;
  static StreamSubscription? messageStream;

  static void fireNewMessage(var message) {
    debugPrint('cr message manager fire message:');
    eventBus.fire(OnChatMessageEvent(message));
  }

  static StreamSubscription listeningNewMessage(Function onNewMessage) {
    return eventBus.on<OnChatMessageEvent>().listen((event) {
      debugPrint('ev 监听到消息：event.chatMessage');
      debugPrint(event.chatMessage.toString());
      onNewMessage(event.chatMessage);
    });
  }

  static void loadMessage() async {
    print('加载历史消息，第$currentMessagePage页');
    var res = await Api.getChatHistoryMessage(page: currentMessagePage);
    if (res['code'] == 0) {
      currentMessagePage++;
      print('消息已加载，添加');
      // res['data'].forEach((e) {
      //   e['type'] = 'msg';
      //   print(e['time']);
      // });
      for (int i = 0; i < res['data'].length; i++) {
        res['data'][i]['type'] = 'msg';
        messageList.insert(0, res['data'][i]);
        print(res['data'][i]['time']);
      }
      print('fire update event');
      eventBus.fire(OnHistoryMessageLoaded());
    }
  }

  static void startListening() {
    messageStream = ChatRoomMessageManager.listeningNewMessage((message) {
      // if (ChatRoomMessageManager.messageList.length > 5000) {
      //   ChatRoomMessageManager.messageList.removeRange(0, 2500);
      // }
      if (message['type'] == 'msg') {
        ChatRoomMessageManager.messageList.add(message);
        eventBus.fire(OnChatMessageUpdate(message));
      } else if (message['type'] == 'online') {
        DataManager.chatRoomOnLineInfo = message;
        eventBus.fire(OnOnlineStatusUpdate(message));
      } else if (message['type'] == 'revoke') {
        String oId = message['oId'];
        messageList.removeWhere((msg) => msg['oId'] == oId);
        eventBus.fire(OnOnlineStatusUpdate(message));
      }
    });
    loadMessage();
  }

  static void unlistenNewMessage() {
    WebsocketManager().destory();
    if (messageStream != null) {
      messageStream!.cancel();
    }
  }
}
