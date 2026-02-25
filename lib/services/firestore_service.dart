import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry_model.dart';
import '../models/challenge_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Users Collection
  CollectionReference get _usersCollection => _firestore.collection('users');

  // 🔹 Moods Collection
  CollectionReference get _moodsCollection => _firestore.collection('moods');

  // 🔹 Challenges Collection
  CollectionReference get _challengesCollection =>
      _firestore.collection('challenges');

  /// 🔹 Fetch single user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// 🔹 Update / Add User
  Future<void> setUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  /// 🔹 Add Mood Entry
  Future<void> addMoodEntry(MoodEntryModel moodEntry) async {
    await _moodsCollection.add(moodEntry.toMap());
  }

  /// 🔹 Get Mood Entries for a user
  Future<List<MoodEntryModel>> getUserMoods(String uid) async {
    final snapshot = await _moodsCollection
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            MoodEntryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  /// 🔹 Add Challenge
  Future<void> addChallenge(ChallengeModel challenge) async {
    await _challengesCollection.add(challenge.toMap());
  }

  /// 🔹 Update Challenge (mark complete)
  Future<void> updateChallenge(
      String challengeId, Map<String, dynamic> data) async {
    await _challengesCollection.doc(challengeId).update(data);
  }

  /// 🔹 Get Daily Challenges
  Future<List<ChallengeModel>> getDailyChallenges() async {
    final snapshot = await _challengesCollection
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map((doc) =>
            ChallengeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  /// 🔹 Update user fields (e.g., isAdmin, isActive)
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  /// 🔹 Admin: Delete Challenge
  Future<void> deleteChallenge(String challengeId) async {
    await _challengesCollection.doc(challengeId).delete();
  }

  /// 🔹 Admin: Get All Users
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _usersCollection.get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
