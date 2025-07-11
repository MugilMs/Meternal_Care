class HealthTip {
  final int week;
  final String title;
  final String content;
  final String category;

  HealthTip({
    required this.week,
    required this.title,
    required this.content,
    required this.category,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      week: json['week'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'title': title,
      'content': content,
      'category': category,
    };
  }
}
