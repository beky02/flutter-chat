import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';

abstract class SendMessageEvent {}

class SendNewMessageEvent extends SendMessageEvent {
  final String content;
  final int receiverId;

  SendNewMessageEvent(this.content, this.receiverId);
}

class SendTypingEvent extends SendMessageEvent {
  final int connectionId;
  final int receiverId;

  SendTypingEvent(this.connectionId, this.receiverId);
}

class SendNewMessageSuccessfulEvent extends SendMessageEvent {
  final ConversationModel message;

  SendNewMessageSuccessfulEvent(this.message);
}

class SendNewMessageFailedEvent extends SendMessageEvent {
  
}

class NewMessageArrivedEvent extends SendMessageEvent {
  final ConversationModel message;

  NewMessageArrivedEvent(this.message);
}
