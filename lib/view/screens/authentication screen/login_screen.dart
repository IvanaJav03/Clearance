import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nemsu_clearance/controllers/auth_controller.dart';
import 'package:nemsu_clearance/main_screen.dart';
import 'package:nemsu_clearance/view/screens/authentication screen/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  bool _isObscure = true;
  bool _isLoading = false;

  String emailOrStudentId = '';
  String password = '';

  loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String result =
          await _authController.loginUser(emailOrStudentId, password);

      if (result == 'success') {
        if (mounted) {
          final currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            final savedToken = await FirebaseMessaging.instance.getToken();
            print('Token: $savedToken');

            final timestamp = DateTime.now();

            await FirebaseFirestore.instance
                .collection('userToken')
                .doc(currentUser.uid)
                .set({
              'fcmToken': savedToken,
              'timestamp': timestamp,
            });

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are now logged in')),
            );
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/nem.png',
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      "North Eastern Mindanao State University",
                      style: GoogleFonts.getFont(
                        'Lato',
                        color: const Color(0xFF0d120E),
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Student Login",
                      style: GoogleFonts.getFont(
                        'Lato',
                        color: const Color(0xFF0d120E),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        onChanged: (value) {
                          emailOrStudentId = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email or student ID';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 217, 231, 235),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          labelText: 'Email or student ID',
                          labelStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 4, 0, 255),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: _isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 217, 231, 235),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          labelText: 'Password',
                          labelStyle: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 4, 0, 255),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: loginUser,
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
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.getFont('Lato',
                                      fontSize: 17, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot your password?',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF102DE1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
