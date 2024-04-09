import 'package:flutter/foundation.dart';
import 'package:safeer/screens/authenticate/register.dart';

enum UserTyp { owner, rider }

class UserProvider extends ChangeNotifier {
  String? uid;
  UserTyp userType = UserTyp.owner;
  UserProvider({this.uid});

  void updateUid(String? uid, UserTyp userType) {
    print('updateUid called');
    this.uid = uid;
    this.userType = userType;
    notifyListeners();
  }
}
