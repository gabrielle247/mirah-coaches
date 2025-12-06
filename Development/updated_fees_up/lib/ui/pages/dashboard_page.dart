import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // For direct sync triggers if needed
import 'package:updated_fees_up/core/models/student.dart';
import 'package:updated_fees_up/logic/view_models/dashboard_view_model.dart';
import 'package:updated_fees_up/logic/view_models/notification_view_model.dart';
import 'package:updated_fees_up/ui/widgets/app_drawer.dart';
import 'package:updated_fees_up/ui/widgets/empty_list_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Local state for the Tab Filter (All / Paid / Overdue)
  int _selectedFilterIndex = 0; // 0 = All, 1 = Paid, 2 = Overdue

  @override
  void initState() {
    super.initState();
    // Initial Data Load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = Provider.of<DashboardViewModel>(context, listen: false);
      await vm.loadDashboard();

      // Check for new bills to show snackbar
      if (vm.newBillsGeneratedCount > 0 && mounted) {
        Provider.of<NotificationViewModel>(context, listen: false).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${vm.newBillsGeneratedCount} new bills generated."),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    // 1. Filter Logic
    List<Student> displayList;
    if (_selectedFilterIndex == 1) {
      displayList = vm.paidStudentsCurrentMonth;
    } else if (_selectedFilterIndex == 2) {
      displayList = vm.unpaidStudentsCurrentMonth;
    } else {
      displayList = vm.students; // All
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: const Color(
          0xFF121B22,
        ), // Deep Dark Background from design
        drawer: const AppDrawer(),

        // FAB: Add Student
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF2F80ED), // Bright Blue
          onPressed: () async {
            await context.push("/addStudent");
            if (mounted) vm.loadDashboard();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),

        body: RefreshIndicator(
          onRefresh: () async => vm.refreshData(),
          child: CustomScrollView(
            slivers: [
              // --- 1. APP BAR ---
              SliverAppBar(
                floating: true,
                pinned: false,
                backgroundColor: const Color(0xFF121B22),
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: [
                  Consumer<NotificationViewModel>(
                    builder: (_, notifVM, __) => IconButton(
                      onPressed: () => context.push('/notifications'),
                      icon: Badge(
                        isLabelVisible: notifVM.hasNotifications,
                        label: Text('${notifVM.unreadCount}'),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // --- 2. METRICS CARDS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          title: "Current Month\nPayments",
                          value: vm.totalCollectedFormatted,
                          color: const Color(0xFF1E2B36), // Dark Card
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          title: "Overdue\nPayments",
                          value: vm.totalOverdueFormatted,
                          color: const Color(0xFF1E2B36),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 3. SEARCH BAR ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () async {
                      await context.push('/search');
                      if (mounted) vm.loadDashboard();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2B36),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade500),
                          const SizedBox(width: 12),
                          Text(
                            "Search students by name or ID",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- 4. TABS (All / Paid / Overdue) ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2B36),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _TabButton(
                          "All",
                          0,
                          _selectedFilterIndex,
                          (i) => setState(() => _selectedFilterIndex = i),
                        ),
                        _TabButton(
                          "Paid",
                          1,
                          _selectedFilterIndex,
                          (i) => setState(() => _selectedFilterIndex = i),
                        ),
                        _TabButton(
                          "Overdue",
                          2,
                          _selectedFilterIndex,
                          (i) => setState(() => _selectedFilterIndex = i),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- 5. LOADING STATE ---
              if (vm.isLoading && !vm.isSyncing)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              // --- 6. STUDENT LIST ---
              else if (displayList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: EmptyListWidget(
                      () => context.push("/addStudent"),
                      "No students found",
                      "Adjust your filter or add a new student.",
                      Icons.people_outline,
                      "Add Student",
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final student = displayList[index];
                      final isOverdue = vm.isStudentOverdue(student.studentId);

                      return _StudentListTile(
                        student: student,
                        isOverdue: isOverdue,
                        onTap: () async {
                          // TODO: Create/Verify Student Ledger Page existence
                          await context.push(
                            '/studentLedger',
                            extra: {
                              'studentId': student.studentId,
                              'studentName': student.studentName,
                              'enrolledSubjects': student.subjects,
                            },
                          );
                          if (mounted) vm.loadDashboard();
                        },
                      );
                    }, childCount: displayList.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 🎨 CUSTOM WIDGETS (Private to this file for now)
// -----------------------------------------------------------------------------

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color textColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 28, // Big Bold Number
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const _TabButton(this.label, this.index, this.selectedIndex, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2F80ED) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentListTile extends StatelessWidget {
  final Student student;
  final bool isOverdue;
  final VoidCallback onTap;

  const _StudentListTile({
    required this.student,
    required this.isOverdue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a consistent color based on name length for avatar bg
    final avatarColor =
        Colors.primaries[student.studentName.length % Colors.primaries.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2B36),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        // Avatar
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: avatarColor.withOpacity(0.2),
          // Placeholder logic for image, real app would load from student.imageUrl
          child: Text(
            student.studentName.isNotEmpty
                ? student.studentName[0].toUpperCase()
                : '?',
            style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold),
          ),
        ),
        // Name & ID
        title: Text(
          student.studentName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "ID: ${student.studentId}", // Using the public 'STU-XXX' ID
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ),
        // Status Badge
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isOverdue
                ? const Color(0xFFEB5757).withOpacity(0.15) // Red bg
                : const Color(0xFF27AE60).withOpacity(0.15), // Green bg
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOverdue ? "Overdue" : "Paid",
            style: TextStyle(
              color: isOverdue
                  ? const Color(0xFFEB5757)
                  : const Color(0xFF27AE60),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
