class SocialGroup {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final GroupType type;
  final GroupPrivacy privacy;
  final DateTime createdAt;
  final String creatorId;
  final List<String> memberIds;
  final List<String> moderatorIds;
  final Map<String, dynamic>? metadata;
  final bool isActive;

  SocialGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.privacy,
    required this.createdAt,
    required this.creatorId,
    required this.memberIds,
    required this.moderatorIds,
    this.metadata,
    this.isActive = true,
  });

  int get memberCount => memberIds.length;
  bool get isPublic => privacy == GroupPrivacy.public;
  bool get isPrivate => privacy == GroupPrivacy.private;

  factory SocialGroup.fromJson(Map<String, dynamic> json) {
    return SocialGroup(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      type: GroupType.values[json['type']],
      privacy: GroupPrivacy.values[json['privacy']],
      createdAt: DateTime.parse(json['created_at']),
      creatorId: json['creator_id'],
      memberIds: List<String>.from(json['member_ids']),
      moderatorIds: List<String>.from(json['moderator_ids']),
      metadata: json['metadata'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'type': type.index,
      'privacy': privacy.index,
      'created_at': createdAt.toIso8601String(),
      'creator_id': creatorId,
      'member_ids': memberIds,
      'moderator_ids': moderatorIds,
      'metadata': metadata,
      'is_active': isActive,
    };
  }
}

enum GroupType {
  dueDateGroup,
  localGroup,
  topicBased,
  expertLed,
  supportGroup,
  firstTimeMoms,
  secondTimeMoms,
  highRiskPregnancy,
  postpartum,
  general
}

enum GroupPrivacy { public, private, invite_only }

class GroupMember {
  final String userId;
  final String groupId;
  final MemberRole role;
  final DateTime joinedAt;
  final bool isActive;
  final Map<String, dynamic>? memberData;

  GroupMember({
    required this.userId,
    required this.groupId,
    required this.role,
    required this.joinedAt,
    this.isActive = true,
    this.memberData,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['user_id'],
      groupId: json['group_id'],
      role: MemberRole.values[json['role']],
      joinedAt: DateTime.parse(json['joined_at']),
      isActive: json['is_active'] ?? true,
      memberData: json['member_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'group_id': groupId,
      'role': role.index,
      'joined_at': joinedAt.toIso8601String(),
      'is_active': isActive,
      'member_data': memberData,
    };
  }
}

enum MemberRole { member, moderator, admin, creator }

class ExpertQA {
  final String id;
  final String question;
  final String? answer;
  final String userId;
  final String? expertId;
  final List<String> tags;
  final QACategory category;
  final QAStatus status;
  final DateTime createdAt;
  final DateTime? answeredAt;
  final int upvotes;
  final List<String> upvotedBy;
  final bool isAnonymous;

  ExpertQA({
    required this.id,
    required this.question,
    this.answer,
    required this.userId,
    this.expertId,
    required this.tags,
    required this.category,
    required this.status,
    required this.createdAt,
    this.answeredAt,
    this.upvotes = 0,
    required this.upvotedBy,
    this.isAnonymous = false,
  });

  bool get isAnswered => answer != null && answer!.isNotEmpty;
  bool get isPending => status == QAStatus.pending;

  factory ExpertQA.fromJson(Map<String, dynamic> json) {
    return ExpertQA(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      userId: json['user_id'],
      expertId: json['expert_id'],
      tags: List<String>.from(json['tags']),
      category: QACategory.values[json['category']],
      status: QAStatus.values[json['status']],
      createdAt: DateTime.parse(json['created_at']),
      answeredAt: json['answered_at'] != null ? DateTime.parse(json['answered_at']) : null,
      upvotes: json['upvotes'] ?? 0,
      upvotedBy: List<String>.from(json['upvoted_by'] ?? []),
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'user_id': userId,
      'expert_id': expertId,
      'tags': tags,
      'category': category.index,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'answered_at': answeredAt?.toIso8601String(),
      'upvotes': upvotes,
      'upvoted_by': upvotedBy,
      'is_anonymous': isAnonymous,
    };
  }
}

enum QACategory {
  medical,
  nutrition,
  exercise,
  mental_health,
  labor_delivery,
  postpartum,
  baby_development,
  breastfeeding,
  general
}

enum QAStatus { pending, answered, closed, featured }

class Expert {
  final String id;
  final String name;
  final String title;
  final String specialty;
  final String bio;
  final String imageUrl;
  final List<String> credentials;
  final List<String> specializations;
  final double rating;
  final int totalAnswers;
  final bool isVerified;
  final bool isAvailable;

  Expert({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.imageUrl,
    required this.credentials,
    required this.specializations,
    this.rating = 0.0,
    this.totalAnswers = 0,
    this.isVerified = false,
    this.isAvailable = true,
  });

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      specialty: json['specialty'],
      bio: json['bio'],
      imageUrl: json['image_url'],
      credentials: List<String>.from(json['credentials']),
      specializations: List<String>.from(json['specializations']),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalAnswers: json['total_answers'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'specialty': specialty,
      'bio': bio,
      'image_url': imageUrl,
      'credentials': credentials,
      'specializations': specializations,
      'rating': rating,
      'total_answers': totalAnswers,
      'is_verified': isVerified,
      'is_available': isAvailable,
    };
  }
}
