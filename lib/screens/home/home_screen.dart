import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazali_chat/screens/home/chats_section.dart';
import 'package:gazali_chat/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _personLabel;

  @override
  void initState() {
    _handlePersonLabel(AuthService.user);
    AuthService.userStream.listen(_handlePersonLabel);
    FirestoreService.getUserChats(AuthService.user?.displayName ?? "");
    super.initState();
  }

  void _handlePersonLabel(User? user) {
    if (user == null) {
      setState(() {
        _personLabel = 'Sign In';
      });
    } else {
      setState(() {
        _personLabel = 'Profile';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.chat),
        title: const Text('Gazai Chat'),
      ),
      body: const ChatsSection(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthService.user == null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Not Authenticated',
                  ),
                  content: const Text(
                    'You must sign in before adding new chat.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pushNamed("/add-chat");
          }
        },
        child: const Icon(Icons.person_add_alt_1_sharp),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            if (value == 1) {
              if (_personLabel == null) {
                return;
              } else if (_personLabel == 'Profile') {
                Navigator.of(context).pushNamed('/profile');
              } else {
                Navigator.of(context).pushNamed('/sign-in');
              }
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: _personLabel ?? 'Sign In',
            ),
          ]),
    );
  }
}
