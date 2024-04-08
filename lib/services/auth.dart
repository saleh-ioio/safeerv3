import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/authenticate/Register.dart';
import 'package:safeer/services/dataBase.dart';

// This class will be used to handle the authentication of the user
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserProvider _userFromFirebaseUser(User user) {
    return UserProvider(uid: user.uid);
  }

// auth change user stream
  Stream<UserProvider?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? _userFromFirebaseUser(user) : null;
    });
  }

// sign in anonnymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password
  Future registerWithEmailAndPassword(
      {required String email,
      required String userName,
      required String password,
      required int userType}) async {
    try {
      User? user;

      if (userType == 0) {
        // owner
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        user = result.user;
        DataBaseService(uid: user!.uid).updateOnwerUserData(userName, email);
      }

      if (userType == 1) {
        // rider
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        user = result.user;

        DataBaseService(uid: user!.uid).updateRiderUserData(userName, email);
      }

      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}
