import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_repository/src/auth/interfaces/interfaces.dart';

class AuthRepository extends BaseAuthRepository{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? getCurrentUser() => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification(User user) {
    return user.sendEmailVerification();
  }

  @override
  bool isEmailVerified(User user) {
    return user.emailVerified;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> signInWithCustomToken(String token) {
    return _firebaseAuth.signInWithCustomToken(token);
  }

  @override
  Future<UserCredential> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.linkWithCredential(credential);
    }
    throw FirebaseAuthException(
      code: 'no-current-user',
      message: 'No current user to link credentials with.',
    );
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.reauthenticateWithCredential(credential);
    }
    throw FirebaseAuthException(
      code: 'no-current-user',
      message: 'No current user to re-authenticate.',
    );
  }

  @override
  Future<void> updatePassword(User user, String newPassword) {
    return user.updatePassword(newPassword);
  }

  @override
  Future<void> updateEmail(User user, String newEmail) {
    return user.verifyBeforeUpdateEmail(newEmail);
  }

  @override
  Future<void> deleteUser(User user) {
    return user.delete();
  }
}