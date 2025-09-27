class SmartDevice {
  final String id;
  final String name;
  final DeviceType type;
  final String brand;
  final String model;
  final bool isConnected;
  final DateTime? lastSyncTime;
  final Map<String, dynamic> capabilities;
  final DeviceStatus status;
  final double? batteryLevel;

  SmartDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.model,
    this.isConnected = false,
    this.lastSyncTime,
    required this.capabilities,
    required this.status,
    this.batteryLevel,
  });

  bool get needsBatteryCharge => batteryLevel != null && batteryLevel! < 20;
  bool get isOnline => isConnected && status == DeviceStatus.active;

  factory SmartDevice.fromJson(Map<String, dynamic> json) {
    return SmartDevice(
      id: json['id'],
      name: json['name'],
      type: DeviceType.values[json['type']],
      brand: json['brand'],
      model: json['model'],
      isConnected: json['is_connected'] ?? false,
      lastSyncTime: json['last_sync_time'] != null ? DateTime.parse(json['last_sync_time']) : null,
      capabilities: json['capabilities'],
      status: DeviceStatus.values[json['status']],
      batteryLevel: json['battery_level']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'brand': brand,
      'model': model,
      'is_connected': isConnected,
      'last_sync_time': lastSyncTime?.toIso8601String(),
      'capabilities': capabilities,
      'status': status.index,
      'battery_level': batteryLevel,
    };
  }
}

enum DeviceType {
  smartScale,
  fitnessTracker,
  smartWatch,
  bloodPressureMonitor,
  glucoseMeter,
  thermometer,
  sleepTracker,
  heartRateMonitor,
  prenatalMonitor
}

enum DeviceStatus { active, inactive, error, syncing, lowBattery }

class DeviceReading {
  final String id;
  final String deviceId;
  final String userId;
  final ReadingType type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final bool isValidated;

  DeviceReading({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.metadata,
    this.isValidated = false,
  });

  String get formattedValue => '${value.toStringAsFixed(1)} $unit';
  bool get isRecent => DateTime.now().difference(timestamp).inHours < 24;

  factory DeviceReading.fromJson(Map<String, dynamic> json) {
    return DeviceReading(
      id: json['id'],
      deviceId: json['device_id'],
      userId: json['user_id'],
      type: ReadingType.values[json['type']],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
      isValidated: json['is_validated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'user_id': userId,
      'type': type.index,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'is_validated': isValidated,
    };
  }
}

enum ReadingType {
  weight,
  bloodPressureSystolic,
  bloodPressureDiastolic,
  heartRate,
  bloodGlucose,
  bodyTemperature,
  sleepHours,
  steps,
  caloriesBurned,
  stressLevel
}

class HealthSync {
  final String id;
  final String userId;
  final List<SmartDevice> connectedDevices;
  final DateTime lastFullSync;
  final Map<String, List<DeviceReading>> recentReadings;
  final List<SyncAlert> alerts;
  final SyncPreferences preferences;

  HealthSync({
    required this.id,
    required this.userId,
    required this.connectedDevices,
    required this.lastFullSync,
    required this.recentReadings,
    required this.alerts,
    required this.preferences,
  });

  List<SmartDevice> get activeDevices => connectedDevices.where((d) => d.isOnline).toList();
  List<SyncAlert> get unreadAlerts => alerts.where((a) => !a.isRead).toList();
  bool get hasLowBatteryDevices => connectedDevices.any((d) => d.needsBatteryCharge);

  factory HealthSync.fromJson(Map<String, dynamic> json) {
    return HealthSync(
      id: json['id'],
      userId: json['user_id'],
      connectedDevices: (json['connected_devices'] as List)
          .map((device) => SmartDevice.fromJson(device))
          .toList(),
      lastFullSync: DateTime.parse(json['last_full_sync']),
      recentReadings: Map<String, List<DeviceReading>>.from(
        json['recent_readings'].map((key, value) => MapEntry(
          key,
          (value as List).map((reading) => DeviceReading.fromJson(reading)).toList(),
        )),
      ),
      alerts: (json['alerts'] as List)
          .map((alert) => SyncAlert.fromJson(alert))
          .toList(),
      preferences: SyncPreferences.fromJson(json['preferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'connected_devices': connectedDevices.map((device) => device.toJson()).toList(),
      'last_full_sync': lastFullSync.toIso8601String(),
      'recent_readings': recentReadings.map((key, value) => MapEntry(
        key,
        value.map((reading) => reading.toJson()).toList(),
      )),
      'alerts': alerts.map((alert) => alert.toJson()).toList(),
      'preferences': preferences.toJson(),
    };
  }
}

class SyncAlert {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? actionData;

  SyncAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.createdAt,
    this.isRead = false,
    this.actionData,
  });

  factory SyncAlert.fromJson(Map<String, dynamic> json) {
    return SyncAlert(
      id: json['id'],
      type: AlertType.values[json['type']],
      title: json['title'],
      message: json['message'],
      severity: AlertSeverity.values[json['severity']],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
      actionData: json['action_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'message': message,
      'severity': severity.index,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'action_data': actionData,
    };
  }
}

enum AlertType {
  deviceDisconnected,
  lowBattery,
  abnormalReading,
  syncFailure,
  deviceError,
  maintenanceRequired
}

enum AlertSeverity { info, warning, critical }

class SyncPreferences {
  final bool autoSync;
  final int syncFrequencyMinutes;
  final bool notifyOnAbnormalReadings;
  final bool notifyOnDeviceDisconnect;
  final bool shareWithHealthcare;
  final List<String> enabledDeviceTypes;
  final Map<String, dynamic> thresholds;

  SyncPreferences({
    this.autoSync = true,
    this.syncFrequencyMinutes = 30,
    this.notifyOnAbnormalReadings = true,
    this.notifyOnDeviceDisconnect = true,
    this.shareWithHealthcare = false,
    required this.enabledDeviceTypes,
    required this.thresholds,
  });

  factory SyncPreferences.fromJson(Map<String, dynamic> json) {
    return SyncPreferences(
      autoSync: json['auto_sync'] ?? true,
      syncFrequencyMinutes: json['sync_frequency_minutes'] ?? 30,
      notifyOnAbnormalReadings: json['notify_on_abnormal_readings'] ?? true,
      notifyOnDeviceDisconnect: json['notify_on_device_disconnect'] ?? true,
      shareWithHealthcare: json['share_with_healthcare'] ?? false,
      enabledDeviceTypes: List<String>.from(json['enabled_device_types']),
      thresholds: json['thresholds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auto_sync': autoSync,
      'sync_frequency_minutes': syncFrequencyMinutes,
      'notify_on_abnormal_readings': notifyOnAbnormalReadings,
      'notify_on_device_disconnect': notifyOnDeviceDisconnect,
      'share_with_healthcare': shareWithHealthcare,
      'enabled_device_types': enabledDeviceTypes,
      'thresholds': thresholds,
    };
  }
}
