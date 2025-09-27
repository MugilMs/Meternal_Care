class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phoneNumber;
  final String? email;
  final ContactType type;
  final bool isPrimary;
  final bool isAvailable24x7;
  final String? address;
  final Map<String, dynamic>? additionalInfo;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    this.email,
    required this.type,
    this.isPrimary = false,
    this.isAvailable24x7 = false,
    this.address,
    this.additionalInfo,
  });

  bool get isMedical => type == ContactType.doctor || type == ContactType.hospital || type == ContactType.midwife;
  bool get isFamily => type == ContactType.family || type == ContactType.partner;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      relationship: json['relationship'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      type: ContactType.values[json['type']],
      isPrimary: json['is_primary'] ?? false,
      isAvailable24x7: json['is_available_24x7'] ?? false,
      address: json['address'],
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'phone_number': phoneNumber,
      'email': email,
      'type': type.index,
      'is_primary': isPrimary,
      'is_available_24x7': isAvailable24x7,
      'address': address,
      'additional_info': additionalInfo,
    };
  }
}

enum ContactType {
  doctor,
  hospital,
  midwife,
  partner,
  family,
  friend,
  doula,
  emergency911
}

class EmergencyAlert {
  final String id;
  final String userId;
  final AlertType type;
  final EmergencyLevel level;
  final String title;
  final String description;
  final DateTime triggeredAt;
  final String? location;
  final Map<String, dynamic>? vitalSigns;
  final List<String> contactsNotified;
  final AlertStatus status;
  final DateTime? resolvedAt;
  final String? resolution;

  EmergencyAlert({
    required this.id,
    required this.userId,
    required this.type,
    required this.level,
    required this.title,
    required this.description,
    required this.triggeredAt,
    this.location,
    this.vitalSigns,
    required this.contactsNotified,
    required this.status,
    this.resolvedAt,
    this.resolution,
  });

  bool get isActive => status == AlertStatus.active;
  bool get isCritical => level == EmergencyLevel.critical;
  Duration get duration => (resolvedAt ?? DateTime.now()).difference(triggeredAt);

  factory EmergencyAlert.fromJson(Map<String, dynamic> json) {
    return EmergencyAlert(
      id: json['id'],
      userId: json['user_id'],
      type: AlertType.values[json['type']],
      level: EmergencyLevel.values[json['level']],
      title: json['title'],
      description: json['description'],
      triggeredAt: DateTime.parse(json['triggered_at']),
      location: json['location'],
      vitalSigns: json['vital_signs'],
      contactsNotified: List<String>.from(json['contacts_notified']),
      status: AlertStatus.values[json['status']],
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at']) : null,
      resolution: json['resolution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'level': level.index,
      'title': title,
      'description': description,
      'triggered_at': triggeredAt.toIso8601String(),
      'location': location,
      'vital_signs': vitalSigns,
      'contacts_notified': contactsNotified,
      'status': status.index,
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolution': resolution,
    };
  }
}

enum AlertType {
  medicalEmergency,
  laborOnset,
  severeSymptoms,
  fallDetection,
  panicButton,
  abnormalVitals,
  medicationAlert,
  appointmentMissed
}

enum EmergencyLevel { low, medium, high, critical }
enum AlertStatus { active, acknowledged, resolved, false_alarm }

class MedicalID {
  final String userId;
  final String fullName;
  final DateTime dateOfBirth;
  final String bloodType;
  final List<String> allergies;
  final List<String> medications;
  final List<String> medicalConditions;
  final List<EmergencyContact> emergencyContacts;
  final String? pregnancyDueDate;
  final int? pregnancyWeek;
  final String? primaryDoctor;
  final String? hospital;
  final Map<String, dynamic>? insuranceInfo;
  final DateTime lastUpdated;

  MedicalID({
    required this.userId,
    required this.fullName,
    required this.dateOfBirth,
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.medicalConditions,
    required this.emergencyContacts,
    this.pregnancyDueDate,
    this.pregnancyWeek,
    this.primaryDoctor,
    this.hospital,
    this.insuranceInfo,
    required this.lastUpdated,
  });

  int get age => DateTime.now().difference(dateOfBirth).inDays ~/ 365;
  bool get hasAllergies => allergies.isNotEmpty;
  bool get isOnMedications => medications.isNotEmpty;
  bool get hasConditions => medicalConditions.isNotEmpty;

