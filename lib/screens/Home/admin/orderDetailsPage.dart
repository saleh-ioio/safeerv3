// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:safeer/models/appColors.dart';
import 'package:safeer/services/dataBase.dart';

class orderDetails extends StatefulWidget {
  final String adminUid;
  final String orderId;
  const orderDetails({
    Key? key,
    required this.adminUid,
    required this.orderId,
  }) : super(key: key);

  @override
  State<orderDetails> createState() => _orderDetailsState();
}

class _orderDetailsState extends State<orderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Order Details : ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: DataBaseServiceWithNoUser().getOrder(
              adminId: widget.adminUid, orderId: widget.orderId),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return LoadingAnimationWidget.dotsTriangle(color: AppColors.darkergreen, size: 20);
            }
            if (snapshot.hasError) {
              return const Text("error", style: TextStyle(color: AppColors.red),);
            }
            return Column(
            children: [
              Text('Client Name: ${snapshot.data!.clientName}'),
              Text('Address: ${snapshot.data!.address}'),
              Text('Phone: ${snapshot.data!.phone}'),
              Text('Location Link: ${snapshot.data!.locationLink}'),
              Text('Payment Method: ${snapshot.data!.paymentMethod}'),
              Text('Total Price: ${snapshot.data!.totalPrice}'),
          
            ],
              );
          }, 
        )));
  }
}