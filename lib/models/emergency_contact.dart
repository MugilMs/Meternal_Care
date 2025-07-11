class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String type;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.type,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'type': type,
    };
  }
}
