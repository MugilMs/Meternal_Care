import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../theme/app_theme.dart';
import '../models/appointment.dart';
import 'add_appointment_screen.dart';
import '../widgets/appointment_card.dart';
import '../utils/ui_helpers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isExpanded = true;
  
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Map to store appointments by date
  Map<DateTime, List<Appointment>> _appointmentsByDate = {};
  
  // Current view mode
  String _currentView = 'calendar'; // 'calendar' or 'list'
  final List<Appointment> appointments = [
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
    ),
    Appointment(
      id: 3,
      date: "2024-03-08",
      time: "11:15 AM",
      doctor: "Dr. Emily Rodriguez",
      specialty: "Nutritionist",
      type: "Nutrition Consultation",
      status: "Completed",
      location: "Wellness Clinic"
    )
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _organizeAppointmentsByDate();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Start expanded
    _animationController.value = 1.0;
  }
  
  void _organizeAppointmentsByDate() {
    _appointmentsByDate = {};
    for (var appointment in appointments) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(appointment.date);
        final normalizedDate = DateTime(date.year, date.month, date.day);
        
        if (_appointmentsByDate[normalizedDate] == null) {
          _appointmentsByDate[normalizedDate] = [];
        }
        _appointmentsByDate[normalizedDate]!.add(appointment);
      } catch (e) {
        // Skip invalid dates
      }
    }
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    final normalizedDate = DateTime(day.year, day.month, day.day);
    return _appointmentsByDate[normalizedDate] ?? [];
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppHeader(
        title: "My Appointments",
        currentPage: "appointments",
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAppointmentScreen(
                onAppointmentAdded: (newAppointment) {
                  setState(() {
                    // Add the new appointment to the list
                    appointments.add(newAppointment);
                    // Sort appointments by date
                    appointments.sort((a, b) {
                      final aDate = DateTime.parse(a.date);
                      final bDate = DateTime.parse(b.date);
                      return aDate.compareTo(bDate);
                    });
                    // Update the appointment groups
                    _organizeAppointmentsByDate();
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab buttons for Calendar and List views
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentView = 'calendar';
                          if (!_isExpanded) {
                            _isExpanded = true;
                            _animationController.forward();
                          }
                        });
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text("Calendar View"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentView == 'calendar' ? AppTheme.primaryColor : Colors.grey[200],
                        foregroundColor: _currentView == 'calendar' ? Colors.white : AppTheme.textPrimaryColor,
                        elevation: _currentView == 'calendar' ? 2 : 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentView = 'list';
                        });
                      },
                      icon: const Icon(Icons.list),
                      label: const Text("List View"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentView == 'list' ? AppTheme.primaryColor : Colors.grey[200],
                        foregroundColor: _currentView == 'list' ? Colors.white : AppTheme.textPrimaryColor,
                        elevation: _currentView == 'list' ? 2 : 0,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Calendar header with month navigation and expand/collapse button
              if (_currentView == 'calendar') ...[              
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedDay),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month - 1,
                                  _focusedDay.day,
                                );
                              });
                            },
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month + 1,
                                  _focusedDay.day,
                                );
                              });
                            },
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                                if (_isExpanded) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }
                              });
                            },
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (_currentView == 'calendar') ...[              
                // Animated Calendar
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SizedBox(
                      height: _isExpanded ? null : 120 + 200 * _animation.value,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2023, 1, 1),
                            lastDay: DateTime.utc(2025, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            headerVisible: false, // We have our custom header
                            daysOfWeekHeight: 40,
                            rowHeight: 60,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              outsideDaysVisible: true,
                              markersMaxCount: 3,
                              markerDecoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                              ),
                              todayTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                              selectedDecoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: const TextStyle(color: AppTheme.accentColor),
                              outsideTextStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                final appointments = _getAppointmentsForDay(date);
                                if (appointments.isEmpty) return null;
                                
                                // Show different markers based on appointment types
                                return Positioned(
                                  bottom: 5,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: appointments.take(3).map((appointment) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 1),
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getAppointmentColor(appointment.type),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getAppointmentColor(appointment.type).withOpacity(0.5),
                                            blurRadius: 3,
                                            spreadRadius: 0.5,
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ),
                                );
                              },
                              todayBuilder: (context, day, focusedDay) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                                  ),
                                  child: Text(
                                    day.day.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                                  ),
                                );
                              },
                              selectedBuilder: (context, day, focusedDay) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryColor.withOpacity(0.5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    day.day.toString(),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                              headerTitleBuilder: (context, day) {
                                return Container(); // Empty since we have custom header
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              
              // List view for appointments
              if (_currentView == 'list') ...[              
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search appointments...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          UIHelpers.showWorkInProgressDialog(context);
                        },
                        icon: const Icon(Icons.filter_list),
                        label: const Text("Filter"),
                      ),
                    ],
                  ),
                ),
              ],
              
              
              if (_currentView == 'calendar') ...[              
                // Calendar Legend - more modern design
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Appointment Types",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildLegendItem("Regular Checkup", AppTheme.primaryColor),
                              _buildLegendItem("Ultrasound", AppTheme.accentColor),
                              _buildLegendItem("Nutrition", AppTheme.greenColor),
                              _buildLegendItem("Other", AppTheme.secondaryColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Selected Day Appointments - only show in calendar view
              if (_currentView == 'calendar' && _selectedDay != null) ...[  
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          DateFormat('MMM d').format(_selectedDay!),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Appointments",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSelectedDayAppointments(),
              ],
              
              const SizedBox(height: 16),
              
              // Add Appointment Button - floating action button style
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    UIHelpers.showWorkInProgressDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Schedule New Appointment"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              // Appointments List - show full list in list view, or just upcoming in calendar view
              Container(
                height: 300, // Fixed height for the list
                child: _currentView == 'list' 
                  ? (appointments.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return AppointmentCard(
                              appointment: appointment,
                              onReschedule: appointment.status == 'Confirmed'
                                  ? () {
                                      UIHelpers.showWorkInProgressDialog(context);
                                    }
                                  : null,
                              onCancel: appointment.status == 'Confirmed'
                                  ? () {
                                      UIHelpers.showWorkInProgressDialog(context);
                                    }
                                  : null,
                              onViewDetails: appointment.status == 'Pending'
                                  ? () {
                                      UIHelpers.showWorkInProgressDialog(context);
                                    }
                                  : null,
                              onViewReport: appointment.status == 'Completed'
                                  ? () {
                                      UIHelpers.showWorkInProgressDialog(context);
                                    }
                                  : null,
                            );
                          },
                        ))
                  : (_selectedDay == null
                      ? ListView(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              "Upcoming Appointments",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...appointments
                              .where((a) => a.status != 'Completed')
                              .take(3)
                              .map((appointment) => AppointmentCard(
                                appointment: appointment,
                                onReschedule: appointment.status == 'Confirmed'
                                    ? () {
                                        UIHelpers.showWorkInProgressDialog(context);
                                      }
                                    : null,
                                onCancel: appointment.status == 'Confirmed'
                                    ? () {
                                        UIHelpers.showWorkInProgressDialog(context);
                                      }
                                    : null,
                                onViewDetails: appointment.status == 'Pending'
                                    ? () {
                                        UIHelpers.showWorkInProgressDialog(context);
                                      }
                                    : null,
                                onViewReport: appointment.status == 'Completed'
                                    ? () {
                                        UIHelpers.showWorkInProgressDialog(context);
                                      }
                                    : null,
                              ))
                              .toList(),
                          ],
                        )
                      : Container()),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "No appointments scheduled",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Schedule your first appointment to get started",
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              UIHelpers.showWorkInProgressDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Schedule Appointment"),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectedDayAppointments() {
    final dayAppointments = _getAppointmentsForDay(_selectedDay!);
    
    if (dayAppointments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.event_busy,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              const Text(
                "No appointments for this day",
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: dayAppointments.map((appointment) => AppointmentCard(
        appointment: appointment,
        onReschedule: appointment.status == 'Confirmed'
            ? () {
                UIHelpers.showWorkInProgressDialog(context);
              }
            : null,
        onCancel: appointment.status == 'Confirmed'
            ? () {
                UIHelpers.showWorkInProgressDialog(context);
              }
            : null,
        onViewDetails: appointment.status == 'Pending'
            ? () {
                UIHelpers.showWorkInProgressDialog(context);
              }
            : null,
        onViewReport: appointment.status == 'Completed'
            ? () {
                UIHelpers.showWorkInProgressDialog(context);
              }
            : null,
      )).toList(),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 2,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getAppointmentColor(String appointmentType) {
    switch (appointmentType) {
      case 'Regular Checkup':
        return AppTheme.primaryColor;
      case 'Ultrasound':
        return AppTheme.accentColor;
      case 'Nutrition Consultation':
        return AppTheme.greenColor;
      default:
        return AppTheme.secondaryColor;
    }
  }
}
