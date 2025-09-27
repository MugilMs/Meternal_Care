class WellnessActivity {
  final String id;
  final String name;
  final String description;
  final WellnessType type;
  final Duration duration;
  final DifficultyLevel difficulty;
  final List<String> benefits;
  final List<String> instructions;
  final String? videoUrl;
  final String? audioUrl;
  final List<String> imageUrls;
  final List<String> pregnancyStages;
  final bool isPregnancySafe;
  final List<String> contraindications;
  final DateTime createdAt;

  WellnessActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.duration,
    required this.difficulty,
    required this.benefits,
    required this.instructions,
    this.videoUrl,
    this.audioUrl,
    required this.imageUrls,
    required this.pregnancyStages,
    this.isPregnancySafe = true,
    required this.contraindications,
    required this.createdAt,
  });

  String get durationText {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  factory WellnessActivity.fromJson(Map<String, dynamic> json) {
    return WellnessActivity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: WellnessType.values[json['type']],
      duration: Duration(minutes: json['duration_minutes']),
      difficulty: DifficultyLevel.values[json['difficulty']],
      benefits: List<String>.from(json['benefits']),
      instructions: List<String>.from(json['instructions']),
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
      imageUrls: List<String>.from(json['image_urls']),
      pregnancyStages: List<String>.from(json['pregnancy_stages']),
      isPregnancySafe: json['is_pregnancy_safe'] ?? true,
      contraindications: List<String>.from(json['contraindications']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'duration_minutes': duration.inMinutes,
      'difficulty': difficulty.index,
      'benefits': benefits,
      'instructions': instructions,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'image_urls': imageUrls,
      'pregnancy_stages': pregnancyStages,
      'is_pregnancy_safe': isPregnancySafe,
      'contraindications': contraindications,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum WellnessType {
  meditation,
  prenatalYoga,
  breathingExercise,
  relaxation,
  sleepStory,
  mindfulness,
  stretchingExercise,
  prenatalFitness,
  mentalHealth,
  stressRelief
}

enum DifficultyLevel { beginner, intermediate, advanced }

class MeditationSession {
  final String id;
  final String userId;
  final String activityId;
  final WellnessActivity activity;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? actualDuration;
  final MoodBefore? moodBefore;
  final MoodAfter? moodAfter;
  final int? stressLevelBefore;
  final int? stressLevelAfter;
  final String? notes;
  final bool isCompleted;

  MeditationSession({
    required this.id,
    required this.userId,
    required this.activityId,
    required this.activity,
    required this.startTime,
    this.endTime,
    this.actualDuration,
    this.moodBefore,
    this.moodAfter,
    this.stressLevelBefore,
    this.stressLevelAfter,
    this.notes,
    this.isCompleted = false,
  });

  Duration get sessionDuration => actualDuration ?? (endTime?.difference(startTime) ?? Duration.zero);
  bool get hasImprovement => 
    (stressLevelBefore != null && stressLevelAfter != null) 
      ? stressLevelAfter! < stressLevelBefore! 
      : false;

  factory MeditationSession.fromJson(Map<String, dynamic> json) {
    return MeditationSession(
      id: json['id'],
      userId: json['user_id'],
      activityId: json['activity_id'],
      activity: WellnessActivity.fromJson(json['activity']),
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      actualDuration: json['actual_duration_minutes'] != null 
        ? Duration(minutes: json['actual_duration_minutes']) 
        : null,
      moodBefore: json['mood_before'] != null ? MoodBefore.values[json['mood_before']] : null,
      moodAfter: json['mood_after'] != null ? MoodAfter.values[json['mood_after']] : null,
      stressLevelBefore: json['stress_level_before'],
      stressLevelAfter: json['stress_level_after'],
      notes: json['notes'],
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'activity_id': activityId,
      'activity': activity.toJson(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'actual_duration_minutes': actualDuration?.inMinutes,
      'mood_before': moodBefore?.index,
      'mood_after': moodAfter?.index,
      'stress_level_before': stressLevelBefore,
      'stress_level_after': stressLevelAfter,
      'notes': notes,
      'is_completed': isCompleted,
    };
  }
}

enum MoodBefore { anxious, stressed, tired, neutral, calm }
enum MoodAfter { relaxed, peaceful, energized, happy, sleepy }

class WellnessProgram {
  final String id;
  final String name;
  final String description;
  final List<WellnessActivity> activities;
  final Duration totalDuration;
  final int totalSessions;
  final List<String> goals;
  final List<String> pregnancyStages;
  final String imageUrl;
  final bool isPremium;

  WellnessProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.activities,
    required this.totalDuration,
    required this.totalSessions,
    required this.goals,
    required this.pregnancyStages,
    required this.imageUrl,
    this.isPremium = false,
  });

  String get totalDurationText {
    final days = totalDuration.inDays;
    if (days > 0) {
      return '$days days';
    } else {
      final hours = totalDuration.inHours;
      return '${hours}h';
    }
  }

  factory WellnessProgram.fromJson(Map<String, dynamic> json) {
    return WellnessProgram(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      activities: (json['activities'] as List)
          .map((activity) => WellnessActivity.fromJson(activity))
          .toList(),
      totalDuration: Duration(minutes: json['total_duration_minutes']),
      totalSessions: json['total_sessions'],
      goals: List<String>.from(json['goals']),
      pregnancyStages: List<String>.from(json['pregnancy_stages']),
      imageUrl: json['image_url'],
      isPremium: json['is_premium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'total_duration_minutes': totalDuration.inMinutes,
      'total_sessions': totalSessions,
      'goals': goals,
      'pregnancy_stages': pregnancyStages,
      'image_url': imageUrl,
      'is_premium': isPremium,
    };
  }
}

class WellnessGoal {
  final String id;
  final String userId;
  final GoalType type;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final String unit;
  final DateTime startDate;
  final DateTime targetDate;
  final bool isCompleted;
  final List<GoalMilestone> milestones;

  WellnessGoal({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.targetValue,
    this.currentValue = 0,
    required this.unit,
    required this.startDate,
    required this.targetDate,
    this.isCompleted = false,
    required this.milestones,
  });

  double get progressPercentage => targetValue > 0 ? (currentValue / targetValue * 100).clamp(0, 100) : 0;
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;
  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;

  factory WellnessGoal.fromJson(Map<String, dynamic> json) {
    return WellnessGoal(
      id: json['id'],
      userId: json['user_id'],
      type: GoalType.values[json['type']],
      title: json['title'],
      description: json['description'],
      targetValue: json['target_value'],
      currentValue: json['current_value'] ?? 0,
      unit: json['unit'],
      startDate: DateTime.parse(json['start_date']),
      targetDate: DateTime.parse(json['target_date']),
      isCompleted: json['is_completed'] ?? false,
      milestones: (json['milestones'] as List)
          .map((milestone) => GoalMilestone.fromJson(milestone))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'title': title,
      'description': description,
      'target_value': targetValue,
      'current_value': currentValue,
      'unit': unit,
      'start_date': startDate.toIso8601String(),
      'target_date': targetDate.toIso8601String(),
      'is_completed': isCompleted,
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
    };
  }
}

enum GoalType {
  dailyMeditation,
  weeklyYoga,
  stressReduction,
  sleepImprovement,
  mindfulness,
  exerciseMinutes,
  relaxationSessions
}

class GoalMilestone {
  final String id;
  final String goalId;
  final String title;
  final int targetValue;
  final DateTime targetDate;
  final bool isCompleted;
  final DateTime? completedAt;

  GoalMilestone({
    required this.id,
    required this.goalId,
    required this.title,
    required this.targetValue,
    required this.targetDate,
    this.isCompleted = false,
    this.completedAt,
  });

  factory GoalMilestone.fromJson(Map<String, dynamic> json) {
    return GoalMilestone(
      id: json['id'],
      goalId: json['goal_id'],
      title: json['title'],
      targetValue: json['target_value'],
      targetDate: DateTime.parse(json['target_date']),
      isCompleted: json['is_completed'] ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'title': title,
      'target_value': targetValue,
      'target_date': targetDate.toIso8601String(),
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class WellnessInsight {
  final String id;
  final String userId;
  final InsightType type;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final DateTime generatedAt;
  final bool isRead;

  WellnessInsight({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.generatedAt,
    this.isRead = false,
  });

  factory WellnessInsight.fromJson(Map<String, dynamic> json) {
    return WellnessInsight(
      id: json['id'],
      userId: json['user_id'],
      type: InsightType.values[json['type']],
      title: json['title'],
      message: json['message'],
      data: json['data'],
      generatedAt: DateTime.parse(json['generated_at']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'title': title,
      'message': message,
      'data': data,
      'generated_at': generatedAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}

enum InsightType {
  stressPattern,
  sleepQuality,
  meditationStreak,
  moodImprovement,
  goalProgress,
  recommendation
}
