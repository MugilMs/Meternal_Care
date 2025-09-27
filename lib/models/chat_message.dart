import 'package:flutter/material.dart';

enum MessageType { user, bot, system }
enum MessageCategory { general, medical, nutrition, exercise, emergency }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final MessageCategory category;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;
  final List<QuickReply>? quickReplies;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
    this.quickReplies,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      type: MessageType.values[json['type']],
      category: MessageCategory.values[json['category']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      metadata: json['metadata'],
      quickReplies: json['quick_replies'] != null
          ? (json['quick_replies'] as List)
              .map((reply) => QuickReply.fromJson(reply))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.index,
      'category': category.index,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'metadata': metadata,
      'quick_replies': quickReplies?.map((reply) => reply.toJson()).toList(),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    MessageCategory? category,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? metadata,
    List<QuickReply>? quickReplies,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
      quickReplies: quickReplies ?? this.quickReplies,
    );
  }
}

class QuickReply {
  final String id;
  final String text;
  final String? action;
  final Map<String, dynamic>? data;

  QuickReply({
    required this.id,
    required this.text,
    this.action,
    this.data,
  });

  factory QuickReply.fromJson(Map<String, dynamic> json) {
    return QuickReply(
      id: json['id'],
      text: json['text'],
      action: json['action'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'action': action,
      'data': data,
    };
  }
}

class ChatSession {
  final String id;
  final List<ChatMessage> messages;
  final DateTime startTime;
  final DateTime? endTime;
  final MessageCategory primaryCategory;
  final bool isActive;

  ChatSession({
    required this.id,
    required this.messages,
    required this.startTime,
    this.endTime,
    required this.primaryCategory,
    this.isActive = true,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  int get messageCount => messages.length;

  ChatMessage? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  List<ChatMessage> get unreadMessages {
    return messages.where((message) => !message.isRead && message.type == MessageType.bot).toList();
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      messages: (json['messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      primaryCategory: MessageCategory.values[json['primary_category']],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'primary_category': primaryCategory.index,
      'is_active': isActive,
    };
  }
}
