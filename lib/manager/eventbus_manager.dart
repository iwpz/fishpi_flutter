import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class OnChatMessageEvent {
  var chatMessage = {};
  OnChatMessageEvent(this.chatMessage);
}

class OnCloseSlidableEvent {
  var slidableId = {};
  OnCloseSlidableEvent(this.slidableId);
}
