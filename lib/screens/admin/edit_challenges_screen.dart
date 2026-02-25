import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class EditChallengeScreen extends StatefulWidget {
  final ChallengeModel challenge;
  const EditChallengeScreen({super.key, required this.challenge});

  @override
  State<EditChallengeScreen> createState() => _EditChallengeScreenState();
}

class _EditChallengeScreenState extends State<EditChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.challenge.title);
    _descriptionController =
        TextEditingController(text: widget.challenge.description);
  }

  Future<void> _editChallenge() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedChallenge = ChallengeModel(
      id: widget.challenge.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdAt: widget.challenge.createdAt,
    );

    try {
      await _firestoreService.updateChallenge(updatedChallenge);
      showSnackBar(context, "Challenge updated!",
          backgroundColor: Colors.green);
      Navigator.pop(context, true); // return true to refresh list
    } catch (e) {
      showSnackBar(context, e.toString(), backgroundColor: Colors.redAccent);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Challenge"),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Challenge Title",
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _editChallenge,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Challenge",
                          style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
