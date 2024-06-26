import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeer/models/invetation.dart';
import 'package:safeer/models/mapVar.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/orderStages.dart';
import 'package:safeer/models/rider.dart';
import 'package:safeer/models/user.dart';

enum StatusEnum { pending, accepted, rejected }

class DataBaseServiceWithNoUser{

final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('owners-admins');

  final CollectionReference riderCollection =
      FirebaseFirestore.instance.collection('riders');


Future<bool?> checkUserExist(UserTyp userType, String email) async {
    if (userType == UserTyp.owner) {
      final result =
          await userCollection.where('email', isEqualTo: email).get();
      if (result.docs.isNotEmpty) {
        return true;
      } else {
        print('User does not exist');
        return false;
      }
    }

    if (userType == UserTyp.rider) {
      final result =
          await riderCollection.where('email', isEqualTo: email).get();
      if (result.docs.isNotEmpty) {
        return true;
      } else {
        print('User does not exist');
        return false;
      }
    }

    print('User Type is not valid');
    return false;
  }

Future<ClientOrder> getOrder({required String adminId, required String orderId}){
    return userCollection.doc(adminId).collection('orders').doc(orderId).get().then((value) => ClientOrder(
      id: value.id,
      clientName: value['clientName'] ?? '',
      address: value['address'] ?? '',
      phone: value['phone'] ?? '',
      locationLink: value['locationLink'] ?? '',
      paymentMethod: value['paymentMethod'] ?? '',
      totalPrice: value['totalPrice'] ?? 0.0,
      riderEmail: value['riderEmail'] ?? '',
      riderId: value['riderId'] ?? '',
      latitude: value['latitude'] ?? '',
      longitude: value['longitude'] ?? '',
      ConfirmationCode: value['ConfirmationCode'] ?? '',
    orderStatus: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${value['orderStatus']}', orElse: () => OrderStatus.StillInChina),
    ));
  }

}

class DataBaseService {
  final String uid;
  final String email;
  DataBaseService({required this.uid, required this.email});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('owners-admins');

  final CollectionReference riderCollection =
      FirebaseFirestore.instance.collection('riders');

//createds and updates the user data
  Future updateOnwerUserData(String userName, String email) async {
    return await userCollection.doc(uid).set({
      'name': userName,
      'email': email,
      'orders': [],
    });
  }

  Future updateRiderUserData(String userName, String email) async {
    return await riderCollection.doc(uid).set({
      'name': userName,
      'email': email,
      'orderId': [],
    });
  }



  Future updateInvetationStatus(
      {required String ownerId,
      required StatusEnum status,
      required String refrenceInrider,
      required String refrenceInOwner}) async {
    await userCollection
        .doc(ownerId)
        .collection('fleetTable')
        .doc(refrenceInOwner)
        .update({'status': status.name});
    await riderCollection
        .doc(uid)
        .collection('fleetTable')
        .doc(refrenceInrider)
        .update({'status': status.name});
  }

  

  Future addNewOrderData(String clientName, String? address, String phone,
      String? locationLink, String? paymentMethod, double? totalPrice,String confirmationCode, {Rider? rider, MapPin? pin, OrderStatus orderStatus = OrderStatus.StillInChina}) async {
    DocumentReference userDoc = userCollection.doc(uid);

    Map<String, dynamic> orderData = {
      'clientName': clientName,
      'address': address,
      'phone': phone,
      'locationLink': locationLink,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'riderId' : rider?.uid, 
      'riderEmail' : rider?.email,
      'longitude' : pin?.pin.longitude.degrees.toString(),
      'latitude' : pin?.pin.latitude.degrees.toString(),
      'orderStatus' : orderStatus.name,
      'ConfirmationCode' : confirmationCode,
      
    };

    final orderIdInAdmin = await userDoc.collection('orders').add(orderData);

    

    if(rider != null){
      Map<String, dynamic> orderDataRef = {
      'orderId': orderIdInAdmin.id,
      'adminId': uid, 
      'AdminEmail': email,
      };

    // final orderIdInrider = 
    await riderCollection.doc(rider.uid).collection('orders').add(orderDataRef);
    }
    // return await userDoc.update({
    //   'orders': FieldValue.arrayUnion([orderData])
    // });
  }

  //update existing order data
  Future updateOrderData(String orderId, String clientName, String? address, String phone,
      String? locationLink, String? paymentMethod, double? totalPrice, {Rider? rider, MapPin? pin, OrderStatus orderStatus = OrderStatus.StillInChina}) async {
    DocumentReference userDoc = userCollection.doc(uid);

    print(orderStatus.name);
    Map<String, dynamic> orderData = {
      'clientName': clientName,
      'address': address,
      'phone': phone,
      'locationLink': locationLink,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'riderId' : rider?.uid, 
      'riderEmail' : rider?.email,
      'longitude' : pin?.pin.longitude.degrees.toString(),
      'latitude' : pin?.pin.latitude.degrees.toString(),
      'orderStatus' : orderStatus.name,
      
      
    };

    final orderIdInAdmin = await userDoc.collection('orders').doc(orderId).update(orderData);

    

    if(rider != null){
      Map<String, dynamic> orderDataRef = {
      'orderId': orderId,
      'adminId': uid, 
      'AdminEmail': email,
      };

    // final orderIdInrider = 
    await riderCollection.doc(rider.uid).collection('orders').add(orderDataRef);
    }
    // return await userDoc.update({
    //   'orders': FieldValue.arrayUnion([orderData])
    // });
  }
// check if the passcode is correct
  Future<bool> checkPasscode({required String orderId, required String adminId, required String passcode}) async {
    final result = await userCollection.doc(adminId).collection('orders').doc(orderId).get();
    //if yes change the order status to complete order
if(result['ConfirmationCode'] == passcode){
  await userCollection.doc(adminId).collection('orders').doc(orderId).update({'orderStatus': OrderStatus.CompleteOrder.name});
  return true;
}
return false;

  }

