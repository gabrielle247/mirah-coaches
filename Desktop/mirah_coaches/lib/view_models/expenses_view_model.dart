import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math'; // Required for ID generation
import '../models/models.dart';
import '../utils/database_helper.dart'; // ✅ Now Active

final expensesViewModelProvider = ChangeNotifierProvider<ExpensesViewModel>((ref) {
  return ExpensesViewModel();
});

class ExpensesViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Expenses> _expensesList = [];
  List<Expenses> get expensesList => _expensesList;

  // Dynamic Calculation (Sums up the list currently in memory)
  double get totalExpenseAmount => _expensesList.fold(0, (sum, item) => sum + item.totalAmount);

  ExpensesViewModel() {
    loadExpenses();
  }

  // --- 1. LOAD FROM DATABASE ---
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch real data from SQL
      _expensesList = await DatabaseHelper.instance.getAllExpenses();
    } catch (e) {
      debugPrint("Error loading expenses: $e");
      _expensesList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- 2. ADD TO DATABASE ---
  Future<void> addExpense(String name, double amount) async {
    // We don't set _isLoading to true here to avoid flickering the whole screen,
    // but you could if you wanted to block user interaction.
    
    // A. Generate robust 8-digit ID (10000000 to 99999999)
    final int randomNum = 10000000 + Random().nextInt(90000000); 
    final String uniqueID = "EXP-$randomNum";

    // B. Create the Object
    final newExpense = Expenses(
      name: name,
      totalAmount: amount,
      // For display number, we can use the current count + 1. 
      // Note: If you delete items later, this number logic might need a rethink, 
      // but for a simple log, it works fine.
      expenseNumber: _expensesList.length + 1,
      expenseID: uniqueID, 
    );

    // C. Save to SQL
    await DatabaseHelper.instance.createExpense(newExpense);

    // D. Reload to ensure UI is in sync with DB
    await loadExpenses(); 
  }
}