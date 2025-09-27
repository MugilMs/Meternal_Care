import 'package:flutter/material.dart';

class WeightEntry {
  final String id;
  final DateTime date;
  final double weight;
  final int pregnancyWeek;
  final String? notes;
  final DateTime createdAt;

  WeightEntry({
    required this.id,
    required this.date,
    required this.weight,
    required this.pregnancyWeek,
    this.notes,
    required this.createdAt,
  });

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      weight: json['weight'].toDouble(),
      pregnancyWeek: json['pregnancy_week'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'pregnancy_week': pregnancyWeek,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class WeightTracker {
  final List<WeightEntry> entries;
  final double prePregnancyWeight;
  final double targetWeightGain;
  final double currentWeight;
  final int currentWeek;

  WeightTracker({
    required this.entries,
    required this.prePregnancyWeight,
    required this.targetWeightGain,
    required this.currentWeight,
    required this.currentWeek,
  });

  double get totalWeightGain => currentWeight - prePregnancyWeight;
  
  double get weeklyAverageGain {
    if (currentWeek == 0) return 0;
    return totalWeightGain / currentWeek;
  }

  double get remainingWeightGain => targetWeightGain - totalWeightGain;

  bool get isOnTrack {
    final expectedGain = _getExpectedWeightGain(currentWeek);
    return (totalWeightGain - expectedGain).abs() <= 2.0; // Within 2 lbs
  }

  double _getExpectedWeightGain(int week) {
    if (week <= 12) return week * 0.1; // ~0.1 lb per week first trimester
    if (week <= 28) return 1.2 + (week - 12) * 0.4; // ~0.4 lb per week second trimester
    return 7.6 + (week - 28) * 0.5; // ~0.5 lb per week third trimester
  }

  List<WeightEntry> getEntriesForWeek(int week) {
    return entries.where((entry) => entry.pregnancyWeek == week).toList();
  }

  List<WeightEntry> getRecentEntries(int count) {
    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedEntries.take(count).toList();
  }
}
