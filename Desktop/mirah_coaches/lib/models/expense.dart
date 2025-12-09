// lib/models/expenses.dart

class Expenses {
  final int? id;
  final String name;
  final double totalAmount;
  final int expenseNumber;
  final String expenseID; // e.g. EXP-001

  Expenses({
    this.id,
    required this.name, 
    required this.totalAmount, 
    required this.expenseNumber, 
    required this.expenseID
  });

  // --- SQL HELPER METHODS ---

  // 1. To Map (Saving to DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_amount': totalAmount,
      'expense_number': expenseNumber,
      'expense_id': expenseID,
    };
  }

  // 2. From Map (Reading from DB)
  factory Expenses.fromMap(Map<String, dynamic> map) {
    return Expenses(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      totalAmount: (map['total_amount'] as num).toDouble(),
      expenseNumber: map['expense_number'] ?? 0,
      expenseID: map['expense_id'] ?? '',
    );
  }
}