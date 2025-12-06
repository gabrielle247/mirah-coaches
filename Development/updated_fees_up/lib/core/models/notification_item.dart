class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp; // 'timestamp'
  final bool isRead;
  final String type; // 'type' (default 'info')
  final DateTime updatedAt; // 'updated_at'
  final String? adminUid; // 'admin_uid' (Nullable)

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    this.type = 'info',
    required this.updatedAt,
    this.adminUid,
  });

  factory NotificationItem.fromRow(Map<String, dynamic> row) {
    return NotificationItem(
      id: row['id'] as String,
      title: row['title'] as String,
      body: row['body'] as String,
      timestamp: DateTime.tryParse(row['timestamp'] ?? '') ?? DateTime.now(),
      isRead: row['is_read'] == 1 || row['is_read'] == true,
      type: row['type'] as String? ?? 'info',
      updatedAt: DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
      adminUid: row['admin_uid'] as String?,
    );
  }

  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead ? 1 : 0,
      'type': type,
      'updated_at': DateTime.now().toIso8601String(),
      'admin_uid': adminUid,
    };
  }

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      type: type,
      updatedAt: DateTime.now(),
      adminUid: adminUid,
    );
  }
}