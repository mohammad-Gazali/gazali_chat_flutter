import 'package:flutter/material.dart';
import 'package:gazali_chat/screens/screens.dart';
import 'package:gazali_chat/services/services.dart';
import 'package:gazali_chat/shared/shared.dart';

class ChatsSection extends StatefulWidget {
  const ChatsSection({super.key});

  @override
  State<ChatsSection> createState() => _ChatsSectionState();
}

class _ChatsSectionState extends State<ChatsSection> {
  @override
  void initState() {
    AuthService.userStream.listen((event) {
      // rebuild the widget after changing auth state
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (AuthService.user == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Sign in to start chat with other people.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FittedBox(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/sign-in');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 6),
                  Text("Sign in"),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return FutureBuilder(
      future: FirestoreService.getUserChats(AuthService.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var chats = snapshot.data!;

          if (chats.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "There is no chats.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/add-chat");
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 6),
                            Text("Add New Chat"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              children: chats.map((chat) {
                var avatarLetter = "";
                if (AuthService.user?.uid == chat.user1.id) {
                  if (chat.user2.name.isEmpty) {
                    avatarLetter = "G";
                  } else {
                    avatarLetter = chat.user2.name[0].toUpperCase();
                  }
                } else {
                  if (chat.user1.name.isEmpty) {
                    avatarLetter = "G";
                  } else {
                    avatarLetter = chat.user1.name[0].toUpperCase();
                  }
                }

                return Hero(
                  tag: chat.id,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        avatarLetter,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      AuthService.user?.uid == chat.user1.id
                          ? chat.user2.name
                          : chat.user1.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      AuthService.user?.uid == chat.user1.id
                          ? chat.user2.email
                          : chat.user1.email,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chat: chat,
                            messagesStream:
                                FirestoreService.messageCollectionStream(
                                    chat.id),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const ErrorMessage();
        }
      },
    );
  }
}
