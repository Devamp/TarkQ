import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tark_q/services/data-access.dart';

class UserServices {
  // Private constructor
  UserServices._privateConstructor();

  DocumentSnapshot? userData;
  int ticketIdx = 0;

  // The single instance
  static final UserServices _instance = UserServices._privateConstructor();

  static UserServices get instance => _instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth changes (e.g. user login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  static final DataAccess dataAccess = DataAccess.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool?> verifyUserVerification() async {
    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      _auth.currentUser?.delete();
      await dataAccess.delete(_auth.currentUser!.email!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String userEmail) async {
    try {
      await _auth.sendPasswordResetEmail(email: userEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDisplayRaidTickets(
    String userEmail, [
    Map<String, String>? filters,
  ]) async {
    try {
      if (filters == null || filters.isEmpty) {
        return await dataAccess.getDisplayRaidTickets(userEmail);
      } else {
        return await dataAccess.getDisplayRaidTickets(userEmail, filters);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserRaidTickets(
    String userEmail,
  ) async {
    try {
      return await dataAccess.getUserRaidTickets(userEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserTicket(String userEmail, String ticketDocId) async {
    try {
      return await dataAccess.deleteUserTicket(userEmail, ticketDocId);
    } catch (e) {
      rethrow;
    }
  }

  // Sign up with email & password
  Future<UserCredential> signUpUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      // create user with email and password
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // add user to firestore
      await dataAccess.createUser(email, username);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Login with email & password
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<void> loadUserOnLogin() async {
    try {
      userData = await dataAccess.getUserData(_auth.currentUser!.email);
    } catch (e) {
      rethrow;
    }
  }

  String getUsername() {
    userData?.data() as Map<String, dynamic>?;

    final String? username = userData?['username'] as String?;

    if (username != null) {
      return username;
    }

    throw Exception('Failed to get username');
  }

  int getNumRaidTickets() {
    userData?.data() as Map<String, dynamic>?;

    final int? numRaidTickets = userData?['numRaidTickets'] as int?;

    if (numRaidTickets != null) {
      return numRaidTickets;
    }

    throw Exception('Failed to get username');
  }

  String getUserEmail() {
    userData?.data() as Map<String, dynamic>?;

    final String? email = userData?['email'] as String?;

    if (email != null) {
      return email;
    }

    throw Exception('Failed to get email');
  }

  Future<void> updateUserAchievements(
    String userEmail,
    List<String?> achievements,
  ) async {
    return await dataAccess.updateUserAchievements(userEmail, achievements);
  }

  Future<List<String?>> getUserAchievements(String email) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    final data = doc.data();
    if (data != null && data['achievements'] is List) {
      return List<String>.from(data['achievements']);
    }

    return [];
  }
}
