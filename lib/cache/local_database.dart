import 'package:chat/models/chat_message.dart';
import 'package:chat/models/conversation_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBManager {
  DBManager._internal() {
    HiveMethode().initState();
  }

  static final DBManager _dbManager = DBManager._internal();

  factory DBManager() {
    return _dbManager;
  }

  addMessage(ConversationModel log) => HiveMethode().addMessage(log);
  getMessages(int connectionId) => HiveMethode().getMessages(connectionId);
  List<Map<String, dynamic>> getAllMessages() => HiveMethode().getAllMessages();
}

class HiveMethode {
  String messageBox = "Message_Box";
  String friendsBox = "Friends_Box";

  void initState() async {
    print("Database Connection started");
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    // print(appDocumentDirectory.path);
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox(friendsBox);
    await Hive.openBox(messageBox);
    //final box = await Hive.openBox(friendsBox);
    //box.clear();
    print("database connected");
  }

  addMessage(ConversationModel conversation) async {
    final box = await Hive.openBox(messageBox);
    //List<dynamic> messages = [];
    var messages =
        await box.get(conversation.message.connectionId, defaultValue: null);
    // print("local database add message to DB");
    // print(message.content);
    Map messageJson = conversation.message.toJson();
    // print(messageJson);
    print('add message connection id');
    print(conversation.message.connectionId);
    if (messages != null) {
      messages.add(messageJson);
      await box.put(conversation.message.connectionId, messages);
      await updateLastMessage(conversation);
    } else {
      await box.put(conversation.message.connectionId, [messageJson]);
      await addToFriendsList(conversation);
    }
    
  }

  getMessages(int connectionId) async {
    print('connection id $connectionId');
    final box = await Hive.openBox(messageBox);
   // box.clear();

    var messages = box.get(connectionId, defaultValue: null);
    print("get all message using connection id");
    print(messages);
    if (messages == null) {
      return null;
    }
    return messages;
  }

  getAllMessages() async {
    final box = await Hive.openBox(messageBox);
  
    var messages = box.values;
    print("all messages");
    print(messages);
    return messages;
  }

  getAllFriends() async {
    final box = await Hive.openBox(friendsBox);
   
    var freinds = box.values;
    print("all friends");
    print(freinds);
    return freinds;
  }

  addToFriendsList(ConversationModel conversation) async {
    final box = await Hive.openBox(friendsBox);
    print(conversation.user.firstName);
    Map user = conversation.user.toJson();
    Map messageJson = conversation.message.toJson();
    int connectionId = conversation.connectionId;

    Map<String, dynamic> freind = {
      'user': user,
      'messages': messageJson,
      'connectionId': connectionId
    };
    await box.put(conversation.connectionId, freind);
  }

  updateLastMessage(ConversationModel conversation) async {
    print("on update message");
    final box = await Hive.openBox(friendsBox);
    var check = box.get(conversation.connectionId,defaultValue: "not found");
    print(conversation.connectionId);
    print(box.keys);
   
    Map user = box.get(conversation.connectionId)['user'];
    print(user);
    Map messageJson = conversation.message.toJson();
    int connectionId = conversation.connectionId;

    Map<String, dynamic> freind = {
      'user': user,
      'messages': messageJson,
      'connectionId': connectionId
    };
  

    await box.put(conversation.connectionId, freind);
  }
}
