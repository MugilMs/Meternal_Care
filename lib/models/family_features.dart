class FamilyMember {
  final String id;
  final String userId;
  final String name;
  final String email;
  final FamilyRole role;
  final String? phoneNumber;
  final String? avatarUrl;
  final bool isActive;
  final DateTime joinedAt;
  final Map<String, bool> permissions;
  final NotificationPreferences notificationPreferences;

  FamilyMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.avatarUrl,
    this.isActive = true,
    required this.joinedAt,
    required this.permissions,
    required this.notificationPreferences,
  });

  bool get canViewHealthData => permissions['view_health_data'] ?? false;
  bool get canReceiveUpdates => permissions['receive_updates'] ?? false;
  bool get isPartner => role == FamilyRole.partner;
  bool get isParent => role == FamilyRole.parent;

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      role: FamilyRole.values[json['role']],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
      isActive: json['is_active'] ?? true,
      joinedAt: DateTime.parse(json['joined_at']),
      permissions: Map<String, bool>.from(json['permissions']),
      notificationPreferences: NotificationPreferences.fromJson(json['notification_preferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'email': email,
      'role': role.index,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'joined_at': joinedAt.toIso8601String(),
      'permissions': permissions,
      'notification_preferences': notificationPreferences.toJson(),
    };
  }
}

enum FamilyRole {
  partner,
  parent,
  sibling,
  grandparent,
  friend,
  caregiver,
  doula,
  other
}

class NotificationPreferences {
  final bool appointmentReminders;
  final bool healthUpdates;
  final bool milestoneAlerts;
  final bool emergencyNotifications;
  final bool weeklyReports;
  final bool photoUpdates;
  final String preferredMethod; // email, sms, push

  NotificationPreferences({
    this.appointmentReminders = true,
    this.healthUpdates = true,
    this.milestoneAlerts = true,
    this.emergencyNotifications = true,
    this.weeklyReports = false,
    this.photoUpdates = true,
    this.preferredMethod = 'push',
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      appointmentReminders: json['appointment_reminders'] ?? true,
      healthUpdates: json['health_updates'] ?? true,
      milestoneAlerts: json['milestone_alerts'] ?? true,
      emergencyNotifications: json['emergency_notifications'] ?? true,
      weeklyReports: json['weekly_reports'] ?? false,
      photoUpdates: json['photo_updates'] ?? true,
      preferredMethod: json['preferred_method'] ?? 'push',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_reminders': appointmentReminders,
      'health_updates': healthUpdates,
      'milestone_alerts': milestoneAlerts,
      'emergency_notifications': emergencyNotifications,
      'weekly_reports': weeklyReports,
      'photo_updates': photoUpdates,
      'preferred_method': preferredMethod,
    };
  }
}

class FamilyUpdate {
  final String id;
  final String userId;
  final String authorId;
  final UpdateType type;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final List<String> sharedWith;
  final Map<String, dynamic>? metadata;

  FamilyUpdate({
    required this.id,
    required this.userId,
    required this.authorId,
    required this.type,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.sharedWith,
    this.metadata,
  });

  bool get hasImages => imageUrls.isNotEmpty;
  bool get isSharedWithAll => sharedWith.isEmpty; // Empty means shared with all family members

  factory FamilyUpdate.fromJson(Map<String, dynamic> json) {
    return FamilyUpdate(
      id: json['id'],
      userId: json['user_id'],
      authorId: json['author_id'],
      type: UpdateType.values[json['type']],
      title: json['title'],
      content: json['content'],
      imageUrls: List<String>.from(json['image_urls']),
      createdAt: DateTime.parse(json['created_at']),
      sharedWith: List<String>.from(json['shared_with']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'author_id': authorId,
      'type': type.index,
      'title': title,
      'content': content,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
      'shared_with': sharedWith,
      'metadata': metadata,
    };
  }
}

enum UpdateType {
  milestone,
  appointment,
  healthUpdate,
  photo,
  general,
  emergency,
  celebration
}

class PartnerApp {
  final String id;
  final String partnerId;
  final String pregnantUserId;
  final bool isConnected;
  final DateTime connectedAt;
  final PartnerPermissions permissions;
  final List<String> subscribedUpdates;
  final Map<String, dynamic> preferences;

  PartnerApp({
    required this.id,
    required this.partnerId,
    required this.pregnantUserId,
    this.isConnected = true,
    required this.connectedAt,
    required this.permissions,
    required this.subscribedUpdates,
    required this.preferences,
  });

  factory PartnerApp.fromJson(Map<String, dynamic> json) {
    return PartnerApp(
      id: json['id'],
      partnerId: json['partner_id'],
      pregnantUserId: json['pregnant_user_id'],
      isConnected: json['is_connected'] ?? true,
      connectedAt: DateTime.parse(json['connected_at']),
      permissions: PartnerPermissions.fromJson(json['permissions']),
      subscribedUpdates: List<String>.from(json['subscribed_updates']),
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'pregnant_user_id': pregnantUserId,
      'is_connected': isConnected,
      'connected_at': connectedAt.toIso8601String(),
      'permissions': permissions.toJson(),
      'subscribed_updates': subscribedUpdates,
      'preferences': preferences,
    };
  }
}

class PartnerPermissions {
  final bool viewHealthData;
  final bool viewAppointments;
  final bool receiveEmergencyAlerts;
  final bool viewBabyDevelopment;
  final bool accessPhotoJournal;
  final bool viewSymptomLogs;
  final bool receiveWeeklyUpdates;

