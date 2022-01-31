class Admin {
  final String id;
  final String email;
  final String password;

  Admin({required this.id, required this.email, required this.password});
  factory Admin.fromMap(Map<String, dynamic> data, String documentId) {
    final String password = data["password"] ?? "";
    final String email = data["email"] ?? "";
    return Admin(password: password, email: email, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "password": password,
      "email": email,
    };
  }
}
