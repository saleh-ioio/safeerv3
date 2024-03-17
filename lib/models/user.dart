import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String? uid = null;
  UserProvider({this.uid});

  void updateUid(String? uid) {
    this.uid = uid;
    notifyListeners();
  }
}
