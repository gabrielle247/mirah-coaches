class Payment {
  final String id;
  final String billId; // NOT NULL in SQL
  final String studentId;
  final double amount;
  final DateTime datePaid;
  final String method; // Default 'Cash'
  final DateTime updatedAt;
  final String? adminUid; // Nullable

  Payment({
    required this.id,
    required this.billId,
    required this.studentId,
    required this.amount,
    required this.datePaid,
    this.method = 'Cash',
    required this.updatedAt,
    this.adminUid,
  });

  factory Payment.fromRow(Map<String, dynamic> row) {
    return Payment(
      id: row['id'] as String,
      billId: row['bill_id'] as String, // Strictly String now
      studentId: row['student_id'] as String,
      amount: (row['amount'] as num).toDouble(),
      datePaid: DateTime.tryParse(row['date_paid'] ?? '') ?? DateTime.now(),
      method: row['method'] as String? ?? 'Cash',
      updatedAt: DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
      adminUid: row['admin_uid'] as String?,
    );
  }

  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'bill_id': billId,
      'student_id': studentId,
      'amount': amount,
      'date_paid': datePaid.toIso8601String(),
      'method': method,
      'updated_at': DateTime.now().toIso8601String(),
      'admin_uid': adminUid,
    };
  }
}