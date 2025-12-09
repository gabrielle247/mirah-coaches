// lib/utils/tabs/dashboard_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../widgets/ticket_card.dart'; // Ensure you have this widget created/moved
// import '../../utils/theme.dart'; // Optional if you need specific constants

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the ViewModel - this triggers a rebuild whenever notifyListeners() is called
    final dashboardVM = ref.watch(dashboardViewModelProvider);
    final theme = Theme.of(context);

    if (dashboardVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        // 1. Stats Cards Area
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        colors: const [Color(0xff2196f3), Color(0xff003366)],
                        value: "${dashboardVM.totalPassengers}",
                        title: "Passengers",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        colors: const [Color(0xff28a745), Color(0xff15401a)],
                        value: "${dashboardVM.onboardCount}",
                        title: "Onboard",
                      ),
                    ),
                  ],
                ),
              ),

              // "Recently Added" Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Recently Added Passengers",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. The List of Tickets
        dashboardVM.recentTickets.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "No recent passengers found.",
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ticket = dashboardVM.recentTickets[index];
                    // Using your existing TicketCard widget (ensure it's imported)
                    // If TicketCard is not yet in lib/widgets, you might need to move it there.
                    return TicketCard(ticket: ticket);
                  },
                  childCount: dashboardVM.recentTickets.length,
                ),
              ),
              
        // Bottom Padding for scrollability
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}

// --- Private Helper Widget for the Stats Cards ---
// Replaces your old 'cartView' function with a proper Widget class for better performance
class _StatCard extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final String value;

  const _StatCard({
    required this.colors,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12), // Added rounded corners for better UI
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70, // Slightly transparent for subtitle
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}