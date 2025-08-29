/// Mô hình dữ liệu cho một lựa chọn kèo
class Selection {
  final int id;
  final int marketId;
  final String name;
  final String code;
  final double odd;
  final String status;

  Selection({
    required this.id,
    required this.marketId,
    required this.name,
    required this.code,
    required this.odd,
    required this.status,
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(
      id: json['id']?.toInt() ?? 0,
      marketId: json['marketId']?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      odd: (json['odd'] is num) ? json['odd'].toDouble() : 1.0,
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marketId': marketId,
      'name': name,
      'code': code,
      'odd': odd,
      'status': status,
    };
  }
}
