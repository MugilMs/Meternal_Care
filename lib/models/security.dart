class SecuritySettings {
  final String userId;
  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final String? twoFactorMethod;
  final bool autoLockEnabled;
  final int autoLockTimeoutMinutes;
  final bool dataEncryptionEnabled;
  final List<String> trustedDevices;
  final DateTime lastSecurityUpdate;
  final Map<String, dynamic> privacySettings;

  SecuritySettings({
    required this.userId,
    this.biometricEnabled = false,
    this.twoFactorEnabled = false,
    this.twoFactorMethod,
    this.autoLockEnabled = true,
    this.autoLockTimeoutMinutes = 5,
    this.dataEncryptionEnabled = true,
    required this.trustedDevices,
    required this.lastSecurityUpdate,
    required this.privacySettings,
  });

  bool get hasAdvancedSecurity => biometricEnabled && twoFactorEnabled;
  bool get needsSecurityUpdate => DateTime.now().difference(lastSecurityUpdate).inDays > 90;

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      userId: json['user_id'],
      biometricEnabled: json['biometric_enabled'] ?? false,
      twoFactorEnabled: json['two_factor_enabled'] ?? false,
      twoFactorMethod: json['two_factor_method'],
      autoLockEnabled: json['auto_lock_enabled'] ?? true,
      autoLockTimeoutMinutes: json['auto_lock_timeout_minutes'] ?? 5,
      dataEncryptionEnabled: json['data_encryption_enabled'] ?? true,
      trustedDevices: List<String>.from(json['trusted_devices']),
      lastSecurityUpdate: DateTime.parse(json['last_security_update']),
      privacySettings: json['privacy_settings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'biometric_enabled': biometricEnabled,
      'two_factor_enabled': twoFactorEnabled,
      'two_factor_method': twoFactorMethod,
      'auto_lock_enabled': autoLockEnabled,
      'auto_lock_timeout_minutes': autoLockTimeoutMinutes,
      'data_encryption_enabled': dataEncryptionEnabled,
      'trusted_devices': trustedDevices,
      'last_security_update': lastSecurityUpdate.toIso8601String(),
      'privacy_settings': privacySettings,
    };
  }
}

class SecurityEvent {
  final String id;
  final String userId;
  final EventType type;
  final String description;
  final EventSeverity severity;
  final DateTime timestamp;
  final String? deviceInfo;
  final String? ipAddress;
  final String? location;
  final bool isResolved;
  final Map<String, dynamic>? metadata;

  SecurityEvent({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.severity,
    required this.timestamp,
    this.deviceInfo,
    this.ipAddress,
    this.location,
    this.isResolved = false,
    this.metadata,
  });

  bool get isHighRisk => severity == EventSeverity.high || severity == EventSeverity.critical;
  bool get isRecent => DateTime.now().difference(timestamp).inHours < 24;

  factory SecurityEvent.fromJson(Map<String, dynamic> json) {
    return SecurityEvent(
      id: json['id'],
      userId: json['user_id'],
      type: EventType.values[json['type']],
      description: json['description'],
      severity: EventSeverity.values[json['severity']],
      timestamp: DateTime.parse(json['timestamp']),
      deviceInfo: json['device_info'],
      ipAddress: json['ip_address'],
      location: json['location'],
      isResolved: json['is_resolved'] ?? false,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'description': description,
      'severity': severity.index,
      'timestamp': timestamp.toIso8601String(),
      'device_info': deviceInfo,
      'ip_address': ipAddress,
      'location': location,
      'is_resolved': isResolved,
      'metadata': metadata,
    };
  }
}

enum EventType {
  login,
  logout,
  failedLogin,
  passwordChange,
  dataAccess,
  dataExport,
  settingsChange,
  suspiciousActivity,
  deviceRegistration,
  accountLocked
}

enum EventSeverity { low, medium, high, critical }

class DataPrivacy {
  final String userId;
  final bool shareWithHealthcare;
  final bool shareWithResearchers;
  final bool allowAnalytics;
  final bool allowPersonalization;
  final List<String> dataCategories;
  final Map<String, bool> sharingPermissions;
  final DateTime consentDate;
  final String? consentVersion;

