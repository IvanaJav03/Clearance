import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String email;

  Student({required this.id, required this.email});

  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      email: data['email'] ?? '',
    );
  }
}
