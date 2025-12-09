import 'package:flutter/material.dart';

class Ticket {
  final int id;
  final String routeFrom;
  final String routeTo;
  final String ticketID; //TKT-000-000-00
  final double amount;
  final String passengerName;
  final List<String> charges; //Bus Fare, Lagguage, Extra Ticket

  Ticket({
    required this.id,
    required this.routeFrom,
    required this.routeTo,
    required this.ticketID,
    required this.amount,
    required this.passengerName,
    required this.charges,
  });
}

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key, required this.ticket});
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ticket.routeFrom} - ${ticket.routeTo}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  ticket.passengerName,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Total amount ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      "\$${ticket.amount}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 40, color: Colors.black),
              SizedBox(height: 8),
              Text(
                "Ticket no : $ticket.id",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