  PartnerPermissions({
    this.viewHealthData = true,
    this.viewAppointments = true,
    this.receiveEmergencyAlerts = true,
    this.viewBabyDevelopment = true,
    this.accessPhotoJournal = true,
    this.viewSymptomLogs = false,
    this.receiveWeeklyUpdates = true,
  });

  factory PartnerPermissions.fromJson(Map<String, dynamic> json) {
    return PartnerPermissions(
      viewHealthData: json['view_health_data'] ?? true,
      viewAppointments: json['view_appointments'] ?? true,
      receiveEmergencyAlerts: json['receive_emergency_alerts'] ?? true,
      viewBabyDevelopment: json['view_baby_development'] ?? true,
      accessPhotoJournal: json['access_photo_journal'] ?? true,
      viewSymptomLogs: json['view_symptom_logs'] ?? false,
      receiveWeeklyUpdates: json['receive_weekly_updates'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'view_health_data': viewHealthData,
      'view_appointments': viewAppointments,
      'receive_emergency_alerts': receiveEmergencyAlerts,
      'view_baby_development': viewBabyDevelopment,
      'access_photo_journal': accessPhotoJournal,
      'view_symptom_logs': viewSymptomLogs,
      'receive_weekly_updates': receiveWeeklyUpdates,
    };
  }
}

class ChildcareProvider {
  final String id;
  final String name;
  final String type; // nanny, daycare, babysitter, etc.
  final String description;
  final String address;
  final String phoneNumber;
  final String? email;
  final String? website;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final Map<String, dynamic> pricing;
  final List<String> availability;
  final bool isVerified;
  final List<String> certifications;

  ChildcareProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.address,
    required this.phoneNumber,
    this.email,
    this.website,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.services,
    required this.pricing,
    required this.availability,
    this.isVerified = false,
    required this.certifications,
  });

  bool get hasGoodRating => rating >= 4.0;
  bool get hasReviews => reviewCount > 0;

  factory ChildcareProvider.fromJson(Map<String, dynamic> json) {
    return ChildcareProvider(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      website: json['website'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      services: List<String>.from(json['services']),
      pricing: json['pricing'],
      availability: List<String>.from(json['availability']),
      isVerified: json['is_verified'] ?? false,
      certifications: List<String>.from(json['certifications']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'website': website,
      'rating': rating,
      'review_count': reviewCount,
      'services': services,
      'pricing': pricing,
      'availability': availability,
      'is_verified': isVerified,
      'certifications': certifications,
    };
  }
}

class FamilyCalendar {
  final String id;
  final String familyId;
  final List<FamilyEvent> events;
  final Map<String, bool> memberVisibility;
  final DateTime lastUpdated;

  FamilyCalendar({
    required this.id,
    required this.familyId,
    required this.events,
    required this.memberVisibility,
    required this.lastUpdated,
  });

  List<FamilyEvent> getEventsForDate(DateTime date) {
    return events.where((event) {
      return event.startTime.year == date.year &&
             event.startTime.month == date.month &&
             event.startTime.day == date.day;
    }).toList();
  }

  List<FamilyEvent> getUpcomingEvents(int days) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    return events.where((event) {
      return event.startTime.isAfter(now) && event.startTime.isBefore(endDate);
    }).toList();
  }

  factory FamilyCalendar.fromJson(Map<String, dynamic> json) {
    return FamilyCalendar(
      id: json['id'],
      familyId: json['family_id'],
      events: (json['events'] as List)
          .map((event) => FamilyEvent.fromJson(event))
          .toList(),
      memberVisibility: Map<String, bool>.from(json['member_visibility']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_id': familyId,
      'events': events.map((event) => event.toJson()).toList(),
      'member_visibility': memberVisibility,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class FamilyEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final EventCategory category;
  final String? location;
  final List<String> attendees;
  final bool isAllDay;
  final String? reminder;

  FamilyEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    required this.category,
    this.location,
    required this.attendees,
    this.isAllDay = false,
    this.reminder,
  });

  Duration? get duration => endTime?.difference(startTime);
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
           startTime.month == now.month &&
           startTime.day == now.day;
  }

  factory FamilyEvent.fromJson(Map<String, dynamic> json) {
    return FamilyEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      category: EventCategory.values[json['category']],
      location: json['location'],
      attendees: List<String>.from(json['attendees']),
      isAllDay: json['is_all_day'] ?? false,
      reminder: json['reminder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'category': category.index,
      'location': location,
      'attendees': attendees,
      'is_all_day': isAllDay,
      'reminder': reminder,
    };
  }
}

enum EventCategory {
  appointment,
  milestone,
  preparation,
  social,
  education,
  exercise,
  other
}
