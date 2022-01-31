class Users {
  final String id;
  final String email;
  final String name;
  final String photoURL;

  Users(
      {required this.id,
      required this.email,
      required this.name,
      required this.photoURL});
  factory Users.fromMap(Map<String, dynamic>? data, String documentId) {
    final String name = data!["name"] ?? "";
    final String email = data["email"] ?? "";
    final String photoURL = data["photoURL"] ?? "";
    return Users(name: name, email: email, id: documentId, photoURL: photoURL);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "photoURL": photoURL,
    };
  }
}
