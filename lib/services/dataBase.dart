import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/user.dart';

class DataBaseService {
  final String uid;
  DataBaseService({required this.uid});

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

  Future updateOrderData(String clientName, String address, String phone,
      String locationLink, String paymentMethod, double totalPrice) async {
    DocumentReference userDoc = userCollection.doc(uid);

    Map<String, dynamic> orderData = {
      'clientName': clientName,
      'address': address,
      'phone': phone,
      'locationLink': locationLink,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
    };

    await userDoc.collection('orders').add(orderData);

    // return await userDoc.update({
    //   'orders': FieldValue.arrayUnion([orderData])
    // });
  }

  Future sendInvetation(String riderId) async {
    await userCollection
        .doc(uid)
        .collection('invitations')
        .add({'riderId': riderId, 'status': 'pending'});

    return await riderCollection
        .doc(riderId)
        .collection('invitations')
        .add({'OwnerId': uid, 'status': 'pending'});
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
      );
    }).toList();
  }

  Stream<List<ClientOrder>> get orders {
    return userCollection
        .doc(uid)
        .collection('orders')
        .snapshots()
        .map(_OrdersListFromSnapshot);
  }

  Future<QuerySnapshot<Object?>> searchDriverQuery({required String email}) {
    final result = riderCollection
        .where("name", isGreaterThanOrEqualTo: email)
        .where("name", isLessThanOrEqualTo: "${email}\uf7ff");
    return result.get();
  }
}
