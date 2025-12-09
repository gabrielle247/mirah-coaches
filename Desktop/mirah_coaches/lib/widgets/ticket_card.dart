import 'package:flutter/material.dart';
import 'package:mirah_coaches/models/models.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: allGradientBoxes(
        color: [Color(0xffcadbef), Color(0xff1188fe)],
        radius: 12.0,
      ),
      child: Row(
        children: [
          // 1. The Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // Slightly lighter blue for the circle background
              color: const Color(0xFF1A273B),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.confirmation_number_outlined, // Or CupertinoIcons.ticket
              color: Color(0xFF2196F3), // Bright blue icon color
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // 2. The Ticket Details (Middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ticket.routeFrom} - ${ticket.routeTo}",
                  style: const TextStyle(
                    color: Color(0xFF1A273B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ticket.passengerName.isEmpty
                      ? "Anonymous"
                      : ticket.passengerName,
                  style: TextStyle(
                    // Greyish-blue text for subtitle
                    color: const Color(0xFF1A273B),
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Ticket #${ticket.id}",
                  style: TextStyle(
                    // Greyish-blue text for subtitle
                    color: const Color(0xFF1A273B),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 3. The Price (Right)
          Text(
            "\$${ticket.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Color(0xFF1A273B),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  const PaymentItem({super.key, required this.expenses} );

  final Expenses expenses;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: allGradientBoxes(
        color: [Color(0xffcadbef), Color(0xff1188fe)],
        radius: 12.0,
      ),
      child: Row(
        children: [

          // 2. The Ticket Details (Middle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expenses.name,
                  style: const TextStyle(
                    color: Color(0xFF1A273B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                Text(
                  "No.${expenses.expenseNumber}",
                  style: const TextStyle(
                    color: Color(0xFF1A273B),
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 3. The Price (Right)
          Text(
            "\$${expenses.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Color(0xFF1A273B),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}