//DashboardTab

import 'package:flutter/material.dart';
import 'package:mirah_coaches/pages/home_page.dart';
import 'package:mirah_coaches/utils/receipt_item.dart';
import 'package:mirah_coaches/utils/testing_data/testing_data.dart';
import 'package:mirah_coaches/utils/ticket_widget.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Ticket> allTickets = testingData();
    return CustomScrollView(
      slivers: [
        //Cards,
        SliverToBoxAdapter(
          // ignore: sized_box_for_whitespace
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: cartView(
                      [Color(0xff2196f3), Color(0xff003366)],
                      value: "200",
                      title: "Passengers",
                    ),
                  ),
                  Expanded(
                    child: cartView(
                      [Color(0xff28a745), Color.fromARGB(255, 15, 64, 26)],
                      title: "Obboard",
                      value: "170",
                    ),
                  ),
                ],
              ),

              //Recent Passengers Text()
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Recently Added Passengers",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),

        //List Widget
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final ticket = allTickets[index];
            return TicketCard(ticket: ticket);
          }, childCount: allTickets.length),
        ),
      ],
    );
  }
}

Widget cartView(List<Color> color, {required title, required String value}) {
  return Container(
    height: 110,
    padding: EdgeInsets.all(16),
    decoration: allGradientBoxes(color: color, radius: 0),
    child: Column(
      children: [
        Text(value, style: textStyleTitle),
        Text(title, style: textStyle),
      ],
    ),
  );
}
