import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nemsu_clearance/view/screens/authentication screen/nav_screens/notification_page.dart';
import 'package:nemsu_clearance/view/screens/authentication screen/nav_screens/home_page.dart';
import 'package:nemsu_clearance/view/screens/authentication screen/nav_screens/settings_page.dart';
import 'package:nemsu_clearance/view/screens/authentication screen/nav_screens/profile_page.dart';
import 'package:nemsu_clearance/view/screens/authentication%20screen/nav_screens/message_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const MessageFormPage(),
    const NotificationPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      // When "Messages" is clicked, update unread messages to be read for the current user
      await _markMessagesAsRead();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _markMessagesAsRead() async {
    try {
      // Get the current user's UID
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      // Query unread messages where the current user is a participant
      QuerySnapshot unreadMessagesSnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .where('participants', arrayContains: currentUserUid)
          .where('isReadUser', isEqualTo: false)
          .get();

      // If there are any unread messages, update them
      if (unreadMessagesSnapshot.docs.isNotEmpty) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (var doc in unreadMessagesSnapshot.docs) {
          // Ensure the message is for the current user and update isReadUser to true
          batch.update(doc.reference, {'isReadUser': true});
        }

        // Commit the batch update
        await batch.commit();
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      print('Error updating messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.message, size: 28),
                Positioned(
                  right: -8,
                  top: -8,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .where('isReadUser', isEqualTo: false)
                        .where('participants',
                            arrayContains:
                                FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      final unreadCount = snapshot.data!.docs.length;
                      return Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            label: 'Messages',
          ),
          // Notification Tab with Badge for unread notifications
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications, size: 28),
                Positioned(
                  right: -8,
                  top: -8,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('activityLog')
                        .where('notifIsRead', isEqualTo: false)
                        .where('changeForUid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox();
                      }
                      final unreadNotifCount = snapshot.data!.docs.length;
                      return Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadNotifCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0300BF),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
