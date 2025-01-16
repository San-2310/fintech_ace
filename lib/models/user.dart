import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String language;
  final bool isBiometricEnabled;

  // Unnamed Constructor
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.language,
    this.isBiometricEnabled = false,
  });

  /// Converts a `User` object into a Firestore document (Map).
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'language': language,
      'isBiometricEnabled': isBiometricEnabled,
    };
  }

  /// Converts a Firestore document (Map) into a `User` object.
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id, // Use Firestore document ID as the user's ID
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      language: data['language'] ?? 'en', // Default language as 'en'
      isBiometricEnabled: data['isBiometricEnabled'] ?? false,
    );
  }

  /// Converts a `User` object into a JSON Map (for other uses like local storage).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'language': language,
      'isBiometricEnabled': isBiometricEnabled,
    };
  }

  /// Creates a `User` object from a JSON Map (for local storage).
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      language: json['language'] ?? 'en',
      isBiometricEnabled: json['isBiometricEnabled'] ?? false,
    );
  }
}
