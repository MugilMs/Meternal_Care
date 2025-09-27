import 'dart:async';
import 'dart:math';
import '../models/chat_message.dart';

class AIChatbotService {
  static final AIChatbotService _instance = AIChatbotService._internal();
  factory AIChatbotService() => _instance;
  AIChatbotService._internal();

  final List<ChatSession> _sessions = [];
  final StreamController<ChatMessage> _messageController = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get messageStream => _messageController.stream;

  // Pregnancy knowledge base
  static const Map<String, List<String>> _knowledgeBase = {
    'morning_sickness': [
      'Morning sickness is common in early pregnancy. Try eating small, frequent meals and avoid triggers.',
      'Ginger tea or ginger candies can help reduce nausea. Stay hydrated with small sips of water.',
      'If you can\'t keep food down for 24 hours, contact your healthcare provider.',
    ],
    'weight_gain': [
      'Healthy weight gain during pregnancy is typically 25-35 pounds for normal BMI.',
      'Focus on nutrient-dense foods rather than "eating for two" in terms of calories.',
      'Your healthcare provider will monitor your weight gain at each appointment.',
    ],
    'baby_movement': [
      'You should feel baby movements regularly after 28 weeks. Count kicks daily.',
      'If you notice decreased movement, try drinking cold water and lying on your side.',
      'Contact your doctor if you don\'t feel 10 movements in 2 hours after 28 weeks.',
    ],
    'exercise': [
      'Regular exercise during pregnancy is beneficial. Aim for 30 minutes of moderate activity most days.',
      'Safe exercises include walking, swimming, prenatal yoga, and stationary cycling.',
      'Avoid contact sports, activities with fall risk, and lying flat on your back after first trimester.',
    ],
    'nutrition': [
      'Take prenatal vitamins with folic acid. Eat a variety of fruits, vegetables, and lean proteins.',
      'Avoid raw fish, unpasteurized dairy, and limit caffeine to 200mg per day.',
      'Stay hydrated with 8-10 glasses of water daily.',
    ],
    'sleep': [
      'Sleep on your side, preferably left side, to improve blood flow to baby.',
      'Use pregnancy pillows for support. Avoid sleeping on your back after 20 weeks.',
      'If you have trouble sleeping, try relaxation techniques or talk to your doctor.',
    ],
    'warning_signs': [
      'Contact your doctor immediately for severe headaches, vision changes, or severe swelling.',
      'Heavy bleeding, severe abdominal pain, or persistent vomiting require immediate attention.',
      'Decreased baby movement after 28 weeks is a reason to call your healthcare provider.',
    ],
  };

  static const List<String> _greetings = [
    'Hello! I\'m your pregnancy companion. How can I help you today?',
    'Hi there! I\'m here to support you through your pregnancy journey. What would you like to know?',
    'Welcome! I\'m your AI pregnancy assistant. Feel free to ask me anything about your pregnancy.',
  ];

  static final List<QuickReply> _commonQuickReplies = [
    QuickReply(id: '1', text: 'Morning sickness tips', action: 'query', data: {'topic': 'morning_sickness'}),
    QuickReply(id: '2', text: 'Exercise guidelines', action: 'query', data: {'topic': 'exercise'}),
    QuickReply(id: '3', text: 'Nutrition advice', action: 'query', data: {'topic': 'nutrition'}),
    QuickReply(id: '4', text: 'Baby movement', action: 'query', data: {'topic': 'baby_movement'}),
    QuickReply(id: '5', text: 'Warning signs', action: 'query', data: {'topic': 'warning_signs'}),
  ];

