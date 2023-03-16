import 'package:chat/models/chat_message.dart';
import 'package:chat/models/user_model.dart';

class ConversationModel {
  UserModel user;
  ChatMessage message;
  int connectionId;

  ConversationModel({this.user, this.message, this.connectionId});

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        user: json['user'] == null ? null : UserModel.fromJson(json['user']),
        message: json['message'] == null
            ? null
            : ChatMessage.fromJson(json['message']),
        connectionId: json['connection_id'],
      );


      factory ConversationModel.fromDynamic(Map<dynamic, dynamic> json) => ConversationModel(
     
      user: UserModel.fromDynamic(json['user']),
      message: ChatMessage.fromDynamic(json['messages']),
      connectionId: json['connectionId'],
      );
}


