import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/Orderpage.dart';
import 'package:safeer/screens/Home/admin/addDriverManage.dart';
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDriverPage()));
                },
                child: const Text("Add Driver",
                    style: TextStyle(color: Colors.white))),
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
                child: const Text("sign out",
                    style: TextStyle(color: Colors.white)))
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
    final email = context.watch<UserProvider>().email;

    if (uid == null) {
      return Container(
        child: const Center(
          child: Text("No Orders"),
        ),
      );
    }
    return StreamBuilder<List<ClientOrder>>(
      stream: DataBaseService(uid: uid, email: email!).orders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data as List<ClientOrder>?;
          if (orders == null) {
            return const Center(
              child: Text("No Orders"),
            );
          }
          if (orders.length == 0) {
            return const Center(
              child: Text("No Orders"),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(orders[index].clientName),
                subtitle: Text(orders[index].address),
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
