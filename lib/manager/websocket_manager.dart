import 'dart:convert';
import 'dart:io';

import 'package:fishpi_flutter/config.dart';
import 'package:fishpi_flutter/manager/chat_room_message_manager.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';
import 'package:flutter/material.dart';

class WebsocketManager {
  factory WebsocketManager() => _sharedInstance();
  static final WebsocketManager _instance = WebsocketManager._();
  late WebSocket _socket;
  WebsocketManager._();

  static WebsocketManager _sharedInstance() {
    return _instance;
  }

  static int retryTime = 0;

  void init() async {
    String url = AppConfig.baseWsUrl + '/chat-room-channel?apiKey=' + RequestManager.apiKey;
    _socket = await WebSocket.connect(url);
    _socket.listen(
      (message) {
        Map<String, dynamic> msg = json.decode(message);
        ChatRoomMessageManager.fireNewMessage(msg);
      },
      onError: (error) {
        debugPrint('ws onerror');
        debugPrint(error.toString());
      },
      onDone: () {
        if (retryTime < 3) {
          retryTime++;
          init();
        } else {
          _socket.close();
          debugPrint('ws ondone');
        }
      },
    );
  }

  void destory() {
    _socket.close();
  }
}
