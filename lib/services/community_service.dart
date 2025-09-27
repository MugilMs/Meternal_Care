import 'package:uuid/uuid.dart';
import '../models/community_post.dart';
import 'supabase_service.dart';

class CommunityService {
  static final CommunityService _instance = CommunityService._internal();
  final SupabaseService _supabaseService = SupabaseService();
  final Uuid _uuid = Uuid();
  
  // Singleton pattern
  factory CommunityService() {
    return _instance;
  }
  
  CommunityService._internal();
  
  // Ensure community tables exist
  Future<void> ensureCommunityTablesExist() async {
    if (!_supabaseService.isAuthenticated) return;
    
    try {
      // Check if the community_posts table exists
      try {
        await _supabaseService.client.from('community_posts').select('id').limit(1);
      } catch (e) {
        if (e.toString().contains('relation "public.community_posts" does not exist')) {
          // Create the community_posts table
          await _createCommunityPostsTable();
        }
      }
    } catch (e) {
      print('Error ensuring community tables exist: $e');
      // Don't throw here to allow the app to continue
    }
  }
  
  Future<void> _createCommunityPostsTable() async {
    try {
      await _supabaseService.client.rpc('create_community_posts_table');
      print('Community posts table setup completed');
    } catch (e) {
      print('Error creating community_posts table: $e');
      if (e.toString().contains('function "create_community_posts_table" does not exist')) {
        print('The create_community_posts_table function does not exist in Supabase');
        print('Please run the SQL script to create the community_posts table');
      }
    }
  }
  
  // Create a new community post (fully offline)
  Future<CommunityPost> createPost({required String title, required String content, required List<String> tags, 
      required String postType, String? date, String? time, String? location, int? attendees, int? members, String? imageUrl}) async {
    
    // Generate a UUID for the post
    final postId = _uuid.v4();
    
    // Get current user info or use defaults for offline mode
    final currentUser = _supabaseService.currentUser;
    final userId = currentUser?.id ?? 'offline_user_${DateTime.now().millisecondsSinceEpoch}';
    final username = currentUser?.userMetadata?['display_name'] ?? currentUser?.email?.split('@')[0] ?? 'You';
    
    // Create the post object
    final post = CommunityPost(
      id: postId,
      userId: userId,
      username: username,
      title: title,
      content: content,
      tags: tags,
      createdAt: DateTime.now(),
      likes: 0,
      comments: 0,
      postType: postType,
      date: date,
      time: time,
      location: location,
      attendees: attendees,
      members: members,
      imageUrl: imageUrl,
    );
    
    // Store post in memory for this session
    _addToLocalPosts(post);
    
    print('Post created successfully (offline mode)');
    return post;
  }
  
  // Local posts storage for this session
  static final List<CommunityPost> _localPosts = [];
  
  void _addToLocalPosts(CommunityPost post) {
    _localPosts.insert(0, post); // Add to beginning for newest first
    // Keep only last 50 posts to avoid memory issues
    if (_localPosts.length > 50) {
      _localPosts.removeRange(50, _localPosts.length);
    }
  }
  
  // Get community posts by type (offline-first)
  Future<List<CommunityPost>> getPostsByType(String postType) async {
    // Return local posts filtered by type, plus sample data
    final localFilteredPosts = _localPosts
        .where((post) => post.postType == postType)
        .toList();
    
    final samplePosts = _getSamplePosts(postType);
    
    // Combine local posts with sample posts, avoiding duplicates
    final allPosts = <CommunityPost>[];
    allPosts.addAll(localFilteredPosts);
    
    for (final samplePost in samplePosts) {
      if (!allPosts.any((post) => post.id == samplePost.id)) {
        allPosts.add(samplePost);
      }
    }
    
    // Sort by creation date, newest first
    allPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return allPosts;
  }
  
  // Get all community posts (offline-first)
  Future<List<CommunityPost>> getAllPosts() async {
    // Return all local posts plus sample data
    final allSamplePosts = <CommunityPost>[];
    allSamplePosts.addAll(_getSamplePosts('discussion'));
    allSamplePosts.addAll(_getSamplePosts('group'));
    allSamplePosts.addAll(_getSamplePosts('event'));
    
    final allPosts = <CommunityPost>[];
    allPosts.addAll(_localPosts);
    
    // Add sample posts, avoiding duplicates
    for (final samplePost in allSamplePosts) {
      if (!allPosts.any((post) => post.id == samplePost.id)) {
        allPosts.add(samplePost);
      }
    }
    
    // Sort by creation date, newest first
    allPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return allPosts;
  }
  
  // Update a post's likes or comments
  Future<void> updatePostEngagement(String postId, {int? likes, int? comments}) async {
    if (!_supabaseService.isAuthenticated) {
      throw Exception('User not authenticated');
    }
    
    try {
      final updateData = {};
      if (likes != null) updateData['likes'] = likes;
      if (comments != null) updateData['comments'] = comments;
      
      await _supabaseService.client
          .from('community_posts')
          .update(updateData)
          .eq('id', postId);
    } catch (e) {
      print('Error updating post engagement: $e');
      // If the table doesn't exist, just return
      if (!e.toString().contains('relation "public.community_posts" does not exist')) {
        rethrow;
      }
    }
  }
  
