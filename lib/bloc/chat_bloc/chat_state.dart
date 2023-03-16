
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';

abstract class ChatState {}
class InitialChatState extends ChatState {}
class LoadingChatState extends ChatState {}
class SuccessFulFetchedFriendsState extends ChatState {
 final List<ConversationModel> friends;

  SuccessFulFetchedFriendsState(this.friends);
}

class NewMessageChatState extends ChatState {
  final ConversationModel message;

  NewMessageChatState(this.message);
}

class NewTypingState extends ChatState {
  final Map typing;

  NewTypingState(this.typing);
}

class NewOnlineStatusState extends ChatState {
  final Map status;

  NewOnlineStatusState(this.status);
}


