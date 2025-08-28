import 'package:overwin_mobile/modules/esports/models/competition.dart';

class ESport {
  final int id;
  final String name;
  final String icon;
  final List<Competition> competitions;

  ESport({
    required this.id,
    required this.name,
    required this.icon,
    required this.competitions,
  });

  factory ESport.fromJson(Map<String, dynamic> json) {
    return ESport(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      competitions: (json['competitions'] as List<dynamic>? ?? [])
          .map((e) => Competition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert from API response
  factory ESport.fromApi(Map<String, dynamic> data) {
    return ESport(
      id: data['id'] ?? 0,
      name: data['name'] ?? '',
      icon: data['icon'] ?? 'assets/icons/rocket-league.png',
      competitions: data['competitions'] != null
          ? (data['competitions'] as List)
              .map((comp) => Competition.fromApi(comp))
              .toList()
          : <Competition>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'competitions': competitions.map((c) => c.toJson()).toList(),
    };
  }
}
