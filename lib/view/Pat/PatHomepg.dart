import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_connect/view/Pat/SettingsPat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controller/session.dart';
import '../firstpg.dart';
import 'Pt-HomeDoc.dart';
import 'TopDocs.dart';
import 'PatProfile.dart';
import 'PatAbout.dart';

class PatHomePg extends StatefulWidget {
  @override
  _PatHomePgState createState() => _PatHomePgState();
}

class _PatHomePgState extends State<PatHomePg> {
  int _currentIndex = 0;
  String userName = "User";
  String userPhone="";
  String? profileImageUrl;

  // List of screens for navigation
  final List<Widget> _screens = [
    HomeScreen(),      // Home screen
    TopDocs(),   // Doctors screen
    PatProfile(),   // Profile screen
  ];

  @override
  void initState() {
    super.initState();
    _getUserName(); // Call to fetch user data when the widget is initialized
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser; // Get current user

    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot['name'];
          userPhone=snapshot['phone'];
          profileImageUrl = snapshot['profileImage'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text("Welcome $userName",  style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  userPhone,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal.shade400,
                  child:profileImageUrl != null
                      ? ClipOval(
                    child: Image.network(
                      profileImageUrl!, // Use the fetched profile image URL
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  )
                      : Icon(Icons.person, size: 40, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildTile(
                    icon: Icons.settings, title: 'Settings',
                    color: Colors.teal.shade100,
                    iconColor: Colors.teal,  // Set the icon color to white
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPagePat()),
                      );
                    },
                  ),
                  _buildTile(
                    icon: Icons.report,
                    title: 'About us',
                    color: Colors.teal.shade100,
                    iconColor: Colors.teal,  // Set the icon color to white
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatAbout()),
                      );
                    },
                  ),
                  Divider(),
                  _buildTile(
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    color: Colors.red.shade500,
                    iconColor: Colors.white, // Set the icon color to white
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text('Do you really want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the alert dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Clear session and navigate to FirstPg
                                  SessionManager sessionManager = SessionManager();
                                  await sessionManager.clearSession();

                                  // Navigate to FirstPg after confirming logout
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => FirstPg()),
                                  );
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex], // Display the current screen based on selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.teal.shade700,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Doctors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, size: 30, color: iconColor),  // Set the color of the icon to white
          title: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

