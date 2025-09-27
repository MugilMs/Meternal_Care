class LocalizationSettings {
  final String userId;
  final String languageCode;
  final String countryCode;
  final String locale;
  final bool useSystemLocale;
  final Map<String, String> customTranslations;
  final DateTime lastUpdated;

  LocalizationSettings({
    required this.userId,
    required this.languageCode,
    required this.countryCode,
    required this.locale,
    this.useSystemLocale = true,
    required this.customTranslations,
    required this.lastUpdated,
  });

  String get fullLocale => '${languageCode}_$countryCode';
  bool get isRTL => ['ar', 'he', 'fa', 'ur'].contains(languageCode);

  factory LocalizationSettings.fromJson(Map<String, dynamic> json) {
    return LocalizationSettings(
      userId: json['user_id'],
      languageCode: json['language_code'],
      countryCode: json['country_code'],
      locale: json['locale'],
      useSystemLocale: json['use_system_locale'] ?? true,
      customTranslations: Map<String, String>.from(json['custom_translations']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'language_code': languageCode,
      'country_code': countryCode,
      'locale': locale,
      'use_system_locale': useSystemLocale,
      'custom_translations': customTranslations,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class TranslationEntry {
  final String key;
  final String languageCode;
  final String value;
  final String? context;
  final String? description;
  final bool isPlural;
  final Map<String, String>? pluralForms;
  final DateTime lastUpdated;

  TranslationEntry({
    required this.key,
    required this.languageCode,
    required this.value,
    this.context,
    this.description,
    this.isPlural = false,
    this.pluralForms,
    required this.lastUpdated,
  });

  String getPlural(int count) {
    if (!isPlural || pluralForms == null) return value;
    
    if (count == 0 && pluralForms!.containsKey('zero')) {
      return pluralForms!['zero']!;
    } else if (count == 1 && pluralForms!.containsKey('one')) {
      return pluralForms!['one']!;
    } else if (pluralForms!.containsKey('other')) {
      return pluralForms!['other']!;
    }
    
    return value;
  }

  factory TranslationEntry.fromJson(Map<String, dynamic> json) {
    return TranslationEntry(
      key: json['key'],
      languageCode: json['language_code'],
      value: json['value'],
      context: json['context'],
      description: json['description'],
      isPlural: json['is_plural'] ?? false,
      pluralForms: json['plural_forms'] != null 
        ? Map<String, String>.from(json['plural_forms']) 
        : null,
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'language_code': languageCode,
      'value': value,
      'context': context,
      'description': description,
      'is_plural': isPlural,
      'plural_forms': pluralForms,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String countryCode;
  final bool isRTL;
  final double completionPercentage;
  final bool isActive;
  final DateTime lastUpdated;

  SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.countryCode,
    this.isRTL = false,
    this.completionPercentage = 100.0,
    this.isActive = true,
    required this.lastUpdated,
  });

  bool get isFullyTranslated => completionPercentage >= 100.0;
  bool get needsTranslation => completionPercentage < 90.0;

  factory SupportedLanguage.fromJson(Map<String, dynamic> json) {
    return SupportedLanguage(
      code: json['code'],
      name: json['name'],
      nativeName: json['native_name'],
      countryCode: json['country_code'],
      isRTL: json['is_rtl'] ?? false,
      completionPercentage: json['completion_percentage']?.toDouble() ?? 100.0,
      isActive: json['is_active'] ?? true,
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'native_name': nativeName,
      'country_code': countryCode,
      'is_rtl': isRTL,
      'completion_percentage': completionPercentage,
      'is_active': isActive,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class RegionalSettings {
  final String countryCode;
  final String currencyCode;
  final String currencySymbol;
  final String dateFormat;
  final String timeFormat;
  final String numberFormat;
  final String temperatureUnit;
  final String weightUnit;
  final String heightUnit;
  final Map<String, dynamic> culturalPreferences;

  RegionalSettings({
    required this.countryCode,
    required this.currencyCode,
    required this.currencySymbol,
    required this.dateFormat,
    required this.timeFormat,
    required this.numberFormat,
    this.temperatureUnit = 'celsius',
    this.weightUnit = 'kg',
    this.heightUnit = 'cm',
    required this.culturalPreferences,
  });

  bool get usesMetricSystem => weightUnit == 'kg' && heightUnit == 'cm';
  bool get uses24HourFormat => timeFormat.contains('HH');

  factory RegionalSettings.fromJson(Map<String, dynamic> json) {
    return RegionalSettings(
      countryCode: json['country_code'],
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      dateFormat: json['date_format'],
      timeFormat: json['time_format'],
      numberFormat: json['number_format'],
      temperatureUnit: json['temperature_unit'] ?? 'celsius',
      weightUnit: json['weight_unit'] ?? 'kg',
      heightUnit: json['height_unit'] ?? 'cm',
      culturalPreferences: json['cultural_preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'date_format': dateFormat,
      'time_format': timeFormat,
      'number_format': numberFormat,
      'temperature_unit': temperatureUnit,
      'weight_unit': weightUnit,
      'height_unit': heightUnit,
      'cultural_preferences': culturalPreferences,
    };
  }
}

class LocalizedContent {
  final String id;
  final String contentType;
  final String languageCode;
  final String title;
  final String content;
  final Map<String, String>? metadata;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isPublished;

  LocalizedContent({
    required this.id,
    required this.contentType,
    required this.languageCode,
    required this.title,
    required this.content,
    this.metadata,
    required this.createdAt,
    required this.lastUpdated,
    this.isPublished = true,
  });

  factory LocalizedContent.fromJson(Map<String, dynamic> json) {
    return LocalizedContent(
      id: json['id'],
      contentType: json['content_type'],
      languageCode: json['language_code'],
      title: json['title'],
      content: json['content'],
      metadata: json['metadata'] != null 
        ? Map<String, String>.from(json['metadata']) 
        : null,
      createdAt: DateTime.parse(json['created_at']),
      lastUpdated: DateTime.parse(json['last_updated']),
      isPublished: json['is_published'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_type': contentType,
      'language_code': languageCode,
      'title': title,
      'content': content,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated.toIso8601String(),
      'is_published': isPublished,
    };
  }
}

class CulturalAdaptation {
  final String countryCode;
  final Map<String, dynamic> pregnancyPractices;
  final Map<String, dynamic> dietaryRestrictions;
  final Map<String, dynamic> religiousConsiderations;
  final Map<String, dynamic> familyStructure;
  final List<String> commonConcerns;
  final Map<String, dynamic> healthcareSystem;

  CulturalAdaptation({
    required this.countryCode,
    required this.pregnancyPractices,
    required this.dietaryRestrictions,
    required this.religiousConsiderations,
    required this.familyStructure,
    required this.commonConcerns,
    required this.healthcareSystem,
  });

  factory CulturalAdaptation.fromJson(Map<String, dynamic> json) {
    return CulturalAdaptation(
      countryCode: json['country_code'],
      pregnancyPractices: json['pregnancy_practices'],
      dietaryRestrictions: json['dietary_restrictions'],
      religiousConsiderations: json['religious_considerations'],
      familyStructure: json['family_structure'],
      commonConcerns: List<String>.from(json['common_concerns']),
      healthcareSystem: json['healthcare_system'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'pregnancy_practices': pregnancyPractices,
      'dietary_restrictions': dietaryRestrictions,
      'religious_considerations': religiousConsiderations,
      'family_structure': familyStructure,
      'common_concerns': commonConcerns,
      'healthcare_system': healthcareSystem,
    };
  }
}
