import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../services/firestore_service.dart';
import '../widgets/challenge_card.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'add_challenge_screen.dart'; // Screen for adding new challenge

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _users = [];
  List<ChallengeModel> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _users = await _firestoreService.getAllUsers();
    _challenges = await _firestoreService.getDailyChallenges();
    setState(() => _isLoading = false);
  }

  Future<void> _deleteChallenge(String id) async {
    await _firestoreService.deleteChallenge(id);
    showSnackBar(context, "Challenge deleted", backgroundColor: Colors.red);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: PRIMARY_COLOR,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add Challenge Screen
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddChallengeScreen()),
          );
          if (added == true) _loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Users Section
                  const Text(
                    "Users",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(DEFAULT_AVATAR),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: user.isAdmin
                            ? const Icon(Icons.shield, color: Colors.deepPurple)
                            : null,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Challenges Section
                  const Text(
                    "Challenges",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = _challenges[index];
                      return Stack(
                        children: [
                          ChallengeCard(
                            challenge: challenge,
                            onTap: () {},
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteChallenge(challenge.id),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
