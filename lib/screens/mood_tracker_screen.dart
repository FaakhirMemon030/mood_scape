import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
    with SingleTickerProviderStateMixin {
  double _moodValue = 3;
  final TextEditingController _noteController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _saveMood() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _firestore.collection('moods').add({
      'userId': user.uid,
      'mood': _moodValue,
      'note': _noteController.text.trim(),
      'date': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mood Saved Successfully ✅"),
      ),
    );

    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // 🔥 Animated Emoji
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                getMoodEmoji(_moodValue),
                key: ValueKey(_moodValue),
                style: const TextStyle(fontSize: 80),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              getMoodText(_moodValue),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 🎚 Mood Slider
            Slider(
              value: _moodValue,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() {
                  _moodValue = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // 📝 Note Field
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: "Write something about today...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            // 💾 Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveMood,
                child: const Text(
                  "Save Mood",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
