import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodVisualScreen extends StatefulWidget {
  const MoodVisualScreen({super.key});

  @override
  State<MoodVisualScreen> createState() => _MoodVisualScreenState();
}

class _MoodVisualScreenState extends State<MoodVisualScreen>
    with SingleTickerProviderStateMixin {

  double _currentMood = 3;
  late AnimationController _animationController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fetchTodayMood();
  }

  Future<void> _fetchTodayMood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('moods')
        .where('userId', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('date', isLessThan: Timestamp.fromDate(todayEnd))
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        _currentMood = (data['mood'] as num).toDouble();
      });
    }
  }

  Color getMoodColor(double value) {
    if (value <= 1) return Colors.red;
    if (value <= 2) return Colors.orange;
    if (value <= 3) return Colors.yellow;
    if (value <= 4) return Colors.lightGreen;
    return Colors.greenAccent;
  }

  String getMoodEmoji(double value) {
    if (value <= 1) return "😢";
    if (value <= 2) return "😔";
    if (value <= 3) return "😐";
    if (value <= 4) return "😊";
    return "😄";
  }

  String getMoodText(double value) {
    if (value <= 1) return "Very Sad";
    if (value <= 2) return "Sad";
    if (value <= 3) return "Neutral";
    if (value <= 4) return "Happy";
    return "Very Happy";
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = getMoodColor(_currentMood);

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: 250 + 20 * _animationController.value,
              height: 250 + 20 * _animationController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.7), color.withOpacity(0.2)],
                  stops: const [0.4, 1.0],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getMoodEmoji(_currentMood),
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getMoodText(_currentMood),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}