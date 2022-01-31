class SubCategory {
  final String id;
  final String name;
  final String iconLink;
  final String type;

  SubCategory({
    required this.id,
    required this.name,
    required this.iconLink,
    required this.type,
  });
  factory SubCategory.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data["name"] ?? "";
    final String iconLink = data["iconLink"] ?? "";
    final String type = data["type"] ?? "";
    return SubCategory(
        name: name, iconLink: iconLink, type: type, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "iconLink": iconLink,
      "type": type,
    };
  }
}
