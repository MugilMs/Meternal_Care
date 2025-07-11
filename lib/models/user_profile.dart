class UserProfile {
  final String id;
  final String? email;
  final String? fullName;
  final String? displayName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? dueDate;
  final int? currentWeek;
  final String? bloodType;
  final double? height;
  final double? prePregnancyWeight;
  final double? currentWeight;
  final List<String>? allergies;
  final List<String>? medicalConditions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.email,
    this.fullName,
    this.displayName,
    this.phoneNumber,
    this.avatarUrl,
    this.dueDate,
    this.currentWeek,
    this.bloodType,
    this.height,
    this.prePregnancyWeight,
    this.currentWeight,
    this.allergies,
    this.medicalConditions,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      displayName: json['display_name'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
      dueDate: json['due_date'],
      currentWeek: json['current_week'],
      bloodType: json['blood_type'],
      height: json['height']?.toDouble(),
      prePregnancyWeight: json['pre_pregnancy_weight']?.toDouble(),
      currentWeight: json['current_weight']?.toDouble(),
      allergies: json['allergies'] != null 
          ? List<String>.from(json['allergies']) 
          : null,
      medicalConditions: json['medical_conditions'] != null 
          ? List<String>.from(json['medical_conditions']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'display_name': displayName,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'due_date': dueDate,
      'current_week': currentWeek,
      'blood_type': bloodType,
      'height': height,
      'pre_pregnancy_weight': prePregnancyWeight,
      'current_weight': currentWeight,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
    String? dueDate,
    int? currentWeek,
    String? bloodType,
    double? height,
    double? prePregnancyWeight,
    double? currentWeight,
    List<String>? allergies,
    List<String>? medicalConditions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dueDate: dueDate ?? this.dueDate,
      currentWeek: currentWeek ?? this.currentWeek,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      prePregnancyWeight: prePregnancyWeight ?? this.prePregnancyWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
