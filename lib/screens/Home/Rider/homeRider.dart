import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/Rider/menageOwners.dart';
import 'package:safeer/screens/Home/Rider/ordersWidget.dart';
import 'package:safeer/services/auth.dart';

class HomeRiderPage extends StatefulWidget {
  const HomeRiderPage({super.key});

  @override
  State<HomeRiderPage> createState() => _HomeRiderPageState();
}

enum DriverPages { Profile, currentOrders, CompletedOrders, MenageOwner, stats }

class _HomeRiderPageState extends State<HomeRiderPage> {
  DriverPages selectedPage = DriverPages.Profile;
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
            accountName: Text("Driver"),
            accountEmail: Text(email!),
          ),
          
          Container(
            color: selectedPage == DriverPages.currentOrders
                ? AppColors.primary
                : null,
            child: ListTile(
              title: Text("Current Orders",style: TextStyle( color: selectedPage == DriverPages.currentOrders ? AppColors.darkgreen :AppColors.black )),
              onTap: () {
                setState(() {
                  // selectedPage = onwerPages.fleetManagement;
                  Navigator.pop(context);
                  selectedPage = DriverPages.currentOrders;
                });
              },
            ),
          ),
          Container(
            color: selectedPage == DriverPages.CompletedOrders
                ? AppColors.primary
                : null,
            child: ListTile(
              title: Text("Completed Orders",style: TextStyle( color: selectedPage == DriverPages.CompletedOrders ? AppColors.darkgreen :AppColors.black )),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  selectedPage = DriverPages.CompletedOrders;
                });
              },
            ),
          ),
          Container(
            color: selectedPage == DriverPages.MenageOwner
                ? AppColors.primary
                : null,
            child: ListTile(
              title: Text("Menage Owners" ,style: TextStyle( color: selectedPage == DriverPages.MenageOwner ? AppColors.darkgreen :AppColors.black ) ,),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  selectedPage = DriverPages.MenageOwner;
                });
              },
            ),
          ),
          Container(
            color: selectedPage == DriverPages.stats ? AppColors.primary : null,
            child: ListTile(
              title: Text("Stats", style: TextStyle( color: selectedPage == DriverPages.stats ? AppColors.darkgreen :AppColors.black ) ),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  selectedPage = DriverPages.stats;
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
                        .updateUid(result, UserTyp.rider);
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

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      drawer: DrawerBuild(user.email),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          selectedPage.name,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          selectedPage == DriverPages.Profile
              ? Container()
              : selectedPage == DriverPages.currentOrders
                  ? ordersList()
                  : selectedPage == DriverPages.CompletedOrders
                      ? Container()
                      : selectedPage == DriverPages.MenageOwner
                          ? MenageOwner()
                          : selectedPage == DriverPages.stats
                              ? Container()
                              : ordersList()
        ],
      ),
      bottomNavigationBar: selectedPage == DriverPages.MenageOwner ? BottomNavigationBar(items: 
      [
        BottomNavigationBarItem(icon: Icon(Icons.group_add), label: "Add Owners"),
        BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: "Menage Owners"),
      ],) : null,
    );
  }
}
