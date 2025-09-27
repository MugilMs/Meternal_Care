import 'package:flutter/material.dart';

enum SymptomSeverity { none, mild, moderate, severe }
enum MoodType { happy, neutral, anxious, sad, excited, tired, stressed }
enum EnergyLevel { veryLow, low, moderate, high, veryHigh }

class SymptomEntry {
  final String id;
  final DateTime date;
  final Map<String, SymptomSeverity> symptoms;
  final MoodType mood;
  final EnergyLevel energyLevel;
  final int sleepHours;
  final double? sleepQuality; // 1-10 scale
  final String? notes;
  final DateTime createdAt;

  SymptomEntry({
    required this.id,
    required this.date,
    required this.symptoms,
    required this.mood,
    required this.energyLevel,
    required this.sleepHours,
    this.sleepQuality,
    this.notes,
    required this.createdAt,
  });

  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    return SymptomEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      symptoms: Map<String, SymptomSeverity>.from(
        json['symptoms'].map((key, value) => MapEntry(
          key,
          SymptomSeverity.values[value],
        )),
      ),
      mood: MoodType.values[json['mood']],
      energyLevel: EnergyLevel.values[json['energy_level']],
      sleepHours: json['sleep_hours'],
      sleepQuality: json['sleep_quality']?.toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'symptoms': symptoms.map((key, value) => MapEntry(key, value.index)),
      'mood': mood.index,
      'energy_level': energyLevel.index,
      'sleep_hours': sleepHours,
      'sleep_quality': sleepQuality,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SymptomLogger {
  static const List<String> commonSymptoms = [
    'Morning Sickness',
    'Fatigue',
    'Headache',
    'Back Pain',
    'Heartburn',
    'Constipation',
    'Swelling',
    'Breast Tenderness',
    'Frequent Urination',
    'Mood Swings',
    'Insomnia',
    'Leg Cramps',
    'Shortness of Breath',
    'Dizziness',
    'Food Cravings',
    'Food Aversions',
  ];

  final List<SymptomEntry> entries;

  SymptomLogger({required this.entries});

  List<SymptomEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return entries.where((entry) {
      return entry.date.isAfter(start.subtract(const Duration(days: 1))) &&
             entry.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> getSymptomFrequency(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries.where((entry) => entry.date.isAfter(cutoffDate)).toList();
    
    final frequency = <String, int>{};
    for (final entry in recentEntries) {
      for (final symptom in entry.symptoms.keys) {
        if (entry.symptoms[symptom] != SymptomSeverity.none) {
          frequency[symptom] = (frequency[symptom] ?? 0) + 1;
        }
      }
    }
    
    return frequency.map((symptom, count) => 
      MapEntry(symptom, count / recentEntries.length));
  }

  Map<MoodType, int> getMoodDistribution(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries.where((entry) => entry.date.isAfter(cutoffDate)).toList();
    
    final distribution = <MoodType, int>{};
    for (final entry in recentEntries) {
      distribution[entry.mood] = (distribution[entry.mood] ?? 0) + 1;
    }
    
    return distribution;
  }

  double getAverageSleepHours(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries.where((entry) => entry.date.isAfter(cutoffDate)).toList();
    
    if (recentEntries.isEmpty) return 0;
    
    final totalHours = recentEntries.fold<int>(0, (sum, entry) => sum + entry.sleepHours);
    return totalHours / recentEntries.length;
  }

  double getAverageSleepQuality(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries.where((entry) => 
      entry.date.isAfter(cutoffDate) && entry.sleepQuality != null).toList();
    
    if (recentEntries.isEmpty) return 0;
    
    final totalQuality = recentEntries.fold<double>(0, (sum, entry) => sum + entry.sleepQuality!);
    return totalQuality / recentEntries.length;
  }

  List<String> getMostCommonSymptoms(int days, {int limit = 5}) {
    final frequency = getSymptomFrequency(days);
    final sortedSymptoms = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedSymptoms.take(limit).map((e) => e.key).toList();
  }
}
