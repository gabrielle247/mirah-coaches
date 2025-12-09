import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod All The Way

import 'utils/theme.dart';
import 'utils/routes.dart';
// import 'view_models/home_view_model.dart';
// import 'view_models/balancing_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    // 1. ProviderScope: The single source of truth for the entire app
    const ProviderScope(
      child: MirahCoachesApp(),
    ),
  );
}

class MirahCoachesApp extends ConsumerWidget {
  const MirahCoachesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Watch the Router (defined in utils/routes.dart)
    final router = appRoutes(); 

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mirah Coaches',
      
      // Theme Configuration (Stubbed)
      theme: AppTheme.lightTheme,
      
      // Routing Configuration
      routerConfig: router,
    );
  }
}



// ------------------------------------------------------------------------------
// FOLDER: lib/view_models/
// FILE: balancing_view_model.dart
// ------------------------------------------------------------------------------
// 1. The Provider Declaration (Global)
final balancingViewModelProvider = ChangeNotifierProvider<BalancingViewModel>((ref) {
  return BalancingViewModel();
});

// 2. The Logic Class
class BalancingViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void loadData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Fake loading
    _isLoading = false;
    notifyListeners();
  }
}



// ------------------------------------------------------------------------------
// FOLDER: lib/pages/
// FILE: balancing_page.dart
// ------------------------------------------------------------------------------
