class ChatRoom {
  final String chatRoomId;
  final dynamic users;
  final dynamic messages;
  final String lastMessage;
  final String updateAt;
  final String createAt;
  final dynamic target;

  ChatRoom(this.chatRoomId, this.users, this.messages, this.updateAt,
      this.createAt, this.lastMessage, this.target);
}
