class MyBookingModel{
  
}
class Booking {
  final String name;
  final String role;
  final String profileImageUrl;
  final DateTime appointmentDate;
  final String duration;
  final String status;
  final bool isAccepted;
  final String appointmentType; // New field

  Booking({
    required this.name,
    required this.role,
    required this.profileImageUrl,
    required this.appointmentDate,
    required this.duration,
    required this.status,
    required this.isAccepted,
    required this.appointmentType, // Initialize the new field
  });
}

