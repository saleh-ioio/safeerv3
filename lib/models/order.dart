class ClientOrder {
  final String id;
  final String clientName;
  final String address;
  final String phone;
  final String locationLink;
  final String paymentMethod;
  final double totalPrice;

  ClientOrder(
      {required this.id,
      required this.clientName,
      required this.address,
      required this.phone,
      required this.locationLink,
      required this.paymentMethod,
      required this.totalPrice});
}
