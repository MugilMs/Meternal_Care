import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/social_group.dart';
import '../widgets/app_header.dart';

class EnhancedCommunityScreen extends StatefulWidget {
  const EnhancedCommunityScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedCommunityScreen> createState() => _EnhancedCommunityScreenState();
}

class _EnhancedCommunityScreenState extends State<EnhancedCommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample data - replace with actual data from your backend
  final List<SocialGroup> _groups = [
    SocialGroup(
      id: '1',
      name: 'March 2024 Moms',
      description: 'Connect with other moms due in March 2024',
      imageUrl: 'https://example.com/march_moms.jpg',
      type: GroupType.dueDateGroup,
      privacy: GroupPrivacy.public,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      creatorId: 'user1',
      memberIds: List.generate(45, (index) => 'user$index'),
      moderatorIds: ['user1', 'user2'],
    ),
    SocialGroup(
      id: '2',
      name: 'First Time Moms Support',
      description: 'A safe space for first-time mothers to share experiences',
      imageUrl: 'https://example.com/first_time.jpg',
      type: GroupType.firstTimeMoms,
      privacy: GroupPrivacy.public,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      creatorId: 'user3',
      memberIds: List.generate(128, (index) => 'user$index'),
      moderatorIds: ['user3', 'user4'],
    ),
    SocialGroup(
      id: '3',
      name: 'Prenatal Nutrition Tips',
      description: 'Expert-led group for pregnancy nutrition guidance',
      imageUrl: 'https://example.com/nutrition.jpg',
      type: GroupType.expertLed,
      privacy: GroupPrivacy.public,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      creatorId: 'expert1',
      memberIds: List.generate(89, (index) => 'user$index'),
      moderatorIds: ['expert1'],
    ),
  ];

  final List<ExpertQA> _expertQAs = [
    ExpertQA(
      id: '1',
      question: 'Is it safe to exercise during the third trimester?',
      answer: 'Yes, gentle exercise is generally safe and beneficial during the third trimester. Focus on low-impact activities like walking, swimming, and prenatal yoga. Always consult your healthcare provider before starting any exercise routine.',
      userId: 'user1',
      expertId: 'expert1',
      tags: ['exercise', 'third-trimester', 'safety'],
      category: QACategory.exercise,
      status: QAStatus.answered,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      answeredAt: DateTime.now().subtract(const Duration(days: 1)),
      upvotes: 24,
      upvotedBy: List.generate(24, (index) => 'user$index'),
    ),
    ExpertQA(
      id: '2',
      question: 'What foods should I avoid during pregnancy?',
      userId: 'user2',
      tags: ['nutrition', 'food-safety'],
      category: QACategory.nutrition,
      status: QAStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      upvotes: 8,
      upvotedBy: List.generate(8, (index) => 'user$index'),
    ),
  ];

  final List<Expert> _experts = [
    Expert(
      id: 'expert1',
      name: 'Dr. Sarah Johnson',
      title: 'OB/GYN',
      specialty: 'Obstetrics & Gynecology',
      bio: 'Board-certified OB/GYN with 15 years of experience in maternal-fetal medicine.',
      imageUrl: 'https://example.com/dr_johnson.jpg',
      credentials: ['MD', 'Board Certified OB/GYN'],
      specializations: ['High-risk pregnancy', 'Prenatal care', 'Labor & delivery'],
      rating: 4.9,
      totalAnswers: 156,
      isVerified: true,
    ),
    Expert(
      id: 'expert2',
      name: 'Lisa Chen, RD',
      title: 'Registered Dietitian',
      specialty: 'Prenatal Nutrition',
      bio: 'Specialized in pregnancy nutrition and maternal health for over 10 years.',
      imageUrl: 'https://example.com/lisa_chen.jpg',
      credentials: ['RD', 'CDE'],
      specializations: ['Prenatal nutrition', 'Gestational diabetes', 'Weight management'],
      rating: 4.8,
      totalAnswers: 89,
      isVerified: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(
        title: "Community",
        currentPage: "enhanced_community",
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Groups'),
                Tab(text: 'Expert Q&A'),
                Tab(text: 'Experts'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupsTab(),
                _buildExpertQATab(),
                _buildExpertsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOptions,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Groups
          Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return _buildFeaturedGroupCard(group);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Group Categories
          Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCategoryCard('Due Date Groups', Icons.calendar_today, GroupType.dueDateGroup),
              _buildCategoryCard('Local Groups', Icons.location_on, GroupType.localGroup),
              _buildCategoryCard('First Time Moms', Icons.baby_changing_station, GroupType.firstTimeMoms),
              _buildCategoryCard('Expert Led', Icons.school, GroupType.expertLed),
              _buildCategoryCard('Support Groups', Icons.favorite, GroupType.supportGroup),
              _buildCategoryCard('High Risk', Icons.medical_services, GroupType.highRiskPregnancy),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // All Groups
          Text(
            'All Groups',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          ...(_groups.map((group) => _buildGroupListTile(group)).toList()),
        ],
      ),
    );
  }

  Widget _buildExpertQATab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ask Question Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showAskQuestionDialog,
              icon: const Icon(Icons.help_outline, color: Colors.white),
              label: const Text('Ask an Expert', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Categories
          Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: QACategory.values.map((category) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(_getCategoryName(category)),
                    selected: false,
                    onSelected: (selected) {
                      // Filter by category
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recent Questions
          Text(
            'Recent Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          ...(_expertQAs.map((qa) => _buildQACard(qa)).toList()),
        ],
      ),
    );
  }

  Widget _buildExpertsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Verified Experts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          ...(_experts.map((expert) => _buildExpertCard(expert)).toList()),
        ],
      ),
    );
  }

  Widget _buildFeaturedGroupCard(SocialGroup group) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
                ),
              ),
              child: Center(
                child: Icon(
                  _getGroupTypeIcon(group.type),
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${group.memberCount} members',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, GroupType type) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to category groups
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupListTile(SocialGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(_getGroupTypeIcon(group.type), color: AppColors.primary),
        ),
        title: Text(
          group.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${group.memberCount} members'),
                const SizedBox(width: 16),
                if (group.privacy == GroupPrivacy.private)
                  Icon(Icons.lock, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Join group
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Join'),
        ),
      ),
    );
  }

  Widget _buildQACard(ExpertQA qa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              qa.question,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tags
            Wrap(
              spacing: 8,
              children: qa.tags.map((tag) {
                return Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 12)),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: TextStyle(color: AppColors.primary),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            // Answer (if available)
            if (qa.isAnswered) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified, size: 16, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(
                          'Expert Answer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      qa.answer!,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pending, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Waiting for expert response',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Actions
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Upvote question
                  },
                  icon: Icon(Icons.thumb_up_outlined, color: AppColors.primary),
                ),
                Text('${qa.upvotes}'),
                const Spacer(),
                Text(
                  _formatDate(qa.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertCard(Expert expert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(Icons.person, size: 30, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            expert.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (expert.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.verified, size: 20, color: AppColors.success),
                          ],
                        ],
                      ),
                      Text(
                        expert.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${expert.rating} • ${expert.totalAnswers} answers'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              expert.bio,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Specializations
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: expert.specializations.map((spec) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    spec,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ask this expert a question
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ask a Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGroupTypeIcon(GroupType type) {
    switch (type) {
      case GroupType.dueDateGroup:
        return Icons.calendar_today;
      case GroupType.localGroup:
        return Icons.location_on;
      case GroupType.topicBased:
        return Icons.topic;
      case GroupType.expertLed:
        return Icons.school;
      case GroupType.supportGroup:
        return Icons.favorite;
      case GroupType.firstTimeMoms:
        return Icons.baby_changing_station;
      case GroupType.secondTimeMoms:
        return Icons.family_restroom;
      case GroupType.highRiskPregnancy:
        return Icons.medical_services;
      case GroupType.postpartum:
        return Icons.child_care;
      default:
        return Icons.group;
    }
  }

  String _getCategoryName(QACategory category) {
    switch (category) {
      case QACategory.medical:
        return 'Medical';
      case QACategory.nutrition:
        return 'Nutrition';
      case QACategory.exercise:
        return 'Exercise';
      case QACategory.mental_health:
        return 'Mental Health';
      case QACategory.labor_delivery:
        return 'Labor & Delivery';
      case QACategory.postpartum:
        return 'Postpartum';
      case QACategory.baby_development:
        return 'Baby Development';
      case QACategory.breastfeeding:
        return 'Breastfeeding';
      default:
        return 'General';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showCreateOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.group_add, color: AppColors.primary),
              title: const Text('Create Group'),
              subtitle: const Text('Start a new community group'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to create group
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('Ask Expert'),
              subtitle: const Text('Get professional advice'),
              onTap: () {
                Navigator.pop(context);
                _showAskQuestionDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAskQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask an Expert'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Your Question',
                hintText: 'What would you like to know?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Tags (optional)',
                hintText: 'e.g., nutrition, exercise',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Submit question
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
