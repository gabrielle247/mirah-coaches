import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:updated_fees_up/core/services/database_service.dart';
// 🛑 ADDED: Import the Bill model to access BillStatus enum
import 'package:updated_fees_up/core/models/bill.dart'; 

// UI Helper Model
class LedgerEntry {
  final String id;
  final String description;
  final DateTime date;
  final double amount;
  final double paid;
  final double balance;
  final String status;
  final Color color;

  LedgerEntry(this.id, this.description, this.date, this.amount, this.paid, this.balance, this.status, this.color);
}

class StudentLedgerViewModel extends ChangeNotifier {
  final String studentId;
  final DatabaseService _db = DatabaseService();

  StudentLedgerViewModel(this.studentId);

  List<LedgerEntry> _entries = [];
  double _totalBilled = 0.0;
  double _totalPaid = 0.0;
  bool _isLoading = false;

  List<LedgerEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String get totalOutstandingFormatted => "\$${(_totalBilled - _totalPaid).toStringAsFixed(2)}";

  Future<void> loadLedger() async {
    _isLoading = true;
    notifyListeners();

    try {
      final bills = await _db.getBillsForStudent(studentId);
      
      _totalBilled = 0;
      _totalPaid = 0;
      _entries = [];

      for (var bill in bills) {
        _totalBilled += bill.totalAmount;
        _totalPaid += bill.paidAmount;

        String status = "Unpaid";
        Color color = Colors.grey;
        
        if (bill.isPaid) {
          status = "Paid";
          color = Colors.greenAccent;
        } else if (bill.paidAmount > 0) {
          status = "Partial";
          color = Colors.orangeAccent;
        } else if (bill.status == BillStatus.overdue) {
          status = "Overdue";
          color = Colors.redAccent;
        }

        _entries.add(LedgerEntry(
          bill.id,
          DateFormat('MMMM yyyy').format(bill.monthYear),
          bill.monthYear,
          bill.totalAmount,
          bill.paidAmount,
          bill.outstandingBalance,
          status,
          color,
        ));
      }
    } catch (e) {
      debugPrint("Error loading ledger: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}