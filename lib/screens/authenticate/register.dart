// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/services/auth.dart';

class Register extends StatefulWidget {
  final UserTyp userType;
  const Register({
    Key? key,
    required this.userType,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String username = '';
  String error = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              TextFormField(
                decoration:const  InputDecoration(
                  hintText: 'Email',
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  email = val;
                  setState(() {});
                },
              ),
              TextFormField(
                decoration: const  InputDecoration(
                  hintText: 'UserName',
                ),
                validator: (val) => val!.isEmpty ? 'Enter a UserName' : null,
                onChanged: (val) {
                  username = val;
                  setState(() {});
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
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
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email: email,
                        userName: username,
                        password: password,
                        userType: widget.userType);
                    if (result == null) {
                      {
                        print('error signing in');
                        setState(() {
                          error = 'Please supply a valid email';
                        });
                      }
                    } else {
                      print('signed in');
                      print(result.uid);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignIn(usertype: widget.userType)),
                      );
                    }
                  }
                },
                child: Text('Register'),
              ),
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignIn(usertype: widget.userType)),
                  );
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
