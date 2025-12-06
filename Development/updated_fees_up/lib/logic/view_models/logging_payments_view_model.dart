import 'package:flutter/foundation.dart';

import 'package:updated_fees_up/core/models/bill.dart';
import 'dart:math';

import 'package:updated_fees_up/core/models/payment.dart';
import 'package:updated_fees_up/core/services/database_service.dart'; // For generateShortId helper if needed

class LoggingPaymentsViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  String studentId = '';
  double amount = 0.0;
  bool _isLoading = false;

  List<Bill> _unpaidBills = [];
  
  bool get isLoading => _isLoading;
  List<Bill> get unpaidBills => _unpaidBills;
  
  double get totalOutstanding => _unpaidBills.fold(0.0, (sum, b) => sum + b.outstandingBalance);
  double get surplus => (amount - totalOutstanding) > 0 ? (amount - totalOutstanding) : 0.0;

  void setStudentId(String id) {
    studentId = id;
    if (studentId.isNotEmpty) _loadBills();
  }

  void updateAmount(double val) {
    amount = val;
    notifyListeners();
  }

  Future<void> _loadBills() async {
    _isLoading = true;
    notifyListeners();
    try {
      final allBills = await _db.getBillsForStudent(studentId);
      // Filter for unpaid only and sort oldest first for payment logic
      _unpaidBills = allBills.where((b) => !b.isPaid).toList();
      _unpaidBills.sort((a, b) => a.billingCycleStart.compareTo(b.billingCycleStart));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logPayment() async {
    if (amount <= 0 || studentId.isEmpty) return false;
    _isLoading = true;
    notifyListeners();

    try {
      double remaining = amount;
      
      // 1. Pay off existing debt (Oldest first)
      for (var bill in _unpaidBills) {
        if (remaining <= 0) break;
        
        double toPay = min(remaining, bill.outstandingBalance);
        
        final payment = Payment(
          id: "PAY-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}",
          billId: bill.id,
          studentId: studentId,
          amount: toPay,
          datePaid: DateTime.now(),
          method: 'Cash',
          updatedAt: DateTime.now(),
          adminUid: 'offline_admin',
        );

        await _db.savePayment(payment);
        remaining -= toPay;
      }

      // 2. Handle Surplus (Credit Future) - Simplified for now
      // If there's money left, we ideally create a future bill or store as credit.
      // For this offline version, we just log it against the most recent bill or a "Credit" bill.
      if (remaining > 0) {
         // Logic to create a credit entry or advance payment would go here.
         debugPrint("Surplus payment of $remaining detected. (Credit logic pending)");
      }

      amount = 0.0;
      await _loadBills(); // Refresh UI
      return true;
    } catch (e) {
      debugPrint("Payment Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}