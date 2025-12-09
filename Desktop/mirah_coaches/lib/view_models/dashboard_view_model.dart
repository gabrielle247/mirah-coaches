// lib/view_models/dashboard_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart'; // Imports your Ticket model
// import '../utils/database_helper.dart'; // Uncomment when ready to connect DB

// 1. The Provider Declaration (Global)
// This allows any widget to find this logic without context
final dashboardViewModelProvider = ChangeNotifierProvider<DashboardViewModel>((ref) {
  return DashboardViewModel();
});

// 2. The Logic Class
class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Ticket> _recentTickets = [];
  List<Ticket> get recentTickets => _recentTickets;

  int _totalPassengers = 0;
  int get totalPassengers => _totalPassengers;

  int _onboardCount = 0;
  int get onboardCount => _onboardCount;

  // Constructor: Load data immediately when the dashboard is created
  DashboardViewModel() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // SIMULATION: Replace this with actual Database calls later
    // final tickets = await DatabaseHelper.instance.getAllTickets();
    await Future.delayed(const Duration(milliseconds: 800)); // Fake network delay

    // Mock Data for now - eventually this comes from the DB
    _recentTickets = [
      Ticket(id: 1, routeFrom: "Harare", routeTo: "Masvingo", ticketID: "TKT-001", amount: 15.0, passengerName: "Tawanda M.", charges: ["Fare"]),
      Ticket(id: 2, routeFrom: "Byo", routeTo: "Hre", ticketID: "TKT-002", amount: 20.0, passengerName: "Sipho N.", charges: ["Fare"]),
      Ticket(id: 3, routeFrom: "Hre", routeTo: "Mutare", ticketID: "TKT-003", amount: 18.0, passengerName: "James K.", charges: ["Fare"]),
    ];

    _totalPassengers = 200; // Example stat
    _onboardCount = 170;    // Example stat

    _isLoading = false;
    notifyListeners();
  }
}