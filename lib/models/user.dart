import 'package:flutter/foundation.dart';

enum UserTyp { owner, rider }

class UserProvider extends ChangeNotifier {
  String? uid;
  String? email;
  UserTyp userType = UserTyp.owner;
  UserProvider({this.uid, this.email});

  void updateUid(String? uid, UserTyp userType, {String? email}) {
    print('updateUid called');
    this.uid = uid;
    this.email = email;
    this.userType = userType;
    notifyListeners();
  }
}
