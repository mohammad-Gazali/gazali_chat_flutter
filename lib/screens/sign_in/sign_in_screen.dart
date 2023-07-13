import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazali_chat/services/auth.dart';
import 'package:gazali_chat/shared/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FocusManager.instance.primaryFocus?.unfocus();

      await AuthService.login(
          email: _emailController.text, password: _passwordController.text);

      if (context.mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            content: Text(
              err.message ?? "Something went wrong!",
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
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FocusManager.instance.primaryFocus?.unfocus();

      await AuthService.googleLogin();

      if (context.mounted) Navigator.of(context).pop();
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
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
            bottom: 0,
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 140,
              ),
              const Text(
                'Sign in',
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            Navigator.of(context)
                                .pushReplacementNamed('/register');
                          },
                    child: Text(
                      'Regsiter',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
              ),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: _isLoading ? null : _signIn,
                child: const Text('Sign in'),
              ),
              OutlinedButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          'assets/goolge_logo.png',
                          width: 24,
                        ),
                      )
                    else
                      Image.asset(
                        'assets/goolge_logo.png',
                        width: 24,
                      ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text('Sign in with Google'),
                  ],
                ),
              ),
              const SizedBox(
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
