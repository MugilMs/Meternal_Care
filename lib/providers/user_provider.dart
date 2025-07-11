import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:womb_wisdom_flutter/models/user_profile.dart';
import 'package:womb_wisdom_flutter/services/supabase_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  final SupabaseService _supabaseService = SupabaseService();

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  // Load user profile from Supabase
  Future<void> loadUserProfile() async {
    if (!_supabaseService.isAuthenticated) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final userData = await _supabaseService.getUserProfile();
      
      if (userData != null) {
        _userProfile = UserProfile.fromJson(userData);
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _supabaseService.updateUserProfile(data);
      await loadUserProfile(); // Reload profile to get updated data
      
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> uploadProfileImage(File imageFile) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final uploadPath = await _supabaseService.uploadProfileImage(imageFile, fileName);
      
      if (uploadPath != null) {
        final imageUrl = await _supabaseService.getProfileImageUrl(uploadPath);
        if (imageUrl != null) {
          await _supabaseService.updateUserProfile({
            'avatar_url': imageUrl,
          });
          await loadUserProfile(); // Reload profile to get updated data
        }
      }
      
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Sign in user
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await loadUserProfile();
        return true;
      } else {
        _error = 'Failed to sign in';
        return false;
      }
    } catch (e) {
      _error = 'Error signing in: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign up user
  Future<bool> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        userData: {
          'full_name': fullName,
          'display_name': fullName.split(' ')[0],
        },
      );
      
      if (response.user != null) {
        // Create initial profile
        await _supabaseService.updateUserProfile({
          'full_name': fullName,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        await loadUserProfile();
        return true;
      } else {
        _error = 'Failed to create account';
        return false;
      }
    } catch (e) {
      _error = 'Error creating account: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Sign out user
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _supabaseService.signOut();
      _userProfile = null;
    } catch (e) {
      _error = 'Error signing out: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
