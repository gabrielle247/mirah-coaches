class SchoolTerm {
  final String id; // 'id' uuid
  final String name; // 'name' text
  final int year; // 'year' integer
  final DateTime startDate; // 'start_date' date
  final DateTime endDate; // 'end_date' date
  final bool isActive; // 'is_active' boolean
  final DateTime createdAt; // 'created_at'
  final String adminUid; // 'admin_uid' uuid (Not Null)

  SchoolTerm({
    required this.id,
    required this.name,
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.adminUid,
  });

  factory SchoolTerm.fromRow(Map<String, dynamic> row) {
    return SchoolTerm(
      id: row['id'] as String,
      name: row['name'] as String,
      year: row['year'] as int,
      startDate: DateTime.parse(row['start_date']),
      endDate: DateTime.parse(row['end_date']),
      isActive: row['is_active'] == 1 || row['is_active'] == true,
      createdAt: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
      adminUid: row['admin_uid'] as String,
    );
  }

  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'admin_uid': adminUid,
    };
  }

  SchoolTerm copyWith({
    String? name,
    int? year,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return SchoolTerm(
      id: id,
      name: name ?? this.name,
      year: year ?? this.year,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      adminUid: adminUid,
    );
  }
}