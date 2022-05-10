import 'dart:async';

import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:flutter/material.dart';

class ChatRoomMessageManager {
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

  static void unlistenNewMessage(StreamSubscription stream) {
    stream.cancel();
  }
}
