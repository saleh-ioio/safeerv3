import 'package:flutter/material.dart';
import 'package:safeer/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

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
                    print('valid');
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      {
                        print('error signing in');
                        setState(() {
                          error = 'Please supply a valid email';
                        });
                      }
                    } else {
                      print('Signed in');
                      print(result.uid);
                    }
                  }
                },
                child: Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
