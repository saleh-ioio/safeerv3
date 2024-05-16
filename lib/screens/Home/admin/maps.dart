import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kmeans/kmeans.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({
    super.key,
  });

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
    List<ClientOrder> ordersWithLocation = [];
  @override
  Widget build(BuildContext context) {
    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;

    final _formKey = GlobalKey<FormState>();
    int numberOfClusters = 0;

    List<List<double>> ordersDouble = [];
    List<ClientOrder> orders = [];
    List<Marker> MarkerList = [];
    // List<ClientOrder> clusteredOrders = [];
    bool filtered = false;

    Widget DrawerMap() {
      return Drawer(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.darkgreen,
                ),
                child: Text(
                  'Map Clustering',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Number of Clusters'),
                    prefixIcon: Icon(Icons.analytics),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of clusters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    print(value);
                    numberOfClusters = int.parse(value);
                  },
                ),
              ),
              // ListTile(
              ListTile(
                title: TextButton(
                  onPressed: () {
                    print('Start Clustring');
                    if (_formKey.currentState!.validate()) {
                      print('valid');
                      
                      print(numberOfClusters);

                      
                      ordersWithLocation = [];
                     
                      orders.forEach((element) {
                        print(element.latitude);

                        if (element.latitude != null &&
                            element.longitude != null &&
                            element.latitude != "" &&
                            element.longitude != "") {
                          ordersWithLocation.add(element);
                          print(
                              '${element.latitude}, ${element.longitude} ${element.clientName} ${element.cluster} hello world');
                        }
                      });

                      ordersDouble = ordersWithLocation
                          .map((e) => [
                                double.parse(e.latitude!),
                                double.parse(e.longitude!)
                              ])
                          .toList();

                      final clusters =
                          KMeans(ordersDouble).fit(numberOfClusters).clusters;

                      // for (var i = 0; i < clusters.length; i++) {
                      //   ordersWithLocation[i].cluster = clusters[i];
                      //   clusteredOrders.add(ordersWithLocation[i]);
                      // }

                      setState(() {});

                      ordersWithLocation.forEach((element) {
                        print(
                            '${element.latitude}, ${element.longitude} ${element.clientName} ${element.cluster} hello world ');
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Start Clustring'),
                ),
              ),
              ListTile(
                title: Text(' exit maps page'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      // drawer: DrawerMap(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Maps',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
          children:[ FutureBuilder(
        future: DataBaseService(uid: uid!, email: email!).getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingAnimationWidget.bouncingBall(
              size: 50,
              color: AppColors.yellow,
            );
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          orders = snapshot.data as List<ClientOrder>;
          
          orders.forEach((element) {
            print(element.latitude);

            if (element.latitude != null &&
                element.longitude != null &&
                element.latitude != "" &&
                element.longitude != "") {
              // print(
              //     '${element.latitude}, ${element.longitude} ${element.clientName} ');
              ordersWithLocation.add(element);
            }
          });
          

         
          // final ordersDouble = ordersWithLocation
          //     .map((e) =>
          //         [double.parse(e.latitude!), double.parse(e.longitude!)])
          //     .toList();
          // ordersWithLocation.forEach((element) {});

          // ordersDouble.forEach((element) {
          //   print(element);
          // });
          // final clustered = KMeans(
          //   ordersDouble,
          // ).fit(3);
          // for (var i = 0; i < clustered.clusters.length; i++) {
          //   ordersWithLocation[i].cluster = clustered.clusters[i];
          // }

          return Form(
            key: _formKey,
            child: Column(
              
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Number of Clusters'),
                    prefixIcon: Icon(Icons.analytics),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of clusters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    print(value);
                    numberOfClusters = int.parse(value);
                  },
                ),
                TextButton(onPressed: () {
                   
                    print('Start Clustring');
                    if (_formKey.currentState!.validate()) {
                     
                    }
                }, child: Text('Start Clustring')),
                SizedBox(height: MediaQuery.of(context).size.height * 0.7,
                  child: FlutterMap(
                      options: MapOptions(
                          initialCenter: LatLng(31.9491529, 35.9181175),
                          initialZoom: 13),
                      children: [
                        
                  
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                          //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', another look for the map
                          userAgentPackageName: 'safeer',
                        ),
                        MarkerLayer(
                          markers: MarkerList,
                        )
                      ]),
                ),
              ],
            ),
          );
        },
      )]),
    );
  }

  
}
