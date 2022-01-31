class Switches {
  final String id;
  final String name;
  final String iconLink;
  final String type;
  final String value;

  Switches({
    required this.id,
    required this.name,
    required this.iconLink,
    required this.type,
    required this.value,
  });
  factory Switches.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data["name"] ?? "";
    final String iconLink = data["iconLink"] ?? "";
    final String type = data["type"] ?? "";
    final String value = data["value"] ?? "";
    return Switches(
        name: name,
        iconLink: iconLink,
        type: type,
        id: documentId,
        value: value);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "iconLink": iconLink,
      "type": type,
      "value": value,
    };
  }
}
