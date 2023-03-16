import 'package:chat/models/conversation_model.dart';

abstract class SearchUserEvent {}

class SearchUsersEvent extends SearchUserEvent {
  final String phoneNumber;

  SearchUsersEvent(this.phoneNumber);
}

class SearchUserSuccessfulEvent extends SearchUserEvent {
  final ConversationModel conversationModel;

  SearchUserSuccessfulEvent(this.conversationModel);
}

class SearchUserLoadingEvent extends SearchUserEvent {}
