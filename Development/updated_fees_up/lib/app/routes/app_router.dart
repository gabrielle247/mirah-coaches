import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:updated_fees_up/ui/pages/dashboard_page.dart';

// View Models (For Scoped Injection)
// import 'package:fees_up/logic/view_models/student_ledger_view_model.dart';
// import 'package:fees_up/logic/view_models/logging_payments_view_model.dart';

// UI Pages
// import 'package:fees_up/ui/pages/dashboard_page.dart';
// import 'package:fees_up/ui/pages/register_student_page.dart';
// import 'package:fees_up/ui/pages/search_page.dart';
// import 'package:fees_up/ui/pages/notifications_page.dart';
// import 'package:fees_up/ui/pages/student_ledger_page.dart';
// import 'package:fees_up/ui/pages/logging_payments_page.dart';
// import 'package:fees_up/ui/pages/evaluation_page.dart';

final GoRouter mobileRouter = GoRouter(
  initialLocation: '/', 
  routes: <RouteBase>[
    // 1. Dashboard (Home)
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
      routes: [
        // 2. Register Student
        GoRoute(
          path: 'addStudent',
          builder: (context, state) => const Text("Register Student"),//RegisterStudentPage(),
        ),
    //     // 3. Search
    //     GoRoute(
    //       path: 'search',
    //       builder: (context, state) => const SearchPage(),
    //     ),
    //     // 4. Notifications
    //     GoRoute(
    //       path: 'notifications',
    //       builder: (context, state) => const NotificationsPage(),
    //     ),
    //     // 5. Monthly Evaluation (Tabs)
    //     GoRoute(
    //       path: 'evaluation',
    //       builder: (context, state) {
    //         final tabIndex = state.extra as int? ?? 0;
    //         return EvaluationPage(initialTabIndex: tabIndex);
    //       },
    //     ),
    //     // 6. Student Ledger (Requires passing Data)
    //     GoRoute(
    //       path: 'studentLedger',
    //       builder: (context, state) {
    //         final data = state.extra as Map<String, dynamic>;
    //         // Scoped Provider: Only exists while on this screen
    //         return ChangeNotifierProvider(
    //           create: (_) => StudentLedgerViewModel(data['studentId'].toString()),
    //           child: StudentLedgerPage(
    //             studentId: data['studentId'].toString(),
    //             studentName: data['studentName'] as String,
    //             enrolledSubjects: List<String>.from(data['enrolledSubjects'] ?? []),
    //           ),
    //         );
    //       },
    //     ),
    //     // 7. Log Payment
    //     GoRoute(
    //       path: 'loggingPayments',
    //       builder: (context, state) {
    //         final studentId = state.extra as String? ?? "";
    //         return ChangeNotifierProvider(
    //            create: (_) => LoggingPaymentsViewModel(),
    //            child: LoggingPaymentsPage(studentId: studentId),
    //         );
    //       },
    //     ),
      ],
    ),
  ],
);