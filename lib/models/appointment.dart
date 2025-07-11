class Appointment {
  final int id;
  final String date;
  final String time;
  final String doctor;
  final String specialty;
  final String type;
  final String status;
  final String location;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.doctor,
    required this.specialty,
    required this.type,
    required this.status,
    required this.location,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      doctor: json['doctor'],
      specialty: json['specialty'],
      type: json['type'],
      status: json['status'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'doctor': doctor,
      'specialty': specialty,
      'type': type,
      'status': status,
      'location': location,
    };
  }
}
