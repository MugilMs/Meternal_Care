import 'dart:async';
import 'dart:math';
import '../models/notification_reminder.dart';
import '../models/user_profile.dart';

class SmartNotificationService {
  static final SmartNotificationService _instance = SmartNotificationService._internal();
  factory SmartNotificationService() => _instance;
  SmartNotificationService._internal();

  final List<NotificationReminder> _reminders = [];
  final List<SmartNotification> _notifications_history = [];
  Timer? _reminderTimer;

  Future<void> initialize() async {
    // Initialize without flutter_local_notifications for now
    _startReminderTimer();
  }

  void _startReminderTimer() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkReminders();
    });
  }

  void _checkReminders() {
    final now = DateTime.now();
    
    for (final reminder in _reminders) {
      if (reminder.shouldTriggerNow()) {
        _triggerReminder(reminder);
      }
    }
  }

  void _triggerReminder(NotificationReminder reminder) {
    // Update reminder trigger count and last triggered time
    final updatedReminder = reminder.copyWith(
      lastTriggered: DateTime.now(),
      triggerCount: reminder.triggerCount + 1,
    );
    
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = updatedReminder;
    }

    // For now, just print the notification (in production, use actual notifications)
    print('Notification: ${reminder.title} - ${reminder.message}');
  }

  Future<void> scheduleReminder(NotificationReminder reminder) async {
    _reminders.add(reminder);
    print('Reminder scheduled: ${reminder.title}');
  }

  // Smart reminder creation based on user profile and pregnancy week
  List<NotificationReminder> generateSmartReminders(UserProfile profile) {
    final reminders = <NotificationReminder>[];
    final now = DateTime.now();
    final pregnancyWeek = profile.currentWeek ?? 20;

    // Prenatal vitamin reminder
    reminders.add(NotificationReminder(
      id: 'prenatal_vitamin_${now.millisecondsSinceEpoch}',
      title: 'Take Your Prenatal Vitamin',
      message: 'Don\'t forget your daily prenatal vitamin for you and baby\'s health!',
      type: ReminderType.prenatalVitamin,
      frequency: ReminderFrequency.daily,
      scheduledTime: DateTime(now.year, now.month, now.day, 9, 0), // 9 AM daily
      priority: NotificationPriority.high,
      createdAt: now,
    ));

    // Hydration reminders
    for (int hour in [10, 14, 18]) {
      reminders.add(NotificationReminder(
        id: 'hydration_${hour}_${now.millisecondsSinceEpoch}',
        title: 'Stay Hydrated! 💧',
        message: 'Time for a glass of water. Staying hydrated is crucial during pregnancy.',
        type: ReminderType.hydration,
        frequency: ReminderFrequency.daily,
        scheduledTime: DateTime(now.year, now.month, now.day, hour, 0),
        priority: NotificationPriority.medium,
        createdAt: now,
      ));
    }

    return reminders;
  }

  // Context-aware notifications
  Future<void> sendContextualNotification({
    required String title,
    required String message,
    required NotificationPriority priority,
    Map<String, dynamic>? payload,
  }) async {
    final notification = SmartNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: message,
      priority: priority,
      timestamp: DateTime.now(),
      payload: payload,
    );

    _notifications_history.add(notification);
    print('Contextual Notification: $title - $message');
  }

  // Emergency notifications
  Future<void> sendEmergencyAlert({
    required String title,
    required String message,
    List<NotificationAction>? actions,
  }) async {
    await sendContextualNotification(
      title: '🚨 $title',
      message: message,
      priority: NotificationPriority.urgent,
      payload: {'type': 'emergency', 'actions': actions?.map((a) => a.toJson()).toList()},
    );
  }

  // Get all active reminders
  List<NotificationReminder> getActiveReminders() {
    return _reminders.where((r) => r.isActive).toList();
  }

  // Get notification history
  List<SmartNotification> getNotificationHistory({int? limit}) {
    final sorted = List<SmartNotification>.from(_notifications_history)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null) {
      return sorted.take(limit).toList();
    }
    return sorted;
  }

  // Update reminder
  Future<void> updateReminder(NotificationReminder reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      print('Reminder updated: ${reminder.title}');
    }
  }

  // Delete reminder
  Future<void> deleteReminder(String reminderId) async {
    _reminders.removeWhere((r) => r.id == reminderId);
    print('Reminder deleted: $reminderId');
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    _notifications_history.clear();
    print('All notifications cleared');
  }

  void dispose() {
    _reminderTimer?.cancel();
  }
}
