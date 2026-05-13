import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mood_model.dart';

class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user logged in");
    }

    return user.uid;
  }

  Future<void> addMood(MoodModel mood) async {
    await _firestore
        .collection("users")
        .doc(_uid)
        .collection("moods")
        .add(mood.toMap());
  }

  Stream<List<MoodModel>> getMoods() {
    return _firestore
        .collection("users")
        .doc(_uid)
        .collection("moods")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => MoodModel.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }
}