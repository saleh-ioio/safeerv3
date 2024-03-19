import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/HomeAdmin.dart';
import 'package:safeer/screens/authenticate/anonnymousSignIn.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().uid;
    return user == null ? const authenticate() : const HomeAdmin();
  }
}
