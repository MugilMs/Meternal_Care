import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Function()? onReschedule;
  final Function()? onCancel;
  final Function()? onViewDetails;
  final Function()? onViewReport;
  
  const AppointmentCard({
    Key? key,
    required this.appointment,
    this.onReschedule,
    this.onCancel,
    this.onViewDetails,
    this.onViewReport,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'Confirmed':
        return AppTheme.confirmedColor;
      case 'Pending':
        return AppTheme.pendingColor;
      case 'Completed':
        return AppTheme.completedColor;
      default:
        return AppTheme.completedColor;
    }
  }

  Color _getStatusTextColor() {
    switch (appointment.status) {
      case 'Confirmed':
        return AppTheme.confirmedTextColor;
      case 'Pending':
        return AppTheme.pendingTextColor;
      case 'Completed':
        return AppTheme.completedTextColor;
      default:
        return AppTheme.completedTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(appointment.date);
    String formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate);
    
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
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusTextColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.doctor,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '•',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  appointment.specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '$formattedDate at ${appointment.time}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (appointment.status == 'Confirmed') ...[
                  OutlinedButton(
                    onPressed: onReschedule,
                    child: const Text('Reschedule'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.redColor,
                      side: const BorderSide(color: Color(0xFFFFE4E6)), // red-100
                    ),
                    child: const Text('Cancel'),
                  ),
                ] else if (appointment.status == 'Pending') ...[
                  OutlinedButton(
                    onPressed: onViewDetails,
                    child: const Text('View Details'),
                  ),
                ] else if (appointment.status == 'Completed') ...[
                  OutlinedButton(
                    onPressed: onViewReport,
                    child: const Text('View Report'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
