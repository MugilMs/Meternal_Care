import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../utils/ui_helpers.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppHeader(
        title: "Community",
        currentPage: "community",
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Community",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Connect with other expectant mothers and share experiences",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search discussions...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondaryColor,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: "Discussions"),
                Tab(text: "Groups"),
                Tab(text: "Events"),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDiscussionsTab(),
                  _buildGroupsTab(),
                  _buildEventsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UIHelpers.showWorkInProgressDialog(context);
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDiscussionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDiscussionCard(
          username: "Jessica M.",
          title: "Tips for managing back pain in third trimester?",
          content: "I'm 32 weeks pregnant and experiencing lower back pain. Any suggestions for relief that worked for you?",
          likes: 24,
          comments: 18,
          timeAgo: "2 hours ago",
          tags: ["Third Trimester", "Health"],
        ),
        _buildDiscussionCard(
          username: "Priya K.",
          title: "Recommended prenatal vitamins",
          content: "My doctor suggested changing my prenatal vitamins. What brands are you all using and why?",
          likes: 15,
          comments: 32,
          timeAgo: "5 hours ago",
          tags: ["Nutrition", "Health"],
        ),
        _buildDiscussionCard(
          username: "Sarah J.",
          title: "Baby shower ideas needed!",
          content: "Planning my sister's baby shower next month. Looking for creative theme ideas that aren't too traditional.",
          likes: 41,
          comments: 27,
          timeAgo: "1 day ago",
          tags: ["Events", "Fun"],
        ),
        _buildDiscussionCard(
          username: "Emily R.",
          title: "Hospital bag checklist",
          content: "First-time mom here! What are the must-haves for my hospital bag? I don't want to overpack but also don't want to miss anything important.",
          likes: 56,
          comments: 43,
          timeAgo: "2 days ago",
          tags: ["Preparation", "First-time Mom"],
        ),
      ],
    );
  }

  Widget _buildGroupsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGroupCard(
          name: "First-Time Moms",
          members: 1243,
          description: "Support group for women experiencing pregnancy for the first time",
          image: "https://images.unsplash.com/photo-1490424660416-359912d314b3?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        ),
        _buildGroupCard(
          name: "Natural Birth Support",
          members: 856,
          description: "Discussion and support for those planning natural childbirth",
          image: "https://images.unsplash.com/photo-1516627145497-ae6968895b74?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        ),
        _buildGroupCard(
          name: "Twin Pregnancy",
          members: 437,
          description: "Connect with other mothers expecting twins or multiples",
          image: "https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        ),
        _buildGroupCard(
          name: "Working Moms",
          members: 1092,
          description: "Balancing career and pregnancy/motherhood",
          image: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventCard(
          title: "Virtual Prenatal Yoga Class",
          date: "May 15, 2024",
          time: "10:00 AM - 11:00 AM",
          location: "Online (Zoom)",
          attendees: 24,
          description: "Join our certified prenatal yoga instructor for a gentle session designed specifically for expectant mothers.",
        ),
        _buildEventCard(
          title: "Childbirth Preparation Workshop",
          date: "May 22-23, 2024",
          time: "9:00 AM - 3:00 PM",
          location: "City General Hospital",
          attendees: 18,
          description: "Two-day comprehensive workshop covering labor, delivery, pain management techniques, and postpartum care.",
        ),
        _buildEventCard(
          title: "New Parents Meetup",
          date: "June 5, 2024",
          time: "2:00 PM - 4:00 PM",
          location: "Central Park Cafe",
          attendees: 32,
          description: "Casual gathering for expectant parents and those with newborns to connect and share experiences.",
        ),
        _buildEventCard(
          title: "Breastfeeding Basics Class",
          date: "June 12, 2024",
          time: "6:00 PM - 8:00 PM",
          location: "Women's Health Center",
          attendees: 15,
          description: "Learn essential breastfeeding techniques and tips from our certified lactation consultant.",
        ),
      ],
    );
  }

  Widget _buildDiscussionCard({
    required String username,
    required String title,
    required String content,
    required int likes,
    required int comments,
    required String timeAgo,
    required List<String> tags,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and time
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    username[0],
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                  color: AppTheme.textSecondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Title and content
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) => _buildTag(tag)).toList(),
            ),
            const SizedBox(height: 12),
            
            // Actions
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_outlined,
                  label: likes.toString(),
                  onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: comments.toString(),
                  onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: "Share",
                  onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard({
    required String name,
    required int members,
    required String description,
    required String image,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey.shade300,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group name and member count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    Text(
                      "$members members",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Join button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Join Group"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String time,
    required String location,
    required int attendees,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            
            // Event details
            _buildEventDetail(Icons.calendar_today, date),
            const SizedBox(height: 8),
            _buildEventDetail(Icons.access_time, time),
            const SizedBox(height: 8),
            _buildEventDetail(Icons.location_on, location),
            const SizedBox(height: 8),
            _buildEventDetail(Icons.people, "$attendees attending"),
            const SizedBox(height: 12),
            
            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                    child: const Text("More Info"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("RSVP"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
