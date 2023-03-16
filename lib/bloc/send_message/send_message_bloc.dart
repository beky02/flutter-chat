import 'dart:async';

import 'package:chat/bloc/send_message/send_message_event.dart';
import 'package:chat/bloc/send_message/send_message_state.dart';
import 'package:chat/cache/local_database.dart';
import 'package:chat/socket/socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final SocketConnection _socketConnection = SocketConnection();
  SendMessageBloc() : super(SendMessageInitialState()) {
    _socketConnection.sendMessageBlocStreem.listen((event) {
      if (event.containsKey('send-message-response')) {
        add(SendNewMessageSuccessfulEvent(event['send-message-response']));
      } else {
        add(NewMessageArrivedEvent(event['new-message']));
      }
    });
  }

  @override
  Stream<SendMessageState> mapEventToState(SendMessageEvent event) async* {
    if (event is SendNewMessageEvent) {
      _socketConnection.sendMessage(event.content, event.receiverId);
    }

    if (event is SendTypingEvent) {
      _socketConnection.sendTypingStatus(event.connectionId, event.receiverId);
    }

    if (event is SendNewMessageSuccessfulEvent) {
      // print("on send message bloc add sent message to DB ");

      yield SendMessageSuccessfulState(event.message);
    }
    if (event is SendNewMessageFailedEvent) {
      yield SendMessageFailedState();
    }
    if (event is NewMessageArrivedEvent) {
      print("called on send message ");
      yield NewMessageArrivedState(event.message.message);
    }
  }
}
