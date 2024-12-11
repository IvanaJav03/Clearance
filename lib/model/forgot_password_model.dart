import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nemsu_clearance/data/global_key.dart';

class ForgotPasswordModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool isEmailError = false;
  String emailErrorMessage = '';

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@nemsu.edu.ph$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> resetPassword(BuildContext context) async {
    isEmailError = false;
    emailErrorMessage = '';

    void showSnackbar(String message) {
      scaffoldMessengerKey.currentState
          ?.showSnackBar(SnackBar(content: Text(message)));
    }

    if (!_isValidEmail(emailController.text)) {
      isEmailError = true;
      emailErrorMessage =
          "Please enter a valid NEMSU email (example@nemsu.edu.ph).";
      showSnackbar(emailErrorMessage);
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      showSnackbar("Password reset link sent! Check your email.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        isEmailError = true;
        emailErrorMessage = "No account found with this email.";
        showSnackbar(emailErrorMessage);
      } else {
        showSnackbar("An error occurred. Please try again.");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
