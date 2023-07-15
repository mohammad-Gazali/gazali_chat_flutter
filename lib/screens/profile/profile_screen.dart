import 'package:flutter/material.dart';
import 'package:gazali_chat/screens/profile/placeholder_avatar.dart';
import 'package:gazali_chat/services/auth.dart';
import 'package:gazali_chat/shared/shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController =
      TextEditingController(text: AuthService.user?.displayName);
  bool _editMode = false;
  bool _isLoading = false;
  String _currentDisplayedName = AuthService.user?.displayName ?? "";

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _switchEditMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  void _updateName() async {
    // this is for dismissing the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      setState(() {
        _isLoading = true;
      });

      await AuthService.updateDisplayName(_displayNameController.text);

      setState(() {
        _currentDisplayedName = _displayNameController.text;
      });

      _switchEditMode();
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
                'Something went wrong!',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _signOut() async {
    try {
      setState(() {
        _isLoading = false;
      });

      await AuthService.signOut();

      if (context.mounted)
        Navigator.of(context).pushReplacementNamed("/sign-in");
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
                'Something went wrong!',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Personal Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            const PlaceholderAvatar(),
            const SizedBox(
              height: 20,
            ),
            if (_editMode)
              Column(
                children: [
                  CustomTextField(
                    controller: _displayNameController,
                    hintText: 'Name',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _displayNameController.text =
                                      AuthService.user?.displayName ?? '';
                                  _switchEditMode();
                                },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey.shade700),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading ? null : _updateName,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    _currentDisplayedName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _switchEditMode,
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
            const SizedBox(
              height: 42,
            ),
            OutlinedButton(
              onPressed: _isLoading ? null : _signOut,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Sign out'),
                ],
              ),
            ),
            const SizedBox(
              height: 56,
            ),
          ],
        ),
      ),
    );
  }
}
