import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:safeer/models/user.dart';
import 'package:safeer/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({
    Key? key,
    required this.toggleView,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  email = val;
                  setState(() {});
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {});
                  password = val;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result =
                        await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Could not sign in with those credentials';
                      });
                    } else {
                      print('signed in');
                      print(result.uid);

                      context.read<UserProvider>().updateUid(result.uid);
                      widget.toggleView();
                    }
                  }
                },
                child: Text('Sign in'),
              ),
              TextButton(
                onPressed: () {
                  widget.toggleView();
                },
                child: Text('Create a new account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
