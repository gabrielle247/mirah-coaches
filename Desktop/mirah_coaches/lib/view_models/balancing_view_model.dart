import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
// import '../utils/database_helper.dart'; // Uncomment when DB is ready

// --- 1. THIS IS THE MISSING PART ---
// This global variable allows the UI to find your ViewModel.
final balancingViewModelProvider = ChangeNotifierProvider<BalancingViewModel>((ref) {
  return BalancingViewModel();
});

// --- 2. The Logic Class ---
class BalancingViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Data Containers
  List<Ticket> _fromTickets = [];
  List<Ticket> _toTickets = [];
  
  List<Expenses> _fromExpenses = [];
  List<Expenses> _toExpenses = [];

  // --- GETTERS (The Math) ---
  
  // -- OUTBOUND (From) --
  List<Ticket> get fromTickets => _fromTickets;
  List<Expenses> get fromExpenses => _fromExpenses;
  
  double get fromRevenue => _fromTickets.fold(0, (sum, item) => sum + item.amount);
  double get fromExpenseTotal => _fromExpenses.fold(0, (sum, item) => sum + item.totalAmount);
  double get fromNetProfit => fromRevenue - fromExpenseTotal;

  // -- INBOUND (To) --
  List<Ticket> get toTickets => _toTickets;
  List<Expenses> get toExpenses => _toExpenses;

  double get toRevenue => _toTickets.fold(0, (sum, item) => sum + item.amount);
  double get toExpenseTotal => _toExpenses.fold(0, (sum, item) => sum + item.totalAmount);
  double get toNetProfit => toRevenue - toExpenseTotal;

  // --- ACTIONS ---

  void loadData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate Network/DB Delay
    await Future.delayed(const Duration(milliseconds: 500)); 

    // Mock Data: From (e.g. Harare -> Masvingo)
    _fromTickets = [
      Ticket(id: 1, routeFrom: "Harare", routeTo: "Masvingo", ticketID: "TKT-01", amount: 20.0, passengerName: "Tawanda", charges: ["Fare"]),
      Ticket(id: 2, routeFrom: "Harare", routeTo: "Masvingo", ticketID: "TKT-02", amount: 20.0, passengerName: "Sarah", charges: ["Fare"]),
    ];

    _fromExpenses = [
      Expenses(name: "Fuel", totalAmount: 15.0, expenseNumber: 1, expenseID: "EXP-01"),
    ];

    // Mock Data: To (e.g. Masvingo -> Harare)
    _toTickets = [
      Ticket(id: 3, routeFrom: "Masvingo", routeTo: "Harare", ticketID: "TKT-03", amount: 20.0, passengerName: "Brian", charges: ["Fare"]),
    ];

    _toExpenses = [
       Expenses(name: "Lunch", totalAmount: 5.0, expenseNumber: 3, expenseID: "EXP-03"),
       Expenses(name: "Tollgate", totalAmount: 2.0, expenseNumber: 4, expenseID: "EXP-04"),
    ];

    _isLoading = false;
    notifyListeners();
  }
}