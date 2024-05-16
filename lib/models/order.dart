// ignore_for_file: public_member_api_docs, sort_constructors_first
class ClientOrder {
  final String id;
  final String clientName;
  final String address;
  final String phone;
  final String locationLink;
  final String paymentMethod;
  final double totalPrice;
  final String? riderId;
  final String? riderEmail;
  final String? longitude;
  final String? latitude;
   int? cluster;
  
  ClientOrder({
    required this.id,
    required this.clientName,
    required this.address,
    required this.phone,
    required this.locationLink,
    required this.paymentMethod,
    required this.totalPrice,
    this.riderId,
    this.riderEmail,
    this.longitude,
    this.latitude,
    this.cluster,
  });


}
