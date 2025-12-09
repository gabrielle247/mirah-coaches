import 'package:flutter/material.dart';
import 'package:mirah_coaches/utils/receipt_item.dart';
import 'package:mirah_coaches/utils/ticket_widget.dart';

class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Ticket> dummyTickets = [
      
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_rounded),
        title: const Text('Receipts'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("All the receipts"),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ), // Adds scrolling space at bottom
                itemCount: dummyTickets.length,
                itemBuilder: (context, index) {
                  final ticket = dummyTickets[index];
                  return TicketCard(ticket: ticket,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
