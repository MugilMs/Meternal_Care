import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment.dart';
import '../theme/app_colors.dart';

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
        return const Color(0xFF10B981); // emerald-500
      case 'Pending':
        return const Color(0xFFF59E0B); // amber-500
      case 'Completed':
        return const Color(0xFF6366F1); // indigo-500
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusBackgroundColor() {
    switch (appointment.status) {
      case 'Confirmed':
        return const Color(0xFFECFDF5); // emerald-50
      case 'Pending':
        return const Color(0xFFFFFBEB); // amber-50
      case 'Completed':
        return const Color(0xFFEEF2FF); // indigo-50
      default:
        return AppColors.primary.withOpacity(0.1);
    }
  }

  Color _getCardGradientStart() {
    switch (appointment.status) {
      case 'Confirmed':
        return const Color(0xFFF0FDF4); // green-50
      case 'Pending':
        return const Color(0xFFFFFBEB); // amber-50
      case 'Completed':
        return const Color(0xFFEEF2FF); // indigo-50
      default:
        return Colors.white;
    }
  }

  Color _getCardGradientEnd() {
    return Colors.white;
  }

  IconData _getStatusIcon() {
    switch (appointment.status) {
      case 'Confirmed':
        return Icons.check_circle_outline;
      case 'Pending':
        return Icons.schedule;
      case 'Completed':
        return Icons.task_alt;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDate = DateFormat('yyyy-MM-dd').parse(appointment.date);
    String formattedDate = DateFormat('MMMM d, yyyy').format(appointmentDate);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_getCardGradientStart(), _getCardGradientEnd()],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _getStatusColor().withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      size: 20,
                      color: _getStatusColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.type,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            appointment.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Doctor and Specialty Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 18,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appointment.doctor,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            appointment.specialty,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$formattedDate at ${appointment.time}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appointment.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (appointment.status == 'Confirmed') ...[
                    OutlinedButton.icon(
                      onPressed: onReschedule,
                      icon: const Icon(Icons.edit_calendar, size: 16),
                      label: const Text('Reschedule'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getStatusColor(),
                        side: BorderSide(color: _getStatusColor().withOpacity(0.3)),
                        backgroundColor: _getStatusColor().withOpacity(0.05),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                        backgroundColor: AppColors.error.withOpacity(0.05),
                      ),
                    ),
                  ] else if (appointment.status == 'Pending') ...[
                    OutlinedButton.icon(
                      onPressed: onViewDetails,
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getStatusColor(),
                        side: BorderSide(color: _getStatusColor().withOpacity(0.3)),
                        backgroundColor: _getStatusColor().withOpacity(0.05),
                      ),
                    ),
                  ] else if (appointment.status == 'Completed') ...[
                    OutlinedButton.icon(
                      onPressed: onViewReport,
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text('View Report'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _getStatusColor(),
                        side: BorderSide(color: _getStatusColor().withOpacity(0.3)),
                        backgroundColor: _getStatusColor().withOpacity(0.05),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
