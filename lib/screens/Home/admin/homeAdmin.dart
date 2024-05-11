import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/addDriverManage.dart';
import 'package:safeer/screens/Home/admin/orderpage.dart';
import 'package:safeer/services/auth.dart';
import 'package:safeer/services/dataBase.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

enum onwerPages { orders, fleetManagement, analytics, settings }

class _HomeAdminState extends State<HomeAdmin> {
  onwerPages selectedPage = onwerPages.orders;

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;
    return Scaffold(
      backgroundColor: AppColors.primary,
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Admin"),
                accountEmail: Text(email!),
              ),
              ListTile(
                title: Text("Orders"),
                onTap: () {
                  setState(() {
                    selectedPage = onwerPages.orders;
                  });
                },
              ),
              ListTile(
                title: Text("Fleet Management"),
                onTap: () {
                  setState(() {
                    // selectedPage = onwerPages.fleetManagement;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddDriverPage()));
                  });
                },
              ),
              ListTile(
                title: Text("Analytics"),
                onTap: () {
                  setState(() {
                    selectedPage = onwerPages.analytics;
                  });
                },
              ),
              ListTile(
                  title: Text("Sign Out"),
                  onTap: () async {
                    final result = await _auth.signOut();

                    if (result == null) {
                      context
                          .read<UserProvider>()
                          .updateUid(result, UserTyp.owner);
                      print("signed out");
                    } else {
                      print(result.toString());
                    }
                  }),
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(selectedPage.name, style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold
          ),),
          actions: [],
        ),
        body: orderList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.green,
          onPressed: () async {
            final listOfAvailableRiders =
                await DataBaseService(uid: uid!, email: email!)
                    .getAvailableRiders();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderPage(
                        listOfAvailableRiders: listOfAvailableRiders)));
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
