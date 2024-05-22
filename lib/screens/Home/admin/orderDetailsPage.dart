// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/orderStages.dart';
import 'package:safeer/models/rider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/Rider/orderConfirmationPage.dart';
import 'package:safeer/screens/Home/admin/orderEditPage.dart';
import 'package:safeer/screens/Home/admin/orderFormpage.dart';
import 'package:safeer/services/dataBase.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
  OrderStatus selectedStatus = OrderStatus.StillInChina;
  @override
  Widget build(BuildContext context) {
    Widget detailWidget(
        {required String textType,
        required String text,
        required IconData icon,
        double fontsizeText = 18,
        bool moveDown = false,
        bool copyIcon = false
        }) {
      return Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(icon, color: AppColors.darkergreen, size: 30)),

              Text(textType,
                  style: const TextStyle(
                      color: AppColors.darkergreen, fontSize: 18)),

              
                Expanded(
                  child: Text(text,
                      style:  TextStyle(color: AppColors.black, fontSize: fontsizeText )
                      ,overflow: TextOverflow.ellipsis,),
                ),
                copyIcon? IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to Clipboard')));
                  },
                  icon: const Icon(Icons.copy),
                  color: AppColors.darkergreen,
                ): Container(),
                    
              
              SizedBox(width: 15)
            ],
          ));
    }

    Widget CustDivider() {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30), child: Divider());
    }

    final UserTyp user = context.read<UserProvider>().userType;
    return Scaffold(
        backgroundColor: AppColors.primary,
        floatingActionButton: user == UserTyp.owner? FloatingActionButton(
          onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => EditOrderPage(adminUid: widget.adminUid, orderId: widget.orderId)));
          },
          child: const Icon(Icons.edit),
          backgroundColor: AppColors.darkergreen,
        ): FloatingActionButton(onPressed: () {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => OrderConfirmationPage(adminId: widget.adminUid, orderId: widget.orderId))
          );
        }, child: const Icon(Icons.check), backgroundColor: AppColors.yellow,),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Order Details : ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: FutureBuilder(
            future: DataBaseServiceWithNoUser()
                .getOrder(adminId: widget.adminUid, orderId: widget.orderId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingAnimationWidget.dotsTriangle(
                    color: AppColors.darkergreen, size: 50);
              }
              if (snapshot.hasError) {
                return const Text(
                  "error",
                  style: TextStyle(color: AppColors.red),
                );
              }
          
             OrderStatus selectedStatus = snapshot.data!.orderStatus!;
              
              
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.darkergreen),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    detailWidget(textType: "Rider Email: ", text: snapshot.data!.riderEmail?? "", icon: Icons.delivery_dining),
                    detailWidget(
                        icon: Icons.account_box_outlined,
                        textType: "Client Name: ",
                        text: snapshot.data!.clientName),
                    CustDivider(),
                    detailWidget(
                        icon: Icons.location_on_outlined,
                        textType: "Client Address: ",
                        text: snapshot.data!.address),
                    CustDivider(),
                    detailWidget(
                        icon: Icons.map_sharp,
                        textType: "LocationLink: ",
                        text: snapshot.data!.locationLink,
                        copyIcon: true
                        ),
                    CustDivider(),
                    detailWidget(textType: "Order PassCode", text: snapshot.data!.ConfirmationCode!, icon: Icons.lock, copyIcon: true),
                    CustDivider(),
                    detailWidget(
                        icon: Icons.phone_android_outlined,
                        textType: "Client Phone: ",
                        text: snapshot.data!.phone,
                        copyIcon: true),
                    CustDivider(),
                    detailWidget(
                        icon: Icons.payment_outlined,
                        textType: "Payment Method:",
                        text: snapshot.data!.paymentMethod),
                    CustDivider(),
                    detailWidget(
                        icon: Icons.phone_android_outlined,
                        textType: "Total Price:",
                        text: snapshot.data!.totalPrice.toString()),
                    CustDivider(),
                    context.read<UserProvider>().userType == UserTyp.owner? Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.darkergreen),
          
                      color: AppColors.lightyellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:
                      TextButton(
                        onPressed: () {
                          //copy to clipboard the link that the client will use to input his location
                          Clipboard.setData(ClipboardData(text: 'https://salehalsaleh0.github.io/safeerWeb1/dist/index.html?adminId=${widget.adminUid}&orderId=${widget.orderId}'));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link Copied to Clipboard')));
                        },
                        child: const Text("Client Web link", style: TextStyle(color: AppColors.darkergreen, fontSize: 18),),
                      )
                    
                    ): Container()
                    ,
                    // Step Indicator
           Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
             child: StepProgressIndicator(
                  totalSteps: OrderStatus.values.length,
                  currentStep: OrderStatus.values.indexOf(selectedStatus) + 1,
                  size: 80,
                  selectedColor: AppColors.lightGreen,
                  unselectedColor: AppColors.lightyellow,
                  customStep: (index, color, _) {
                    return Container(
                      color: color,
                      child: Center(
                        child: Text(
                          OrderStatus.values[index].toString().split('.').last.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}'),
          
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    );
                  }
                ),
           )
                  ],
                ),
              );
            },
          )),
        ));
  }
}
