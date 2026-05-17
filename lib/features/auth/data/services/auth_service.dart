import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:pfe/core/models/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get current user stream
  Stream<auth.User?> get userStream => _firebaseAuth.authStateChanges();

  // Get current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    String phone = '',
  }) async {
    try {
      // Create user in Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        // Create user model
        final newUser = User(
          id: firebaseUser.uid,
          fullName: fullName,
          email: email,
          phone: phone,
          profileImage: '',
          createdAt: DateTime.now(),
        );

        // Save to Realtime Database
        await _database.child('users').child(firebaseUser.uid).set(newUser.toJson());

        return newUser;
      }
    } catch (e) {
      rethrow; // You can implement custom error handling here if needed
    }
    return null;
  }

  // Login with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        // Fetch user data from Realtime Database
        final snapshot = await _database.child('users').child(firebaseUser.uid).get();

        if (snapshot.exists) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          return User.fromJson(data);
        } else {
          // If the user exists in auth but not in DB, we could handle it here
          // For now, return a basic User object
          return User(
            id: firebaseUser.uid,
            fullName: 'Unknown',
            email: firebaseUser.email ?? '',
            phone: '',
            profileImage: '',
            createdAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Fetch current user details from DB
  Future<User?> getCurrentUserDetails() async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final snapshot = await _database.child('users').child(uid).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return User.fromJson(data);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
