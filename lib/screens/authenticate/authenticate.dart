import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/HomeAdmin.dart';
import 'package:safeer/screens/authenticate/Register.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/services/auth.dart';

class authenticate extends StatefulWidget {
  const authenticate({super.key});

  @override
  State<authenticate> createState() => _authenticateState();
}

class _authenticateState extends State<authenticate> {
  final AuthService _auth = AuthService();

  // index's : true for sign in, false for register
  bool isSignIn = true;

  void toggleView() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn
        ? SignIn(
            toggleView: toggleView,
          )
        : Register(toggleView: toggleView);
  }

  Widget annonymouslySignIn() {
    return Scaffold(
      body: Column(children: [
        Text('authenticate'),
        TextButton(
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null) {
                print('error signing in');
              } else {
                context.read<UserProvider>().updateUid(result.uid);
                print('signed in');
                print(result.uid);
              }
            },
            child: Text("annonymous sign in")),
      ]),
    );
  }
}