  Future<ChatMessage> sendMessage(String content, MessageCategory category) async {
    final userMessage = ChatMessage(
      id: _generateId(),
      content: content,
      type: MessageType.user,
      category: category,
      timestamp: DateTime.now(),
    );

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 500));

    final botResponse = await _generateResponse(content, category);
    
    _messageController.add(userMessage);
    _messageController.add(botResponse);

    return botResponse;
  }

  Future<ChatMessage> _generateResponse(String userInput, MessageCategory category) async {
    // Simulate AI processing time
    await Future.delayed(const Duration(milliseconds: 1000));

    String response;
    List<QuickReply>? quickReplies;

    // Simple keyword matching for demo - in production, use actual AI/NLP
    final input = userInput.toLowerCase();

    if (_containsKeywords(input, ['hello', 'hi', 'hey', 'start'])) {
      response = _greetings[Random().nextInt(_greetings.length)];
      quickReplies = List.from(_commonQuickReplies);
    } else if (_containsKeywords(input, ['nausea', 'morning sickness', 'sick', 'vomit'])) {
      response = _getRandomResponse('morning_sickness');
      quickReplies = [
        QuickReply(id: 'ms1', text: 'More nausea tips', action: 'query', data: {'topic': 'morning_sickness'}),
        QuickReply(id: 'ms2', text: 'When to call doctor', action: 'query', data: {'topic': 'warning_signs'}),
      ];
    } else if (_containsKeywords(input, ['weight', 'gain', 'pounds', 'eating'])) {
      response = _getRandomResponse('weight_gain');
      quickReplies = [
        QuickReply(id: 'wg1', text: 'Nutrition tips', action: 'query', data: {'topic': 'nutrition'}),
        QuickReply(id: 'wg2', text: 'Exercise advice', action: 'query', data: {'topic': 'exercise'}),
      ];
    } else if (_containsKeywords(input, ['baby', 'movement', 'kick', 'moving'])) {
      response = _getRandomResponse('baby_movement');
      quickReplies = [
        QuickReply(id: 'bm1', text: 'Kick counting', action: 'navigate', data: {'screen': 'kick_counter'}),
        QuickReply(id: 'bm2', text: 'Warning signs', action: 'query', data: {'topic': 'warning_signs'}),
      ];
    } else if (_containsKeywords(input, ['exercise', 'workout', 'fitness', 'activity'])) {
      response = _getRandomResponse('exercise');
      quickReplies = [
        QuickReply(id: 'ex1', text: 'Safe exercises', action: 'query', data: {'topic': 'exercise'}),
        QuickReply(id: 'ex2', text: 'Prenatal yoga', action: 'navigate', data: {'screen': 'wellness'}),
      ];
    } else if (_containsKeywords(input, ['food', 'eat', 'nutrition', 'diet', 'vitamin'])) {
      response = _getRandomResponse('nutrition');
      quickReplies = [
        QuickReply(id: 'nu1', text: 'Foods to avoid', action: 'query', data: {'topic': 'nutrition'}),
        QuickReply(id: 'nu2', text: 'Meal planning', action: 'navigate', data: {'screen': 'nutrition'}),
      ];
    } else if (_containsKeywords(input, ['sleep', 'tired', 'rest', 'insomnia'])) {
      response = _getRandomResponse('sleep');
      quickReplies = [
        QuickReply(id: 'sl1', text: 'Sleep positions', action: 'query', data: {'topic': 'sleep'}),
        QuickReply(id: 'sl2', text: 'Relaxation techniques', action: 'navigate', data: {'screen': 'wellness'}),
      ];
    } else if (_containsKeywords(input, ['pain', 'bleeding', 'headache', 'emergency', 'worried'])) {
      response = _getRandomResponse('warning_signs');
      quickReplies = [
        QuickReply(id: 'ws1', text: 'Emergency contacts', action: 'navigate', data: {'screen': 'emergency'}),
        QuickReply(id: 'ws2', text: 'Call doctor now', action: 'call', data: {'number': 'doctor'}),
      ];
    } else if (_containsKeywords(input, ['appointment', 'doctor', 'visit', 'schedule'])) {
      response = 'I can help you manage your appointments! You can schedule, view, or modify your prenatal appointments through the app.';
      quickReplies = [
        QuickReply(id: 'ap1', text: 'Schedule appointment', action: 'navigate', data: {'screen': 'schedule_appointment'}),
        QuickReply(id: 'ap2', text: 'View appointments', action: 'navigate', data: {'screen': 'appointments'}),
      ];
    } else if (_containsKeywords(input, ['week', 'trimester', 'due date', 'development'])) {
      response = 'Every week brings new developments for your baby! Check your dashboard for weekly updates and milestones.';
      quickReplies = [
        QuickReply(id: 'dev1', text: 'Baby development', action: 'navigate', data: {'screen': 'baby_tracker'}),
        QuickReply(id: 'dev2', text: 'Weekly tips', action: 'navigate', data: {'screen': 'dashboard'}),
      ];
    } else {
      response = _getGeneralResponse(input);
      quickReplies = List.from(_commonQuickReplies.take(3));
    }

    return ChatMessage(
      id: _generateId(),
      content: response,
      type: MessageType.bot,
      category: category,
      timestamp: DateTime.now(),
      quickReplies: quickReplies,
    );
  }

  bool _containsKeywords(String input, List<String> keywords) {
    return keywords.any((keyword) => input.contains(keyword));
  }

  String _getRandomResponse(String topic) {
    final responses = _knowledgeBase[topic] ?? ['I\'m here to help with your pregnancy questions.'];
    return responses[Random().nextInt(responses.length)];
  }

  String _getGeneralResponse(String input) {
    const responses = [
      'That\'s a great question! While I can provide general pregnancy information, please consult your healthcare provider for personalized medical advice.',
      'I understand your concern. For specific medical questions, it\'s always best to speak with your doctor or midwife.',
      'Every pregnancy is unique. I can share general information, but your healthcare provider knows your specific situation best.',
      'I\'m here to support you! For detailed medical advice, please reach out to your healthcare team.',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  List<QuickReply> getContextualQuickReplies(MessageCategory category) {
    switch (category) {
      case MessageCategory.medical:
        return [
          QuickReply(id: 'med1', text: 'Symptoms tracker', action: 'navigate', data: {'screen': 'health_tracking'}),
          QuickReply(id: 'med2', text: 'Warning signs', action: 'query', data: {'topic': 'warning_signs'}),
          QuickReply(id: 'med3', text: 'Call doctor', action: 'call', data: {'number': 'doctor'}),
        ];
      case MessageCategory.nutrition:
        return [
          QuickReply(id: 'nut1', text: 'Meal planning', action: 'navigate', data: {'screen': 'nutrition'}),
          QuickReply(id: 'nut2', text: 'Foods to avoid', action: 'query', data: {'topic': 'nutrition'}),
          QuickReply(id: 'nut3', text: 'Prenatal vitamins', action: 'query', data: {'topic': 'nutrition'}),
        ];
      case MessageCategory.exercise:
        return [
          QuickReply(id: 'ex1', text: 'Safe exercises', action: 'query', data: {'topic': 'exercise'}),
          QuickReply(id: 'ex2', text: 'Prenatal yoga', action: 'navigate', data: {'screen': 'wellness'}),
          QuickReply(id: 'ex3', text: 'Activity tracker', action: 'navigate', data: {'screen': 'health_tracking'}),
        ];
      case MessageCategory.emergency:
        return [
          QuickReply(id: 'em1', text: 'Emergency contacts', action: 'navigate', data: {'screen': 'emergency'}),
          QuickReply(id: 'em2', text: 'Call 911', action: 'call', data: {'number': '911'}),
          QuickReply(id: 'em3', text: 'Hospital directions', action: 'navigate', data: {'screen': 'hospitals'}),
        ];
      default:
        return List.from(_commonQuickReplies);
    }
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void dispose() {
    _messageController.close();
  }

  // Risk assessment based on symptoms and user input
  Map<String, dynamic> assessRisk(List<String> symptoms, Map<String, dynamic> userProfile) {
    int riskScore = 0;
    List<String> concerns = [];
    List<String> recommendations = [];

    // High-risk symptoms
    final highRiskSymptoms = ['severe headache', 'vision changes', 'heavy bleeding', 'severe pain'];
    final mediumRiskSymptoms = ['persistent vomiting', 'decreased movement', 'swelling'];
    final lowRiskSymptoms = ['mild nausea', 'fatigue', 'back pain'];

    for (final symptom in symptoms) {
      if (highRiskSymptoms.any((hrs) => symptom.toLowerCase().contains(hrs))) {
        riskScore += 3;
        concerns.add('High-risk symptom detected: $symptom');
        recommendations.add('Contact your healthcare provider immediately');
      } else if (mediumRiskSymptoms.any((mrs) => symptom.toLowerCase().contains(mrs))) {
        riskScore += 2;
        concerns.add('Monitor symptom: $symptom');
        recommendations.add('Consider calling your healthcare provider');
      } else if (lowRiskSymptoms.any((lrs) => symptom.toLowerCase().contains(lrs))) {
        riskScore += 1;
        recommendations.add('Normal pregnancy symptom: $symptom');
      }
    }

    String riskLevel;
    if (riskScore >= 6) {
      riskLevel = 'HIGH';
    } else if (riskScore >= 3) {
      riskLevel = 'MEDIUM';
    } else {
      riskLevel = 'LOW';
    }

    return {
      'risk_level': riskLevel,
      'risk_score': riskScore,
      'concerns': concerns,
      'recommendations': recommendations,
      'should_contact_doctor': riskScore >= 3,
      'is_emergency': riskScore >= 6,
    };
  }
}
