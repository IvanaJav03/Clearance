import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about_us_page.dart';
import 'team_member.dart';
import 'package:nemsu_clearance/view/screens/authentication%20screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TeamMember> teamMembers = [
      TeamMember(
        name: 'Abiera, Vincent',
        name2: 'Asset, Honorable',
        imagePath: 'assets/banner/Abiera.jpeg',
      ),
      TeamMember(
        name: 'Acita, Jolly Mae D. ',
        name2: 'Researcher  ',
        imagePath: 'assets/banner/Acita.png',
      ),
      TeamMember(
        name: 'Alameda, Atrio R.',
        name2: 'Hacker',
        imagePath: '',
      ),
      TeamMember(
        name: 'Balagulan, Sarah Mae R. ',
        name2: 'Hustler',
        imagePath: '',
      ),
      TeamMember(
        name: 'Balili, Ma. Via Angelica E. ',
        name2: 'Researcher ',
        imagePath: '',
      ),
      TeamMember(
        name: 'Barrot, Ailyn G. ',
        name2: 'Researcher',
        imagePath: 'assets/banner/Barrot.jpeg',
      ),
      TeamMember(
        name: 'Bernadas, Jan Jerwin P.',
        name2: 'Hustler',
        imagePath: '',
      ),
      TeamMember(
        name: 'Calderon, Chilber John Q.',
        name2: 'Hacker',
        imagePath: '',
      ),
      TeamMember(
        name: 'Day, Rollyvic M. ',
        name2: 'Hacker',
        imagePath: 'assets/banner/Day.jpeg',
      ),
      TeamMember(
        name: 'Dedicatoria, Joven I. ',
        name2: 'Hustler',
        imagePath: '',
      ),
      TeamMember(
        name: 'Dumanig, Carlwin A. ',
        name2: 'Hustler',
        imagePath: 'assets/banner/Dumanig.jpeg',
      ),
      TeamMember(
        name: 'Enderez, Juhnajane P. ',
        name2: 'Hacker, Hipster',
        imagePath: 'assets/banner/enderez.jpg',
      ),
      TeamMember(
        name: 'Frias, Jobert G. ',
        name2: 'Tester',
        imagePath: 'assets/banner/Frias.jpeg',
      ),
      TeamMember(
        name: 'Gier, Carl Michael P.',
        name2: 'Hustler',
        imagePath: '',
      ),
      TeamMember(
        name: 'Javier, Rodin Van Moore D. ',
        name2: 'Shy Type,Maginoo Pero Medyo Bastos ',
        imagePath: 'assets/banner/javier.jpg',
      ),
      TeamMember(
        name: 'Otero, Dave C.',
        name2: 'Tester',
        imagePath: 'assets/banner/Oteroo.jpeg',
      ),
      TeamMember(
        name: 'Pasaporte, Christine Joy B. ',
        name2: 'Hacker, Hipster',
        imagePath: 'assets/banner/Pasaporte.jpeg',
      ),
      TeamMember(
        name: 'Pazo, Wawie G. ',
        name2: 'Hacker',
        imagePath: '',
      ),
      TeamMember(
        name: 'Planas, Faustine Frichot G. ',
        name2: 'Hacker',
        imagePath: 'assets/banner/Planas.jpeg',
      ),
      TeamMember(
        name: 'Rugay, Chrisel Jay C. ',
        name2: 'Tester ',
        imagePath: '',
      ),
      TeamMember(
        name: 'Taripe, Go Primo Victorino R.',
        name2: 'Hacker',
        imagePath: '',
      ),
      TeamMember(
        name: 'Tinunga, Angelyn C. ',
        name2: 'Hustler ',
        imagePath: 'assets/banner/Tinunga.png',
      ),
      TeamMember(
        name: 'Trinidad, Joyce D.',
        name2: 'Tester ',
        imagePath: '',
      ),
    ];

    final updatedTeamMembers = teamMembers.map((member) {
      return TeamMember(
        name: member.name,
        name2: member.name2,
        imagePath: member.imagePath.isEmpty
            ? 'assets/images/NEMSU.png'
            : member.imagePath,
      );
    }).toList();

    Future<void> changePassword(BuildContext context) async {
      final TextEditingController newPasswordController =
          TextEditingController();
      final TextEditingController confirmPasswordController =
          TextEditingController();

      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change Password',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword =
                              confirmPasswordController.text.trim();

                          if (newPassword.isEmpty || confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fields cannot be empty'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          try {
                            User? user = FirebaseAuth.instance.currentUser;
                            await user?.updatePassword(newPassword);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update password: $e'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/heed.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Change Password'),
            onTap: () => changePassword(context),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AboutUsPage(teamMembers: updatedTeamMembers),
                ),
              );
            },
          ),
          const Divider(
            height: 30,
            thickness: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
