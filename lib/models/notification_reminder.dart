enum ReminderType {
  medication,
  appointment,
  hydration,
  exercise,
  weightTracking,
  kickCounting,
  prenatalVitamin,
  bloodPressure,
  glucose,
  custom
}

enum ReminderFrequency {
  once,
  daily,
  weekly,
  monthly,
  custom
}

enum NotificationPriority { low, medium, high, urgent }

class NotificationReminder {
  final String id;
  final String title;
  final String message;
  final ReminderType type;
  final ReminderFrequency frequency;
  final DateTime scheduledTime;
  final DateTime? endDate;
  final NotificationPriority priority;
  final bool isActive;
  final Map<String, dynamic>? customData;
  final List<int>? customDays; // For weekly reminders (1=Monday, 7=Sunday)
  final Duration? customInterval; // For custom frequency
  final DateTime createdAt;
  final DateTime? lastTriggered;
  final int triggerCount;

  NotificationReminder({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.frequency,
    required this.scheduledTime,
    this.endDate,
    required this.priority,
    this.isActive = true,
    this.customData,
    this.customDays,
    this.customInterval,
    required this.createdAt,
    this.lastTriggered,
    this.triggerCount = 0,
  });

  factory NotificationReminder.fromJson(Map<String, dynamic> json) {
    return NotificationReminder(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: ReminderType.values[json['type']],
      frequency: ReminderFrequency.values[json['frequency']],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      priority: NotificationPriority.values[json['priority']],
      isActive: json['is_active'] ?? true,
      customData: json['custom_data'],
      customDays: json['custom_days'] != null ? List<int>.from(json['custom_days']) : null,
      customInterval: json['custom_interval'] != null 
          ? Duration(milliseconds: json['custom_interval']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      lastTriggered: json['last_triggered'] != null 
          ? DateTime.parse(json['last_triggered']) 
          : null,
      triggerCount: json['trigger_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.index,
      'frequency': frequency.index,
      'scheduled_time': scheduledTime.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'priority': priority.index,
      'is_active': isActive,
      'custom_data': customData,
      'custom_days': customDays,
      'custom_interval': customInterval?.inMilliseconds,
      'created_at': createdAt.toIso8601String(),
      'last_triggered': lastTriggered?.toIso8601String(),
      'trigger_count': triggerCount,
    };
  }

  DateTime? getNextScheduledTime() {
    if (!isActive) return null;
    
    final now = DateTime.now();
    DateTime next = scheduledTime;

    switch (frequency) {
      case ReminderFrequency.once:
        return next.isAfter(now) ? next : null;
      
      case ReminderFrequency.daily:
        while (next.isBefore(now)) {
          next = next.add(const Duration(days: 1));
        }
        break;
      
      case ReminderFrequency.weekly:
        if (customDays != null && customDays!.isNotEmpty) {
          // Find next occurrence based on custom days
          final currentWeekday = now.weekday;
          final todayMinutes = now.hour * 60 + now.minute;
          final scheduledMinutes = scheduledTime.hour * 60 + scheduledTime.minute;
          
          for (int i = 0; i < 7; i++) {
            final checkDay = ((currentWeekday - 1 + i) % 7) + 1;
            if (customDays!.contains(checkDay)) {
              final daysToAdd = i;
              if (daysToAdd == 0 && todayMinutes >= scheduledMinutes) {
                continue; // Today but time has passed
              }
              next = DateTime(now.year, now.month, now.day + daysToAdd, 
                             scheduledTime.hour, scheduledTime.minute);
              break;
            }
          }
        } else {
          while (next.isBefore(now)) {
            next = next.add(const Duration(days: 7));
          }
        }
        break;
      
      case ReminderFrequency.monthly:
        while (next.isBefore(now)) {
          next = DateTime(next.year, next.month + 1, next.day, next.hour, next.minute);
        }
        break;
      
      case ReminderFrequency.custom:
        if (customInterval != null) {
          while (next.isBefore(now)) {
            next = next.add(customInterval!);
          }
        }
        break;
    }

    if (endDate != null && next.isAfter(endDate!)) {
      return null;
    }

    return next;
  }

  bool shouldTriggerNow() {
    final next = getNextScheduledTime();
    if (next == null) return false;
    
    final now = DateTime.now();
    final difference = next.difference(now).abs();
    
    // Trigger if within 1 minute of scheduled time
    return difference.inMinutes <= 1;
  }

  NotificationReminder copyWith({
    String? id,
    String? title,
    String? message,
    ReminderType? type,
    ReminderFrequency? frequency,
    DateTime? scheduledTime,
    DateTime? endDate,
    NotificationPriority? priority,
    bool? isActive,
    Map<String, dynamic>? customData,
    List<int>? customDays,
    Duration? customInterval,
    DateTime? createdAt,
    DateTime? lastTriggered,
    int? triggerCount,
  }) {
    return NotificationReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      customData: customData ?? this.customData,
      customDays: customDays ?? this.customDays,
      customInterval: customInterval ?? this.customInterval,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
      triggerCount: triggerCount ?? this.triggerCount,
    );
  }
}

class SmartNotification {
  final String id;
  final String title;
  final String body;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? payload;
  final String? imageUrl;
  final List<NotificationAction>? actions;

  SmartNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.payload,
    this.imageUrl,
    this.actions,
  });

  factory SmartNotification.fromJson(Map<String, dynamic> json) {
    return SmartNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      priority: NotificationPriority.values[json['priority']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      payload: json['payload'],
      imageUrl: json['image_url'],
      actions: json['actions'] != null
          ? (json['actions'] as List)
              .map((action) => NotificationAction.fromJson(action))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'priority': priority.index,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'payload': payload,
      'image_url': imageUrl,
      'actions': actions?.map((action) => action.toJson()).toList(),
    };
  }
}

class NotificationAction {
  final String id;
  final String title;
  final String action;
  final Map<String, dynamic>? data;

  NotificationAction({
    required this.id,
    required this.title,
    required this.action,
    this.data,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      id: json['id'],
      title: json['title'],
      action: json['action'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'action': action,
      'data': data,
    };
  }
}
