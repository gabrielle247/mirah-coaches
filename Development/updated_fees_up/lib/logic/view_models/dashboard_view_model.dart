import 'package:flutter/foundation.dart';
import 'package:updated_fees_up/core/services/database_service.dart';
import 'package:updated_fees_up/core/models/student.dart';
import 'package:updated_fees_up/core/models/bill.dart';
import 'package:updated_fees_up/logic/utils/dashboard_calculator.dart';

class DashboardViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  // --- STATE ---
  List<Student> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- METRICS ---
  double _totalCollectedThisMonth = 0.0;
  double _totalOverdueAllTime = 0.0;
  int _newBillsGeneratedCount = 0;
  
  final List<Student> _paidStudentsCurrentMonth = [];
  final List<Student> _unpaidStudentsCurrentMonth = [];
  final Map<String, BillStatus> _studentFinancialStatus = {};

  // --- GETTERS ---
  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  bool get isSyncing => false; // Disabled for offline
  String? get errorMessage => _errorMessage;
  
  int get newBillsGeneratedCount => _newBillsGeneratedCount;
  String get totalCollectedFormatted => "\$${_totalCollectedThisMonth.toStringAsFixed(2)}";
  String get totalOverdueFormatted => "\$${_totalOverdueAllTime.toStringAsFixed(2)}";
  int get totalStudents => _students.length;

  List<Student> get paidStudentsCurrentMonth => _paidStudentsCurrentMonth;
  List<Student> get unpaidStudentsCurrentMonth => _unpaidStudentsCurrentMonth;

  bool isStudentOverdue(String studentId) {
    return _studentFinancialStatus[studentId] == BillStatus.overdue;
  }

  // --- ACTIONS ---

  Future<void> loadDashboard() async {
    _setLoading(true);
    _clearError();
    try {
      // 1. Run local automation (Generate bills for new month)
      // Note: Ensure your DatabaseService has this method implemented!
      // If not, we can implement it here, but it's cleaner in the service.
      // _newBillsGeneratedCount = await _db.ensureBillsForAllStudents(); 
      _newBillsGeneratedCount = 0; // Placeholder if method missing in Service

      // 2. Fetch Data
      await _fetchAndCalculateLocalData();
    } catch (e) {
      _setError("Failed to load dashboard: $e");
      debugPrint("Error loading dashboard: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshData() async {
    notifyListeners();
    await loadDashboard();
  }

  Future<void> _fetchAndCalculateLocalData() async {
    final students = await _db.getAllStudents();
    
    // We need to fetch bills and payments to calculate status
    // Assuming DB service has getAllBills/Payments. If not, we fetch by student loop (slower)
    // or add getAll methods to DatabaseService.
    
    // For now, let's assume we add these methods to DatabaseService:
    final allBills = await _db.getAllBills(); 
    final allPayments = await _db.getAllPayments();

    final metrics = calculateDashboardMetrics(
      students: students,
      allBills: allBills,
      allPayments: allPayments,
    );

    _students = metrics.sortedStudents;
    _totalCollectedThisMonth = metrics.totalCollectedThisMonth;
    _totalOverdueAllTime = metrics.totalOverdueAllTime;

    _paidStudentsCurrentMonth
      ..clear()
      ..addAll(metrics.paidStudentsCurrentMonth);
      
    _unpaidStudentsCurrentMonth
      ..clear()
      ..addAll(metrics.unpaidStudentsCurrentMonth);
      
    _studentFinancialStatus
      ..clear()
      ..addAll(metrics.studentFinancialStatus);

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}