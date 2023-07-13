import 'package:flutter/material.dart';
import 'package:gazali_chat/services/auth.dart';
import 'package:gazali_chat/services/firestore.dart';
import 'package:gazali_chat/services/models.dart';
import 'package:gazali_chat/shared/shared.dart';

class AddChatScreen extends StatefulWidget {
  const AddChatScreen({super.key});

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  List<UserWithChats> _allUser = [];
  UserWithChats? _selectedUser;
  bool _isLoading = false;
  String? _error;

  _addChat() async {
    try {
      var currentUser = User(
        id: AuthService.user!.uid,
        name: AuthService.user!.displayName ?? "",
        email: AuthService.user!.email ?? "",
      );

      setState(() {
        _isLoading = true;
      });

      await FirestoreService.addChatDocument(
        user1: _selectedUser!.toUser(),
        user2: currentUser,
      );

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed("/");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Chat Added Successfully 🎉"),
          ),
        );
      }
    } catch (_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            content: Text(
              "Something went wrong!",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    FirestoreService.getAllUsersDocuments()
        .then(
          (fetchingResult) => setState(
            () {
              var currentUser = fetchingResult.firstWhere(
                (user) => user.id == AuthService.user!.uid,
              );

              fetchingResult.remove(currentUser);

              // assigning _allUser state and filtering all users we have chats with them
              _allUser = fetchingResult
                  .where(
                    (user) => !user.usersChats.any(
                      (userId) => userId.toString() == currentUser.id,
                    ),
                  )
                  .toList();
            },
          ),
        )
        .catchError(
          (e) => setState(() {
            _error = e.toString();
          }),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Add Chat'),
        ),
        body: ErrorMessage(message: _error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Chat'),
      ),
      body: _allUser.isEmpty
          ? const LoadingScreen()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 140,
                  ),
                  Text(
                    _selectedUser == null
                        ? 'Search the email you want to make chat with.'
                        : 'Selected user',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: _selectedUser == null ? 52 : 26,
                  ),
                  if (_selectedUser == null)
                    Autocomplete<UserWithChats>(
                      onSelected: (user) {
                        setState(() {
                          _selectedUser = user;
                        });
                      },
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable.empty();
                        }
                        return _allUser.where(
                          (user) => user.email.contains(textEditingValue.text),
                        );
                      },
                      displayStringForOption: (user) => user.email,
                    )
                  else ...[
                    Card(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            _selectedUser!.email,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedUser = null;
                                        });
                                      },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: _isLoading ? null : _addChat,
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    const SizedBox(
                      height: 52,
                    )
                  ],
                ],
              ),
            ),
    );
  }
}
