import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // listen for auth state changes to automatically redirect to home after sign up
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  _login() async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response.user != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Log In'),
          ),
          const Spacer(),
          const Text('Don\'t have an account?'),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/signup');
            },
            child: const Text('Sign Up'),
          ),
        ]),
      ),
    );
  }
}
