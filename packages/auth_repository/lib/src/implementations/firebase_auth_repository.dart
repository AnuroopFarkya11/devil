import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository extends BaseAuthRepository{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  getUserData() {
    return _firebaseAuth.currentUser;
  }

  @override
  logOut() {
    _firebaseAuth.signOut();
  }

  @override
  Future<UserCredential> login(String username, String password) async {
    return _firebaseAuth.signInWithEmailAndPassword(email: username, password: password);
  }
}