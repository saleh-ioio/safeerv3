import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Maps',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Center(
          child: FutureBuilder(
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
          print("catting around the orders");
          List<ClientOrder> orders = snapshot.data as List<ClientOrder>;
          
       List<ClientOrder> ordersWithLocation =[];
          orders.forEach((element) { print( element.latitude); 

          if(element.latitude != null && element.longitude != null && element.latitude != "" && element.longitude != ""){
            print('${element.latitude}, ${element.longitude} ${element.clientName}');
            ordersWithLocation.add(element);
          }}
          
          );

          print(ordersWithLocation.length);
          return FlutterMap(
              options: MapOptions(
                  initialCenter: LatLng(31.9491529, 35.9181175),
                  initialZoom: 16),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', another look for the map
                  userAgentPackageName: 'safeer',
                ),
                 MarkerLayer(
                        markers: [
                          for (var i = 0; i < ordersWithLocation.length; i++)
                            Marker(
                              width: 45.0,

                              height: 45.0,
                              point: LatLng(double.parse(ordersWithLocation[i].latitude!),
                                  double.parse(ordersWithLocation[i].longitude!)),
                              child: IconButton(
                                icon: Icon(Icons.location_on),
                                color: AppColors.darkergreen,
                                iconSize: 45.0,
                                onPressed: () {
                                  print('Marker tapped');
                                },
                              ),
                            ),
                        ],
                      )
                    
              ]);
        },
      )),
    );
  }
}
