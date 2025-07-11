class User {
  final String name;
  final int currentWeek;
  final String dueDate;
  final String profileImage;

  User({
    required this.name,
    required this.currentWeek,
    required this.dueDate,
    this.profileImage = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      currentWeek: json['currentWeek'],
      dueDate: json['dueDate'],
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentWeek': currentWeek,
      'dueDate': dueDate,
      'profileImage': profileImage,
    };
  }
}
