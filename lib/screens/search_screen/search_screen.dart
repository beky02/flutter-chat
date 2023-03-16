import 'package:chat/bloc/search_user/search_user_bloc.dart';
import 'package:chat/bloc/search_user/search_user_event.dart';
import 'package:chat/bloc/search_user/search_user_state.dart';
import 'package:chat/bloc/send_message/send_message_bloc.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/screens/chat_detail_page.dart';
import 'package:chat/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  List<ConversationModel> users;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    users = [];
  }

  @override
  Widget build(BuildContext context) {
    print("check");
    print(SocketConnection().socket.connected);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Flexible(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                    ),
                    onSubmitted: (v) {
                      BlocProvider.of<SearchUserBloc>(context)
                          .add(SearchUsersEvent(v.trim()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocConsumer<SearchUserBloc, SearchUserState>(
          listener: (context, state) {
        if (state is SearchUserSuccessfulState) {
          print("users");
          print(state.conversationModel.user);
          setState(() {
            users.add(state.conversationModel);
          });
        }
      }, builder: (context, state) {
        if (state is SearchUserLoadingState) {
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
          );
        }
        return Container(
          child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider<SendMessageBloc>(
                                  create: (context) => SendMessageBloc(),
                                  child: ChatDetailPage(
                                    id: users[index].user.id,
                                    name: users[index].user?.firstName +
                                        ' ' +
                                        users[index].user?.lastName,
                                    imgUrl: users[index].user?.lastName,
                                    message: [],
                                  ),
                                )));
                  },
                  leading: CircleAvatar(
                    maxRadius: 22,
                  ),
                  title: Text("${users[index].user?.firstName} ${users[index].user?.lastName}"),
                  subtitle: Text(users[index].user?.phoneNumber ?? ""),
                );
              }),
        );
      }),
    );
  }
}
