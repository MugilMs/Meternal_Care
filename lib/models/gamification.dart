class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final int points;
  final String iconUrl;
  final AchievementRarity rarity;
  final List<AchievementCriteria> criteria;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.points,
    required this.iconUrl,
    required this.rarity,
    required this.criteria,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  bool get isCompleted => progress >= 100.0;
  String get progressText => '${progress.toStringAsFixed(0)}%';

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: AchievementCategory.values[json['category']],
      points: json['points'],
      iconUrl: json['icon_url'],
      rarity: AchievementRarity.values[json['rarity']],
      criteria: (json['criteria'] as List)
          .map((criterion) => AchievementCriteria.fromJson(criterion))
          .toList(),
      isUnlocked: json['is_unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null ? DateTime.parse(json['unlocked_at']) : null,
      progress: json['progress']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.index,
      'points': points,
      'icon_url': iconUrl,
      'rarity': rarity.index,
      'criteria': criteria.map((criterion) => criterion.toJson()).toList(),
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }
}

enum AchievementCategory {
  healthTracking,
  appointments,
  community,
  education,
  wellness,
  milestones,
  consistency,
  social
}

enum AchievementRarity { common, uncommon, rare, epic, legendary }

class AchievementCriteria {
  final String type;
  final int targetValue;
  final String unit;
  final String description;

  AchievementCriteria({
    required this.type,
    required this.targetValue,
    required this.unit,
    required this.description,
  });

  factory AchievementCriteria.fromJson(Map<String, dynamic> json) {
    return AchievementCriteria(
      type: json['type'],
      targetValue: json['target_value'],
      unit: json['unit'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'target_value': targetValue,
      'unit': unit,
      'description': description,
    };
  }
}

class UserLevel {
  final int level;
  final int currentXP;
  final int xpToNextLevel;
  final int totalXP;
  final String title;
  final List<String> perks;

  UserLevel({
    required this.level,
    required this.currentXP,
    required this.xpToNextLevel,
    required this.totalXP,
    required this.title,
    required this.perks,
  });

  double get progressToNextLevel => xpToNextLevel > 0 ? (currentXP / xpToNextLevel * 100).clamp(0, 100) : 100.0;
  bool get canLevelUp => currentXP >= xpToNextLevel;

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      level: json['level'],
      currentXP: json['current_xp'],
      xpToNextLevel: json['xp_to_next_level'],
      totalXP: json['total_xp'],
      title: json['title'],
      perks: List<String>.from(json['perks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'current_xp': currentXP,
      'xp_to_next_level': xpToNextLevel,
      'total_xp': totalXP,
      'title': title,
      'perks': perks,
    };
  }
}

class Challenge {
  final String id;
  final String name;
  final String description;
  final ChallengeType type;
  final ChallengeDifficulty difficulty;
  final int duration; // in days
  final int targetValue;
  final String unit;
  final int rewardPoints;
  final List<String> rewardItems;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isCompleted;
  final int currentProgress;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.duration,
    required this.targetValue,
    required this.unit,
    required this.rewardPoints,
    required this.rewardItems,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.isCompleted = false,
    this.currentProgress = 0,
  });

  double get progressPercentage => targetValue > 0 ? (currentProgress / targetValue * 100).clamp(0, 100) : 0;
  int get daysRemaining => endDate.difference(DateTime.now()).inDays;
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get canComplete => currentProgress >= targetValue;

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ChallengeType.values[json['type']],
      difficulty: ChallengeDifficulty.values[json['difficulty']],
      duration: json['duration'],
      targetValue: json['target_value'],
      unit: json['unit'],
      rewardPoints: json['reward_points'],
      rewardItems: List<String>.from(json['reward_items']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'] ?? true,
      isCompleted: json['is_completed'] ?? false,
      currentProgress: json['current_progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'difficulty': difficulty.index,
      'duration': duration,
      'target_value': targetValue,
      'unit': unit,
      'reward_points': rewardPoints,
      'reward_items': rewardItems,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'is_completed': isCompleted,
      'current_progress': currentProgress,
    };
  }
}

enum ChallengeType {
  dailyHabits,
  weeklyGoals,
  healthTracking,
  socialEngagement,
  learningGoals,
  wellnessActivities
}

enum ChallengeDifficulty { easy, medium, hard, expert }

class Streak {
  final String id;
  final String userId;
  final StreakType type;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final DateTime streakStartDate;
  final bool isActive;

  Streak({
    required this.id,
    required this.userId,
    required this.type,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.streakStartDate,
    this.isActive = true,
  });

  bool get isBroken => !isActive || DateTime.now().difference(lastActivityDate).inDays > 1;
  int get daysSinceLastActivity => DateTime.now().difference(lastActivityDate).inDays;

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      id: json['id'],
      userId: json['user_id'],
      type: StreakType.values[json['type']],
      currentStreak: json['current_streak'],
      longestStreak: json['longest_streak'],
      lastActivityDate: DateTime.parse(json['last_activity_date']),
      streakStartDate: DateTime.parse(json['streak_start_date']),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_activity_date': lastActivityDate.toIso8601String(),
      'streak_start_date': streakStartDate.toIso8601String(),
      'is_active': isActive,
    };
  }
}