  DataPrivacy({
    required this.userId,
    this.shareWithHealthcare = false,
    this.shareWithResearchers = false,
    this.allowAnalytics = true,
    this.allowPersonalization = true,
    required this.dataCategories,
    required this.sharingPermissions,
    required this.consentDate,
    this.consentVersion,
  });

  bool get hasGivenHealthcareConsent => shareWithHealthcare;
  bool get hasRestrictedSharing => !shareWithHealthcare && !shareWithResearchers;

  factory DataPrivacy.fromJson(Map<String, dynamic> json) {
    return DataPrivacy(
      userId: json['user_id'],
      shareWithHealthcare: json['share_with_healthcare'] ?? false,
      shareWithResearchers: json['share_with_researchers'] ?? false,
      allowAnalytics: json['allow_analytics'] ?? true,
      allowPersonalization: json['allow_personalization'] ?? true,
      dataCategories: List<String>.from(json['data_categories']),
      sharingPermissions: Map<String, bool>.from(json['sharing_permissions']),
      consentDate: DateTime.parse(json['consent_date']),
      consentVersion: json['consent_version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'share_with_healthcare': shareWithHealthcare,
      'share_with_researchers': shareWithResearchers,
      'allow_analytics': allowAnalytics,
      'allow_personalization': allowPersonalization,
      'data_categories': dataCategories,
      'sharing_permissions': sharingPermissions,
      'consent_date': consentDate.toIso8601String(),
      'consent_version': consentVersion,
    };
  }
}

class EncryptedData {
  final String id;
  final String encryptedContent;
  final String encryptionMethod;
  final String keyId;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  EncryptedData({
    required this.id,
    required this.encryptedContent,
    required this.encryptionMethod,
    required this.keyId,
    required this.createdAt,
    this.metadata,
  });

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      id: json['id'],
      encryptedContent: json['encrypted_content'],
      encryptionMethod: json['encryption_method'],
      keyId: json['key_id'],
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encrypted_content': encryptedContent,
      'encryption_method': encryptionMethod,
      'key_id': keyId,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class AccessControl {
  final String userId;
  final List<Permission> permissions;
  final List<String> roles;
  final Map<String, AccessLevel> resourceAccess;
  final DateTime lastPermissionUpdate;

  AccessControl({
    required this.userId,
    required this.permissions,
    required this.roles,
    required this.resourceAccess,
    required this.lastPermissionUpdate,
  });

  bool hasPermission(String permission) => permissions.any((p) => p.name == permission && p.isGranted);
  bool hasRole(String role) => roles.contains(role);
  AccessLevel getResourceAccess(String resource) => resourceAccess[resource] ?? AccessLevel.none;

  factory AccessControl.fromJson(Map<String, dynamic> json) {
    return AccessControl(
      userId: json['user_id'],
      permissions: (json['permissions'] as List)
          .map((permission) => Permission.fromJson(permission))
          .toList(),
      roles: List<String>.from(json['roles']),
      resourceAccess: Map<String, AccessLevel>.from(
        json['resource_access'].map((key, value) => MapEntry(key, AccessLevel.values[value])),
      ),
      lastPermissionUpdate: DateTime.parse(json['last_permission_update']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'permissions': permissions.map((permission) => permission.toJson()).toList(),
      'roles': roles,
      'resource_access': resourceAccess.map((key, value) => MapEntry(key, value.index)),
      'last_permission_update': lastPermissionUpdate.toIso8601String(),
    };
  }
}

class Permission {
  final String name;
  final String description;
  final bool isGranted;
  final DateTime? grantedAt;
  final DateTime? expiresAt;

  Permission({
    required this.name,
    required this.description,
    this.isGranted = false,
    this.grantedAt,
    this.expiresAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isValid => isGranted && !isExpired;

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      name: json['name'],
      description: json['description'],
      isGranted: json['is_granted'] ?? false,
      grantedAt: json['granted_at'] != null ? DateTime.parse(json['granted_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'is_granted': isGranted,
      'granted_at': grantedAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}

enum AccessLevel { none, read, write, admin }
