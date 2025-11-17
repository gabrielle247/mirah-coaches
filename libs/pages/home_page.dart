import 'package:flutter/material.dart';
import 'package:mirah_coaches/utils/receipt_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> dummyTickets = [
    {
      "id": "H8K9L1",
      "destination": "Bulawayo",
      "class": "Luxury Coach",
      "price": 45.00,
    },
    {
      "id": "M2N4P6",
      "destination": "Victoria Falls",
      "class": "Sleeper",
      "price": 65.00,
    },
    {
      "id": "Q7R5S3",
      "destination": "Mutare",
      "class": "Standard Class",
      "price": 20.00,
    },
    {
      "id": "T9V1X2",
      "destination": "Gweru",
      "class": "Business Class",
      "price": 35.00,
    },
    {
      "id": "Z3B5D7",
      "destination": "Masvingo",
      "class": "Standard Class",
      "price": 25.00,
    },
    {
      "id": "A1B2C3",
      "destination": "Kariba",
      "class": "Standard Class",
      "price": 40.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

    var textStyleTitle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    var textStyleSubtitle = TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: const Text('Dashboard'),
        actions: [
          Container(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Mirah Coaches!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            SizedBox(height: 20),

            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // 1. Forces children to fill vertical space
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withAlpha(70),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Optional: spaces out content evenly
                        children: [
                          Text("Current Route", style: textStyle),
                          SizedBox(height: 8), // Added for spacing
                          Column(
                            // Grouping the route details
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("City A", style: textStyleTitle),
                              Text("City B", style: textStyleTitle),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withAlpha(70),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Onboard", style: textStyle),

                          SizedBox(height: 10.0),
                          // Using Align or Spacer can push this text to match the bottom of the other card if desired
                          Text("152", style: textStyleTitle),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0),
            //Actions
            //Receipts
            //View Passangers
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // 1. Forces children to fill vertical space
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Optional: spaces out content evenly
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 26),
                          const SizedBox(height: 5),
                          Text("Issue Receipt", style: textStyleSubtitle),
                          Text(
                            "Create new receipts for passangers",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withAlpha(70),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 26),
                          const SizedBox(height: 5),
                          Text("View Receipts", style: textStyleSubtitle),
                          Text(
                            "See all passanger on this bus",
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0),

            //Recently Issued Receipts
            Text(
              "Recently Issued",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            SizedBox(height: 16.0),

            // Inside your ListView or Column
            //Card 1
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ), // Adds scrolling space at bottom
                itemCount: dummyTickets.length,
                itemBuilder: (context, index) {
                  final ticket = dummyTickets[index];
                  return TicketCard(
                    ticketId: ticket["id"],
                    destination: ticket["destination"],
                    ticketClass: ticket["class"],
                    price: ticket["price"],
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
