import 'package:flutter/material.dart';

class KickSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int kickCount;
  final Duration? timeToTenKicks;
  final List<DateTime> kickTimes;
  final String? notes;

  KickSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.kickCount,
    this.timeToTenKicks,
    required this.kickTimes,
    this.notes,
  });

  Duration get sessionDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  double get kicksPerHour {
    final duration = sessionDuration;
    if (duration.inMinutes == 0) return 0;
    return (kickCount / duration.inMinutes) * 60;
  }

  bool get isComplete => endTime != null;

  factory KickSession.fromJson(Map<String, dynamic> json) {
    return KickSession(
      id: json['id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      kickCount: json['kick_count'],
      timeToTenKicks: json['time_to_ten_kicks'] != null 
        ? Duration(milliseconds: json['time_to_ten_kicks']) 
        : null,
      kickTimes: (json['kick_times'] as List)
        .map((time) => DateTime.parse(time))
        .toList(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'kick_count': kickCount,
      'time_to_ten_kicks': timeToTenKicks?.inMilliseconds,
      'kick_times': kickTimes.map((time) => time.toIso8601String()).toList(),
      'notes': notes,
    };
  }
}

class BabyKickCounter {
  final List<KickSession> sessions;

  BabyKickCounter({required this.sessions});

  List<KickSession> getSessionsForDate(DateTime date) {
    return sessions.where((session) {
      return session.startTime.year == date.year &&
             session.startTime.month == date.month &&
             session.startTime.day == date.day;
    }).toList();
  }

  List<KickSession> getRecentSessions(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return sessions.where((session) => session.startTime.isAfter(cutoffDate)).toList();
  }

  double getAverageKicksPerHour(int days) {
    final recentSessions = getRecentSessions(days);
    if (recentSessions.isEmpty) return 0;

    final totalKicksPerHour = recentSessions.fold<double>(
      0, (sum, session) => sum + session.kicksPerHour);
    return totalKicksPerHour / recentSessions.length;
  }

  Duration? getAverageTimeToTenKicks(int days) {
    final recentSessions = getRecentSessions(days)
      .where((session) => session.timeToTenKicks != null)
      .toList();
    
    if (recentSessions.isEmpty) return null;

    final totalMilliseconds = recentSessions.fold<int>(
      0, (sum, session) => sum + session.timeToTenKicks!.inMilliseconds);
    
    return Duration(milliseconds: totalMilliseconds ~/ recentSessions.length);
  }

  Map<DateTime, int> getDailyKickCounts(int days) {
    final result = <DateTime, int>{};
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    
    for (final session in sessions) {
      if (session.startTime.isAfter(cutoffDate)) {
        final date = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        result[date] = (result[date] ?? 0) + session.kickCount;
      }
    }
    
    return result;
  }

  bool hasDecreasedActivity(int days) {
    final recentSessions = getRecentSessions(days);
    if (recentSessions.length < 3) return false;

    // Sort by date
    recentSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // Check if there's a significant decrease in recent activity
    final recent = recentSessions.takeLast(2).map((s) => s.kicksPerHour).toList();
    final previous = recentSessions.take(recentSessions.length - 2)
      .map((s) => s.kicksPerHour).toList();
    
    if (previous.isEmpty) return false;
    
    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final previousAvg = previous.reduce((a, b) => a + b) / previous.length;
    
    // Alert if recent activity is 50% less than previous average
    return recentAvg < (previousAvg * 0.5);
  }

  List<String> getInsights() {
    final insights = <String>[];
    final recentAvg = getAverageKicksPerHour(7);
    
    if (recentAvg > 15) {
      insights.add("Your baby is very active! This is a great sign of healthy development.");
    } else if (recentAvg > 10) {
      insights.add("Your baby's activity level is normal and healthy.");
    } else if (recentAvg > 5) {
      insights.add("Your baby's activity is on the lower side but still within normal range.");
    } else if (recentAvg > 0) {
      insights.add("Consider tracking kicks more regularly. Contact your doctor if you're concerned.");
    }
    
    if (hasDecreasedActivity(7)) {
      insights.add("⚠️ Decreased fetal movement detected. Please contact your healthcare provider.");
    }
    
    final avgTimeToTen = getAverageTimeToTenKicks(7);
    if (avgTimeToTen != null) {
      if (avgTimeToTen.inMinutes < 30) {
        insights.add("Great! Your baby reaches 10 kicks quickly, indicating good activity.");
      } else if (avgTimeToTen.inMinutes > 120) {
        insights.add("It takes longer to reach 10 kicks. Monitor closely and discuss with your doctor.");
      }
    }
    
    return insights;
  }
}

extension ListExtension<T> on List<T> {
  List<T> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }
}
