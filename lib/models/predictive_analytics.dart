class PredictiveModel {
  final String id;
  final String name;
  final ModelType type;
  final String description;
  final double accuracy;
  final DateTime lastTrained;
  final Map<String, dynamic> parameters;
  final List<String> inputFeatures;
  final String outputTarget;
  final bool isActive;

  PredictiveModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.accuracy,
    required this.lastTrained,
    required this.parameters,
    required this.inputFeatures,
    required this.outputTarget,
    this.isActive = true,
  });

  bool get isHighAccuracy => accuracy >= 0.85;
  bool get needsRetraining => DateTime.now().difference(lastTrained).inDays > 30;

  factory PredictiveModel.fromJson(Map<String, dynamic> json) {
    return PredictiveModel(
      id: json['id'],
      name: json['name'],
      type: ModelType.values[json['type']],
      description: json['description'],
      accuracy: json['accuracy'].toDouble(),
      lastTrained: DateTime.parse(json['last_trained']),
      parameters: json['parameters'],
      inputFeatures: List<String>.from(json['input_features']),
      outputTarget: json['output_target'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'description': description,
      'accuracy': accuracy,
      'last_trained': lastTrained.toIso8601String(),
      'parameters': parameters,
      'input_features': inputFeatures,
      'output_target': outputTarget,
      'is_active': isActive,
    };
  }
}

enum ModelType {
  laborPrediction,
  complicationRisk,
  postpartumDepression,
  gestationalDiabetes,
  preeclampsia,
  birthWeight,
  deliveryMethod,
  pregnancyDuration
}

class Prediction {
  final String id;
  final String userId;
  final String modelId;
  final PredictionType type;
  final double probability;
  final double confidence;
  final Map<String, dynamic> inputData;
  final Map<String, dynamic> result;
  final DateTime createdAt;
  final DateTime? validUntil;
  final List<String> recommendations;
  final RiskLevel riskLevel;

  Prediction({
    required this.id,
    required this.userId,
    required this.modelId,
    required this.type,
    required this.probability,
    required this.confidence,
    required this.inputData,
    required this.result,
    required this.createdAt,
    this.validUntil,
    required this.recommendations,
    required this.riskLevel,
  });

  bool get isHighConfidence => confidence >= 0.8;
  bool get isExpired => validUntil != null && DateTime.now().isAfter(validUntil!);
  bool get isHighRisk => riskLevel == RiskLevel.high || riskLevel == RiskLevel.critical;

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'],
      userId: json['user_id'],
      modelId: json['model_id'],
      type: PredictionType.values[json['type']],
      probability: json['probability'].toDouble(),
      confidence: json['confidence'].toDouble(),
      inputData: json['input_data'],
      result: json['result'],
      createdAt: DateTime.parse(json['created_at']),
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
      recommendations: List<String>.from(json['recommendations']),
      riskLevel: RiskLevel.values[json['risk_level']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'model_id': modelId,
      'type': type.index,
      'probability': probability,
      'confidence': confidence,
      'input_data': inputData,
      'result': result,
      'created_at': createdAt.toIso8601String(),
      'valid_until': validUntil?.toIso8601String(),
      'recommendations': recommendations,
      'risk_level': riskLevel.index,
    };
  }
}

enum PredictionType {
  laborOnset,
  complicationRisk,
  birthWeight,
  deliveryComplications,
  postpartumRisk,
  gestationalDiabetes,
  preeclampsia,
  pretermBirth
}

enum RiskLevel { low, moderate, high, critical }

class AnalyticsInsight {
  final String id;
  final String userId;
  final InsightType type;
  final String title;
  final String description;
  final Map<String, dynamic> data;
  final double relevanceScore;
  final DateTime generatedAt;
  final DateTime? expiresAt;
  final bool isActionable;
  final List<String> suggestedActions;

  AnalyticsInsight({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.data,
    required this.relevanceScore,
    required this.generatedAt,
    this.expiresAt,
    this.isActionable = false,
    required this.suggestedActions,
  });

