// lib/utils/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mirah_coaches/models/models.dart'; // Imports ticket, expense, trips

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mirah_coaches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. TICKETS TABLE
    await db.execute('''
      CREATE TABLE tickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        route_from TEXT,
        route_to TEXT,
        ticket_id TEXT,
        amount REAL,
        passenger_name TEXT,
        passenger_phone TEXT,
        charges TEXT
      )
    ''');

    // 2. EXPENSES TABLE
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        total_amount REAL,
        expense_number INTEGER,
        expense_id TEXT
      )
    ''');

    // 3. TRIPS TABLE (The new logic for Drivers)
    await db.execute('''
      CREATE TABLE trips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        route_from TEXT,
        route_to TEXT,
        standard_price REAL,
        trip_code TEXT
      )
    ''');
  }

  // --- CRUD OPERATIONS ---

  // TICKET ACTIONS
  Future<int> createTicket(Ticket ticket) async {
    final db = await instance.database;
    return await db.insert('tickets', ticket.toMap());
  }

  Future<List<Ticket>> getAllTickets() async {
    final db = await instance.database;
    final result = await db.query('tickets', orderBy: 'id DESC'); // Newest first
    return result.map((json) => Ticket.fromMap(json)).toList();
  }

  // EXPENSE ACTIONS
  Future<int> createExpense(Expenses expense) async {
    final db = await instance.database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expenses>> getAllExpenses() async {
    final db = await instance.database;
    final result = await db.query('expenses', orderBy: 'id DESC');
    return result.map((json) => Expenses.fromMap(json)).toList();
  }

  // TRIP ACTIONS
  Future<int> createTrip(Trip trip) async {
    final db = await instance.database;
    return await db.insert('trips', trip.toMap());
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await instance.database;
    final result = await db.query('trips');
    return result.map((json) => Trip.fromMap(json)).toList();
  }
}