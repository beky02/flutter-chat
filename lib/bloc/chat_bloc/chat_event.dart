import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:flutter/material.dart';

abstract class ChatEvent {}

class GetFriendsEvent extends ChatEvent {
  final int page;
  final int limit;

  GetFriendsEvent({@required this.page, @required this.limit});
  
}

class SuccessFulFetchedFriendsEvent extends ChatEvent {
  final Map friends;

  SuccessFulFetchedFriendsEvent(this.friends);
}

class GetNewMessageEvent extends ChatEvent {
  final ConversationModel message;

  GetNewMessageEvent(this.message);

}

class GetTypingEvent extends ChatEvent {
  final Map tying;

  GetTypingEvent(this.tying);

}

class GetOnlineStatusEvent extends ChatEvent {
  final Map status;

  GetOnlineStatusEvent(this.status);

}

