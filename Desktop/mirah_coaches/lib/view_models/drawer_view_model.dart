// lib/view_models/drawer_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';

final drawerViewModelProvider = ChangeNotifierProvider<DrawerViewModel>((ref) {
  return DrawerViewModel();
});

class DrawerViewModel extends ChangeNotifier {
  
  // --- 1. APP LOCK (Local Auth Logic) ---
  Future<void> triggerAppLock(BuildContext context) async {
    // In a real app, use the 'local_auth' package here.
    // For now, we simulate a system lock by showing a secure dialog.
    
    bool authenticated = await _simulateLocalAuth(context);
    
    if (authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication Successful: App Unlocked")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication Failed"), backgroundColor: Colors.red),
      );
    }
  }

  Future<bool> _simulateLocalAuth(BuildContext context) async {
    // This simulates the FaceID/Fingerprint delay
    await Future.delayed(const Duration(seconds: 1));
    return true; // Assume success for testing
  }

  // --- 2. ADMIN AUDIT (Password Protection) ---
  void openAdminPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final passController = TextEditingController();
        return AlertDialog(
          title: const Text("Admin Access"),
          content: TextField(
            controller: passController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter Admin PIN",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Hardcoded Admin PIN for now (e.g., 1234)
                if (passController.text == "1234") {
                  Navigator.pop(ctx); // Close dialog
                  // Navigate to Admin Page (Stub)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Access Granted: Clearing Trips...")),
                  );
                  // context.push('/admin'); // Uncomment when route exists
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Wrong PIN"), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  // --- 3. PRINT SETTINGS TOGGLE ---
  bool _useThermalFormat = true;
  bool get useThermalFormat => _useThermalFormat;

  void togglePrintFormat() {
    _useThermalFormat = !_useThermalFormat;
    notifyListeners();
  }
}