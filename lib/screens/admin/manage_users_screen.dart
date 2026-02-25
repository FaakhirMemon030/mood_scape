import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    _users = await _firestoreService.getAllUsers();
    setState(() => _isLoading = false);
  }

  Future<void> _toggleAdmin(UserModel user) async {
    if (user.isAdmin && user.email == ADMIN_EMAIL) {
      showSnackBar(context, "Cannot revoke super admin",
          backgroundColor: Colors.red);
      return;
    }
    await _firestoreService.updateUser(user.uid, {"isAdmin": !user.isAdmin});
    showSnackBar(
        context,
        user.isAdmin
            ? "${user.name} is no longer admin"
            : "${user.name} promoted to admin",
        backgroundColor: Colors.green);
    _loadUsers();
  }

  Future<void> _deactivateUser(UserModel user) async {
    if (user.email == ADMIN_EMAIL) {
      showSnackBar(context, "Cannot deactivate super admin",
          backgroundColor: Colors.red);
      return;
    }
    await _firestoreService.updateUser(user.uid, {"isActive": false});
    showSnackBar(context, "${user.name} deactivated",
        backgroundColor: Colors.red);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: PRIMARY_COLOR,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("No users found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(DEFAULT_AVATAR),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!user.isAdmin)
                              IconButton(
                                icon: const Icon(Icons.upgrade,
                                    color: Colors.deepPurple),
                                tooltip: "Promote to Admin",
                                onPressed: () => _toggleAdmin(user),
                              ),
                            if (!user.isAdmin ||
                                (user.isAdmin && user.email != ADMIN_EMAIL))
                              IconButton(
                                icon: const Icon(Icons.block,
                                    color: Colors.redAccent),
                                tooltip: "Deactivate User",
                                onPressed: () => _deactivateUser(user),
                              ),
                            if (user.isAdmin)
                              const Icon(Icons.shield,
                                  color: Colors.deepPurple),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
