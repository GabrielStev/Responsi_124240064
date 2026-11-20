class Spell {
  final String name;
  final String use;
  final int index;

  Spell({required this.name, required this.use, required this.index});

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      name: (json['spell'] ?? 'Unknown Spell').toString(),
      use: (json['use'] ?? 'No description').toString(),
      index: int.tryParse(json['index']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'spell': name, 'use': use, 'index': index};
  }

  factory Spell.fromMap(Map<dynamic, dynamic> map) {
    return Spell(
      name: (map['spell'] ?? '').toString(),
      use: (map['use'] ?? '').toString(),
      index: int.tryParse(map['index']?.toString() ?? '') ?? 0,
    );
  }

  String get key => index.toString();
}
