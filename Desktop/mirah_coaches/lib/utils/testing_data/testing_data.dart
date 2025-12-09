import 'package:mirah_coaches/pages/home_page.dart';
import 'package:mirah_coaches/utils/ticket_widget.dart';

List<Ticket> testingData() {
  return [
    Ticket(
      id: 1,
      routeFrom: "Harare",
      routeTo: "Masvingo",
      ticketID: "TKT-001-000-01",
      amount: 5.00,
      passengerName: "Tawanda Mutodza",
      charges: ["Bus Fare"],
    ),
    Ticket(
      id: 2,
      routeFrom: "Masvingo",
      routeTo: "Beitbridge",
      ticketID: "TKT-001-000-02",
      amount: 10.00,
      passengerName: "Sipho Ndlovu",
      charges: ["Bus Fare", "Luggage"],
    ),
    Ticket(
      id: 3,
      routeFrom: "Beitbridge",
      routeTo: "Johannesburg",
      ticketID: "TKT-001-000-03",
      amount: 50.00,
      passengerName: "John Kwezi",
      charges: ["Bus Fare"],
    ),
    Ticket(
      id: 4,
      routeFrom: "Johannesburg",
      routeTo: "Port Elizabeth",
      ticketID: "TKT-001-000-04",
      amount: 120.00,
      passengerName: "Jane Smith",
      charges: ["Bus Fare", "Luggage"],
    ),
    Ticket(
      id: 5,
      routeFrom: "Harare",
      routeTo: "Beitbridge",
      ticketID: "TKT-001-000-05",
      amount: 15.00,
      passengerName: "Linda Makoni",
      charges: ["Bus Fare"],
    ),
    Ticket(
      id: 6,
      routeFrom: "Beitbridge",
      routeTo: "Port Elizabeth",
      ticketID: "TKT-001-000-06",
      amount: 140.00,
      passengerName: "Brian Chisamba",
      charges: ["Bus Fare", "Luggage"],
    ),
    Ticket(
      id: 7,
      routeFrom: "Gumtree",
      routeTo: "Port Elizabeth",
      ticketID: "TKT-001-000-7",
      amount: 20.00,
      passengerName: "Cecilia Mupfumi",
      charges: ["Bus Fare"],
    ),
    Ticket(
      id: 8,
      routeFrom: "Harare",
      routeTo: "Port Elizabeth",
      ticketID: "TKT-001-000-8",
      amount: 180.00,
      passengerName: "Thabo Moyo",
      charges: ["Bus Fare"],
    ),
    Ticket(
      id: 9,
      routeFrom: "Beitbridge",
      routeTo: "Johannesburg",
      ticketID: "TKT-001-000-9",
      amount: 50.00,
      passengerName: "Moses Chiwanga",
      charges: ["Bus Fare", "Luggage"],
    ),
    Ticket(
      id: 10,
      routeFrom: "Johannesburg",
      routeTo: "Port Elizabeth",
      ticketID: "TKT-001-000-10",
      amount: 120.00,
      passengerName: "Nomsa Moyo",
      charges: ["Bus Fare"],
    ),
  ];
}

List<Expenses> testingExpense() {
  return [
    Expenses("Fuel - Harare to Port Elizabeth", 1500.00, 1, "EXP-0000001"),
    Expenses("Toll Fees - Harare to Port Elizabeth", 200.00, 2, "EXP-0000002"),
    Expenses(
      "Driver Salary - Harare to Port Elizabeth",
      500.00,
      3,
      "EXP-0000003",
    ),
    Expenses("Maintenance - Bus Cleaning", 100.00, 4, "EXP-0000004"),
    Expenses("Insurance - Bus Insurance Premium", 300.00, 5, "EXP-0000005"),
    Expenses("Accommodation - Driver Accommodation", 200.00, 6, "EXP-0000006"),
    Expenses("Food - Driver Meals", 100.00, 7, "EXP-0000007"),
    Expenses("Bus Repair - Tyre Replacement", 500.00, 8, "EXP-0000008"),
    Expenses("Licensing - Bus License Renewal", 200.00, 9, "EXP-0000009"),
    Expenses("Other - Miscellaneous", 100.00, 10, "EXP-0000010"),
  ];
}
