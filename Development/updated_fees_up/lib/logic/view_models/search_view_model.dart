import 'package:flutter/foundation.dart';
// 🛑 UPDATED PACKAGE NAME
import 'package:updated_fees_up/core/models/student.dart';
import 'package:updated_fees_up/core/services/database_service.dart';

class SearchViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;
  String _query = "";

  List<Student> get results => _filteredStudents;
  bool get isLoading => _isLoading;
  bool get isQueryEmpty => _query.isEmpty;

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allStudents = await _db.getAllStudents();
      // Default to showing everyone sorted by name
      _filteredStudents = List.from(_allStudents); 
    } catch (e) {
      debugPrint("Error loading search: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _query = query;
    if (query.isEmpty) {
      _filteredStudents = List.from(_allStudents);
    } else {
      final lower = query.toLowerCase();
      _filteredStudents = _allStudents.where((s) {
        // 🛑 FIX: Changed 'fullName' to 'studentName' to match the SQL column 'student_name'
        return s.studentName.toLowerCase().contains(lower) || 
               s.studentId.toLowerCase().contains(lower);
      }).toList();
    }
    notifyListeners();
  }
}