import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kmeans/kmeans.dart';
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
    List<ClientOrder> ordersWithLocation = [];
    int numberOfClusters = 0;

    List<List<double>> ordersDouble = [];
    List<ClientOrder> orders = [];
    List<Marker> MarkerList = [];
    Clusters?  clusterInfo = null;



  @override
  Widget build(BuildContext context) {
    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;

    final _formKey = GlobalKey<FormState>();
   

    return Scaffold(
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
          ordersWithLocation = [];
          orders.forEach((element) {

            if (element.latitude != null &&
                element.longitude != null &&
                element.latitude != "" &&
                element.longitude != "") {
         
              ordersWithLocation.add(element);
            }
          });
          
            MarkerList = []; 
          MarkerList = ordersWithLocation
              .map((e) => Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(double.parse(e.latitude!), double.parse(e.longitude!)),
                    child:  Container(
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: clusterInfo == null? AppColors.darkergreen : AppColors.colorClusters[clusterInfo!.clusters[ordersWithLocation.indexOf(e)]] ,
                            size: 40,
                          ),
                          Text(e.clientName),
                        ],
                      ),
                    ),
                  ))
              .toList();

              

          

         
       

          return SingleChildScrollView(
            child: Form(
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
                 
                      numberOfClusters = int.parse(value);
                    },
                  ),
                  TextButton(onPressed: () {
                     
                      
                      if (_formKey.currentState!.validate()) {
                 
            
                         ordersDouble = ordersWithLocation
                            .map((e) => [double.parse(e.latitude!), double.parse(e.longitude!)])
                            .toList();
            
                        clusterInfo = KMeans(ordersDouble).fit(numberOfClusters);
            
                        
                        print(clusterInfo!.clusters);
            
                       
                        setState(() {});
                      }
                  }, child: Text('Start Clustring')),
                  ConstrainedBox(
                    constraints: BoxConstraints(
maxHeight:   MediaQuery.of(context).size.height * 0.7,
minHeight:  MediaQuery.of(context).size.height * 0.2,

                    ) ,
                    
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
            ),
          );
        },
      )]),
    );
  }

  
}
