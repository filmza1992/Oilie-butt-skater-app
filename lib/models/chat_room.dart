class ChatRoom {
  final String chatRoomId;
  final dynamic users;
  final dynamic messages;
  final String updateAt;
  final String createAt;

  ChatRoom(this.chatRoomId, this.users, this.messages, this.updateAt, this.createAt);
}
