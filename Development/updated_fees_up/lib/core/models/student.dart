import 'dart:convert';

class Student {
  final int id; // 'id' serial
  final String studentId; // 'student_id' text (Public ID)
  final String studentName; // 'student_name'
  final String grade; // 'grade'
  final DateTime registrationDate; // 'registration_date'
  final bool isActive; // 'is_active'
  final double baseFee; // 'base_fee'
  final String parentContact; // 'parent_contact'
  
  // ⚡️ VERSATILITY FIELDS
  final String frequency; // 'frequency' (Legacy/Simple)
  final String billingMode; // 'billing_mode' (Advanced: monthly, termly, custom)
  final Map<String, dynamic>? billingConfig; // 'billing_config' (JSON String)
  
  final List<String> subjects; // 'subjects' (jsonb)
  final String adminUid; // 'admin_uid'
  final DateTime updatedAt; // 'updated_at'

  Student({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.registrationDate,
    required this.isActive,
    required this.baseFee,
    this.parentContact = '',
    this.frequency = 'Monthly',
    this.billingMode = 'monthly',
    this.billingConfig,
    this.subjects = const [],
    required this.adminUid,
    required this.updatedAt,
  });

  factory Student.fromRow(Map<String, dynamic> row) {
    return Student(
      id: row['id'] as int,
      studentId: row['student_id'] as String,
      studentName: row['student_name'] as String,
      grade: row['grade'] as String? ?? 'Form 1',
      registrationDate: DateTime.tryParse(row['registration_date'] ?? '') ?? DateTime.now(),
      isActive: row['is_active'] == true || row['is_active'] == 1,
      baseFee: (row['base_fee'] as num?)?.toDouble() ?? 0.0,
      parentContact: row['parent_contact'] as String? ?? '',
      
      // MAPPING VERSATILITY
      frequency: row['frequency'] as String? ?? 'Monthly',
      billingMode: row['billing_mode'] as String? ?? 'monthly',
      billingConfig: row['billing_config'] != null 
          ? _parseConfig(row['billing_config']) 
          : null,
      
      subjects: _parseSubjects(row['subjects']),
      adminUid: row['admin_uid'] as String,
      updatedAt: DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toRow() {
    return {
      // 'id' is SERIAL, usually excluded on insert, but included here for full object mapping
      'id': id, 
      'student_id': studentId,
      'student_name': studentName,
      'grade': grade,
      'registration_date': registrationDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'base_fee': baseFee,
      'parent_contact': parentContact,
      'frequency': frequency,
      'billing_mode': billingMode,
      'billing_config': billingConfig != null ? jsonEncode(billingConfig) : null,
      'subjects': jsonEncode(subjects),
      'admin_uid': adminUid,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // --- HELPERS ---

  static List<String> _parseSubjects(dynamic raw) {
    if (raw == null) return [];
    try {
      // SQLite/Postgres might return it as a String (jsonb stringified) or a List (driver dependent)
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String) {
        final List<dynamic> list = jsonDecode(raw);
        return list.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Map<String, dynamic>? _parseConfig(String raw) {
    try {
      return jsonDecode(raw);
    } catch (e) {
      return null;
    }
  }

  // Helper CopyWith (Crucial for Edit Screens)
  Student copyWith({
    String? studentName,
    String? grade,
    double? baseFee,
    String? billingMode,
    String? parentContact,
    List<String>? subjects,
  }) {
    return Student(
      id: id,
      studentId: studentId,
      studentName: studentName ?? this.studentName,
      grade: grade ?? this.grade,
      registrationDate: registrationDate,
      isActive: isActive,
      baseFee: baseFee ?? this.baseFee,
      parentContact: parentContact ?? this.parentContact,
      frequency: frequency,
      billingMode: billingMode ?? this.billingMode,
      billingConfig: billingConfig,
      subjects: subjects ?? this.subjects,
      adminUid: adminUid,
      updatedAt: DateTime.now(),
    );
  }
}