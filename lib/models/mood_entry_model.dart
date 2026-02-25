import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntryModel {
  final String id; // Document ID
  final String userId; // User UID
  final double value; // 1-5 scale
  final String? note; // Optional note
  final Timestamp date; // Date saved

  MoodEntryModel({
    required this.id,
    required this.userId,
    required this.value, // ✅ main value property
    this.note,
    required this.date,
  });

  // 🔹 Convert Model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'value': value,
      'note': note,
      'date': date,
    };
  }

  // 🔹 Convert Firestore doc to Model
  factory MoodEntryModel.fromMap(Map<String, dynamic> map, String docId) {
    return MoodEntryModel(
      id: docId,
      userId: map['userId'] ?? '',
      value: (map['value'] as num).toDouble(),
      note: map['note'],
      date: map['date'] ?? Timestamp.now(),
    );
  }
}
