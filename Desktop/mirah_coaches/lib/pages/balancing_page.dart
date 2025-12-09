import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/balancing_view_model.dart';
import '../models/models.dart';

// Converted to ConsumerStatefulWidget for Riverpod
class BalancingPage extends ConsumerStatefulWidget {
  const BalancingPage({super.key});

  @override
  ConsumerState<BalancingPage> createState() => _BalancingPageState();
}

class _BalancingPageState extends ConsumerState<BalancingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Trigger data load using Riverpod
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(balancingViewModelProvider).loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state
    final vm = ref.watch(balancingViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journey Summary"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary, // Brand Red
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: "OUTBOUND"),
            Tab(text: "INBOUND"),
          ],
        ),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _SimpleBalanceSheet(
                  tickets: vm.fromTickets,
                  expenses: vm.fromExpenses,
                  netProfit: vm.fromNetProfit,
                  title: "Harare ➝ Masvingo",
                ),
                _SimpleBalanceSheet(
                  tickets: vm.toTickets,
                  expenses: vm.toExpenses,
                  netProfit: vm.toNetProfit,
                  title: "Masvingo ➝ Harare",
                ),
              ],
            ),
    );
  }
}

// --- SIMPLIFIED SHEET ---
class _SimpleBalanceSheet extends StatelessWidget {
  final List<Ticket> tickets;
  final List<Expenses> expenses;
  final double netProfit;
  final String title;

  const _SimpleBalanceSheet({
    required this.tickets,
    required this.expenses,
    required this.netProfit,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. CLEAN SUMMARY CARD
        Card(
          color: theme.colorScheme.primary, // Brand Blue
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(title, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                const Text("CASH ON HAND", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                Text(
                  "\$${netProfit.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // 2. TICKETS SECTION (Simple Header)
        if (tickets.isNotEmpty) ...[
          _header("Revenue (${tickets.length})"),
          ...tickets.map((t) => _CompactTile(
            label: t.passengerName, 
            subLabel: t.ticketID, 
            amount: t.amount, 
            isIncome: true
          )),
        ],

        const SizedBox(height: 16),

        // 3. EXPENSES SECTION
        if (expenses.isNotEmpty) ...[
          _header("Expenses (${expenses.length})"),
          ...expenses.map((e) => _CompactTile(
            label: e.name, 
            subLabel: "#${e.expenseNumber}", 
            amount: e.totalAmount, 
            isIncome: false
          )),
        ],

        if (tickets.isEmpty && expenses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text("No data recorded yet", style: TextStyle(color: Colors.grey))),
          ),
      ],
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}

// --- COMPACT TILE (Cleaner Look) ---
class _CompactTile extends StatelessWidget {
  final String label;
  final String subLabel;
  final double amount;
  final bool isIncome;

  const _CompactTile({
    required this.label,
    required this.subLabel,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Icon Indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isIncome ? Colors.blue.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isIncome ? Colors.blue : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          
          // Amount
          Text(
            "${isIncome ? '+' : '-'} \$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.black87 : const Color(0xFFCC0000),
            ),
          ),
        ],
      ),
    );
  }
}