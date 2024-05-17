class InvitationOwner {
  String onwerId;
  String? owenerEmail;
  String refrerenceInOwner;
  String refrenceInRider;
  String Status;
  String riderId;

  InvitationOwner({
    required this.onwerId,
    required this.riderId,
    this.owenerEmail,
    required this.Status,
    required this.refrerenceInOwner,
    required this.refrenceInRider,
  });
}
