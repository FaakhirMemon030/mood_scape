import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String id; // Document ID
  final String title; // Challenge title
  final String description; // Challenge description
  final bool completed; // Completed status
  final Timestamp createdAt; // Creation date

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    required this.createdAt,
  });

  // 🔹 From Firestore
  factory ChallengeModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChallengeModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      completed: map['completed'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  // 🔹 To Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
    };
  }
}
