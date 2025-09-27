class CommunityPost {
  final String id;
  final String userId;
  final String username;
  final String title;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final String postType; // 'discussion', 'group', or 'event'

  // Event-specific fields
  final String? date;
  final String? time;
  final String? location;
  final int? attendees;

  // Group-specific fields
  final int? members;
  final String? imageUrl;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.content,
    required this.tags,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    required this.postType,
    this.date,
    this.time,
    this.location,
    this.attendees,
    this.members,
    this.imageUrl,
  });

  // Copy with method to create a new instance with updated fields
  CommunityPost copyWith({
    String? id,
    String? userId,
    String? username,
    String? title,
    String? content,
    List<String>? tags,
    DateTime? createdAt,
    int? likes,
    int? comments,
    String? postType,
    String? date,
    String? time,
    String? location,
    int? attendees,
    int? members,
    String? imageUrl,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      postType: postType ?? this.postType,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      members: members ?? this.members,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['created_at']),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      postType: json['post_type'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      attendees: json['attendees'],
      members: json['members'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'title': title,
      'content': content,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'post_type': postType,
      'date': date,
      'time': time,
      'location': location,
      'attendees': attendees,
      'members': members,
      'image_url': imageUrl,
    };
  }
}
