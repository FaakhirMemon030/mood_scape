class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileUrl;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileUrl,
    this.isAdmin = false,
  });

  // 🔹 From Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  // 🔹 To Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'isAdmin': isAdmin,
    };
  }
}