enum StreakType {
  dailyCheckIn,
  healthTracking,
  meditation,
  exercise,
  prenatalVitamins,
  appointments,
  communityEngagement
}

class Leaderboard {
  final String id;
  final String name;
  final LeaderboardType type;
  final LeaderboardPeriod period;
  final List<LeaderboardEntry> entries;
  final DateTime lastUpdated;

  Leaderboard({
    required this.id,
    required this.name,
    required this.type,
    required this.period,
    required this.entries,
    required this.lastUpdated,
  });

  LeaderboardEntry? getUserEntry(String userId) {
    try {
      return entries.firstWhere((entry) => entry.userId == userId);
    } catch (e) {
      return null;
    }
  }

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      id: json['id'],
      name: json['name'],
      type: LeaderboardType.values[json['type']],
      period: LeaderboardPeriod.values[json['period']],
      entries: (json['entries'] as List)
          .map((entry) => LeaderboardEntry.fromJson(entry))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'period': period.index,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

enum LeaderboardType { points, streaks, challenges, community, wellness }
enum LeaderboardPeriod { daily, weekly, monthly, allTime }

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int rank;
  final int score;
  final Map<String, dynamic> metadata;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.rank,
    required this.score,
    required this.metadata,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'],
      userName: json['user_name'],
      avatarUrl: json['avatar_url'],
      rank: json['rank'],
      score: json['score'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'rank': rank,
      'score': score,
      'metadata': metadata,
    };
  }
}

class Reward {
  final String id;
  final String name;
  final String description;
  final RewardType type;
  final int pointsCost;
  final String? imageUrl;
  final bool isAvailable;
  final bool isRedeemed;
  final DateTime? redeemedAt;
  final Map<String, dynamic>? rewardData;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.pointsCost,
    this.imageUrl,
    this.isAvailable = true,
    this.isRedeemed = false,
    this.redeemedAt,
    this.rewardData,
  });

  bool get canRedeem => isAvailable && !isRedeemed;

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: RewardType.values[json['type']],
      pointsCost: json['points_cost'],
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
      isRedeemed: json['is_redeemed'] ?? false,
      redeemedAt: json['redeemed_at'] != null ? DateTime.parse(json['redeemed_at']) : null,
      rewardData: json['reward_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'points_cost': pointsCost,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'is_redeemed': isRedeemed,
      'redeemed_at': redeemedAt?.toIso8601String(),
      'reward_data': rewardData,
    };
  }
}

enum RewardType {
  discount,
  freeContent,
  badge,
  customization,
  consultation,
  physicalItem
}

class GamificationProfile {
  final String userId;
  final UserLevel level;
  final int totalPoints;
  final int availablePoints;
  final List<Achievement> achievements;
  final List<Streak> streaks;
  final List<Challenge> activeChallenges;
  final List<Reward> redeemedRewards;
  final DateTime lastActivity;
  final Map<String, dynamic> statistics;

  GamificationProfile({
    required this.userId,
    required this.level,
    required this.totalPoints,
    required this.availablePoints,
    required this.achievements,
    required this.streaks,
    required this.activeChallenges,
    required this.redeemedRewards,
    required this.lastActivity,
    required this.statistics,
  });

  int get unlockedAchievements => achievements.where((a) => a.isUnlocked).length;
  int get totalAchievements => achievements.length;
  int get activeStreaks => streaks.where((s) => s.isActive && !s.isBroken).length;
  int get completedChallenges => activeChallenges.where((c) => c.isCompleted).length;

  factory GamificationProfile.fromJson(Map<String, dynamic> json) {
    return GamificationProfile(
      userId: json['user_id'],
      level: UserLevel.fromJson(json['level']),
      totalPoints: json['total_points'],
      availablePoints: json['available_points'],
      achievements: (json['achievements'] as List)
          .map((achievement) => Achievement.fromJson(achievement))
          .toList(),
      streaks: (json['streaks'] as List)
          .map((streak) => Streak.fromJson(streak))
          .toList(),
      activeChallenges: (json['active_challenges'] as List)
          .map((challenge) => Challenge.fromJson(challenge))
          .toList(),
      redeemedRewards: (json['redeemed_rewards'] as List)
          .map((reward) => Reward.fromJson(reward))
          .toList(),
      lastActivity: DateTime.parse(json['last_activity']),
      statistics: json['statistics'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'level': level.toJson(),
      'total_points': totalPoints,
      'available_points': availablePoints,
      'achievements': achievements.map((achievement) => achievement.toJson()).toList(),
      'streaks': streaks.map((streak) => streak.toJson()).toList(),
      'active_challenges': activeChallenges.map((challenge) => challenge.toJson()).toList(),
      'redeemed_rewards': redeemedRewards.map((reward) => reward.toJson()).toList(),
      'last_activity': lastActivity.toIso8601String(),
      'statistics': statistics,
    };
  }
}
