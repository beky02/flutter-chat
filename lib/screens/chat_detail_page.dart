import 'package:chat/bloc/send_message/send_message_bloc.dart';
import 'package:chat/bloc/send_message/send_message_event.dart';
import 'package:chat/bloc/send_message/send_message_state.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  final int id;
  final int connectionId;
  final String name;
  final String imgUrl;
  final List<ChatMessage> message;
  final bool onlineStatus;

  const ChatDetailPage(
      {@required this.id,
      @required this.connectionId,
      @required this.name,
      @required this.imgUrl,
      @required this.message,
      @required this.onlineStatus,
      Key key}): super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  int unSeenMessageCount = 0;
  bool lastMessageRendered = false;
  bool onlineStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messages = widget.message;
    onlineStatus = widget.onlineStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // print(_scrollController.position.maxScrollExtent);
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  animateToLastItem() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  updateLastMessageRenderedStatus() {
    setState(() {
      lastMessageRendered = true;
    });
    // print("object");
    // print(lastMessageRendered);
  }

  changeOnlineStatus(){
    setState(() {
      onlineStatus = !onlineStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            child: Row(children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 0),
              CircleAvatar(
                //backgroundImage: NetworkImage(widget.imgUrl),
                maxRadius: 22,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    onlineStatus == true ? Text(
                      "Online",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    )
                    : Text(
                      "last seen 2 min ago",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
      body: BlocConsumer<SendMessageBloc, SendMessageState>(
          listener: (context, state) {
        if (state is SendMessageSuccessfulState) {
          messages.add(state.message.message);
          setState(() {});

          animateToLastItem();
        }
        if (state is NewMessageArrivedState) {
          messages.add(state.message);
          setState(() {});

          animateToLastItem();
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.8 ,
                  child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                      ),
                      itemBuilder: (context, index) {
                        
                        if (messages[index] == messages.last) {
                          // updateLastMessageRenderedStatus();
                        }
                        if (messages[index].senderId ==
                            UserModel.userModel.id) {
                          return sentMessageAlignment(messages[index], size);
                        } else {
                          return recivedMessageAlignment(messages[index], size);
                        }
                      }),
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.width * 0.01),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                              hintText: "Write a message . . . ",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                              onChanged: (v){
                                BlocProvider.of<SendMessageBloc>(context).add(
                                  SendTypingEvent(widget.connectionId,widget.id)
                                );
                              },
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            BlocProvider.of<SendMessageBloc>(context).add(
                                SendNewMessageEvent(
                                    _controller.text.trim(), widget.id));
                            _controller.clear();
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ],
                  ),
                ))
          ],
        );
      }),
    );
  }

  Widget sentMessageAlignment(ChatMessage message, Size size) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.blue[200], borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
            )),
        constraints: BoxConstraints(maxWidth: size.width * 0.8),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget recivedMessageAlignment(ChatMessage message, Size size) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10)
            )),
        constraints: BoxConstraints(maxWidth: size.width * 0.8),
        child: Text(
          message.content,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
