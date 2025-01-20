import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;  // Avoid storing plain-text passwords in production!
  final String specialization;
  final DateTime timestamp;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.specialization,
    required this.timestamp,
  });

  // Factory method to create a Doctor instance from Firestore data
  factory Doctor.fromFirestore(Map<String, dynamic> doc) {
    return Doctor(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      password: doc['password'] ?? '',
      specialization: doc['specialization'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert a Doctor instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'specialization': specialization,
      'timestamp': timestamp,
    };
  }
}
