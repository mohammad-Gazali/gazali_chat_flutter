import 'package:flutter/material.dart';
import 'package:gazali_chat/screens/screens.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const HomeScreen(),
  '/add-chat': (context) => const AddChatScreen(),
  '/sign-in': (context) => const SignInScreen(),
  '/register': (context) => const RegisterScreen(),
  '/profile': (context) => const ProfileScreen(),
};
