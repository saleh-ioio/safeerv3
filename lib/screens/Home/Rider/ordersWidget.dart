import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/orderStages.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/orderDetailsPage.dart';
import 'package:safeer/services/dataBase.dart';

class ordersList extends StatefulWidget {
  final bool? isCurrentOrders;
  const ordersList({super.key, this.isCurrentOrders = true});

  @override
  State<ordersList> createState() => _ordersListState();
}

class _ordersListState extends State<ordersList> {
  @override
  Widget build(BuildContext context) {
    final uid = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;

    return StreamBuilder(
      stream: DataBaseService(email: email!, uid: uid!).ordersOnRider(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final orders = snapshot.data as List<dynamic>;
          //filter only orders that are not completed
          
          return ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: DataBaseService(email: email, uid: uid).getOrder(
                      adminId: orders[index]['adminId'],
                      orderId: orders[index]['orderId']),
                  builder: (context, result) {
                    print(result.data);
                    if (result.hasData) {
                      final order = result.data as ClientOrder;

                      if (widget.isCurrentOrders == true &&
                          order.orderStatus!.name == OrderStatus.CompleteOrder.name) {
                        return Container();
                      }
                      return Container(
                        margin: EdgeInsets.only(top: 7, left: 2, right: 2),
                        decoration: BoxDecoration(
                          color: AppColors.offWhite,
                          border:
                              Border.all(color: AppColors.lightGreen, width: 2),
                        ),
                        child: Ink(
                          color: AppColors.offWhite,
                          child: InkWell(
                            splashColor: AppColors.lightGreen,
                            onTap: () {
                              
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => orderDetails(  orderId: orders[index]['orderId'] , 
                              adminUid: orders[index]['adminId'],  )));
                            },
                            child: ListTile(
                              title: Text(order.clientName),
                              subtitle: Text(order.address),
                              trailing: Column(
                                children: [
                                  Text(order.totalPrice.toString()),
                                  Text(order.orderStatus!.name.toString())
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  });
            },
          );
        }
        return SizedBox(height: 100, child: CircularProgressIndicator());
      },
    );
  }
}
