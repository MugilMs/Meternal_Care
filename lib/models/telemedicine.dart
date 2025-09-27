class TelemedicineAppointment {
  final String id;
  final String patientId;
  final String providerId;
  final DateTime scheduledTime;
  final Duration duration;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? meetingUrl;
  final String? meetingId;
  final String? notes;
  final List<String> symptoms;
  final Map<String, dynamic>? vitalSigns;
  final DateTime createdAt;
  final DateTime? completedAt;

  TelemedicineAppointment({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.scheduledTime,
    required this.duration,
    required this.type,
    required this.status,
    this.meetingUrl,
    this.meetingId,
    this.notes,
    required this.symptoms,
    this.vitalSigns,
    required this.createdAt,
    this.completedAt,
  });

  bool get isUpcoming => scheduledTime.isAfter(DateTime.now()) && status == AppointmentStatus.scheduled;
  bool get isActive => status == AppointmentStatus.inProgress;
  bool get isCompleted => status == AppointmentStatus.completed;

  factory TelemedicineAppointment.fromJson(Map<String, dynamic> json) {
    return TelemedicineAppointment(
      id: json['id'],
      patientId: json['patient_id'],
      providerId: json['provider_id'],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      duration: Duration(minutes: json['duration_minutes']),
      type: AppointmentType.values[json['type']],
      status: AppointmentStatus.values[json['status']],
      meetingUrl: json['meeting_url'],
      meetingId: json['meeting_id'],
      notes: json['notes'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      vitalSigns: json['vital_signs'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'provider_id': providerId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'duration_minutes': duration.inMinutes,
      'type': type.index,
      'status': status.index,
      'meeting_url': meetingUrl,
      'meeting_id': meetingId,
      'notes': notes,
      'symptoms': symptoms,
      'vital_signs': vitalSigns,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

enum AppointmentType {
  consultation,
  followUp,
  emergency,
  prenatalCheckup,
  mentalHealth,
  nutrition,
  lactation
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow
}

class HealthcareProvider {
  final String id;
  final String name;
  final String title;
  final String specialty;
  final String bio;
  final String imageUrl;
  final List<String> credentials;
  final List<String> languages;
  final double rating;
  final int totalConsultations;
  final bool isAvailable;
  final List<AvailabilitySlot> availability;
  final ConsultationRates rates;

  HealthcareProvider({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.imageUrl,
    required this.credentials,
    required this.languages,
    this.rating = 0.0,
    this.totalConsultations = 0,
    this.isAvailable = true,
    required this.availability,
    required this.rates,
  });

  factory HealthcareProvider.fromJson(Map<String, dynamic> json) {
    return HealthcareProvider(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      specialty: json['specialty'],
      bio: json['bio'],
      imageUrl: json['image_url'],
      credentials: List<String>.from(json['credentials']),
      languages: List<String>.from(json['languages']),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalConsultations: json['total_consultations'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      availability: (json['availability'] as List)
          .map((slot) => AvailabilitySlot.fromJson(slot))
          .toList(),
      rates: ConsultationRates.fromJson(json['rates']),
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
      'languages': languages,
      'rating': rating,
      'total_consultations': totalConsultations,
      'is_available': isAvailable,
      'availability': availability.map((slot) => slot.toJson()).toList(),
      'rates': rates.toJson(),
    };
  }
}

class AvailabilitySlot {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isAvailable;

  AvailabilitySlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      dayOfWeek: json['day_of_week'],
      startTime: TimeOfDay(
        hour: json['start_hour'],
        minute: json['start_minute'],
      ),
      endTime: TimeOfDay(
        hour: json['end_hour'],
        minute: json['end_minute'],
      ),
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'start_hour': startTime.hour,
      'start_minute': startTime.minute,
      'end_hour': endTime.hour,
      'end_minute': endTime.minute,
      'is_available': isAvailable,
    };
  }
}

class ConsultationRates {
  final double consultation;
  final double followUp;
  final double emergency;
  final String currency;

  ConsultationRates({
    required this.consultation,
    required this.followUp,
    required this.emergency,
    this.currency = 'USD',
  });

  factory ConsultationRates.fromJson(Map<String, dynamic> json) {
    return ConsultationRates(
      consultation: json['consultation'].toDouble(),
      followUp: json['follow_up'].toDouble(),
      emergency: json['emergency'].toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultation': consultation,
      'follow_up': followUp,
      'emergency': emergency,
      'currency': currency,
    };
  }
}

class DigitalPrescription {
  final String id;
  final String appointmentId;
  final String providerId;
  final String patientId;
  final List<Medication> medications;
  final String instructions;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final PrescriptionStatus status;

  DigitalPrescription({
    required this.id,
    required this.appointmentId,
    required this.providerId,
    required this.patientId,
    required this.medications,
    required this.instructions,
    required this.issuedAt,
    this.expiresAt,
    required this.status,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isActive => status == PrescriptionStatus.active && !isExpired;

  factory DigitalPrescription.fromJson(Map<String, dynamic> json) {
    return DigitalPrescription(
      id: json['id'],
      appointmentId: json['appointment_id'],
      providerId: json['provider_id'],
      patientId: json['patient_id'],
      medications: (json['medications'] as List)
          .map((med) => Medication.fromJson(med))
          .toList(),
      instructions: json['instructions'],
      issuedAt: DateTime.parse(json['issued_at']),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      status: PrescriptionStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'provider_id': providerId,
      'patient_id': patientId,
      'medications': medications.map((med) => med.toJson()).toList(),
      'instructions': instructions,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status.index,
    };
  }
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final bool isPregnancySafe;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    this.isPregnancySafe = true,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
      isPregnancySafe: json['is_pregnancy_safe'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'is_pregnancy_safe': isPregnancySafe,
    };
  }
}

enum PrescriptionStatus { active, completed, cancelled, expired }

class LabResult {
  final String id;
  final String patientId;
  final String providerId;
  final String testName;
  final String category;
  final Map<String, dynamic> results;
  final String? interpretation;
  final DateTime collectedAt;
  final DateTime reportedAt;
  final LabStatus status;
  final String? notes;

  LabResult({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.testName,
    required this.category,
    required this.results,
    this.interpretation,
    required this.collectedAt,
    required this.reportedAt,
    required this.status,
    this.notes,
  });

  bool get isNormal => status == LabStatus.normal;
  bool get requiresAttention => status == LabStatus.abnormal || status == LabStatus.critical;

  factory LabResult.fromJson(Map<String, dynamic> json) {
    return LabResult(
      id: json['id'],
      patientId: json['patient_id'],
      providerId: json['provider_id'],
      testName: json['test_name'],
      category: json['category'],
      results: json['results'],
      interpretation: json['interpretation'],
      collectedAt: DateTime.parse(json['collected_at']),
      reportedAt: DateTime.parse(json['reported_at']),
      status: LabStatus.values[json['status']],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'provider_id': providerId,
      'test_name': testName,
      'category': category,
      'results': results,
      'interpretation': interpretation,
      'collected_at': collectedAt.toIso8601String(),
      'reported_at': reportedAt.toIso8601String(),
      'status': status.index,
      'notes': notes,
    };
  }
}

enum LabStatus { pending, normal, abnormal, critical }

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