  // Delete a post
  Future<void> deletePost(String postId) async {
    if (!_supabaseService.isAuthenticated) {
      throw Exception('User not authenticated');
    }
    
    try {
      await _supabaseService.client
          .from('community_posts')
          .delete()
          .eq('id', postId);
    } catch (e) {
      print('Error deleting post: $e');
      // If the table doesn't exist, just return
      if (!e.toString().contains('relation "public.community_posts" does not exist')) {
        rethrow;
      }
    }
  }
  
  // Sample data to use when the database table doesn't exist yet
  List<CommunityPost> _getSamplePosts(String postType) {
    final now = DateTime.now();
    final sampleUserId = 'sample-user-id';
    
    switch (postType) {
      case 'discussion':
        return [
          CommunityPost(
            id: '1',
            userId: sampleUserId,
            username: 'Sarah',
            title: 'Morning Sickness Remedies',
            content: "I've been struggling with morning sickness. What remedies have worked for you?",
            tags: ['First Trimester', 'Health'],
            createdAt: now.subtract(const Duration(days: 2)),
            likes: 15,
            comments: 8,
            postType: 'discussion',
          ),
          CommunityPost(
            id: '2',
            userId: sampleUserId,
            username: 'Emily',
            title: 'Baby Name Ideas',
            content: 'Looking for unique baby names with meaning. Any suggestions?',
            tags: ['Baby Names', 'Planning'],
            createdAt: now.subtract(const Duration(days: 5)),
            likes: 24,
            comments: 32,
            postType: 'discussion',
          ),
          CommunityPost(
            id: '3',
            userId: sampleUserId,
            username: 'Jessica',
            title: 'Exercise During Pregnancy',
            content: 'What exercises are safe during the third trimester?',
            tags: ['Third Trimester', 'Fitness'],
            createdAt: now.subtract(const Duration(days: 1)),
            likes: 18,
            comments: 7,
            postType: 'discussion',
          ),
        ];
      case 'group':
        return [
          CommunityPost(
            id: '4',
            userId: sampleUserId,
            username: 'Maria',
            title: 'First-Time Moms',
            content: 'A supportive group for women experiencing pregnancy for the first time.',
            tags: ['Support', 'First-Time'],
            createdAt: now.subtract(const Duration(days: 30)),
            likes: 45,
            comments: 0,
            postType: 'group',
            members: 128,
          ),
          CommunityPost(
            id: '5',
            userId: sampleUserId,
            username: 'Aisha',
            title: 'Working Moms',
            content: 'Balancing career and pregnancy/motherhood.',
            tags: ['Work-Life', 'Career'],
            createdAt: now.subtract(const Duration(days: 45)),
            likes: 36,
            comments: 0,
            postType: 'group',
            members: 95,
          ),
          CommunityPost(
            id: '6',
            userId: sampleUserId,
            username: 'Sophia',
            title: 'Healthy Pregnancy Diet',
            content: 'Share recipes and nutrition tips for a healthy pregnancy.',
            tags: ['Nutrition', 'Health'],
            createdAt: now.subtract(const Duration(days: 15)),
            likes: 29,
            comments: 0,
            postType: 'group',
            members: 76,
          ),
        ];
      case 'event':
        return [
          CommunityPost(
            id: '7',
            userId: sampleUserId,
            username: 'Emma',
            title: 'Prenatal Yoga Workshop',
            content: 'Join us for a gentle yoga session designed specifically for pregnant women.',
            tags: ['Yoga', 'Wellness'],
            createdAt: now.subtract(const Duration(days: 3)),
            likes: 32,
            comments: 5,
            postType: 'event',
            date: now.add(const Duration(days: 7)).toString().substring(0, 10),
            time: '10:00 AM',
            location: 'Serenity Yoga Studio',
            attendees: 18,
          ),
          CommunityPost(
            id: '8',
            userId: sampleUserId,
            username: 'Olivia',
            title: 'Childbirth Preparation Class',
            content: 'A comprehensive class covering labor, delivery, and early newborn care.',
            tags: ['Education', 'Childbirth'],
            createdAt: now.subtract(const Duration(days: 10)),
            likes: 41,
            comments: 12,
            postType: 'event',
            date: now.add(const Duration(days: 14)).toString().substring(0, 10),
            time: '6:30 PM',
            location: 'Community Hospital',
            attendees: 24,
          ),
          CommunityPost(
            id: '9',
            userId: sampleUserId,
            username: 'Zoe',
            title: 'Baby Shower Ideas Exchange',
            content: 'Come share and gather ideas for planning the perfect baby shower.',
            tags: ['Social', 'Planning'],
            createdAt: now.subtract(const Duration(days: 7)),
            likes: 27,
            comments: 8,
            postType: 'event',
            date: now.add(const Duration(days: 21)).toString().substring(0, 10),
            time: '2:00 PM',
            location: 'Bloom Café',
            attendees: 15,
          ),
        ];
      default:
        return [];
    }
  }
}
