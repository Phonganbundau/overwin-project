/// Mô hình dữ liệu cho một lựa chọn kèo
class Selection {
  final int id;
  final int marketId;
  final String name;
  final String code;
  final double odd;
  final String status;

  const Selection({
    required this.id,
    required this.marketId,
    required this.name,
    required this.code,
    required this.odd,
    required this.status,
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(
      id: json['id'] as int,
      marketId: json['marketId'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      odd: (json['odd'] as num).toDouble(),
      status: json['status'] as String,
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
