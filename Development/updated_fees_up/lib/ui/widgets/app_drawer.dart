import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Logic
import 'package:updated_fees_up/logic/view_models/dashboard_view_model.dart';
import 'package:updated_fees_up/logic/view_models/notification_view_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // -----------------------------------------------------
  // 🔒 LOGOUT / LOCK LOGIC (Offline Mode)
  // -----------------------------------------------------
  Future<void> _showLogoutDialog(BuildContext context) async {
    // 1. Close the drawer first
    if (context.mounted && Navigator.of(context).canPop()) {
      context.pop();
    }

    // 2. Show the confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2B36), // Dark Card Color
        title: const Text(
          "Confirm Exit",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to lock the console?",
          style: TextStyle(color: Colors.white70),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB5757), // Red Accent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              "Lock App",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // 3. Process the confirmation
    if (confirm == true && context.mounted) {
      // Navigate to Login (or Exit)
      // Since we don't have Auth middleware anymore, we just push to login
      context.go('/login');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Console Locked.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper to refresh dashboard when returning from a page
    void refreshDashboard() {
      if (context.mounted) {
        Provider.of<DashboardViewModel>(context, listen: false).loadDashboard();
      }
    }

    return Drawer(
      backgroundColor: const Color(0xFF121B22), // Main Background
      child: Column(
        children: [
          // ──────────────────────────────────────────────
          // 1. CUSTOM HEADER
          // ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2B36), // Slightly lighter header
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF2F80ED),
                  child: const Text(
                    "A",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Administrator",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Fees Up Admin",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ──────────────────────────────────────────────
          // 2. MENU ITEMS
          // ──────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _DrawerTile(
                  icon: Icons.dashboard_rounded,
                  title: "Dashboard",
                  onTap: () => context.pop(),
                  isActive: true, // Highlight Dashboard
                ),

                const SizedBox(height: 8),

                _DrawerTile(
                  icon: Icons.person_add_alt_1_rounded,
                  title: "Register Student",
                  onTap: () async {
                    context.pop();
                    await context.push('/addStudent');
                    refreshDashboard();
                  },
                ),

                const SizedBox(height: 8),

                _DrawerTile(
                  icon: Icons.search_rounded,
                  title: "Search / Ledger",
                  onTap: () async {
                    context.pop();
                    await context.push('/search');
                    refreshDashboard();
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Colors.white10),
                ),

                // ✅ NOTIFICATIONS TILE WITH LIVE BADGE
                Consumer<NotificationViewModel>(
                  builder: (context, notifVM, child) {
                    return _DrawerTile(
                      icon: notifVM.hasNotifications
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_rounded,
                      title: "Notifications",

                      // Badge Widget
                      trailing: notifVM.hasNotifications
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEB5757),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${notifVM.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,

                      onTap: () async {
                        context.pop();
                        await context.push('/notifications');
                        refreshDashboard();
                        // Refresh notifications to clear badges if read
                        if (context.mounted) notifVM.loadNotifications();
                      },
                      isActive: false,
                    );
                  },
                ),

                const SizedBox(height: 8),

                _DrawerTile(
                  icon: Icons.analytics_outlined,
                  title: "Monthly Evaluation",
                  onTap: () async {
                    context.pop();
                    await context.push('/evaluation', extra: 0);
                    refreshDashboard();
                  },
                ),

                const SizedBox(height: 8),

                _DrawerTile(
                  icon: Icons.picture_as_pdf_outlined,
                  title: "Export Reports",
                  subtitle: "Coming Soon",
                  onTap: () {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PDF Export coming in next update."),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ──────────────────────────────────────────────
          // 3. FOOTER
          // ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              children: [
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {
                    context.pop();
                    context.push('/profile'); // Route to AdminProfilePage
                  },
                ),

                const SizedBox(height: 8),

                // LOGOUT / LOCK
                _DrawerTile(
                  icon: Icons.lock_outline_rounded,
                  title: "Lock Console",
                  onTap: () => _showLogoutDialog(context),
                ),

                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    "v1.0.0 • Offline Mode",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPER WIDGET FOR TILES ---
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isActive;
  final Widget? trailing;

  const _DrawerTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isActive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // Style constants matching Dashboard
    final activeColor = const Color(0xFF2F80ED);
    final activeBg = activeColor.withOpacity(0.15); // Standard opacity
    final inactiveColor = Colors.grey.shade400;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: isActive
              ? BoxDecoration(
                  color: activeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: activeColor.withOpacity(0.3)),
                )
              : null,
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isActive ? Colors.white : Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: activeColor.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
