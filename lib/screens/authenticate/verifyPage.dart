import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/authenticate.dart';
import 'package:safeer/services/auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    // a screen with text in center to verify email 
    return  Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Please verify your email'),
            ),
            TextButton(onPressed: () async{
              //check if the user has verified the email
              // if yes, navigate to the home page
              // if no, show the same screen
              context.read<UserProvider>().isEmailVerified = await _auth.isEmailVerified();
            }, child: const Text('Check Email')),
            // a button to logout
            TextButton(onPressed: () async{
               final result = await _auth.signOut();

                  if (result == null) {
                    Navigator.pop(context);
                    context
                        .read<UserProvider>()
                        .updateUid(result, UserTyp.owner);
                    print("signed out");
                  } else {
                    print(result.toString());
                  }
            }, child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}