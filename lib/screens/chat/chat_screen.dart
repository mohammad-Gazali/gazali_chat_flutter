import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazali_chat/screens/chat/message.dart';
import 'package:gazali_chat/services/auth.dart';
import 'package:gazali_chat/services/firestore.dart';
import 'package:gazali_chat/services/models.dart';
import 'package:gazali_chat/shared/shared.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    try {
      await FirestoreService.addMessageDocument(
        chatId: widget.chat.id,
        senderId: AuthService.user!.uid,
        text: _messageController.text,
      );
      _messageController.clear();
    } catch (e) {
      // TODO: handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          AuthService.user?.uid == widget.chat.user1.id
              ? widget.chat.user2.name
              : widget.chat.user1.name,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService.messageCollectionStream(widget.chat.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                if (snapshot.hasError) {
                  return ErrorMessage(
                    message: snapshot.error.toString(),
                  );
                }

                if (!snapshot.hasData) {
                  return ErrorMessage(
                    message: snapshot.error.toString(),
                  );
                }

                if (snapshot.data?.size == 0) {
                  return Container();
                }

                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ListView(
                    children: [
                      ...snapshot.data!.docs.map((DocumentSnapshot doc) {
                        var id = doc.id;
                        var messageData = doc.data()! as Map<String, dynamic>;

                        messageData['id'] = id;

                        var message = Message.fromJson(messageData);

                        if (message.senderId == AuthService.user!.uid) {
                          return SentMessage(message: message);
                        } else {
                          return ReceivedMessage(message: message);
                        }
                      }).toList(),
                      const SizedBox(height: 52),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Write a message...",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 26,
                ),
                IconButton.filled(
                  onPressed: _sendMessage,
                  iconSize: 32,
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
