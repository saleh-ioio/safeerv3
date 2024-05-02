import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/chooseUserTypePage.dart';
import 'package:safeer/screens/authenticate/register.dart';
import 'package:safeer/screens/authenticate/signIn.dart';
import 'package:safeer/screens/welcomePage.dart';
import 'package:safeer/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  SharedPreferences? prefs;

  
  final AuthService _auth = AuthService();

  // index's : true for sign in, false for register
  bool isSignIn = true;
  UserTyp? usertype = null; // 0 for owner and 1 for rider

// toggle between sign in and register pages
  void toggleBtwSignInAndRegister() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  void skipWelcomePage() {
    setState(() {
      prefs!.setBool('firstEnter', false);
    });
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initPrefs(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return  Scaffold(body:  Center(child: CircularProgressIndicator()));
        }else{

        if (snapshot.hasError) {
          return 
          ChooseUserTypePage();
        }


        if (snapshot.connectionState == ConnectionState.done) {
          if (prefs!.getBool('firstEnter') == null ||
              prefs!.getBool('firstEnter') == true) {
            return welcomePage(
              toggleView: skipWelcomePage,
            );
          }else{
          print('success');
          print(prefs!.getBool('firstEnter'));
          return ChooseUserTypePage( resetWelcomePage: (){
            setState(() {
              prefs!.setBool('firstEnter', true);
            });
          },);


          }
        }else{ 
          return ChooseUserTypePage();
        }
      }}
    );
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
