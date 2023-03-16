import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';

abstract class SendMessageState {}

class SendMessageInitialState extends SendMessageState {}

class SendMessageSuccessfulState extends SendMessageState {
  final ConversationModel message;
  SendMessageSuccessfulState(this.message);
}

class SendMessageFailedState extends SendMessageState {}

class SendMessageLoadingState extends SendMessageState {}
class NewMessageArrivedState extends SendMessageState {
  final ChatMessage message;

  NewMessageArrivedState(this.message);
}