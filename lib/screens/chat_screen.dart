import 'package:chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/bloc/chat_bloc/chat_event.dart';
import 'package:chat/bloc/chat_bloc/chat_state.dart';
import 'package:chat/bloc/search_user/search_user_bloc.dart';
import 'package:chat/cache/local_database.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/search_screen/search_screen.dart';
import 'package:chat/socket/socket.dart';
import 'package:chat/widgets/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //List<Map<String,dynamic>> users;
  List<ConversationModel> users;

  static List<ChatMessage> messages;

  List<Map<String, dynamic>> dbConversations;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = [];
    messages = [];

    // BlocProvider.of<ChatBloc>(context).add(GetFriendsEvent(page: 1, limit: 5));

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //print(dbMessages);

    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
        if (state is SuccessFulFetchedFriendsState) {
          users = state.friends;

          setState(() {});
        }
        if (state is NewTypingState) {}
      }, builder: (context, state) {
        return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Conversations",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 28)),
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.add,
                              color: Colors.pink,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>
                                    SearchUserBloc(SocketConnection().socket),
                                child: SearchScreen(),
                              )));
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text("Search...",
                            style: TextStyle(color: Colors.grey.shade600))
                      ],
                    )),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box("Friends_Box").isOpen
                    ? Hive.box("Friends_Box").listenable()
                    : Hive.openBox("Friends_Box")
                        .then((value) => Hive.box("Friends_Box").listenable()),
                builder: (
                  context,
                  Box freindsBox,
                  _,
                ) {
                  print("value lisn");

                  List friendsList = freindsBox.values.toList();
                  print(friendsList);
                  return ListView.builder(
                      itemCount: friendsList.length,
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Conversation(
                            conversationModel: ConversationModel.fromDynamic(
                                friendsList[index]));
                      });
                }),
          ]),
        );
      }),
    );
  }
}
