class OfflineData {
  final String id;
  final String userId;
  final DataType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? lastModified;
  final bool isSynced;
  final SyncPriority priority;
  final int retryCount;

  OfflineData({
    required this.id,
    required this.userId,
    required this.type,
    required this.data,
    required this.createdAt,
    this.lastModified,
    this.isSynced = false,
    this.priority = SyncPriority.normal,
    this.retryCount = 0,
  });

  bool get needsSync => !isSynced;
  bool get isStale => DateTime.now().difference(lastModified ?? createdAt).inDays > 7;
  bool get hasFailedSync => retryCount > 3;

  factory OfflineData.fromJson(Map<String, dynamic> json) {
    return OfflineData(
      id: json['id'],
      userId: json['user_id'],
      type: DataType.values[json['type']],
      data: json['data'],
      createdAt: DateTime.parse(json['created_at']),
      lastModified: json['last_modified'] != null ? DateTime.parse(json['last_modified']) : null,
      isSynced: json['is_synced'] ?? false,
      priority: SyncPriority.values[json['priority'] ?? 1],
      retryCount: json['retry_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'last_modified': lastModified?.toIso8601String(),
      'is_synced': isSynced,
      'priority': priority.index,
      'retry_count': retryCount,
    };
  }

  OfflineData copyWith({
    String? id,
    String? userId,
    DataType? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isSynced,
    SyncPriority? priority,
    int? retryCount,
  }) {
    return OfflineData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isSynced: isSynced ?? this.isSynced,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

enum DataType {
  healthTracking,
  symptomLog,
  appointment,
  communityPost,
  chatMessage,
  weightEntry,
  kickCount,
  meditation,
  photo,
  userPreferences
}

enum SyncPriority { low, normal, high, critical }

class OfflineCache {
  final String userId;
  final Map<String, CachedContent> content;
  final DateTime lastCacheUpdate;
  final int maxCacheSize;
  final int currentCacheSize;

  OfflineCache({
    required this.userId,
    required this.content,
    required this.lastCacheUpdate,
    this.maxCacheSize = 100, // MB
    required this.currentCacheSize,
  });

  bool get isCacheFull => currentCacheSize >= maxCacheSize;
  double get cacheUsagePercentage => (currentCacheSize / maxCacheSize * 100).clamp(0, 100);
  bool get needsCacheCleanup => cacheUsagePercentage > 80;

  factory OfflineCache.fromJson(Map<String, dynamic> json) {
    return OfflineCache(
      userId: json['user_id'],
      content: Map<String, CachedContent>.from(
        json['content'].map((key, value) => MapEntry(key, CachedContent.fromJson(value))),
      ),
      lastCacheUpdate: DateTime.parse(json['last_cache_update']),
      maxCacheSize: json['max_cache_size'] ?? 100,
      currentCacheSize: json['current_cache_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'content': content.map((key, value) => MapEntry(key, value.toJson())),
      'last_cache_update': lastCacheUpdate.toIso8601String(),
      'max_cache_size': maxCacheSize,
      'current_cache_size': currentCacheSize,
    };
  }
}

class CachedContent {
  final String id;
  final ContentType type;
  final Map<String, dynamic> data;
  final DateTime cachedAt;
  final DateTime expiresAt;
  final int accessCount;
  final DateTime lastAccessed;
  final int sizeBytes;

  CachedContent({
    required this.id,
    required this.type,
    required this.data,
    required this.cachedAt,
    required this.expiresAt,
    this.accessCount = 0,
    required this.lastAccessed,
    required this.sizeBytes,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isStale => DateTime.now().difference(lastAccessed).inDays > 3;
  double get sizeMB => sizeBytes / (1024 * 1024);

  factory CachedContent.fromJson(Map<String, dynamic> json) {
    return CachedContent(
      id: json['id'],
      type: ContentType.values[json['type']],
      data: json['data'],
      cachedAt: DateTime.parse(json['cached_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      accessCount: json['access_count'] ?? 0,
      lastAccessed: DateTime.parse(json['last_accessed']),
      sizeBytes: json['size_bytes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'data': data,
      'cached_at': cachedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'access_count': accessCount,
      'last_accessed': lastAccessed.toIso8601String(),
      'size_bytes': sizeBytes,
    };
  }
}

enum ContentType {
  healthTips,
  babyDevelopment,
  exerciseVideos,
  meditationAudio,
  communityPosts,
  expertAnswers,
  productCatalog,
  userProfile
}

class SyncQueue {
  final List<OfflineData> pendingItems;
  final List<OfflineData> failedItems;
  final DateTime lastSyncAttempt;
  final bool isSyncing;
  final SyncStatus status;

  SyncQueue({
    required this.pendingItems,
    required this.failedItems,
    required this.lastSyncAttempt,
    this.isSyncing = false,
    required this.status,
  });

  int get totalPendingItems => pendingItems.length;
  int get totalFailedItems => failedItems.length;
  int get highPriorityItems => pendingItems.where((item) => item.priority == SyncPriority.high || item.priority == SyncPriority.critical).length;
  bool get hasFailedItems => failedItems.isNotEmpty;

  factory SyncQueue.fromJson(Map<String, dynamic> json) {
    return SyncQueue(
      pendingItems: (json['pending_items'] as List)
          .map((item) => OfflineData.fromJson(item))
          .toList(),
      failedItems: (json['failed_items'] as List)
          .map((item) => OfflineData.fromJson(item))
          .toList(),
      lastSyncAttempt: DateTime.parse(json['last_sync_attempt']),
      isSyncing: json['is_syncing'] ?? false,
      status: SyncStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending_items': pendingItems.map((item) => item.toJson()).toList(),
      'failed_items': failedItems.map((item) => item.toJson()).toList(),
      'last_sync_attempt': lastSyncAttempt.toIso8601String(),
      'is_syncing': isSyncing,
      'status': status.index,
    };
  }
}

enum SyncStatus { idle, syncing, completed, failed, paused }

class OfflineSettings {
  final bool enableOfflineMode;
  final bool autoSyncWhenOnline;
  final bool syncOnWifiOnly;
  final int maxOfflineStorageMB;
  final int syncRetryAttempts;
  final Duration syncRetryDelay;
  final List<DataType> priorityDataTypes;
  final bool compressOfflineData;

  OfflineSettings({
    this.enableOfflineMode = true,
    this.autoSyncWhenOnline = true,
    this.syncOnWifiOnly = true,
    this.maxOfflineStorageMB = 500,
    this.syncRetryAttempts = 3,
    this.syncRetryDelay = const Duration(minutes: 5),
    required this.priorityDataTypes,
    this.compressOfflineData = true,
  });

  factory OfflineSettings.fromJson(Map<String, dynamic> json) {
    return OfflineSettings(
      enableOfflineMode: json['enable_offline_mode'] ?? true,
      autoSyncWhenOnline: json['auto_sync_when_online'] ?? true,
      syncOnWifiOnly: json['sync_on_wifi_only'] ?? true,
      maxOfflineStorageMB: json['max_offline_storage_mb'] ?? 500,
      syncRetryAttempts: json['sync_retry_attempts'] ?? 3,
      syncRetryDelay: Duration(milliseconds: json['sync_retry_delay_ms'] ?? 300000),
      priorityDataTypes: (json['priority_data_types'] as List)
          .map((type) => DataType.values[type])
          .toList(),
      compressOfflineData: json['compress_offline_data'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_offline_mode': enableOfflineMode,
      'auto_sync_when_online': autoSyncWhenOnline,
      'sync_on_wifi_only': syncOnWifiOnly,
      'max_offline_storage_mb': maxOfflineStorageMB,
      'sync_retry_attempts': syncRetryAttempts,
      'sync_retry_delay_ms': syncRetryDelay.inMilliseconds,
      'priority_data_types': priorityDataTypes.map((type) => type.index).toList(),
      'compress_offline_data': compressOfflineData,
    };
  }
}
