import 'dart:math';

// Enum matching Postgres type 'cycle_interval'
enum CycleInterval { monthly, termly, yearly, custom }

class Bill {
  final String id;
  final String studentId;
  final double totalAmount;
  final double paidAmount;
  final DateTime monthYear;
  final DateTime billingCycleStart;
  final CycleInterval cycleInterval;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? adminUid; // Nullable

  // Generated Column (Read-Only)
  final DateTime? billingCycleEnd;

  Bill({
    required this.id,
    required this.studentId,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.monthYear,
    required this.billingCycleStart,
    this.cycleInterval = CycleInterval.monthly,
    required this.createdAt,
    required this.updatedAt,
    this.adminUid,
    this.billingCycleEnd,
  });

  // Computed Status (Business Logic)
  bool get isPaid => paidAmount >= (totalAmount - 0.01);
  double get outstandingBalance => max(0.0, totalAmount - paidAmount);

  factory Bill.fromRow(Map<String, dynamic> row) {
    return Bill(
      id: row['id'] as String,
      studentId: row['student_id'] as String,
      totalAmount: (row['total_amount'] as num).toDouble(),
      paidAmount: (row['paid_amount'] as num?)?.toDouble() ?? 0.0,
      monthYear: DateTime.parse(row['month_year']),
      billingCycleStart: DateTime.parse(row['billing_cycle_start']),
      cycleInterval: _parseInterval(row['cycle_interval']),
      createdAt: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
      adminUid: row['admin_uid'] as String?,
      billingCycleEnd: row['billing_cycle_end'] != null
          ? DateTime.tryParse(row['billing_cycle_end'])
          : null,
    );
  }

  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'student_id': studentId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'month_year': monthYear.toIso8601String(),
      'billing_cycle_start': billingCycleStart.toIso8601String(),
      'cycle_interval': cycleInterval.name, // Saves as 'monthly' etc.
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'admin_uid': adminUid,
      // billing_cycle_end is GENERATED ALWAYS, so we don't insert it
    };
  }

  static CycleInterval _parseInterval(String? val) {
    return CycleInterval.values.firstWhere(
      (e) => e.name == val,
      orElse: () => CycleInterval.monthly,
    );
  }
}
