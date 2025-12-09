// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_models/drawer_view_model.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final drawerVM = ref.watch(drawerViewModelProvider);

    return Drawer(
      child: Column(
        children: [
          // 1. HEADER (Brand Identity)
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            accountName: const Text("Nyasha Gabriel", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("Bus 001 • Harare - Byo"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "NG",
                style: TextStyle(fontSize: 24, color: theme.colorScheme.primary),
              ),
            ),
          ),

          // 2. MENU OPTIONS
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                
                // --- APP LOCK ---
                _DrawerItem(
                  icon: Icons.fingerprint,
                  title: "App Lock",
                  subtitle: "Secure with biometrics",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    ref.read(drawerViewModelProvider).triggerAppLock(context);
                  },
                ),

                const Divider(),

                // --- CHECK BALANCES ---
                _DrawerItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Check Balances",
                  subtitle: "View trip totals",
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/balancing'); // Navigates to your existing BalancingPage
                  },
                ),

                // --- ANNOUNCEMENTS ---
                _DrawerItem(
                  icon: Icons.campaign_outlined,
                  title: "Announcements",
                  subtitle: "Broadcasts & Messages",
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No new announcements")),
                    );
                  },
                ),

                // --- ROUTE SETTINGS ---
                _DrawerItem(
                  icon: Icons.alt_route_outlined,
                  title: "Route Settings",
                  subtitle: "Switch Trip A / Trip B",
                  onTap: () {
                    Navigator.pop(context);
                    // This could open a dialog to select the active trip
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Route switched to Return Trip")),
                    );
                  },
                ),

                // --- PRINT SETTINGS ---
                SwitchListTile(
                  secondary: Icon(Icons.print_outlined, color: theme.colorScheme.primary),
                  title: const Text("Thermal Print Format"),
                  subtitle: Text(drawerVM.useThermalFormat ? "Enabled (Small)" : "Disabled (A4)"),
                  value: drawerVM.useThermalFormat,
                  activeThumbColor: theme.colorScheme.secondary,
                  onChanged: (val) => ref.read(drawerViewModelProvider).togglePrintFormat(),
                ),

                const Divider(),

                // --- ADMIN AUDITING (Protected) ---
                _DrawerItem(
                  icon: Icons.admin_panel_settings_outlined,
                  title: "Admin Auditing",
                  subtitle: "Clear trips & Cash drops",
                  iconColor: theme.colorScheme.secondary, // Red for caution
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(drawerViewModelProvider).openAdminPanel(context);
                  },
                ),
              ],
            ),
          ),

          // 3. FOOTER
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Batch One v1.0.0",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for consistent styling
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      onTap: onTap,
    );
  }
}