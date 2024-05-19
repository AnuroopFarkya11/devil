import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository{
  // Stream to listen to authentication state changes
  Stream<User?> authStateChanges();

  // Get the current user
  User? getCurrentUser();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);

  // Register a new user with email and password
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password);

  // Sign out the current user
  Future<void> signOut();

  // Send email verification
  Future<void> sendEmailVerification(User user);

  // Check if the user's email is verified
  bool isEmailVerified(User user);

  // Send a password reset email
  Future<void> sendPasswordResetEmail(String email);

  // Sign in with a custom token
  Future<UserCredential> signInWithCustomToken(String token);

  // Sign in anonymously
  Future<UserCredential> signInAnonymously();

  // Link additional credentials to the current user
  Future<UserCredential> linkWithCredential(AuthCredential credential);

  // Re-authenticate the user
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential);

  // Update the user's password
  Future<void> updatePassword(User user, String newPassword);

  // Update the user's email
  Future<void> updateEmail(User user, String newEmail);

  // Delete the current user
  Future<void> deleteUser(User user);
}