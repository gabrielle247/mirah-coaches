// lib/utils/tabs/passengers_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/passengers_view_model.dart';
import '../../widgets/ticket_card.dart'; // Ensure this is imported

class PassengersTab extends ConsumerWidget {
  const PassengersTab({super.key}); 
  // removed 'required this.ticketsList' because we fetch it ourselves now!

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(passengersViewModelProvider);
    final theme = Theme.of(context);

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        // 1. THE TITLE (Added as requested)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Passengers", 
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary, // Brand Blue
                  ),
                ),
                Text(
                  "Full manifest for this session",
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const Divider(), // Optional line separator
              ],
            ),
          ),
        ),

        // 2. THE LIST
        vm.allTickets.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(child: Text("No passengers recorded yet.")),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ticket = vm.allTickets[index];
                    return TicketCard(ticket: ticket);
                  },
                  childCount: vm.allTickets.length,
                ),
              ),
              
         // Bottom Padding
        const SliverToBoxAdapter(child: SizedBox(height: 50)),
      ],
    );
  }
}