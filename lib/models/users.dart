class Users {
  final String id;
  final String email;
  final String name;
  final String photoURL;
  final String token;

  Users(
      {required this.id,
      required this.email,
      required this.name,
      required this.photoURL,
      required this.token});
  factory Users.fromMap(Map<String, dynamic>? data, String documentId) {
    final String name = data!["name"] ?? "";
    final String email = data["email"] ?? "";
    final String photoURL = data["photoURL"] ?? "";
    final String token = data["token"] ?? "";
    return Users(
        name: name,
        email: email,
        id: documentId,
        photoURL: photoURL,
        token: token);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "photoURL": photoURL,
    };
  }
}
