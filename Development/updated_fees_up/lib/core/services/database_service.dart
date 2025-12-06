import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart'; 
import 'package:updated_fees_up/core/models/bill.dart';
import 'package:updated_fees_up/core/models/notification_item.dart';
import 'package:updated_fees_up/core/models/payment.dart';
import 'package:updated_fees_up/core/models/school_term.dart';
import 'package:updated_fees_up/core/models/student.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  // 🔐 SECURITY: This key locks the file.
  final String _dbPassword = "StartUp_Greyway_Secure_Key_2025!"; 

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    await init();
    return _db!;
  }

  Future<void> init() async {
    final docs = await getApplicationDocumentsDirectory();
    final dbPath = join(docs.path, 'fees_up_core.db');

    // 🛑 KEY CHANGE 2: Pass the password parameter.
    _db = await openDatabase(
      dbPath,
      version: 1,
      password: _dbPassword, // <--- THIS ENCRYPTS THE FILE
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // 1. STUDENTS
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id TEXT NOT NULL UNIQUE,
        student_name TEXT NOT NULL,
        registration_date TEXT,
        is_active INTEGER DEFAULT 1,
        base_fee REAL DEFAULT 0.0,
        parent_contact TEXT,
        subjects TEXT,
        frequency TEXT DEFAULT 'Monthly',
        admin_uid TEXT NOT NULL,
        updated_at TEXT,
        grade TEXT DEFAULT 'Form 1',
        billing_mode TEXT DEFAULT 'monthly',
        billing_config TEXT
      )
    ''');

    // 2. SCHOOL TERMS
    await db.execute('''
      CREATE TABLE school_terms (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        year INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        is_active INTEGER DEFAULT 0,
        created_at TEXT,
        admin_uid TEXT NOT NULL
      )
    ''');

    // 3. NOTIFICATIONS
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        timestamp TEXT,
        is_read INTEGER DEFAULT 0,
        type TEXT DEFAULT 'info',
        updated_at TEXT,
        admin_uid TEXT
      )
    ''');

    // 4. BILLS
    await db.execute('''
      CREATE TABLE bills (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        total_amount REAL NOT NULL,
        paid_amount REAL DEFAULT 0.0,
        month_year TEXT NOT NULL,
        billing_cycle_start TEXT NOT NULL,
        cycle_interval TEXT DEFAULT 'monthly',
        created_at TEXT,
        updated_at TEXT,
        admin_uid TEXT,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE
      )
    ''');

    // 5. PAYMENTS
    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        bill_id TEXT NOT NULL,
        student_id TEXT NOT NULL,
        amount REAL NOT NULL,
        date_paid TEXT NOT NULL,
        method TEXT DEFAULT 'Cash',
        updated_at TEXT,
        admin_uid TEXT,
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE,
        FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE
      )
    ''');
    
    debugPrint("✅ Database Encrypted & Tables Created");
  }



  // ---------------------------------------------------------------------------
  // 💾 CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  // --- STUDENTS ---
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final rows = await db.query('students', orderBy: 'student_name ASC');
    return rows.map((r) => Student.fromRow(r)).toList();
  }

  Future<String?> registerNewStudent({
    required String fullName,
    required String grade,
    required double baseFee,
    required String parentContact,
    required List<String> subjects,
    required String billingMode,
    required String frequency,
    required String adminUid,
  }) async {
    try {
      final db = await database;
      final uniqueId = "STU-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      
      final newStudent = Student(
        id: 0, // Auto-increment handles this
        studentId: uniqueId,
        studentName: fullName,
        grade: grade,
        registrationDate: DateTime.now(),
        isActive: true,
        baseFee: baseFee,
        parentContact: parentContact,
        subjects: subjects,
        frequency: frequency,
        billingMode: billingMode,
        adminUid: adminUid,
        updatedAt: DateTime.now(),
      );

      await db.insert('students', newStudent.toRow()..remove('id')); // Let SQLite handle ID
      return uniqueId;
    } catch (e) {
      debugPrint("❌ Register Error: $e");
      return null;
    }
  }

  // --- BILLS ---
  Future<List<Bill>> getBillsForStudent(String studentId) async {
    final db = await database;
    final rows = await db.query(
      'bills', 
      where: 'student_id = ?', 
      whereArgs: [studentId],
      orderBy: 'billing_cycle_start DESC'
    );
    return rows.map((r) => Bill.fromRow(r)).toList();
  }

  Future<void> saveBill(Bill bill) async {
    final db = await database;
    await db.insert(
      'bills', 
      bill.toRow(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // --- PAYMENTS ---
  Future<List<Payment>> getPaymentsForStudent(String studentId) async {
    final db = await database;
    final rows = await db.query(
      'payments',
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'date_paid DESC'
    );
    return rows.map((r) => Payment.fromRow(r)).toList();
  }

  Future<void> savePayment(Payment payment) async {
    final db = await database;
    await db.transaction((txn) async {
      // 1. Insert Payment
      await txn.insert(
        'payments', 
        payment.toRow(), 
        conflictAlgorithm: ConflictAlgorithm.replace
      );

      // 2. Update Bill (Paid Amount)
      // Retrieve current bill
      final billRows = await txn.query('bills', where: 'id = ?', whereArgs: [payment.billId]);
      if (billRows.isNotEmpty) {
        final bill = Bill.fromRow(billRows.first);
        final newPaid = bill.paidAmount + payment.amount;
        
        await txn.update(
          'bills',
          {'paid_amount': newPaid, 'updated_at': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [payment.billId]
        );
      }
    });
  }

  // --- NOTIFICATIONS ---
  Future<List<NotificationItem>> getNotifications() async {
    final db = await database;
    final rows = await db.query('notifications', orderBy: 'timestamp DESC');
    return rows.map((r) => NotificationItem.fromRow(r)).toList();
  }
  
  // --- TERMS ---
  Future<List<SchoolTerm>> getActiveTerms() async {
    final db = await database;
    final rows = await db.query('school_terms', where: 'is_active = 1');
    return rows.map((r) => SchoolTerm.fromRow(r)).toList();
  }

  // 🛠 MAINTENANCE
  Future<void> wipeAllData() async {
    final db = await database;
    await db.delete('students');
    await db.delete('bills');
    await db.delete('payments');
    await db.delete('notifications');
    await db.delete('school_terms');
    debugPrint("⚠️ ALL DATA WIPED");
  }
}