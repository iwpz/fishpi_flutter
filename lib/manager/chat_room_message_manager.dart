import 'dart:async';

import 'package:fishpi_flutter/manager/eventbus_manager.dart';

class ChatRoomMessageManager {
  static void fireNewMessage(var message) {
    print('cr message manager fire message:');
    eventBus.fire(OnChatMessageEvent(message));
  }

  static StreamSubscription listeningNewMessage(Function onNewMessage) {
    return eventBus.on<OnChatMessageEvent>().listen((event) {
      print('ev 监听到消息：event.chatMessage');
      print(event.chatMessage);
      onNewMessage(event.chatMessage);
    });
  }

  static void unlistenNewMessage(StreamSubscription stream) {
    stream.cancel();
  }
}
