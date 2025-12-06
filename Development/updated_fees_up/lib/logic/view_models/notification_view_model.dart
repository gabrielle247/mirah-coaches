import 'package:flutter/foundation.dart';
import 'package:updated_fees_up/core/models/notification_item.dart';
import 'package:updated_fees_up/core/services/database_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasNotifications => _notifications.isNotEmpty;

  // --- ACTIONS ---

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Run AI Analysis (Generate new insights based on latest data)
      await _generateSmartInsights();

      // 2. Fetch results
      _notifications = await _db.getNotifications();
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _notifications = await _db.getNotifications();
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    // Optimistic Update
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
    // DB Update
    final db = await _db.database;
    await db.update(
      'notifications', 
      {'is_read': 1}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
    
    final db = await _db.database;
    await db.update('notifications', {'is_read': 1}, where: 'is_read = 0');
  }

  // --- SMART INSIGHTS ENGINE ---
  Future<void> _generateSmartInsights() async {
    // Basic implementation of the "AI" logic
    final students = await _db.getAllStudents();
    
    // 1. Growth Milestone
    if (students.length >= 10 && students.length % 10 == 0) {
      await _createSystemNotification(
        id: "milestone_student_${students.length}",
        title: "Growth Milestone! 🚀",
        body: "You have reached ${students.length} students.",
        type: "success",
      );
    }

    // 2. New Month Check
    // 🛑 FIX: Removed unused 'currentMonthKey' variable to silence linter warning
    // If you need it later for revenue checks, uncomment and use it immediately.
    // final now = DateTime.now();
    // final currentMonthKey = DateFormat('yyyy-MM').format(now);
  }

  Future<void> _createSystemNotification({
    required String id,
    required String title,
    required String body,
    required String type,
  }) async {
    final db = await _db.database;
    // Check if exists
    final exists = await db.query('notifications', where: 'id = ?', whereArgs: [id]);
    if (exists.isEmpty) {
      await db.insert('notifications', {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
        'is_read': 0,
        'type': type,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }
}