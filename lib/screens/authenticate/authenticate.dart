import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/register.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/screens/welcomePage.dart';
import 'package:safeer/services/auth.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final firstEnter = true;
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

    // if(firstEnter){
    // return welcomePage();
    // }
    
    return
    isSignIn
        ? SignIn(
            toggleView: toggleView,
          )
        : Register(toggleView: toggleView);
  }

  Widget annonymouslySignIn() {
    return Scaffold(
      body: Column(children: [
        const Text('authenticate'),
        TextButton(
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null) {
                print('error signing in');
              } else {
                context
                    .read<UserProvider>()
                    .updateUid(result.uid, UserTyp.owner);
                print('signed in');
                print(result.uid);
              }
            },
            child: const Text("annonymous sign in")),
      ]),
    );
  }
}