  bool get isHighRelevance => relevanceScore >= 0.7;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory AnalyticsInsight.fromJson(Map<String, dynamic> json) {
    return AnalyticsInsight(
      id: json['id'],
      userId: json['user_id'],
      type: InsightType.values[json['type']],
      title: json['title'],
      description: json['description'],
      data: json['data'],
      relevanceScore: json['relevance_score'].toDouble(),
      generatedAt: DateTime.parse(json['generated_at']),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      isActionable: json['is_actionable'] ?? false,
      suggestedActions: List<String>.from(json['suggested_actions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'title': title,
      'description': description,
      'data': data,
      'relevance_score': relevanceScore,
      'generated_at': generatedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_actionable': isActionable,
      'suggested_actions': suggestedActions,
    };
  }
}

enum InsightType {
  healthTrend,
  riskFactor,
  behaviorPattern,
  recommendation,
  milestone,
  anomaly,
  optimization
}

class TrendAnalysis {
  final String id;
  final String userId;
  final String metric;
  final List<DataPoint> dataPoints;
  final TrendDirection direction;
  final double slope;
  final double correlation;
  final DateTime analysisDate;
  final Map<String, dynamic> statistics;

  TrendAnalysis({
    required this.id,
    required this.userId,
    required this.metric,
    required this.dataPoints,
    required this.direction,
    required this.slope,
    required this.correlation,
    required this.analysisDate,
    required this.statistics,
  });

  bool get isSignificantTrend => correlation.abs() >= 0.5;
  bool get isPositiveTrend => direction == TrendDirection.increasing;
  bool get isStableTrend => direction == TrendDirection.stable;

  factory TrendAnalysis.fromJson(Map<String, dynamic> json) {
    return TrendAnalysis(
      id: json['id'],
      userId: json['user_id'],
      metric: json['metric'],
      dataPoints: (json['data_points'] as List)
          .map((point) => DataPoint.fromJson(point))
          .toList(),
      direction: TrendDirection.values[json['direction']],
      slope: json['slope'].toDouble(),
      correlation: json['correlation'].toDouble(),
      analysisDate: DateTime.parse(json['analysis_date']),
      statistics: json['statistics'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'metric': metric,
      'data_points': dataPoints.map((point) => point.toJson()).toList(),
      'direction': direction.index,
      'slope': slope,
      'correlation': correlation,
      'analysis_date': analysisDate.toIso8601String(),
      'statistics': statistics,
    };
  }
}

enum TrendDirection { increasing, decreasing, stable, volatile }

class DataPoint {
  final DateTime timestamp;
  final double value;
  final Map<String, dynamic>? metadata;

  DataPoint({
    required this.timestamp,
    required this.value,
    this.metadata,
  });

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value'].toDouble(),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'metadata': metadata,
    };
  }
}

class RiskAssessment {
  final String id;
  final String userId;
  final AssessmentType type;
  final Map<String, double> riskFactors;
  final double overallRiskScore;
  final RiskLevel riskLevel;
  final List<String> identifiedRisks;
  final List<String> mitigationStrategies;
  final DateTime assessmentDate;
  final DateTime? nextAssessmentDue;

  RiskAssessment({
    required this.id,
    required this.userId,
    required this.type,
    required this.riskFactors,
    required this.overallRiskScore,
    required this.riskLevel,
    required this.identifiedRisks,
    required this.mitigationStrategies,
    required this.assessmentDate,
    this.nextAssessmentDue,
  });

  bool get needsImmediateAttention => riskLevel == RiskLevel.critical;
  bool get isOverdue => nextAssessmentDue != null && DateTime.now().isAfter(nextAssessmentDue!);

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    return RiskAssessment(
      id: json['id'],
      userId: json['user_id'],
      type: AssessmentType.values[json['type']],
      riskFactors: Map<String, double>.from(
        json['risk_factors'].map((key, value) => MapEntry(key, value.toDouble())),
      ),
      overallRiskScore: json['overall_risk_score'].toDouble(),
      riskLevel: RiskLevel.values[json['risk_level']],
      identifiedRisks: List<String>.from(json['identified_risks']),
      mitigationStrategies: List<String>.from(json['mitigation_strategies']),
      assessmentDate: DateTime.parse(json['assessment_date']),
      nextAssessmentDue: json['next_assessment_due'] != null 
        ? DateTime.parse(json['next_assessment_due']) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.index,
      'risk_factors': riskFactors,
      'overall_risk_score': overallRiskScore,
      'risk_level': riskLevel.index,
      'identified_risks': identifiedRisks,
      'mitigation_strategies': mitigationStrategies,
      'assessment_date': assessmentDate.toIso8601String(),
      'next_assessment_due': nextAssessmentDue?.toIso8601String(),
    };
  }
}

enum AssessmentType {
  comprehensive,
  gestationalDiabetes,
  preeclampsia,
  pretermLabor,
  postpartumDepression,
  fetal,
  maternal
}
