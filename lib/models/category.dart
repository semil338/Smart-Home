class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data["name"] ?? "";

    return Category(name: name, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }
}
