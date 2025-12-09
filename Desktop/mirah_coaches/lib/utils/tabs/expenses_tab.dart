import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirah_coaches/widgets/ticket_card.dart';
import '../../view_models/expenses_view_model.dart'; // Ensure this points to your PaymentItem widget// Reuse your validators

class ExpensesTab extends ConsumerWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(expensesViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      // 1. THE FAB (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, ref),
        backgroundColor: theme.colorScheme.secondary, // Brand Red
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Expense"),
      ),
      
      // 2. THE BODY
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // TOTAL EXPENSE CARD
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.secondary,
                            const Color(0xFF8B0000)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.secondary.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "TOTAL EXPENSES",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$${vm.totalExpenseAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // LIST TITLE
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Expense History",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.grey.shade700),
                    ),
                  ),
                ),

                // EXPENSE LIST
                vm.expensesList.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text("No expenses recorded.")),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final expense = vm.expensesList[index];
                            return PaymentItem(expenses: expense);
                          },
                          childCount: vm.expensesList.length,
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)), // Space for FAB
              ],
            ),
    );
  }

  // --- 3. THE SMART DIALOG ---
  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to use Close button
      builder: (ctx) => _AddExpenseDialog(ref: ref),
    );
  }
}

// --- PRIVATE STATEFUL WIDGET FOR DIALOG LOGIC ---
class _AddExpenseDialog extends StatefulWidget {
  final WidgetRef ref;
  const _AddExpenseDialog({required this.ref});

  @override
  State<_AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<_AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _customNameController = TextEditingController();

  // Predetermined list
  final List<String> _expenseTypes = [
    "Fuel",
    "Tollgate",
    "Driver Allowance",
    "Bus Maintenance",
    "Council Levy",
    "Other (Custom)"
  ];

  String? _selectedType;

  @override
  void dispose() {
    _amountController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Determine final name
      String finalName = _selectedType == "Other (Custom)"
          ? _customNameController.text
          : _selectedType!;

      double amount = double.parse(_amountController.text);

      // Call View Model
      widget.ref.read(expensesViewModelProvider).addExpense(finalName, amount);

      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Added Successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink to fit content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER with Close Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add New Expense", style: theme.textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // 1. SPINNER (Dropdown)
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: "Expense Type",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _expenseTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                  });
                },
                validator: (val) => val == null ? "Please select a type" : null,
              ),
              const SizedBox(height: 16),

              // 2. CUSTOM NAME FIELD (Only if "Other" is selected)
              if (_selectedType == "Other (Custom)") ...[
                TextFormField(
                  controller: _customNameController,
                  maxLength: 30, // Limit words/length
                  decoration: const InputDecoration(
                    labelText: "Name: Description",
                    hintText: "e.g. Mechanic: Brake Fix",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return "Description required";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 3. AMOUNT FIELD
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Amount (\$)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) {
                  // Reuse your strict validator or add custom logic here
                  if (val == null || val.isEmpty) return "Amount required";
                  final num = double.tryParse(val);
                  if (num == null) return "Invalid number";
                  if (num > 10000) return "Limit exceeded (Max \$10,000)";
                  if (num <= 0) return "Must be greater than 0";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 4. SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.secondary, // Brand Red
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("SAVE EXPENSE"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}