  factory MedicalID.fromJson(Map<String, dynamic> json) {
    return MedicalID(
      userId: json['user_id'],
      fullName: json['full_name'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      bloodType: json['blood_type'],
      allergies: List<String>.from(json['allergies']),
      medications: List<String>.from(json['medications']),
      medicalConditions: List<String>.from(json['medical_conditions']),
      emergencyContacts: (json['emergency_contacts'] as List)
          .map((contact) => EmergencyContact.fromJson(contact))
          .toList(),
      pregnancyDueDate: json['pregnancy_due_date'],
      pregnancyWeek: json['pregnancy_week'],
      primaryDoctor: json['primary_doctor'],
      hospital: json['hospital'],
      insuranceInfo: json['insurance_info'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'blood_type': bloodType,
      'allergies': allergies,
      'medications': medications,
      'medical_conditions': medicalConditions,
      'emergency_contacts': emergencyContacts.map((contact) => contact.toJson()).toList(),
      'pregnancy_due_date': pregnancyDueDate,
      'pregnancy_week': pregnancyWeek,
      'primary_doctor': primaryDoctor,
      'hospital': hospital,
      'insurance_info': insuranceInfo,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class LocationService {
  final String userId;
  final bool isEnabled;
  final bool shareWithFamily;
  final bool shareWithMedical;
  final bool emergencyLocationSharing;
  final List<String> trustedContacts;
  final Map<String, dynamic> locationHistory;
  final DateTime lastLocationUpdate;

  LocationService({
    required this.userId,
    this.isEnabled = false,
    this.shareWithFamily = false,
    this.shareWithMedical = true,
    this.emergencyLocationSharing = true,
    required this.trustedContacts,
    required this.locationHistory,
    required this.lastLocationUpdate,
  });

  bool get hasRecentLocation => DateTime.now().difference(lastLocationUpdate).inMinutes < 30;

  factory LocationService.fromJson(Map<String, dynamic> json) {
    return LocationService(
      userId: json['user_id'],
      isEnabled: json['is_enabled'] ?? false,
      shareWithFamily: json['share_with_family'] ?? false,
      shareWithMedical: json['share_with_medical'] ?? true,
      emergencyLocationSharing: json['emergency_location_sharing'] ?? true,
      trustedContacts: List<String>.from(json['trusted_contacts']),
      locationHistory: json['location_history'],
      lastLocationUpdate: DateTime.parse(json['last_location_update']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'is_enabled': isEnabled,
      'share_with_family': shareWithFamily,
      'share_with_medical': shareWithMedical,
      'emergency_location_sharing': emergencyLocationSharing,
      'trusted_contacts': trustedContacts,
      'location_history': locationHistory,
      'last_location_update': lastLocationUpdate.toIso8601String(),
    };
  }
}

class EmergencyProtocol {
  final String id;
  final String name;
  final ProtocolType type;
  final List<ProtocolStep> steps;
  final List<String> triggerConditions;
  final EmergencyLevel minimumLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUsed;

  EmergencyProtocol({
    required this.id,
    required this.name,
    required this.type,
    required this.steps,
    required this.triggerConditions,
    required this.minimumLevel,
    this.isActive = true,
    required this.createdAt,
    this.lastUsed,
  });

  bool get hasBeenUsed => lastUsed != null;
  int get stepCount => steps.length;

  factory EmergencyProtocol.fromJson(Map<String, dynamic> json) {
    return EmergencyProtocol(
      id: json['id'],
      name: json['name'],
      type: ProtocolType.values[json['type']],
      steps: (json['steps'] as List)
          .map((step) => ProtocolStep.fromJson(step))
          .toList(),
      triggerConditions: List<String>.from(json['trigger_conditions']),
      minimumLevel: EmergencyLevel.values[json['minimum_level']],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      lastUsed: json['last_used'] != null ? DateTime.parse(json['last_used']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'steps': steps.map((step) => step.toJson()).toList(),
      'trigger_conditions': triggerConditions,
      'minimum_level': minimumLevel.index,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_used': lastUsed?.toIso8601String(),
    };
  }
}

enum ProtocolType {
  laborOnset,
  medicalEmergency,
  severeSymptoms,
  fallDetection,
  panicResponse,
  hospitalTransport
}

class ProtocolStep {
  final int order;
  final String title;
  final String description;
  final StepType type;
  final bool isRequired;
  final Map<String, dynamic>? actionData;
  final Duration? timeLimit;

  ProtocolStep({
    required this.order,
    required this.title,
    required this.description,
    required this.type,
    this.isRequired = true,
    this.actionData,
    this.timeLimit,
  });

  factory ProtocolStep.fromJson(Map<String, dynamic> json) {
    return ProtocolStep(
      order: json['order'],
      title: json['title'],
      description: json['description'],
      type: StepType.values[json['type']],
      isRequired: json['is_required'] ?? true,
      actionData: json['action_data'],
      timeLimit: json['time_limit_seconds'] != null 
        ? Duration(seconds: json['time_limit_seconds']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'title': title,
      'description': description,
      'type': type.index,
      'is_required': isRequired,
      'action_data': actionData,
      'time_limit_seconds': timeLimit?.inSeconds,
    };
  }
}

enum StepType {
  callEmergency,
  notifyContacts,
  gatherInformation,
  takeAction,
  waitForHelp,
  followUp
}

class EmergencySettings {
  final String userId;
  final bool autoCallEmergency;
  final bool shareLocationInEmergency;
  final bool notifyAllContacts;
  final int emergencyTimeoutSeconds;
  final bool enableFallDetection;
  final bool enablePanicButton;
  final Map<String, bool> alertTypes;
  final List<String> customProtocols;

  EmergencySettings({
    required this.userId,
    this.autoCallEmergency = false,
    this.shareLocationInEmergency = true,
    this.notifyAllContacts = true,
    this.emergencyTimeoutSeconds = 30,
    this.enableFallDetection = false,
    this.enablePanicButton = true,
    required this.alertTypes,
    required this.customProtocols,
  });

  factory EmergencySettings.fromJson(Map<String, dynamic> json) {
    return EmergencySettings(
      userId: json['user_id'],
      autoCallEmergency: json['auto_call_emergency'] ?? false,
      shareLocationInEmergency: json['share_location_in_emergency'] ?? true,
      notifyAllContacts: json['notify_all_contacts'] ?? true,
      emergencyTimeoutSeconds: json['emergency_timeout_seconds'] ?? 30,
      enableFallDetection: json['enable_fall_detection'] ?? false,
      enablePanicButton: json['enable_panic_button'] ?? true,
      alertTypes: Map<String, bool>.from(json['alert_types']),
      customProtocols: List<String>.from(json['custom_protocols']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'auto_call_emergency': autoCallEmergency,
      'share_location_in_emergency': shareLocationInEmergency,
      'notify_all_contacts': notifyAllContacts,
      'emergency_timeout_seconds': emergencyTimeoutSeconds,
      'enable_fall_detection': enableFallDetection,
      'enable_panic_button': enablePanicButton,
      'alert_types': alertTypes,
      'custom_protocols': customProtocols,
    };
  }
}
