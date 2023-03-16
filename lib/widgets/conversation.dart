import 'package:chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/bloc/chat_bloc/chat_state.dart';
import 'package:chat/bloc/send_message/send_message_bloc.dart';
import 'package:chat/cache/local_database.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat_detail_page.dart';
import 'package:chat/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Conversation extends StatefulWidget {
  final ConversationModel conversationModel;

  Conversation({@required this.conversationModel});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  bool showTypingIndicatore = false;
  bool onlineStatus = false;

  @override
  void initState() {
    super.initState();
  }

  void showTyping() {
    if (!showTypingIndicatore) {
      setState(() {
        showTypingIndicatore = true;
      });
    }

    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        showTypingIndicatore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
      if (state is NewTypingState) {
        if (state.typing["connection_id"] ==
            widget.conversationModel.connectionId) {
          print("on converstion");
          print(state);
          showTyping();
        }
      }
      if (state is NewOnlineStatusState) {
        if (state.status['connection_id'] ==
            widget.conversationModel.connectionId) {
          setState(() {
            onlineStatus = state.status['online'];
          });
        }
      }
    }, builder: (context, snapshot) {
      return GestureDetector(
        onTap: () async {
          // print(widget.messages);
          List<ChatMessage> messages = [];

          var message = await DBManager()
              .getMessages(widget.conversationModel.connectionId);
          // print("message");
          // print(message);
          if (message != null) {
            message.forEach((element) {
              messages.add(ChatMessage.fromDynamic(element));
            });
          }
          //print(messages.length);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider<SendMessageBloc>(
                        create: (context) => SendMessageBloc(),
                        child: ChatDetailPage(
                          id: widget.conversationModel.user.id,
                          connectionId: widget.conversationModel.connectionId,
                          name: widget.conversationModel.user.firstName +
                              " " +
                              widget.conversationModel.user.lastName,
                          imgUrl: '',
                          message: messages,
                          onlineStatus: onlineStatus,
                        ),
                      )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.width * 0.02),
          child: Row(children: [
            Stack(
              children: [
                CircleAvatar(
                  //backgroundImage: NetworkImage('https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.capitalethiopia.com%2Fwp-content%2Fuploads%2F2019%2F02%2Ffrehiwot-tamiru.jpg&imgrefurl=https%3A%2F%2Fwww.capitalethiopia.com%2Ffeatured%2Fethio-telecom-to-invest-in-the-financial-sector%2F&tbnid=4HjG1-iskwlcCM&vet=12ahUKEwj_8uGq-_vvAhWJ_IUKHZqlAXcQMygbegUIARDwAQ..i&docid=iG6m81i8RqcxhM&w=1500&h=1000&q=ethio%20image&ved=2ahUKEwj_8uGq-_vvAhWJ_IUKHZqlAXcQMygbegUIARDwAQ'),
                  maxRadius: 26,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: onlineStatus ? Colors.green : Colors.grey[200],
                        shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.conversationModel.user.firstName +
                          " " +
                          widget.conversationModel.user.lastName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(children: [
                      if (UserModel.userModel.id ==
                          widget.conversationModel.message.senderId)
                        Icon(Icons.check),
                        SizedBox(width:4),
                      Text(
                        "Today",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 12,
                            fontWeight: widget.conversationModel.message.seen
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ])
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                showTypingIndicatore
                    ? Text('typing . . .')
                    : Text(
                        widget.conversationModel.message.content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: widget.conversationModel.message.seen
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
              ],
            )),
          ]),
        ),
      );
    });
  }
}
