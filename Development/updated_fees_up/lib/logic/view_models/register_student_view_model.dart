import 'package:flutter/foundation.dart';
import 'package:updated_fees_up/core/services/database_service.dart';

class RegisterStudentViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  // State
  String studentName = '';
  String grade = 'Form 1';
  String parentContact = '';
  List<String> selectedSubjects = [];
  double negotiatedFee = 0.0;
  String frequency = 'Monthly';
  String billingMode = 'monthly';

  // Setters
  void updateStudentName(String val) { studentName = val; notifyListeners(); }
  void updateGrade(String val) { grade = val; notifyListeners(); }
  void updateParentContact(String val) { parentContact = val; notifyListeners(); }
  void updateSelectedSubjects(List<String> val) { selectedSubjects = val; notifyListeners(); }
  void updateNegotiatedFee(String val) { negotiatedFee = double.tryParse(val) ?? 0.0; notifyListeners(); }

  bool validate() {
    return studentName.isNotEmpty && negotiatedFee > 0 && grade.isNotEmpty;
  }

  Future<String?> registerStudent() async {
    if (!validate()) return null;

    return await _db.registerNewStudent(
      fullName: studentName,
      grade: grade,
      baseFee: negotiatedFee,
      parentContact: parentContact,
      subjects: selectedSubjects,
      billingMode: billingMode,
      frequency: frequency,
      adminUid: "offline_admin",
    );
  }
}