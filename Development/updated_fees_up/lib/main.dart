import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:updated_fees_up/app/app_providers.dart';
import 'package:updated_fees_up/app/routes/app_router.dart';
import 'package:updated_fees_up/core/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final dbService = DatabaseService();
  await dbService.init();

  runApp(const FeesUpApp());
}

class FeesUpApp extends StatelessWidget {
  const FeesUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: globalAppProviders(), // 👈 Updated to function call
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Fees Up',
        // 🎨 THEME: Dark Financial Dashboard Theme
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: const Color(0xff3498db),
            onPrimary: const Color(0xffffffff),
            secondary: const Color(0xff2ecc71),
            onSecondary: const Color(0xffffffff),
            surface: const Color(0xff1c2a35),
            onSurface: Colors.white,
            error: const Color(0xffff4c4c),
            onError: const Color(0xffffffff),
            tertiary: Colors.blueGrey.shade800,
            onTertiary: const Color(0xffffffff),
          ),
          scaffoldBackgroundColor: const Color(0xff121b22),
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        routerConfig: mobileRouter, 
      ),
    );
  }
}
