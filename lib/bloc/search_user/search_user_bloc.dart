import 'package:chat/bloc/search_user/search_user_event.dart';
import 'package:chat/bloc/search_user/search_user_state.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final Socket _socket;
  SearchUserBloc(this._socket) : super(SearchUserInitialState());

  @override
  Stream<SearchUserState> mapEventToState(SearchUserEvent event) async* {
    if (event is SearchUsersEvent) {
      print(event.phoneNumber);
      //yield SearchUserLoadingState();
      _socket.emitWithAck('search-user', {'phone_no': event.phoneNumber},
          ack: (data) {
        print(data);
        if (data['status'] == 200) {
          add(SearchUserSuccessfulEvent(ConversationModel.fromJson(data["data"])));
        }
      });
    }

    if (event is SearchUserSuccessfulEvent) {
      yield SearchUserSuccessfulState(event.conversationModel);
    }
  }
}
