import 'supabase_service.dart';

class DatabaseSetup {
  static final DatabaseSetup _instance = DatabaseSetup._internal();
  final SupabaseService _supabaseService = SupabaseService();
  
  // Singleton pattern
  factory DatabaseSetup() {
    return _instance;
  }
  
  DatabaseSetup._internal();
  
  Future<void> initialize() async {
    if (!_supabaseService.isAuthenticated) return;
    
    try {
      // Ensure profiles table exists
      await _supabaseService.ensureDatabaseSetup();
      
      // Ensure community tables exist
      await _createCommunityPostsTable();
      
      print('Database setup completed successfully');
    } catch (e) {
      print('Error during database setup: $e');
    }
  }
  
  Future<void> _createCommunityPostsTable() async {
    try {
      // Create the community_posts table using SQL function
      await _supabaseService.client.rpc('create_community_posts_table');
      print('Community posts table setup completed');
    } catch (e) {
      print('Error creating community_posts table: $e');
      // If the function doesn't exist, we need to handle it
      if (e.toString().contains('function "create_community_posts_table" does not exist')) {
        print('The create_community_posts_table function does not exist in Supabase');
        print('Please run the SQL script in supabase/setup_community_posts_table.sql');
      }
    }
  }
}
