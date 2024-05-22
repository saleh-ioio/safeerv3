import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/manageDriver.dart';
import 'package:safeer/screens/Home/admin/maps.dart';
import 'package:safeer/screens/Home/admin/orderDetailsPage.dart';
import 'package:safeer/screens/Home/admin/orderFormpage.dart';
import 'package:safeer/services/auth.dart';
import 'package:safeer/services/dataBase.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

enum onwerPages { CurrentOrders, CompletedOrders, fleetManagement, analytics, settings }

class _HomeAdminState extends State<HomeAdmin> {
  onwerPages selectedPage = onwerPages.CurrentOrders;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    appBarBuild(String? uid, String? email) {
      return AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          selectedPage.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final listOfAvailableRiders =
                    await DataBaseService(uid: uid!, email: email!)
                        .getAvailableRiders();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(
                      listOfAvailableRiders: listOfAvailableRiders,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add)),
        
        ],
      );
    }

    void openBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: DraggableScrollableSheet(
            shouldCloseOnMinExtent: true,
            minChildSize: 0.1,
            initialChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return GestureDetector(
                onTap:
                    () {}, // Prevent the GestureDetector above from dismissing the sheet when tapping on the sheet itself
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: FlutterMap(
                    options: MapOptions(),
                    children: [],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;
    return
        //  Stack(
        //   children:[
        Scaffold(
      floatingActionButton: selectedPage == onwerPages.CurrentOrders ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapsPage()));
        },
        child: Icon(Icons.map),
      ): null,
      backgroundColor: AppColors.primary,
      drawer: DrawerBuild(email),
      appBar: appBarBuild(uid, email),
      body: selectedPage == onwerPages.CurrentOrders
          ? orderList()
          : selectedPage == onwerPages.fleetManagement
              ? const AddDriverPage()
              : Container(),
      bottomNavigationBar: selectedPage != onwerPages.fleetManagement
          ? null
          : null
    );
  }

  Widget DrawerBuild(String? email) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.green),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            accountName: Text("Admin"),
            accountEmail: Text(email!),
          ),
          Container(
            color: selectedPage == onwerPages.CurrentOrders ? AppColors.primary : null,
            child: ListTile(
              title: Text("Current Orders"),
              onTap: () {
                setState(() {
                  selectedPage = onwerPages.CurrentOrders;
                  Navigator.pop(context);
                });
              },
            ),
          ),
Container(
            color: selectedPage == onwerPages.CompletedOrders ? AppColors.primary : null,
            child: ListTile(
              title: Text("Completed Orders"),
              onTap: () {
                setState(() {
                  selectedPage = onwerPages.CompletedOrders;
                  Navigator.pop(context);
                });
              },
            ),
          ),
          Container(
            color: selectedPage == onwerPages.fleetManagement
                ? AppColors.primary
                : null,
            child: ListTile(
              title: Text("Fleet Management"),
              onTap: () {
                setState(() {
                  // selectedPage = onwerPages.fleetManagement;
                  Navigator.pop(context);
                  selectedPage = onwerPages.fleetManagement;
                });
              },
            ),
          ),
          Container(
            color:
                selectedPage == onwerPages.analytics ? AppColors.primary : null,
            child: ListTile(
              title: Text("Analytics"),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  selectedPage = onwerPages.analytics;
                });
              },
            ),
          ),
          Container(
            child: ListTile(
                title: Text("Sign Out", style: TextStyle(color: AppColors.red)),
                onTap: () async {
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
                }),
          ),
        ],
      ),
    );
  }

  Widget orderList({bool isCompleted = false}) {
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
            shrinkWrap: true,
            itemBuilder: (context, index) {

              return Container(
                  margin: EdgeInsets.only(top: 7, left: 2, right: 2),
                  // color: AppColors.offWhite,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.lightGreen, width: 2),
                  ),
                  child: Ink(
                    color: AppColors.offWhite,
                    child: InkWell(
                      onTap: () async{
                        final order = orders[index];

                       
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => orderDetails(orderId: order.id,adminUid: uid , )));
                      },
                      splashColor: AppColors.lightGreen,
                      child: Container(
                        child: ListTile(
                          leading: Container(
                              child: Icon(
                            Icons.person,
                            size: 30,
                          )),
                          title: Text(orders[index].clientName),
                          subtitle: Text(orders[index].address),
                          trailing: Column(children: [
                            Text(
                              orders[index].paymentMethod,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(orders[index].totalPrice.toString()),
                            Text(orders[index].orderStatus!.name.toString())
                          ]),
                        ),
                      ),
                    ),
                  ));
            },
          );
        } else {
          return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.darkergreen, size: 40));
        }
      },
    );
  }
}
