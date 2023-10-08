import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  _signUp() async {
    final response = await Supabase.instance.client.auth.signUp(
        password: _passwordController.text,
        email: _emailController.text,
        phone: _phoneNumberController.text);

    if (response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Sign up successful! Check your email for the confirmation link.')),
      );
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
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
          TextField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _signUp,
            child: const Text('Sign Up'),
          ),
        ]),
      ),
    );
  }
}
