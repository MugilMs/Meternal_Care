import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:womb_wisdom_flutter/models/user_profile.dart';
import 'package:womb_wisdom_flutter/providers/user_provider.dart';
import 'package:womb_wisdom_flutter/screens/login_screen.dart';
import 'package:womb_wisdom_flutter/services/supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _preWeightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  String? _bloodType;
  bool _isEditing = false;
  File? _imageFile;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final supabaseService = SupabaseService();
      
      // Check if user is authenticated
      if (!supabaseService.isAuthenticated) {
        // If not authenticated, show login screen
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to login after a short delay
          Future.delayed(const Duration(milliseconds: 100), () {
            _navigateToLogin();
          });
        }
        return;
      }
      
      // Ensure database tables exist
      try {
        await supabaseService.ensureDatabaseSetup();
        print('Database setup completed');
      } catch (e) {
        print('Error setting up database: $e');
        // Continue anyway, as the table might already exist
      }
      
      // Try to load profile from Supabase
      await userProvider.loadUserProfile();
      
      // If profile loaded successfully
      if (userProvider.userProfile != null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _populateFields(userProvider.userProfile);
          });
        }
      } else {
        // If no profile exists in database, create one with default data
        print('No profile found, creating a new one...');
        
        // Create a profile with default values
        final mockProfile = _getMockProfile();
        
        // Save the profile to Supabase
        try {
          await userProvider.updateUserProfile(mockProfile.toJson());
          print('Profile created successfully');
          
          // Reload the profile
          await userProvider.loadUserProfile();
          
          if (mounted) {
            setState(() {
              _isLoading = false;
              _populateFields(userProvider.userProfile ?? mockProfile);
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Created new profile with default values'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        } catch (e) {
          print('Error creating profile: $e');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = 'Error creating profile: $e';
            });
          }
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load profile: ${e.toString()}';
        });
      }
    }
  }
  
  UserProfile _getMockProfile() {
    final supabaseService = SupabaseService();
    final currentUser = supabaseService.currentUser;
    
    return UserProfile(
      id: currentUser?.id ?? 'mock-user-id',
      email: currentUser?.email ?? 'test@example.com',
      fullName: currentUser?.userMetadata?['full_name'] ?? 'Jane Doe',
      displayName: currentUser?.userMetadata?['display_name'] ?? 'Jane',
      phoneNumber: '',
      dueDate: DateTime.now().add(const Duration(days: 180)).toString().substring(0, 10),
      currentWeek: 20,
      bloodType: 'A+',
      height: 165.0,
      prePregnancyWeight: 60.0,
      currentWeight: 65.5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _displayNameController.dispose();
    _phoneController.dispose();
    _dueDateController.dispose();
    _heightController.dispose();
    _preWeightController.dispose();
    _currentWeightController.dispose();
    super.dispose();
  }

  void _populateFields(UserProfile? profile) {
    if (profile == null) return;
    
    _fullNameController.text = profile.fullName ?? '';
    _displayNameController.text = profile.displayName ?? '';
    _phoneController.text = profile.phoneNumber ?? '';
    _dueDateController.text = profile.dueDate ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _preWeightController.text = profile.prePregnancyWeight?.toString() ?? '';
    _currentWeightController.text = profile.currentWeight?.toString() ?? '';
    
    if (profile.bloodType != null) {
      setState(() {
        _bloodType = profile.bloodType;
      });
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    final ImagePicker picker = ImagePicker();
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _imageFile = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _imageFile = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDateController.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(_dueDateController.text)
          : DateTime.now().add(const Duration(days: 280)), // ~40 weeks from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 300)),
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Create updated profile
      final updatedProfile = userProvider.userProfile?.copyWith(
        fullName: _fullNameController.text,
        displayName: _displayNameController.text,
        phoneNumber: _phoneController.text,
        dueDate: _dueDateController.text,
        bloodType: _bloodType,
        height: _heightController.text.isNotEmpty ? double.parse(_heightController.text) : null,
        prePregnancyWeight: _preWeightController.text.isNotEmpty ? double.parse(_preWeightController.text) : null,
        currentWeight: _currentWeightController.text.isNotEmpty ? double.parse(_currentWeightController.text) : null,
      );
      
      if (updatedProfile != null) {
        await userProvider.updateUserProfile(updatedProfile.toJson());
        
        // Upload profile image if selected
        if (_imageFile != null) {
          await userProvider.uploadProfileImage(_imageFile!);
        }
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to update profile: ${e.toString()}';
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmSignOut() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.signOut();
      _navigateToLogin();
    }
  }
  
  Widget _buildPregnancyProgress() {
    if (_dueDateController.text.isEmpty) return const SizedBox.shrink();
    
    try {
      final dueDate = DateFormat('yyyy-MM-dd').parse(_dueDateController.text);
      final today = DateTime.now();
      
      // Pregnancy is typically 40 weeks (280 days)
      final pregnancyDuration = const Duration(days: 280);
      final conceptionDate = dueDate.subtract(pregnancyDuration);
      
      // Calculate days passed and total days
      final daysPassed = today.difference(conceptionDate).inDays;
      final totalDays = dueDate.difference(conceptionDate).inDays;
      
      // Calculate current week of pregnancy
      final currentWeek = (daysPassed / 7).floor() + 1;
      
      // Calculate progress percentage (capped at 100%)
      final progress = math.min(daysPassed / totalDays, 1.0);
      
      // If due date is in the past
      if (today.isAfter(dueDate)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your due date was ${DateFormat('MMMM d, yyyy').format(dueDate)}.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'We hope you and your baby are doing well!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week $currentWeek of 40',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Conception: ${DateFormat('MMM d').format(conceptionDate)}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                'Due: ${DateFormat('MMM d').format(dueDate)}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getTrimesterInfo(currentWeek),
            style: const TextStyle(fontSize: 15),
          ),
        ],
      );
    } catch (e) {
      return const Text('Invalid due date format');
    }
  }
  
  String _getTrimesterInfo(int week) {
    if (week <= 13) {
      return '1st Trimester: Your baby is developing vital organs and structures.';  
    } else if (week <= 26) {
      return '2nd Trimester: Your baby is growing rapidly and you may feel movement.';  
    } else {
      return '3rd Trimester: Your baby is gaining weight and preparing for birth.';  
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF444444)),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.favorite,
                color: Color(0xFFFF6B6B),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Profile',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
                ),
              )
            : _hasError
                ? _buildErrorView()
                : _buildProfileContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFFF6B6B)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Retry', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final userProvider = Provider.of<UserProvider>(context);
    final profile = userProvider.userProfile;
    final primaryColor = const Color(0xFFFF6B6B);
    final textColor = const Color(0xFF444444);
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header with avatar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isEditing ? _showImageSourceActionSheet : null,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: _imageFile != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _imageFile!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : (profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            profile.avatarUrl!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.person, size: 60, color: Color(0xFFFF6B6B));
                                            },
                                          ),
                                        )
                                      : const Icon(Icons.person, size: 60, color: Color(0xFFFF6B6B))),
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile?.displayName ?? profile?.fullName ?? 'User',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Edit/Save buttons
                    if (!_isEditing)
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _populateFields(profile);
                                _imageFile = null;
                              });
                            },
                            child: const Text('Cancel'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _saveProfile,
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(height: 32),
            
            // Personal Information Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: Icon(Icons.person, color: _isEditing ? primaryColor : Colors.grey),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                    ),
                    enabled: _isEditing,
                    validator: (value) {
                      if (_isEditing && (value == null || value.isEmpty)) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: Icon(Icons.badge, color: _isEditing ? primaryColor : Colors.grey),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                      helperText: 'This name will be displayed throughout the app',
                    ),
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: Icon(Icons.phone, color: _isEditing ? primaryColor : Colors.grey),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                    ),
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            
            // Pregnancy Information Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pregnant_woman, color: primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Pregnancy Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Due Date with Calendar Picker
                  GestureDetector(
                    onTap: _isEditing ? () => _selectDate(context) : null,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dueDateController,
                        decoration: InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          prefixIcon: Icon(Icons.calendar_today, color: _isEditing ? primaryColor : Colors.grey),
                          suffixIcon: _isEditing ? Icon(Icons.arrow_drop_down, color: primaryColor) : null,
                          filled: true,
                          fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                          helperText: 'Tap to select your due date',
                        ),
                        enabled: _isEditing,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Blood Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _bloodType,
                    decoration: InputDecoration(
                      labelText: 'Blood Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: Icon(Icons.bloodtype, color: _isEditing ? primaryColor : Colors.grey),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'A+', child: Text('A+')),
                      DropdownMenuItem(value: 'A-', child: Text('A-')),
                      DropdownMenuItem(value: 'B+', child: Text('B+')),
                      DropdownMenuItem(value: 'B-', child: Text('B-')),
                      DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                      DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                      DropdownMenuItem(value: 'O+', child: Text('O+')),
                      DropdownMenuItem(value: 'O-', child: Text('O-')),
                    ],
                    onChanged: _isEditing
                        ? (value) {
                            setState(() {
                              _bloodType = value;
                            });
                          }
                        : null,
                    icon: Icon(_isEditing ? Icons.arrow_drop_down : null, color: _isEditing ? primaryColor : Colors.transparent),
                  ),
                  const SizedBox(height: 16),
                  
                  // Height field
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      prefixIcon: Icon(Icons.height, color: _isEditing ? primaryColor : Colors.grey),
                      filled: true,
                      fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                    ),
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Weight fields in a Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _preWeightController,
                          decoration: InputDecoration(
                            labelText: 'Pre-pregnancy Weight (kg)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.monitor_weight, color: _isEditing ? primaryColor : Colors.grey),
                            filled: true,
                            fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                          ),
                          enabled: _isEditing,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _currentWeightController,
                          decoration: InputDecoration(
                            labelText: 'Current Weight (kg)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.monitor_weight_outlined, color: _isEditing ? primaryColor : Colors.grey),
                            filled: true,
                            fillColor: _isEditing ? Colors.white : Colors.grey.shade50,
                          ),
                          enabled: _isEditing,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Show pregnancy progress if due date is set
                  if (_dueDateController.text.isNotEmpty && !_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: _buildPregnancyProgress(),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Sign Out Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _confirmSignOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
