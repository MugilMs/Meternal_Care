class BabyDevelopment {
  final int week;
  final String title;
  final String description;
  final BabySize size;
  final List<String> developments;
  final List<String> maternalChanges;
  final List<String> tips;
  final String imageUrl;
  final Map<String, dynamic> measurements;

  BabyDevelopment({
    required this.week,
    required this.title,
    required this.description,
    required this.size,
    required this.developments,
    required this.maternalChanges,
    required this.tips,
    required this.imageUrl,
    required this.measurements,
  });

  String get trimester {
    if (week <= 12) return 'First Trimester';
    if (week <= 27) return 'Second Trimester';
    return 'Third Trimester';
  }

  factory BabyDevelopment.fromJson(Map<String, dynamic> json) {
    return BabyDevelopment(
      week: json['week'],
      title: json['title'],
      description: json['description'],
      size: BabySize.fromJson(json['size']),
      developments: List<String>.from(json['developments']),
      maternalChanges: List<String>.from(json['maternal_changes']),
      tips: List<String>.from(json['tips']),
      imageUrl: json['image_url'],
      measurements: json['measurements'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'title': title,
      'description': description,
      'size': size.toJson(),
      'developments': developments,
      'maternal_changes': maternalChanges,
      'tips': tips,
      'image_url': imageUrl,
      'measurements': measurements,
    };
  }
}

class BabySize {
  final String comparison;
  final double lengthCm;
  final double lengthInches;
  final double weightGrams;
  final double weightOunces;

  BabySize({
    required this.comparison,
    required this.lengthCm,
    required this.lengthInches,
    required this.weightGrams,
    required this.weightOunces,
  });

  String get lengthDisplay => '${lengthCm.toStringAsFixed(1)} cm (${lengthInches.toStringAsFixed(1)}")';
  String get weightDisplay => '${weightGrams.toStringAsFixed(0)}g (${weightOunces.toStringAsFixed(1)} oz)';

  factory BabySize.fromJson(Map<String, dynamic> json) {
    return BabySize(
      comparison: json['comparison'],
      lengthCm: json['length_cm'].toDouble(),
      lengthInches: json['length_inches'].toDouble(),
      weightGrams: json['weight_grams'].toDouble(),
      weightOunces: json['weight_ounces'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comparison': comparison,
      'length_cm': lengthCm,
      'length_inches': lengthInches,
      'weight_grams': weightGrams,
      'weight_ounces': weightOunces,
    };
  }
}

class PregnancyMilestone {
  final String id;
  final int week;
  final String title;
  final String description;
  final MilestoneType type;
  final bool isImportant;
  final DateTime? scheduledDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;

  PregnancyMilestone({
    required this.id,
    required this.week,
    required this.title,
    required this.description,
    required this.type,
    this.isImportant = false,
    this.scheduledDate,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
  });

  bool get isUpcoming => scheduledDate != null && scheduledDate!.isAfter(DateTime.now()) && !isCompleted;
  bool get isOverdue => scheduledDate != null && scheduledDate!.isBefore(DateTime.now()) && !isCompleted;

  factory PregnancyMilestone.fromJson(Map<String, dynamic> json) {
    return PregnancyMilestone(
      id: json['id'],
      week: json['week'],
      title: json['title'],
      description: json['description'],
      type: MilestoneType.values[json['type']],
      isImportant: json['is_important'] ?? false,
      scheduledDate: json['scheduled_date'] != null ? DateTime.parse(json['scheduled_date']) : null,
      isCompleted: json['is_completed'] ?? false,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'week': week,
      'title': title,
      'description': description,
      'type': type.index,
      'is_important': isImportant,
      'scheduled_date': scheduledDate?.toIso8601String(),
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }
}

enum MilestoneType {
  appointment,
  test,
  development,
  preparation,
  education,
  health
}

class BabyPhotoJournal {
  final String id;
  final String userId;
  final int pregnancyWeek;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final DateTime capturedAt;
  final Map<String, dynamic>? metadata;

  BabyPhotoJournal({
    required this.id,
    required this.userId,
    required this.pregnancyWeek,
    required this.title,
    this.description,
    required this.imageUrls,
    required this.capturedAt,
    this.metadata,
  });

  bool get hasMultiplePhotos => imageUrls.length > 1;

  factory BabyPhotoJournal.fromJson(Map<String, dynamic> json) {
    return BabyPhotoJournal(
      id: json['id'],
      userId: json['user_id'],
      pregnancyWeek: json['pregnancy_week'],
      title: json['title'],
      description: json['description'],
      imageUrls: List<String>.from(json['image_urls']),
      capturedAt: DateTime.parse(json['captured_at']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pregnancy_week': pregnancyWeek,
      'title': title,
      'description': description,
      'image_urls': imageUrls,
      'captured_at': capturedAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class BabyNameSuggestion {
  final String name;
  final Gender gender;
  final String origin;
  final String meaning;
  final int popularity;
  final List<String> variations;
  final List<String> nicknames;
  final bool isFavorite;

  BabyNameSuggestion({
    required this.name,
    required this.gender,
    required this.origin,
    required this.meaning,
    required this.popularity,
    required this.variations,
    required this.nicknames,
    this.isFavorite = false,
  });

  String get popularityText {
    if (popularity <= 10) return 'Very Popular';
    if (popularity <= 50) return 'Popular';
    if (popularity <= 100) return 'Moderately Popular';
    if (popularity <= 500) return 'Uncommon';
    return 'Rare';
  }

  factory BabyNameSuggestion.fromJson(Map<String, dynamic> json) {
    return BabyNameSuggestion(
      name: json['name'],
      gender: Gender.values[json['gender']],
      origin: json['origin'],
      meaning: json['meaning'],
      popularity: json['popularity'],
      variations: List<String>.from(json['variations']),
      nicknames: List<String>.from(json['nicknames']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.index,
      'origin': origin,
      'meaning': meaning,
      'popularity': popularity,
      'variations': variations,
      'nicknames': nicknames,
      'is_favorite': isFavorite,
    };
  }
}

enum Gender { boy, girl, unisex }

class NurseryPlanning {
  final String id;
  final String userId;
  final String theme;
  final String colorScheme;
  final List<NurseryItem> items;
  final double budget;
  final double spent;
  final List<String> inspirationImages;
  final Map<String, dynamic>? roomDimensions;

  NurseryPlanning({
    required this.id,
    required this.userId,
    required this.theme,
    required this.colorScheme,
    required this.items,
    required this.budget,
    this.spent = 0.0,
    required this.inspirationImages,
    this.roomDimensions,
  });

  double get remainingBudget => budget - spent;
  double get budgetUsedPercentage => budget > 0 ? (spent / budget * 100).clamp(0, 100) : 0;
  int get completedItems => items.where((item) => item.isPurchased).length;
  int get totalItems => items.length;

  factory NurseryPlanning.fromJson(Map<String, dynamic> json) {
    return NurseryPlanning(
      id: json['id'],
      userId: json['user_id'],
      theme: json['theme'],
      colorScheme: json['color_scheme'],
      items: (json['items'] as List)
          .map((item) => NurseryItem.fromJson(item))
          .toList(),
      budget: json['budget'].toDouble(),
      spent: json['spent']?.toDouble() ?? 0.0,
      inspirationImages: List<String>.from(json['inspiration_images']),
      roomDimensions: json['room_dimensions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme': theme,
      'color_scheme': colorScheme,
      'items': items.map((item) => item.toJson()).toList(),
      'budget': budget,
      'spent': spent,
      'inspiration_images': inspirationImages,
      'room_dimensions': roomDimensions,
    };
  }
}

class NurseryItem {
  final String id;
  final String name;
  final NurseryItemCategory category;
  final double estimatedPrice;
  final double? actualPrice;
  final bool isPurchased;
  final bool isEssential;
  final String? purchaseUrl;
  final String? notes;
  final DateTime? purchaseDate;

  NurseryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.estimatedPrice,
    this.actualPrice,
    this.isPurchased = false,
    this.isEssential = false,
    this.purchaseUrl,
    this.notes,
    this.purchaseDate,
  });

  double get finalPrice => actualPrice ?? estimatedPrice;

  factory NurseryItem.fromJson(Map<String, dynamic> json) {
    return NurseryItem(
      id: json['id'],
      name: json['name'],
      category: NurseryItemCategory.values[json['category']],
      estimatedPrice: json['estimated_price'].toDouble(),
      actualPrice: json['actual_price']?.toDouble(),
      isPurchased: json['is_purchased'] ?? false,
      isEssential: json['is_essential'] ?? false,
      purchaseUrl: json['purchase_url'],
      notes: json['notes'],
      purchaseDate: json['purchase_date'] != null ? DateTime.parse(json['purchase_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.index,
      'estimated_price': estimatedPrice,
      'actual_price': actualPrice,
      'is_purchased': isPurchased,
      'is_essential': isEssential,
      'purchase_url': purchaseUrl,
      'notes': notes,
      'purchase_date': purchaseDate?.toIso8601String(),
    };
  }
}

enum NurseryItemCategory {
  furniture,
  bedding,
  decor,
  storage,
  lighting,
  safety,
  feeding,
  changing,
  clothing,
  toys
}

class DevelopmentTracker {
  final String id;
  final String userId;
  final int currentWeek;
  final DateTime lastUpdated;
  final Map<int, BabyDevelopment> weeklyDevelopments;
  final List<PregnancyMilestone> milestones;
  final List<BabyPhotoJournal> photoJournal;
  final Map<String, dynamic> preferences;

  DevelopmentTracker({
    required this.id,
    required this.userId,
    required this.currentWeek,
    required this.lastUpdated,
    required this.weeklyDevelopments,
    required this.milestones,
    required this.photoJournal,
    required this.preferences,
  });

  BabyDevelopment? get currentWeekDevelopment => weeklyDevelopments[currentWeek];
  BabyDevelopment? get nextWeekDevelopment => weeklyDevelopments[currentWeek + 1];
  List<PregnancyMilestone> get upcomingMilestones => 
    milestones.where((m) => m.isUpcoming).toList()..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
  List<PregnancyMilestone> get overdueMilestones => milestones.where((m) => m.isOverdue).toList();

  factory DevelopmentTracker.fromJson(Map<String, dynamic> json) {
    return DevelopmentTracker(
      id: json['id'],
      userId: json['user_id'],
      currentWeek: json['current_week'],
      lastUpdated: DateTime.parse(json['last_updated']),
      weeklyDevelopments: Map<int, BabyDevelopment>.from(
        json['weekly_developments'].map((key, value) => 
          MapEntry(int.parse(key), BabyDevelopment.fromJson(value))),
      ),
      milestones: (json['milestones'] as List)
          .map((milestone) => PregnancyMilestone.fromJson(milestone))
          .toList(),
      photoJournal: (json['photo_journal'] as List)
          .map((photo) => BabyPhotoJournal.fromJson(photo))
          .toList(),
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'current_week': currentWeek,
      'last_updated': lastUpdated.toIso8601String(),
      'weekly_developments': weeklyDevelopments.map((key, value) => 
        MapEntry(key.toString(), value.toJson())),
      'milestones': milestones.map((milestone) => milestone.toJson()).toList(),
      'photo_journal': photoJournal.map((photo) => photo.toJson()).toList(),
      'preferences': preferences,
    };
  }
}
