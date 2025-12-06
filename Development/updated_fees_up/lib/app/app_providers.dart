import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

// Logic Imports
import 'package:updated_fees_up/logic/view_models/dashboard_view_model.dart';
import 'package:updated_fees_up/logic/view_models/notification_view_model.dart';
import 'package:updated_fees_up/logic/view_models/register_student_view_model.dart';
import 'package:updated_fees_up/logic/view_models/search_view_model.dart';
// Note: LoggingPayments and StudentLedger are NOT imported here because they are "Scoped" providers.

List<SingleChildWidget> globalAppProviders() {
  return [
    ChangeNotifierProvider(create: (_) => DashboardViewModel()),
    ChangeNotifierProvider(create: (_) => RegisterStudentViewModel()),
    ChangeNotifierProvider(create: (_) => NotificationViewModel()),
    ChangeNotifierProvider(create: (_) => SearchViewModel()),
    
    // 🛑 REMOVED: StudentLedgerViewModel & LoggingPaymentsViewModel
    // These are injected by the Router only when needed, because they require specific data (studentId).
  ];
}
