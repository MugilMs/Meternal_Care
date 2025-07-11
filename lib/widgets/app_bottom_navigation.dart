import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home),
          _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today),
          _buildNavItem(2, Icons.chat_bubble_outline, Icons.chat_bubble),
          _buildNavItem(3, Icons.add_circle_outline, Icons.add_circle, isSpecial: true),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, {bool isSpecial = false}) {
    final bool isSelected = index == currentIndex;
    final Color iconColor = isSelected 
        ? isSpecial ? const Color(0xFFFF6B6B) : const Color(0xFF444444)
        : Colors.grey;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: iconColor,
            size: isSpecial ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFF6B6B) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
