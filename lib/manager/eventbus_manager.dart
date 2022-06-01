import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnChatMessageEvent {
  var chatMessage = {};
  OnChatMessageEvent(this.chatMessage);
}

class OnChatMessageUpdate {
  var message;
  OnChatMessageUpdate([this.message]);
}

class OnHistoryMessageLoaded {
  OnHistoryMessageLoaded();
}

class OnOnlineStatusUpdate {
  var onlineMessage;
  OnOnlineStatusUpdate(this.onlineMessage);
}

class OnBlackListChangeEvent {
  OnBlackListChangeEvent();
}

class OnListNeedRefreshEvent {
  OnListNeedRefreshEvent();
}

class OnCloseSlidableEvent {
  var slidableId = {};
  OnCloseSlidableEvent(this.slidableId);
}
