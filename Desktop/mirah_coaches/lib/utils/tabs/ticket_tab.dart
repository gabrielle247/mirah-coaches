// lib/utils/tabs/ticket_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirah_coaches/view_models/ticket_tab_view_model.dart';
import '../../models/models.dart'; // Import Trip model
import '../../utils/validators.dart';

class TicketTab extends ConsumerStatefulWidget {
  const TicketTab({super.key});

  @override
  ConsumerState<TicketTab> createState() => _TicketTabState();
}

class _TicketTabState extends ConsumerState<TicketTab> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _amountController = TextEditingController();
  final _luggageController = TextEditingController(); // Optional charge

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _amountController.dispose();
    _luggageController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Prepare charges list
      List<String> charges = ["Bus Fare"];
      if (_luggageController.text.isNotEmpty) {
        charges.add("Luggage");
      }

      // Call ViewModel
      final success = await ref.read(ticketViewModelProvider).submitTicket(
        name: _nameController.text,
        from: _fromController.text,
        to: _toController.text,
        amount: double.parse(_amountController.text),
        charges: charges,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ticket Generated Successfully!")),
        );
        // Clear form for next passenger
        _nameController.clear();
        _amountController.clear();
        _luggageController.clear();
        // We purposefully DON'T clear From/To so they persist for the next passenger on the same trip
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketVM = ref.watch(ticketViewModelProvider);
    final theme = Theme.of(context);

    // Reusable Decoration Logic
    InputDecoration getDecor(String hint, IconData icon) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14.0),
        prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trip Details", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            // 1. TRIP DROPDOWN (The "Auto-Fill" Feature)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueGrey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Trip>(
                  value: ticketVM.selectedTrip,
                  hint: const Text("Select Current Route"),
                  isExpanded: true,
                  items: ticketVM.availableTrips.map((Trip trip) {
                    return DropdownMenuItem<Trip>(
                      value: trip,
                      child: Text("${trip.routeFrom} ➝ ${trip.routeTo}"),
                    );
                  }).toList(),
                  onChanged: (Trip? newTrip) {
                    // Update ViewModel and Auto-fill controllers
                    ref.read(ticketViewModelProvider).selectTrip(
                      newTrip, 
                      _fromController, 
                      _toController, 
                      _amountController
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text("Passenger Info", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            // 2. NAME
            TextFormField(
              controller: _nameController,
              decoration: getDecor("Passenger Name", Icons.person),
              validator: Validators.validateName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // 3. FROM (Auto-filled but editable)
            TextFormField(
              controller: _fromController,
              decoration: getDecor("Journey From", Icons.logout),
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),

            // 4. TO (Auto-filled but editable)
            TextFormField(
              controller: _toController,
              decoration: getDecor("Journey To", Icons.login),
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),

            // 5. FARE
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: getDecor("Bus Fare (\$)", Icons.attach_money),
              validator: Validators.validateMoney,
            ),
            const SizedBox(height: 16),

            // 6. LUGGAGE (Optional)
            TextFormField(
              controller: _luggageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: getDecor("Luggage Fee (Optional)", Icons.business_center),
            ),

            const SizedBox(height: 30),

            // 7. SUBMIT BUTTON
            ElevatedButton(
              onPressed: ticketVM.isLoading ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: ticketVM.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Generate Ticket", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}