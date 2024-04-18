class Invitationclient {
  String onwerId;
  String? owenerEmail;
  String refrerenceInOwner;
  String refrenceInRider;
  String Status;
  String riderId;

  Invitationclient({
    required this.onwerId,
    required this.riderId,
    this.owenerEmail,
    required this.Status,
    required this.refrerenceInOwner,
    required this.refrenceInRider,
  });
}
