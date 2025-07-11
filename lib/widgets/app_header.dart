import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final String currentPage;
  
  const AppHeader({
    Key? key,
    required this.title,
    this.showBackButton = false,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (showBackButton) const SizedBox(width: 8),
          const Icon(
            FontAwesomeIcons.heartPulse,
            color: Color(0xFFFF6B6B), // Pink color for the heart icon
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: currentPage == 'notifications' 
                ? Color(0xFFFF6B6B) 
                : Color(0xFF444444),
            size: 26,
          ),
          onPressed: () {
            // Handle notifications
            if (currentPage != 'notifications') {
              Navigator.pushNamed(context, '/notifications');
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.person_outline,
            color: currentPage == 'profile' 
                ? Color(0xFFFF6B6B) 
                : Color(0xFF444444),
            size: 26,
          ),
          onPressed: () {
            if (currentPage != 'profile') {
              Navigator.pushNamed(context, '/profile');
            }
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
