import 'dart:async';

import 'package:chat/cache/local_database.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/utls/url.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketConnection {
  Socket socket;
  final _chatBlocController = StreamController<Map>.broadcast();
  final _sendMessageBlocController =
      StreamController<Map<String, ConversationModel>>.broadcast();
  StreamSink<Map> get chatBlocSink => _chatBlocController.sink;
  Stream<Map> get chatBlocStreem => _chatBlocController.stream;

  StreamSink<Map<String, ConversationModel>> get sendMessageBlocSink =>
      _sendMessageBlocController.sink;
  Stream<Map<String, ConversationModel>> get sendMessageBlocStreem =>
      _sendMessageBlocController.stream;

  SocketConnection._internal() {
    socket = io(
      socketAddress + '?token=' + UserModel.userModel.token,
      OptionBuilder()
          .setTransports(['websocket'])
          .setTimeout(3000)
          .enableAutoConnect()
          .disableReconnection()
          .build(),
    )
      ..connect()..
      onConnecting((data) => print('connecting'))
      ..onConnect((_) {
        print('connected');
        //sinks.add("connected stream");
      });
    socket.on("receive-new-message", (data) {
      print("*********************** new message **************************");
      print(data);
      newMessageArrived(ConversationModel.fromJson(data));
    });

    socket.on('receive-typing', (data) {
      print("=====------==== recived typing status ======-------=====");
      print(data);
      typingRecieved(data);
    });

    socket.on('receive-online', (data) {
      print("=====------==== recived online status ======-------=====");
      print(data);
      updateOnlineStatus(data);
    });
  }

  static final SocketConnection _socketConnection =
      SocketConnection._internal();

  factory SocketConnection() {
    print(_socketConnection.socket.connected);

    return _socketConnection;
  }

  void newMessageArrived(ConversationModel message) {
    DBManager().addMessage(message);
    //chatBlocSink.add(message);
    sendMessageBlocSink.add({'new-message': message});
  }

  void typingRecieved(Map typing) {
   // DBManager().addMessage(message);
    chatBlocSink.add({'typing': typing });
  }

  void updateOnlineStatus(Map status) {
   // DBManager().addMessage(message);
    chatBlocSink.add({'onlineStatus': status });
  }

  void sendMessage(String content, int receiverId) {
    socket.emitWithAck(
        'send-new-message', {'content': content, 'receiver_id': receiverId},
        ack: (data) {
      print("========= send new message response ==============");
      print(data);
      if (data['status'] == 201) {
        DBManager().addMessage(ConversationModel.fromJson(data['data']));
        sendMessageBlocSink.add({
          'send-message-response': ConversationModel.fromJson(data['data'])
        });
      }
    });
  }

  void sendTypingStatus(int connectionId, int receiverId) {
    socket.emit(
      'send-typing',
      {'connection_id': connectionId, 'receiver_id': receiverId},
    );
  }

  void dispose() {
    _chatBlocController.close();
    _sendMessageBlocController.close();
  }
}
