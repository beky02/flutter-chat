import 'package:chat/models/conversation_model.dart';

abstract class SearchUserState {}

class SearchUserSuccessfulState extends SearchUserState {
  final ConversationModel conversationModel;

  SearchUserSuccessfulState(this.conversationModel);
}

class SearchUserLoadingState extends SearchUserState {}

class SearchUserFailedState extends SearchUserState {}

class SearchUserInitialState extends SearchUserState {}
