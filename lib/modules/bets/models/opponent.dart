class Opponent {
  final int id;
  final String name;
  final String logo;

  Opponent({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Opponent.fromJson(Map<String, dynamic> json) {
    try {
      return Opponent(
        id: json['id']?.toInt() ?? 0,
        name: json['name']?.toString() ?? 'Unknown Team',
        logo: json['logo']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Opponent from JSON: $e');
      // Return a default opponent if parsing fails
      return Opponent(
        id: 0,
        name: 'Unknown Team',
        logo: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }
}
