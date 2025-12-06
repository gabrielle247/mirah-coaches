import 'package:intl/intl.dart';
import 'package:updated_fees_up/core/models/student.dart';
import 'package:updated_fees_up/core/models/bill.dart';
import 'package:updated_fees_up/core/models/payment.dart';

class DashboardMetrics {
  final List<Student> sortedStudents;
  final double totalCollectedThisMonth;
  final double totalOverdueAllTime;
  final List<Student> paidStudentsCurrentMonth;
  final List<Student> unpaidStudentsCurrentMonth;
  final Map<String, BillStatus> studentFinancialStatus;

  DashboardMetrics({
    required this.sortedStudents,
    required this.totalCollectedThisMonth,
    required this.totalOverdueAllTime,
    required this.paidStudentsCurrentMonth,
    required this.unpaidStudentsCurrentMonth,
    required this.studentFinancialStatus,
  });
}

DashboardMetrics calculateDashboardMetrics({
  required List<Student> students,
  required List<Bill> allBills,
  required List<Payment> allPayments,
}) {
  final now = DateTime.now();
  final currentMonthKey = DateFormat('yyyy-MM').format(now);
  
  double monthlyCashFlow = 0.0;
  double totalDebt = 0.0;
  
  final paidStudents = <Student>[];
  final unpaidStudents = <Student>[];
  final studentStatusMap = <String, BillStatus>{};

  // 1. Sort students by Name
  students.sort((a, b) => a.studentName.compareTo(b.studentName));
  final activeStudents = students.where((s) => s.isActive).toList();

  // 2. Prepare Bill Map for current month
  // We identify if a bill exists for this specific month key
  final Map<String, Bill> currentMonthBills = {};
  
  for (var bill in allBills) {
    // Format: 2025-12
    final billMonthKey = DateFormat('yyyy-MM').format(bill.monthYear);
    
    if (billMonthKey == currentMonthKey) {
      currentMonthBills[bill.studentId] = bill;
    }
    
    // Default status initialization
    if (studentStatusMap[bill.studentId] == null) {
      studentStatusMap[bill.studentId] = BillStatus.paid;
    }
  }

  // 3. Categorize Students (Paid vs Unpaid/Overdue)
  for (var student in activeStudents) {
    final bill = currentMonthBills[student.studentId];
    
    // If bill exists and is fully paid
    if (bill != null && bill.isPaid) {
      paidStudents.add(student);
      studentStatusMap[student.studentId] = BillStatus.paid;
    } else {
      // If no bill generated yet, or bill exists but unpaid
      unpaidStudents.add(student);
      // Status will be overwritten by debt check below if they owe money
    }
  }

  // 4. Calculate Cash Flow (Payments made THIS month)
  for (final pay in allPayments) {
    if (pay.datePaid.year == now.year && pay.datePaid.month == now.month) {
      monthlyCashFlow += pay.amount;
    }
  }

  // 5. Calculate Total Debt (Global Overdue)
  for (final bill in allBills) {
    if (!bill.isPaid) {
      totalDebt += bill.outstandingBalance;
      
      // If a student has ANY unpaid bill that is overdue, mark them overdue
      if (bill.status == BillStatus.overdue) {
        studentStatusMap[bill.studentId] = BillStatus.overdue;
      } else if (studentStatusMap[bill.studentId] != BillStatus.overdue) {
        // If not already marked overdue, mark as unpaid/partial
        studentStatusMap[bill.studentId] = bill.status;
      }
    }
  }

  return DashboardMetrics(
    sortedStudents: students,
    totalCollectedThisMonth: monthlyCashFlow,
    totalOverdueAllTime: totalDebt,
    paidStudentsCurrentMonth: paidStudents,
    unpaidStudentsCurrentMonth: unpaidStudents,
    studentFinancialStatus: studentStatusMap,
  );
}