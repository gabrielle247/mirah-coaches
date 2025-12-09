// lib/view_models/passengers_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
// import '../utils/database_helper.dart'; // Uncomment for real DB

final passengersViewModelProvider = ChangeNotifierProvider<PassengersViewModel>((ref) {
  return PassengersViewModel();
});

class PassengersViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Ticket> _allTickets = [];
  List<Ticket> get allTickets => _allTickets;

  PassengersViewModel() {
    loadPassengers();
  }

  Future<void> loadPassengers() async {
    _isLoading = true;
    notifyListeners();

    // await Future.delayed(const Duration(milliseconds: 500)); // Fake delay
    // _allTickets = await DatabaseHelper.instance.getAllTickets(); 
    
    // Mock Data
    _allTickets = [
      Ticket(id: 10, routeFrom: "Harare", routeTo: "Gweru", ticketID: "TKT-010", amount: 10.0, passengerName: "Blessing M.", charges: ["Fare"]),
      Ticket(id: 9, routeFrom: "Gweru", routeTo: "Bulawayo", ticketID: "TKT-009", amount: 15.0, passengerName: "Tendai C.", charges: ["Fare"]),
      Ticket(id: 8, routeFrom: "Harare", routeTo: "Masvingo", ticketID: "TKT-008", amount: 20.0, passengerName: "Sarah K.", charges: ["Fare"]),
      // Add more mock data if needed to test scrolling
    ];

    _isLoading = false;
    notifyListeners();
  }
}