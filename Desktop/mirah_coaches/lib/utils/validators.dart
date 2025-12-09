// lib/utils/validators.dart

class Validators {
  // STRICT MONEY ($0.50 - $500.00)
  static String? validateMoney(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount required';
    final regex = RegExp(r'^\d*\.?\d+$');
    if (!regex.hasMatch(value)) return 'Invalid format (e.g. 10.50)';
    
    final number = double.tryParse(value);
    if (number == null) return 'Invalid number';
    if (number < 0.50) return 'Min \$0.50';
    if (number > 500.00) return 'Max \$500.00';
    return null;
  }

  // NAME
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (value.length < 2) return 'Too short';
    return null;
  }
}