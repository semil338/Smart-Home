class Room {
  final String id;
  final String name;
  final String iconLink;

  Room({
    required this.id,
    required this.name,
    required this.iconLink,
  });
  factory Room.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data["name"] ?? "";
    final String iconLink = data["iconLink"] ?? "";
    return Room(name: name, iconLink: iconLink, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "iconLink": iconLink,
    };
  }
}
