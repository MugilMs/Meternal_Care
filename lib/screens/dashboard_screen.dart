import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/health_tip.dart';
import '../models/appointment.dart';
import '../models/emergency_contact.dart';
import '../theme/app_theme.dart';
import '../widgets/health_tip_card.dart';
import '../widgets/app_header.dart';
import '../utils/ui_helpers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Sarah";
  final int currentWeek = 24;
  
  final List<HealthTip> weeklyTips = [
    HealthTip(
      week: 24,
      title: "Your Baby is Growing!",
      content: "Your baby is now about the size of a cantaloupe! Focus on iron-rich foods and continue your prenatal vitamins.",
      category: "Development"
    ),
    HealthTip(
      week: 24,
      title: "Nutrition Focus",
      content: "Include leafy greens, lean proteins, and whole grains. Stay hydrated with 8-10 glasses of water daily.",
      category: "Nutrition"
    ),
    HealthTip(
      week: 24,
      title: "Exercise Safely",
      content: "Gentle prenatal yoga and walking are excellent. Avoid contact sports and lying flat on your back.",
      category: "Exercise"
    )
  ];

  final List<Appointment> upcomingAppointments = [
    Appointment(
      id: 1,
      date: "2024-03-15",
      time: "10:00 AM",
      doctor: "Dr. Sarah Johnson",
      specialty: "Obstetrician",
      type: "Regular Checkup",
      status: "Confirmed",
      location: "City General Hospital"
    ),
    Appointment(
      id: 2,
      date: "2024-03-22",
      time: "2:30 PM",
      doctor: "Dr. Michael Chen",
      specialty: "Radiologist",
      type: "Ultrasound",
      status: "Pending",
      location: "Women's Health Center"
    )
  ];

  final List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      name: "Emergency Helpline",
      phoneNumber: "1-800-MATERNAL",
      type: "emergency"
    ),
    EmergencyContact(
      name: "City General Hospital",
      phoneNumber: "(555) 123-4567",
      type: "hospital"
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppHeader(
        title: "MaternalCare",
        currentPage: "dashboard",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(),
                const SizedBox(height: 24),
                
                // Main Content and Sidebar
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 700) {
                      // Tablet/Desktop Layout
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildMainContent(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: _buildSidebar(),
                          ),
                        ],
                      );
                    } else {
                      // Mobile Layout
                      return Column(
                        children: [
                          _buildMainContent(),
                          const SizedBox(height: 16),
                          _buildSidebar(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back, $userName!",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "You're in week $currentWeek of your pregnancy journey",
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 16),
        
        // Progress Bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 12.0,
              percent: currentWeek / 40,
              backgroundColor: Colors.grey.shade200,
              linearGradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              barRadius: const Radius.circular(8),
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 8),
            Text(
              "$currentWeek of 40 weeks completed",
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Health Tips
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "This Week's Health Tips",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Week $currentWeek guidance for you and your baby",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ...weeklyTips.map((tip) => HealthTipCard(tip: tip)).toList(),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Quick Actions
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Access your most-used features",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildQuickActionButton(
                      icon: Icons.calendar_month,
                      label: "Schedule",
                      color: AppTheme.primaryColor,
                      onTap: () {
                        UIHelpers.showWorkInProgressDialog(context);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.forum,
                      label: "Community",
                      color: AppTheme.greenColor,
                      onTap: () {
                        UIHelpers.showWorkInProgressDialog(context);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.location_on,
                      label: "Find Hospitals",
                      color: AppTheme.accentColor,
                      onTap: () {
                        UIHelpers.showWorkInProgressDialog(context);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.person,
                      label: "Consult Doctor",
                      color: AppTheme.secondaryColor,
                      onTap: () {
                        UIHelpers.showWorkInProgressDialog(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        // Upcoming Appointments
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppTheme.accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Upcoming Appointments",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...upcomingAppointments.map((appointment) => _buildAppointmentItem(appointment)).toList(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      UIHelpers.showWorkInProgressDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Schedule New Appointment"),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Emergency Contacts
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Contacts",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.redColor,
                  ),
                ),
                const SizedBox(height: 16),
                ...emergencyContacts.map((contact) => _buildEmergencyContactItem(contact)).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(Appointment appointment) {
    Color bgColor;
    Color textColor;
    
    switch (appointment.status) {
      case 'Confirmed':
        bgColor = AppTheme.confirmedColor;
        textColor = AppTheme.confirmedTextColor;
        break;
      case 'Pending':
        bgColor = AppTheme.pendingColor;
        textColor = AppTheme.pendingTextColor;
        break;
      default:
        bgColor = AppTheme.completedColor;
        textColor = AppTheme.completedTextColor;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bgColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.type,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appointment.doctor,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: textColor.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Text(
                "${appointment.date} at ${appointment.time}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactItem(EmergencyContact contact) {
    final bool isEmergency = contact.type == 'emergency';
    final Color bgColor = isEmergency ? AppTheme.redColor.withOpacity(0.1) : Colors.orange.shade50;
    final Color borderColor = isEmergency ? AppTheme.redColor.withOpacity(0.3) : Colors.orange.shade200;
    final Color textColor = isEmergency ? AppTheme.redColor : Colors.orange.shade900;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            contact.phoneNumber,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
