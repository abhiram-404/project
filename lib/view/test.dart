import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_connect/view/Doc/Settings.dart';
import 'package:dr_connect/view/Doc/passwordchange.dart';
import 'package:dr_connect/view/Doc/profilepg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/session.dart';
import 'Doc/AboutUs.dart';
import 'Doc/logindoc.dart';


class Test {
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'email';

  // Save user ID and email
  Future<void> saveSession(String userId, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);
  }

  // Get user ID
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Get email
  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Clear session
  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
  }

  // Check if session exists
  Future<bool> hasSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userIdKey) && prefs.containsKey(_emailKey);
  }
}

class DocHomepg extends StatefulWidget {
  DocHomepg({Key? key}) : super(key: key);

  @override
  State<DocHomepg> createState() => _DocHomepgState();
}

class _DocHomepgState extends State<DocHomepg> {
  String username = 'Fetching...';
  String depart = 'Loading..';
  String? uid;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final sessionManager = Test();
    uid = await sessionManager.getUserId();
    email = await sessionManager.getEmail();

    if (uid != null && uid!.isNotEmpty) {
      fetchUserDetails(uid!);
    }
  }

  Future<void> fetchUserDetails(String uid) async {
    if (uid.isEmpty) return;

    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('doctors').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['name'] ?? 'No Name Available';
          depart = userDoc['specialization'] ?? 'No Department Available';
        });
      } else {
        setState(() {
          username = 'User Not Found';
          depart = 'Department Not Found';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error Fetching Name';
        depart = 'Error Fetching Department';
      });
      print('Error fetching user details: $e');
    }
  }

  Widget _buildTile({required IconData icon, required String title, required Color color, required Function onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      tileColor: color,
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedEmail = email ?? 'No Email Provided';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade500,
            Colors.blue.shade300,
            Colors.blue.shade100
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade500,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 28,
          ),
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'WELCOME',
                textStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                speed: Duration(milliseconds: 200),
              ),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    displayedEmail,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade400,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildTile(
                        icon: Icons.settings,
                        title: 'Settings',
                        color: Colors.blue.shade100,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settingspage()),
                          );
                        }),
                    _buildTile(
                      icon: Icons.report,
                      title: 'About us',
                      color: Colors.blue.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                    ),
                    _buildTile(
                      icon: Icons.lock_outlined,
                      title: 'Change password',
                      color: Colors.blue.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Password()),
                        );
                      },
                    ),
                    Divider(),
                    _buildTile(
                      icon: Icons.exit_to_app,
                      title: 'Logout',
                      color: Colors.red.shade500,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Logout'),
                              content:
                              const Text('Do you really want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the alert dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginDoc()),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + 12),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. $username",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              depart,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "IN",
                              style: TextStyle(
                                color: CupertinoColors.systemGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Location: Floor 3, Room 24',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Time In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Patient Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons.assignment_rounded,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Booking Details: Floor 2, Room 10',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
