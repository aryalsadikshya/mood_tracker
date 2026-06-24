import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProfile({
    String? username,
    String? avatarId,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged-in user found.");
    }

    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
    };

    // Save both username and name so every screen stays synchronized
    if (username != null && username.trim().isNotEmpty) {
      data["username"] = username.trim();
      data["name"] = username.trim();

      // Update Firebase Auth display name as well
      await user.updateDisplayName(username.trim());
    }

    if (avatarId != null && avatarId.trim().isNotEmpty) {
      data["avatarId"] = avatarId.trim();
    }

    await _firestore
        .collection("users")
        .doc(user.uid)
        .set(
      data,
      SetOptions(merge: true),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileData() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getProfileOnce() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No logged-in user found.");
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .get();
  }
}