import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String ticketId;
  final String destination;
  final String ticketClass;
  final double price;

  const TicketCard({
    super.key,
    required this.ticketId,
    required this.destination,
    required this.ticketClass,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // Exact dark navy color from the screenshot
        color: const Color(0xFF0F1621), 
        borderRadius: BorderRadius.circular(16.0),
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
                  "Ticket #$ticketId",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "To $destination - $ticketClass",
                  style: TextStyle(
                    // Greyish-blue text for subtitle
                    color: Colors.grey[500], 
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
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}