  //converts a snopshot of orders to a list of orders

 List<ClientOrder> _OrdersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ClientOrder(
        id: doc.id,
        clientName: doc['clientName'] ?? '',
        address: doc['address'] ?? '',
        phone: doc['phone'] ?? '',
        locationLink: doc['locationLink'] ?? '',
        paymentMethod: doc['paymentMethod'] ?? '',
        totalPrice: doc['totalPrice'] ?? 0.0,
        latitude: doc['latitude'] ?? '',
        longitude: doc['longitude'] ?? '',
        riderId: doc['riderId'] ?? '',
        riderEmail: doc['riderEmail'] ?? '',
    orderStatus: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${doc['orderStatus']}', orElse: () => OrderStatus.StillInChina),
        
        
      );
    }).toList();
  }


  Future sendInvetation(
      {required String riderId, required String riderEmail}) async {
    final refrence = await userCollection
        .doc(uid)
        .collection('fleetTable')
        .add({
      'riderId': riderId,
      'status': StatusEnum.pending.name,
      'riderEmail': riderEmail
    });

    return await riderCollection.doc(riderId).collection('fleetTable').add({
      'ownerId': uid,
      'status': StatusEnum.pending.name,
      'ownerEmail': email,
      'refrence': refrence.id,
    });
  }

  Future<bool?> checkUserExist(UserTyp userType, String email) async {
    if (userType == UserTyp.owner) {
      final result =
          await userCollection.where('email', isEqualTo: email).get();
      if (result.docs.isNotEmpty) {
        return true;
      } else {
        print('User does not exist');
        return false;
      }
    }

    if (userType == UserTyp.rider) {
      final result =
          await riderCollection.where('email', isEqualTo: email).get();
      if (result.docs.isNotEmpty) {
        return true;
      } else {
        print('User does not exist');
        return false;
      }
    }

    print('User Type is not valid');
    return false;
  }

 

  

  //converts a snopshot of riders to a list of available riders
  List<Rider> _RidersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Rider(
      fleetTableId: doc.id,
      email: doc['riderEmail'] ?? '',
      status: doc['status'] ?? '',
      uid: doc['riderId'] ?? '',
      );
    }).toList();
  }


  //returns the list of Available Riders (accepted the invetation)
  Future<List<Rider>> getAvailableRiders() async {
    final result = await userCollection
        .doc(uid)
        .collection('fleetTable')
        .where('status', isEqualTo: StatusEnum.accepted.name)
        .get();
    return _RidersListFromSnapshot(result);
  }

  

  List<InvitationOwner> _InvetationsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return InvitationOwner(
        onwerId: doc['ownerId'] ?? '',
        Status: doc['status'] ?? '',
        owenerEmail: doc['ownerEmail'] ?? '',
        refrerenceInOwner: doc['refrence'] ?? '',
        refrenceInRider: doc.id,
        riderId: uid,
      );
    }).toList();
  }
// inveted riders


  Stream<List<InvitationOwner>> get invetations {
    print('get invetations called');
    final result = riderCollection
        .doc(uid)
        .collection('fleetTable')
        .snapshots()
        .map(_InvetationsListFromSnapshot);
    print(result);
    return result;
  }

  Stream<List<ClientOrder>> get orders {
    return userCollection
        .doc(uid)
        .collection('orders')
        .snapshots()
        .map(_OrdersListFromSnapshot);
  }

  //the same as get orders but instead of sream a future
  Future<List<ClientOrder>> getOrders() async {
    final result = await userCollection.doc(uid).collection('orders').get();
    return _OrdersListFromSnapshot(result);
  }

  Future<ClientOrder> getOrder({required String adminId, required String orderId}){
    return userCollection.doc(adminId).collection('orders').doc(orderId).get().then((value) => ClientOrder(
      id: value.id,
      clientName: value['clientName'] ?? '',
      address: value['address'] ?? '',
      phone: value['phone'] ?? '',
      locationLink: value['locationLink'] ?? '',
      paymentMethod: value['paymentMethod'] ?? '',
      totalPrice: value['totalPrice'] ?? 0.0,
    orderStatus: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${value['orderStatus']}', orElse: () => OrderStatus.StillInChina),
    ));
  }



  Future<QuerySnapshot<Object?>> searchDriverQuery({required String email}) {
    final result = riderCollection
        .where("name", isGreaterThanOrEqualTo: email)
        .where("name", isLessThanOrEqualTo: "${email}\uf7ff");
    return result.get();
  }

  Stream<List<dynamic>> ordersOnRider(){
    return riderCollection.doc(uid).collection('orders').snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }

  //list of Pending Riders invetations 
  Stream<List<InvitationOwner>> get pendingInvetations {
    final result = riderCollection
        .doc(uid)
        .collection('fleetTable')
        .where('status', isEqualTo: StatusEnum.pending.name)
        .snapshots()
        .map(_InvetationsListFromSnapshot);
    return result;
  }

  //list of pending invetations for the owner
  Stream<List<Rider>> get allRidersInFleet {
    final result = userCollection
        .doc(uid)
        .collection('fleetTable')
        .snapshots()
        .map(_RidersListFromSnapshot);
    return result;
  }
}

