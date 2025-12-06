import 'dart:math';

// 🛑 ADDED: The missing Enum
enum BillStatus { paid, partial, overdue, unpaid }

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
  final String? adminUid; 
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

  // 🛑 ADDED: The Missing Logic
  BillStatus get status {
    // 1. Paid Check (with small float tolerance)
    if (paidAmount >= (totalAmount - 0.01)) return BillStatus.paid;
    
    // 2. Partial Check
    if (paidAmount > 0) return BillStatus.partial;

    // 3. Overdue Check
    // Logic: If today is after the cycle start + 30 days, it's overdue.
    // (You can adjust this duration to match your business rules)
    final dueDate = billingCycleStart.add(const Duration(days: 30));
    if (DateTime.now().isAfter(dueDate)) return BillStatus.overdue;

    // 4. Default
    return BillStatus.unpaid;
  }

  bool get isPaid => status == BillStatus.paid;
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
      'cycle_interval': cycleInterval.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'admin_uid': adminUid,
    };
  }

  static CycleInterval _parseInterval(String? val) {
    return CycleInterval.values.firstWhere(
      (e) => e.name == val,
      orElse: () => CycleInterval.monthly,
    );
  }
}
