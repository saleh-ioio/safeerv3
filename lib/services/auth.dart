import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

// This class will be used to handle the authentication of the user
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  UserProvider _userFromFirebaseUser(User user) {
    return UserProvider(uid: user.uid, email: user.email);
  }

// auth change user stream
  Stream<UserProvider?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? _userFromFirebaseUser(user) : null;
    });
  }

  //reset password
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
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
      required UserTyp userType}) async {
    try {
      User? user;

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          result.user!.sendEmailVerification();
      user = result.user;

      if (userType == UserTyp.owner) {
        // owner
        DataBaseService(uid: user!.uid, email: email)
            .updateOnwerUserData(userName, email);
      }

      if (userType == UserTyp.rider) {
        // rider
        DataBaseService(uid: user!.uid, email: email)
            .updateRiderUserData(userName, email);
      }

      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //get if the user is verified or not
  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    return user!.emailVerified;
  }

// sign in with email and password
  Future signInWithEmailAndPassword(
      String email, String password, UserTyp userType) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      final isValidUser = await DataBaseService(uid: user!.uid, email: email)
          .checkUserExist(userType, email);
      print(isValidUser);
      if (isValidUser == false) {
        return null;
      }

      return _userFromFirebaseUser(user);
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
