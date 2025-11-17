import 'package:flutter/material.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    // Use standard text themes for consistency
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.secondary, // Use your Brand Red or Grey
        );
    final valueStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary, // Use your Brand Blue
        );

    return IntrinsicHeight( // Ensures both boxes stretch to the same height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [
          // 1. Route Card
          _buildStatCard(
            context,
            label: "Current Route",
            labelStyle: labelStyle,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Harare", style: valueStyle),
                Icon(Icons.arrow_downward, size: 16, color: Colors.grey), // Visual cue
                Text("Bulawayo", style: valueStyle),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // 2. Passenger Count Card
          _buildStatCard(
            context,
            label: "Onboard",
            labelStyle: labelStyle,
            content: Text("152", style: valueStyle?.copyWith(fontSize: 32)),
          ),
        ],
      ),
    );
  }

  // --- The Reusable Widget ---
  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required Widget content,
    TextStyle? labelStyle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface, // Light grey background
          border: Border.all(
            // Use outlineVariant for subtle borders (Material 3 standard)
            color: Theme.of(context).colorScheme.outlineVariant, 
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces label and content
          children: [
            Text(label.toUpperCase(), style: labelStyle),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
