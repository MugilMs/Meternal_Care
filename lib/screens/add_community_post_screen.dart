import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../services/community_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_header.dart';

class AddCommunityPostScreen extends StatefulWidget {
  final String initialPostType;
  final Function(CommunityPost) onPostAdded;
  
  const AddCommunityPostScreen({
    Key? key,
    required this.initialPostType,
    required this.onPostAdded,
  }) : super(key: key);

  @override
  State<AddCommunityPostScreen> createState() => _AddCommunityPostScreenState();
}

class _AddCommunityPostScreenState extends State<AddCommunityPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _communityService = CommunityService();
  
  late String _postType;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  
  // Event-specific controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Group-specific controllers
  final TextEditingController _imageUrlController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postType = widget.initialPostType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Parse tags
        final tags = _tagsController.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
        
        CommunityPost newPost;
        
        try {
          // Try to create the post via backend
          newPost = await _communityService.createPost(
            title: _titleController.text,
            content: _contentController.text,
            tags: tags,
            postType: _postType,
            date: _postType == 'event' ? _dateController.text : null,
            time: _postType == 'event' ? _timeController.text : null,
            location: _postType == 'event' ? _locationController.text : null,
            attendees: _postType == 'event' ? 0 : null,
            members: _postType == 'group' ? 0 : null,
            imageUrl: _postType == 'group' ? _imageUrlController.text : null,
          );
        } catch (e) {
          // If backend fails, create offline post
          print('Backend failed, creating offline post: $e');
          newPost = _createOfflinePost(tags);
        }
        
        // Call the callback
        widget.onPostAdded(newPost);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back
          Navigator.pop(context);
        }
      } catch (e) {
        // Show error message only for unexpected errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating post: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  CommunityPost _createOfflinePost(List<String> tags) {
    // Generate a unique ID for offline post
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final offlineId = 'offline_${timestamp}';
    
    return CommunityPost(
      id: offlineId,
      userId: 'offline_user',
      username: 'You',
      title: _titleController.text,
      content: _contentController.text,
      tags: tags,
      createdAt: DateTime.now(),
      likes: 0,
      comments: 0,
      postType: _postType,
      // Event-specific fields
      date: _postType == 'event' ? _dateController.text : null,
      time: _postType == 'event' ? _timeController.text : null,
      location: _postType == 'event' ? _locationController.text : null,
      attendees: _postType == 'event' ? 0 : null,
      // Group-specific fields
      members: _postType == 'group' ? 0 : null,
      imageUrl: _postType == 'group' && _imageUrlController.text.isNotEmpty 
          ? _imageUrlController.text 
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: "Create ${_getPostTypeTitle()}",
        currentPage: "community",
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post type selector
                const Text(
                  "Post Type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _postType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'discussion',
                      child: Text('Discussion'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'group',
                      child: Text('Group'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'event',
                      child: Text('Event'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _postType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Title field
                const Text(
                  "Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Content field
                const Text(
                  "Content",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Tags field
                const Text(
                  "Tags (comma separated)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    hintText: "Enter tags (e.g. Health, First Trimester)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one tag';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Event-specific fields
                if (_postType == 'event') ...[
                  const Text(
                    "Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: "Enter date (e.g. May 15, 2024)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (_postType == 'event' && (value == null || value.isEmpty)) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    "Time",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      hintText: "Enter time (e.g. 10:00 AM - 11:00 AM)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (_postType == 'event' && (value == null || value.isEmpty)) {
                        return 'Please enter a time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    "Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: "Enter location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (_postType == 'event' && (value == null || value.isEmpty)) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Group-specific fields
                if (_postType == 'group') ...[
                  const Text(
                    "Image URL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      hintText: "Enter image URL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (value) {
                      if (_postType == 'group' && (value == null || value.isEmpty)) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _savePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create ${_getPostTypeTitle()}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getPostTypeTitle() {
    switch (_postType) {
      case 'discussion':
        return 'Discussion';
      case 'group':
        return 'Group';
      case 'event':
        return 'Event';
      default:
        return 'Post';
    }
  }
}
