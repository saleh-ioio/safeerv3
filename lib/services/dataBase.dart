import 'package:cloud_firestore/cloud_firestore.dart';
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

    return await userDoc.update({
      'orders': FieldValue.arrayUnion([orderData])
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
  }

  Stream<DocumentSnapshot<Object?>> get orders {
    return userCollection.doc(uid).snapshots();
  }

  Future<QuerySnapshot<Object?>> searchDriverQuery({required String email}) {
    final result = riderCollection
        .where("name", isGreaterThanOrEqualTo: email)
        .where("name", isLessThanOrEqualTo: "${email}\uf7ff");
    return result.get();
  }
}
