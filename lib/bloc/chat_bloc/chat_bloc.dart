import 'package:chat/bloc/chat_bloc/chat_event.dart';
import 'package:chat/bloc/chat_bloc/chat_state.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/socket/socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketConnection _socketConnection = SocketConnection();
  ChatBloc() : super(InitialChatState()) {
    _socketConnection.chatBlocStreem.listen((event) {
      if (event.containsKey('typing')) {
        add(GetTypingEvent(event['typing']));
      }
      if (event.containsKey('onlineStatus')) {
        add(GetOnlineStatusEvent(event['onlineStatus']));
      }
    });
  }

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is GetFriendsEvent) {
      _socketConnection.socket.emitWithAck(
          'get-friends', {'page': event.page, 'limit': event.limit},
          ack: (data) {
        print("get-friends");
        print(data);
        if (data['status'] == 200) {
          add(SuccessFulFetchedFriendsEvent(data));
        }
      });
    }

    if (event is SuccessFulFetchedFriendsEvent) {
      yield SuccessFulFetchedFriendsState(List.from(
          event.friends['data'].map((x) => ConversationModel.fromJson(x))));
    }

    if (event is GetTypingEvent) {
      yield NewTypingState(event.tying);
    }
    if (event is GetOnlineStatusEvent) {
      yield NewOnlineStatusState(event.status);
    }
  }
}
