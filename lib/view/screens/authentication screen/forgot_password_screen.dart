import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nemsu_clearance/model/forgot_password_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordModel(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/y.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Consumer<ForgotPasswordModel>(
                  builder: (context, model, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/nem.png',
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          "North Eastern Mindanao State University",
                          style: GoogleFonts.lato(
                            color: const Color(0xFF0d120E),
                            fontWeight: FontWeight.normal,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Forgot Password",
                          style: GoogleFonts.lato(
                            color: const Color(0xFF0d120E),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: model.emailController,
                            decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 217, 231, 235),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              labelText: 'Enter your email',
                              labelStyle: GoogleFonts.nunitoSans(
                                fontSize: 14,
                                letterSpacing: 0.1,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 4, 0, 255),
                              ),
                              errorText: model.isEmailError
                                  ? model.emailErrorMessage
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: model.isLoading
                              ? null
                              : () => model.resetPassword(context),
                          child: Container(
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF102DE1),
                                  Color(0xCC0D6EFF),
                                ],
                              ),
                            ),
                            child: Center(
                              child: model.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Send Reset Email',
                                      style: GoogleFonts.lato(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back to Login',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF102DE1),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
