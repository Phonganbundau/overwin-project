class Competition {
  final int id;
  final String name;
  final String icon;
  final DateTime startDate;
  final DateTime? endsAt;
  final int esportId;

  Competition({
    required this.id,
    required this.name,
    required this.icon,
    required this.startDate,
    this.endsAt,
    required this.esportId,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endsAt: json['endsAt'] != null 
          ? DateTime.parse(json['endsAt'] as String)
          : null,
      esportId: json['esportId'] as int,
    );
  }

  // Convert from API response
  factory Competition.fromApi(Map<String, dynamic> data) {
    return Competition(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      icon: data['icon'] ?? 'assets/icons/rlcs-logo.png',
      startDate: data['startDate'] != null 
          ? DateTime.parse(data['startDate']) 
          : DateTime.now(),
      endsAt: data['endsAt'] != null 
          ? DateTime.parse(data['endsAt']) 
          : DateTime.now().add(const Duration(days: 30)),
      esportId: data['esportId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'esportId': esportId,
      'startDate': startDate.toIso8601String(),
      'endsAt': endsAt?.toIso8601String(),
    };
  }
}
