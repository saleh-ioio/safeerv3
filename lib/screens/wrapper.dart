import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/Rider/homeRider.dart';
import 'package:safeer/screens/Home/admin/homeAdmin.dart';
import 'package:safeer/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().uid;
    final userType = context.watch<UserProvider>().userType;
    print("user: $user");

    if (user == null) {
      return const Authenticate();
    } else {
      if (userType == UserTyp.owner) {
        return const HomeAdmin();
      } else {
        return const HomeRiderPage();
      }
    }
  }
}
