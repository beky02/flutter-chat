class ChatMessage {
  int id;
  int senderId;
  int connectionId;
  String content;
  bool seen;

  ChatMessage(
      {this.id, this.senderId, this.connectionId, this.content, this.seen});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      connectionId: json['connection_id'],
      content: json['content'],
      seen: json['seen']);
factory ChatMessage.fromDynamic(Map<dynamic, dynamic> json) => ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      connectionId: json['connectionId'],
      content: json['content'],
      seen: json['seen']);
      
      Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "senderId": senderId == null ? null : senderId,
        "connectionId": connectionId == null ? null : connectionId,
        "content": content == null ? null : content,
        "seen": seen == null ? null : seen,
    };
}
