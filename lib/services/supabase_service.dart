import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:womb_wisdom_flutter/services/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  
  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }
  
  SupabaseService._internal();
  
  Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _client = Supabase.instance.client;
  }
  
  // Ensure database tables are created
  Future<void> ensureDatabaseSetup() async {
    if (!isAuthenticated) return;
    
    try {
      // Try to create the profiles table if it doesn't exist
      await _client.rpc('create_profiles_table');
      print('Database setup completed successfully');
    } catch (e) {
      print('Error during database setup: $e');
      // If the function doesn't exist, we need to create it
      if (e.toString().contains('function "create_profiles_table" does not exist')) {
        print('The create_profiles_table function does not exist in Supabase');
        print('Please run the SQL script in supabase/setup_profiles_table.sql');
      }
      rethrow;
    }
  }
  
  SupabaseClient get client => _client;
  
  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
    return response;
  }
  
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // Check if user is logged in
  bool get isAuthenticated => _client.auth.currentUser != null;
  
  // Get current user
  User? get currentUser => _client.auth.currentUser;
  
  // User profile methods
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;
    
    try {
      // First check if the profiles table exists
      try {
        await _client.from('profiles').select('id').limit(1);
      } catch (e) {
        if (e.toString().contains('relation "public.profiles" does not exist')) {
          // Create the profiles table if it doesn't exist
          print('Creating profiles table from getUserProfile...');
          await ensureDatabaseSetup();
        }
      }
      
      // Try to get the user profile
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .maybeSingle();
      
      if (response != null) {
        return response;
      } else {
        // Profile doesn't exist, create a default one
        print('Profile not found, creating default profile');
        final defaultProfile = {
          'id': currentUser!.id,
          'email': currentUser!.email,
          'full_name': currentUser!.userMetadata?['full_name'] ?? '',
          'display_name': currentUser!.userMetadata?['display_name'] ?? '',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        // Insert the default profile
        await updateUserProfile(defaultProfile);
        
        // Return the default profile
        return defaultProfile;
      }
    } catch (e) {
      print('Error getting user profile: $e');
      // If there's an error, return a default profile
      return {
        'id': currentUser!.id,
        'email': currentUser!.email,
        'full_name': currentUser!.userMetadata?['full_name'] ?? '',
        'display_name': currentUser!.userMetadata?['display_name'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
    }
  }
  
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    
    try {
      // First check if the profiles table exists
      try {
        await _client.from('profiles').select('id').limit(1);
      } catch (e) {
        if (e.toString().contains('relation "public.profiles" does not exist')) {
          // Create the profiles table if it doesn't exist
          print('Creating profiles table...');
          await _client.rpc('create_profiles_table');
        }
      }
      
      // Check if user profile exists
      final existingProfile = await _client
          .from('profiles')
          .select('id')
          .eq('id', currentUser!.id)
          .maybeSingle();
      
      // Prepare complete profile data
      final completeData = {
        'id': currentUser!.id,
        'email': currentUser!.email,
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // If profile doesn't exist, add created_at
      if (existingProfile == null) {
        completeData['created_at'] = DateTime.now().toIso8601String();
      }
      
      // Upsert the profile data
      await _client
          .from('profiles')
          .upsert(completeData);
          
      print('Profile updated successfully: ${completeData.toString()}');
    } catch (e) {
      // If the table doesn't exist, create it first
      if (e.toString().contains('relation "public.profiles" does not exist')) {
        // Create the profiles table
        await _client.rpc('create_profiles_table', params: {});
        
        // Try the update again
        await _client
            .from('profiles')
            .upsert({
              'id': currentUser!.id,
              ...data,
              'updated_at': DateTime.now().toIso8601String(),
            });
      } else {
        rethrow;
      }
    }
  }
  
  // Upload profile image
  Future<String?> uploadProfileImage(File file, String fileName) async {
    if (currentUser == null) return null;
    
    final response = await _client
        .storage
        .from('profile_images')
        .upload('${currentUser!.id}/$fileName', file);
    
    return response;
  }
  
  // Get profile image URL
  Future<String?> getProfileImageUrl(String path) async {
    final response = await _client
        .storage
        .from('profile_images')
        .getPublicUrl(path);
    
    return response;
  }
}
