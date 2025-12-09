// lib/models/ticket.dart
import 'dart:convert';

class Ticket {
  final int? id; // Database ID (auto-generated)
  final String routeFrom;
  final String routeTo;
  final String ticketID; // e.g. TKT-001
  final double amount;
  final String passengerName;
  final String passengerPhone;
  final List<String> charges; // e.g. ["Fare", "Luggage"]

  Ticket({
    this.id,
    required this.routeFrom,
    required this.routeTo,
    required this.ticketID,
    required this.amount,
    required this.passengerName,
    this.passengerPhone = "",
    required this.charges,
  });

  // --- SQL HELPER METHODS ---

  // 1. To Map (Saving to DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'route_from': routeFrom,
      'route_to': routeTo,
      'ticket_id': ticketID,
      'amount': amount,
      'passenger_name': passengerName,
      'passenger_phone': passengerPhone,
      // Store list as JSON string because SQL can't hold Lists
      'charges': jsonEncode(charges), 
    };
  }

  // 2. From Map (Reading from DB)
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] as int?,
      routeFrom: map['route_from'] ?? '',
      routeTo: map['route_to'] ?? '',
      ticketID: map['ticket_id'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      passengerName: map['passenger_name'] ?? '',
      passengerPhone: map['passenger_phone'] ?? '',
      // Convert JSON string back to List
      charges: map['charges'] != null 
          ? List<String>.from(jsonDecode(map['charges'])) 
          : [],
    );
  }
}