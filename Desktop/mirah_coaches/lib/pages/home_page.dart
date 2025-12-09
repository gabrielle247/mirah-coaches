import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:mirah_coaches/pages/balancing_page.dart';
import 'package:mirah_coaches/utils/main_page_tabs/dashboard_tab.dart';
import 'package:mirah_coaches/utils/receipt_item.dart';
import 'package:mirah_coaches/utils/ticket_widget.dart';
import 'package:mirah_coaches/utils/validators.dart';
import 'package:mirah_coaches/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mirah_coaches/utils/testing_data/testing_data.dart';

// ignore: unused_local_variable
var textStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.normal,
);

// ignore: unused_local_variable
var textStyleTitle = TextStyle(
  color: Colors.white,
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

// ignore: unused_local_variable
var textStyleSubtitle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    ColorScheme appTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primary,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: const Text("Mirah Coaches"),
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
        bottom: TabBar(
          onTap: (index) => homeViewModel.changeTab(index),
          controller: _tabController,
          tabs: [
            getText("HOME"),
            getText("TICKET"),
            getText("PASSENGERS"),
            getText("EXPENSES"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DashboardTab(),
          TicketTab(),
          PassengersTab(ticketsList: testingData()),
          BalancingPage(),
        ],
      ),
    );
  }
}

class TicketTab extends StatelessWidget {
  const TicketTab({super.key});

  @override
  Widget build(BuildContext context) {
    var title = const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    // ignore: unused_local_variable
    var subTitle = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
    final colorScheme = Theme.of(context).colorScheme;

    // Define Input Decoration Style once to reuse
    InputDecoration getDecor(String hint, IconData icon) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 14.0),
        prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Academic Information", style: title),
                // PHONE
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: getDecor("Enter passenger name...", Icons.person),
                  style: TextStyle(color: Colors.black),
                  // onChanged: vm.updateParentContact,
                  validator: Validators.validateName, // ✅ Added Validator
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16.0),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: getDecor(
                    "Journey To...",
                    Icons.subdirectory_arrow_right,
                  ),
                  style: TextStyle(color: Colors.black),
                  // onChanged: vm.updateParentContact,
                  validator: Validators.validateName, // ✅ Added Validator
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16.0),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: getDecor(
                    "Journey From...",
                    Icons.subdirectory_arrow_left_rounded,
                  ),
                  style: TextStyle(color: Colors.black),
                  // onChanged: vm.updateParentContact,
                  validator: Validators.validateName, // ✅ Added Validator
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16.0),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: getDecor("Bus Fare...", Icons.train),
                  style: TextStyle(color: Colors.black),
                  // onChanged: vm.updateParentContact,
                  validator: Validators.validateName, // ✅ Added Validator
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: 16.0),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: getDecor(
                    "Laguage Fee...",
                    Icons.business_center_sharp,
                  ),
                  style: TextStyle(color: Colors.black),
                  // onChanged: vm.updateParentContact,
                  validator: Validators.validateName, // ✅ Added Validator
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 30),

                // SUBMIT
                ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Print Receipt"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PassengersTab extends StatelessWidget {
  const PassengersTab({super.key, required this.ticketsList});

  final List<Ticket> ticketsList;
  @override
  Widget build(BuildContext context) {
    return //List Widget
    CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final ticket = ticketsList[index];
            return TicketCard(ticket: ticket);
          }, childCount: ticketsList.length),
        ),
      ],
    );
  }
}

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Expenses> expensesList = testingExpense();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cartView(
                [Color(0xff2196f3), Color(0xff003366)],
                value: "\$200.50",
                title: "Total Amount",
              ),

              
            ],
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final expense = expensesList[index];
            return PaymentItem(expenses: expense);
          }, childCount: expensesList.length),
        ),
      ],
    );
  }
}

Tab getText(final String value) {
  return Tab(text: value);
}

BoxDecoration allGradientBoxes({
  required List<Color> color,
  required double radius,
}) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: color,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(radius),
  );
}

class Expenses {
  final String name; //Mostly on the journey
  final double totalAmount;
  final int expenseNumber;
  final String expenseID; //EXP-0000000
  Expenses(this.name, this.totalAmount, this.expenseNumber, this.expenseID);
}

