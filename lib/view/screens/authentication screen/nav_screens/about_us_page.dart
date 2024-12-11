import 'package:flutter/material.dart';
import 'team_member.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  final List<TeamMember> teamMembers;

  const AboutUsPage({super.key, required this.teamMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/heead.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Text(
                        'About Us',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'The People Behind the App',
                    style: GoogleFonts.openSans(
                      color: const Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'S.Y. 2024-2025',
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF0d120E),
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.3,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                const TeamLeaderWidget(
                  name: 'Michael L. Estal, MSCS',
                  name2: 'Instructor III',
                  imagePath: 'assets/images/estal.jpg',
                ),
                const SizedBox(height: 25.0),
                ...teamMembers.map((member) {
                  return TeamMemberWidget(
                    name: member.name,
                    name2: member.name2,
                    imagePath: member.imagePath,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamLeaderWidget extends StatelessWidget {
  final String name;
  final String name2;
  final String imagePath;

  const TeamLeaderWidget(
      {super.key,
      required this.name,
      required this.name2,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 8.0),
        Text(
          name,
          style: GoogleFonts.poppins(
            color: const Color(0xFF0d120E),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
            fontSize: 19,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name2,
          style: GoogleFonts.poppins(
            color: const Color(0xFF0d120E),
            fontWeight: FontWeight.normal,
            letterSpacing: 0.2,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class TeamMemberWidget extends StatelessWidget {
  final String name;
  final String name2;
  final String imagePath;

  const TeamMemberWidget(
      {super.key,
      required this.name,
      required this.name2,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style:
                GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          Text(
            name2,
            style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
