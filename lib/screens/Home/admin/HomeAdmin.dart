import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/auth.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () async {
              final result = await _auth.signOut();

              if (result == null) {
                context.read<UserProvider>().updateUid(result);
                print("signed out");
              } else {
                print(result.toString());
              }
            },
            child: Text("sign out"))
      ]),
    );
  }
}
