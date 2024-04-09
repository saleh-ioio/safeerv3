import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/Order.dart';
import 'package:safeer/services/auth.dart';
import 'package:safeer/services/dataBase.dart';

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
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () async {
                  final result = await _auth.signOut();

                  if (result == null) {
                    context
                        .read<UserProvider>()
                        .updateUid(result, UserTyp.owner);
                    print("signed out");
                  } else {
                    print(result.toString());
                  }
                },
                child: const Text("sign out"))
          ],
        ),
        body: orderList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrderPage()));
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget orderList() {
    final uid = context.watch<UserProvider>().uid;

    if (uid == null) {
      return Container(
        child: const Center(
          child: Text("No Orders"),
        ),
      );
    }
    return StreamBuilder(
      stream: DataBaseService(uid: uid).orders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!['orders'];
          if (orders == null) {
            return const Center(
              child: Text("No Orders"),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(orders[index]['clientName']),
                subtitle: Text(orders[index]['address']),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
