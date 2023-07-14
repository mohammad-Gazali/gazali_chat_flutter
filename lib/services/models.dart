import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazali_chat/typedefs.dart';

class Chat {
  final String id;
  final User user1;
  final User user2;

  Chat({
    required this.id,
    required this.user1,
    required this.user2,
  });

  Chat.fromJson(JsonType data)
      : id = data["id"],
        user1 = User.fromJson(data["user1"]),
        user2 = User.fromJson(data["user2"]);
}

class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  User.fromJson(JsonType data)
      : id = data["id"],
        name = data["name"],
        email = data["email"];

  JsonType toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
    };
  }
}

class UserWithChats {
  final String id;
  final String name;
  final String email;

  /// usersChats contains ids of users that he has chat with
  ///
  /// I made the type of usersChats List<dynamic> instead of List<String> becasue of strange error with dart where I can't convert List<dynamic> to List<String>
  final List<dynamic> usersChats;

  const UserWithChats({
    required this.id,
    required this.email,
    required this.name,
    required this.usersChats,
  });

  UserWithChats.fromJson(JsonType data)
      : id = data["id"],
        email = data["email"],
        name = data["name"],
        usersChats = data["users_chats"];

  User toUser() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final Timestamp createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  Message.fromJson(JsonType data)
      : id = data["id"],
        senderId = data["sender_id"],
        text = data["text"],
        createdAt = data["created_at"];
}
