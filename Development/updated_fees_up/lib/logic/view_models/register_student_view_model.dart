import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:updated_fees_up/core/models/student.dart';
import 'package:uuid/uuid.dart';

// MODELS
import 'package:fees_up/features/students/data/student_model.dart';

// SERVICES
// ✅ Import the service we created earlier
import 'package:fees_up/features/students/services/registration_service.dart';

// --- STATE CLASS ---
class RegisterStudentState {
  final bool isLoading;
  final String? error;

  // Form Fields
  final String fullName;
  final String parentContact;
  final String grade;
  final double monthlyFee;
  final double initialPayment;
  final List<String> subjects;
  final String frequency;
  final DateTime registrationDate;

  const RegisterStudentState({
    this.isLoading = false,
    this.error,
    this.fullName = '',
    this.parentContact = '',
    this.grade = 'Form 1',
    this.monthlyFee = 0.0,
    this.initialPayment = 0.0,
    this.subjects = const [],
    this.frequency = 'Monthly',
    required this.registrationDate,
  });

  RegisterStudentState copyWith({
    bool? isLoading,
    String? error,
    String? fullName,
    String? parentContact,
    String? grade,
    double? monthlyFee,
    double? initialPayment,
    List<String>? subjects,
    String? frequency,
    DateTime? registrationDate,
  }) {
    return RegisterStudentState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      fullName: fullName ?? this.fullName,
      parentContact: parentContact ?? this.parentContact,
      grade: grade ?? this.grade,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      initialPayment: initialPayment ?? this.initialPayment,
      subjects: subjects ?? this.subjects,
      frequency: frequency ?? this.frequency,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }
}

// --- PROVIDER ---
final registerStudentControllerProvider =
    StateNotifierProvider.autoDispose<
      RegisterStudentController,
      RegisterStudentState
    >((ref) {
      // ✅ Inject the service
      final service = ref.watch(registrationServiceProvider);
      return RegisterStudentController(service);
    });

// --- CONTROLLER ---
class RegisterStudentController extends StateNotifier<RegisterStudentState> {
  // ✅ Use Service instead of raw Repo
  final RegistrationService _registrationService;
  final Uuid _uuid = const Uuid();

  RegisterStudentController(this._registrationService)
    : super(RegisterStudentState(registrationDate: DateTime.now()));

  // --- FIELD UPDATERS ---
  void updateName(String val) => state = state.copyWith(fullName: val);
  void updateContact(String val) => state = state.copyWith(parentContact: val);
  void updateGrade(String val) => state = state.copyWith(grade: val);

  void updateFee(String val) =>
      state = state.copyWith(monthlyFee: double.tryParse(val) ?? 0.0);
  void updateInitialPayment(String val) =>
      state = state.copyWith(initialPayment: double.tryParse(val) ?? 0.0);
  void updateSubjects(List<String> val) =>
      state = state.copyWith(subjects: val);

  void updateFrequency(String val) {
    state = state.copyWith(frequency: val);
    updateDate(state.registrationDate);
  }

  void updateDate(DateTime date) {
    if (state.frequency == 'Monthly') {
      if (date.day > 28) {
        final corrected = DateTime(date.year, date.month, 28);
        state = state.copyWith(registrationDate: corrected);
      } else {
        state = state.copyWith(registrationDate: date);
      }
    } else {
      state = state.copyWith(registrationDate: date);
    }
  }

  // --- SAVE LOGIC ---
  Future<bool> register() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newId = _uuid.v4();

      final student = Student(
        id: newId,
        fullName: state.fullName,
        grade: state.grade,
        parentContact: state.parentContact,
        registrationDate: state.registrationDate,
        baseFee: state.monthlyFee,
        subjects: state.subjects,
        isActive: true,
      );

      // ✅ Call the Service to handle Student + Bill + Payment
      await _registrationService.registerStudentWithFinancials(
        student: student,
        monthlyFee: state.monthlyFee,
        initialPayment: state.initialPayment,
        frequency: state.frequency,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
