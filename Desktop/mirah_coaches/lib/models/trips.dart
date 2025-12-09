// lib/models/trip.dart

class Trip {
  final int? id; // Database ID
  final String routeFrom; // e.g. "Harare"
  final String routeTo;   // e.g. "Bulawayo"
  final double standardPrice; // Optional: Auto-fill the price too!
  final String tripCode; // e.g. "HRE-BYO-001"

  Trip({
    this.id,
    required this.routeFrom,
    required this.routeTo,
    this.standardPrice = 0.0,
    required this.tripCode,
  });

  // --- SQL HELPER METHODS ---

  // 1. To Map (Saving to DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'route_from': routeFrom,
      'route_to': routeTo,
      'standard_price': standardPrice,
      'trip_code': tripCode,
    };
  }

  // 2. From Map (Reading from DB)
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as int?,
      routeFrom: map['route_from'] ?? '',
      routeTo: map['route_to'] ?? '',
      standardPrice: (map['standard_price'] as num?)?.toDouble() ?? 0.0,
      tripCode: map['trip_code'] ?? '',
    );
  }

  // Helper to display the full route name easily in Dropdowns
  String get routeName => "$routeFrom to $routeTo";
}