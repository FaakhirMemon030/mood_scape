import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../services/firestore_service.dart';
import '../widgets/challenge_card.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'add_challenge_screen.dart';
import 'edit_challenge_screen.dart';

class ManageChallengesScreen extends StatefulWidget {
  const ManageChallengesScreen({super.key});

  @override
  State<ManageChallengesScreen> createState() => _ManageChallengesScreenState();
}

class _ManageChallengesScreenState extends State<ManageChallengesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<ChallengeModel> _challenges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    setState(() => _isLoading = true);
    _challenges = await _firestoreService.getDailyChallenges();
    setState(() => _isLoading = false);
  }

  Future<void> _deleteChallenge(String id) async {
    await _firestoreService.deleteChallenge(id);
    showSnackBar(context, "Challenge deleted", backgroundColor: Colors.red);
    _loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Challenges"),
        backgroundColor: PRIMARY_COLOR,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChallenges,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddChallengeScreen()),
          );
          if (added == true) _loadChallenges();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _challenges.isEmpty
              ? const Center(child: Text("No challenges found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
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
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  bool? edited = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditChallengeScreen(
                                          challenge: challenge),
                                    ),
                                  );
                                  if (edited == true) _loadChallenges();
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteChallenge(challenge.id),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
    );
  }
}
