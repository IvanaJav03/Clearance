import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nemsu_clearance/model/login_screen_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> loginUser(String input, String password) async {
    String result = 'Check User Credentials';
    try {
      String email;

      if (input.contains('@')) {
        email = input;
        if (!email.endsWith('@nemsu.edu.ph')) {
          return 'Only @nemsu.edu.ph emails are allowed';
        }
      } else {
        if (!_isValidStudentID(input)) {
          return 'Invalid student ID format';
        }

        final querySnapshot = await _firestore
            .collection('student')
            .where('studentId', isEqualTo: input)
            .get();

        if (querySnapshot.docs.isEmpty) {
          return 'No student found with the given ID.';
        }

        final studentDoc = querySnapshot.docs.first;
        Student student = Student.fromFirestore(studentDoc);
        email = student.email;

        if (!email.endsWith('@nemsu.edu.ph')) {
          return 'No valid email found for the given student ID.';
        }
      }

      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        User? user = _auth.currentUser;
        if (user == null) {
          return 'User not authenticated';
        }

        final studentDocSnapshot =
            await _firestore.collection('student').doc(user.uid).get();

        if (!studentDocSnapshot.exists) {
          return 'Not Allowed';
        }

        result = 'success';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          result = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          result = 'Wrong password provided.';
        } else {
          result = 'Authentication error: ${e.message}';
        }
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  bool _isValidStudentID(String input) {
    RegExp regex = RegExp(r'^\d{2}-\d{5}$');
    return regex.hasMatch(input);
  }
}
