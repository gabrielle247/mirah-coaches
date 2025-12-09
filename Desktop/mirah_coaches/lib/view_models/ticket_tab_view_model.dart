// lib/view_models/ticket_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
// import '../utils/database_helper.dart'; // Uncomment for DB integration

// Global Provider
final ticketViewModelProvider = ChangeNotifierProvider<TicketViewModel>((ref) {
  return TicketViewModel();
});

class TicketViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- TRIPS LOGIC ---
  List<Trip> _availableTrips = [];
  List<Trip> get availableTrips => _availableTrips;

  Trip? _selectedTrip;
  Trip? get selectedTrip => _selectedTrip;

  // Constructor
  TicketViewModel() {
    _loadTrips();
  }

  // Load standard routes (Mocking DB for now)
  void _loadTrips() async {
    // await DatabaseHelper.instance.getAllTrips();
    await Future.delayed(const Duration(milliseconds: 200));
    _availableTrips = [
      Trip(routeFrom: "Harare", routeTo: "Bulawayo", tripCode: "HRE-BYO", standardPrice: 20.0),
      Trip(routeFrom: "Bulawayo", routeTo: "Harare", tripCode: "BYO-HRE", standardPrice: 20.0),
      Trip(routeFrom: "Harare", routeTo: "Masvingo", tripCode: "HRE-MAS", standardPrice: 15.0),
    ];
    notifyListeners();
  }

  // When driver selects a trip from dropdown
  void selectTrip(Trip? trip, TextEditingController fromCtrl, TextEditingController toCtrl, TextEditingController amountCtrl) {
    _selectedTrip = trip;
    if (trip != null) {
      fromCtrl.text = trip.routeFrom;
      toCtrl.text = trip.routeTo;
      // Optional: Auto-fill price if you want, or leave it editable
      // amountCtrl.text = trip.standardPrice.toStringAsFixed(2); 
    }
    notifyListeners();
  }

  // --- SUBMIT LOGIC ---
  Future<bool> submitTicket({
    required String name,
    required String from,
    required String to,
    required double amount,
    required List<String> charges,
  }) async {
    _isLoading = true;
    notifyListeners();

    // 1. Create Model
    final newTicket = Ticket(
      // ID is null because DB auto-increments
      routeFrom: from,
      routeTo: to,
      ticketID: "TKT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      amount: amount,
      passengerName: name,
      charges: charges,
    );

    // 2. Save to DB (Simulated)
    // await DatabaseHelper.instance.createTicket(newTicket);
    debugPrint("Saving Ticket: ${newTicket.toMap()}");
    
    await Future.delayed(const Duration(seconds: 1)); // Fake saving delay

    _isLoading = false;
    notifyListeners();
    return true; // Return success
  }
}