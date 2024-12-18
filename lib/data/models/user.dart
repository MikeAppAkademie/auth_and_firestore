import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final int age;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.age,
    this.createdAt,
  });

  // Factory-Methode für das Erstellen des UserModel aus Firestore
  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Zum Konvertieren des UserModel in ein Map-Format für Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }
}
