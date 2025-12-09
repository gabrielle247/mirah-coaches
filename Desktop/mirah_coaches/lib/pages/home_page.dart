import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirah_coaches/widgets/app_drawer.dart';
// import '../utils/theme.dart'; // Using your new Theme file
import '../view_models/home_view_model.dart'; // Importing the Riverpod Provider

import '../utils/tabs/tab_imports.dart'; // Importing all tabs

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // We have 4 tabs: Home, Ticket, Passengers, Balancing (Expenses was renamed/moved in your flow)
    _tabController = TabController(length: 4, vsync: this);

    // Optional: Sync TabController with Riverpod State if needed
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(homeViewModelProvider).changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);
    // final homeVM = ref.watch(homeViewModelProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary, // Brand Blue
        centerTitle: true,
        title: const Text("Mirah Coaches"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary, // Brand Red
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.6),
          tabs: const [
            Tab(text: "HOME"),
            Tab(text: "TICKET"),
            Tab(text: "PASSENGERS"),
            Tab(
              text: "SUMMARY",
            ), // Changed "EXPENSES" to "SUMMARY" to match BalancingPage
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardTab(), // Tab 1
          TicketTab(), // Tab 2
          PassengersTab(), // Tab 3 (Make sure this widget fetches its own data now!)
          ExpensesTab(), // Tab 4
        ],
      ),
    );
  }
}
