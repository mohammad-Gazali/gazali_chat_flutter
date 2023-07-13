import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gazali_chat/firebase_options.dart';
import 'package:gazali_chat/routes.dart';
import 'package:google_fonts/google_fonts.dart';

// General Notes:
// to get SHA-1 certificate fingerprints for android write this command "keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android"

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gazali Chats',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          secondary: Colors.indigo,
        ),
        fontFamily: GoogleFonts.openSans().fontFamily,
        useMaterial3: true,
      ),
    );
  }
}
